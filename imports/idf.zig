pub const bl = @import("bootloader");
pub const bt = @import("bluetooth");
pub const nimble = if (@hasDecl(sys, "CONFIG_BT_NIMBLE_ENABLED"))
    @import("nimble")
else
    @compileError(
        \\NimBLE not enabled. Enable via:
        \\  idf.py menuconfig → Component config → Bluetooth → Host → NimBLE
        \\Then run: idf.py reconfigure
    );
pub const crc = @import("crc");
pub const dsp = switch (sys.HAS_ESP_DSP != 0) {
    true => @import("dsp"),
    false => @compileError("requires: idf.py add-dependency espressif/esp-dsp"),
};
pub const err = @import("error");
pub const gpio = @import("gpio");
pub const heap = @import("heap");
pub const http = @import("http");
pub const i2c = @import("i2c");
pub const i2s = @import("i2s");
pub const led = switch (sys.HAS_LED_STRIP != 0) {
    true => @import("led"),
    false => @compileError("requires: idf.py add-dependency espressif/led_strip"),
};
pub const log = @import("log");
pub const lwip = @import("lwip");
pub const mqtt = @import("mqtt");
pub const esp_now = @import("now");
pub const phy = @import("phy");
pub const pulse = @import("pulse");
pub const esp_panic = @import("panic");
pub const rtos = @import("rtos");
pub const nvs = @import("nvs");
pub const partition = @import("partition");
pub const sleep = @import("sleep");
pub const event = @import("event");
pub const wdt = @import("wdt");
pub const segger = @import("segger");
pub const spi = @import("spi");
pub const uart = @import("uart");
pub const ver = @import("ver");
pub const wifi = switch (currentTarget) {
    .esp32h2, .esp32h21, .esp32h4, .esp32p4 => @compileError("Wifi unsupported!"),
    else => @import("wifi"),
};
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
    esp32h21,
    esp32h4,
    esp32p4,
};

// Convert compile-time target string to enum
pub const currentTarget = blk: {
    const target_str = sys.CONFIG_IDF_TARGET;
    break :blk @import("std").meta.stringToEnum(Device, target_str) orelse {
        @compileError("Unknown ESP32 device target: " ++ target_str);
    };
};

// Check all imports
comptime {
    _ = sys;
    _ = bl;
    _ = bt;
    _ = crc;
    _ = err;
    _ = gpio;
    _ = heap;
    _ = http;
    _ = i2c;
    _ = i2s;
    _ = log;
    _ = lwip;
    _ = mqtt;
    _ = esp_now;
    _ = phy;
    _ = pulse;
    _ = esp_panic;
    _ = rtos;
    _ = nvs;
    _ = partition;
    _ = sleep;
    _ = event;
    _ = wdt;
    _ = segger;
    _ = spi;
    _ = uart;
    _ = ver;
    _ = switch (currentTarget) {
        .esp32h2, .esp32h21, .esp32h4, .esp32p4 => {},
        else => wifi,
    };
    if (sys.HAS_ESP_DSP != 0) _ = dsp;
    if (sys.HAS_LED_STRIP != 0) _ = led;
}
