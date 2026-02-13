const std = @import("std");
const builtin = @import("builtin");
const idf = @import("esp_idf");
const sys = idf.sys;

const tag = "zig-wifi";
const log = std.log.scoped(.@"esp-idf");

const MAX_RETRY_ATTEMPTS = 5;
const WIFI_CONNECT_TIMEOUT_MS = std.time.ms_per_s * 30; // 30 seconds

const WifiBits = struct {
    const CONNECTED: u32 = sys.WIFI_CONNECTED_BIT;
    const FAILED: u32 = sys.WIFI_FAIL_BIT;
};

const WifiContext = struct {
    allocator: std.mem.Allocator,
    event_group: sys.EventGroupHandle_t,
    retry_count: u32,

    fn init(allocator: std.mem.Allocator) !WifiContext {
        const event_group = sys.xEventGroupCreate() orelse return error.EventGroupCreateFailed;

        return WifiContext{
            .allocator = allocator,
            .event_group = event_group,
            .retry_count = 0,
        };
    }

    fn deinit(self: *WifiContext) void {
        if (self.event_group) |group| {
            sys.vEventGroupDelete(group);
        }
    }
};

var wifi_context: ?*WifiContext = null;

export fn app_main() callconv(.c) void {
    const heap = std.heap.c_allocator;
    var arena = std.heap.ArenaAllocator.init(heap);
    defer {
        log.info("Shutting down arena allocator", .{});
        arena.deinit();
    }
    const allocator = arena.allocator();

    // Initialize NVS (Non-Volatile Storage)
    initNvs() catch |err| {
        log.err("NVS initialization failed: {}", .{err});
        return;
    };

    log.info("Starting WiFi in station mode", .{});

    wifiInitStation(allocator) catch |err| {
        log.err("WiFi initialization failed: {}", .{err});
        return;
    };

    log.info("WiFi initialization complete", .{});
}

/// Initialize Non-Volatile Storage
fn initNvs() !void {
    var ret = sys.nvs_flash_init();

    if (ret == sys.ESP_ERR_NVS_NO_FREE_PAGES or ret == sys.ESP_ERR_NVS_NEW_VERSION_FOUND) {
        try idf.err.espCheckError(sys.nvs_flash_erase());
        ret = sys.nvs_flash_init();
    }

    try idf.err.espCheckError(ret);
}

/// Format IP address to string (allocates)
fn ipToString(allocator: std.mem.Allocator, ip: u32) ![]const u8 {
    return std.fmt.allocPrint(allocator, "{d}.{d}.{d}.{d}", .{
        @as(u8, @intCast(ip & 0xFF)),
        @as(u8, @intCast((ip >> 8) & 0xFF)),
        @as(u8, @intCast((ip >> 16) & 0xFF)),
        @as(u8, @intCast((ip >> 24) & 0xFF)),
    });
}

fn copyStringToArray(dest: []u8, src: []const u8) void {
    const len = @min(dest.len - 1, src.len);
    @memcpy(dest[0..len], src[0..len]);
    dest[len] = 0;
}

/// WiFi event handler callback
export fn wifiEventHandler(
    _: ?*anyopaque,
    event_base: sys.esp_event_base_t,
    event_id: i32,
    event_data: ?*anyopaque,
) callconv(.c) void {
    const ctx = wifi_context orelse {
        log.warn("Event handler called with null context", .{});
        return;
    };

    if (event_base == sys.WIFI_EVENT) {
        handleWifiEvent(ctx, event_id) catch |err| {
            log.err("Error handling WiFi event: {}", .{err});
        };
    } else if (event_base == sys.IP_EVENT) {
        handleIpEvent(ctx, event_id, event_data) catch |err| {
            log.err("Error handling IP event: {}", .{err});
        };
    }
}

/// Handle WiFi-specific events
fn handleWifiEvent(ctx: *WifiContext, event_id: i32) !void {
    switch (event_id) {
        sys.WIFI_EVENT_STA_START => {
            log.info("WiFi started, connecting to AP...", .{});
            try idf.wifi.connect();
        },
        sys.WIFI_EVENT_STA_DISCONNECTED => {
            if (ctx.retry_count < MAX_RETRY_ATTEMPTS) {
                ctx.retry_count += 1;
                log.warn("Disconnected, retrying... (attempt {}/{})", .{ ctx.retry_count, MAX_RETRY_ATTEMPTS });
                try idf.wifi.connect();
            } else {
                log.err("Failed to connect after {} attempts", .{MAX_RETRY_ATTEMPTS});
                _ = sys.xEventGroupSetBits(ctx.event_group, WifiBits.FAILED);
            }
        },
        else => {
            log.debug("Unhandled WiFi event: {}", .{event_id});
        },
    }
}

