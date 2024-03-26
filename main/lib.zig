const std = @import("std");
const builtin = @import("builtin");
const idf = @import("esp_idf");

export fn app_main() callconv(.C) void {
    // This allocator is safe to use as the backing allocator w/ arena allocator
    // std.heap.raw_c_allocator

    // custom allocators (based on raw_c_allocator)
    // idf.heap.HeapCapsAllocator
    // idf.heap.MultiHeapAllocator
    // idf.heap.vPortAllocator

    var heap = idf.heap.HeapCapsAllocator.init(.MALLOC_CAP_8BIT);
    var arena = std.heap.ArenaAllocator.init(heap.allocator());
    defer arena.deinit();
    const allocator = arena.allocator();

    log.info("Hello, world from Zig!", .{});

    log.info(
        \\
        \\[Zig Info]
        \\* Version: {s}
        \\* Compiler Backend: {s}
        \\
    , .{
        builtin.zig_version_string,
        @tagName(builtin.zig_backend),
    });

    idf.ESP_LOG(allocator, tag,
        \\
        \\[ESP-IDF Info]
        \\* Version: {s}
        \\
    , .{idf.Version.get().toString(allocator)});

    idf.ESP_LOG(
        allocator,
        tag,
        \\
        \\[Memory Info]
        \\* Total: {d}
        \\* Free: {d}
        \\* Minimum: {d}
        \\
    ,
        .{
            heap.totalSize(),
            heap.freeSize(),
            heap.minimumFreeSize(),
        },
    );

    idf.ESP_LOG(
        allocator,
        tag,
        "\nLet's have a look at your shiny {s} - {s} system! :)\n\n",
        .{
            @tagName(builtin.cpu.arch),
            builtin.cpu.model.name,
        },
    );

    var arr = std.ArrayList(c_int).init(allocator);
    defer arr.deinit();

    arr.append(10) catch |err|
        @panic(@errorName(err));
    arr.append(20) catch |err|
        @panic(@errorName(err));
    arr.append(30) catch |err|
        @panic(@errorName(err));

    for (arr.items) |index| {
        idf.ESP_LOG(
            allocator,
            tag,
            "Arr value: {}\n",
            .{index},
        );
    }
    if (builtin.mode == .Debug)
        heap.dump();

    // FreeRTOS Tasks
    if (idf.xTaskCreate(foo, "foo", 1024 * 3, null, 1, null) == 0) {
        @panic("Error: Task foo not created!\n");
    }
    if (idf.xTaskCreate(bar, "bar", 1024 * 3, null, 2, null) == 0) {
        @panic("Error: Task bar not created!\n");
    }
    if (idf.xTaskCreate(blinkclock, "blink", 1024 * 2, null, 5, null) == 0) {
        @panic("Error: Task blinkclock not created!\n");
    }
}

// comptime function
fn blinkLED(delay_ms: u32) !void {
    try idf.gpio.setDirection(
        .GPIO_NUM_18,
        .GPIO_MODE_OUTPUT,
    );
    while (true) {
        log.info("LED: ON", .{});
        try idf.gpio.setLevel(.GPIO_NUM_18, 1);

        idf.vTaskDelay(delay_ms / idf.portTICK_PERIOD_MS);

        log.info("LED: OFF", .{});
        try idf.gpio.setLevel(.GPIO_NUM_18, 0);
    }
}

// Task functions (must be exported to C ABI) - runtime functions
export fn blinkclock(_: ?*anyopaque) void {
    blinkLED(1000) catch |err|
        @panic(@errorName(err));
}

export fn foo(_: ?*anyopaque) callconv(.C) void {
    while (true) {
        log.info("Demo_Task foo printing..", .{});
        idf.vTaskDelay(2000 / idf.portTICK_PERIOD_MS);
    }
}
export fn bar(_: ?*anyopaque) callconv(.C) void {
    while (true) {
        log.info("Demo_Task bar printing..", .{});
        idf.vTaskDelay(1000 / idf.portTICK_PERIOD_MS);
    }
}

// override the std panic function with idf.panic
pub const panic = idf.panic;

const log = std.log.scoped(.@"esp-idf");
pub const std_options = .{
    .log_level = switch (builtin.mode) {
        .Debug => .debug,
        else => .info,
    },
    // Define logFn to override the std implementation
    .logFn = idf.espLogFn,
};

const tag = "zig-example";
