const std = @import("std");
const builtin = @import("builtin");
const idf = @import("esp_idf");
const wifi = idf.wifi;

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
        \\[Zig Info]
        \\* Version: {s}
        \\* Compiler Backend: {s}
        \\
    , .{
        @as([]const u8, builtin.zig_version_string), // fix esp32p4(.xesppie) fmt-slice bug
        @tagName(builtin.zig_backend),
    });

    idf.ESP_LOG(allocator, tag,
        \\[ESP-IDF Info]
        \\* Version: {s}
        \\
    , .{idf.Version.get().toString(allocator)});

    idf.ESP_LOG(
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

    idf.ESP_LOG(
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

    if (!std.mem.eql(u8, idf.sys.mcpu, "esp32h2")) {
        wifi_init() catch |err| {
            log.err("Error: {s}", .{@errorName(err)});
        };
    }

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

fn stringToArray(comptime size: usize, str: [:0]const u8) [size]u8 {
    var arr: [size]u8 = undefined;
    @memset(&arr, 0); // Zero-fill
    const len = @min(str.len, size);
    @memcpy(arr[0..len], str[0..len]);
    return arr;
}

fn wifi_init() !void {
    var conf: wifi.wifiConfig = .{
        .sta = .{
            .password = stringToArray(64, "pass"),
            .ssid = stringToArray(32, "my_ssid"),
        },
    };
    try wifi.init(&.{});
    try wifi.setMode(.WIFI_MODE_STA);
    try wifi.setConfig(.WIFI_IF_STA, &conf);
    try wifi.start();
    try wifi.connect();
}

// comptime function
fn blinkLED(delay_ms: u32) !void {
    try idf.gpio.Direction.set(
        .GPIO_NUM_18,
        .GPIO_MODE_OUTPUT,
    );
    while (true) {
        log.info("LED: ON", .{});
        try idf.gpio.Level.set(.GPIO_NUM_18, 1);

        idf.vTaskDelay(delay_ms / idf.portTICK_PERIOD_MS);

        log.info("LED: OFF", .{});
        try idf.gpio.Level.set(.GPIO_NUM_18, 0);
    }
}

fn arraylist(allocator: std.mem.Allocator) !void {
    var arr = std.ArrayList(u32).init(allocator);
    defer arr.deinit();

    try arr.append(10);
    try arr.append(20);
    try arr.append(30);

    for (arr.items) |index| {
        idf.ESP_LOG(
            allocator,
            tag,
            "Arr value: {}\n",
            .{index},
        );
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
pub const std_options: std.Options = .{
    .log_level = switch (builtin.mode) {
        .Debug => .debug,
        else => .info,
    },
    // Define logFn to override the std implementation
    .logFn = idf.espLogFn,
};

const tag = "zig-example";
