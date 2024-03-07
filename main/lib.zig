const std = @import("std");
const builtin = @import("builtin");
const esp_idf = @import("esp_idf");
const led = @import("led-strip.zig");

export fn app_main() callconv(.C) void {
    esp_idf.ESP_LOGI(.ESP_LOG_INFO, "zig-example", "Hello, world from Zig!", .{});
    esp_idf.ESP_LOGI(.ESP_LOG_INFO, "zig-example", "\nZig Info:\n\nVersion: {s}\nStage: {s}\n", .{ builtin.zig_version_string, @tagName(builtin.zig_backend) });
    esp_idf.ESP_LOGI(.ESP_LOG_DEBUG, "zig-example", "ESP-IDF version {s}!\n", .{esp_idf.esp_get_idf_version()});
    esp_idf.ESP_LOGI(
        .ESP_LOG_INFO,
        "zig-example",
        "\nLet's have a look at your shiny {s} - {s} system! :)\n\n",
        .{ @tagName(builtin.cpu.arch), builtin.cpu.model.name[0.. :0] },
    );
    var arena = std.heap.ArenaAllocator.init(esp_idf.raw_heap_caps_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var arr = std.ArrayList(c_int).init(allocator);
    defer arr.deinit();

    arr.append(10) catch |err| esp_idf.ESP_LOGI(.ESP_LOG_ERROR, "zig-example", "Error: {s}", .{@errorName(err)});
    arr.append(20) catch |err| esp_idf.ESP_LOGI(.ESP_LOG_ERROR, "zig-example", "Error: {s}", .{@errorName(err)});
    arr.append(30) catch |err| esp_idf.ESP_LOGI(.ESP_LOG_ERROR, "zig-example", "Error: {s}", .{@errorName(err)});

    for (arr.items) |index| {
        esp_idf.ESP_LOGI(.ESP_LOG_INFO, "zig-example", "Arr value: {}!\n", .{index});
    }

    // _ = esp_idf.xTaskCreate(foo, "foo", 1024, null, 1, null);
    // _ = esp_idf.xTaskCreate(bar, "bar", 1024, null, 0, null);
    // configure_led();
    // while (true) {
    //     blink_led();
    //     s_led_state = !s_led_state;
    //     _ = esp_idf.vTaskDelay(led.CONFIG_BLINK_PERIOD / esp_idf.portTICK_PERIOD_MS);
    // }
}

// pub export fn foo(params: ?*anyopaque) callconv(.C) void {
//     _ = params; // autofix
//     while (true) {
//         esp_idf.ESP_LOGI(.ESP_LOG_INFO, "zig-example", "Demo_Task printing..\n", .{});
//         _ = esp_idf.vTaskDelay(6000 / esp_idf.portTICK_PERIOD_MS);
//     }
// }
// pub export fn bar(params: ?*anyopaque) callconv(.C) void {
//     _ = params; // autofix
//     while (true) {
//         esp_idf.ESP_LOGI(.ESP_LOG_INFO, "zig-example", "Demo_Task 2 printing..\n", .{});
//         _ = esp_idf.vTaskDelay(1000 / esp_idf.portTICK_PERIOD_MS);
//     }
// }

// export fn blink_led() void {
//     //* If the addressable LED is enabled */
//     if (s_led_state) {
//         //* Set the LED pixel using RGB from 0 (0%) to 255 (100%) for each color */
//         _ = led.led_strip_set_pixel(led_strip, 0, 16, 16, 16);
//         //* Refresh the strip to send data */
//         _ = led.led_strip_refresh(led_strip);
//     } else {
//         //* Set all LED off to clear all pixels */
//         _ = led.led_strip_clear(led_strip);
//     }
// }
export fn blink_led() void {
    _ = led.gpio_set_level(BLINK_GPIO, @intFromBool(s_led_state));
}
export fn configure_led() void {
    esp_idf.ESP_LOGI(.ESP_LOG_INFO, "zig-example", "Example configured to blink GPIO LED!", .{});
    _ = led.gpio_reset_pin(BLINK_GPIO);
    // Set the GPIO as a push/pull output
    _ = led.gpio_set_direction(BLINK_GPIO, esp_idf.gpio_mode_t.GPIO_MODE_OUTPUT);
}

const BLINK_GPIO: esp_idf.gpio_num_t = @enumFromInt(led.CONFIG_BLINK_GPIO);
var s_led_state: bool = false;
const led_strip = led.led_strip_handle_t;
