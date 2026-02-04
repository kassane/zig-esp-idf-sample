const std = @import("std");
const builtin = @import("builtin");
const idf = @import("esp_idf");

const mem = std.mem;

// Globals
var global_allocator: ?std.mem.Allocator = null;
var s_retry_num: i32 = 0;
var s_wifi_event_group: ?*anyopaque = null;
const tag = "zig-example";

export fn app_main() callconv(.C) void {
    const heap = std.heap.raw_c_allocator;
    var arena = std.heap.ArenaAllocator.init(heap);
    defer {
        idf.log.ESP_LOG(global_allocator.?, tag, "ARENA DEINIT();\n", .{});
        arena.deinit();
    }
    global_allocator = arena.allocator();

    // Initalize NVS
    var ret = idf.sys.nvs_flash_init();
    if (ret == idf.sys.ESP_ERR_NVS_NO_FREE_PAGES or ret == idf.sys.ESP_ERR_NVS_NEW_VERSION_FOUND) {
        idf.err.espCheckError(idf.sys.nvs_flash_erase()) catch {};
        ret = idf.sys.nvs_flash_init();
    }
    idf.err.espCheckError(ret) catch {};

    idf.log.ESP_LOG(global_allocator.?, tag, "ESP_WIFI_MODE_STA\n", .{});

    wifi_init_sta(global_allocator.?);
}

// override the std panic function with idf.panic
pub const panic = idf.esp_panic.panic;
const log = std.log.scoped(.@"esp-idf");
pub const std_options: std.Options = .{
    .log_level = switch (builtin.mode) {
        .Debug => .debug,
        else => .info,
    },
    // Define logFn to override the std implementation
    .logFn = idf.log.espLogFn,
};

fn ip_to_str(ip: u32) []u8 {
    var addr: [16]u8 = [_]u8{0} ** 16; // Buffer to store the formatted string

    return std.fmt.bufPrint(&addr, "{d}.{d}.{d}.{d}", .{
        @as(u8, @intCast(ip & 0xFF)), // Byte 1
        @as(u8, @intCast((ip >> 8) & 0xFF)), // Byte 2
        @as(u8, @intCast((ip >> 16) & 0xFF)), // Byte 3
        @as(u8, @intCast((ip >> 24) & 0xFF)), // Byte 4
    }) catch "";
}

export fn event_handler(
    _: ?*anyopaque,
    event_base: idf.sys.esp_event_base_t,
    event_id: i32,
    event_data: ?*anyopaque,
) callconv(.C) void {
    if (global_allocator) |allocator| {
        if (event_base == idf.sys.WIFI_EVENT) {
            //const event_type = @as(idf.sys.wifi_event_t, @enumFromInt(@as(c_uint, @intCast(event_id))));

            if (event_id == idf.sys.WIFI_EVENT_STA_START) {
                idf.wifi.connect() catch {};
            } else if (event_id == idf.sys.WIFI_EVENT_STA_DISCONNECTED) {
                if (s_retry_num < 5) {
                    idf.wifi.connect() catch {
                        s_retry_num += 1;
                    };
                    idf.log.ESP_LOG(allocator, tag, "retry to connect to the AP\n", .{});
                } else {
                    _ = idf.sys.xEventGroupSetBits(@as(idf.sys.EventGroupHandle_t, @ptrCast(s_wifi_event_group)), idf.sys.WIFI_FAIL_BIT);
                }
                idf.log.ESP_LOG(allocator, tag, "connect to the AP fail\n", .{});
            }
        } else if (event_base == idf.sys.IP_EVENT) {
            //const event_type = @as(idf.sys.ip_event_t, @enumFromInt(@as(c_uint, @intCast(event_id))));

            if (event_id == idf.sys.IP_EVENT_STA_GOT_IP) {
                const event: *idf.sys.ip_event_got_ip_t = @ptrCast(@alignCast(event_data));
                idf.log.ESP_LOG(allocator, tag, "got ip: {s}\n", .{ip_to_str(event.ip_info.ip.addr)});
                s_retry_num = 0;
                _ = idf.sys.xEventGroupSetBits(@as(idf.sys.EventGroupHandle_t, @ptrCast(s_wifi_event_group)), idf.sys.WIFI_CONNECTED_BIT);
            }
        }
    }
}

