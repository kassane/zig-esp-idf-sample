const sys = @import("sys");

pub const crc8 = sys.esp_rom_crc8;
pub const crc16 = sys.esp_rom_crc16;
pub const crc32 = sys.esp_rom_crc32;
pub const zigCRC32 = @import("std").hash.crc;
