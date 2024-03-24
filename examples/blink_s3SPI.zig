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

    var heap = idf.heap.vPortAllocator.init();
    var arena = std.heap.ArenaAllocator.init(heap.allocator());
    defer arena.deinit();
    const allocator = arena.allocator();

    log.info("Hello, world from Zig!", .{});

    log.info(
        \\
        \\[Zig Info]
        \\* Version: {s}
        \\* Stage: {s}
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
        \\* Free: {d}
        \\* Minimum: {d}
        \\
    ,
        .{
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

    if (builtin.mode == .Debug)
        heap.dump();

    // FreeRTOS Tasks
    if (idf.xTaskCreate(blinkclock, "blink", 1024 * 2, null, 5, null) == 0) {
        @panic("Error: Task blinkclock not created!\n");
    }
}
var led_strip: ?*idf.led_strip_t = null;
var s_led_state = false;

/// comptime function
fn blinkLED(delay_ms: u32) !void {
    if (s_led_state) {
        idf.vTaskDelay(delay_ms / idf.portTICK_PERIOD_MS);
        log.info("LOG ON", .{});
        // Set the LED pixel using RGB from 0 (0%) to 255 (100%) for each color
        idf.espCheckError(idf.led_strip_set_pixel(led_strip, 0, 16, 16, 16)) catch |err|
            @panic(@errorName(err));
        // Refresh the strip to send data
        idf.espCheckError(idf.led_strip_refresh(led_strip)) catch |err|
            @panic(@errorName(err));
    } else {
        idf.vTaskDelay(delay_ms / idf.portTICK_PERIOD_MS);
        // Set all LED off to clear all pixels
        idf.espCheckError(idf.led_strip_clear(led_strip)) catch |err|
            @panic(@errorName(err));
        log.info("LOG OFF", .{});
    }
}

fn config_led() void {
    const strip_config: idf.led_strip_config_t = .{
        .strip_gpio_num = 48,
        .max_leds = 1, // at least one LED on board
    };
    const spi_config: idf.led_strip_spi_config_t = .{
        .spi_bus = .SPI2_HOST,
        .flags = .{
            .with_dma = true,
        },
    };
    idf.espCheckError(idf.led_strip_new_spi_device(&strip_config, &spi_config, &led_strip)) catch |err|
        @panic(@errorName(err));
    // Set all LED off to clear all pixels
    idf.espCheckError(idf.led_strip_clear(led_strip)) catch |err|
        @panic(@errorName(err));
}

/// Task functions (must be exported to C ABI) - runtime functions
export fn blinkclock(_: ?*anyopaque) void {
    config_led();

    while (true) {
        blinkLED(1000) catch |err|
            @panic(@errorName(err));
        // Toggle the LED state
        s_led_state = !s_led_state;
    }
}

/// override the std panic function with idf.panic
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

const tag = "zig-blinkSPI";
