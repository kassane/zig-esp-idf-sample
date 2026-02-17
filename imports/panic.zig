const sys = @import("sys");
const log = @import("log");

/// panic handler for esp-idf
pub fn panic(msg: []const u8, stack_trace: ?*@import("std").builtin.StackTrace, _: ?usize) noreturn {
    sys.esp_log_write(log.default_level, "PANIC", "[%lu ms] PANIC: %.*s\n", sys.esp_log_timestamp(), msg.len, msg.ptr);

    // try print stack trace if available
    if (stack_trace) |st| {
        var i: usize = st.index;
        if (i > st.instruction_addresses.len) i = st.instruction_addresses.len;
        var idx: usize = 0;
        while (idx < i) : (idx += 1) {
            sys.esp_log_write(log.default_level, "PANIC", "  #%u: 0x%08lx\n", idx, st.instruction_addresses[idx]);
        }
    }

    while (true) {
        asm volatile ("" ::: "memory");
    }
}
