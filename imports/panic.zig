const idf = @import("sys");
const log = @import("log");

// panic handler for esp-idf
pub fn panic(msg: []const u8, error_return_trace: ?*@import("std").builtin.StackTrace, _: ?usize) noreturn {
    @setCold(true);
    idf.esp_log_write(log.default_level, "panic_handler", "PANIC: caused by %s - %ul\n", msg.ptr, idf.esp_log_timestamp());
    if (error_return_trace) |trace| {
        for (trace.instruction_addresses) |address| {
            idf.esp_log_write(log.default_level, "panic_handler", "Addr: %d  - %ul\n", address, idf.esp_log_timestamp());
        }
    }
    @breakpoint();
    idf.esp_system_abort("aborting...");
}