/// Handle IP-specific events
fn handleIpEvent(ctx: *WifiContext, event_id: i32, event_data: ?*anyopaque) !void {
    switch (event_id) {
        sys.IP_EVENT_STA_GOT_IP => {
            const event = @as(*sys.ip_event_got_ip_t, @ptrCast(@alignCast(event_data)));
            const ip_str = try ipToString(ctx.allocator, event.ip_info.ip.addr);
            defer ctx.allocator.free(ip_str);

            log.info("Connected! IP address: {s}", .{ip_str});
            ctx.retry_count = 0;
            _ = sys.xEventGroupSetBits(ctx.event_group, WifiBits.CONNECTED);
        },
        else => {
            log.debug("Unhandled IP event: {}", .{event_id});
        },
    }
}

/// Register event handlers for WiFi and IP events
fn registerEventHandlers() !void {
    var instance_wifi: sys.esp_event_handler_instance_t = undefined;
    var instance_ip: sys.esp_event_handler_instance_t = undefined;

    // Register handler for all WiFi events
    try idf.err.espCheckError(sys.esp_event_handler_instance_register(
        sys.WIFI_EVENT,
        sys.ESP_EVENT_ANY_ID,
        &wifiEventHandler,
        null,
        &instance_wifi,
    ));

    // Register handler for IP events
    try idf.err.espCheckError(sys.esp_event_handler_instance_register(
        sys.IP_EVENT,
        sys.IP_EVENT_STA_GOT_IP,
        &wifiEventHandler,
        null,
        &instance_ip,
    ));
}

/// Create WiFi configuration from SDK config
fn createWifiConfig() idf.wifi.wifiConfig {
    const ssid = sys.CONFIG_ESP_WIFI_SSID;
    const password = sys.CONFIG_ESP_WIFI_PASSWORD;
    const sae_h2e_id = sys.CONFIG_ESP_WIFI_PW_ID;

    var config = idf.wifi.wifiConfig{
        .sta = .{
            .ssid = std.mem.zeroes([32]u8),
            .password = std.mem.zeroes([64]u8),
            .threshold = .{ .authmode = sys.WIFI_AUTH_WPA2_PSK },
            .sae_pwe_h2e = sys.WPA3_SAE_PWE_BOTH,
            .sae_h2e_identifier = std.mem.zeroes([32]u8),
        },
    };

    copyStringToArray(&config.sta.ssid, ssid);
    copyStringToArray(&config.sta.password, password);
    copyStringToArray(&config.sta.sae_h2e_identifier, sae_h2e_id);

    return config;
}

/// Initialize WiFi in station mode
fn wifiInitStation(allocator: std.mem.Allocator) !void {
    // Create and initialize context
    var ctx = try WifiContext.init(allocator);
    defer ctx.deinit();
    wifi_context = &ctx;

    // Initialize network interface
    try idf.err.espCheckError(sys.esp_netif_init());
    try idf.err.espCheckError(sys.esp_event_loop_create_default());
    _ = sys.esp_netif_create_default_wifi_sta();

    // Initialize WiFi driver
    var wifi_init_cfg = idf.wifi.init_config_default();
    log.debug("WiFi init config magic: 0x{x}", .{wifi_init_cfg.magic});
    try idf.err.espCheckError(sys.esp_wifi_init(&wifi_init_cfg));

    // Register event handlers
    try registerEventHandlers();

    // Configure and start WiFi
    const wifi_config = createWifiConfig();
    try idf.wifi.setMode(.WIFI_MODE_STA);
    try idf.wifi.setConfig(.WIFI_IF_STA, @constCast(&wifi_config));
    try idf.wifi.start();

    log.info("WiFi initialization complete, waiting for connection...", .{});

    // Wait for connection or failure
    const bits = sys.xEventGroupWaitBits(
        ctx.event_group,
        WifiBits.CONNECTED | WifiBits.FAILED,
        0, // don't clear bits on exit
        0, // wait for any bit (OR)
        sys.portMAX_DELAY,
    );

    // Check connection result
    if ((bits & WifiBits.CONNECTED) != 0) {
        log.info("Successfully connected to SSID: {s}", .{sys.CONFIG_ESP_WIFI_SSID});
    } else if ((bits & WifiBits.FAILED) != 0) {
        log.err("Failed to connect to SSID: {s}", .{sys.CONFIG_ESP_WIFI_SSID});
        return error.WifiConnectionFailed;
    } else {
        log.err("Unexpected WiFi event bits: 0x{x}", .{bits});
        return error.UnexpectedEvent;
    }
}

// Override std panic with ESP-IDF panic handler
pub const panic = idf.esp_panic.panic;

// Configure logging
pub const std_options: std.Options = .{
    .log_level = switch (builtin.mode) {
        .Debug => .debug,
        else => .info,
    },
    .logFn = idf.log.espLogFn,
};
