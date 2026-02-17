const std = @import("std");
const builtin = @import("builtin");
const idf = @import("esp_idf");
const ver = idf.ver.Version;
const mem = std.mem;
const led = idf.led;

comptime {
    @export(&main, .{ .name = "app_main" });
}

// LED strip configuration constants
const LED_STRIP_USE_DMA = false;
const LED_STRIP_LED_COUNT = if (LED_STRIP_USE_DMA) 256 else 24;
const LED_STRIP_MEMORY_BLOCK_WORDS = if (LED_STRIP_USE_DMA) 1024 else 0;
const LED_STRIP_GPIO_PIN = 2;

fn configureLED() !led.LedStripHandle {
    // LED strip general initialization using wrapped types
    const strip_config = led.LedStripConfig.ws2812(LED_STRIP_GPIO_PIN, LED_STRIP_LED_COUNT);

    // LED strip backend configuration: RMT
    var rmt_config = led.LedStripRmtConfig.default;
    rmt_config.mem_block_symbols = LED_STRIP_MEMORY_BLOCK_WORDS;

    if (LED_STRIP_USE_DMA) {
        // Set DMA flag if needed
        rmt_config.flags = 1; // with_dma bit
    }

    var led_strip: led.LedStripHandle = null;
    const strip = try led.newRmtDevice(&strip_config, &rmt_config, &led_strip);

    log.info("Created LED strip object with RMT backend", .{});
    return strip;
}

fn ledStripTask(led_strip_ptr: ?*anyopaque) callconv(.c) void {
    const led_strip: led.LedStripHandle = @ptrCast(@alignCast(led_strip_ptr.?));
    var led_on_off = false;

    log.info("Start blinking LED strip", .{});

    while (true) {
        if (led_on_off) {
            // Set the LED pixel using RGB from 0 (0%) to 255 (100%) for each color
            var i: u32 = 0;
            while (i < LED_STRIP_LED_COUNT) : (i += 1) {
                led.setPixel(led_strip, i, 5, 5, 5) catch |err| {
                    log.err("Failed to set LED pixel {}: {s}", .{ i, @errorName(err) });
                };
            }

            // Refresh the strip to send data
            led.refresh(led_strip) catch |err| {
                log.err("Failed to refresh LED strip: {s}", .{@errorName(err)});
            };

            log.info("LED ON!", .{});
        } else {
            // Set all LED off to clear all pixels
            led.clear(led_strip) catch |err| {
                log.err("Failed to clear LED strip: {s}", .{@errorName(err)});
            };

            log.info("LED OFF!", .{});
        }

        led_on_off = !led_on_off;
        idf.rtos.vTaskDelay(500 / idf.rtos.portTICK_PERIOD_MS);
    }
}

fn main() callconv(.c) void {
    log.info("LED Strip Example", .{});

    // Configure and initialize LED strip
    const led_strip = configureLED() catch |err| {
        log.err("Failed to configure LED strip: {s}", .{@errorName(err)});
        @panic("LED strip initialization failed");
    };

    // Create LED strip control task
    if (idf.rtos.xTaskCreate(
        ledStripTask,
        "led_strip",
        1024 * 4,
        led_strip,
        5,
        null,
    ) == 0) {
        @panic("Error: LED strip task not created!");
    }

    log.info("LED strip task started successfully", .{});
}

// Override the std panic function with idf.panic
pub const panic = idf.esp_panic.panic;

const log = std.log.scoped(.@"led-strip");
pub const std_options: std.Options = .{
    .log_level = switch (builtin.mode) {
        .Debug => .debug,
        else => .info,
    },
    // Define logFn to override the std implementation
    .logFn = idf.log.espLogFn,
};
