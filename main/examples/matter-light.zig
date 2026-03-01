//! matter-light.zig — Matter On/Off Light example
//!
//! Creates a single Matter On/Off Light endpoint and handles attribute
//! updates to toggle an LED (GPIO2 by default).
//!
//! Requirements:
//!   - espressif/esp_matter managed component installed
//!   - CONFIG_ESP_MATTER_ENABLE_MATTER_SERVER=y in sdkconfig
//!   - WiFi or Thread commissioning configured
//!   - NVS flash partition present
//!
//! To use: set ZIG_EXAMPLE_MATTER_LIGHT in menuconfig, or change
//! root_source_file in build.zig to "main/examples/matter-light.zig".

const idf = @import("esp_idf");
const std = @import("std");
const matter = idf.matter;
const log = std.log.scoped(.matter);

// ── Cluster / attribute IDs (from Matter specification) ──────────────────────

const ON_OFF_CLUSTER_ID: u32 = 0x0006;
const ON_OFF_ATTR_ID: u32 = 0x0000; // OnOff attribute
const LED_GPIO: idf.gpio.Num() = .@"2";

// ── Global state ─────────────────────────────────────────────────────────────
var g_light_endpoint_id: u16 = 0;

/// Called before/after every attribute update in the data model.
fn attributeCallback(cb_type: matter.AttrCbType, endpoint_id: u16, cluster_id: u32, attribute_id: u32, val: ?*matter.AttrVal, _: ?*anyopaque) callconv(.c) c_int {
    if (cb_type != matter.AttrCbType.ESP_MATTER_ATTR_CB_POST_UPDATE) return 0;
    if (endpoint_id != g_light_endpoint_id) return 0;
    if (cluster_id != ON_OFF_CLUSTER_ID or attribute_id != ON_OFF_ATTR_ID) return 0;

    const v = val orelse return 0;
    const on = v.val.b;

    // Drive the LED
    idf.gpio.Level.set(LED_GPIO, if (on) 0 else 1) catch {};
    log.info("matter-light: on={}", .{on});

    return 0; // ESP_OK
}

/// Called when clients interact with the Identify cluster.
fn identifyCallback(_: matter.IdentifyCbType, _: u16, _: u8, _: u8, _: ?*anyopaque) callconv(.c) c_int {
    log.info("matter-light: identify request", .{});
    return 0;
}

// ── app_main ──────────────────────────────────────────────────────────────────

pub fn main() callconv(.c) void {
    // 1. Initialise NVS (required by Matter for commissioning state).
    idf.nvs.flashInitOrErase() catch |err| @panic(@errorName(err));

    // 2. Initialise the network stack.
    //    For WiFi-based commissioning, start WiFi station in the usual way.
    //    Matter will use the netif that is already up.

    // 3. Configure LED GPIO as output.
    idf.gpio.Direction.set(LED_GPIO, .output) catch |err| @panic(@errorName(err));
    idf.gpio.Level.set(LED_GPIO, 1) catch |err| @panic(@errorName(err));

    // 4. Build the Matter data model.
    const node = matter.nodeCreate(&attributeCallback, &identifyCallback, null) catch |err| @panic(@errorName(err));

    // Add an On/Off Light endpoint with default clusters (OnOff, Identify,
    // Descriptor, Groups, Scenes Management, Level Control…).
    const ep = matter.endpoint.addOnOffLight(node, matter.EpFlags.none, null) catch |err| @panic(@errorName(err));

    g_light_endpoint_id = matter.endpoint.getId(ep);
    log.info("matter-light: light endpoint id={}", .{g_light_endpoint_id});

    // 5. Start the Matter stack.
    matter.start(&attributeCallback, &identifyCallback) catch |err| @panic(@errorName(err));

    log.info("matter-light: Matter started — waiting for commissioning", .{});

    // 6. Main loop — just keep the FreeRTOS idle task alive.
    while (true) {
        idf.rtos.Task.delayMs(1000);
    }
}

pub const panic = idf.esp_panic.panic;
pub const std_options: std.Options = .{
    .log_level = switch (@import("builtin").mode) {
        .Debug => .debug,
        else => .info,
    },
    .logFn = idf.log.espLogFn,
};

comptime {
    @export(&main, .{ .name = "app_main" });
}
