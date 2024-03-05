const std = @import("std");
const builtin = @import("builtin");
const esp_idf = @import("esp_idf");

export fn app_main() callconv(.C) void {
    _ = std.c.printf("Hello, world from Zig!\n");
    _ = std.c.printf(
        "\nZig Info:\n\nVersion: %s\nStage: %s\n",
        builtin.zig_version_string,
        @tagName(builtin.zig_backend),
    );
    _ = std.c.printf("ESP-IDF version %s!\n", esp_idf.esp_get_idf_version());
    _ = std.c.printf(
        "\nLet's have a look at your shiny %s - %s system! :)\n\n",
        @tagName(builtin.cpu.arch),
        builtin.cpu.model.name[0.. :0],
    );
    var arena = std.heap.ArenaAllocator.init(
        esp_idf.raw_heap_caps_allocator,
    );
    defer arena.deinit();
    const allocator = arena.allocator();

    var arr = std.ArrayList(c_int).init(allocator);
    defer arr.deinit();

    arr.append(10) catch |err| @panic(@errorName(err));
    arr.append(20) catch |err| @panic(@errorName(err));
    arr.append(30) catch |err| @panic(@errorName(err));

    for (arr.items) |index| {
        _ = std.c.printf("Arr value: %d!\n", index);
    }

    _ = esp_idf.xTaskCreate(foo, "foo", 1024, null, 1, null);
    _ = esp_idf.xTaskCreate(bar, "bar", 1024, null, 0, null);
}

pub export fn foo(params: ?*anyopaque) callconv(.C) void {
    _ = params; // autofix
    while (true) {
        _ = std.c.printf("Demo_Task printing..\n");
        _ = esp_idf.vTaskDelay(6000 / std.time.ms_per_s);
    }
}
pub export fn bar(params: ?*anyopaque) callconv(.C) void {
    _ = params; // autofix
    while (true) {
        _ = std.c.printf("Demo_Task 2 printing..\n");
        _ = esp_idf.vTaskDelay(1000 / std.time.ms_per_s);
    }
}
