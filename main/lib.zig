const std = @import("std");
const builtin = @import("builtin");
const esp_idf = @import("esp_idf");
const led = @import("led-strip.zig");

const tag = "zig-example";

export fn app_main() callconv(.C) void {
    esp_idf.ESP_LOGI(.ESP_LOG_INFO, tag, "Hello, world from Zig!", .{});
    esp_idf.ESP_LOGI(.ESP_LOG_INFO, tag, "\nZig Info:\n\nVersion: {s}\nStage: {s}\n", .{ builtin.zig_version_string, @tagName(builtin.zig_backend) });
    esp_idf.ESP_LOGI(.ESP_LOG_DEBUG, tag, "ESP-IDF version {s}!\n", .{esp_idf.esp_get_idf_version()});
    esp_idf.ESP_LOGI(
        .ESP_LOG_INFO,
        tag,
        "\nLet's have a look at your shiny {s} - {s} system! :)\n\n",
        .{ @tagName(builtin.cpu.arch), builtin.cpu.model.name[0.. :0] },
    );
    var arena = std.heap.ArenaAllocator.init(esp_idf.raw_heap_caps_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var arr = std.ArrayList(c_int).init(allocator);
    defer arr.deinit();

    arr.append(10) catch |err|
        esp_idf.ESP_LOGI(.ESP_LOG_ERROR, tag, "Error: {s}", .{@errorName(err)});
    arr.append(20) catch |err|
        esp_idf.ESP_LOGI(.ESP_LOG_ERROR, tag, "Error: {s}", .{@errorName(err)});
    arr.append(30) catch |err|
        esp_idf.ESP_LOGI(.ESP_LOG_ERROR, tag, "Error: {s}", .{@errorName(err)});

    for (arr.items) |index| {
        esp_idf.ESP_LOGI(.ESP_LOG_INFO, tag, "Arr value: {}!\n", .{index});
    }
    if (esp_idf.xTaskCreate(foo, "foo", 1024, null, 1, null) == 0) {
        esp_idf.ESP_LOGI(.ESP_LOG_ERROR, tag, "Error: Task not created!\n", .{});
    }
    if (esp_idf.xTaskCreate(bar, "bar", 1024, null, 0, null) == 0) {
        esp_idf.ESP_LOGI(.ESP_LOG_ERROR, tag, "Error: Task not created!\n", .{});
    }
}

pub export fn foo(params: ?*anyopaque) callconv(.C) void {
    _ = params; // autofix
    while (true) {
        esp_idf.ESP_LOGI(.ESP_LOG_INFO, tag, "Demo_Task 1 printing..\n", .{});
        esp_idf.vTaskDelay(6000 / esp_idf.portTICK_PERIOD_MS);
    }
}
pub export fn bar(params: ?*anyopaque) callconv(.C) void {
    _ = params; // autofix
    while (true) {
        esp_idf.ESP_LOGI(.ESP_LOG_INFO, tag, "Demo_Task 2 printing..\n", .{});
        esp_idf.vTaskDelay(1000 / esp_idf.portTICK_PERIOD_MS);
    }
}
