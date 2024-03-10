const std = @import("std");
const builtin = @import("builtin");
const esp_idf = @import("esp_idf");
const led = @import("led-strip.zig");

const tag = "zig-example";

export fn app_main() callconv(.C) void {
    var arena = std.heap.ArenaAllocator.init(esp_idf.raw_heap_caps_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    defer esp_idf.ESP_LOGI(allocator, tag, "Minimum free heap size: {} bytes.\n", .{esp_idf.esp_get_free_heap_size()});

    esp_idf.ESP_LOGI(allocator, tag, "Hello, world from Zig!\n", .{});
    esp_idf.ESP_LOGI(allocator, tag,
        \\[Zig Info]
        \\* Version: {s}
        \\* Stage: {s}
        \\
    , .{ builtin.zig_version_string, @tagName(builtin.zig_backend) });
    esp_idf.ESP_LOGI(allocator, tag,
        \\[ESP-IDF Info]
        \\* Version: {s}
        \\
    , .{esp_idf.esp_get_idf_version()});
    esp_idf.ESP_LOGI(
        allocator,
        tag,
        "\nLet's have a look at your shiny {s} - {s} system! :)\n\n",
        .{ @tagName(builtin.cpu.arch), builtin.cpu.model.name[0.. :0] },
    );

    var arr = std.ArrayList(c_int).init(allocator);
    defer arr.deinit();

    arr.append(10) catch |err|
        esp_idf.ESP_LOGI(allocator, tag, "Error: {s}", .{@errorName(err)});
    arr.append(20) catch |err|
        esp_idf.ESP_LOGI(allocator, tag, "Error: {s}", .{@errorName(err)});
    arr.append(30) catch |err|
        esp_idf.ESP_LOGI(allocator, tag, "Error: {s}", .{@errorName(err)});

    for (arr.items) |index| {
        esp_idf.ESP_LOGI(allocator, tag, "Arr value: {}!\n", .{index});
    }

    // FreeRTOS Tasks
    defer {
        if (esp_idf.xTaskCreate(foo, "foo", 1024 * 3, null, 1, null) == 0) {
            esp_idf.ESP_LOGI(allocator, tag, "Error: Task not created!\n", .{});
        }
        if (esp_idf.xTaskCreate(bar, "bar", 1024 * 3, null, 2, null) == 0) {
            esp_idf.ESP_LOGI(allocator, tag, "Error: Task not created!\n", .{});
        }
    }
}
export fn foo(_: ?*anyopaque) callconv(.C) void {
    while (true) {
        _ = std.c.printf("Demo_Task 1 printing..\n");
        esp_idf.vTaskDelay(6000 / esp_idf.portTICK_PERIOD_MS);
    }
}
export fn bar(_: ?*anyopaque) callconv(.C) void {
    while (true) {
        _ = std.c.printf("Demo_Task 2 printing..\n");
        esp_idf.vTaskDelay(1000 / esp_idf.portTICK_PERIOD_MS);
    }
}
