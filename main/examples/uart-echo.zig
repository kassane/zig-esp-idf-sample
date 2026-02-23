/// UART Echo example — reads bytes from UART0 and echoes them back.
///
/// Connect with: idf.py -p <PORT> monitor   (or any serial terminal at 115200)
/// Type characters and they are echoed back.
///
/// Uses the Zig UART wrapper (idf.uart).
const std = @import("std");
const builtin = @import("builtin");
const idf = @import("esp_idf");
const sys = idf.sys;

const log = std.log.scoped(.uart_echo);

const UART_PORT: idf.uart.Port = 1; // UART1 (UART0 is used by console/monitor)
const BAUD_RATE = 115200;
const BUF_SIZE = 256;

// Pin assignment — adjust for your board
const TX_PIN: c_int = 4;
const RX_PIN: c_int = 5;

export fn app_main() callconv(.c) void {
    log.info("UART Echo example — UART{d} @ {d} baud", .{ UART_PORT, BAUD_RATE });

    // Configure UART parameters
    const uart_config = sys.uart_config_t{
        .baud_rate = BAUD_RATE,
        .data_bits = sys.UART_DATA_8_BITS,
        .parity = sys.UART_PARITY_DISABLE,
        .stop_bits = sys.UART_STOP_BITS_1,
        .flow_ctrl = sys.UART_HW_FLOWCTRL_DISABLE,
        .source_clk = sys.UART_SCLK_DEFAULT,
        .rx_flow_ctrl_thresh = 0,
        .lp_source_clk = 0,
        .flags = .{ .backup_before_sleep = 0, .allow_pd = 0 },
    };

    idf.uart.paramConfig(UART_PORT, &uart_config) catch |err| {
        log.err("paramConfig failed: {s}", .{@errorName(err)});
        return;
    };

    idf.uart.setPin(UART_PORT, .{
        .tx = TX_PIN,
        .rx = RX_PIN,
    }) catch |err| {
        log.err("setPin failed: {s}", .{@errorName(err)});
        return;
    };

    idf.uart.driverInstall(UART_PORT, .{
        .rx_buffer_size = BUF_SIZE * 2,
        .tx_buffer_size = 0,
    }) catch |err| {
        log.err("driverInstall failed: {s}", .{@errorName(err)});
        return;
    };

    log.info("UART driver installed — echoing on TX={d} RX={d}", .{ TX_PIN, RX_PIN });

    // Echo loop
    var buf: [BUF_SIZE]u8 = undefined;
    while (true) {
        const n = idf.uart.readBytes(UART_PORT, &buf, sys.portMAX_DELAY) catch |err| {
            log.err("readBytes: {s}", .{@errorName(err)});
            continue;
        };
        if (n > 0) {
            _ = idf.uart.writeBytes(UART_PORT, buf[0..n]) catch |err| {
                log.err("writeBytes: {s}", .{@errorName(err)});
            };
        }
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
