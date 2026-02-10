pub const bl = @import("bootloader");
pub const bt = @import("bluetooth");
pub const crc = @import("crc");
pub const dsp = @import("dsp");
pub const err = @import("error");
pub const gpio = @import("gpio");
pub const heap = @import("heap");
pub const http = @import("http");
pub const i2c = @import("i2c");
pub const i2s = @import("i2s");
pub const led = @import("led");
pub const log = @import("log");
pub const lwip = @import("lwip");
pub const mqtt = @import("mqtt");
pub const phy = @import("phy");
pub const pulse = @import("pulse");
pub const esp_panic = @import("panic");
pub const rtos = @import("rtos");
pub const segger = @import("segger");
pub const spi = @import("spi");
pub const uart = @import("uart");
pub const ver = @import("ver");
pub const wifi = @import("wifi");
pub const sys = @import("sys");

const Device = enum {
    esp32,
    esp32s2,
    esp32s3,
    esp32c2,
    esp32c3,
    esp32c5,
    esp32c6,
    esp32c61,
    esp32h2,
    esp32h4,
    esp32p4,
};

// Convert compile-time target string to enum
pub const current_device = blk: {
    const target_str = sys.CONFIG_IDF_TARGET;
    break :blk @import("std").meta.stringToEnum(Device, target_str) orelse {
        @compileError("Unknown ESP32 device target: " ++ target_str);
    };
};
