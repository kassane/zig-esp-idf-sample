const sys = @import("sys");
const log = @import("log");

/// panic handler for esp-idf
pub fn panic(msg: []const u8, _: ?*@import("std").builtin.StackTrace, _: ?usize) noreturn {
    sys.esp_log_write(log.default_level, "panic_handler", "PANIC: caused by %s - timestamp: %ul\n", msg.ptr, sys.esp_log_timestamp());

    //TODO: get the stack trace and print it!

    while (true) {
        asm volatile ("" ::: "memory");
    }
}