fn wifi_init_sta(allocator: std.mem.Allocator) void {
    s_wifi_event_group = idf.sys.xEventGroupCreate();

    idf.err.espCheckError(idf.sys.esp_netif_init()) catch {};

    idf.err.espCheckError(idf.sys.esp_event_loop_create_default()) catch {};
    _ = idf.sys.esp_netif_create_default_wifi_sta();

    // TODO: Some of these come from the sdkconfig, how to parse in?
    var cfg = idf.wifi.init_config_default();
    idf.log.ESP_LOG(allocator, tag, "WiFi Init Magic: 0x{x}\n", .{cfg.magic});
    idf.err.espCheckError(idf.sys.esp_wifi_init(&cfg)) catch {
        idf.log.ESP_LOG(allocator, tag, "WiFi init failed", .{});
    };

    var instance_any_id: idf.sys.esp_event_handler_instance_t = undefined;
    var instance_got_ip: idf.sys.esp_event_handler_instance_t = undefined;

    idf.err.espCheckError(idf.sys.esp_event_handler_instance_register(
        idf.sys.WIFI_EVENT,
        -1,
        &event_handler,
        null,
        &instance_any_id,
    )) catch {};
    idf.err.espCheckError(idf.sys.esp_event_handler_instance_register(
        idf.sys.WIFI_EVENT,
        idf.sys.IP_EVENT_STA_GOT_IP,
        &event_handler,
        null,
        &instance_got_ip,
    )) catch {};

    var wifi_config = idf.wifi.wifiConfig{
        .sta = .{
            .ssid = mem.zeroes([32]u8),
            .password = mem.zeroes([64]u8),
            .threshold = .{ .authmode = idf.sys.WIFI_AUTH_WPA2_PSK },
            .sae_pwe_h2e = idf.sys.WPA3_SAE_PWE_BOTH,
            .sae_h2e_identifier = mem.zeroes([32]u8),
        },
    };
    const ssid = idf.CONFIG_ESP_WIFI_SSID;
    const passwd = idf.CONFIG_ESP_WIFI_PASSWORD;
    const sae_h2e_id = idf.CONFIG_ESP_WIFI_PW_ID;

    mem.copyForwards(u8, wifi_config.sta.ssid[0..ssid.len], ssid);
    wifi_config.sta.ssid[ssid.len] = 0;

    mem.copyForwards(u8, wifi_config.sta.password[0..passwd.len], passwd);
    wifi_config.sta.password[passwd.len] = 0;

    mem.copyForwards(u8, wifi_config.sta.sae_h2e_identifier[0..sae_h2e_id.len], sae_h2e_id);
    wifi_config.sta.sae_h2e_identifier[sae_h2e_id.len] = 0;

    idf.wifi.setMode(.WIFI_MODE_STA) catch {};
    idf.wifi.setConfig(.WIFI_IF_STA, &wifi_config) catch {};
    idf.wifi.start() catch {};

    idf.log.ESP_LOG(allocator, tag, "wifi_init_sta finished.\n", .{});

    // Waiting until either the connection is established (WIFI_CONNECTED_BIT) or connection failed for the maximum
    // number of re-tries (WIFI_FAIL_BIT). The bits are set by event_handler() (see above)
    const bits = idf.sys.xEventGroupWaitBits(
        @as(idf.sys.EventGroupHandle_t, @ptrCast(s_wifi_event_group)),
        idf.sys.WIFI_CONNECTED_BIT | idf.sys.WIFI_FAIL_BIT,
        0,
        0,
        0xffffffff,
    );

    // xEventGroupWaitBits() returns the bits before the call returned, hence we can test which event actually
    // happened.
    if ((bits & idf.sys.WIFI_CONNECTED_BIT) != 0) {
        idf.log.ESP_LOG(allocator, tag, "connected to ap SSID: {s} password: {s}\n", .{ ssid, passwd });
    } else if ((bits & idf.sys.WIFI_FAIL_BIT) != 0) {
        idf.log.ESP_LOG(allocator, tag, "Failed to connect SSID: {s} password: {s}\n", .{ ssid, passwd });
    } else {
        idf.log.ESP_LOG(allocator, tag, "UNEXPECTED EVENT", .{});
    }
}
