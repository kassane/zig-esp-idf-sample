/// Panic / Checked Illegal behaviour example - panics in various ways
///
/// Demonstrates what happens when checked illegal behaviour is caught
/// at runtime in Debug and ReleaseSafe mode, or @panic() is called.
///
/// No WiFi or Bluetooth required — works on any ESP32 target.
const std = @import("std");
const builtin = @import("builtin");
const idf = @import("esp_idf");

const log = std.log.scoped(.@"panic-check");

// Variables in the ".rtc_noinit" section retain their value after a software reset.
const NOINIT_ATTR = ".noinit";
// Variables in the ".rtc_noinit" section also retain their value during deep-sleep.
const RTC_NOINIT_ATTR = ".rtc_noinit";

// This variable is not zeroed or clobbered during software reset. No such
// guarantee for hardware reset.
// Cannot be initialised. If power is lost, any value is possible.
var reboot_counter: u32 linksection(NOINIT_ATTR ++ ".zig") = 5;


var bounds: [3]u8 = undefined;
var small: u2 = undefined;

export fn app_main() callconv(.c) void {
    reboot_counter +%= 1;

    log.info("Panic / Checked Illegal behaviour example, reboot_counter = {}", .{reboot_counter});
    log.info("Tip: try compiling in different modes and see what happens! e.g.\n    idf.py build -DZIG_BUILD_TYPE=ReleaseFast", .{});
    
    idf.rtos.Task.delayMs(500);

    // reboot_counter used as a variable, to defeat compile-time checks
    // Otherwise this code would fail to compile in any mode.
    switch(reboot_counter) {
        1 => @panic("Reason? We don't need a reason!"),
        2 => unreachable, // Reached Unreachable Code
        3 => bounds[reboot_counter] = 0, // Index out of Bounds
        4 => small = @intCast(reboot_counter), // Cast Truncates Data
        5 => reboot_counter /= (reboot_counter - 5), // Division By Zero
        6 => @as(*u32, @ptrFromInt(reboot_counter)).* = 5, // Incorrect Pointer Alignment
        // ... many more possibilities - see zig documentation.
        else => reboot_counter = 0,
    }

    log.warn("Ordinary restart", .{});
    idf.sys.esp_restart(); // No error message or stack trace.
}

// Zig looks for a `panic` declaration here, in the root source file
pub const panic = idf.esp_panic.panic;

pub const std_options: std.Options = .{
    .log_level = switch (builtin.mode) {
        .debug => .debug,
        else => .info,
    },
    .logFn = idf.log.espLogFn,
};
