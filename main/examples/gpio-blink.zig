/// GPIO Blink example — toggles an LED on a GPIO pin every second.
///
/// Default pin is GPIO2 (onboard LED on most ESP32 dev boards).
/// Change `LED_PIN` below for your board.
///
/// No WiFi or Bluetooth required — works on any ESP32 target.
const std = @import("std");
const builtin = @import("builtin");
const idf = @import("esp_idf");

const log = std.log.scoped(.blink);

const LED_PIN: idf.gpio.Num() = .@"2";

export fn app_main() callconv(.c) void {
    log.info("GPIO Blink example — toggling GPIO{d}", .{@intFromEnum(LED_PIN)});

    idf.gpio.Direction.set(LED_PIN, .output) catch |err| {
        log.err("GPIO direction set failed: {s}", .{@errorName(err)});
        return;
    };

    var led_on: u1 = 0;
    while (true) {
        led_on ^= 1;
        idf.gpio.Level.set(LED_PIN, led_on) catch {};
        log.info("LED: {s}", .{if (led_on == 1) "ON" else "OFF"});
        idf.rtos.Task.delayMs(1000);
    }
}

pub const panic = idf.esp_panic.panic;
pub const std_options: std.Options = .{
    .log_level = switch (builtin.mode) {
        .Debug => .debug,
        else => .info,
    },
    .logFn = idf.log.espLogFn,
};
