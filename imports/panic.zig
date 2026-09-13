const std = @import("std");
const sys = @import("sys");
const hw_support = @import("hw_support");

pub const panic = std.debug.FullPanic(panicFn);

/// panic handler for esp-idf
fn panicFn(msg: []const u8, first_trace_addr: ?usize) noreturn {
    // Safety-check panics will provide first_trace_addr to the code that triggered them,
    // whereas @panic("msg") is inlined to this function, so we can use @returnAddress()
    const trace_addr: u32 = first_trace_addr orelse @returnAddress();
    const addr: u32 = hw_support.cpu.pcToAddr(trace_addr - 3);

    // 100 bytes should be sufficient for most panic messages
    var buf: [100:0]u8 = @splat(0);
    const fmtMsg = std.mem.printSentinel(&buf, "core {d} PC 0x{x} panic: {s}", .{
        hw_support.cpu.getCoreId(),
        addr,
        msg,
    }, 0) catch {
        sys.esp_system_abort(&buf); // Print the partial message
        unreachable;
    };

    // This will print out the string, stack trace, and then restart the chip
    sys.esp_system_abort(fmtMsg);
    unreachable;
}
