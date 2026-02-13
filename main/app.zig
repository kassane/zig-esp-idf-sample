const std = @import("std");
const builtin = @import("builtin");
const idf = @import("esp_idf");
const ver = idf.ver.Version;
const mem = std.mem;
const sys = idf.sys;
const ESP_LOG = idf.log.ESP_LOG;

comptime {
    @export(&main, .{ .name = "app_main" });
}

fn main() callconv(.c) void {
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
        \\[Zig Info]
        \\* Version: {s}
        \\* Compiler Backend: {s}
        \\
    , .{
        @as([]const u8, builtin.zig_version_string),
        @tagName(builtin.zig_backend),
    });

    ESP_LOG(allocator, tag,
        \\[ESP-IDF Info]
        \\* Version: {s}
        \\
    , .{ver.get().toString(allocator)});

    ESP_LOG(
        allocator,
        tag,
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

    ESP_LOG(
        allocator,
        tag,
        "Let's have a look at your shiny {s} - {s} system! :)\n\n",
        .{
            @tagName(builtin.cpu.arch),
            builtin.cpu.model.name,
        },
    );

    arraylist(allocator) catch |err| {
        log.err("Error: {s}", .{@errorName(err)});
    };

    if (builtin.mode == .Debug)
        heap.dump();

    // FreeRTOS Tasks
    if (idf.rtos.xTaskCreate(fooTask, "foo", 1024 * 3, null, 1, null) == 0) {
        @panic("Error: Task foo not created!\n");
    }
    if (idf.rtos.xTaskCreate(barTask, "bar", 1024 * 3, null, 2, null) == 0) {
        @panic("Error: Task bar not created!\n");
    }
    if (idf.rtos.xTaskCreate(blinkTask, "blink", 1024 * 2, null, 5, null) == 0) {
        @panic("Error: Task blinkclock not created!\n");
    }
}

fn blinkLED(delay_ms: u32) !void {
    try idf.gpio.Direction.set(
        .GPIO_NUM_18,
        .GPIO_MODE_OUTPUT,
    );
    while (true) {
        log.info("LED: ON", .{});
        try idf.gpio.Level.set(.GPIO_NUM_18, 1);

        idf.rtos.vTaskDelay(delay_ms / idf.rtos.portTICK_PERIOD_MS);

        log.info("LED: OFF", .{});
        try idf.gpio.Level.set(.GPIO_NUM_18, 0);

        idf.rtos.vTaskDelay(delay_ms / idf.rtos.portTICK_PERIOD_MS);
    }
}

fn arraylist(allocator: mem.Allocator) !void {
    var arr: std.ArrayList(u32) = .empty;
    defer arr.deinit(allocator);

    try arr.append(allocator, 10);
    try arr.append(allocator, 20);
    try arr.append(allocator, 30);

    for (arr.items) |value| {
        ESP_LOG(
            allocator,
            tag,
            "Arr value: {}\n",
            .{value},
        );
    }
}

// Task functions (must be exported to C ABI)
export fn blinkTask(_: ?*anyopaque) callconv(.c) void {
    blinkLED(1000) catch |err|
        @panic(@errorName(err));
}

export fn fooTask(_: ?*anyopaque) callconv(.c) void {
    while (true) {
        log.info("Demo_Task foo printing..", .{});
        idf.rtos.vTaskDelay(2000 / idf.rtos.portTICK_PERIOD_MS);
    }
}

export fn barTask(_: ?*anyopaque) callconv(.c) void {
    while (true) {
        log.info("Demo_Task bar printing..", .{});
        idf.rtos.vTaskDelay(1000 / idf.rtos.portTICK_PERIOD_MS);
    }
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

const tag = "zig-example";
