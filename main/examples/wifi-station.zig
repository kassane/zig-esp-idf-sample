const std = @import("std");
const builtin = @import("builtin");
const idf = @import("esp_idf");
const sys = idf.sys;

const log = std.log.scoped(.wifi);

const MAX_RETRY_ATTEMPTS = 5;

// Event-group bits
const CONNECTED_BIT: u32 = sys.WIFI_CONNECTED_BIT;
const FAILED_BIT: u32 = sys.WIFI_FAIL_BIT;

// Module-level state shared with callbacks
var g_event_group: sys.EventGroupHandle_t = null;
var g_retry_count: u32 = 0;

export fn app_main() callconv(.c) void {
    var heap = idf.heap.HeapCapsAllocator.init(.{ .@"8bit" = true });
    var arena = std.heap.ArenaAllocator.init(heap.allocator());
    defer arena.deinit();
    const allocator = arena.allocator();
    _ = allocator;

    // NVS — required by WiFi driver to store calibration data.
    idf.nvs.flashInitOrErase() catch |err| {
        log.err("NVS init failed: {s}", .{@errorName(err)});
        return;
    };

    wifiStation() catch |err| {
        log.err("WiFi station failed: {s}", .{@errorName(err)});
    };
}

fn wifiStation() !void {
    // Create the event group used by the callbacks.
    g_event_group = sys.xEventGroupCreate() orelse return error.EventGroupCreateFailed;
    defer sys.vEventGroupDelete(g_event_group);

    // Network interface + default event loop
    try idf.err.espCheckError(sys.esp_netif_init());
    try idf.event.loopCreateDefault();
    _ = sys.esp_netif_create_default_wifi_sta();

    // WiFi driver init
    var wifi_init_cfg = idf.wifi.init_config_default();
    try idf.err.espCheckError(sys.esp_wifi_init(&wifi_init_cfg));

    // Register event handlers (new wrapper API)
    const inst_wifi = try idf.event.handlerInstanceRegister(sys.WIFI_EVENT, idf.event.ANY_ID, &onWifiEvent, null);
    defer idf.event.handlerInstanceUnregister(sys.WIFI_EVENT, idf.event.ANY_ID, inst_wifi) catch {};

    const inst_ip = try idf.event.handlerInstanceRegister(sys.IP_EVENT, sys.IP_EVENT_STA_GOT_IP, &onIpEvent, null);
    defer idf.event.handlerInstanceUnregister(sys.IP_EVENT, sys.IP_EVENT_STA_GOT_IP, inst_ip) catch {};

    // Build WiFi STA config from sdkconfig values
    var wifi_config = idf.wifi.wifiConfig{
        .sta = .{
            .ssid = std.mem.zeroes([32]u8),
            .password = std.mem.zeroes([64]u8),
            .threshold = .{ .authmode = sys.WIFI_AUTH_WPA2_PSK },
            .sae_pwe_h2e = sys.WPA3_SAE_PWE_BOTH,
            .sae_h2e_identifier = std.mem.zeroes([32]u8),
        },
    };
    copyZ(&wifi_config.sta.ssid, sys.CONFIG_ESP_WIFI_SSID);
    copyZ(&wifi_config.sta.password, sys.CONFIG_ESP_WIFI_PASSWORD);

    try idf.wifi.setMode(.WIFI_MODE_STA);
    try idf.wifi.setConfig(.WIFI_IF_STA, &wifi_config);
    try idf.wifi.start();

    log.info("WiFi station started, connecting to \"{s}\"...", .{sys.CONFIG_ESP_WIFI_SSID});

    // Block until connected or exhausted retries
    const bits = sys.xEventGroupWaitBits(
        g_event_group,
        CONNECTED_BIT | FAILED_BIT,
        0,
        0,
        sys.portMAX_DELAY,
    );

    if ((bits & CONNECTED_BIT) != 0) {
        log.info("Connected to SSID: {s}", .{sys.CONFIG_ESP_WIFI_SSID});
    } else {
        log.err("Failed to connect to SSID: {s} after {} attempts", .{ sys.CONFIG_ESP_WIFI_SSID, MAX_RETRY_ATTEMPTS });
        return error.WifiConnectionFailed;
    }
}

export fn onWifiEvent(
    _: ?*anyopaque,
    event_base: sys.esp_event_base_t,
    event_id: i32,
    _: ?*anyopaque,
) callconv(.c) void {
    _ = event_base;
    switch (event_id) {
        sys.WIFI_EVENT_STA_START => {
            log.info("STA started, connecting...", .{});
            idf.wifi.connect() catch |err|
                log.err("connect() failed: {s}", .{@errorName(err)});
        },
        sys.WIFI_EVENT_STA_DISCONNECTED => {
            if (g_retry_count < MAX_RETRY_ATTEMPTS) {
                g_retry_count += 1;
                log.warn("Disconnected, retry {}/{}", .{ g_retry_count, MAX_RETRY_ATTEMPTS });
                idf.wifi.connect() catch {};
            } else {
                _ = sys.xEventGroupSetBits(g_event_group, FAILED_BIT);
            }
        },
        else => {},
    }
}

export fn onIpEvent(
    _: ?*anyopaque,
    _: sys.esp_event_base_t,
    event_id: i32,
    event_data: ?*anyopaque,
) callconv(.c) void {
    if (event_id == sys.IP_EVENT_STA_GOT_IP) {
        const ev = @as(*sys.ip_event_got_ip_t, @ptrCast(@alignCast(event_data)));
        const ip = ev.ip_info.ip.addr;
        log.info("Got IP: {}.{}.{}.{}", .{
            @as(u8, @truncate(ip)),
            @as(u8, @truncate(ip >> 8)),
            @as(u8, @truncate(ip >> 16)),
            @as(u8, @truncate(ip >> 24)),
        });
        g_retry_count = 0;
        _ = sys.xEventGroupSetBits(g_event_group, CONNECTED_BIT);
    }
}

fn copyZ(dest: []u8, src: []const u8) void {
    const n = @min(dest.len - 1, src.len);
    @memcpy(dest[0..n], src[0..n]);
    dest[n] = 0;
}

pub const panic = idf.esp_panic.panic;
pub const std_options: std.Options = .{
    .log_level = switch (builtin.mode) {
        .Debug => .debug,
        else => .info,
    },
    .logFn = idf.log.espLogFn,
};
