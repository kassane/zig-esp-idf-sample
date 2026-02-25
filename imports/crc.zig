const sys = @import("sys");

// ---------------------------------------------------------------------------
// CRC helpers — thin wrappers around the ESP-ROM implementations.
//
// All functions take a running `crc` (pass 0 for the first block) and a
// data slice, and return the updated CRC value.
//
// Le = reflected polynomial (little-endian / standard CRC convention).
// Be = non-reflected polynomial (big-endian convention).
// ---------------------------------------------------------------------------

// ── CRC-8 ─────────────────────────────────────────────────────────────────

/// CRC-8 with reflected (little-endian) polynomial.
pub fn crc8Le(crc: u8, buf: []const u8) u8 {
    return sys.esp_rom_crc8_le(crc, buf.ptr, buf.len);
}

/// CRC-8 with non-reflected (big-endian) polynomial.
pub fn crc8Be(crc: u8, buf: []const u8) u8 {
    return sys.esp_rom_crc8_be(crc, buf.ptr, buf.len);
}

// ── CRC-16 ────────────────────────────────────────────────────────────────

/// CRC-16 with reflected (little-endian) polynomial.
pub fn crc16Le(crc: u16, buf: []const u8) u16 {
    return sys.esp_rom_crc16_le(crc, buf.ptr, buf.len);
}

/// CRC-16 with non-reflected (big-endian) polynomial.
pub fn crc16Be(crc: u16, buf: []const u8) u16 {
    return sys.esp_rom_crc16_be(crc, buf.ptr, buf.len);
}

// ── CRC-32 ────────────────────────────────────────────────────────────────

/// CRC-32 with reflected (little-endian) polynomial — compatible with
/// zlib / Ethernet / standard CRC-32.
pub fn crc32Le(crc: u32, buf: []const u8) u32 {
    return sys.esp_rom_crc32_le(crc, buf.ptr, buf.len);
}

/// CRC-32 with non-reflected (big-endian) polynomial.
pub fn crc32Be(crc: u32, buf: []const u8) u32 {
    return sys.esp_rom_crc32_be(crc, buf.ptr, buf.len);
}

// ── Zig stdlib CRC (kept for pure-Zig use without ROM calls) ──────────────
pub const zigCRC32 = @import("std").hash.crc;
