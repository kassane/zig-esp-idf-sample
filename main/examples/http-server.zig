/// Minimal HTTP Server example — serves a "Hello from Zig!" page.
///
/// Requirements:
///   - WiFi configured in sdkconfig (SSID/password)
///   - CONFIG_ESP_WIFI_ENABLED=y
///
/// After connecting to WiFi, open http://<IP>/ in a browser.
const std = @import("std");
const builtin = @import("builtin");
const idf = @import("esp_idf");
const sys = idf.sys;

const log = std.log.scoped(.http_srv);

// ---------------------------------------------------------------------------
// URI handlers
// ---------------------------------------------------------------------------

const index_html =
    \\<!DOCTYPE html><html><body>
    \\<h1>Hello from Zig on ESP32!</h1>
    \\<p>This page is served by the Zig HTTP server wrapper.</p>
    \\</body></html>
;

/// GET / — serve the index page.
export fn handleRoot(req: [*c]sys.httpd_req_t) callconv(.c) sys.esp_err_t {
    idf.http.Server.Response.sendStr(req, index_html) catch |err| {
        log.err("sendStr: {s}", .{@errorName(err)});
        return sys.ESP_FAIL;
    };
    return sys.ESP_OK;
}

/// GET /api/hello — JSON API endpoint.
export fn handleApiHello(req: [*c]sys.httpd_req_t) callconv(.c) sys.esp_err_t {
    idf.http.Server.Response.setType(req, "application/json") catch {};
    idf.http.Server.Response.sendStr(req, "{\"message\":\"Hello from Zig!\"}") catch |err| {
        log.err("sendStr: {s}", .{@errorName(err)});
        return sys.ESP_FAIL;
    };
    return sys.ESP_OK;
}

// ---------------------------------------------------------------------------
// WiFi event handling (simplified — see wifi-station.zig for full version)
// ---------------------------------------------------------------------------

var g_event_group: sys.EventGroupHandle_t = null;
const CONNECTED_BIT: u32 = sys.WIFI_CONNECTED_BIT;

export fn onWifiEvent(_: ?*anyopaque, _: sys.esp_event_base_t, event_id: i32, _: ?*anyopaque) callconv(.c) void {
    if (event_id == sys.WIFI_EVENT_STA_START) {
        idf.wifi.connect() catch {};
    } else if (event_id == sys.WIFI_EVENT_STA_DISCONNECTED) {
        idf.wifi.connect() catch {};
    }
}

export fn onIpEvent(_: ?*anyopaque, _: sys.esp_event_base_t, event_id: i32, event_data: ?*anyopaque) callconv(.c) void {
    if (event_id == sys.IP_EVENT_STA_GOT_IP) {
        const ev = @as(*sys.ip_event_got_ip_t, @ptrCast(@alignCast(event_data)));
        const ip = ev.ip_info.ip.addr;
        log.info("Got IP: {}.{}.{}.{}", .{
            @as(u8, @truncate(ip)),
            @as(u8, @truncate(ip >> 8)),
            @as(u8, @truncate(ip >> 16)),
            @as(u8, @truncate(ip >> 24)),
        });
        _ = sys.xEventGroupSetBits(g_event_group, CONNECTED_BIT);
    }
}

// ---------------------------------------------------------------------------
// Entry point
// ---------------------------------------------------------------------------

export fn app_main() callconv(.c) void {
    // NVS
    idf.nvs.flashInitOrErase() catch |err| {
        log.err("NVS: {s}", .{@errorName(err)});
        return;
    };

    // WiFi init
    g_event_group = sys.xEventGroupCreate() orelse {
        log.err("xEventGroupCreate failed", .{});
        return;
    };
    idf.err.espCheckError(sys.esp_netif_init()) catch return;
    idf.event.loopCreateDefault() catch return;
    _ = sys.esp_netif_create_default_wifi_sta();

    var wifi_init_cfg = idf.wifi.init_config_default();
    idf.err.espCheckError(sys.esp_wifi_init(&wifi_init_cfg)) catch return;

    _ = idf.event.handlerInstanceRegister(sys.WIFI_EVENT, idf.event.ANY_ID, &onWifiEvent, null) catch return;
    _ = idf.event.handlerInstanceRegister(sys.IP_EVENT, sys.IP_EVENT_STA_GOT_IP, &onIpEvent, null) catch return;

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

    idf.wifi.setMode(.WIFI_MODE_STA) catch return;
    idf.wifi.setConfig(.WIFI_IF_STA, &wifi_config) catch return;
    idf.wifi.start() catch return;

    log.info("Waiting for WiFi connection...", .{});
    _ = sys.xEventGroupWaitBits(g_event_group, CONNECTED_BIT, 0, 0, sys.portMAX_DELAY);

    // Start HTTP server
    startHttpServer() catch |err| {
        log.err("HTTP server start failed: {s}", .{@errorName(err)});
    };
}

fn startHttpServer() !void {
    var config = std.mem.zeroes(sys.httpd_config_t);
    config.server_port = 80;
    config.stack_size = 4096;
    config.task_priority = 5;
    config.max_uri_handlers = 8;
    config.max_resp_headers = 8;
    config.recv_wait_timeout = 5;
    config.send_wait_timeout = 5;
    config.lru_purge_enable = false;

    const server = try idf.http.Server.start(&config);

    const root_uri = sys.httpd_uri_t{
        .uri = "/",
        .method = sys.HTTP_GET,
        .handler = &handleRoot,
        .user_ctx = null,
    };
    try idf.http.Server.registerUri(server, &root_uri);

    const api_uri = sys.httpd_uri_t{
        .uri = "/api/hello",
        .method = sys.HTTP_GET,
        .handler = &handleApiHello,
        .user_ctx = null,
    };
    try idf.http.Server.registerUri(server, &api_uri);

    log.info("HTTP server started on port 80", .{});
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
