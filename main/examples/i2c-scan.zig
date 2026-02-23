/// I2C Bus Scanner — probes all 7-bit addresses and prints which devices
/// respond with an ACK.
///
/// Uses the new I2C master driver (ESP-IDF v5.2+).
/// Default pins: SDA=21, SCL=22 (common on ESP32 dev boards).
const std = @import("std");
const builtin = @import("builtin");
const idf = @import("esp_idf");
const sys = idf.sys;

const log = std.log.scoped(.i2c_scan);

const SDA_PIN = 21;
const SCL_PIN = 22;
const I2C_FREQ_HZ = 100_000; // 100 kHz standard mode

export fn app_main() callconv(.c) void {
    log.info("I2C Bus Scanner — SDA={d} SCL={d} @ {d} Hz", .{ SDA_PIN, SCL_PIN, I2C_FREQ_HZ });

    // Create the I2C master bus
    const bus_config = sys.i2c_master_bus_config_t{
        .i2c_port = -1, // auto-select
        .sda_io_num = SDA_PIN,
        .scl_io_num = SCL_PIN,
        .clk_source = sys.I2C_CLK_SRC_DEFAULT,
        .glitch_ignore_cnt = 7,
        .intr_priority = 0,
        .trans_queue_depth = 0,
        .flags = .{
            .enable_internal_pullup = 1,
            .allow_pd = 0,
            .clk_flags = 0,
        },
    };

    var bus_handle: sys.i2c_master_bus_handle_t = null;
    idf.i2c.BUS.add(&bus_config, &bus_handle) catch |err| {
        log.err("I2C bus init failed: {s}", .{@errorName(err)});
        return;
    };

    // Scan all valid 7-bit addresses (0x03 – 0x77)
    var found: u32 = 0;
    log.info("Scanning...", .{});

    var addr: u16 = 0x03;
    while (addr <= 0x77) : (addr += 1) {
        if (idf.i2c.probe(bus_handle, addr, 50)) {
            log.info("  Found device at 0x{X:0>2}", .{addr});
            found += 1;
        } else |_| {
            // No ACK — no device at this address
        }
    }

    if (found == 0) {
        log.info("No I2C devices found.", .{});
    } else {
        log.info("Scan complete — {d} device(s) found.", .{found});
    }

    // Clean up
    idf.i2c.BUS.del(bus_handle) catch {};
}

pub const panic = idf.esp_panic.panic;
pub const std_options: std.Options = .{
    .log_level = switch (builtin.mode) {
        .Debug => .debug,
        else => .info,
    },
    .logFn = idf.log.espLogFn,
};
