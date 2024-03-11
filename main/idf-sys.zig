//! esp-idf headers 'zig translate-c' v0.12.0 for xtensa target (re-edited by @kassane)

const std = @import("std");

pub const va_list = extern struct {
    __va_stk: [*c]c_int = std.mem.zeroes([*c]c_int),
    __va_reg: [*c]c_int = std.mem.zeroes([*c]c_int),
    __va_ndx: c_int = std.mem.zeroes(c_int),
};

// Alocator for use with raw_heap_caps_allocator
pub const raw_heap_caps_allocator: std.mem.Allocator = .{
    .ptr = undefined,
    .vtable = &raw_heap_caps_allocator_vtable,
};
const raw_heap_caps_allocator_vtable = std.mem.Allocator.VTable{
    .alloc = rawHeapCapsAlloc,
    .resize = rawHeapCapsResize,
    .free = rawHeapCapsFree,
};

fn rawHeapCapsAlloc(
    _: *anyopaque,
    len: usize,
    log2_ptr_align: u8,
    ret_addr: usize,
) ?[*]u8 {
    _ = ret_addr;
    std.debug.assert(log2_ptr_align <= comptime std.math.log2_int(
        usize,
        @alignOf(std.c.max_align_t),
    ));
    return @as(?[*]u8, @ptrCast(
        heap_caps_malloc(
            len,
            @intFromEnum(Caps.MALLOC_CAP_DEFAULT) | @intFromEnum(Caps.MALLOC_CAP_INTERNAL),
        ),
    ));
}

fn rawHeapCapsResize(
    _: *anyopaque,
    buf: []u8,
    log2_old_align: u8,
    new_len: usize,
    ret_addr: usize,
) bool {
    _ = log2_old_align;
    _ = ret_addr;

    if (new_len <= buf.len)
        return true;

    const full_len = if (@TypeOf(heap_caps_get_allocated_size) != void)
        heap_caps_get_allocated_size(buf.ptr);
    if (new_len <= full_len) return true;

    return false;
}

fn rawHeapCapsFree(
    _: *anyopaque,
    buf: []u8,
    log2_old_align: u8,
    ret_addr: usize,
) void {
    _ = log2_old_align;
    _ = ret_addr;
    std.debug.assert(heap_caps_check_integrity_all(true));
    heap_caps_free(buf.ptr);
}
// Alocator for use with raw_multi_heap_allocator
pub const raw_multi_heap_allocator: std.mem.Allocator = .{
    .ptr = undefined,
    .vtable = &raw_multi_heap_allocator_vtable,
};
const raw_multi_heap_allocator_vtable = std.mem.Allocator.VTable{
    .alloc = rawMultiHeapAlloc,
    .resize = rawMultiHeapResize,
    .free = rawMultiHeapFree,
};

var multi_heap_alloc: multi_heap_handle_t = null;
fn rawMultiHeapAlloc(
    _: *anyopaque,
    len: usize,
    log2_ptr_align: u8,
    ret_addr: usize,
) ?[*]u8 {
    _ = ret_addr;
    std.debug.assert(log2_ptr_align <= comptime std.math.log2_int(
        usize,
        @alignOf(std.c.max_align_t),
    ));
    return @as(?[*]u8, @ptrCast(
        multi_heap_malloc(multi_heap_alloc, len),
    ));
}

fn rawMultiHeapResize(
    _: *anyopaque,
    buf: []u8,
    log2_old_align: u8,
    new_len: usize,
    ret_addr: usize,
) bool {
    _ = log2_old_align;
    _ = ret_addr;

    if (new_len <= buf.len)
        return true;

    if (@TypeOf(multi_heap_get_allocated_size) != void)
        if (new_len <= multi_heap_get_allocated_size(multi_heap_alloc, buf.ptr))
            return true;

    return false;
}

fn rawMultiHeapFree(
    _: *anyopaque,
    buf: []u8,
    log2_old_align: u8,
    ret_addr: usize,
) void {
    _ = log2_old_align;
    _ = ret_addr;
    defer std.debug.assert(multi_heap_check(multi_heap_alloc, true));
    multi_heap_free(multi_heap_alloc, buf.ptr);
}

// C error
pub const esp_err_t = enum(c_int) {
    ESP_OK = 0,
    ESP_FAIL = -1,
    ESP_ERR_NO_MEM = 0x101,
    ESP_ERR_INVALID_ARG = 0x102,
    ESP_ERR_INVALID_STATE = 0x103,
    ESP_ERR_INVALID_SIZE = 0x104,
    ESP_ERR_NOT_FOUND = 0x105,
    ESP_ERR_NOT_SUPPORTED = 0x106,
    ESP_ERR_TIMEOUT = 0x107,
    ESP_ERR_INVALID_RESPONSE = 0x108,
    ESP_ERR_INVALID_CRC = 0x109,
    ESP_ERR_INVALID_VERSION = 0x10A,
    ESP_ERR_INVALID_MAC = 0x10B,
    ESP_ERR_NOT_FINISHED = 0x10C,
    ESP_ERR_NOT_ALLOWED = 0x10D,
    ESP_ERR_WIFI_BASE = 0x3000,
    ESP_ERR_MESH_BASE = 0x4000,
    ESP_ERR_FLASH_BASE = 0x6000,
    ESP_ERR_HW_CRYPTO_BASE = 0xc000,
    ESP_ERR_MEMPROT_BASE = 0xd000,
};

// Zig error
const esp_error = error{
    Fail,
    ErrorNoMem,
    ErrorInvalidArg,
    ErrorInvalidState,
    ErrorInvalidSize,
    ErrorNotFound,
    ErrorNotSupported,
    ErrorTimeout,
    ErrorInvalidResponse,
    ErrorInvalidCRC,
    ErrorInvalidVersion,
    ErrorInvalidMAC,
    ErrorNotFinished,
    ErrorNotAllowed,
    ErrorWiFiBase,
    ErrorMeshBase,
    ErrorFlashBase,
    ErrorHWCryptoBase,
    ErrorMemProtectBase,
};

// C to Zig error
pub fn espError(err: esp_err_t) esp_error!esp_err_t {
    return switch (err) {
        .ESP_FAIL => esp_error.Fail,
        .ESP_ERR_NO_MEM => esp_error.ErrorNoMem,
        .ESP_ERR_INVALID_ARG => esp_error.ErrorInvalidArg,
        .ESP_ERR_INVALID_STATE => esp_error.ErrorInvalidState,
        .ESP_ERR_INVALID_SIZE => esp_error.ErrorInvalidSize,
        .ESP_ERR_NOT_FOUND => esp_error.ErrorNotFound,
        .ESP_ERR_NOT_SUPPORTED => esp_error.ErrorNotSupported,
        .ESP_ERR_TIMEOUT => esp_error.ErrorTimeout,
        .ESP_ERR_INVALID_RESPONSE => esp_error.ErrorInvalidResponse,
        .ESP_ERR_INVALID_CRC => esp_error.ErrorInvalidCRC,
        .ESP_ERR_INVALID_VERSION => esp_error.ErrorInvalidVersion,
        .ESP_ERR_INVALID_MAC => esp_error.ErrorInvalidMAC,
        .ESP_ERR_NOT_FINISHED => esp_error.ErrorNotFinished,
        .ESP_ERR_NOT_ALLOWED => esp_error.ErrorNotAllowed,
        .ESP_ERR_WIFI_BASE => esp_error.ErrorWiFiBase,
        .ESP_ERR_MESH_BASE => esp_error.ErrorMeshBase,
        .ESP_ERR_FLASH_BASE => esp_error.ErrorFlashBase,
        .ESP_ERR_HW_CRYPTO_BASE => esp_error.ErrorHWCryptoBase,
        .ESP_ERR_MEMPROT_BASE => esp_error.ErrorMemProtectBase,
        else => .ESP_OK,
    };
}

pub fn espCheckError(errc: esp_err_t) esp_error!void {
    if (try espError(errc) == esp_err_t.ESP_OK)
        return;
}
pub extern fn esp_err_to_name(code: esp_err_t) [*:0]const u8;
pub extern fn esp_err_to_name_r(code: esp_err_t, buf: [*:0]u8, buflen: usize) [*:0]const u8;
pub extern fn _esp_error_check_failed(rc: esp_err_t, file: [*:0]const u8, line: c_int, function: [*:0]const u8, expression: [*:0]const u8) noreturn;
pub extern fn _esp_error_check_failed_without_abort(rc: esp_err_t, file: [*:0]const u8, line: c_int, function: [*:0]const u8, expression: [*:0]const u8) void;
pub extern fn esp_get_idf_version() [*:0]const u8;
pub const esp_reset_reason_t = enum(c_uint) {
    ESP_RST_UNKNOWN = 0,
    ESP_RST_POWERON = 1,
    ESP_RST_EXT = 2,
    ESP_RST_SW = 3,
    ESP_RST_PANIC = 4,
    ESP_RST_INT_WDT = 5,
    ESP_RST_TASK_WDT = 6,
    ESP_RST_WDT = 7,
    ESP_RST_DEEPSLEEP = 8,
    ESP_RST_BROWNOUT = 9,
    ESP_RST_SDIO = 10,
    ESP_RST_USB = 11,
    ESP_RST_JTAG = 12,
};
pub const shutdown_handler_t = ?*const fn () callconv(.C) void;
extern fn esp_register_shutdown_handler(handle: shutdown_handler_t) esp_err_t;
pub fn espRegisterShutdownHandler(handle: shutdown_handler_t) !void {
    try espCheckError(esp_register_shutdown_handler(handle));
}
extern fn esp_unregister_shutdown_handler(handle: shutdown_handler_t) esp_err_t;
pub fn espUnregisterShutdownHandler(handle: shutdown_handler_t) !void {
    try espCheckError(esp_unregister_shutdown_handler(handle));
}
// fixme: need to find a way to get the esp_chip_info_t
// pub const esp_chip_model_t = enum(c_uint) {
//     CHIP_ESP32 = 1,
//     CHIP_ESP32S2 = 2,
//     CHIP_ESP32S3 = 9,
//     CHIP_ESP32C3 = 5,
//     CHIP_ESP32C2 = 12,
//     CHIP_ESP32C6 = 13,
//     CHIP_ESP32H2 = 16,
//     CHIP_ESP32C5 = 17,
//     CHIP_ESP32P4 = 18,
//     CHIP_POSIX_LINUX = 999,
// };
// pub const esp_chip_info_t = extern struct {
//     model: esp_chip_model_t = std.mem.zeroes(esp_chip_model_t),
//     features: u32 = std.mem.zeroes(u32),
//     revision: u16 = std.mem.zeroes(u16),
//     cores: u8 = std.mem.zeroes(u8),
// };
// pub const CHIP_FEATURE_EMB_FLASH = BIT(@as(c_int, 0));
// pub const CHIP_FEATURE_WIFI_BGN = BIT(@as(c_int, 1));
// pub const CHIP_FEATURE_BLE = BIT(@as(c_int, 4));
// pub const CHIP_FEATURE_BT = BIT(@as(c_int, 5));
// pub const CHIP_FEATURE_IEEE802154 = BIT(@as(c_int, 6));
// pub const CHIP_FEATURE_EMB_PSRAM = BIT(@as(c_int, 7));
// pub inline fn BIT(nr: anytype) @TypeOf(@as(c_ulong, 1) << nr) {
//     _ = &nr;
//     return @as(c_ulong, 1) << nr;
// }
// pub extern fn esp_chip_info(out_info: [*c]esp_chip_info_t) void;
pub extern fn esp_restart() noreturn;
pub extern fn esp_reset_reason() esp_reset_reason_t;
pub extern fn esp_get_free_heap_size() u32;
pub extern fn esp_get_free_internal_heap_size() u32;
pub extern fn esp_get_minimum_free_heap_size() u32;
pub extern fn esp_system_abort(details: [*:0]const u8) noreturn;
pub extern fn esp_rom_crc32_le(crc: u32, buf: [*:0]const u8, len: u32) u32;
pub extern fn esp_rom_crc32_be(crc: u32, buf: [*:0]const u8, len: u32) u32;
pub extern fn esp_rom_crc16_le(crc: u16, buf: [*:0]const u8, len: u32) u16;
pub extern fn esp_rom_crc16_be(crc: u16, buf: [*:0]const u8, len: u32) u16;
pub extern fn esp_rom_crc8_le(crc: u8, buf: [*:0]const u8, len: u32) u8;
pub extern fn esp_rom_crc8_be(crc: u8, buf: [*:0]const u8, len: u32) u8;
pub const soc_reset_reason_t = enum(c_uint) {
    RESET_REASON_CHIP_POWER_ON = 1,
    RESET_REASON_CORE_SW = 3,
    RESET_REASON_CORE_DEEP_SLEEP = 5,
    RESET_REASON_CORE_SDIO = 6,
    RESET_REASON_CORE_MWDT0 = 7,
    RESET_REASON_CORE_MWDT1 = 8,
    RESET_REASON_CORE_RTC_WDT = 9,
    RESET_REASON_CPU0_MWDT0 = 11,
    RESET_REASON_CPU1_MWDT1 = 11,
    RESET_REASON_CPU0_SW = 12,
    RESET_REASON_CPU1_SW = 12,
    RESET_REASON_CPU0_RTC_WDT = 13,
    RESET_REASON_CPU1_RTC_WDT = 13,
    RESET_REASON_CPU1_CPU0 = 14,
    RESET_REASON_SYS_BROWN_OUT = 15,
    RESET_REASON_SYS_RTC_WDT = 16,
};
pub extern fn esp_rom_software_reset_system() void;
pub extern fn esp_rom_software_reset_cpu(cpu_no: c_int) void;
pub extern fn esp_rom_printf(fmt: [*:0]const u8, ...) c_int;
pub extern fn esp_rom_delay_us(us: u32) void;
pub extern fn esp_rom_install_channel_putc(channel: c_int, putc: ?*const fn (u8) callconv(.C) void) void;
pub extern fn esp_rom_install_uart_printf() void;
pub extern fn esp_rom_get_reset_reason(cpu_no: c_int) soc_reset_reason_t;
pub extern fn esp_rom_route_intr_matrix(cpu_core: c_int, periph_intr_id: u32, cpu_intr_num: u32) void;
pub extern fn esp_rom_get_cpu_ticks_per_us() u32;
pub extern fn esp_rom_set_cpu_ticks_per_us(ticks_per_us: u32) void;
const esp_log_level_t = enum(c_uint) {
    ESP_LOG_NONE = 0,
    ESP_LOG_ERROR = 1,
    ESP_LOG_WARN = 2,
    ESP_LOG_INFO = 3,
    ESP_LOG_DEBUG = 4,
    ESP_LOG_VERBOSE = 5,
};
const default_level: esp_log_level_t = switch (@import("builtin").mode) {
    .Debug => .ESP_LOG_DEBUG,
    .ReleaseSafe => .ESP_LOG_INFO,
    .ReleaseFast, .ReleaseSmall => .ESP_LOG_ERROR,
};
pub fn ESP_LOGI(allocator: std.mem.Allocator, tag: [*:0]const u8, comptime cfmt: []const u8, args: anytype) void {
    const fmt = std.fmt.allocPrintZ(allocator, cfmt, args) catch |err| @errorName(err);
    esp_log_write(default_level, tag, fmt, esp_log_timestamp(), tag);
}
pub const LOG_COLOR_BLACK = "30";
pub const LOG_COLOR_RED = "31";
pub const LOG_COLOR_GREEN = "32";
pub const LOG_COLOR_BROWN = "33";
pub const LOG_COLOR_BLUE = "34";
pub const LOG_COLOR_PURPLE = "35";
pub const LOG_COLOR_CYAN = "36";
pub inline fn LOG_COLOR(COLOR: anytype) @TypeOf("\x1b[0;" ++ COLOR ++ "m") {
    _ = &COLOR;
    return "\x1b[0;" ++ COLOR ++ "m";
}
pub inline fn LOG_BOLD(COLOR: anytype) @TypeOf("\x1b[1;" ++ COLOR ++ "m") {
    _ = &COLOR;
    return "\x1b[1;" ++ COLOR ++ "m";
}
pub const LOG_RESET_COLOR = "\x1b[0m";
pub const LOG_COLOR_E = LOG_COLOR(LOG_COLOR_RED);
pub const LOG_COLOR_W = LOG_COLOR(LOG_COLOR_BROWN);
pub const LOG_COLOR_I = LOG_COLOR(LOG_COLOR_GREEN);
pub const vprintf_like_t = ?*const fn ([*:0]const u8, va_list) callconv(.C) c_int;
pub extern var esp_log_default_level: esp_log_level_t;
pub extern fn esp_log_level_set(tag: [*:0]const u8, level: esp_log_level_t) void;
pub extern fn esp_log_level_get(tag: [*:0]const u8) esp_log_level_t;
pub extern fn esp_log_set_vprintf(func: vprintf_like_t) vprintf_like_t;
pub extern fn esp_log_timestamp() u32;
pub extern fn esp_log_system_timestamp() [*:0]u8;
pub extern fn esp_log_early_timestamp() u32;
pub extern fn esp_log_write(level: esp_log_level_t, tag: [*:0]const u8, format: [*:0]const u8, ...) void;
pub extern fn esp_log_writev(level: esp_log_level_t, tag: [*:0]const u8, format: [*:0]const u8, args: va_list) void;
pub extern fn esp_log_buffer_hex_internal(tag: [*:0]const u8, buffer: ?*const anyopaque, buff_len: u16, level: esp_log_level_t) void;
pub extern fn esp_log_buffer_char_internal(tag: [*:0]const u8, buffer: ?*const anyopaque, buff_len: u16, level: esp_log_level_t) void;
pub extern fn esp_log_buffer_hexdump_internal(tag: [*:0]const u8, buffer: ?*const anyopaque, buff_len: u16, log_level: esp_log_level_t) void;
pub const periph_interrput_t = enum(c_uint) {
    ETS_WIFI_MAC_INTR_SOURCE = 0,
    ETS_WIFI_MAC_NMI_SOURCE = 1,
    ETS_WIFI_BB_INTR_SOURCE = 2,
    ETS_BT_MAC_INTR_SOURCE = 3,
    ETS_BT_BB_INTR_SOURCE = 4,
    ETS_BT_BB_NMI_SOURCE = 5,
    ETS_RWBT_INTR_SOURCE = 6,
    ETS_RWBLE_INTR_SOURCE = 7,
    ETS_RWBT_NMI_SOURCE = 8,
    ETS_RWBLE_NMI_SOURCE = 9,
    ETS_SLC0_INTR_SOURCE = 10,
    ETS_SLC1_INTR_SOURCE = 11,
    ETS_UHCI0_INTR_SOURCE = 12,
    ETS_UHCI1_INTR_SOURCE = 13,
    ETS_TG0_T0_LEVEL_INTR_SOURCE = 14,
    ETS_TG0_T1_LEVEL_INTR_SOURCE = 15,
    ETS_TG0_WDT_LEVEL_INTR_SOURCE = 16,
    ETS_TG0_LACT_LEVEL_INTR_SOURCE = 17,
    ETS_TG1_T0_LEVEL_INTR_SOURCE = 18,
    ETS_TG1_T1_LEVEL_INTR_SOURCE = 19,
    ETS_TG1_WDT_LEVEL_INTR_SOURCE = 20,
    ETS_TG1_LACT_LEVEL_INTR_SOURCE = 21,
    ETS_GPIO_INTR_SOURCE = 22,
    ETS_GPIO_NMI_SOURCE = 23,
    ETS_FROM_CPU_INTR0_SOURCE = 24,
    ETS_FROM_CPU_INTR1_SOURCE = 25,
    ETS_FROM_CPU_INTR2_SOURCE = 26,
    ETS_FROM_CPU_INTR3_SOURCE = 27,
    ETS_SPI0_INTR_SOURCE = 28,
    ETS_SPI1_INTR_SOURCE = 29,
    ETS_SPI2_INTR_SOURCE = 30,
    ETS_SPI3_INTR_SOURCE = 31,
    ETS_I2S0_INTR_SOURCE = 32,
    ETS_I2S1_INTR_SOURCE = 33,
    ETS_UART0_INTR_SOURCE = 34,
    ETS_UART1_INTR_SOURCE = 35,
    ETS_UART2_INTR_SOURCE = 36,
    ETS_SDIO_HOST_INTR_SOURCE = 37,
    ETS_ETH_MAC_INTR_SOURCE = 38,
    ETS_PWM0_INTR_SOURCE = 39,
    ETS_PWM1_INTR_SOURCE = 40,
    ETS_LEDC_INTR_SOURCE = 43,
    ETS_EFUSE_INTR_SOURCE = 44,
    ETS_TWAI_INTR_SOURCE = 45,
    ETS_RTC_CORE_INTR_SOURCE = 46,
    ETS_RMT_INTR_SOURCE = 47,
    ETS_PCNT_INTR_SOURCE = 48,
    ETS_I2C_EXT0_INTR_SOURCE = 49,
    ETS_I2C_EXT1_INTR_SOURCE = 50,
    ETS_RSA_INTR_SOURCE = 51,
    ETS_SPI1_DMA_INTR_SOURCE = 52,
    ETS_SPI2_DMA_INTR_SOURCE = 53,
    ETS_SPI3_DMA_INTR_SOURCE = 54,
    ETS_WDT_INTR_SOURCE = 55,
    ETS_TIMER1_INTR_SOURCE = 56,
    ETS_TIMER2_INTR_SOURCE = 57,
    ETS_TG0_T0_EDGE_INTR_SOURCE = 58,
    ETS_TG0_T1_EDGE_INTR_SOURCE = 59,
    ETS_TG0_WDT_EDGE_INTR_SOURCE = 60,
    ETS_TG0_LACT_EDGE_INTR_SOURCE = 61,
    ETS_TG1_T0_EDGE_INTR_SOURCE = 62,
    ETS_TG1_T1_EDGE_INTR_SOURCE = 63,
    ETS_TG1_WDT_EDGE_INTR_SOURCE = 64,
    ETS_TG1_LACT_EDGE_INTR_SOURCE = 65,
    ETS_MMU_IA_INTR_SOURCE = 66,
    ETS_MPU_IA_INTR_SOURCE = 67,
    ETS_CACHE_IA_INTR_SOURCE = 68,
    ETS_MAX_INTR_SOURCE = 69,
};
pub extern const esp_isr_names: [69][*c]const u8;
pub extern const Xthal_rev_no: c_uint;
pub extern fn xthal_save_extra(base: ?*anyopaque) void;
pub extern fn xthal_restore_extra(base: ?*anyopaque) void;
pub extern fn xthal_save_cpregs(base: ?*anyopaque, c_int) void;
pub extern fn xthal_restore_cpregs(base: ?*anyopaque, c_int) void;
pub extern fn xthal_save_cp0(base: ?*anyopaque) void;
pub extern fn xthal_save_cp1(base: ?*anyopaque) void;
pub extern fn xthal_save_cp2(base: ?*anyopaque) void;
pub extern fn xthal_save_cp3(base: ?*anyopaque) void;
pub extern fn xthal_save_cp4(base: ?*anyopaque) void;
pub extern fn xthal_save_cp5(base: ?*anyopaque) void;
pub extern fn xthal_save_cp6(base: ?*anyopaque) void;
pub extern fn xthal_save_cp7(base: ?*anyopaque) void;
pub extern fn xthal_restore_cp0(base: ?*anyopaque) void;
pub extern fn xthal_restore_cp1(base: ?*anyopaque) void;
pub extern fn xthal_restore_cp2(base: ?*anyopaque) void;
pub extern fn xthal_restore_cp3(base: ?*anyopaque) void;
pub extern fn xthal_restore_cp4(base: ?*anyopaque) void;
pub extern fn xthal_restore_cp5(base: ?*anyopaque) void;
pub extern fn xthal_restore_cp6(base: ?*anyopaque) void;
pub extern fn xthal_restore_cp7(base: ?*anyopaque) void;
pub extern var Xthal_cpregs_save_fn: [8]?*anyopaque;
pub extern var Xthal_cpregs_restore_fn: [8]?*anyopaque;
pub extern var Xthal_cpregs_save_nw_fn: [8]?*anyopaque;
pub extern var Xthal_cpregs_restore_nw_fn: [8]?*anyopaque;
pub extern const Xthal_extra_size: c_uint;
pub extern const Xthal_extra_align: c_uint;
pub extern const Xthal_cpregs_size: [8]c_uint;
pub extern const Xthal_cpregs_align: [8]c_uint;
pub extern const Xthal_all_extra_size: c_uint;
pub extern const Xthal_all_extra_align: c_uint;
pub extern const Xthal_cp_names: [8][*c]const u8;
pub extern fn xthal_init_mem_extra(?*anyopaque) void;
pub extern fn xthal_init_mem_cp(?*anyopaque, c_int) void;
pub extern const Xthal_num_coprocessors: c_uint;
pub extern const Xthal_cp_num: u8;
pub extern const Xthal_cp_max: u8;
pub extern const Xthal_cp_mask: c_uint;
pub extern const Xthal_num_aregs: c_uint;
pub extern const Xthal_num_aregs_log2: u8;
pub extern const Xthal_icache_linewidth: u8;
pub extern const Xthal_dcache_linewidth: u8;
pub extern const Xthal_icache_linesize: c_ushort;
pub extern const Xthal_dcache_linesize: c_ushort;
pub extern const Xthal_icache_size: c_uint;
pub extern const Xthal_dcache_size: c_uint;
pub extern const Xthal_dcache_is_writeback: u8;
pub extern fn xthal_icache_region_invalidate(addr: ?*anyopaque, size: c_uint) void;
pub extern fn xthal_dcache_region_invalidate(addr: ?*anyopaque, size: c_uint) void;
pub extern fn xthal_dcache_region_writeback(addr: ?*anyopaque, size: c_uint) void;
pub extern fn xthal_dcache_region_writeback_inv(addr: ?*anyopaque, size: c_uint) void;
pub extern fn xthal_icache_line_invalidate(addr: ?*anyopaque) void;
pub extern fn xthal_dcache_line_invalidate(addr: ?*anyopaque) void;
pub extern fn xthal_dcache_line_writeback(addr: ?*anyopaque) void;
pub extern fn xthal_dcache_line_writeback_inv(addr: ?*anyopaque) void;
pub extern fn xthal_icache_sync() void;
pub extern fn xthal_dcache_sync() void;
pub extern fn xthal_icache_get_ways() c_uint;
pub extern fn xthal_icache_set_ways(ways: c_uint) void;
pub extern fn xthal_dcache_get_ways() c_uint;
pub extern fn xthal_dcache_set_ways(ways: c_uint) void;
pub extern fn xthal_cache_coherence_on() void;
pub extern fn xthal_cache_coherence_off() void;
pub extern fn xthal_cache_coherence_optin() void;
pub extern fn xthal_cache_coherence_optout() void;
pub extern fn xthal_get_cache_prefetch() c_int;
pub extern fn xthal_set_cache_prefetch(c_int) c_int;
pub extern fn xthal_set_cache_prefetch_long(c_ulonglong) c_int;
pub extern const Xthal_debug_configured: c_int;
pub extern fn xthal_set_soft_break(addr: ?*anyopaque) c_uint;
pub extern fn xthal_remove_soft_break(addr: ?*anyopaque, c_uint) void;
pub extern fn xthal_disassemble(instr_buf: [*:0]u8, tgt_addr: ?*anyopaque, buffer: [*:0]u8, buflen: c_uint, options: c_uint) c_int;
pub extern fn xthal_disassemble_size(instr_buf: [*:0]u8) c_int;
pub extern fn xthal_memcpy(dst: ?*anyopaque, src: ?*const anyopaque, len: c_uint) ?*anyopaque;
pub extern fn xthal_bcopy(src: ?*const anyopaque, dst: ?*anyopaque, len: c_uint) ?*anyopaque;
pub extern fn xthal_compare_and_set(addr: [*c]c_int, test_val: c_int, compare_val: c_int) c_int;
pub extern const Xthal_release_major: c_uint;
pub extern const Xthal_release_minor: c_uint;
pub extern const Xthal_release_name: [*:0]const u8;
pub extern const Xthal_release_internal: [*:0]const u8;
pub extern const Xthal_memory_order: u8;
pub extern const Xthal_have_windowed: u8;
pub extern const Xthal_have_density: u8;
pub extern const Xthal_have_booleans: u8;
pub extern const Xthal_have_loops: u8;
pub extern const Xthal_have_nsa: u8;
pub extern const Xthal_have_minmax: u8;
pub extern const Xthal_have_sext: u8;
pub extern const Xthal_have_clamps: u8;
pub extern const Xthal_have_mac16: u8;
pub extern const Xthal_have_mul16: u8;
pub extern const Xthal_have_fp: u8;
pub extern const Xthal_have_speculation: u8;
pub extern const Xthal_have_threadptr: u8;
pub extern const Xthal_have_pif: u8;
pub extern const Xthal_num_writebuffer_entries: c_ushort;
pub extern const Xthal_build_unique_id: c_uint;
pub extern const Xthal_hw_configid0: c_uint;
pub extern const Xthal_hw_configid1: c_uint;
pub extern const Xthal_hw_release_major: c_uint;
pub extern const Xthal_hw_release_minor: c_uint;
pub extern const Xthal_hw_release_name: [*:0]const u8;
pub extern const Xthal_hw_release_internal: [*:0]const u8;
pub extern fn xthal_clear_regcached_code() void;
pub extern fn xthal_window_spill() void;
pub extern fn xthal_validate_cp(c_int) void;
pub extern fn xthal_invalidate_cp(c_int) void;
pub extern fn xthal_set_cpenable(c_uint) void;
pub extern fn xthal_get_cpenable() c_uint;
pub extern const Xthal_num_intlevels: u8;
pub extern const Xthal_num_interrupts: u8;
pub extern const Xthal_excm_level: u8;
pub extern const Xthal_intlevel_mask: [16]c_uint;
pub extern const Xthal_intlevel_andbelow_mask: [16]c_uint;
pub extern const Xthal_intlevel: [32]u8;
pub extern const Xthal_inttype: [32]u8;
pub extern const Xthal_inttype_mask: [11]c_uint;
pub extern const Xthal_timer_interrupt: [4]c_int;
pub extern fn xthal_get_intenable() c_uint;
pub extern fn xthal_set_intenable(c_uint) void;
pub extern fn xthal_get_interrupt() c_uint;
pub extern fn xthal_set_intset(c_uint) void;
pub extern fn xthal_set_intclear(c_uint) void;
pub extern const Xthal_num_ibreak: c_int;
pub extern const Xthal_num_dbreak: c_int;
pub extern const Xthal_have_ccount: u8;
pub extern const Xthal_num_ccompare: u8;
pub extern fn xthal_get_ccount() c_uint;
pub extern fn xthal_set_ccompare(c_int, c_uint) void;
pub extern fn xthal_get_ccompare(c_int) c_uint;
pub extern const Xthal_have_prid: u8;
pub extern const Xthal_have_exceptions: u8;
pub extern const Xthal_xea_version: u8;
pub extern const Xthal_have_interrupts: u8;
pub extern const Xthal_have_highlevel_interrupts: u8;
pub extern const Xthal_have_nmi: u8;
pub extern fn xthal_get_prid() c_uint;
pub extern fn xthal_vpri_to_intlevel(vpri: c_uint) c_uint;
pub extern fn xthal_intlevel_to_vpri(intlevel: c_uint) c_uint;
pub extern fn xthal_int_enable(c_uint) c_uint;
pub extern fn xthal_int_disable(c_uint) c_uint;
pub extern fn xthal_set_int_vpri(intnum: c_int, vpri: c_int) c_int;
pub extern fn xthal_get_int_vpri(intnum: c_int) c_int;
pub extern fn xthal_set_vpri_locklevel(intlevel: c_uint) void;
pub extern fn xthal_get_vpri_locklevel() c_uint;
pub extern fn xthal_set_vpri(vpri: c_uint) c_uint;
pub extern fn xthal_get_vpri() c_uint;
pub extern fn xthal_set_vpri_intlevel(intlevel: c_uint) c_uint;
pub extern fn xthal_set_vpri_lock() c_uint;
pub const XtHalVoidFunc = fn () callconv(.C) void;
pub extern var Xthal_tram_pending: c_uint;
pub extern var Xthal_tram_enabled: c_uint;
pub extern var Xthal_tram_sync: c_uint;
pub extern fn xthal_tram_pending_to_service() c_uint;
pub extern fn xthal_tram_done(serviced_mask: c_uint) void;
pub extern fn xthal_tram_set_sync(intnum: c_int, sync: c_int) c_int;
pub extern fn xthal_set_tram_trigger_func(trigger_fn: ?*const XtHalVoidFunc) ?*const XtHalVoidFunc;
pub extern const Xthal_num_instrom: u8;
pub extern const Xthal_num_instram: u8;
pub extern const Xthal_num_datarom: u8;
pub extern const Xthal_num_dataram: u8;
pub extern const Xthal_num_xlmi: u8;
pub const Xthal_instrom_vaddr: [*c]const c_uint = @extern([*c]const c_uint, .{
    .name = "Xthal_instrom_vaddr",
});
pub const Xthal_instrom_paddr: [*c]const c_uint = @extern([*c]const c_uint, .{
    .name = "Xthal_instrom_paddr",
});
pub const Xthal_instrom_size: [*c]const c_uint = @extern([*c]const c_uint, .{
    .name = "Xthal_instrom_size",
});
pub const Xthal_instram_vaddr: [*c]const c_uint = @extern([*c]const c_uint, .{
    .name = "Xthal_instram_vaddr",
});
pub const Xthal_instram_paddr: [*c]const c_uint = @extern([*c]const c_uint, .{
    .name = "Xthal_instram_paddr",
});
pub const Xthal_instram_size: [*c]const c_uint = @extern([*c]const c_uint, .{
    .name = "Xthal_instram_size",
});
pub const Xthal_datarom_vaddr: [*c]const c_uint = @extern([*c]const c_uint, .{
    .name = "Xthal_datarom_vaddr",
});
pub const Xthal_datarom_paddr: [*c]const c_uint = @extern([*c]const c_uint, .{
    .name = "Xthal_datarom_paddr",
});
pub const Xthal_datarom_size: [*c]const c_uint = @extern([*c]const c_uint, .{
    .name = "Xthal_datarom_size",
});
pub const Xthal_dataram_vaddr: [*c]const c_uint = @extern([*c]const c_uint, .{
    .name = "Xthal_dataram_vaddr",
});
pub const Xthal_dataram_paddr: [*c]const c_uint = @extern([*c]const c_uint, .{
    .name = "Xthal_dataram_paddr",
});
pub const Xthal_dataram_size: [*c]const c_uint = @extern([*c]const c_uint, .{
    .name = "Xthal_dataram_size",
});
pub const Xthal_xlmi_vaddr: [*c]const c_uint = @extern([*c]const c_uint, .{
    .name = "Xthal_xlmi_vaddr",
});
pub const Xthal_xlmi_paddr: [*c]const c_uint = @extern([*c]const c_uint, .{
    .name = "Xthal_xlmi_paddr",
});
pub const Xthal_xlmi_size: [*c]const c_uint = @extern([*c]const c_uint, .{
    .name = "Xthal_xlmi_size",
});
pub extern const Xthal_icache_setwidth: u8;
pub extern const Xthal_dcache_setwidth: u8;
pub extern const Xthal_icache_ways: c_uint;
pub extern const Xthal_dcache_ways: c_uint;
pub extern const Xthal_icache_line_lockable: u8;
pub extern const Xthal_dcache_line_lockable: u8;
pub extern fn xthal_get_cacheattr() c_uint;
pub extern fn xthal_get_icacheattr() c_uint;
pub extern fn xthal_get_dcacheattr() c_uint;
pub extern fn xthal_set_cacheattr(c_uint) void;
pub extern fn xthal_set_icacheattr(c_uint) void;
pub extern fn xthal_set_dcacheattr(c_uint) void;
pub extern fn xthal_set_region_attribute(addr: ?*anyopaque, size: c_uint, cattr: c_uint, flags: c_uint) c_int;
pub extern fn xthal_icache_enable() void;
pub extern fn xthal_dcache_enable() void;
pub extern fn xthal_icache_disable() void;
pub extern fn xthal_dcache_disable() void;
pub extern fn xthal_icache_all_invalidate() void;
pub extern fn xthal_dcache_all_invalidate() void;
pub extern fn xthal_dcache_all_writeback() void;
pub extern fn xthal_dcache_all_writeback_inv() void;
pub extern fn xthal_icache_all_unlock() void;
pub extern fn xthal_dcache_all_unlock() void;
pub extern fn xthal_icache_region_lock(addr: ?*anyopaque, size: c_uint) void;
pub extern fn xthal_dcache_region_lock(addr: ?*anyopaque, size: c_uint) void;
pub extern fn xthal_icache_region_unlock(addr: ?*anyopaque, size: c_uint) void;
pub extern fn xthal_dcache_region_unlock(addr: ?*anyopaque, size: c_uint) void;
pub extern fn xthal_icache_hugerange_invalidate(addr: ?*anyopaque, size: c_uint) void;
pub extern fn xthal_icache_hugerange_unlock(addr: ?*anyopaque, size: c_uint) void;
pub extern fn xthal_dcache_hugerange_invalidate(addr: ?*anyopaque, size: c_uint) void;
pub extern fn xthal_dcache_hugerange_unlock(addr: ?*anyopaque, size: c_uint) void;
pub extern fn xthal_dcache_hugerange_writeback(addr: ?*anyopaque, size: c_uint) void;
pub extern fn xthal_dcache_hugerange_writeback_inv(addr: ?*anyopaque, size: c_uint) void;
pub extern fn xthal_icache_line_lock(addr: ?*anyopaque) void;
pub extern fn xthal_dcache_line_lock(addr: ?*anyopaque) void;
pub extern fn xthal_icache_line_unlock(addr: ?*anyopaque) void;
pub extern fn xthal_dcache_line_unlock(addr: ?*anyopaque) void;
pub extern fn xthal_memep_inject_error(addr: ?*anyopaque, size: c_int, flags: c_int) void;
pub extern const Xthal_have_spanning_way: u8;
pub extern const Xthal_have_identity_map: u8;
pub extern const Xthal_have_mimic_cacheattr: u8;
pub extern const Xthal_have_xlt_cacheattr: u8;
pub extern const Xthal_have_cacheattr: u8;
pub extern const Xthal_have_tlbs: u8;
pub extern const Xthal_mmu_asid_bits: u8;
pub extern const Xthal_mmu_asid_kernel: u8;
pub extern const Xthal_mmu_rings: u8;
pub extern const Xthal_mmu_ring_bits: u8;
pub extern const Xthal_mmu_sr_bits: u8;
pub extern const Xthal_mmu_ca_bits: u8;
pub extern const Xthal_mmu_max_pte_page_size: c_uint;
pub extern const Xthal_mmu_min_pte_page_size: c_uint;
pub extern const Xthal_itlb_way_bits: u8;
pub extern const Xthal_itlb_ways: u8;
pub extern const Xthal_itlb_arf_ways: u8;
pub extern const Xthal_dtlb_way_bits: u8;
pub extern const Xthal_dtlb_ways: u8;
pub extern const Xthal_dtlb_arf_ways: u8;
pub extern fn xthal_static_v2p(vaddr: c_uint, paddrp: [*c]c_uint) c_int;
pub extern fn xthal_static_p2v(paddr: c_uint, vaddrp: [*c]c_uint, cached: c_uint) c_int;
pub extern fn xthal_set_region_translation(vaddr: ?*anyopaque, paddr: ?*anyopaque, size: c_uint, cache_atr: c_uint, flags: c_uint) c_int;
pub extern fn xthal_v2p(?*anyopaque, [*c]?*anyopaque, [*c]c_uint, [*c]c_uint) c_int;
pub extern fn xthal_invalidate_region(addr: ?*anyopaque) c_int;
pub extern fn xthal_set_region_translation_raw(vaddr: ?*anyopaque, paddr: ?*anyopaque, cattr: c_uint) c_int;
pub const xthal_MPU_entry = extern struct {
    as: u32 = std.mem.zeroes(u32),
    at: u32 = std.mem.zeroes(u32),
};
pub const Xthal_mpu_bgmap: [*c]const xthal_MPU_entry = @extern([*c]const xthal_MPU_entry, .{
    .name = "Xthal_mpu_bgmap",
});
pub extern fn xthal_is_kernel_readable(accessRights: u32) i32;
pub extern fn xthal_is_kernel_writeable(accessRights: u32) i32;
pub extern fn xthal_is_kernel_executable(accessRights: u32) i32;
pub extern fn xthal_is_user_readable(accessRights: u32) i32;
pub extern fn xthal_is_user_writeable(accessRights: u32) i32;
pub extern fn xthal_is_user_executable(accessRights: u32) i32;
pub extern fn xthal_encode_memory_type(x: u32) c_int;
pub extern fn xthal_is_cacheable(memoryType: u32) i32;
pub extern fn xthal_is_writeback(memoryType: u32) i32;
pub extern fn xthal_is_device(memoryType: u32) i32;
pub extern fn xthal_read_map(entries: [*c]xthal_MPU_entry) i32;
pub extern fn xthal_write_map(entries: [*c]const xthal_MPU_entry, n: u32) void;
pub extern fn xthal_check_map(entries: [*c]const xthal_MPU_entry, n: u32) c_int;
pub extern fn xthal_get_entry_for_address(vaddr: ?*anyopaque, infgmap: [*c]i32) xthal_MPU_entry;
pub extern fn xthal_calc_cacheadrdis(e: [*c]const xthal_MPU_entry, n: u32) u32;
pub extern fn xthal_mpu_set_region_attribute(vaddr: ?*anyopaque, size: usize, accessRights: i32, memoryType: i32, flags: u32) c_int;
pub extern fn xthal_read_background_map(entries: [*c]xthal_MPU_entry) i32;
pub extern const Xthal_cp_id_FPU: u8;
pub extern const Xthal_cp_mask_FPU: c_uint;
pub extern const Xthal_cp_id_XCHAL_CP1_IDENT: u8;
pub extern const Xthal_cp_mask_XCHAL_CP1_IDENT: c_uint;
pub extern const Xthal_cp_id_XCHAL_CP2_IDENT: u8;
pub extern const Xthal_cp_mask_XCHAL_CP2_IDENT: c_uint;
pub extern const Xthal_cp_id_XCHAL_CP3_IDENT: u8;
pub extern const Xthal_cp_mask_XCHAL_CP3_IDENT: c_uint;
pub extern const Xthal_cp_id_XCHAL_CP4_IDENT: u8;
pub extern const Xthal_cp_mask_XCHAL_CP4_IDENT: c_uint;
pub extern const Xthal_cp_id_XCHAL_CP5_IDENT: u8;
pub extern const Xthal_cp_mask_XCHAL_CP5_IDENT: c_uint;
pub extern const Xthal_cp_id_XCHAL_CP6_IDENT: u8;
pub extern const Xthal_cp_mask_XCHAL_CP6_IDENT: c_uint;
pub extern const Xthal_cp_id_XCHAL_CP7_IDENT: u8;
pub extern const Xthal_cp_mask_XCHAL_CP7_IDENT: c_uint;
pub const KernelFrame = extern struct {
    pc: c_long = std.mem.zeroes(c_long),
    ps: c_long = std.mem.zeroes(c_long),
    areg: [4]c_long = std.mem.zeroes([4]c_long),
    sar: c_long = std.mem.zeroes(c_long),
    lcount: c_long = std.mem.zeroes(c_long),
    lbeg: c_long = std.mem.zeroes(c_long),
    lend: c_long = std.mem.zeroes(c_long),
    acclo: c_long = std.mem.zeroes(c_long),
    acchi: c_long = std.mem.zeroes(c_long),
    mr: [4]c_long = std.mem.zeroes([4]c_long),
};
pub const UserFrame = extern struct {
    pc: c_long = std.mem.zeroes(c_long),
    ps: c_long = std.mem.zeroes(c_long),
    sar: c_long = std.mem.zeroes(c_long),
    vpri: c_long = std.mem.zeroes(c_long),
    a0: c_long = std.mem.zeroes(c_long),
    a2: c_long = std.mem.zeroes(c_long),
    a3: c_long = std.mem.zeroes(c_long),
    a4: c_long = std.mem.zeroes(c_long),
    a5: c_long = std.mem.zeroes(c_long),
    a6: c_long = std.mem.zeroes(c_long),
    a7: c_long = std.mem.zeroes(c_long),
    a8: c_long = std.mem.zeroes(c_long),
    a9: c_long = std.mem.zeroes(c_long),
    a10: c_long = std.mem.zeroes(c_long),
    a11: c_long = std.mem.zeroes(c_long),
    a12: c_long = std.mem.zeroes(c_long),
    a13: c_long = std.mem.zeroes(c_long),
    a14: c_long = std.mem.zeroes(c_long),
    a15: c_long = std.mem.zeroes(c_long),
    exccause: c_long = std.mem.zeroes(c_long),
    lcount: c_long = std.mem.zeroes(c_long),
    lbeg: c_long = std.mem.zeroes(c_long),
    lend: c_long = std.mem.zeroes(c_long),
    acclo: c_long = std.mem.zeroes(c_long),
    acchi: c_long = std.mem.zeroes(c_long),
    mr: [4]c_long = std.mem.zeroes([4]c_long),
    pad: [3]c_long = std.mem.zeroes([3]c_long),
};
pub const XtExcFrame = extern struct {
    exit: c_long = std.mem.zeroes(c_long),
    pc: c_long = std.mem.zeroes(c_long),
    ps: c_long = std.mem.zeroes(c_long),
    a0: c_long = std.mem.zeroes(c_long),
    a1: c_long = std.mem.zeroes(c_long),
    a2: c_long = std.mem.zeroes(c_long),
    a3: c_long = std.mem.zeroes(c_long),
    a4: c_long = std.mem.zeroes(c_long),
    a5: c_long = std.mem.zeroes(c_long),
    a6: c_long = std.mem.zeroes(c_long),
    a7: c_long = std.mem.zeroes(c_long),
    a8: c_long = std.mem.zeroes(c_long),
    a9: c_long = std.mem.zeroes(c_long),
    a10: c_long = std.mem.zeroes(c_long),
    a11: c_long = std.mem.zeroes(c_long),
    a12: c_long = std.mem.zeroes(c_long),
    a13: c_long = std.mem.zeroes(c_long),
    a14: c_long = std.mem.zeroes(c_long),
    a15: c_long = std.mem.zeroes(c_long),
    sar: c_long = std.mem.zeroes(c_long),
    exccause: c_long = std.mem.zeroes(c_long),
    excvaddr: c_long = std.mem.zeroes(c_long),
    lbeg: c_long = std.mem.zeroes(c_long),
    lend: c_long = std.mem.zeroes(c_long),
    lcount: c_long = std.mem.zeroes(c_long),
};
pub const XtSolFrame = extern struct {
    exit: c_long = std.mem.zeroes(c_long),
    pc: c_long = std.mem.zeroes(c_long),
    ps: c_long = std.mem.zeroes(c_long),
    threadptr: c_long = std.mem.zeroes(c_long),
    a12: c_long = std.mem.zeroes(c_long),
    a13: c_long = std.mem.zeroes(c_long),
    a14: c_long = std.mem.zeroes(c_long),
    a15: c_long = std.mem.zeroes(c_long),
};
pub const xt_handler = ?*const fn (?*anyopaque) callconv(.C) void;
pub const xt_exc_handler = ?*const fn ([*c]XtExcFrame) callconv(.C) void;
pub extern fn xt_set_exception_handler(n: c_int, f: xt_exc_handler) xt_exc_handler;
pub extern fn xt_set_interrupt_handler(n: c_int, f: xt_handler, arg: ?*anyopaque) xt_handler;
pub extern fn xt_ints_on(mask: c_uint) void;
pub extern fn xt_ints_off(mask: c_uint) void;
pub fn xt_set_intset(arg_arg: c_uint) callconv(.C) void {
    var arg = arg_arg;
    _ = &arg;
    xthal_set_intset(arg);
}
pub fn xt_set_intclear(arg_arg: c_uint) callconv(.C) void {
    var arg = arg_arg;
    _ = &arg;
    xthal_set_intclear(arg);
}
pub extern fn xt_get_interrupt_handler_arg(n: c_int) ?*anyopaque;
pub extern fn xt_int_has_handler(intr: c_int, cpu: c_int) bool;
pub const XtosCoreState = extern struct {
    signature: c_long = std.mem.zeroes(c_long),
    restore_label: c_long = std.mem.zeroes(c_long),
    aftersave_label: c_long = std.mem.zeroes(c_long),
    areg: [64]c_long = std.mem.zeroes([64]c_long),
    caller_regs: [16]c_long = std.mem.zeroes([16]c_long),
    caller_regs_saved: c_long = std.mem.zeroes(c_long),
    windowbase: c_long = std.mem.zeroes(c_long),
    windowstart: c_long = std.mem.zeroes(c_long),
    sar: c_long = std.mem.zeroes(c_long),
    epc1: c_long = std.mem.zeroes(c_long),
    ps: c_long = std.mem.zeroes(c_long),
    excsave1: c_long = std.mem.zeroes(c_long),
    depc: c_long = std.mem.zeroes(c_long),
    epc: [6]c_long = std.mem.zeroes([6]c_long),
    eps: [6]c_long = std.mem.zeroes([6]c_long),
    excsave: [6]c_long = std.mem.zeroes([6]c_long),
    lcount: c_long = std.mem.zeroes(c_long),
    lbeg: c_long = std.mem.zeroes(c_long),
    lend: c_long = std.mem.zeroes(c_long),
    vecbase: c_long = std.mem.zeroes(c_long),
    atomctl: c_long = std.mem.zeroes(c_long),
    memctl: c_long = std.mem.zeroes(c_long),
    ccount: c_long = std.mem.zeroes(c_long),
    ccompare: [3]c_long = std.mem.zeroes([3]c_long),
    intenable: c_long = std.mem.zeroes(c_long),
    interrupt: c_long = std.mem.zeroes(c_long),
    icount: c_long = std.mem.zeroes(c_long),
    icountlevel: c_long = std.mem.zeroes(c_long),
    debugcause: c_long = std.mem.zeroes(c_long),
    dbreakc: [2]c_long = std.mem.zeroes([2]c_long),
    dbreaka: [2]c_long = std.mem.zeroes([2]c_long),
    ibreaka: [2]c_long = std.mem.zeroes([2]c_long),
    ibreakenable: c_long = std.mem.zeroes(c_long),
    misc: [4]c_long = std.mem.zeroes([4]c_long),
    cpenable: c_long = std.mem.zeroes(c_long),
    tlbs: [16]c_long = std.mem.zeroes([16]c_long),
    ncp: [48]u8 align(4) = std.mem.zeroes([48]u8),
    cp0: [72]u8 align(4) = std.mem.zeroes([72]u8),
};
pub const _xtos_handler_func = fn () callconv(.C) void;
pub const _xtos_handler = ?*const _xtos_handler_func;
pub extern fn _xtos_ints_off(mask: c_uint) c_uint;
pub extern fn _xtos_ints_on(mask: c_uint) c_uint;
pub fn _xtos_interrupt_enable(arg_intnum: c_uint) callconv(.C) void {
    var intnum = arg_intnum;
    _ = &intnum;
    _ = _xtos_ints_on(@as(c_uint, 1) << @intCast(intnum));
}
pub fn _xtos_interrupt_disable(arg_intnum: c_uint) callconv(.C) void {
    var intnum = arg_intnum;
    _ = &intnum;
    _ = _xtos_ints_off(@as(c_uint, 1) << @intCast(intnum));
}
pub extern fn _xtos_set_intlevel(intlevel: c_int) c_uint;
pub extern fn _xtos_set_min_intlevel(intlevel: c_int) c_uint;
pub extern fn _xtos_restore_intlevel(restoreval: c_uint) c_uint;
pub extern fn _xtos_restore_just_intlevel(restoreval: c_uint) c_uint;
pub extern fn _xtos_set_interrupt_handler(n: c_int, f: _xtos_handler) _xtos_handler;
pub extern fn _xtos_set_interrupt_handler_arg(n: c_int, f: _xtos_handler, arg: ?*anyopaque) _xtos_handler;
pub extern fn _xtos_set_exception_handler(n: c_int, f: _xtos_handler) _xtos_handler;
pub extern fn _xtos_memep_initrams() void;
pub extern fn _xtos_memep_enable(flags: c_int) void;
pub extern fn _xtos_dispatch_level1_interrupts() void;
pub extern fn _xtos_dispatch_level2_interrupts() void;
pub extern fn _xtos_dispatch_level3_interrupts() void;
pub extern fn _xtos_dispatch_level4_interrupts() void;
pub extern fn _xtos_dispatch_level5_interrupts() void;
pub extern fn _xtos_dispatch_level6_interrupts() void;
pub extern fn _xtos_read_ints() c_uint;
pub extern fn _xtos_clear_ints(mask: c_uint) void;
pub extern fn _xtos_core_shutoff(flags: c_uint) c_int;
pub extern fn _xtos_core_save(flags: c_uint, savearea: [*c]XtosCoreState, code: ?*anyopaque) c_int;
pub extern fn _xtos_core_restore(retvalue: c_uint, savearea: [*c]XtosCoreState) void;
pub extern fn _xtos_timer_0_delta(cycles: c_int) void;
pub extern fn _xtos_timer_1_delta(cycles: c_int) void;
pub extern fn _xtos_timer_2_delta(cycles: c_int) void; // esp-idf/components/xtensa/include/xt_utils.h:37:5: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:28:50: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_get_core_id() u32; // esp-idf/components/xtensa/include/xt_utils.h:52:5: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:47:50: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_get_raw_core_id() u32; // esp-idf/components/xtensa/include/xt_utils.h:64:5: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:61:25: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_get_sp() ?*anyopaque; // esp-idf/components/xtensa/include/xt_instr_macros.h:11:30: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:68:28: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_get_cycle_count() u32; // esp-idf/components/xtensa/include/xt_instr_macros.h:12:30: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:75:20: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_set_cycle_count(arg_ccount: u32) callconv(.C) void; // esp-idf/components/xtensa/include/xt_utils.h:82:5: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:80:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_wait_for_intr() void; // esp-idf/components/xtensa/include/xt_utils.h:95:5: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:93:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_set_vecbase(arg_vecbase: u32) void; // esp-idf/components/xtensa/include/xt_instr_macros.h:11:30: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:100:28: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_intr_get_enabled_mask() u32; // esp-idf/components/xtensa/include/xt_instr_macros.h:12:30: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:117:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_set_breakpoint(arg_bp_num: c_int, arg_bp_addr: u32) void; // esp-idf/components/xtensa/include/xt_instr_macros.h:11:30: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:132:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_clear_breakpoint(arg_bp_num: c_int) void; // esp-idf/components/xtensa/include/xt_utils.h:156:35: warning: TODO implement function '__builtin_ffsll' in std.zig.c_builtins
// esp-idf/components/xtensa/include/xt_utils.h:148:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_set_watchpoint(arg_wp_num: c_int, arg_wp_addr: u32, arg_size: usize, arg_on_read: bool, arg_on_write: bool) void; // esp-idf/components/xtensa/include/xt_instr_macros.h:12:30: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:174:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_clear_watchpoint(arg_wp_num: c_int) void; // esp-idf/components/xtensa/include/xt_instr_macros.h:15:30: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:188:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_dbgr_is_attached() bool; // esp-idf/components/xtensa/include/xt_utils.h:198:5: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:196:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_dbgr_break() void; // esp-idf/components/xtensa/include/xt_utils.h:216:5: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:205:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_compare_and_set(arg_addr: [*c]volatile u32, arg_compare_value: u32, arg_new_value: u32) bool;
pub const intr_handler_t = ?*const fn (?*anyopaque) callconv(.C) void;
pub const intr_handle_data_t = opaque {};
pub const intr_handle_t = ?*intr_handle_data_t;
pub const ESP_INTR_CPU_AFFINITY_AUTO: c_int = 0;
pub const ESP_INTR_CPU_AFFINITY_0: c_int = 1;
pub const ESP_INTR_CPU_AFFINITY_1: c_int = 2;
pub const esp_intr_cpu_affinity_t = c_uint;
pub extern fn esp_intr_mark_shared(intno: c_int, cpu: c_int, is_in_iram: bool) esp_err_t;
pub extern fn esp_intr_reserve(intno: c_int, cpu: c_int) esp_err_t;
pub extern fn esp_intr_alloc(source: c_int, flags: c_int, handler: intr_handler_t, arg: ?*anyopaque, ret_handle: [*c]intr_handle_t) esp_err_t;
pub extern fn esp_intr_alloc_intrstatus(source: c_int, flags: c_int, intrstatusreg: u32, intrstatusmask: u32, handler: intr_handler_t, arg: ?*anyopaque, ret_handle: [*c]intr_handle_t) esp_err_t;
pub extern fn esp_intr_free(handle: intr_handle_t) esp_err_t;
pub extern fn esp_intr_get_cpu(handle: intr_handle_t) c_int;
pub extern fn esp_intr_get_intno(handle: intr_handle_t) c_int;
pub extern fn esp_intr_disable(handle: intr_handle_t) esp_err_t;
pub extern fn esp_intr_enable(handle: intr_handle_t) esp_err_t;
pub extern fn esp_intr_set_in_iram(handle: intr_handle_t, is_in_iram: bool) esp_err_t;
pub extern fn esp_intr_noniram_disable() void;
pub extern fn esp_intr_noniram_enable() void;
pub extern fn esp_intr_enable_source(inum: c_int) void;
pub extern fn esp_intr_disable_source(inum: c_int) void; // esp-idf/components/esp_hw_support/include/esp_intr_alloc.h:300:12: warning: TODO implement function '__builtin_ffs' in std.zig.c_builtins
// esp-idf/components/esp_hw_support/include/esp_intr_alloc.h:298:19: warning: unable to translate function, demoted to extern
pub extern fn esp_intr_flags_to_level(arg_flags: c_int) callconv(.C) c_int;
pub fn esp_intr_level_to_flags(arg_level: c_int) callconv(.C) c_int {
    var level = arg_level;
    _ = &level;
    return if (level > @as(c_int, 0)) (@as(c_int, 1) << @intCast(level)) & (((((((@as(c_int, 1) << @intCast(1)) | (@as(c_int, 1) << @intCast(2))) | (@as(c_int, 1) << @intCast(3))) | (@as(c_int, 1) << @intCast(4))) | (@as(c_int, 1) << @intCast(5))) | (@as(c_int, 1) << @intCast(6))) | (@as(c_int, 1) << @intCast(7))) else @as(c_int, 0);
}
pub extern fn esp_intr_dump(stream: std.c.FILE) esp_err_t;
pub const esp_cpu_cycle_count_t = u32;
pub const ESP_CPU_INTR_TYPE_LEVEL: c_int = 0;
pub const ESP_CPU_INTR_TYPE_EDGE: c_int = 1;
pub const ESP_CPU_INTR_TYPE_NA: c_int = 2;
pub const esp_cpu_intr_type_t = c_uint;
pub const esp_cpu_intr_desc_t = extern struct {
    priority: c_int = std.mem.zeroes(c_int),
    type: esp_cpu_intr_type_t = std.mem.zeroes(esp_cpu_intr_type_t),
    flags: u32 = std.mem.zeroes(u32),
};
pub const esp_cpu_intr_handler_t = ?*const fn (?*anyopaque) callconv(.C) void;
pub const ESP_CPU_WATCHPOINT_LOAD: c_int = 0;
pub const ESP_CPU_WATCHPOINT_STORE: c_int = 1;
pub const ESP_CPU_WATCHPOINT_ACCESS: c_int = 2;
pub const esp_cpu_watchpoint_trigger_t = c_uint;
pub extern fn esp_cpu_stall(core_id: c_int) void;
pub extern fn esp_cpu_unstall(core_id: c_int) void;
pub extern fn esp_cpu_reset(core_id: c_int) void;
pub extern fn esp_cpu_wait_for_intr() void;
pub inline fn esp_cpu_get_core_id() c_int {
    return @as(c_int, @bitCast(xt_utils_get_core_id()));
}
pub inline fn esp_cpu_get_sp() ?*anyopaque {
    return xt_utils_get_sp();
}
pub inline fn esp_cpu_get_cycle_count() esp_cpu_cycle_count_t {
    return @as(esp_cpu_cycle_count_t, @bitCast(xt_utils_get_cycle_count()));
}
pub inline fn esp_cpu_set_cycle_count(arg_cycle_count: esp_cpu_cycle_count_t) void {
    var cycle_count = arg_cycle_count;
    _ = &cycle_count;
    xt_utils_set_cycle_count(@as(u32, @bitCast(cycle_count)));
}
pub inline fn esp_cpu_pc_to_addr(arg_pc: u32) ?*anyopaque {
    var pc = arg_pc;
    _ = &pc;
    return @as(?*anyopaque, @ptrFromInt((pc & @as(c_uint, 1073741823)) | @as(c_uint, 1073741824)));
}
pub extern fn esp_cpu_intr_get_desc(core_id: c_int, intr_num: c_int, intr_desc_ret: [*c]esp_cpu_intr_desc_t) void;
pub inline fn esp_cpu_intr_set_ivt_addr(arg_ivt_addr: ?*const anyopaque) void {
    var ivt_addr = arg_ivt_addr;
    _ = &ivt_addr;
    xt_utils_set_vecbase(@as(u32, @intCast(@intFromPtr(ivt_addr))));
} // esp-idf/components/newlib/platform_include/assert.h:30:23: warning: TODO implement function '__builtin_strrchr' in std.zig.c_builtins
// esp-idf/components/esp_hw_support/include/esp_cpu.h:324:24: warning: unable to translate function, demoted to extern
pub extern fn esp_cpu_intr_has_handler(arg_intr_num: c_int) bool; // esp-idf/components/newlib/platform_include/assert.h:30:23: warning: TODO implement function '__builtin_strrchr' in std.zig.c_builtins
// esp-idf/components/esp_hw_support/include/esp_cpu.h:348:24: warning: unable to translate function, demoted to extern
pub extern fn esp_cpu_intr_set_handler(arg_intr_num: c_int, arg_handler: esp_cpu_intr_handler_t, arg_handler_arg: ?*anyopaque) void; // esp-idf/components/newlib/platform_include/assert.h:30:23: warning: TODO implement function '__builtin_strrchr' in std.zig.c_builtins
// esp-idf/components/esp_hw_support/include/esp_cpu.h:366:25: warning: unable to translate function, demoted to extern
pub extern fn esp_cpu_intr_get_handler_arg(arg_intr_num: c_int) ?*anyopaque;
pub inline fn esp_cpu_intr_enable(arg_intr_mask: u32) void {
    var intr_mask = arg_intr_mask;
    _ = &intr_mask;
    xt_ints_on(intr_mask);
}
pub inline fn esp_cpu_intr_disable(arg_intr_mask: u32) void {
    var intr_mask = arg_intr_mask;
    _ = &intr_mask;
    xt_ints_off(intr_mask);
}
pub inline fn esp_cpu_intr_get_enabled_mask() u32 {
    return xt_utils_intr_get_enabled_mask();
} // esp-idf/components/newlib/platform_include/assert.h:30:23: warning: TODO implement function '__builtin_strrchr' in std.zig.c_builtins
// esp-idf/components/esp_hw_support/include/esp_cpu.h:427:24: warning: unable to translate function, demoted to extern
pub extern fn esp_cpu_intr_edge_ack(arg_intr_num: c_int) void;
pub extern fn esp_cpu_configure_region_protection() void;
pub extern fn esp_cpu_set_breakpoint(bp_num: c_int, bp_addr: ?*const anyopaque) esp_err_t;
pub extern fn esp_cpu_clear_breakpoint(bp_num: c_int) esp_err_t;
pub extern fn esp_cpu_set_watchpoint(wp_num: c_int, wp_addr: ?*const anyopaque, size: usize, trigger: esp_cpu_watchpoint_trigger_t) esp_err_t;
pub extern fn esp_cpu_clear_watchpoint(wp_num: c_int) esp_err_t;
pub inline fn esp_cpu_dbgr_is_attached() bool {
    return xt_utils_dbgr_is_attached();
}
pub inline fn esp_cpu_dbgr_break() void {
    xt_utils_dbgr_break();
}
pub inline fn esp_cpu_get_call_addr(arg_return_address: isize) isize {
    var return_address = arg_return_address;
    _ = &return_address;
    return return_address - @as(c_int, 3);
}
pub extern fn esp_cpu_compare_and_set(addr: [*c]volatile u32, compare_value: u32, new_value: u32) bool;
pub const esp_backtrace_frame_t = extern struct {
    pc: u32 = std.mem.zeroes(u32),
    sp: u32 = std.mem.zeroes(u32),
    next_pc: u32 = std.mem.zeroes(u32),
    exc_frame: ?*const anyopaque = std.mem.zeroes(?*const anyopaque),
};
pub extern fn esp_set_breakpoint_if_jtag(@"fn": ?*anyopaque) void;
pub extern fn esp_backtrace_get_start(pc: [*c]u32, sp: [*c]u32, next_pc: [*c]u32) void;
pub extern fn esp_backtrace_get_next_frame(frame: [*c]esp_backtrace_frame_t) bool;
pub extern fn esp_backtrace_print_from_frame(depth: c_int, frame: [*c]const esp_backtrace_frame_t, panic: bool) esp_err_t;
pub extern fn esp_backtrace_print(depth: c_int) esp_err_t;
pub extern fn esp_backtrace_print_all_tasks(depth: c_int) esp_err_t;
pub fn esp_set_watchpoint(arg_no: c_int, arg_adr: ?*anyopaque, arg_size: c_int, arg_flags: c_int) callconv(.C) esp_err_t {
    var no = arg_no;
    _ = &no;
    var adr = arg_adr;
    _ = &adr;
    var size = arg_size;
    _ = &size;
    var flags = arg_flags;
    _ = &flags;
    return esp_cpu_set_watchpoint(no, adr, @as(usize, @bitCast(size)), @as(c_uint, @bitCast(flags)));
}
pub fn esp_clear_watchpoint(arg_no: c_int) callconv(.C) void {
    var no = arg_no;
    _ = &no;
    _ = esp_cpu_clear_watchpoint(no);
}

pub const touch_pad_t = enum(c_uint) {
    TOUCH_PAD_NUM0 = 0,
    TOUCH_PAD_NUM1 = 1,
    TOUCH_PAD_NUM2 = 2,
    TOUCH_PAD_NUM3 = 3,
    TOUCH_PAD_NUM4 = 4,
    TOUCH_PAD_NUM5 = 5,
    TOUCH_PAD_NUM6 = 6,
    TOUCH_PAD_NUM7 = 7,
    TOUCH_PAD_NUM8 = 8,
    TOUCH_PAD_NUM9 = 9,
    TOUCH_PAD_MAX = 10,
};
pub const touch_high_volt_t = enum(c_int) {
    TOUCH_HVOLT_KEEP = -1,
    TOUCH_HVOLT_2V4 = 0,
    TOUCH_HVOLT_2V5 = 1,
    TOUCH_HVOLT_2V6 = 2,
    TOUCH_HVOLT_2V7 = 3,
    TOUCH_HVOLT_MAX = 4,
};
pub const touch_low_volt_t = enum(c_int) {
    TOUCH_LVOLT_KEEP = -1,
    TOUCH_LVOLT_0V5 = 0,
    TOUCH_LVOLT_0V6 = 1,
    TOUCH_LVOLT_0V7 = 2,
    TOUCH_LVOLT_0V8 = 3,
    TOUCH_LVOLT_MAX = 4,
};
pub const touch_volt_atten_t = enum(c_int) {
    TOUCH_HVOLT_ATTEN_KEEP = -1,
    TOUCH_HVOLT_ATTEN_1V5 = 0,
    TOUCH_HVOLT_ATTEN_1V = 1,
    TOUCH_HVOLT_ATTEN_0V5 = 2,
    TOUCH_HVOLT_ATTEN_0V = 3,
    TOUCH_HVOLT_ATTEN_MAX = 4,
};
pub const touch_cnt_slope_t = enum(c_uint) {
    TOUCH_PAD_SLOPE_0 = 0,
    TOUCH_PAD_SLOPE_1 = 1,
    TOUCH_PAD_SLOPE_2 = 2,
    TOUCH_PAD_SLOPE_3 = 3,
    TOUCH_PAD_SLOPE_4 = 4,
    TOUCH_PAD_SLOPE_5 = 5,
    TOUCH_PAD_SLOPE_6 = 6,
    TOUCH_PAD_SLOPE_7 = 7,
    TOUCH_PAD_SLOPE_MAX = 8,
};

pub const touch_tie_opt_t = enum(c_uint) {
    TOUCH_PAD_TIE_OPT_LOW = 0,
    TOUCH_PAD_TIE_OPT_HIGH = 1,
    TOUCH_PAD_TIE_OPT_MAX = 2,
};
pub const touch_fsm_mode_t = enum(c_uint) {
    TOUCH_FSM_MODE_TIMER = 0,
    TOUCH_FSM_MODE_SW = 1,
    TOUCH_FSM_MODE_MAX = 2,
};
pub const touch_trigger_mode_t = enum(c_uint) {
    TOUCH_TRIGGER_BELOW = 0,
    TOUCH_TRIGGER_ABOVE = 1,
    TOUCH_TRIGGER_MAX = 2,
};
pub const touch_trigger_src_t = enum(c_uint) {
    TOUCH_TRIGGER_SOURCE_BOTH = 0,
    TOUCH_TRIGGER_SOURCE_SET1 = 1,
    TOUCH_TRIGGER_SOURCE_MAX = 2,
};
pub const gpio_num_t = enum(c_int) {
    GPIO_NUM_NC = -1,
    GPIO_NUM_0 = 0,
    GPIO_NUM_1 = 1,
    GPIO_NUM_2 = 2,
    GPIO_NUM_3 = 3,
    GPIO_NUM_4 = 4,
    GPIO_NUM_5 = 5,
    GPIO_NUM_6 = 6,
    GPIO_NUM_7 = 7,
    GPIO_NUM_8 = 8,
    GPIO_NUM_9 = 9,
    GPIO_NUM_10 = 10,
    GPIO_NUM_11 = 11,
    GPIO_NUM_12 = 12,
    GPIO_NUM_13 = 13,
    GPIO_NUM_14 = 14,
    GPIO_NUM_15 = 15,
    GPIO_NUM_16 = 16,
    GPIO_NUM_17 = 17,
    GPIO_NUM_18 = 18,
    GPIO_NUM_19 = 19,
    GPIO_NUM_20 = 20,
    GPIO_NUM_21 = 21,
    GPIO_NUM_22 = 22,
    GPIO_NUM_23 = 23,
    GPIO_NUM_25 = 25,
    GPIO_NUM_26 = 26,
    GPIO_NUM_27 = 27,
    GPIO_NUM_28 = 28,
    GPIO_NUM_29 = 29,
    GPIO_NUM_30 = 30,
    GPIO_NUM_31 = 31,
    GPIO_NUM_32 = 32,
    GPIO_NUM_33 = 33,
    GPIO_NUM_34 = 34,
    GPIO_NUM_35 = 35,
    GPIO_NUM_36 = 36,
    GPIO_NUM_37 = 37,
    GPIO_NUM_38 = 38,
    GPIO_NUM_39 = 39,
    GPIO_NUM_MAX = 40,
};
pub const gpio_port_t = enum(c_uint) {
    GPIO_PORT_0 = 0,
    GPIO_PORT_MAX = 1,
};
pub const gpio_int_type_t = enum(c_uint) {
    GPIO_INTR_DISABLE = 0,
    GPIO_INTR_POSEDGE = 1,
    GPIO_INTR_NEGEDGE = 2,
    GPIO_INTR_ANYEDGE = 3,
    GPIO_INTR_LOW_LEVEL = 4,
    GPIO_INTR_HIGH_LEVEL = 5,
    GPIO_INTR_MAX = 6,
};
pub const gpio_mode_t = enum(c_uint) {
    GPIO_MODE_DISABLE = 0,
    GPIO_MODE_INPUT = 1,
    GPIO_MODE_OUTPUT = 2,
    GPIO_MODE_OUTPUT_OD = 6,
    GPIO_MODE_INPUT_OUTPUT_OD = 7,
    GPIO_MODE_INPUT_OUTPUT = 3,
};
pub const gpio_pullup_t = enum(c_uint) {
    GPIO_PULLUP_DISABLE = 0,
    GPIO_PULLUP_ENABLE = 1,
};
pub const gpio_pulldown_t = enum(c_uint) {
    GPIO_PULLDOWN_DISABLE = 0,
    GPIO_PULLDOWN_ENABLE = 1,
};
pub const gpio_pull_mode_t = enum(c_uint) {
    GPIO_PULLUP_ONLY = 0,
    GPIO_PULLDOWN_ONLY = 1,
    GPIO_PULLUP_PULLDOWN = 2,
    GPIO_FLOATING = 3,
};
pub const gpio_drive_cap_t = enum(c_uint) {
    GPIO_DRIVE_CAP_0 = 0,
    GPIO_DRIVE_CAP_1 = 1,
    GPIO_DRIVE_CAP_2 = 2,
    GPIO_DRIVE_CAP_DEFAULT = 2,
    GPIO_DRIVE_CAP_3 = 3,
    GPIO_DRIVE_CAP_MAX = 4,
};
pub const esp_deep_sleep_cb_t = ?*const fn () callconv(.C) void;
pub const esp_sleep_ext1_wakeup_mode_t = enum(c_uint) {
    ESP_EXT1_WAKEUP_ALL_LOW = 0,
    ESP_EXT1_WAKEUP_ANY_HIGH = 1,
};
pub const esp_sleep_pd_domain_t = enum(c_uint) {
    ESP_PD_DOMAIN_RTC_PERIPH = 0,
    ESP_PD_DOMAIN_RTC_SLOW_MEM = 1,
    ESP_PD_DOMAIN_RTC_FAST_MEM = 2,
    ESP_PD_DOMAIN_XTAL = 3,
    ESP_PD_DOMAIN_RC_FAST = 4,
    ESP_PD_DOMAIN_VDDSDIO = 5,
    ESP_PD_DOMAIN_MODEM = 6,
    ESP_PD_DOMAIN_MAX = 7,
};
pub const esp_sleep_pd_option_t = enum(c_uint) {
    ESP_PD_OPTION_OFF = 0,
    ESP_PD_OPTION_ON = 1,
    ESP_PD_OPTION_AUTO = 2,
};
pub const esp_sleep_source_t = enum(c_uint) {
    ESP_SLEEP_WAKEUP_UNDEFINED = 0,
    ESP_SLEEP_WAKEUP_ALL = 1,
    ESP_SLEEP_WAKEUP_EXT0 = 2,
    ESP_SLEEP_WAKEUP_EXT1 = 3,
    ESP_SLEEP_WAKEUP_TIMER = 4,
    ESP_SLEEP_WAKEUP_TOUCHPAD = 5,
    ESP_SLEEP_WAKEUP_ULP = 6,
    ESP_SLEEP_WAKEUP_GPIO = 7,
    ESP_SLEEP_WAKEUP_UART = 8,
    ESP_SLEEP_WAKEUP_WIFI = 9,
    ESP_SLEEP_WAKEUP_COCPU = 10,
    ESP_SLEEP_WAKEUP_COCPU_TRAP_TRIG = 11,
    ESP_SLEEP_WAKEUP_BT = 12,
};
pub const esp_sleep_mode_t = enum(c_uint) {
    ESP_SLEEP_MODE_LIGHT_SLEEP = 0,
    ESP_SLEEP_MODE_DEEP_SLEEP = 1,
};
pub const esp_sleep_wakeup_cause_t = esp_sleep_source_t;
const enum_unnamed_3 = enum(c_uint) {
    ESP_ERR_SLEEP_REJECT = 259,
    ESP_ERR_SLEEP_TOO_SHORT_SLEEP_DURATION = 258,
};
pub extern fn esp_sleep_disable_wakeup_source(source: esp_sleep_source_t) esp_err_t;
pub extern fn esp_sleep_enable_ulp_wakeup() esp_err_t;
pub extern fn esp_sleep_enable_timer_wakeup(time_in_us: u64) esp_err_t;
pub extern fn esp_sleep_enable_touchpad_wakeup() esp_err_t;
pub extern fn esp_sleep_get_touchpad_wakeup_status() touch_pad_t;
pub extern fn esp_sleep_is_valid_wakeup_gpio(gpio_num: gpio_num_t) bool;
pub extern fn esp_sleep_enable_ext0_wakeup(gpio_num: gpio_num_t, level: c_int) esp_err_t;
pub extern fn esp_sleep_enable_ext1_wakeup(io_mask: u64, level_mode: esp_sleep_ext1_wakeup_mode_t) esp_err_t;
pub extern fn esp_sleep_enable_ext1_wakeup_io(io_mask: u64, level_mode: esp_sleep_ext1_wakeup_mode_t) esp_err_t;
pub extern fn esp_sleep_disable_ext1_wakeup_io(io_mask: u64) esp_err_t;
pub extern fn esp_sleep_enable_gpio_wakeup() esp_err_t;
pub extern fn esp_sleep_enable_uart_wakeup(uart_num: c_int) esp_err_t;
pub extern fn esp_sleep_enable_bt_wakeup() esp_err_t;
pub extern fn esp_sleep_disable_bt_wakeup() esp_err_t;
pub extern fn esp_sleep_enable_wifi_wakeup() esp_err_t;
pub extern fn esp_sleep_disable_wifi_wakeup() esp_err_t;
pub extern fn esp_sleep_enable_wifi_beacon_wakeup() esp_err_t;
pub extern fn esp_sleep_disable_wifi_beacon_wakeup() esp_err_t;
pub extern fn esp_sleep_get_ext1_wakeup_status() u64;
pub extern fn esp_sleep_pd_config(domain: esp_sleep_pd_domain_t, option: esp_sleep_pd_option_t) esp_err_t;
pub extern fn esp_deep_sleep_try_to_start() esp_err_t;
pub extern fn esp_deep_sleep_start() noreturn;
pub extern fn esp_light_sleep_start() esp_err_t;
pub extern fn esp_deep_sleep_try(time_in_us: u64) esp_err_t;
pub extern fn esp_deep_sleep(time_in_us: u64) noreturn;
pub extern fn esp_deep_sleep_register_hook(new_dslp_cb: esp_deep_sleep_cb_t) esp_err_t;
pub extern fn esp_deep_sleep_deregister_hook(old_dslp_cb: esp_deep_sleep_cb_t) void;
pub extern fn esp_sleep_get_wakeup_cause() esp_sleep_wakeup_cause_t;
pub extern fn esp_wake_deep_sleep() void;
pub const esp_deep_sleep_wake_stub_fn_t = ?*const fn () callconv(.C) void;
pub extern fn esp_set_deep_sleep_wake_stub(new_stub: esp_deep_sleep_wake_stub_fn_t) void;
pub extern fn esp_set_deep_sleep_wake_stub_default_entry() void;
pub extern fn esp_get_deep_sleep_wake_stub() esp_deep_sleep_wake_stub_fn_t;
pub extern fn esp_default_wake_deep_sleep() void;
pub extern fn esp_deep_sleep_disable_rom_logging() void;
pub extern fn esp_sleep_config_gpio_isolate() void;
pub extern fn esp_sleep_enable_gpio_switch(enable: bool) void;
pub const TaskFunction_t = ?*const fn (?*anyopaque) callconv(.C) void;
pub const spinlock_t = extern struct {
    owner: u32 = std.mem.zeroes(u32),
    count: u32 = std.mem.zeroes(u32),
}; // esp-idf/components/newlib/platform_include/assert.h:30:23: warning: TODO implement function '__builtin_strrchr' in std.zig.c_builtins
// esp-idf/components/esp_hw_support/include/spinlock.h:51:51: warning: unable to translate function, demoted to extern
pub extern fn spinlock_initialize(arg_lock: [*c]spinlock_t) void; // esp-idf/components/newlib/platform_include/assert.h:30:23: warning: TODO implement function '__builtin_strrchr' in std.zig.c_builtins
// esp-idf/components/esp_hw_support/include/spinlock.h:74:51: warning: unable to translate function, demoted to extern
pub extern fn spinlock_acquire(arg_lock: [*c]spinlock_t, arg_timeout: i32) bool; // esp-idf/components/newlib/platform_include/assert.h:30:23: warning: TODO implement function '__builtin_strrchr' in std.zig.c_builtins
// esp-idf/components/esp_hw_support/include/spinlock.h:172:51: warning: unable to translate function, demoted to extern
pub extern fn spinlock_release(arg_lock: [*c]spinlock_t) void;
pub extern fn esp_crosscore_int_init() void;
pub extern fn esp_crosscore_int_send_yield(core_id: c_int) void;
pub extern fn esp_crosscore_int_send_freq_switch(core_id: c_int) void;
pub extern fn esp_crosscore_int_send_gdb_call(core_id: c_int) void;
pub extern fn esp_crosscore_int_send_print_backtrace(core_id: c_int) void;
pub extern fn esp_crosscore_int_send_twdt_abort(core_id: c_int) void; // /home/kassane/.espressif/tools/xtensa-esp-elf/esp-13.2.0_20230928/xtensa-esp-elf/xtensa-esp-elf/include/assert.h:45:24: warning: ignoring StaticAssert declaration
// /home/kassane/.espressif/tools/xtensa-esp-elf/esp-13.2.0_20230928/xtensa-esp-elf/xtensa-esp-elf/include/assert.h:45:24: warning: ignoring StaticAssert declaration
pub inline fn esp_dram_match_iram() bool {
    return (@as(c_int, 1073405952) == @as(c_int, 1074266112)) and (@as(c_int, 1073741824) == @as(c_int, 1074438144));
}
pub inline fn esp_ptr_in_iram(arg_p: ?*const anyopaque) bool {
    var p = arg_p;
    _ = &p;
    return (@as(isize, @intCast(@intFromPtr(p))) >= @as(c_int, 1074266112)) and (@as(isize, @intCast(@intFromPtr(p))) < @as(c_int, 1074438144));
}
pub inline fn esp_ptr_in_dram(arg_p: ?*const anyopaque) bool {
    var p = arg_p;
    _ = &p;
    return (@as(isize, @intCast(@intFromPtr(p))) >= @as(c_int, 1073405952)) and (@as(isize, @intCast(@intFromPtr(p))) < @as(c_int, 1073741824));
}
pub inline fn esp_ptr_in_diram_dram(arg_p: ?*const anyopaque) bool {
    var p = arg_p;
    _ = &p;
    return (@as(isize, @intCast(@intFromPtr(p))) >= @as(c_int, 1073610752)) and (@as(isize, @intCast(@intFromPtr(p))) < @as(c_int, 1073741824));
}
pub inline fn esp_ptr_in_diram_iram(arg_p: ?*const anyopaque) bool {
    var p = arg_p;
    _ = &p;
    return (@as(isize, @intCast(@intFromPtr(p))) >= @as(c_int, 1074397184)) and (@as(isize, @intCast(@intFromPtr(p))) < @as(c_int, 1074528256));
}
pub inline fn esp_ptr_in_rtc_iram_fast(arg_p: ?*const anyopaque) bool {
    var p = arg_p;
    _ = &p;
    return (@as(isize, @intCast(@intFromPtr(p))) >= @as(c_int, 1074528256)) and (@as(isize, @intCast(@intFromPtr(p))) < @as(c_int, 1074536448));
}
pub inline fn esp_ptr_in_rtc_dram_fast(arg_p: ?*const anyopaque) bool {
    var p = arg_p;
    _ = &p;
    return (@as(isize, @intCast(@intFromPtr(p))) >= @as(c_int, 1073217536)) and (@as(isize, @intCast(@intFromPtr(p))) < @as(c_int, 1073225728));
}
pub inline fn esp_ptr_in_rtc_slow(arg_p: ?*const anyopaque) bool {
    var p = arg_p;
    _ = &p;
    return (@as(isize, @intCast(@intFromPtr(p))) >= @as(c_int, 1342177280)) and (@as(isize, @intCast(@intFromPtr(p))) < @as(c_int, 1342185472));
}
pub inline fn esp_ptr_diram_dram_to_iram(arg_p: ?*const anyopaque) ?*anyopaque {
    var p = arg_p;
    _ = &p;
    return @as(?*anyopaque, @ptrFromInt((@as(c_int, 1074397184) + (@as(c_int, 1073741824) - @as(isize, @intCast(@intFromPtr(p))))) - @as(c_int, 4)));
}
pub inline fn esp_ptr_diram_iram_to_dram(arg_p: ?*const anyopaque) ?*anyopaque {
    var p = arg_p;
    _ = &p;
    return @as(?*anyopaque, @ptrFromInt((@as(c_int, 1073610752) + (@as(c_int, 1074528256) - @as(isize, @intCast(@intFromPtr(p))))) - @as(c_int, 4)));
}
pub inline fn esp_ptr_dma_capable(arg_p: ?*const anyopaque) bool {
    var p = arg_p;
    _ = &p;
    return (@as(isize, @intCast(@intFromPtr(p))) >= @as(c_int, 1073405952)) and (@as(isize, @intCast(@intFromPtr(p))) < @as(c_int, 1073741824));
}
pub extern fn esp_ptr_dma_ext_capable(p: ?*const anyopaque) bool;
pub inline fn esp_ptr_word_aligned(arg_p: ?*const anyopaque) bool {
    var p = arg_p;
    _ = &p;
    return std.zig.c_translation.signedRemainder(@as(isize, @intCast(@intFromPtr(p))), @as(c_int, 4)) == @as(c_int, 0);
}
pub inline fn esp_ptr_executable(arg_p: ?*const anyopaque) bool {
    var p = arg_p;
    _ = &p;
    var ip: isize = @as(isize, @intCast(@intFromPtr(p)));
    _ = &ip;
    return ((((ip >= @as(c_int, 1074593792)) and (ip < @as(c_int, 1077936128))) or ((ip >= @as(c_int, 1074266112)) and (ip < @as(c_int, 1074438144)))) or ((ip >= @as(c_int, 1073741824)) and (ip < @as(c_int, 1074200576)))) or ((ip >= @as(c_int, 1074528256)) and (ip < @as(c_int, 1074536448)));
}
pub extern fn esp_ptr_byte_accessible(p: ?*const anyopaque) bool;
pub inline fn esp_ptr_internal(arg_p: ?*const anyopaque) bool {
    var p = arg_p;
    _ = &p;
    var r: bool = undefined;
    _ = &r;
    r = (@as(isize, @intCast(@intFromPtr(p))) >= @as(c_int, 1073283072)) and (@as(isize, @intCast(@intFromPtr(p))) < @as(c_int, 1074536448));
    r |= @as(bool, (@as(isize, @intCast(@intFromPtr(p))) >= @as(c_int, 1342177280)) and (@as(isize, @intCast(@intFromPtr(p))) < @as(c_int, 1342185472)));
    return r;
}
pub extern fn esp_ptr_external_ram(p: ?*const anyopaque) bool;
pub inline fn esp_ptr_in_drom(arg_p: ?*const anyopaque) bool {
    var p = arg_p;
    _ = &p;
    var drom_start_addr: i32 = 1061158912;
    _ = &drom_start_addr;
    return (@as(isize, @intCast(@intFromPtr(p))) >= drom_start_addr) and (@as(isize, @intCast(@intFromPtr(p))) < @as(c_int, 1065353216));
}
pub inline fn esp_stack_ptr_in_dram(arg_sp: u32) bool {
    var sp = arg_sp;
    _ = &sp;
    return !(((sp < @as(u32, @bitCast(@as(c_int, 1073405952) + @as(c_int, 16)))) or (sp > @as(u32, @bitCast(@as(c_int, 1073741824) - @as(c_int, 16))))) or ((sp & @as(u32, @bitCast(@as(c_int, 15)))) != @as(u32, @bitCast(@as(c_int, 0)))));
}
pub inline fn esp_stack_ptr_is_sane(arg_sp: u32) bool {
    var sp = arg_sp;
    _ = &sp;
    return esp_stack_ptr_in_dram(sp);
}
pub extern fn esp_newlib_time_init() void;
// pub extern fn esp_reent_init(r: [*c]_reent) void;
pub extern fn esp_newlib_init_global_stdio(stdio_dev: [*:0]const u8) void;
pub extern fn esp_reent_cleanup() void;
pub extern fn esp_newlib_init() void;
pub extern fn esp_setup_syscall_table() void;
pub extern fn esp_set_time_from_rtc() void;
pub extern fn esp_sync_timekeeping_timers() void;
pub extern fn esp_newlib_locks_init() void;
pub const multi_heap_info = opaque {};
pub const multi_heap_handle_t = ?*multi_heap_info;
pub extern fn multi_heap_aligned_alloc(heap: multi_heap_handle_t, size: usize, alignment: usize) ?*anyopaque;
pub extern fn multi_heap_malloc(heap: multi_heap_handle_t, size: usize) ?*anyopaque;
pub extern fn multi_heap_aligned_free(heap: multi_heap_handle_t, p: ?*anyopaque) void;
pub extern fn multi_heap_free(heap: multi_heap_handle_t, p: ?*anyopaque) void;
pub extern fn multi_heap_realloc(heap: multi_heap_handle_t, p: ?*anyopaque, size: usize) ?*anyopaque;
pub extern fn multi_heap_get_allocated_size(heap: multi_heap_handle_t, p: ?*anyopaque) usize;
pub extern fn multi_heap_register(start: ?*anyopaque, size: usize) multi_heap_handle_t;
pub extern fn multi_heap_set_lock(heap: multi_heap_handle_t, lock: ?*anyopaque) void;
pub extern fn multi_heap_dump(heap: multi_heap_handle_t) void;
pub extern fn multi_heap_check(heap: multi_heap_handle_t, print_errors: bool) bool;
pub extern fn multi_heap_free_size(heap: multi_heap_handle_t) usize;
pub extern fn multi_heap_minimum_free_size(heap: multi_heap_handle_t) usize;
pub const multi_heap_info_t = extern struct {
    total_free_bytes: usize = std.mem.zeroes(usize),
    total_allocated_bytes: usize = std.mem.zeroes(usize),
    largest_free_block: usize = std.mem.zeroes(usize),
    minimum_free_bytes: usize = std.mem.zeroes(usize),
    allocated_blocks: usize = std.mem.zeroes(usize),
    free_blocks: usize = std.mem.zeroes(usize),
    total_blocks: usize = std.mem.zeroes(usize),
};
pub extern fn multi_heap_get_info(heap: multi_heap_handle_t, info: [*c]multi_heap_info_t) void;
pub extern fn multi_heap_aligned_alloc_offs(heap: multi_heap_handle_t, size: usize, alignment: usize, offset: usize) ?*anyopaque;
pub extern fn multi_heap_reset_minimum_free_bytes(heap: multi_heap_handle_t) usize;
pub extern fn multi_heap_restore_minimum_free_bytes(heap: multi_heap_handle_t, new_minimum_free_bytes_value: usize) void;
pub const esp_alloc_failed_hook_t = ?*const fn (usize, u32, [*:0]const u8) callconv(.C) void;
pub const Caps = enum(u32) {
    // @brief Flags to indicate the capabilities of the various memory systems
    MALLOC_CAP_EXEC = (1 << 0), //< Memory must be able to run executable code
    MALLOC_CAP_32BIT = (1 << 1), //< Memory must allow for aligned 32-bit data accesses
    MALLOC_CAP_8BIT = (1 << 2), //< Memory must allow for 8/16/...-bit data accesses
    MALLOC_CAP_DMA = (1 << 3), //< Memory must be able to accessed by DMA
    MALLOC_CAP_PID2 = (1 << 4), //< Memory must be mapped to PID2 memory space (PIDs are not currently used)
    MALLOC_CAP_PID3 = (1 << 5), //< Memory must be mapped to PID3 memory space (PIDs are not currently used)
    MALLOC_CAP_PID4 = (1 << 6), //< Memory must be mapped to PID4 memory space (PIDs are not currently used)
    MALLOC_CAP_PID5 = (1 << 7), //< Memory must be mapped to PID5 memory space (PIDs are not currently used)
    MALLOC_CAP_PID6 = (1 << 8), //< Memory must be mapped to PID6 memory space (PIDs are not currently used)
    MALLOC_CAP_PID7 = (1 << 9), //< Memory must be mapped to PID7 memory space (PIDs are not currently used)
    MALLOC_CAP_SPIRAM = (1 << 10), //< Memory must be in SPI RAM
    MALLOC_CAP_INTERNAL = (1 << 11), //< Memory must be internal; specifically it should not disappear when flash/spiram cache is switched off
    MALLOC_CAP_DEFAULT = (1 << 12), //< Memory can be returned in a non-capability-specific memory allocation (e.g. malloc(), calloc()) call
    MALLOC_CAP_IRAM_8BIT = (1 << 13), //< Memory must be in IRAM and allow unaligned access
    MALLOC_CAP_RETENTION = (1 << 14), //< Memory must be able to accessed by retention DMA
    MALLOC_CAP_RTCRAM = (1 << 15), //< Memory must be in RTC fast memory
    MALLOC_CAP_TCM = (1 << 16), //< Memory must be in TCM memory

    MALLOC_CAP_INVALID = (1 << 31), //< Memory can't be used / list end marker
};
pub extern fn heap_caps_register_failed_alloc_callback(callback: esp_alloc_failed_hook_t) esp_err_t;
pub extern fn heap_caps_malloc(size: usize, caps: u32) ?*anyopaque;
pub extern fn heap_caps_free(ptr: ?*anyopaque) void;
pub extern fn heap_caps_realloc(ptr: ?*anyopaque, size: usize, caps: u32) ?*anyopaque;
pub extern fn heap_caps_aligned_alloc(alignment: usize, size: usize, caps: u32) ?*anyopaque;
pub extern fn heap_caps_aligned_free(ptr: ?*anyopaque) void;
pub extern fn heap_caps_aligned_calloc(alignment: usize, n: usize, size: usize, caps: u32) ?*anyopaque;
pub extern fn heap_caps_calloc(n: usize, size: usize, caps: u32) ?*anyopaque;
pub extern fn heap_caps_get_total_size(caps: u32) usize;
pub extern fn heap_caps_get_free_size(caps: u32) usize;
pub extern fn heap_caps_get_minimum_free_size(caps: u32) usize;
pub extern fn heap_caps_get_largest_free_block(caps: u32) usize;
pub extern fn heap_caps_monitor_local_minimum_free_size_start() esp_err_t;
pub extern fn heap_caps_monitor_local_minimum_free_size_stop() esp_err_t;
pub extern fn heap_caps_get_info(info: [*c]multi_heap_info_t, caps: u32) void;
pub extern fn heap_caps_print_heap_info(caps: u32) void;
pub extern fn heap_caps_check_integrity_all(print_errors: bool) bool;
pub extern fn heap_caps_check_integrity(caps: u32, print_errors: bool) bool;
pub extern fn heap_caps_check_integrity_addr(addr: isize, print_errors: bool) bool;
pub extern fn heap_caps_malloc_extmem_enable(limit: usize) void;
pub extern fn heap_caps_malloc_prefer(size: usize, num: usize, ...) ?*anyopaque;
pub extern fn heap_caps_realloc_prefer(ptr: ?*anyopaque, size: usize, num: usize, ...) ?*anyopaque;
pub extern fn heap_caps_calloc_prefer(n: usize, size: usize, num: usize, ...) ?*anyopaque;
pub extern fn heap_caps_dump(caps: u32) void;
pub extern fn heap_caps_dump_all() void;
pub extern fn heap_caps_get_allocated_size(ptr: ?*anyopaque) usize;
pub const StackType_t = u8;
pub const BaseType_t = c_int;
pub const UBaseType_t = c_uint;
pub const TickType_t = u32;
pub extern fn xPortInIsrContext() BaseType_t;
pub extern fn vPortAssertIfInISR() void;
pub extern fn xPortInterruptedFromISRContext() BaseType_t; // esp-idf/components/xtensa/include/xtensa/xtruntime.h:92:4: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/freertos/FreeRTOS-Kernel/portable/xtensa/include/freertos/portmacro.h:554:58: warning: unable to translate function, demoted to extern
pub extern fn xPortSetInterruptMaskFromISR() UBaseType_t;
pub inline fn vPortClearInterruptMaskFromISR(arg_prev_level: UBaseType_t) void {
    var prev_level = arg_prev_level;
    _ = &prev_level;
    _ = _xtos_set_intlevel(@as(c_int, @bitCast(prev_level)));
}
pub const portMUX_TYPE = spinlock_t;
pub extern fn xPortEnterCriticalTimeout(mux: [*c]portMUX_TYPE, timeout: BaseType_t) BaseType_t;
pub inline fn vPortEnterCritical(arg_mux: [*c]portMUX_TYPE) void {
    var mux = arg_mux;
    _ = &mux;
    _ = xPortEnterCriticalTimeout(mux, -@as(c_int, 1));
}
pub extern fn vPortExitCritical(mux: [*c]portMUX_TYPE) void;
pub extern fn xPortEnterCriticalTimeoutCompliance(mux: [*c]portMUX_TYPE, timeout: BaseType_t) BaseType_t;
pub inline fn vPortEnterCriticalCompliance(arg_mux: [*c]portMUX_TYPE) void {
    var mux = arg_mux;
    _ = &mux;
    _ = xPortEnterCriticalTimeoutCompliance(mux, -@as(c_int, 1));
}
pub extern fn vPortExitCriticalCompliance(mux: [*c]portMUX_TYPE) void;
pub inline fn xPortEnterCriticalTimeoutSafe(arg_mux: [*c]portMUX_TYPE, arg_timeout: BaseType_t) BaseType_t {
    var mux = arg_mux;
    _ = &mux;
    var timeout = arg_timeout;
    _ = &timeout;
    var ret: BaseType_t = undefined;
    _ = &ret;
    if (xPortInIsrContext() != 0) {
        ret = xPortEnterCriticalTimeout(mux, timeout);
    } else {
        ret = xPortEnterCriticalTimeout(mux, timeout);
    }
    return ret;
}
pub inline fn vPortEnterCriticalSafe(arg_mux: [*c]portMUX_TYPE) void {
    var mux = arg_mux;
    _ = &mux;
    _ = xPortEnterCriticalTimeoutSafe(mux, -@as(c_int, 1));
}
pub inline fn vPortExitCriticalSafe(arg_mux: [*c]portMUX_TYPE) void {
    var mux = arg_mux;
    _ = &mux;
    if (xPortInIsrContext() != 0) {
        vPortExitCritical(mux);
    } else {
        vPortExitCritical(mux);
    }
}
pub extern fn vPortYield() void;
pub extern fn vPortYieldOtherCore(coreid: BaseType_t) void; // esp-idf/components/xtensa/include/xt_instr_macros.h:11:30: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/freertos/FreeRTOS-Kernel/portable/xtensa/include/freertos/portmacro.h:606:24: warning: unable to translate function, demoted to extern
pub extern fn xPortCanYield() bool;
pub extern fn vApplicationSleep(xExpectedIdleTime: TickType_t) void;
pub extern fn xPortGetTickRateHz() u32;
pub extern fn vPortSetStackWatchpoint(pxStackStart: ?*anyopaque) void;
pub inline fn xPortGetCoreID() BaseType_t {
    return @as(BaseType_t, @bitCast(esp_cpu_get_core_id()));
}
pub extern fn vPortTCBPreDeleteHook(pxTCB: ?*anyopaque) void;
pub extern fn _frxt_setup_switch() void;
pub extern fn xPortCheckValidListMem(ptr: ?*const anyopaque) bool;
pub extern fn xPortCheckValidTCBMem(ptr: ?*const anyopaque) bool;
pub extern fn xPortcheckValidStackMem(ptr: ?*const anyopaque) bool;
pub extern fn pxPortInitialiseStack(pxTopOfStack: [*c]StackType_t, pxCode: TaskFunction_t, pvParameters: ?*anyopaque) [*c]StackType_t;
pub const HeapRegion = extern struct {
    pucStartAddress: [*:0]u8 = std.mem.zeroes([*:0]u8),
    xSizeInBytes: usize = std.mem.zeroes(usize),
};
pub const HeapRegion_t = HeapRegion;
pub const xHeapStats = extern struct {
    xAvailableHeapSpaceInBytes: usize = std.mem.zeroes(usize),
    xSizeOfLargestFreeBlockInBytes: usize = std.mem.zeroes(usize),
    xSizeOfSmallestFreeBlockInBytes: usize = std.mem.zeroes(usize),
    xNumberOfFreeBlocks: usize = std.mem.zeroes(usize),
    xMinimumEverFreeBytesRemaining: usize = std.mem.zeroes(usize),
    xNumberOfSuccessfulAllocations: usize = std.mem.zeroes(usize),
    xNumberOfSuccessfulFrees: usize = std.mem.zeroes(usize),
};
pub const HeapStats_t = xHeapStats;
pub extern fn vPortDefineHeapRegions(pxHeapRegions: [*c]const HeapRegion_t) void;
pub extern fn vPortGetHeapStats(pxHeapStats: [*c]HeapStats_t) void;
pub extern fn pvPortMalloc(xSize: usize) ?*anyopaque;
pub extern fn vPortFree(pv: ?*anyopaque) void;
pub extern fn vPortInitialiseBlocks() void;
pub extern fn xPortGetFreeHeapSize() usize;
pub extern fn xPortGetMinimumEverFreeHeapSize() usize;
pub extern fn xPortStartScheduler() BaseType_t;
pub extern fn vPortEndScheduler() void;
pub const stat = opaque {};
pub const tms = opaque {};
pub const timezone = opaque {};
pub const xSTATIC_LIST_ITEM = extern struct {
    xDummy2: TickType_t = std.mem.zeroes(TickType_t),
    pvDummy3: [4]?*anyopaque = std.mem.zeroes([4]?*anyopaque),
};
pub const StaticListItem_t = xSTATIC_LIST_ITEM;
pub const xSTATIC_MINI_LIST_ITEM = extern struct {
    xDummy2: TickType_t = std.mem.zeroes(TickType_t),
    pvDummy3: [2]?*anyopaque = std.mem.zeroes([2]?*anyopaque),
};
pub const StaticMiniListItem_t = xSTATIC_MINI_LIST_ITEM;
pub const xSTATIC_LIST = extern struct {
    uxDummy2: UBaseType_t = std.mem.zeroes(UBaseType_t),
    pvDummy3: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    xDummy4: StaticMiniListItem_t = std.mem.zeroes(StaticMiniListItem_t),
};
pub const StaticList_t = xSTATIC_LIST;
pub const xSTATIC_TCB = extern struct {
    pxDummy1: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    xDummy3: [2]StaticListItem_t = std.mem.zeroes([2]StaticListItem_t),
    uxDummy5: UBaseType_t = std.mem.zeroes(UBaseType_t),
    pxDummy6: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    xDummy23: [2]BaseType_t = std.mem.zeroes([2]BaseType_t),
    ucDummy7: [16]u8 = std.mem.zeroes([16]u8),
    pxDummy8: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    uxDummy12: [2]UBaseType_t = std.mem.zeroes([2]UBaseType_t),
    pvDummy15: [2]?*anyopaque = std.mem.zeroes([2]?*anyopaque),
    xDummy17: opaque {},
    ulDummy18: [1]u32 = std.mem.zeroes([1]u32),
    ucDummy19: [1]u8 = std.mem.zeroes([1]u8),
    uxDummy20: u8 = std.mem.zeroes(u8),
    ucDummy21: u8 = std.mem.zeroes(u8),
};
pub const StaticTask_t = xSTATIC_TCB;
const union_unnamed_4 = extern union {
    pvDummy2: ?*anyopaque,
    uxDummy2: UBaseType_t,
};
pub const xSTATIC_QUEUE = extern struct {
    pvDummy1: [3]?*anyopaque = std.mem.zeroes([3]?*anyopaque),
    u: union_unnamed_4 = std.mem.zeroes(union_unnamed_4),
    xDummy3: [2]StaticList_t = std.mem.zeroes([2]StaticList_t),
    uxDummy4: [3]UBaseType_t = std.mem.zeroes([3]UBaseType_t),
    ucDummy5: [2]u8 = std.mem.zeroes([2]u8),
    ucDummy6: u8 = std.mem.zeroes(u8),
    pvDummy7: ?*anyopaque = std.mem.zeroes(?*anyopaque),
};
pub const StaticQueue_t = xSTATIC_QUEUE;
pub const StaticSemaphore_t = StaticQueue_t;
pub const xSTATIC_EVENT_GROUP = extern struct {
    xDummy1: TickType_t = std.mem.zeroes(TickType_t),
    xDummy2: StaticList_t = std.mem.zeroes(StaticList_t),
    ucDummy4: u8 = std.mem.zeroes(u8),
};
pub const StaticEventGroup_t = xSTATIC_EVENT_GROUP;
pub const xSTATIC_TIMER = extern struct {
    pvDummy1: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    xDummy2: StaticListItem_t = std.mem.zeroes(StaticListItem_t),
    xDummy3: TickType_t = std.mem.zeroes(TickType_t),
    pvDummy5: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    pvDummy6: TaskFunction_t = std.mem.zeroes(TaskFunction_t),
    ucDummy8: u8 = std.mem.zeroes(u8),
};
pub const StaticTimer_t = xSTATIC_TIMER;
pub const xSTATIC_STREAM_BUFFER = extern struct {
    uxDummy1: [4]usize = std.mem.zeroes([4]usize),
    pvDummy2: [3]?*anyopaque = std.mem.zeroes([3]?*anyopaque),
    ucDummy3: u8 = std.mem.zeroes(u8),
};
pub const StaticStreamBuffer_t = xSTATIC_STREAM_BUFFER;
pub const StaticMessageBuffer_t = StaticStreamBuffer_t;
pub const xLIST_ITEM = extern struct {
    xItemValue: TickType_t = std.mem.zeroes(TickType_t),
    pxNext: [*c]xLIST_ITEM = std.mem.zeroes([*c]xLIST_ITEM),
    pxPrevious: [*c]xLIST_ITEM = std.mem.zeroes([*c]xLIST_ITEM),
    pvOwner: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    pxContainer: [*c]xLIST = std.mem.zeroes([*c]xLIST),
};
pub const ListItem_t = xLIST_ITEM;
pub const xMINI_LIST_ITEM = extern struct {
    xItemValue: TickType_t = std.mem.zeroes(TickType_t),
    pxNext: [*c]xLIST_ITEM = std.mem.zeroes([*c]xLIST_ITEM),
    pxPrevious: [*c]xLIST_ITEM = std.mem.zeroes([*c]xLIST_ITEM),
};
pub const MiniListItem_t = xMINI_LIST_ITEM;
pub const xLIST = extern struct {
    uxNumberOfItems: UBaseType_t = std.mem.zeroes(UBaseType_t),
    pxIndex: [*c]ListItem_t = std.mem.zeroes([*c]ListItem_t),
    xListEnd: MiniListItem_t = std.mem.zeroes(MiniListItem_t),
};
pub const List_t = xLIST;
pub extern fn vListInitialise(pxList: [*c]List_t) void;
pub extern fn vListInitialiseItem(pxItem: [*c]ListItem_t) void;
pub extern fn vListInsert(pxList: [*c]List_t, pxNewListItem: [*c]ListItem_t) void;
pub extern fn vListInsertEnd(pxList: [*c]List_t, pxNewListItem: [*c]ListItem_t) void;
pub extern fn uxListRemove(pxItemToRemove: [*c]ListItem_t) UBaseType_t;
pub const tskTaskControlBlock = opaque {};
pub const TaskHandle_t = ?*tskTaskControlBlock;
pub const TaskHookFunction_t = ?*const fn (?*anyopaque) callconv(.C) BaseType_t;
pub const eRunning: c_int = 0;
pub const eReady: c_int = 1;
pub const eBlocked: c_int = 2;
pub const eSuspended: c_int = 3;
pub const eDeleted: c_int = 4;
pub const eInvalid: c_int = 5;
pub const eTaskState = c_uint;
pub const eNoAction: c_int = 0;
pub const eSetBits: c_int = 1;
pub const eIncrement: c_int = 2;
pub const eSetValueWithOverwrite: c_int = 3;
pub const eSetValueWithoutOverwrite: c_int = 4;
pub const eNotifyAction = c_uint;
pub const xTIME_OUT = extern struct {
    xOverflowCount: BaseType_t = std.mem.zeroes(BaseType_t),
    xTimeOnEntering: TickType_t = std.mem.zeroes(TickType_t),
};
pub const TimeOut_t = xTIME_OUT;
pub const xMEMORY_REGION = extern struct {
    pvBaseAddress: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    ulLengthInBytes: u32 = std.mem.zeroes(u32),
    ulParameters: u32 = std.mem.zeroes(u32),
};
pub const MemoryRegion_t = xMEMORY_REGION;
pub const xTASK_PARAMETERS = extern struct {
    pvTaskCode: TaskFunction_t = std.mem.zeroes(TaskFunction_t),
    pcName: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    usStackDepth: u32 = std.mem.zeroes(u32),
    pvParameters: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    uxPriority: UBaseType_t = std.mem.zeroes(UBaseType_t),
    puxStackBuffer: [*c]StackType_t = std.mem.zeroes([*c]StackType_t),
    xRegions: [1]MemoryRegion_t = std.mem.zeroes([1]MemoryRegion_t),
};
pub const TaskParameters_t = xTASK_PARAMETERS;
pub const xTASK_STATUS = extern struct {
    xHandle: TaskHandle_t = std.mem.zeroes(TaskHandle_t),
    pcTaskName: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    xTaskNumber: UBaseType_t = std.mem.zeroes(UBaseType_t),
    eCurrentState: eTaskState = std.mem.zeroes(eTaskState),
    uxCurrentPriority: UBaseType_t = std.mem.zeroes(UBaseType_t),
    uxBasePriority: UBaseType_t = std.mem.zeroes(UBaseType_t),
    ulRunTimeCounter: u32 = std.mem.zeroes(u32),
    pxStackBase: [*c]StackType_t = std.mem.zeroes([*c]StackType_t),
    usStackHighWaterMark: u32 = std.mem.zeroes(u32),
};
pub const TaskStatus_t = xTASK_STATUS;
pub const eAbortSleep: c_int = 0;
pub const eStandardSleep: c_int = 1;
pub const eNoTasksWaitingTimeout: c_int = 2;
pub const eSleepModeStatus = c_uint;
pub extern fn xTaskCreatePinnedToCore(pxTaskCode: TaskFunction_t, pcName: [*c]const u8, usStackDepth: u32, pvParameters: ?*anyopaque, uxPriority: UBaseType_t, pvCreatedTask: [*c]TaskHandle_t, xCoreID: BaseType_t) BaseType_t;
pub inline fn xTaskCreate(arg_pxTaskCode: TaskFunction_t, pcName: [*c]const u8, usStackDepth: u32, pvParameters: ?*anyopaque, arg_uxPriority: UBaseType_t, pxCreatedTask: [*c]TaskHandle_t) BaseType_t {
    var pxTaskCode = arg_pxTaskCode;
    _ = &pxTaskCode;
    _ = &pcName;
    _ = &usStackDepth;
    _ = &pvParameters;
    var uxPriority = arg_uxPriority;
    _ = &uxPriority;
    _ = &pxCreatedTask;
    return xTaskCreatePinnedToCore(pxTaskCode, pcName, usStackDepth, pvParameters, uxPriority, pxCreatedTask, @as(BaseType_t, @bitCast(@as(c_int, 2147483647))));
}
pub extern fn xTaskCreateStaticPinnedToCore(pxTaskCode: TaskFunction_t, pcName: [*c]const u8, ulStackDepth: u32, pvParameters: ?*anyopaque, uxPriority: UBaseType_t, pxStackBuffer: [*c]StackType_t, pxTaskBuffer: [*c]StaticTask_t, xCoreID: BaseType_t) TaskHandle_t;
pub inline fn xTaskCreateStatic(arg_pxTaskCode: TaskFunction_t, pcName: [*c]const u8, ulStackDepth: u32, pvParameters: ?*anyopaque, arg_uxPriority: UBaseType_t, puxStackBuffer: [*c]StackType_t, pxTaskBuffer: [*c]StaticTask_t) TaskHandle_t {
    var pxTaskCode = arg_pxTaskCode;
    _ = &pxTaskCode;
    _ = &pcName;
    _ = &ulStackDepth;
    _ = &pvParameters;
    var uxPriority = arg_uxPriority;
    _ = &uxPriority;
    _ = &puxStackBuffer;
    _ = &pxTaskBuffer;
    return xTaskCreateStaticPinnedToCore(pxTaskCode, pcName, ulStackDepth, pvParameters, uxPriority, puxStackBuffer, pxTaskBuffer, @as(BaseType_t, @bitCast(@as(c_int, 2147483647))));
}
pub extern fn vTaskAllocateMPURegions(xTask: TaskHandle_t, pxRegions: [*c]const MemoryRegion_t) void;
pub extern fn vTaskDelete(xTaskToDelete: TaskHandle_t) void;
pub extern fn vTaskDelay(xTicksToDelay: TickType_t) void;
pub extern fn xTaskDelayUntil(pxPreviousWakeTime: [*c]TickType_t, xTimeIncrement: TickType_t) BaseType_t;
pub extern fn xTaskAbortDelay(xTask: TaskHandle_t) BaseType_t;
pub extern fn uxTaskPriorityGet(xTask: TaskHandle_t) UBaseType_t;
pub extern fn uxTaskPriorityGetFromISR(xTask: TaskHandle_t) UBaseType_t;
pub extern fn eTaskGetState(xTask: TaskHandle_t) eTaskState;
pub extern fn vTaskGetInfo(xTask: TaskHandle_t, pxTaskStatus: [*c]TaskStatus_t, xGetFreeStackSpace: BaseType_t, eState: eTaskState) void;
pub extern fn vTaskPrioritySet(xTask: TaskHandle_t, uxNewPriority: UBaseType_t) void;
pub extern fn vTaskSuspend(xTaskToSuspend: TaskHandle_t) void;
pub extern fn vTaskResume(xTaskToResume: TaskHandle_t) void;
pub extern fn xTaskResumeFromISR(xTaskToResume: TaskHandle_t) BaseType_t;
pub extern fn vTaskPreemptionDisable(xTask: TaskHandle_t) void;
pub extern fn vTaskPreemptionEnable(xTask: TaskHandle_t) void;
pub extern fn vTaskStartScheduler() void;
pub extern fn vTaskEndScheduler() void;
pub extern fn vTaskSuspendAll() void;
pub extern fn xTaskResumeAll() BaseType_t;
pub extern fn xTaskGetTickCount() TickType_t;
pub extern fn xTaskGetTickCountFromISR() TickType_t;
pub extern fn uxTaskGetNumberOfTasks() UBaseType_t;
pub extern fn pcTaskGetName(xTaskToQuery: TaskHandle_t) [*:0]u8;
pub extern fn xTaskGetHandle(pcNameToQuery: [*:0]const u8) TaskHandle_t;
pub extern fn xTaskGetStaticBuffers(xTask: TaskHandle_t, ppuxStackBuffer: [*c][*c]StackType_t, ppxTaskBuffer: [*c][*c]StaticTask_t) BaseType_t;
pub extern fn uxTaskGetStackHighWaterMark(xTask: TaskHandle_t) UBaseType_t;
pub extern fn uxTaskGetStackHighWaterMark2(xTask: TaskHandle_t) u32;
pub extern fn vTaskSetThreadLocalStoragePointer(xTaskToSet: TaskHandle_t, xIndex: BaseType_t, pvValue: ?*anyopaque) void;
pub extern fn pvTaskGetThreadLocalStoragePointer(xTaskToQuery: TaskHandle_t, xIndex: BaseType_t) ?*anyopaque;
pub extern fn vApplicationStackOverflowHook(xTask: TaskHandle_t, pcTaskName: [*:0]u8) void;
pub extern fn vApplicationGetIdleTaskMemory(ppxIdleTaskTCBBuffer: [*c][*c]StaticTask_t, ppxIdleTaskStackBuffer: [*c][*c]StackType_t, pulIdleTaskStackSize: [*c]u32) void;
pub extern fn xTaskCallApplicationTaskHook(xTask: TaskHandle_t, pvParameter: ?*anyopaque) BaseType_t;
pub extern fn xTaskGetIdleTaskHandle() [*c]TaskHandle_t;
pub extern fn uxTaskGetSystemState(pxTaskStatusArray: [*c]TaskStatus_t, uxArraySize: UBaseType_t, pulTotalRunTime: [*c]u32) UBaseType_t;
pub extern fn vTaskList(pcWriteBuffer: [*:0]u8) void;
pub extern fn vTaskGetRunTimeStats(pcWriteBuffer: [*:0]u8) void;
pub extern fn ulTaskGetIdleRunTimeCounter() u32;
pub extern fn xTaskGenericNotify(xTaskToNotify: TaskHandle_t, uxIndexToNotify: UBaseType_t, ulValue: u32, eAction: eNotifyAction, pulPreviousNotificationValue: [*c]u32) BaseType_t;
pub extern fn xTaskGenericNotifyFromISR(xTaskToNotify: TaskHandle_t, uxIndexToNotify: UBaseType_t, ulValue: u32, eAction: eNotifyAction, pulPreviousNotificationValue: [*c]u32, pxHigherPriorityTaskWoken: [*c]BaseType_t) BaseType_t;
pub extern fn xTaskGenericNotifyWait(uxIndexToWaitOn: UBaseType_t, ulBitsToClearOnEntry: u32, ulBitsToClearOnExit: u32, pulNotificationValue: [*c]u32, xTicksToWait: TickType_t) BaseType_t;
pub extern fn vTaskGenericNotifyGiveFromISR(xTaskToNotify: TaskHandle_t, uxIndexToNotify: UBaseType_t, pxHigherPriorityTaskWoken: [*c]BaseType_t) void;
pub extern fn ulTaskGenericNotifyTake(uxIndexToWaitOn: UBaseType_t, xClearCountOnExit: BaseType_t, xTicksToWait: TickType_t) u32;
pub extern fn xTaskGenericNotifyStateClear(xTask: TaskHandle_t, uxIndexToClear: UBaseType_t) BaseType_t;
pub extern fn ulTaskGenericNotifyValueClear(xTask: TaskHandle_t, uxIndexToClear: UBaseType_t, ulBitsToClear: u32) u32;
pub extern fn vTaskSetTimeOutState(pxTimeOut: [*c]TimeOut_t) void;
pub extern fn xTaskCheckForTimeOut(pxTimeOut: [*c]TimeOut_t, pxTicksToWait: [*c]TickType_t) BaseType_t;
pub extern fn xTaskCatchUpTicks(xTicksToCatchUp: TickType_t) BaseType_t;
pub extern fn xTaskIncrementTick() BaseType_t;
pub extern fn vTaskPlaceOnEventList(pxEventList: [*c]List_t, xTicksToWait: TickType_t) void;
pub extern fn vTaskPlaceOnUnorderedEventList(pxEventList: [*c]List_t, xItemValue: TickType_t, xTicksToWait: TickType_t) void;
pub extern fn vTaskPlaceOnEventListRestricted(pxEventList: [*c]List_t, xTicksToWait: TickType_t, xWaitIndefinitely: BaseType_t) void;
pub extern fn xTaskRemoveFromEventList(pxEventList: [*c]const List_t) BaseType_t;
pub extern fn vTaskRemoveFromUnorderedEventList(pxEventListItem: [*c]ListItem_t, xItemValue: TickType_t) void;
pub extern fn vTaskSwitchContext(xCoreID: BaseType_t) void;
pub extern fn uxTaskResetEventItemValue() TickType_t;
pub extern fn xTaskGetCurrentTaskHandle() TaskHandle_t;
pub extern fn xTaskGetCurrentTaskHandleCPU(xCoreID: UBaseType_t) TaskHandle_t;
pub extern fn vTaskMissedYield() void;
pub extern fn xTaskGetSchedulerState() BaseType_t;
pub extern fn xTaskPriorityInherit(pxMutexHolder: TaskHandle_t) BaseType_t;
pub extern fn xTaskPriorityDisinherit(pxMutexHolder: TaskHandle_t) BaseType_t;
pub extern fn vTaskPriorityDisinheritAfterTimeout(pxMutexHolder: TaskHandle_t, uxHighestPriorityWaitingTask: UBaseType_t) void;
pub extern fn uxTaskGetTaskNumber(xTask: TaskHandle_t) UBaseType_t;
pub extern fn vTaskSetTaskNumber(xTask: TaskHandle_t, uxHandle: UBaseType_t) void;
pub extern fn vTaskStepTick(xTicksToJump: TickType_t) void;
pub extern fn eTaskConfirmSleepModeStatus() eSleepModeStatus;
pub extern fn pvTaskIncrementMutexHeldCount() TaskHandle_t;
pub extern fn vTaskInternalSetTimeOutState(pxTimeOut: [*c]TimeOut_t) void;
pub extern fn vTaskYieldWithinAPI() void;
pub const esp_task_wdt_config_t = extern struct {
    timeout_ms: u32 = std.mem.zeroes(u32),
    idle_core_mask: u32 = std.mem.zeroes(u32),
    trigger_panic: bool = std.mem.zeroes(bool),
};
pub const esp_task_wdt_user_handle_s = opaque {};
pub const esp_task_wdt_user_handle_t = ?*esp_task_wdt_user_handle_s;
pub extern fn esp_task_wdt_init(config: [*c]const esp_task_wdt_config_t) esp_err_t;
pub extern fn esp_task_wdt_reconfigure(config: [*c]const esp_task_wdt_config_t) esp_err_t;
pub extern fn esp_task_wdt_deinit() esp_err_t;
pub extern fn esp_task_wdt_add(task_handle: TaskHandle_t) esp_err_t;
pub extern fn esp_task_wdt_add_user(user_name: [*:0]const u8, user_handle_ret: [*c]esp_task_wdt_user_handle_t) esp_err_t;
pub extern fn esp_task_wdt_reset() esp_err_t;
pub extern fn esp_task_wdt_reset_user(user_handle: esp_task_wdt_user_handle_t) esp_err_t;
pub extern fn esp_task_wdt_delete(task_handle: TaskHandle_t) esp_err_t;
pub extern fn esp_task_wdt_delete_user(user_handle: esp_task_wdt_user_handle_t) esp_err_t;
pub extern fn esp_task_wdt_status(task_handle: TaskHandle_t) esp_err_t;
pub extern fn esp_task_wdt_isr_user_handler() void;
pub const task_wdt_msg_handler = ?*const fn (?*anyopaque, [*:0]const u8) callconv(.C) void;
pub extern fn esp_task_wdt_print_triggered_tasks(msg_handler: task_wdt_msg_handler, @"opaque": ?*anyopaque, cpus_fail: [*c]c_int) esp_err_t;
pub const esp_interface_t = enum(c_uint) {
    ESP_IF_WIFI_STA = 0,
    ESP_IF_WIFI_AP = 1,
    ESP_IF_WIFI_NAN = 2,
    ESP_IF_ETH = 3,
    ESP_IF_MAX = 4,
};
pub const esp_ipc_func_t = ?*const fn (?*anyopaque) callconv(.C) void;
pub extern fn esp_ipc_call(cpu_id: u32, func: esp_ipc_func_t, arg: ?*anyopaque) esp_err_t;
pub extern fn esp_ipc_call_blocking(cpu_id: u32, func: esp_ipc_func_t, arg: ?*anyopaque) esp_err_t;
pub const esp_mac_type_t = enum(c_uint) {
    ESP_MAC_WIFI_STA = 0,
    ESP_MAC_WIFI_SOFTAP = 1,
    ESP_MAC_BT = 2,
    ESP_MAC_ETH = 3,
    ESP_MAC_IEEE802154 = 4,
    ESP_MAC_BASE = 5,
    ESP_MAC_EFUSE_FACTORY = 6,
    ESP_MAC_EFUSE_CUSTOM = 7,
    ESP_MAC_EFUSE_EXT = 8,
};
pub extern fn esp_base_mac_addr_set(mac: [*:0]const u8) esp_err_t;
pub extern fn esp_base_mac_addr_get(mac: [*:0]u8) esp_err_t;
pub extern fn esp_efuse_mac_get_custom(mac: [*:0]u8) esp_err_t;
pub extern fn esp_efuse_mac_get_default(mac: [*:0]u8) esp_err_t;
pub extern fn esp_read_mac(mac: [*:0]u8, @"type": esp_mac_type_t) esp_err_t;
pub extern fn esp_derive_local_mac(local_mac: [*:0]u8, universal_mac: [*:0]const u8) esp_err_t;
pub extern fn esp_iface_mac_addr_set(mac: [*:0]const u8, @"type": esp_mac_type_t) esp_err_t;
pub extern fn esp_mac_addr_len_get(@"type": esp_mac_type_t) usize;
pub const esp_freertos_idle_cb_t = ?*const fn () callconv(.C) bool;
pub const esp_freertos_tick_cb_t = ?*const fn () callconv(.C) void;
pub extern fn esp_register_freertos_idle_hook_for_cpu(new_idle_cb: esp_freertos_idle_cb_t, cpuid: UBaseType_t) esp_err_t;
pub extern fn esp_register_freertos_idle_hook(new_idle_cb: esp_freertos_idle_cb_t) esp_err_t;
pub extern fn esp_register_freertos_tick_hook_for_cpu(new_tick_cb: esp_freertos_tick_cb_t, cpuid: UBaseType_t) esp_err_t;
pub extern fn esp_register_freertos_tick_hook(new_tick_cb: esp_freertos_tick_cb_t) esp_err_t;
pub extern fn esp_deregister_freertos_idle_hook_for_cpu(old_idle_cb: esp_freertos_idle_cb_t, cpuid: UBaseType_t) void;
pub extern fn esp_deregister_freertos_idle_hook(old_idle_cb: esp_freertos_idle_cb_t) void;
pub extern fn esp_deregister_freertos_tick_hook_for_cpu(old_tick_cb: esp_freertos_tick_cb_t, cpuid: UBaseType_t) void;
pub extern fn esp_deregister_freertos_tick_hook(old_tick_cb: esp_freertos_tick_cb_t) void;
pub fn Atomic_CompareAndSwap_u32(arg_pulDestination: [*c]volatile u32, arg_ulExchange: u32, arg_ulComparand: u32) callconv(.C) u32 {
    var pulDestination = arg_pulDestination;
    _ = &pulDestination;
    var ulExchange = arg_ulExchange;
    _ = &ulExchange;
    var ulComparand = arg_ulComparand;
    _ = &ulComparand;
    var ulReturnValue: u32 = undefined;
    _ = &ulReturnValue;
    var uxCriticalSectionType: UBaseType_t = xPortSetInterruptMaskFromISR();
    _ = &uxCriticalSectionType;
    {
        if (pulDestination.* == ulComparand) {
            pulDestination.* = ulExchange;
            ulReturnValue = 1;
        } else {
            ulReturnValue = 0;
        }
    }
    vPortClearInterruptMaskFromISR(uxCriticalSectionType);
    return ulReturnValue;
}
pub fn Atomic_SwapPointers_p32(arg_ppvDestination: [*c]volatile ?*anyopaque, arg_pvExchange: ?*anyopaque) callconv(.C) ?*anyopaque {
    var ppvDestination = arg_ppvDestination;
    _ = &ppvDestination;
    var pvExchange = arg_pvExchange;
    _ = &pvExchange;
    var pReturnValue: ?*anyopaque = undefined;
    _ = &pReturnValue;
    var uxCriticalSectionType: UBaseType_t = xPortSetInterruptMaskFromISR();
    _ = &uxCriticalSectionType;
    {
        pReturnValue = ppvDestination.*;
        ppvDestination.* = pvExchange;
    }
    vPortClearInterruptMaskFromISR(uxCriticalSectionType);
    return pReturnValue;
}
pub fn Atomic_CompareAndSwapPointers_p32(arg_ppvDestination: [*c]volatile ?*anyopaque, arg_pvExchange: ?*anyopaque, arg_pvComparand: ?*anyopaque) callconv(.C) u32 {
    var ppvDestination = arg_ppvDestination;
    _ = &ppvDestination;
    var pvExchange = arg_pvExchange;
    _ = &pvExchange;
    var pvComparand = arg_pvComparand;
    _ = &pvComparand;
    var ulReturnValue: u32 = 0;
    _ = &ulReturnValue;
    var uxCriticalSectionType: UBaseType_t = xPortSetInterruptMaskFromISR();
    _ = &uxCriticalSectionType;
    {
        if (ppvDestination.* == pvComparand) {
            ppvDestination.* = pvExchange;
            ulReturnValue = 1;
        }
    }
    vPortClearInterruptMaskFromISR(uxCriticalSectionType);
    return ulReturnValue;
}
pub fn Atomic_Add_u32(arg_pulAddend: [*c]volatile u32, arg_ulCount: u32) callconv(.C) u32 {
    var pulAddend = arg_pulAddend;
    _ = &pulAddend;
    var ulCount = arg_ulCount;
    _ = &ulCount;
    var ulCurrent: u32 = undefined;
    _ = &ulCurrent;
    var uxCriticalSectionType: UBaseType_t = xPortSetInterruptMaskFromISR();
    _ = &uxCriticalSectionType;
    {
        ulCurrent = pulAddend.*;
        pulAddend.* +%= @as(u32, @bitCast(ulCount));
    }
    vPortClearInterruptMaskFromISR(uxCriticalSectionType);
    return ulCurrent;
}
pub fn Atomic_Subtract_u32(arg_pulAddend: [*c]volatile u32, arg_ulCount: u32) callconv(.C) u32 {
    var pulAddend = arg_pulAddend;
    _ = &pulAddend;
    var ulCount = arg_ulCount;
    _ = &ulCount;
    var ulCurrent: u32 = undefined;
    _ = &ulCurrent;
    var uxCriticalSectionType: UBaseType_t = xPortSetInterruptMaskFromISR();
    _ = &uxCriticalSectionType;
    {
        ulCurrent = pulAddend.*;
        pulAddend.* -%= @as(u32, @bitCast(ulCount));
    }
    vPortClearInterruptMaskFromISR(uxCriticalSectionType);
    return ulCurrent;
}
pub fn Atomic_Increment_u32(arg_pulAddend: [*c]volatile u32) callconv(.C) u32 {
    var pulAddend = arg_pulAddend;
    _ = &pulAddend;
    var ulCurrent: u32 = undefined;
    _ = &ulCurrent;
    var uxCriticalSectionType: UBaseType_t = xPortSetInterruptMaskFromISR();
    _ = &uxCriticalSectionType;
    {
        ulCurrent = pulAddend.*;
        pulAddend.* +%= @as(u32, @bitCast(@as(u32, @bitCast(@as(c_int, 1)))));
    }
    vPortClearInterruptMaskFromISR(uxCriticalSectionType);
    return ulCurrent;
}
pub fn Atomic_Decrement_u32(arg_pulAddend: [*c]volatile u32) callconv(.C) u32 {
    var pulAddend = arg_pulAddend;
    _ = &pulAddend;
    var ulCurrent: u32 = undefined;
    _ = &ulCurrent;
    var uxCriticalSectionType: UBaseType_t = xPortSetInterruptMaskFromISR();
    _ = &uxCriticalSectionType;
    {
        ulCurrent = pulAddend.*;
        pulAddend.* -%= @as(u32, @bitCast(@as(u32, @bitCast(@as(c_int, 1)))));
    }
    vPortClearInterruptMaskFromISR(uxCriticalSectionType);
    return ulCurrent;
}
pub fn Atomic_OR_u32(arg_pulDestination: [*c]volatile u32, arg_ulValue: u32) callconv(.C) u32 {
    var pulDestination = arg_pulDestination;
    _ = &pulDestination;
    var ulValue = arg_ulValue;
    _ = &ulValue;
    var ulCurrent: u32 = undefined;
    _ = &ulCurrent;
    var uxCriticalSectionType: UBaseType_t = xPortSetInterruptMaskFromISR();
    _ = &uxCriticalSectionType;
    {
        ulCurrent = pulDestination.*;
        pulDestination.* |= @as(u32, @bitCast(ulValue));
    }
    vPortClearInterruptMaskFromISR(uxCriticalSectionType);
    return ulCurrent;
}
pub fn Atomic_AND_u32(arg_pulDestination: [*c]volatile u32, arg_ulValue: u32) callconv(.C) u32 {
    var pulDestination = arg_pulDestination;
    _ = &pulDestination;
    var ulValue = arg_ulValue;
    _ = &ulValue;
    var ulCurrent: u32 = undefined;
    _ = &ulCurrent;
    var uxCriticalSectionType: UBaseType_t = xPortSetInterruptMaskFromISR();
    _ = &uxCriticalSectionType;
    {
        ulCurrent = pulDestination.*;
        pulDestination.* &= @as(u32, @bitCast(ulValue));
    }
    vPortClearInterruptMaskFromISR(uxCriticalSectionType);
    return ulCurrent;
}
pub fn Atomic_NAND_u32(arg_pulDestination: [*c]volatile u32, arg_ulValue: u32) callconv(.C) u32 {
    var pulDestination = arg_pulDestination;
    _ = &pulDestination;
    var ulValue = arg_ulValue;
    _ = &ulValue;
    var ulCurrent: u32 = undefined;
    _ = &ulCurrent;
    var uxCriticalSectionType: UBaseType_t = xPortSetInterruptMaskFromISR();
    _ = &uxCriticalSectionType;
    {
        ulCurrent = pulDestination.*;
        pulDestination.* = ~(ulCurrent & ulValue);
    }
    vPortClearInterruptMaskFromISR(uxCriticalSectionType);
    return ulCurrent;
}
pub fn Atomic_XOR_u32(arg_pulDestination: [*c]volatile u32, arg_ulValue: u32) callconv(.C) u32 {
    var pulDestination = arg_pulDestination;
    _ = &pulDestination;
    var ulValue = arg_ulValue;
    _ = &ulValue;
    var ulCurrent: u32 = undefined;
    _ = &ulCurrent;
    var uxCriticalSectionType: UBaseType_t = xPortSetInterruptMaskFromISR();
    _ = &uxCriticalSectionType;
    {
        ulCurrent = pulDestination.*;
        pulDestination.* ^= @as(u32, @bitCast(ulValue));
    }
    vPortClearInterruptMaskFromISR(uxCriticalSectionType);
    return ulCurrent;
}
pub const tmrTimerControl = opaque {};
pub const TimerHandle_t = ?*tmrTimerControl;
pub const TimerCallbackFunction_t = ?*const fn (TimerHandle_t) callconv(.C) void;
pub const PendedFunction_t = ?*const fn (?*anyopaque, u32) callconv(.C) void;
pub extern fn xTimerCreate(pcTimerName: [*:0]const u8, xTimerPeriodInTicks: TickType_t, uxAutoReload: UBaseType_t, pvTimerID: ?*anyopaque, pxCallbackFunction: TimerCallbackFunction_t) TimerHandle_t;
pub extern fn xTimerCreateStatic(pcTimerName: [*:0]const u8, xTimerPeriodInTicks: TickType_t, uxAutoReload: UBaseType_t, pvTimerID: ?*anyopaque, pxCallbackFunction: TimerCallbackFunction_t, pxTimerBuffer: [*c]StaticTimer_t) TimerHandle_t;
pub extern fn pvTimerGetTimerID(xTimer: TimerHandle_t) ?*anyopaque;
pub extern fn vTimerSetTimerID(xTimer: TimerHandle_t, pvNewID: ?*anyopaque) void;
pub extern fn xTimerIsTimerActive(xTimer: TimerHandle_t) BaseType_t;
pub extern fn xTimerGetTimerDaemonTaskHandle() TaskHandle_t;
pub extern fn xTimerPendFunctionCallFromISR(xFunctionToPend: PendedFunction_t, pvParameter1: ?*anyopaque, ulParameter2: u32, pxHigherPriorityTaskWoken: [*c]BaseType_t) BaseType_t;
pub extern fn xTimerPendFunctionCall(xFunctionToPend: PendedFunction_t, pvParameter1: ?*anyopaque, ulParameter2: u32, xTicksToWait: TickType_t) BaseType_t;
pub extern fn pcTimerGetName(xTimer: TimerHandle_t) [*:0]const u8;
pub extern fn vTimerSetReloadMode(xTimer: TimerHandle_t, uxAutoReload: UBaseType_t) void;
pub extern fn uxTimerGetReloadMode(xTimer: TimerHandle_t) UBaseType_t;
pub extern fn xTimerGetPeriod(xTimer: TimerHandle_t) TickType_t;
pub extern fn xTimerGetExpiryTime(xTimer: TimerHandle_t) TickType_t;
pub extern fn xTimerGetStaticBuffer(xTimer: TimerHandle_t, ppxTimerBuffer: [*c][*c]StaticTimer_t) BaseType_t;
pub extern fn xTimerCreateTimerTask() BaseType_t;
pub extern fn xTimerGenericCommandFromTask(xTimer: TimerHandle_t, xCommandID: BaseType_t, xOptionalValue: TickType_t, pxHigherPriorityTaskWoken: [*c]BaseType_t, xTicksToWait: TickType_t) BaseType_t;
pub extern fn xTimerGenericCommandFromISR(xTimer: TimerHandle_t, xCommandID: BaseType_t, xOptionalValue: TickType_t, pxHigherPriorityTaskWoken: [*c]BaseType_t, xTicksToWait: TickType_t) BaseType_t;
pub extern fn vApplicationGetTimerTaskMemory(ppxTimerTaskTCBBuffer: [*c][*c]StaticTask_t, ppxTimerTaskStackBuffer: [*c][*c]StackType_t, pulTimerTaskStackSize: [*c]u32) void;
pub const EventGroupDef_t = opaque {};
pub const EventGroupHandle_t = ?*EventGroupDef_t;
pub const EventBits_t = TickType_t;
pub extern fn xEventGroupCreate() EventGroupHandle_t;
pub extern fn xEventGroupCreateStatic(pxEventGroupBuffer: [*c]StaticEventGroup_t) EventGroupHandle_t;
pub extern fn xEventGroupWaitBits(xEventGroup: EventGroupHandle_t, uxBitsToWaitFor: EventBits_t, xClearOnExit: BaseType_t, xWaitForAllBits: BaseType_t, xTicksToWait: TickType_t) EventBits_t;
pub extern fn xEventGroupClearBits(xEventGroup: EventGroupHandle_t, uxBitsToClear: EventBits_t) EventBits_t;
pub extern fn xEventGroupSetBits(xEventGroup: EventGroupHandle_t, uxBitsToSet: EventBits_t) EventBits_t;
pub extern fn xEventGroupSync(xEventGroup: EventGroupHandle_t, uxBitsToSet: EventBits_t, uxBitsToWaitFor: EventBits_t, xTicksToWait: TickType_t) EventBits_t;
pub extern fn xEventGroupGetBitsFromISR(xEventGroup: EventGroupHandle_t) EventBits_t;
pub extern fn vEventGroupDelete(xEventGroup: EventGroupHandle_t) void;
pub extern fn xEventGroupGetStaticBuffer(xEventGroup: EventGroupHandle_t, ppxEventGroupBuffer: [*c][*c]StaticEventGroup_t) BaseType_t;
pub extern fn vEventGroupSetBitsCallback(pvEventGroup: ?*anyopaque, ulBitsToSet: u32) void;
pub extern fn vEventGroupClearBitsCallback(pvEventGroup: ?*anyopaque, ulBitsToClear: u32) void;
pub const StreamBufferDef_t = opaque {};
pub const StreamBufferHandle_t = ?*StreamBufferDef_t;
pub extern fn xStreamBufferGetStaticBuffers(xStreamBuffer: StreamBufferHandle_t, ppucStreamBufferStorageArea: [*c][*c]u8, ppxStaticStreamBuffer: [*c][*c]StaticStreamBuffer_t) BaseType_t;
pub extern fn xStreamBufferSend(xStreamBuffer: StreamBufferHandle_t, pvTxData: ?*const anyopaque, xDataLengthBytes: usize, xTicksToWait: TickType_t) usize;
pub extern fn xStreamBufferSendFromISR(xStreamBuffer: StreamBufferHandle_t, pvTxData: ?*const anyopaque, xDataLengthBytes: usize, pxHigherPriorityTaskWoken: [*c]BaseType_t) usize;
pub extern fn xStreamBufferReceive(xStreamBuffer: StreamBufferHandle_t, pvRxData: ?*anyopaque, xBufferLengthBytes: usize, xTicksToWait: TickType_t) usize;
pub extern fn xStreamBufferReceiveFromISR(xStreamBuffer: StreamBufferHandle_t, pvRxData: ?*anyopaque, xBufferLengthBytes: usize, pxHigherPriorityTaskWoken: [*c]BaseType_t) usize;
pub extern fn vStreamBufferDelete(xStreamBuffer: StreamBufferHandle_t) void;
pub extern fn xStreamBufferIsFull(xStreamBuffer: StreamBufferHandle_t) BaseType_t;
pub extern fn xStreamBufferIsEmpty(xStreamBuffer: StreamBufferHandle_t) BaseType_t;
pub extern fn xStreamBufferReset(xStreamBuffer: StreamBufferHandle_t) BaseType_t;
pub extern fn xStreamBufferSpacesAvailable(xStreamBuffer: StreamBufferHandle_t) usize;
pub extern fn xStreamBufferBytesAvailable(xStreamBuffer: StreamBufferHandle_t) usize;
pub extern fn xStreamBufferSetTriggerLevel(xStreamBuffer: StreamBufferHandle_t, xTriggerLevel: usize) BaseType_t;
pub extern fn xStreamBufferSendCompletedFromISR(xStreamBuffer: StreamBufferHandle_t, pxHigherPriorityTaskWoken: [*c]BaseType_t) BaseType_t;
pub extern fn xStreamBufferReceiveCompletedFromISR(xStreamBuffer: StreamBufferHandle_t, pxHigherPriorityTaskWoken: [*c]BaseType_t) BaseType_t;
pub extern fn xStreamBufferGenericCreate(xBufferSizeBytes: usize, xTriggerLevelBytes: usize, xIsMessageBuffer: BaseType_t) StreamBufferHandle_t;
pub extern fn xStreamBufferGenericCreateStatic(xBufferSizeBytes: usize, xTriggerLevelBytes: usize, xIsMessageBuffer: BaseType_t, pucStreamBufferStorageArea: [*:0]u8, pxStaticStreamBuffer: [*c]StaticStreamBuffer_t) StreamBufferHandle_t;
pub extern fn xStreamBufferNextMessageLengthBytes(xStreamBuffer: StreamBufferHandle_t) usize;
pub const MessageBufferHandle_t = ?*anyopaque;
pub const QueueDefinition = opaque {};
pub const QueueHandle_t = ?*QueueDefinition;
pub const QueueSetHandle_t = ?*QueueDefinition;
pub const QueueSetMemberHandle_t = ?*QueueDefinition;
pub extern fn xQueueGenericSend(xQueue: QueueHandle_t, pvItemToQueue: ?*const anyopaque, xTicksToWait: TickType_t, xCopyPosition: BaseType_t) BaseType_t;
pub extern fn xQueuePeek(xQueue: QueueHandle_t, pvBuffer: ?*anyopaque, xTicksToWait: TickType_t) BaseType_t;
pub extern fn xQueuePeekFromISR(xQueue: QueueHandle_t, pvBuffer: ?*anyopaque) BaseType_t;
pub extern fn xQueueReceive(xQueue: QueueHandle_t, pvBuffer: ?*anyopaque, xTicksToWait: TickType_t) BaseType_t;
pub extern fn uxQueueMessagesWaiting(xQueue: QueueHandle_t) UBaseType_t;
pub extern fn uxQueueSpacesAvailable(xQueue: QueueHandle_t) UBaseType_t;
pub extern fn vQueueDelete(xQueue: QueueHandle_t) void;
pub extern fn xQueueGenericSendFromISR(xQueue: QueueHandle_t, pvItemToQueue: ?*const anyopaque, pxHigherPriorityTaskWoken: [*c]BaseType_t, xCopyPosition: BaseType_t) BaseType_t;
pub extern fn xQueueGiveFromISR(xQueue: QueueHandle_t, pxHigherPriorityTaskWoken: [*c]BaseType_t) BaseType_t;
pub extern fn xQueueReceiveFromISR(xQueue: QueueHandle_t, pvBuffer: ?*anyopaque, pxHigherPriorityTaskWoken: [*c]BaseType_t) BaseType_t;
pub extern fn xQueueIsQueueEmptyFromISR(xQueue: QueueHandle_t) BaseType_t;
pub extern fn xQueueIsQueueFullFromISR(xQueue: QueueHandle_t) BaseType_t;
pub extern fn uxQueueMessagesWaitingFromISR(xQueue: QueueHandle_t) UBaseType_t;
pub extern fn xQueueCRSendFromISR(xQueue: QueueHandle_t, pvItemToQueue: ?*const anyopaque, xCoRoutinePreviouslyWoken: BaseType_t) BaseType_t;
pub extern fn xQueueCRReceiveFromISR(xQueue: QueueHandle_t, pvBuffer: ?*anyopaque, pxTaskWoken: [*c]BaseType_t) BaseType_t;
pub extern fn xQueueCRSend(xQueue: QueueHandle_t, pvItemToQueue: ?*const anyopaque, xTicksToWait: TickType_t) BaseType_t;
pub extern fn xQueueCRReceive(xQueue: QueueHandle_t, pvBuffer: ?*anyopaque, xTicksToWait: TickType_t) BaseType_t;
pub extern fn xQueueCreateMutex(ucQueueType: u8) QueueHandle_t;
pub extern fn xQueueCreateMutexStatic(ucQueueType: u8, pxStaticQueue: [*c]StaticQueue_t) QueueHandle_t;
pub extern fn xQueueCreateCountingSemaphore(uxMaxCount: UBaseType_t, uxInitialCount: UBaseType_t) QueueHandle_t;
pub extern fn xQueueCreateCountingSemaphoreStatic(uxMaxCount: UBaseType_t, uxInitialCount: UBaseType_t, pxStaticQueue: [*c]StaticQueue_t) QueueHandle_t;
pub extern fn xQueueSemaphoreTake(xQueue: QueueHandle_t, xTicksToWait: TickType_t) BaseType_t;
pub extern fn xQueueGetMutexHolder(xSemaphore: QueueHandle_t) TaskHandle_t;
pub extern fn xQueueGetMutexHolderFromISR(xSemaphore: QueueHandle_t) TaskHandle_t;
pub extern fn xQueueTakeMutexRecursive(xMutex: QueueHandle_t, xTicksToWait: TickType_t) BaseType_t;
pub extern fn xQueueGiveMutexRecursive(xMutex: QueueHandle_t) BaseType_t;
pub extern fn xQueueGenericCreate(uxQueueLength: UBaseType_t, uxItemSize: UBaseType_t, ucQueueType: u8) QueueHandle_t;
pub extern fn xQueueGenericCreateStatic(uxQueueLength: UBaseType_t, uxItemSize: UBaseType_t, pucQueueStorage: [*:0]u8, pxStaticQueue: [*c]StaticQueue_t, ucQueueType: u8) QueueHandle_t;
pub extern fn xQueueGenericGetStaticBuffers(xQueue: QueueHandle_t, ppucQueueStorage: [*c][*c]u8, ppxStaticQueue: [*c][*c]StaticQueue_t) BaseType_t;
pub extern fn xQueueCreateSet(uxEventQueueLength: UBaseType_t) QueueSetHandle_t;
pub extern fn xQueueAddToSet(xQueueOrSemaphore: QueueSetMemberHandle_t, xQueueSet: QueueSetHandle_t) BaseType_t;
pub extern fn xQueueRemoveFromSet(xQueueOrSemaphore: QueueSetMemberHandle_t, xQueueSet: QueueSetHandle_t) BaseType_t;
pub extern fn xQueueSelectFromSet(xQueueSet: QueueSetHandle_t, xTicksToWait: TickType_t) QueueSetMemberHandle_t;
pub extern fn xQueueSelectFromSetFromISR(xQueueSet: QueueSetHandle_t) QueueSetMemberHandle_t;
pub extern fn vQueueWaitForMessageRestricted(xQueue: QueueHandle_t, xTicksToWait: TickType_t, xWaitIndefinitely: BaseType_t) void;
pub extern fn xQueueGenericReset(xQueue: QueueHandle_t, xNewQueue: BaseType_t) BaseType_t;
pub extern fn vQueueSetQueueNumber(xQueue: QueueHandle_t, uxQueueNumber: UBaseType_t) void;
pub extern fn uxQueueGetQueueNumber(xQueue: QueueHandle_t) UBaseType_t;
pub extern fn ucQueueGetQueueType(xQueue: QueueHandle_t) u8;
pub const SemaphoreHandle_t = QueueHandle_t;
pub const xTASK_SNAPSHOT = extern struct {
    pxTCB: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    pxTopOfStack: [*c]StackType_t = std.mem.zeroes([*c]StackType_t),
    pxEndOfStack: [*c]StackType_t = std.mem.zeroes([*c]StackType_t),
};
pub const TaskSnapshot_t = xTASK_SNAPSHOT;
pub const TaskIterator = extern struct {
    uxCurrentListIndex: UBaseType_t = std.mem.zeroes(UBaseType_t),
    pxNextListItem: [*c]ListItem_t = std.mem.zeroes([*c]ListItem_t),
    pxTaskHandle: TaskHandle_t = std.mem.zeroes(TaskHandle_t),
};
pub const TaskIterator_t = TaskIterator;
pub extern fn xTaskGetNext(xIterator: [*c]TaskIterator_t) c_int;
pub extern fn vTaskGetSnapshot(pxTask: TaskHandle_t, pxTaskSnapshot: [*c]TaskSnapshot_t) BaseType_t;
pub extern fn uxTaskGetSnapshotAll(pxTaskSnapshotArray: [*c]TaskSnapshot_t, uxArrayLength: UBaseType_t, pxTCBSize: [*c]UBaseType_t) UBaseType_t;
pub extern fn pvTaskGetCurrentTCBForCore(xCoreID: BaseType_t) ?*anyopaque;
pub extern fn esp_int_wdt_init() void;
pub extern fn esp_int_wdt_cpu_init() void;
pub const portTICK_PERIOD_MS: TickType_t = @as(TickType_t, @divExact(@as(c_int, 1000), configTICK_RATE_HZ));
pub const configTICK_RATE_HZ: c_int = 100;

pub const esp_event_base_t = [*c]const u8;
pub const esp_event_loop_handle_t = ?*anyopaque;
pub const esp_event_handler_t = ?*const fn (?*anyopaque, esp_event_base_t, i32, ?*anyopaque) callconv(.C) void;
pub const esp_event_handler_instance_t = ?*anyopaque;
pub const esp_event_loop_args_t = extern struct {
    queue_size: i32 = std.mem.zeroes(i32),
    task_name: [*c]const u8 = std.mem.zeroes([*c]const u8),
    task_priority: UBaseType_t = std.mem.zeroes(UBaseType_t),
    task_stack_size: u32 = std.mem.zeroes(u32),
    task_core_id: BaseType_t = std.mem.zeroes(BaseType_t),
};
pub extern fn esp_event_loop_create(event_loop_args: [*c]const esp_event_loop_args_t, event_loop: [*c]esp_event_loop_handle_t) esp_err_t;
pub extern fn esp_event_loop_delete(event_loop: esp_event_loop_handle_t) esp_err_t;
pub extern fn esp_event_loop_create_default() esp_err_t;
pub extern fn esp_event_loop_delete_default() esp_err_t;
pub extern fn esp_event_loop_run(event_loop: esp_event_loop_handle_t, ticks_to_run: TickType_t) esp_err_t;
pub extern fn esp_event_handler_register(event_base: esp_event_base_t, event_id: i32, event_handler: esp_event_handler_t, event_handler_arg: ?*anyopaque) esp_err_t;
pub extern fn esp_event_handler_register_with(event_loop: esp_event_loop_handle_t, event_base: esp_event_base_t, event_id: i32, event_handler: esp_event_handler_t, event_handler_arg: ?*anyopaque) esp_err_t;
pub extern fn esp_event_handler_instance_register_with(event_loop: esp_event_loop_handle_t, event_base: esp_event_base_t, event_id: i32, event_handler: esp_event_handler_t, event_handler_arg: ?*anyopaque, instance: [*c]esp_event_handler_instance_t) esp_err_t;
pub extern fn esp_event_handler_instance_register(event_base: esp_event_base_t, event_id: i32, event_handler: esp_event_handler_t, event_handler_arg: ?*anyopaque, instance: [*c]esp_event_handler_instance_t) esp_err_t;
pub extern fn esp_event_handler_unregister(event_base: esp_event_base_t, event_id: i32, event_handler: esp_event_handler_t) esp_err_t;
pub extern fn esp_event_handler_unregister_with(event_loop: esp_event_loop_handle_t, event_base: esp_event_base_t, event_id: i32, event_handler: esp_event_handler_t) esp_err_t;
pub extern fn esp_event_handler_instance_unregister_with(event_loop: esp_event_loop_handle_t, event_base: esp_event_base_t, event_id: i32, instance: esp_event_handler_instance_t) esp_err_t;
pub extern fn esp_event_handler_instance_unregister(event_base: esp_event_base_t, event_id: i32, instance: esp_event_handler_instance_t) esp_err_t;
pub extern fn esp_event_post(event_base: esp_event_base_t, event_id: i32, event_data: ?*const anyopaque, event_data_size: usize, ticks_to_wait: TickType_t) esp_err_t;
pub extern fn esp_event_post_to(event_loop: esp_event_loop_handle_t, event_base: esp_event_base_t, event_id: i32, event_data: ?*const anyopaque, event_data_size: usize, ticks_to_wait: TickType_t) esp_err_t;
pub extern fn esp_event_isr_post(event_base: esp_event_base_t, event_id: i32, event_data: ?*const anyopaque, event_data_size: usize, task_unblocked: [*c]BaseType_t) esp_err_t;
pub extern fn esp_event_isr_post_to(event_loop: esp_event_loop_handle_t, event_base: esp_event_base_t, event_id: i32, event_data: ?*const anyopaque, event_data_size: usize, task_unblocked: [*c]BaseType_t) esp_err_t;
pub extern fn esp_event_dump(file: std.c.FILE) esp_err_t;
pub const nvs_handle_t = u32;
pub const nvs_handle = nvs_handle_t;
pub const NVS_READONLY: c_int = 0;
pub const NVS_READWRITE: c_int = 1;
pub const nvs_open_mode_t = c_uint;
pub const nvs_open_mode = nvs_open_mode_t;
pub const NVS_TYPE_U8: c_int = 1;
pub const NVS_TYPE_I8: c_int = 17;
pub const NVS_TYPE_U16: c_int = 2;
pub const NVS_TYPE_I16: c_int = 18;
pub const NVS_TYPE_U32: c_int = 4;
pub const NVS_TYPE_I32: c_int = 20;
pub const NVS_TYPE_U64: c_int = 8;
pub const NVS_TYPE_I64: c_int = 24;
pub const NVS_TYPE_STR: c_int = 33;
pub const NVS_TYPE_BLOB: c_int = 66;
pub const NVS_TYPE_ANY: c_int = 255;
pub const nvs_type_t = c_uint;
pub const nvs_entry_info_t = extern struct {
    namespace_name: [16]u8 = std.mem.zeroes([16]u8),
    key: [16]u8 = std.mem.zeroes([16]u8),
    type: nvs_type_t = std.mem.zeroes(nvs_type_t),
};
pub const nvs_opaque_iterator_t = opaque {};
pub const nvs_iterator_t = ?*nvs_opaque_iterator_t;
pub extern fn nvs_open(namespace_name: [*c]const u8, open_mode: nvs_open_mode_t, out_handle: [*c]nvs_handle_t) esp_err_t;
pub extern fn nvs_open_from_partition(part_name: [*c]const u8, namespace_name: [*c]const u8, open_mode: nvs_open_mode_t, out_handle: [*c]nvs_handle_t) esp_err_t;
pub extern fn nvs_set_i8(handle: nvs_handle_t, key: [*c]const u8, value: i8) esp_err_t;
pub extern fn nvs_set_u8(handle: nvs_handle_t, key: [*c]const u8, value: u8) esp_err_t;
pub extern fn nvs_set_i16(handle: nvs_handle_t, key: [*c]const u8, value: i16) esp_err_t;
pub extern fn nvs_set_u16(handle: nvs_handle_t, key: [*c]const u8, value: u16) esp_err_t;
pub extern fn nvs_set_i32(handle: nvs_handle_t, key: [*c]const u8, value: i32) esp_err_t;
pub extern fn nvs_set_u32(handle: nvs_handle_t, key: [*c]const u8, value: u32) esp_err_t;
pub extern fn nvs_set_i64(handle: nvs_handle_t, key: [*c]const u8, value: i64) esp_err_t;
pub extern fn nvs_set_u64(handle: nvs_handle_t, key: [*c]const u8, value: u64) esp_err_t;
pub extern fn nvs_set_str(handle: nvs_handle_t, key: [*c]const u8, value: [*c]const u8) esp_err_t;
pub extern fn nvs_set_blob(handle: nvs_handle_t, key: [*c]const u8, value: ?*const anyopaque, length: usize) esp_err_t;
pub extern fn nvs_get_i8(handle: nvs_handle_t, key: [*c]const u8, out_value: [*c]i8) esp_err_t;
pub extern fn nvs_get_u8(handle: nvs_handle_t, key: [*c]const u8, out_value: [*c]u8) esp_err_t;
pub extern fn nvs_get_i16(handle: nvs_handle_t, key: [*c]const u8, out_value: [*c]i16) esp_err_t;
pub extern fn nvs_get_u16(handle: nvs_handle_t, key: [*c]const u8, out_value: [*c]u16) esp_err_t;
pub extern fn nvs_get_i32(handle: nvs_handle_t, key: [*c]const u8, out_value: [*c]i32) esp_err_t;
pub extern fn nvs_get_u32(handle: nvs_handle_t, key: [*c]const u8, out_value: [*c]u32) esp_err_t;
pub extern fn nvs_get_i64(handle: nvs_handle_t, key: [*c]const u8, out_value: [*c]i64) esp_err_t;
pub extern fn nvs_get_u64(handle: nvs_handle_t, key: [*c]const u8, out_value: [*c]u64) esp_err_t;
pub extern fn nvs_get_str(handle: nvs_handle_t, key: [*c]const u8, out_value: [*c]u8, length: [*c]usize) esp_err_t;
pub extern fn nvs_get_blob(handle: nvs_handle_t, key: [*c]const u8, out_value: ?*anyopaque, length: [*c]usize) esp_err_t;
pub extern fn nvs_find_key(handle: nvs_handle_t, key: [*c]const u8, out_type: [*c]nvs_type_t) esp_err_t;
pub extern fn nvs_erase_key(handle: nvs_handle_t, key: [*c]const u8) esp_err_t;
pub extern fn nvs_erase_all(handle: nvs_handle_t) esp_err_t;
pub extern fn nvs_commit(handle: nvs_handle_t) esp_err_t;
pub extern fn nvs_close(handle: nvs_handle_t) void;
pub const nvs_stats_t = extern struct {
    used_entries: usize = std.mem.zeroes(usize),
    free_entries: usize = std.mem.zeroes(usize),
    available_entries: usize = std.mem.zeroes(usize),
    total_entries: usize = std.mem.zeroes(usize),
    namespace_count: usize = std.mem.zeroes(usize),
};
pub extern fn nvs_get_stats(part_name: [*c]const u8, nvs_stats: [*c]nvs_stats_t) esp_err_t;
pub extern fn nvs_get_used_entry_count(handle: nvs_handle_t, used_entries: [*c]usize) esp_err_t;
pub extern fn nvs_entry_find(part_name: [*c]const u8, namespace_name: [*c]const u8, @"type": nvs_type_t, output_iterator: [*c]nvs_iterator_t) esp_err_t;
pub extern fn nvs_entry_find_in_handle(handle: nvs_handle_t, @"type": nvs_type_t, output_iterator: [*c]nvs_iterator_t) esp_err_t;
pub extern fn nvs_entry_next(iterator: [*c]nvs_iterator_t) esp_err_t;
pub extern fn nvs_entry_info(iterator: nvs_iterator_t, out_info: [*c]nvs_entry_info_t) esp_err_t;
pub extern fn nvs_release_iterator(iterator: nvs_iterator_t) void;
pub const esp_flash_t = opaque {};
pub const ESP_PARTITION_MMAP_DATA: c_int = 0;
pub const ESP_PARTITION_MMAP_INST: c_int = 1;
pub const esp_partition_mmap_memory_t = c_uint;
pub const esp_partition_mmap_handle_t = u32;
pub const ESP_PARTITION_TYPE_APP: c_int = 0;
pub const ESP_PARTITION_TYPE_DATA: c_int = 1;
pub const ESP_PARTITION_TYPE_ANY: c_int = 255;
pub const esp_partition_type_t = c_uint;
pub const ESP_PARTITION_SUBTYPE_APP_FACTORY: c_int = 0;
pub const ESP_PARTITION_SUBTYPE_APP_OTA_MIN: c_int = 16;
pub const ESP_PARTITION_SUBTYPE_APP_OTA_0: c_int = 16;
pub const ESP_PARTITION_SUBTYPE_APP_OTA_1: c_int = 17;
pub const ESP_PARTITION_SUBTYPE_APP_OTA_2: c_int = 18;
pub const ESP_PARTITION_SUBTYPE_APP_OTA_3: c_int = 19;
pub const ESP_PARTITION_SUBTYPE_APP_OTA_4: c_int = 20;
pub const ESP_PARTITION_SUBTYPE_APP_OTA_5: c_int = 21;
pub const ESP_PARTITION_SUBTYPE_APP_OTA_6: c_int = 22;
pub const ESP_PARTITION_SUBTYPE_APP_OTA_7: c_int = 23;
pub const ESP_PARTITION_SUBTYPE_APP_OTA_8: c_int = 24;
pub const ESP_PARTITION_SUBTYPE_APP_OTA_9: c_int = 25;
pub const ESP_PARTITION_SUBTYPE_APP_OTA_10: c_int = 26;
pub const ESP_PARTITION_SUBTYPE_APP_OTA_11: c_int = 27;
pub const ESP_PARTITION_SUBTYPE_APP_OTA_12: c_int = 28;
pub const ESP_PARTITION_SUBTYPE_APP_OTA_13: c_int = 29;
pub const ESP_PARTITION_SUBTYPE_APP_OTA_14: c_int = 30;
pub const ESP_PARTITION_SUBTYPE_APP_OTA_15: c_int = 31;
pub const ESP_PARTITION_SUBTYPE_APP_OTA_MAX: c_int = 32;
pub const ESP_PARTITION_SUBTYPE_APP_TEST: c_int = 32;
pub const ESP_PARTITION_SUBTYPE_DATA_OTA: c_int = 0;
pub const ESP_PARTITION_SUBTYPE_DATA_PHY: c_int = 1;
pub const ESP_PARTITION_SUBTYPE_DATA_NVS: c_int = 2;
pub const ESP_PARTITION_SUBTYPE_DATA_COREDUMP: c_int = 3;
pub const ESP_PARTITION_SUBTYPE_DATA_NVS_KEYS: c_int = 4;
pub const ESP_PARTITION_SUBTYPE_DATA_EFUSE_EM: c_int = 5;
pub const ESP_PARTITION_SUBTYPE_DATA_UNDEFINED: c_int = 6;
pub const ESP_PARTITION_SUBTYPE_DATA_ESPHTTPD: c_int = 128;
pub const ESP_PARTITION_SUBTYPE_DATA_FAT: c_int = 129;
pub const ESP_PARTITION_SUBTYPE_DATA_SPIFFS: c_int = 130;
pub const ESP_PARTITION_SUBTYPE_DATA_LITTLEFS: c_int = 131;
pub const ESP_PARTITION_SUBTYPE_ANY: c_int = 255;
pub const esp_partition_subtype_t = c_uint;
pub const esp_partition_iterator_opaque_ = opaque {};
pub const esp_partition_iterator_t = ?*esp_partition_iterator_opaque_;
pub const esp_partition_t = extern struct {
    flash_chip: ?*esp_flash_t = std.mem.zeroes(?*esp_flash_t),
    type: esp_partition_type_t = std.mem.zeroes(esp_partition_type_t),
    subtype: esp_partition_subtype_t = std.mem.zeroes(esp_partition_subtype_t),
    address: u32 = std.mem.zeroes(u32),
    size: u32 = std.mem.zeroes(u32),
    erase_size: u32 = std.mem.zeroes(u32),
    label: [17]u8 = std.mem.zeroes([17]u8),
    encrypted: bool = std.mem.zeroes(bool),
    readonly: bool = std.mem.zeroes(bool),
};
pub extern fn esp_partition_find(@"type": esp_partition_type_t, subtype: esp_partition_subtype_t, label: [*c]const u8) esp_partition_iterator_t;
pub extern fn esp_partition_find_first(@"type": esp_partition_type_t, subtype: esp_partition_subtype_t, label: [*c]const u8) [*c]const esp_partition_t;
pub extern fn esp_partition_get(iterator: esp_partition_iterator_t) [*c]const esp_partition_t;
pub extern fn esp_partition_next(iterator: esp_partition_iterator_t) esp_partition_iterator_t;
pub extern fn esp_partition_iterator_release(iterator: esp_partition_iterator_t) void;
pub extern fn esp_partition_verify(partition: [*c]const esp_partition_t) [*c]const esp_partition_t;
pub extern fn esp_partition_read(partition: [*c]const esp_partition_t, src_offset: usize, dst: ?*anyopaque, size: usize) esp_err_t;
pub extern fn esp_partition_write(partition: [*c]const esp_partition_t, dst_offset: usize, src: ?*const anyopaque, size: usize) esp_err_t;
pub extern fn esp_partition_read_raw(partition: [*c]const esp_partition_t, src_offset: usize, dst: ?*anyopaque, size: usize) esp_err_t;
pub extern fn esp_partition_write_raw(partition: [*c]const esp_partition_t, dst_offset: usize, src: ?*const anyopaque, size: usize) esp_err_t;
pub extern fn esp_partition_erase_range(partition: [*c]const esp_partition_t, offset: usize, size: usize) esp_err_t;
pub extern fn esp_partition_mmap(partition: [*c]const esp_partition_t, offset: usize, size: usize, memory: esp_partition_mmap_memory_t, out_ptr: [*c]?*const anyopaque, out_handle: [*c]esp_partition_mmap_handle_t) esp_err_t;
pub extern fn esp_partition_munmap(handle: esp_partition_mmap_handle_t) void;
pub extern fn esp_partition_get_sha256(partition: [*c]const esp_partition_t, sha_256: [*c]u8) esp_err_t;
pub extern fn esp_partition_check_identity(partition_1: [*c]const esp_partition_t, partition_2: [*c]const esp_partition_t) bool;
pub extern fn esp_partition_register_external(flash_chip: ?*esp_flash_t, offset: usize, size: usize, label: [*c]const u8, @"type": esp_partition_type_t, subtype: esp_partition_subtype_t, out_partition: [*c][*c]const esp_partition_t) esp_err_t;
pub extern fn esp_partition_deregister_external(partition: [*c]const esp_partition_t) esp_err_t;
pub extern fn esp_partition_unload_all() void;
pub const nvs_sec_cfg_t = extern struct {
    eky: [32]u8 = std.mem.zeroes([32]u8),
    tky: [32]u8 = std.mem.zeroes([32]u8),
};
pub const nvs_flash_generate_keys_t = ?*const fn (?*const anyopaque, [*c]nvs_sec_cfg_t) callconv(.C) esp_err_t;
pub const nvs_flash_read_cfg_t = ?*const fn (?*const anyopaque, [*c]nvs_sec_cfg_t) callconv(.C) esp_err_t;
pub const nvs_sec_scheme_t = extern struct {
    scheme_id: c_int = std.mem.zeroes(c_int),
    scheme_data: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    nvs_flash_key_gen: nvs_flash_generate_keys_t = std.mem.zeroes(nvs_flash_generate_keys_t),
    nvs_flash_read_cfg: nvs_flash_read_cfg_t = std.mem.zeroes(nvs_flash_read_cfg_t),
};
pub extern fn nvs_flash_init() esp_err_t;
pub extern fn nvs_flash_init_partition(partition_label: [*c]const u8) esp_err_t;
pub extern fn nvs_flash_init_partition_ptr(partition: [*c]const esp_partition_t) esp_err_t;
pub extern fn nvs_flash_deinit() esp_err_t;
pub extern fn nvs_flash_deinit_partition(partition_label: [*c]const u8) esp_err_t;
pub extern fn nvs_flash_erase() esp_err_t;
pub extern fn nvs_flash_erase_partition(part_name: [*c]const u8) esp_err_t;
pub extern fn nvs_flash_erase_partition_ptr(partition: [*c]const esp_partition_t) esp_err_t;
pub extern fn nvs_flash_secure_init(cfg: [*c]nvs_sec_cfg_t) esp_err_t;
pub extern fn nvs_flash_secure_init_partition(partition_label: [*c]const u8, cfg: [*c]nvs_sec_cfg_t) esp_err_t;
pub extern fn nvs_flash_generate_keys(partition: [*c]const esp_partition_t, cfg: [*c]nvs_sec_cfg_t) esp_err_t;
pub extern fn nvs_flash_read_security_cfg(partition: [*c]const esp_partition_t, cfg: [*c]nvs_sec_cfg_t) esp_err_t;
pub extern fn nvs_flash_register_security_scheme(scheme_cfg: [*c]nvs_sec_scheme_t) esp_err_t;
pub extern fn nvs_flash_get_default_security_scheme() [*c]nvs_sec_scheme_t;
pub extern fn nvs_flash_generate_keys_v2(scheme_cfg: [*c]nvs_sec_scheme_t, cfg: [*c]nvs_sec_cfg_t) esp_err_t;
pub extern fn nvs_flash_read_security_cfg_v2(scheme_cfg: [*c]nvs_sec_scheme_t, cfg: [*c]nvs_sec_cfg_t) esp_err_t;

pub const ESP_BT_MODE_IDLE: c_int = 0;
pub const ESP_BT_MODE_BLE: c_int = 1;
pub const ESP_BT_MODE_CLASSIC_BT: c_int = 2;
pub const ESP_BT_MODE_BTDM: c_int = 3;
pub const esp_bt_mode_t = c_uint;
pub const ESP_BT_CTRL_HCI_TL_UART: c_int = 0;
pub const ESP_BT_CTRL_HCI_TL_VHCI: c_int = 1;
pub const esp_bt_ctrl_hci_tl_t = c_uint;
pub const ESP_BLE_CE_LEN_TYPE_ORIG: c_int = 0;
pub const ESP_BLE_CE_LEN_TYPE_CE: c_int = 1;
pub const ESP_BLE_CE_LEN_TYPE_SD: c_int = 1;
pub const esp_ble_ce_len_t = c_uint;
pub const ESP_BT_SLEEP_MODE_NONE: c_int = 0;
pub const ESP_BT_SLEEP_MODE_1: c_int = 1;
pub const esp_bt_sleep_mode_t = c_uint;
pub const ESP_BT_SLEEP_CLOCK_NONE: c_int = 0;
pub const ESP_BT_SLEEP_CLOCK_MAIN_XTAL: c_int = 1;
pub const ESP_BT_SLEEP_CLOCK_EXT_32K_XTAL: c_int = 2;
pub const ESP_BT_SLEEP_CLOCK_RTC_SLOW: c_int = 3;
pub const ESP_BT_SLEEP_CLOCK_FPGA_32K: c_int = 4;
pub const esp_bt_sleep_clock_t = c_uint;
pub const ESP_BT_ANT_IDX_0: c_int = 0;
pub const ESP_BT_ANT_IDX_1: c_int = 1;
const enum_unnamed_15 = c_uint;
pub const ESP_BT_COEX_PHY_CODED_TX_RX_TIME_LIMIT_FORCE_DISABLE: c_int = 0;
pub const ESP_BT_COEX_PHY_CODED_TX_RX_TIME_LIMIT_FORCE_ENABLE: c_int = 1;
const enum_unnamed_16 = c_uint;
pub const esp_bt_hci_tl_callback_t = ?*const fn (?*anyopaque, u8) callconv(.C) void;
pub const esp_bt_hci_tl_t = extern struct {
    _magic: u32 = std.mem.zeroes(u32),
    _version: u32 = std.mem.zeroes(u32),
    _reserved: u32 = std.mem.zeroes(u32),
    _open: ?*const fn () callconv(.C) c_int = std.mem.zeroes(?*const fn () callconv(.C) c_int),
    _close: ?*const fn () callconv(.C) void = std.mem.zeroes(?*const fn () callconv(.C) void),
    _finish_transfers: ?*const fn () callconv(.C) void = std.mem.zeroes(?*const fn () callconv(.C) void),
    _recv: ?*const fn ([*c]u8, u32, esp_bt_hci_tl_callback_t, ?*anyopaque) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]u8, u32, esp_bt_hci_tl_callback_t, ?*anyopaque) callconv(.C) void),
    _send: ?*const fn ([*c]u8, u32, esp_bt_hci_tl_callback_t, ?*anyopaque) callconv(.C) void = std.mem.zeroes(?*const fn ([*c]u8, u32, esp_bt_hci_tl_callback_t, ?*anyopaque) callconv(.C) void),
    _flow_off: ?*const fn () callconv(.C) bool = std.mem.zeroes(?*const fn () callconv(.C) bool),
    _flow_on: ?*const fn () callconv(.C) void = std.mem.zeroes(?*const fn () callconv(.C) void),
};
pub const esp_bt_controller_config_t = extern struct {
    magic: u32 = std.mem.zeroes(u32),
    version: u32 = std.mem.zeroes(u32),
    controller_task_stack_size: u16 = std.mem.zeroes(u16),
    controller_task_prio: u8 = std.mem.zeroes(u8),
    controller_task_run_cpu: u8 = std.mem.zeroes(u8),
    bluetooth_mode: u8 = std.mem.zeroes(u8),
    ble_max_act: u8 = std.mem.zeroes(u8),
    sleep_mode: u8 = std.mem.zeroes(u8),
    sleep_clock: u8 = std.mem.zeroes(u8),
    ble_st_acl_tx_buf_nb: u8 = std.mem.zeroes(u8),
    ble_hw_cca_check: u8 = std.mem.zeroes(u8),
    ble_adv_dup_filt_max: u16 = std.mem.zeroes(u16),
    coex_param_en: bool = std.mem.zeroes(bool),
    ce_len_type: u8 = std.mem.zeroes(u8),
    coex_use_hooks: bool = std.mem.zeroes(bool),
    hci_tl_type: u8 = std.mem.zeroes(u8),
    hci_tl_funcs: [*c]esp_bt_hci_tl_t = std.mem.zeroes([*c]esp_bt_hci_tl_t),
    txant_dft: u8 = std.mem.zeroes(u8),
    rxant_dft: u8 = std.mem.zeroes(u8),
    txpwr_dft: u8 = std.mem.zeroes(u8),
    cfg_mask: u32 = std.mem.zeroes(u32),
    scan_duplicate_mode: u8 = std.mem.zeroes(u8),
    scan_duplicate_type: u8 = std.mem.zeroes(u8),
    normal_adv_size: u16 = std.mem.zeroes(u16),
    mesh_adv_size: u16 = std.mem.zeroes(u16),
    coex_phy_coded_tx_rx_time_limit: u8 = std.mem.zeroes(u8),
    hw_target_code: u32 = std.mem.zeroes(u32),
    slave_ce_len_min: u8 = std.mem.zeroes(u8),
    hw_recorrect_en: u8 = std.mem.zeroes(u8),
    cca_thresh: u8 = std.mem.zeroes(u8),
    scan_backoff_upperlimitmax: u16 = std.mem.zeroes(u16),
    dup_list_refresh_period: u16 = std.mem.zeroes(u16),
    ble_50_feat_supp: bool = std.mem.zeroes(bool),
    ble_cca_mode: u8 = std.mem.zeroes(u8),
    ble_data_lenth_zero_aux: u8 = std.mem.zeroes(u8),
};
pub const ESP_BT_CONTROLLER_STATUS_IDLE: c_int = 0;
pub const ESP_BT_CONTROLLER_STATUS_INITED: c_int = 1;
pub const ESP_BT_CONTROLLER_STATUS_ENABLED: c_int = 2;
pub const ESP_BT_CONTROLLER_STATUS_NUM: c_int = 3;
pub const esp_bt_controller_status_t = c_uint;
pub const ESP_BLE_PWR_TYPE_CONN_HDL0: c_int = 0;
pub const ESP_BLE_PWR_TYPE_CONN_HDL1: c_int = 1;
pub const ESP_BLE_PWR_TYPE_CONN_HDL2: c_int = 2;
pub const ESP_BLE_PWR_TYPE_CONN_HDL3: c_int = 3;
pub const ESP_BLE_PWR_TYPE_CONN_HDL4: c_int = 4;
pub const ESP_BLE_PWR_TYPE_CONN_HDL5: c_int = 5;
pub const ESP_BLE_PWR_TYPE_CONN_HDL6: c_int = 6;
pub const ESP_BLE_PWR_TYPE_CONN_HDL7: c_int = 7;
pub const ESP_BLE_PWR_TYPE_CONN_HDL8: c_int = 8;
pub const ESP_BLE_PWR_TYPE_ADV: c_int = 9;
pub const ESP_BLE_PWR_TYPE_SCAN: c_int = 10;
pub const ESP_BLE_PWR_TYPE_DEFAULT: c_int = 11;
pub const ESP_BLE_PWR_TYPE_NUM: c_int = 12;
pub const esp_ble_power_type_t = c_uint;
pub const ESP_PWR_LVL_N24: c_int = 0;
pub const ESP_PWR_LVL_N21: c_int = 1;
pub const ESP_PWR_LVL_N18: c_int = 2;
pub const ESP_PWR_LVL_N15: c_int = 3;
pub const ESP_PWR_LVL_N12: c_int = 4;
pub const ESP_PWR_LVL_N9: c_int = 5;
pub const ESP_PWR_LVL_N6: c_int = 6;
pub const ESP_PWR_LVL_N3: c_int = 7;
pub const ESP_PWR_LVL_N0: c_int = 8;
pub const ESP_PWR_LVL_P3: c_int = 9;
pub const ESP_PWR_LVL_P6: c_int = 10;
pub const ESP_PWR_LVL_P9: c_int = 11;
pub const ESP_PWR_LVL_P12: c_int = 12;
pub const ESP_PWR_LVL_P15: c_int = 13;
pub const ESP_PWR_LVL_P18: c_int = 14;
pub const ESP_PWR_LVL_P21: c_int = 15;
pub const ESP_PWR_LVL_INVALID: c_int = 255;
pub const esp_power_level_t = c_uint;
pub extern fn esp_ble_tx_power_set(power_type: esp_ble_power_type_t, power_level: esp_power_level_t) esp_err_t;
pub extern fn esp_ble_tx_power_get(power_type: esp_ble_power_type_t) esp_power_level_t;
pub extern fn esp_bt_controller_init(cfg: [*c]esp_bt_controller_config_t) esp_err_t;
pub extern fn esp_bt_controller_deinit() esp_err_t;
pub extern fn esp_bt_controller_enable(mode: esp_bt_mode_t) esp_err_t;
pub extern fn esp_bt_controller_disable() esp_err_t;
pub extern fn esp_bt_controller_get_status() esp_bt_controller_status_t;
pub extern fn esp_bt_get_tx_buf_num() u16;
pub const esp_vhci_host_callback = extern struct {
    notify_host_send_available: ?*const fn () callconv(.C) void = std.mem.zeroes(?*const fn () callconv(.C) void),
    notify_host_recv: ?*const fn ([*c]u8, u16) callconv(.C) c_int = std.mem.zeroes(?*const fn ([*c]u8, u16) callconv(.C) c_int),
};
pub const esp_vhci_host_callback_t = esp_vhci_host_callback;
pub extern fn esp_vhci_host_check_send_available() bool;
pub extern fn esp_vhci_host_send_packet(data: [*c]u8, len: u16) void;
pub extern fn esp_vhci_host_register_callback(callback: [*c]const esp_vhci_host_callback_t) esp_err_t;
pub extern fn esp_bt_controller_mem_release(mode: esp_bt_mode_t) esp_err_t;
pub extern fn esp_bt_mem_release(mode: esp_bt_mode_t) esp_err_t;
pub extern fn esp_bt_sleep_enable() esp_err_t;
pub extern fn esp_bt_sleep_disable() esp_err_t;
pub extern fn esp_bt_controller_is_sleeping() bool;
pub extern fn esp_bt_controller_wakeup_request() void;
pub extern fn esp_bt_h4tl_eif_io_event_notify(event: c_int) c_int;
pub extern fn esp_wifi_bt_power_domain_on() void;
pub extern fn esp_wifi_bt_power_domain_off() void;
pub const ESP_BLUEDROID_STATUS_UNINITIALIZED: c_int = 0;
pub const ESP_BLUEDROID_STATUS_INITIALIZED: c_int = 1;
pub const ESP_BLUEDROID_STATUS_ENABLED: c_int = 2;
pub const esp_bluedroid_status_t = c_uint;
pub const esp_bluedroid_config_t = extern struct {
    ssp_en: bool = std.mem.zeroes(bool),
};
pub extern fn esp_bluedroid_get_status() esp_bluedroid_status_t;
pub extern fn esp_bluedroid_enable() esp_err_t;
pub extern fn esp_bluedroid_disable() esp_err_t;
pub extern fn esp_bluedroid_init() esp_err_t;
pub extern fn esp_bluedroid_init_with_cfg(cfg: [*c]esp_bluedroid_config_t) esp_err_t;
pub extern fn esp_bluedroid_deinit() esp_err_t;
pub const ESP_BT_STATUS_SUCCESS: c_int = 0;
pub const ESP_BT_STATUS_FAIL: c_int = 1;
pub const ESP_BT_STATUS_NOT_READY: c_int = 2;
pub const ESP_BT_STATUS_NOMEM: c_int = 3;
pub const ESP_BT_STATUS_BUSY: c_int = 4;
pub const ESP_BT_STATUS_DONE: c_int = 5;
pub const ESP_BT_STATUS_UNSUPPORTED: c_int = 6;
pub const ESP_BT_STATUS_PARM_INVALID: c_int = 7;
pub const ESP_BT_STATUS_UNHANDLED: c_int = 8;
pub const ESP_BT_STATUS_AUTH_FAILURE: c_int = 9;
pub const ESP_BT_STATUS_RMT_DEV_DOWN: c_int = 10;
pub const ESP_BT_STATUS_AUTH_REJECTED: c_int = 11;
pub const ESP_BT_STATUS_INVALID_STATIC_RAND_ADDR: c_int = 12;
pub const ESP_BT_STATUS_PENDING: c_int = 13;
pub const ESP_BT_STATUS_UNACCEPT_CONN_INTERVAL: c_int = 14;
pub const ESP_BT_STATUS_PARAM_OUT_OF_RANGE: c_int = 15;
pub const ESP_BT_STATUS_TIMEOUT: c_int = 16;
pub const ESP_BT_STATUS_PEER_LE_DATA_LEN_UNSUPPORTED: c_int = 17;
pub const ESP_BT_STATUS_CONTROL_LE_DATA_LEN_UNSUPPORTED: c_int = 18;
pub const ESP_BT_STATUS_ERR_ILLEGAL_PARAMETER_FMT: c_int = 19;
pub const ESP_BT_STATUS_MEMORY_FULL: c_int = 20;
pub const ESP_BT_STATUS_EIR_TOO_LARGE: c_int = 21;
pub const ESP_BT_STATUS_HCI_SUCCESS: c_int = 256;
pub const ESP_BT_STATUS_HCI_ILLEGAL_COMMAND: c_int = 257;
pub const ESP_BT_STATUS_HCI_NO_CONNECTION: c_int = 258;
pub const ESP_BT_STATUS_HCI_HW_FAILURE: c_int = 259;
pub const ESP_BT_STATUS_HCI_PAGE_TIMEOUT: c_int = 260;
pub const ESP_BT_STATUS_HCI_AUTH_FAILURE: c_int = 261;
pub const ESP_BT_STATUS_HCI_KEY_MISSING: c_int = 262;
pub const ESP_BT_STATUS_HCI_MEMORY_FULL: c_int = 263;
pub const ESP_BT_STATUS_HCI_CONNECTION_TOUT: c_int = 264;
pub const ESP_BT_STATUS_HCI_MAX_NUM_OF_CONNECTIONS: c_int = 265;
pub const ESP_BT_STATUS_HCI_MAX_NUM_OF_SCOS: c_int = 266;
pub const ESP_BT_STATUS_HCI_CONNECTION_EXISTS: c_int = 267;
pub const ESP_BT_STATUS_HCI_COMMAND_DISALLOWED: c_int = 268;
pub const ESP_BT_STATUS_HCI_HOST_REJECT_RESOURCES: c_int = 269;
pub const ESP_BT_STATUS_HCI_HOST_REJECT_SECURITY: c_int = 270;
pub const ESP_BT_STATUS_HCI_HOST_REJECT_DEVICE: c_int = 271;
pub const ESP_BT_STATUS_HCI_HOST_TIMEOUT: c_int = 272;
pub const ESP_BT_STATUS_HCI_UNSUPPORTED_VALUE: c_int = 273;
pub const ESP_BT_STATUS_HCI_ILLEGAL_PARAMETER_FMT: c_int = 274;
pub const ESP_BT_STATUS_HCI_PEER_USER: c_int = 275;
pub const ESP_BT_STATUS_HCI_PEER_LOW_RESOURCES: c_int = 276;
pub const ESP_BT_STATUS_HCI_PEER_POWER_OFF: c_int = 277;
pub const ESP_BT_STATUS_HCI_CONN_CAUSE_LOCAL_HOST: c_int = 278;
pub const ESP_BT_STATUS_HCI_REPEATED_ATTEMPTS: c_int = 279;
pub const ESP_BT_STATUS_HCI_PAIRING_NOT_ALLOWED: c_int = 280;
pub const ESP_BT_STATUS_HCI_UNKNOWN_LMP_PDU: c_int = 281;
pub const ESP_BT_STATUS_HCI_UNSUPPORTED_REM_FEATURE: c_int = 282;
pub const ESP_BT_STATUS_HCI_SCO_OFFSET_REJECTED: c_int = 283;
pub const ESP_BT_STATUS_HCI_SCO_INTERVAL_REJECTED: c_int = 284;
pub const ESP_BT_STATUS_HCI_SCO_AIR_MODE: c_int = 285;
pub const ESP_BT_STATUS_HCI_INVALID_LMP_PARAM: c_int = 286;
pub const ESP_BT_STATUS_HCI_UNSPECIFIED: c_int = 287;
pub const ESP_BT_STATUS_HCI_UNSUPPORTED_LMP_PARAMETERS: c_int = 288;
pub const ESP_BT_STATUS_HCI_ROLE_CHANGE_NOT_ALLOWED: c_int = 289;
pub const ESP_BT_STATUS_HCI_LMP_RESPONSE_TIMEOUT: c_int = 290;
pub const ESP_BT_STATUS_HCI_LMP_ERR_TRANS_COLLISION: c_int = 291;
pub const ESP_BT_STATUS_HCI_LMP_PDU_NOT_ALLOWED: c_int = 292;
pub const ESP_BT_STATUS_HCI_ENCRY_MODE_NOT_ACCEPTABLE: c_int = 293;
pub const ESP_BT_STATUS_HCI_UNIT_KEY_USED: c_int = 294;
pub const ESP_BT_STATUS_HCI_QOS_NOT_SUPPORTED: c_int = 295;
pub const ESP_BT_STATUS_HCI_INSTANT_PASSED: c_int = 296;
pub const ESP_BT_STATUS_HCI_PAIRING_WITH_UNIT_KEY_NOT_SUPPORTED: c_int = 297;
pub const ESP_BT_STATUS_HCI_DIFF_TRANSACTION_COLLISION: c_int = 298;
pub const ESP_BT_STATUS_HCI_UNDEFINED_0x2B: c_int = 299;
pub const ESP_BT_STATUS_HCI_QOS_UNACCEPTABLE_PARAM: c_int = 300;
pub const ESP_BT_STATUS_HCI_QOS_REJECTED: c_int = 301;
pub const ESP_BT_STATUS_HCI_CHAN_CLASSIF_NOT_SUPPORTED: c_int = 302;
pub const ESP_BT_STATUS_HCI_INSUFFCIENT_SECURITY: c_int = 303;
pub const ESP_BT_STATUS_HCI_PARAM_OUT_OF_RANGE: c_int = 304;
pub const ESP_BT_STATUS_HCI_UNDEFINED_0x31: c_int = 305;
pub const ESP_BT_STATUS_HCI_ROLE_SWITCH_PENDING: c_int = 306;
pub const ESP_BT_STATUS_HCI_UNDEFINED_0x33: c_int = 307;
pub const ESP_BT_STATUS_HCI_RESERVED_SLOT_VIOLATION: c_int = 308;
pub const ESP_BT_STATUS_HCI_ROLE_SWITCH_FAILED: c_int = 309;
pub const ESP_BT_STATUS_HCI_INQ_RSP_DATA_TOO_LARGE: c_int = 310;
pub const ESP_BT_STATUS_HCI_SIMPLE_PAIRING_NOT_SUPPORTED: c_int = 311;
pub const ESP_BT_STATUS_HCI_HOST_BUSY_PAIRING: c_int = 312;
pub const ESP_BT_STATUS_HCI_REJ_NO_SUITABLE_CHANNEL: c_int = 313;
pub const ESP_BT_STATUS_HCI_CONTROLLER_BUSY: c_int = 314;
pub const ESP_BT_STATUS_HCI_UNACCEPT_CONN_INTERVAL: c_int = 315;
pub const ESP_BT_STATUS_HCI_DIRECTED_ADVERTISING_TIMEOUT: c_int = 316;
pub const ESP_BT_STATUS_HCI_CONN_TOUT_DUE_TO_MIC_FAILURE: c_int = 317;
pub const ESP_BT_STATUS_HCI_CONN_FAILED_ESTABLISHMENT: c_int = 318;
pub const ESP_BT_STATUS_HCI_MAC_CONNECTION_FAILED: c_int = 319;
pub const esp_bt_status_t = c_uint;
pub const esp_bt_octet16_t = [16]u8;
pub const esp_bt_octet8_t = [8]u8;
pub const esp_link_key = [16]u8;
const union_unnamed_17 = extern union {
    uuid16: u16,
    uuid32: u32,
    uuid128: [16]u8,
};
pub const esp_bt_uuid_t = extern struct {
    len: u16 align(1) = std.mem.zeroes(u16),
    uuid: union_unnamed_17 align(1) = std.mem.zeroes(union_unnamed_17),
};
pub const ESP_BT_DEVICE_TYPE_BREDR: c_int = 1;
pub const ESP_BT_DEVICE_TYPE_BLE: c_int = 2;
pub const ESP_BT_DEVICE_TYPE_DUMO: c_int = 3;
pub const esp_bt_dev_type_t = c_uint;
pub const esp_bd_addr_t = [6]u8;
pub const BLE_ADDR_TYPE_PUBLIC: c_int = 0;
pub const BLE_ADDR_TYPE_RANDOM: c_int = 1;
pub const BLE_ADDR_TYPE_RPA_PUBLIC: c_int = 2;
pub const BLE_ADDR_TYPE_RPA_RANDOM: c_int = 3;
pub const esp_ble_addr_type_t = c_uint;
pub const BLE_WL_ADDR_TYPE_PUBLIC: c_int = 0;
pub const BLE_WL_ADDR_TYPE_RANDOM: c_int = 1;
pub const esp_ble_wl_addr_type_t = c_uint;
pub const esp_ble_key_mask_t = u8;
pub const esp_bt_dev_coex_op_t = u8;
pub const ESP_BT_DEV_COEX_TYPE_BLE: c_int = 1;
pub const ESP_BT_DEV_COEX_TYPE_BT: c_int = 2;
pub const esp_bt_dev_coex_type_t = c_uint;
pub const ESP_BT_DEV_NAME_RES_EVT: c_int = 0;
pub const ESP_BT_DEV_EVT_MAX: c_int = 1;
pub const esp_bt_dev_cb_event_t = c_uint;
pub const name_res_param_18 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
    name: [*c]u8 = std.mem.zeroes([*c]u8),
};
pub const esp_bt_dev_cb_param_t = extern union {
    name_res: name_res_param_18,
};
pub const esp_bt_dev_cb_t = ?*const fn (esp_bt_dev_cb_event_t, [*c]esp_bt_dev_cb_param_t) callconv(.C) void;
pub extern fn esp_bt_dev_register_callback(callback: esp_bt_dev_cb_t) esp_err_t;
pub extern fn esp_bt_dev_get_address() [*c]const u8;
pub extern fn esp_bt_dev_set_device_name(name: [*c]const u8) esp_err_t;
pub extern fn esp_bt_dev_get_device_name() esp_err_t;
pub extern fn esp_bt_dev_coex_status_config(@"type": esp_bt_dev_coex_type_t, op: esp_bt_dev_coex_op_t, status: u8) esp_err_t;
pub extern fn esp_bt_config_file_path_update(file_path: [*c]const u8) esp_err_t;
pub const WIFI_MODE_NULL: c_int = 0;
pub const WIFI_MODE_STA: c_int = 1;
pub const WIFI_MODE_AP: c_int = 2;
pub const WIFI_MODE_APSTA: c_int = 3;
pub const WIFI_MODE_NAN: c_int = 4;
pub const WIFI_MODE_MAX: c_int = 5;
pub const wifi_mode_t = c_uint;
pub const WIFI_IF_STA: c_int = 0;
pub const WIFI_IF_AP: c_int = 1;
pub const WIFI_IF_NAN: c_int = 2;
pub const WIFI_IF_MAX: c_int = 3;
pub const wifi_interface_t = c_uint;
pub const WIFI_COUNTRY_POLICY_AUTO: c_int = 0;
pub const WIFI_COUNTRY_POLICY_MANUAL: c_int = 1;
pub const wifi_country_policy_t = c_uint;
pub const wifi_country_t = extern struct {
    cc: [3]u8 = std.mem.zeroes([3]u8),
    schan: u8 = std.mem.zeroes(u8),
    nchan: u8 = std.mem.zeroes(u8),
    max_tx_power: i8 = std.mem.zeroes(i8),
    policy: wifi_country_policy_t = std.mem.zeroes(wifi_country_policy_t),
};
pub const WIFI_AUTH_OPEN: c_int = 0;
pub const WIFI_AUTH_WEP: c_int = 1;
pub const WIFI_AUTH_WPA_PSK: c_int = 2;
pub const WIFI_AUTH_WPA2_PSK: c_int = 3;
pub const WIFI_AUTH_WPA_WPA2_PSK: c_int = 4;
pub const WIFI_AUTH_ENTERPRISE: c_int = 5;
pub const WIFI_AUTH_WPA2_ENTERPRISE: c_int = 5;
pub const WIFI_AUTH_WPA3_PSK: c_int = 6;
pub const WIFI_AUTH_WPA2_WPA3_PSK: c_int = 7;
pub const WIFI_AUTH_WAPI_PSK: c_int = 8;
pub const WIFI_AUTH_OWE: c_int = 9;
pub const WIFI_AUTH_WPA3_ENT_192: c_int = 10;
pub const WIFI_AUTH_WPA3_EXT_PSK: c_int = 11;
pub const WIFI_AUTH_WPA3_EXT_PSK_MIXED_MODE: c_int = 12;
pub const WIFI_AUTH_MAX: c_int = 13;
pub const wifi_auth_mode_t = c_uint;
pub const WIFI_REASON_UNSPECIFIED: c_int = 1;
pub const WIFI_REASON_AUTH_EXPIRE: c_int = 2;
pub const WIFI_REASON_AUTH_LEAVE: c_int = 3;
pub const WIFI_REASON_ASSOC_EXPIRE: c_int = 4;
pub const WIFI_REASON_ASSOC_TOOMANY: c_int = 5;
pub const WIFI_REASON_NOT_AUTHED: c_int = 6;
pub const WIFI_REASON_NOT_ASSOCED: c_int = 7;
pub const WIFI_REASON_ASSOC_LEAVE: c_int = 8;
pub const WIFI_REASON_ASSOC_NOT_AUTHED: c_int = 9;
pub const WIFI_REASON_DISASSOC_PWRCAP_BAD: c_int = 10;
pub const WIFI_REASON_DISASSOC_SUPCHAN_BAD: c_int = 11;
pub const WIFI_REASON_BSS_TRANSITION_DISASSOC: c_int = 12;
pub const WIFI_REASON_IE_INVALID: c_int = 13;
pub const WIFI_REASON_MIC_FAILURE: c_int = 14;
pub const WIFI_REASON_4WAY_HANDSHAKE_TIMEOUT: c_int = 15;
pub const WIFI_REASON_GROUP_KEY_UPDATE_TIMEOUT: c_int = 16;
pub const WIFI_REASON_IE_IN_4WAY_DIFFERS: c_int = 17;
pub const WIFI_REASON_GROUP_CIPHER_INVALID: c_int = 18;
pub const WIFI_REASON_PAIRWISE_CIPHER_INVALID: c_int = 19;
pub const WIFI_REASON_AKMP_INVALID: c_int = 20;
pub const WIFI_REASON_UNSUPP_RSN_IE_VERSION: c_int = 21;
pub const WIFI_REASON_INVALID_RSN_IE_CAP: c_int = 22;
pub const WIFI_REASON_802_1X_AUTH_FAILED: c_int = 23;
pub const WIFI_REASON_CIPHER_SUITE_REJECTED: c_int = 24;
pub const WIFI_REASON_TDLS_PEER_UNREACHABLE: c_int = 25;
pub const WIFI_REASON_TDLS_UNSPECIFIED: c_int = 26;
pub const WIFI_REASON_SSP_REQUESTED_DISASSOC: c_int = 27;
pub const WIFI_REASON_NO_SSP_ROAMING_AGREEMENT: c_int = 28;
pub const WIFI_REASON_BAD_CIPHER_OR_AKM: c_int = 29;
pub const WIFI_REASON_NOT_AUTHORIZED_THIS_LOCATION: c_int = 30;
pub const WIFI_REASON_SERVICE_CHANGE_PERCLUDES_TS: c_int = 31;
pub const WIFI_REASON_UNSPECIFIED_QOS: c_int = 32;
pub const WIFI_REASON_NOT_ENOUGH_BANDWIDTH: c_int = 33;
pub const WIFI_REASON_MISSING_ACKS: c_int = 34;
pub const WIFI_REASON_EXCEEDED_TXOP: c_int = 35;
pub const WIFI_REASON_STA_LEAVING: c_int = 36;
pub const WIFI_REASON_END_BA: c_int = 37;
pub const WIFI_REASON_UNKNOWN_BA: c_int = 38;
pub const WIFI_REASON_TIMEOUT: c_int = 39;
pub const WIFI_REASON_PEER_INITIATED: c_int = 46;
pub const WIFI_REASON_AP_INITIATED: c_int = 47;
pub const WIFI_REASON_INVALID_FT_ACTION_FRAME_COUNT: c_int = 48;
pub const WIFI_REASON_INVALID_PMKID: c_int = 49;
pub const WIFI_REASON_INVALID_MDE: c_int = 50;
pub const WIFI_REASON_INVALID_FTE: c_int = 51;
pub const WIFI_REASON_TRANSMISSION_LINK_ESTABLISH_FAILED: c_int = 67;
pub const WIFI_REASON_ALTERATIVE_CHANNEL_OCCUPIED: c_int = 68;
pub const WIFI_REASON_BEACON_TIMEOUT: c_int = 200;
pub const WIFI_REASON_NO_AP_FOUND: c_int = 201;
pub const WIFI_REASON_AUTH_FAIL: c_int = 202;
pub const WIFI_REASON_ASSOC_FAIL: c_int = 203;
pub const WIFI_REASON_HANDSHAKE_TIMEOUT: c_int = 204;
pub const WIFI_REASON_CONNECTION_FAIL: c_int = 205;
pub const WIFI_REASON_AP_TSF_RESET: c_int = 206;
pub const WIFI_REASON_ROAMING: c_int = 207;
pub const WIFI_REASON_ASSOC_COMEBACK_TIME_TOO_LONG: c_int = 208;
pub const WIFI_REASON_SA_QUERY_TIMEOUT: c_int = 209;
pub const WIFI_REASON_NO_AP_FOUND_W_COMPATIBLE_SECURITY: c_int = 210;
pub const WIFI_REASON_NO_AP_FOUND_IN_AUTHMODE_THRESHOLD: c_int = 211;
pub const WIFI_REASON_NO_AP_FOUND_IN_RSSI_THRESHOLD: c_int = 212;
pub const wifi_err_reason_t = c_uint;
pub const WIFI_SECOND_CHAN_NONE: c_int = 0;
pub const WIFI_SECOND_CHAN_ABOVE: c_int = 1;
pub const WIFI_SECOND_CHAN_BELOW: c_int = 2;
pub const wifi_second_chan_t = c_uint;
pub const WIFI_SCAN_TYPE_ACTIVE: c_int = 0;
pub const WIFI_SCAN_TYPE_PASSIVE: c_int = 1;
pub const wifi_scan_type_t = c_uint;
pub const wifi_active_scan_time_t = extern struct {
    min: u32 = std.mem.zeroes(u32),
    max: u32 = std.mem.zeroes(u32),
};
pub const wifi_scan_time_t = extern struct {
    active: wifi_active_scan_time_t = std.mem.zeroes(wifi_active_scan_time_t),
    passive: u32 = std.mem.zeroes(u32),
};
pub const wifi_scan_config_t = extern struct {
    ssid: [*c]u8 = std.mem.zeroes([*c]u8),
    bssid: [*c]u8 = std.mem.zeroes([*c]u8),
    channel: u8 = std.mem.zeroes(u8),
    show_hidden: bool = std.mem.zeroes(bool),
    scan_type: wifi_scan_type_t = std.mem.zeroes(wifi_scan_type_t),
    scan_time: wifi_scan_time_t = std.mem.zeroes(wifi_scan_time_t),
    home_chan_dwell_time: u8 = std.mem.zeroes(u8),
};
pub const WIFI_CIPHER_TYPE_NONE: c_int = 0;
pub const WIFI_CIPHER_TYPE_WEP40: c_int = 1;
pub const WIFI_CIPHER_TYPE_WEP104: c_int = 2;
pub const WIFI_CIPHER_TYPE_TKIP: c_int = 3;
pub const WIFI_CIPHER_TYPE_CCMP: c_int = 4;
pub const WIFI_CIPHER_TYPE_TKIP_CCMP: c_int = 5;
pub const WIFI_CIPHER_TYPE_AES_CMAC128: c_int = 6;
pub const WIFI_CIPHER_TYPE_SMS4: c_int = 7;
pub const WIFI_CIPHER_TYPE_GCMP: c_int = 8;
pub const WIFI_CIPHER_TYPE_GCMP256: c_int = 9;
pub const WIFI_CIPHER_TYPE_AES_GMAC128: c_int = 10;
pub const WIFI_CIPHER_TYPE_AES_GMAC256: c_int = 11;
pub const WIFI_CIPHER_TYPE_UNKNOWN: c_int = 12;
pub const wifi_cipher_type_t = c_uint;
pub const WIFI_ANT_ANT0: c_int = 0;
pub const WIFI_ANT_ANT1: c_int = 1;
pub const WIFI_ANT_MAX: c_int = 2;
pub const wifi_ant_t = c_uint; // esp-idf/components/esp_wifi/include/esp_wifi_types_generic.h:207:13: warning: struct demoted to opaque type - has bitfield
pub const wifi_he_ap_info_t = opaque {}; // esp-idf/components/esp_wifi/include/esp_wifi_types_generic.h:224:14: warning: struct demoted to opaque type - has bitfield
pub const wifi_ap_record_t = opaque {};
pub const WIFI_FAST_SCAN: c_int = 0;
pub const WIFI_ALL_CHANNEL_SCAN: c_int = 1;
pub const wifi_scan_method_t = c_uint;
pub const WIFI_CONNECT_AP_BY_SIGNAL: c_int = 0;
pub const WIFI_CONNECT_AP_BY_SECURITY: c_int = 1;
pub const wifi_sort_method_t = c_uint;
pub const wifi_scan_threshold_t = extern struct {
    rssi: i8 = std.mem.zeroes(i8),
    authmode: wifi_auth_mode_t = std.mem.zeroes(wifi_auth_mode_t),
};
pub const WIFI_PS_NONE: c_int = 0;
pub const WIFI_PS_MIN_MODEM: c_int = 1;
pub const WIFI_PS_MAX_MODEM: c_int = 2;
pub const wifi_ps_type_t = c_uint;
pub const WIFI_BW_HT20: c_int = 1;
pub const WIFI_BW_HT40: c_int = 2;
pub const wifi_bandwidth_t = c_uint;
pub const wifi_pmf_config_t = extern struct {
    capable: bool = std.mem.zeroes(bool),
    required: bool = std.mem.zeroes(bool),
};
pub const WPA3_SAE_PWE_UNSPECIFIED: c_int = 0;
pub const WPA3_SAE_PWE_HUNT_AND_PECK: c_int = 1;
pub const WPA3_SAE_PWE_HASH_TO_ELEMENT: c_int = 2;
pub const WPA3_SAE_PWE_BOTH: c_int = 3;
pub const wifi_sae_pwe_method_t = c_uint;
pub const WPA3_SAE_PK_MODE_AUTOMATIC: c_int = 0;
pub const WPA3_SAE_PK_MODE_ONLY: c_int = 1;
pub const WPA3_SAE_PK_MODE_DISABLED: c_int = 2;
pub const wifi_sae_pk_mode_t = c_uint;
pub const wifi_ap_config_t = extern struct {
    ssid: [32]u8 = std.mem.zeroes([32]u8),
    password: [64]u8 = std.mem.zeroes([64]u8),
    ssid_len: u8 = std.mem.zeroes(u8),
    channel: u8 = std.mem.zeroes(u8),
    authmode: wifi_auth_mode_t = std.mem.zeroes(wifi_auth_mode_t),
    ssid_hidden: u8 = std.mem.zeroes(u8),
    max_connection: u8 = std.mem.zeroes(u8),
    beacon_interval: u16 = std.mem.zeroes(u16),
    pairwise_cipher: wifi_cipher_type_t = std.mem.zeroes(wifi_cipher_type_t),
    ftm_responder: bool = std.mem.zeroes(bool),
    pmf_cfg: wifi_pmf_config_t = std.mem.zeroes(wifi_pmf_config_t),
    sae_pwe_h2e: wifi_sae_pwe_method_t = std.mem.zeroes(wifi_sae_pwe_method_t),
}; // esp-idf/components/esp_wifi/include/esp_wifi_types_generic.h:321:14: warning: struct demoted to opaque type - has bitfield
pub const wifi_sta_config_t = opaque {};
pub const wifi_nan_config_t = extern struct {
    op_channel: u8 = std.mem.zeroes(u8),
    master_pref: u8 = std.mem.zeroes(u8),
    scan_time: u8 = std.mem.zeroes(u8),
    warm_up_sec: u16 = std.mem.zeroes(u16),
};
pub const wifi_config_t = extern union {
    ap: wifi_ap_config_t,
    sta: wifi_sta_config_t,
    nan: wifi_nan_config_t,
}; // esp-idf/components/esp_wifi/include/esp_wifi_types_generic.h:371:14: warning: struct demoted to opaque type - has bitfield
pub const wifi_sta_info_t = opaque {};
pub const WIFI_STORAGE_FLASH: c_int = 0;
pub const WIFI_STORAGE_RAM: c_int = 1;
pub const wifi_storage_t = c_uint;
pub const WIFI_VND_IE_TYPE_BEACON: c_int = 0;
pub const WIFI_VND_IE_TYPE_PROBE_REQ: c_int = 1;
pub const WIFI_VND_IE_TYPE_PROBE_RESP: c_int = 2;
pub const WIFI_VND_IE_TYPE_ASSOC_REQ: c_int = 3;
pub const WIFI_VND_IE_TYPE_ASSOC_RESP: c_int = 4;
pub const wifi_vendor_ie_type_t = c_uint;
pub const WIFI_VND_IE_ID_0: c_int = 0;
pub const WIFI_VND_IE_ID_1: c_int = 1;
pub const wifi_vendor_ie_id_t = c_uint;
pub const WIFI_PHY_MODE_LR: c_int = 0;
pub const WIFI_PHY_MODE_11B: c_int = 1;
pub const WIFI_PHY_MODE_11G: c_int = 2;
pub const WIFI_PHY_MODE_HT20: c_int = 3;
pub const WIFI_PHY_MODE_HT40: c_int = 4;
pub const WIFI_PHY_MODE_HE20: c_int = 5;
pub const wifi_phy_mode_t = c_uint;
pub const vendor_ie_data_t = extern struct {
    element_id: u8 align(1) = std.mem.zeroes(u8),
    length: u8 = std.mem.zeroes(u8),
    vendor_oui: [3]u8 = std.mem.zeroes([3]u8),
    vendor_oui_type: u8 = std.mem.zeroes(u8),
    pub fn payload(self: anytype) std.zig.c_translation.FlexibleArrayType(@TypeOf(self), u8) {
        const Intermediate = std.zig.c_translation.FlexibleArrayType(@TypeOf(self), u8);
        const ReturnType = std.zig.c_translation.FlexibleArrayType(@TypeOf(self), u8);
        return @as(ReturnType, @ptrCast(@alignCast(@as(Intermediate, @ptrCast(self)) + 6)));
    }
};
pub const WIFI_PKT_MGMT: c_int = 0;
pub const WIFI_PKT_CTRL: c_int = 1;
pub const WIFI_PKT_DATA: c_int = 2;
pub const WIFI_PKT_MISC: c_int = 3;
pub const wifi_promiscuous_pkt_type_t = c_uint;
pub const wifi_promiscuous_filter_t = extern struct {
    filter_mask: u32 = std.mem.zeroes(u32),
};
pub const wifi_csi_info_t = extern struct {
    rx_ctrl: wifi_pkt_rx_ctrl_t = std.mem.zeroes(wifi_pkt_rx_ctrl_t),
    mac: [6]u8 = std.mem.zeroes([6]u8),
    dmac: [6]u8 = std.mem.zeroes([6]u8),
    first_word_invalid: bool = std.mem.zeroes(bool),
    buf: [*c]i8 = std.mem.zeroes([*c]i8),
    len: u16 = std.mem.zeroes(u16),
    hdr: [*c]u8 = std.mem.zeroes([*c]u8),
    payload: [*c]u8 = std.mem.zeroes([*c]u8),
    payload_len: u16 = std.mem.zeroes(u16),
};
// esp-idf/components/esp_wifi/include/esp_wifi_types_generic.h:490:13: warning: struct demoted to opaque type - has bitfield
pub const wifi_ant_gpio_t = opaque {};
pub const wifi_ant_gpio_config_t = extern struct {
    gpio_cfg: [4]wifi_ant_gpio_t = std.mem.zeroes([4]wifi_ant_gpio_t),
};
pub const WIFI_ANT_MODE_ANT0: c_int = 0;
pub const WIFI_ANT_MODE_ANT1: c_int = 1;
pub const WIFI_ANT_MODE_AUTO: c_int = 2;
pub const WIFI_ANT_MODE_MAX: c_int = 3;
pub const wifi_ant_mode_t = c_uint; // esp-idf/components/esp_wifi/include/esp_wifi_types_generic.h:521:21: warning: struct demoted to opaque type - has bitfield
pub const wifi_ant_config_t = opaque {};
pub const wifi_action_rx_cb_t = ?*const fn ([*c]u8, [*c]u8, usize, u8) callconv(.C) c_int;
pub const wifi_action_tx_req_t = extern struct {
    ifx: wifi_interface_t align(4) = std.mem.zeroes(wifi_interface_t),
    dest_mac: [6]u8 = std.mem.zeroes([6]u8),
    no_ack: bool = std.mem.zeroes(bool),
    rx_cb: wifi_action_rx_cb_t = std.mem.zeroes(wifi_action_rx_cb_t),
    data_len: u32 = std.mem.zeroes(u32),
    pub fn data(self: anytype) std.zig.c_translation.FlexibleArrayType(@TypeOf(self), u8) {
        const Intermediate = std.zig.c_translation.FlexibleArrayType(@TypeOf(self), u8);
        const ReturnType = std.zig.c_translation.FlexibleArrayType(@TypeOf(self), u8);
        return @as(ReturnType, @ptrCast(@alignCast(@as(Intermediate, @ptrCast(self)) + 20)));
    }
};
pub const wifi_ftm_initiator_cfg_t = extern struct {
    resp_mac: [6]u8 = std.mem.zeroes([6]u8),
    channel: u8 = std.mem.zeroes(u8),
    frm_count: u8 = std.mem.zeroes(u8),
    burst_period: u16 = std.mem.zeroes(u16),
};
pub const NAN_PUBLISH_SOLICITED: c_int = 0;
pub const NAN_PUBLISH_UNSOLICITED: c_int = 1;
pub const NAN_SUBSCRIBE_ACTIVE: c_int = 2;
pub const NAN_SUBSCRIBE_PASSIVE: c_int = 3;
pub const wifi_nan_service_type_t = c_uint; // esp-idf/components/esp_wifi/include/esp_wifi_types_generic.h:591:13: warning: struct demoted to opaque type - has bitfield
pub const wifi_nan_publish_cfg_t = opaque {}; // esp-idf/components/esp_wifi/include/esp_wifi_types_generic.h:605:13: warning: struct demoted to opaque type - has bitfield
pub const wifi_nan_subscribe_cfg_t = opaque {};
pub const wifi_nan_followup_params_t = extern struct {
    inst_id: u8 = std.mem.zeroes(u8),
    peer_inst_id: u8 = std.mem.zeroes(u8),
    peer_mac: [6]u8 = std.mem.zeroes([6]u8),
    svc_info: [64]u8 = std.mem.zeroes([64]u8),
};
pub const wifi_nan_datapath_req_t = extern struct {
    pub_id: u8 = std.mem.zeroes(u8),
    peer_mac: [6]u8 = std.mem.zeroes([6]u8),
    confirm_required: bool = std.mem.zeroes(bool),
};
pub const wifi_nan_datapath_resp_t = extern struct {
    accept: bool = std.mem.zeroes(bool),
    ndp_id: u8 = std.mem.zeroes(u8),
    peer_mac: [6]u8 = std.mem.zeroes([6]u8),
};
pub const wifi_nan_datapath_end_req_t = extern struct {
    ndp_id: u8 = std.mem.zeroes(u8),
    peer_mac: [6]u8 = std.mem.zeroes([6]u8),
};
pub const WIFI_PHY_RATE_1M_L: c_int = 0;
pub const WIFI_PHY_RATE_2M_L: c_int = 1;
pub const WIFI_PHY_RATE_5M_L: c_int = 2;
pub const WIFI_PHY_RATE_11M_L: c_int = 3;
pub const WIFI_PHY_RATE_2M_S: c_int = 5;
pub const WIFI_PHY_RATE_5M_S: c_int = 6;
pub const WIFI_PHY_RATE_11M_S: c_int = 7;
pub const WIFI_PHY_RATE_48M: c_int = 8;
pub const WIFI_PHY_RATE_24M: c_int = 9;
pub const WIFI_PHY_RATE_12M: c_int = 10;
pub const WIFI_PHY_RATE_6M: c_int = 11;
pub const WIFI_PHY_RATE_54M: c_int = 12;
pub const WIFI_PHY_RATE_36M: c_int = 13;
pub const WIFI_PHY_RATE_18M: c_int = 14;
pub const WIFI_PHY_RATE_9M: c_int = 15;
pub const WIFI_PHY_RATE_MCS0_LGI: c_int = 16;
pub const WIFI_PHY_RATE_MCS1_LGI: c_int = 17;
pub const WIFI_PHY_RATE_MCS2_LGI: c_int = 18;
pub const WIFI_PHY_RATE_MCS3_LGI: c_int = 19;
pub const WIFI_PHY_RATE_MCS4_LGI: c_int = 20;
pub const WIFI_PHY_RATE_MCS5_LGI: c_int = 21;
pub const WIFI_PHY_RATE_MCS6_LGI: c_int = 22;
pub const WIFI_PHY_RATE_MCS7_LGI: c_int = 23;
pub const WIFI_PHY_RATE_MCS8_LGI: c_int = 24;
pub const WIFI_PHY_RATE_MCS9_LGI: c_int = 25;
pub const WIFI_PHY_RATE_MCS0_SGI: c_int = 26;
pub const WIFI_PHY_RATE_MCS1_SGI: c_int = 27;
pub const WIFI_PHY_RATE_MCS2_SGI: c_int = 28;
pub const WIFI_PHY_RATE_MCS3_SGI: c_int = 29;
pub const WIFI_PHY_RATE_MCS4_SGI: c_int = 30;
pub const WIFI_PHY_RATE_MCS5_SGI: c_int = 31;
pub const WIFI_PHY_RATE_MCS6_SGI: c_int = 32;
pub const WIFI_PHY_RATE_MCS7_SGI: c_int = 33;
pub const WIFI_PHY_RATE_MCS8_SGI: c_int = 34;
pub const WIFI_PHY_RATE_MCS9_SGI: c_int = 35;
pub const WIFI_PHY_RATE_LORA_250K: c_int = 41;
pub const WIFI_PHY_RATE_LORA_500K: c_int = 42;
pub const WIFI_PHY_RATE_MAX: c_int = 43;
pub const wifi_phy_rate_t = c_uint;
pub const WIFI_EVENT_WIFI_READY: c_int = 0;
pub const WIFI_EVENT_SCAN_DONE: c_int = 1;
pub const WIFI_EVENT_STA_START: c_int = 2;
pub const WIFI_EVENT_STA_STOP: c_int = 3;
pub const WIFI_EVENT_STA_CONNECTED: c_int = 4;
pub const WIFI_EVENT_STA_DISCONNECTED: c_int = 5;
pub const WIFI_EVENT_STA_AUTHMODE_CHANGE: c_int = 6;
pub const WIFI_EVENT_STA_WPS_ER_SUCCESS: c_int = 7;
pub const WIFI_EVENT_STA_WPS_ER_FAILED: c_int = 8;
pub const WIFI_EVENT_STA_WPS_ER_TIMEOUT: c_int = 9;
pub const WIFI_EVENT_STA_WPS_ER_PIN: c_int = 10;
pub const WIFI_EVENT_STA_WPS_ER_PBC_OVERLAP: c_int = 11;
pub const WIFI_EVENT_AP_START: c_int = 12;
pub const WIFI_EVENT_AP_STOP: c_int = 13;
pub const WIFI_EVENT_AP_STACONNECTED: c_int = 14;
pub const WIFI_EVENT_AP_STADISCONNECTED: c_int = 15;
pub const WIFI_EVENT_AP_PROBEREQRECVED: c_int = 16;
pub const WIFI_EVENT_FTM_REPORT: c_int = 17;
pub const WIFI_EVENT_STA_BSS_RSSI_LOW: c_int = 18;
pub const WIFI_EVENT_ACTION_TX_STATUS: c_int = 19;
pub const WIFI_EVENT_ROC_DONE: c_int = 20;
pub const WIFI_EVENT_STA_BEACON_TIMEOUT: c_int = 21;
pub const WIFI_EVENT_CONNECTIONLESS_MODULE_WAKE_INTERVAL_START: c_int = 22;
pub const WIFI_EVENT_AP_WPS_RG_SUCCESS: c_int = 23;
pub const WIFI_EVENT_AP_WPS_RG_FAILED: c_int = 24;
pub const WIFI_EVENT_AP_WPS_RG_TIMEOUT: c_int = 25;
pub const WIFI_EVENT_AP_WPS_RG_PIN: c_int = 26;
pub const WIFI_EVENT_AP_WPS_RG_PBC_OVERLAP: c_int = 27;
pub const WIFI_EVENT_ITWT_SETUP: c_int = 28;
pub const WIFI_EVENT_ITWT_TEARDOWN: c_int = 29;
pub const WIFI_EVENT_ITWT_PROBE: c_int = 30;
pub const WIFI_EVENT_ITWT_SUSPEND: c_int = 31;
pub const WIFI_EVENT_NAN_STARTED: c_int = 32;
pub const WIFI_EVENT_NAN_STOPPED: c_int = 33;
pub const WIFI_EVENT_NAN_SVC_MATCH: c_int = 34;
pub const WIFI_EVENT_NAN_REPLIED: c_int = 35;
pub const WIFI_EVENT_NAN_RECEIVE: c_int = 36;
pub const WIFI_EVENT_NDP_INDICATION: c_int = 37;
pub const WIFI_EVENT_NDP_CONFIRM: c_int = 38;
pub const WIFI_EVENT_NDP_TERMINATED: c_int = 39;
pub const WIFI_EVENT_HOME_CHANNEL_CHANGE: c_int = 40;
pub const WIFI_EVENT_MAX: c_int = 41;
pub const wifi_event_t = c_uint;
pub extern const WIFI_EVENT: esp_event_base_t;
pub const wifi_event_sta_scan_done_t = extern struct {
    status: u32 = std.mem.zeroes(u32),
    number: u8 = std.mem.zeroes(u8),
    scan_id: u8 = std.mem.zeroes(u8),
};
pub const wifi_event_sta_connected_t = extern struct {
    ssid: [32]u8 = std.mem.zeroes([32]u8),
    ssid_len: u8 = std.mem.zeroes(u8),
    bssid: [6]u8 = std.mem.zeroes([6]u8),
    channel: u8 = std.mem.zeroes(u8),
    authmode: wifi_auth_mode_t = std.mem.zeroes(wifi_auth_mode_t),
    aid: u16 = std.mem.zeroes(u16),
};
pub const wifi_event_sta_disconnected_t = extern struct {
    ssid: [32]u8 = std.mem.zeroes([32]u8),
    ssid_len: u8 = std.mem.zeroes(u8),
    bssid: [6]u8 = std.mem.zeroes([6]u8),
    reason: u8 = std.mem.zeroes(u8),
    rssi: i8 = std.mem.zeroes(i8),
};
pub const wifi_event_sta_authmode_change_t = extern struct {
    old_mode: wifi_auth_mode_t = std.mem.zeroes(wifi_auth_mode_t),
    new_mode: wifi_auth_mode_t = std.mem.zeroes(wifi_auth_mode_t),
};
pub const wifi_event_sta_wps_er_pin_t = extern struct {
    pin_code: [8]u8 = std.mem.zeroes([8]u8),
};
pub const WPS_FAIL_REASON_NORMAL: c_int = 0;
pub const WPS_FAIL_REASON_RECV_M2D: c_int = 1;
pub const WPS_FAIL_REASON_MAX: c_int = 2;
pub const wifi_event_sta_wps_fail_reason_t = c_uint;
const unnamed_19 = extern struct {
    ssid: [32]u8 = std.mem.zeroes([32]u8),
    passphrase: [64]u8 = std.mem.zeroes([64]u8),
};
pub const wifi_event_sta_wps_er_success_t = extern struct {
    ap_cred_cnt: u8 = std.mem.zeroes(u8),
    ap_cred: [3]unnamed_19 = std.mem.zeroes([3]unnamed_19),
};
pub const wifi_event_ap_staconnected_t = extern struct {
    mac: [6]u8 = std.mem.zeroes([6]u8),
    aid: u8 = std.mem.zeroes(u8),
    is_mesh_child: bool = std.mem.zeroes(bool),
};
pub const wifi_event_ap_stadisconnected_t = extern struct {
    mac: [6]u8 = std.mem.zeroes([6]u8),
    aid: u8 = std.mem.zeroes(u8),
    is_mesh_child: bool = std.mem.zeroes(bool),
    reason: u8 = std.mem.zeroes(u8),
};
pub const wifi_event_ap_probe_req_rx_t = extern struct {
    rssi: c_int = std.mem.zeroes(c_int),
    mac: [6]u8 = std.mem.zeroes([6]u8),
};
pub const wifi_event_bss_rssi_low_t = extern struct {
    rssi: i32 = std.mem.zeroes(i32),
};
pub const wifi_event_home_channel_change_t = extern struct {
    old_chan: u8 = std.mem.zeroes(u8),
    old_snd: wifi_second_chan_t = std.mem.zeroes(wifi_second_chan_t),
    new_chan: u8 = std.mem.zeroes(u8),
    new_snd: wifi_second_chan_t = std.mem.zeroes(wifi_second_chan_t),
};
pub const FTM_STATUS_SUCCESS: c_int = 0;
pub const FTM_STATUS_UNSUPPORTED: c_int = 1;
pub const FTM_STATUS_CONF_REJECTED: c_int = 2;
pub const FTM_STATUS_NO_RESPONSE: c_int = 3;
pub const FTM_STATUS_FAIL: c_int = 4;
pub const wifi_ftm_status_t = c_uint;
pub const wifi_ftm_report_entry_t = extern struct {
    dlog_token: u8 = std.mem.zeroes(u8),
    rssi: i8 = std.mem.zeroes(i8),
    rtt: u32 = std.mem.zeroes(u32),
    t1: u64 = std.mem.zeroes(u64),
    t2: u64 = std.mem.zeroes(u64),
    t3: u64 = std.mem.zeroes(u64),
    t4: u64 = std.mem.zeroes(u64),
};
pub const wifi_event_ftm_report_t = extern struct {
    peer_mac: [6]u8 = std.mem.zeroes([6]u8),
    status: wifi_ftm_status_t = std.mem.zeroes(wifi_ftm_status_t),
    rtt_raw: u32 = std.mem.zeroes(u32),
    rtt_est: u32 = std.mem.zeroes(u32),
    dist_est: u32 = std.mem.zeroes(u32),
    ftm_report_data: [*c]wifi_ftm_report_entry_t = std.mem.zeroes([*c]wifi_ftm_report_entry_t),
    ftm_report_num_entries: u8 = std.mem.zeroes(u8),
};
pub const wifi_event_action_tx_status_t = extern struct {
    ifx: wifi_interface_t = std.mem.zeroes(wifi_interface_t),
    context: u32 = std.mem.zeroes(u32),
    da: [6]u8 = std.mem.zeroes([6]u8),
    status: u8 = std.mem.zeroes(u8),
};
pub const wifi_event_roc_done_t = extern struct {
    context: u32 = std.mem.zeroes(u32),
};
pub const wifi_event_ap_wps_rg_pin_t = extern struct {
    pin_code: [8]u8 = std.mem.zeroes([8]u8),
};
pub const WPS_AP_FAIL_REASON_NORMAL: c_int = 0;
pub const WPS_AP_FAIL_REASON_CONFIG: c_int = 1;
pub const WPS_AP_FAIL_REASON_AUTH: c_int = 2;
pub const WPS_AP_FAIL_REASON_MAX: c_int = 3;
pub const wps_fail_reason_t = c_uint;
pub const wifi_event_ap_wps_rg_fail_reason_t = extern struct {
    reason: wps_fail_reason_t = std.mem.zeroes(wps_fail_reason_t),
    peer_macaddr: [6]u8 = std.mem.zeroes([6]u8),
};
pub const wifi_event_ap_wps_rg_success_t = extern struct {
    peer_macaddr: [6]u8 = std.mem.zeroes([6]u8),
};
pub const wifi_event_nan_svc_match_t = extern struct {
    subscribe_id: u8 = std.mem.zeroes(u8),
    publish_id: u8 = std.mem.zeroes(u8),
    pub_if_mac: [6]u8 = std.mem.zeroes([6]u8),
    update_pub_id: bool = std.mem.zeroes(bool),
};
pub const wifi_event_nan_replied_t = extern struct {
    publish_id: u8 = std.mem.zeroes(u8),
    subscribe_id: u8 = std.mem.zeroes(u8),
    sub_if_mac: [6]u8 = std.mem.zeroes([6]u8),
};
pub const wifi_event_nan_receive_t = extern struct {
    inst_id: u8 = std.mem.zeroes(u8),
    peer_inst_id: u8 = std.mem.zeroes(u8),
    peer_if_mac: [6]u8 = std.mem.zeroes([6]u8),
    peer_svc_info: [64]u8 = std.mem.zeroes([64]u8),
};
pub const wifi_event_ndp_indication_t = extern struct {
    publish_id: u8 = std.mem.zeroes(u8),
    ndp_id: u8 = std.mem.zeroes(u8),
    peer_nmi: [6]u8 = std.mem.zeroes([6]u8),
    peer_ndi: [6]u8 = std.mem.zeroes([6]u8),
    svc_info: [64]u8 = std.mem.zeroes([64]u8),
};
pub const wifi_event_ndp_confirm_t = extern struct {
    status: u8 = std.mem.zeroes(u8),
    ndp_id: u8 = std.mem.zeroes(u8),
    peer_nmi: [6]u8 = std.mem.zeroes([6]u8),
    peer_ndi: [6]u8 = std.mem.zeroes([6]u8),
    own_ndi: [6]u8 = std.mem.zeroes([6]u8),
    svc_info: [64]u8 = std.mem.zeroes([64]u8),
};
pub const wifi_event_ndp_terminated_t = extern struct {
    reason: u8 = std.mem.zeroes(u8),
    ndp_id: u8 = std.mem.zeroes(u8),
    init_ndi: [6]u8 = std.mem.zeroes([6]u8),
};
pub const wifi_sta_list_t = extern struct {
    sta: [10]wifi_sta_info_t = std.mem.zeroes([10]wifi_sta_info_t),
    num: c_int = std.mem.zeroes(c_int),
};
// esp-idf/components/esp_wifi/include/local/esp_wifi_types_native.h:38:12: warning: struct demoted to opaque type - has bitfield
pub const wifi_pkt_rx_ctrl_t = opaque {};
pub const wifi_csi_config_t = extern struct {
    lltf_en: bool = std.mem.zeroes(bool),
    htltf_en: bool = std.mem.zeroes(bool),
    stbc_htltf2_en: bool = std.mem.zeroes(bool),
    ltf_merge_en: bool = std.mem.zeroes(bool),
    channel_filter_en: bool = std.mem.zeroes(bool),
    manu_scale: bool = std.mem.zeroes(bool),
    shift: u8 = std.mem.zeroes(u8),
    dump_ack_en: bool = std.mem.zeroes(bool),
};
pub const wifi_promiscuous_pkt_t = extern struct {
    rx_ctrl: wifi_pkt_rx_ctrl_t align(4) = std.mem.zeroes(wifi_pkt_rx_ctrl_t),
    pub fn payload(self: anytype) std.zig.c_translation.FlexibleArrayType(@TypeOf(self), u8) {
        const Intermediate = std.zig.c_translation.FlexibleArrayType(@TypeOf(self), u8);
        const ReturnType = std.zig.c_translation.FlexibleArrayType(@TypeOf(self), u8);
        return @as(ReturnType, @ptrCast(@alignCast(@as(Intermediate, @ptrCast(self)) + 48)));
    }
};
pub const ESP_BLUFI_EVENT_INIT_FINISH: c_int = 0;
pub const ESP_BLUFI_EVENT_DEINIT_FINISH: c_int = 1;
pub const ESP_BLUFI_EVENT_SET_WIFI_OPMODE: c_int = 2;
pub const ESP_BLUFI_EVENT_BLE_CONNECT: c_int = 3;
pub const ESP_BLUFI_EVENT_BLE_DISCONNECT: c_int = 4;
pub const ESP_BLUFI_EVENT_REQ_CONNECT_TO_AP: c_int = 5;
pub const ESP_BLUFI_EVENT_REQ_DISCONNECT_FROM_AP: c_int = 6;
pub const ESP_BLUFI_EVENT_GET_WIFI_STATUS: c_int = 7;
pub const ESP_BLUFI_EVENT_DEAUTHENTICATE_STA: c_int = 8;
pub const ESP_BLUFI_EVENT_RECV_STA_BSSID: c_int = 9;
pub const ESP_BLUFI_EVENT_RECV_STA_SSID: c_int = 10;
pub const ESP_BLUFI_EVENT_RECV_STA_PASSWD: c_int = 11;
pub const ESP_BLUFI_EVENT_RECV_SOFTAP_SSID: c_int = 12;
pub const ESP_BLUFI_EVENT_RECV_SOFTAP_PASSWD: c_int = 13;
pub const ESP_BLUFI_EVENT_RECV_SOFTAP_MAX_CONN_NUM: c_int = 14;
pub const ESP_BLUFI_EVENT_RECV_SOFTAP_AUTH_MODE: c_int = 15;
pub const ESP_BLUFI_EVENT_RECV_SOFTAP_CHANNEL: c_int = 16;
pub const ESP_BLUFI_EVENT_RECV_USERNAME: c_int = 17;
pub const ESP_BLUFI_EVENT_RECV_CA_CERT: c_int = 18;
pub const ESP_BLUFI_EVENT_RECV_CLIENT_CERT: c_int = 19;
pub const ESP_BLUFI_EVENT_RECV_SERVER_CERT: c_int = 20;
pub const ESP_BLUFI_EVENT_RECV_CLIENT_PRIV_KEY: c_int = 21;
pub const ESP_BLUFI_EVENT_RECV_SERVER_PRIV_KEY: c_int = 22;
pub const ESP_BLUFI_EVENT_RECV_SLAVE_DISCONNECT_BLE: c_int = 23;
pub const ESP_BLUFI_EVENT_GET_WIFI_LIST: c_int = 24;
pub const ESP_BLUFI_EVENT_REPORT_ERROR: c_int = 25;
pub const ESP_BLUFI_EVENT_RECV_CUSTOM_DATA: c_int = 26;
pub const esp_blufi_cb_event_t = c_uint;
pub const ESP_BLUFI_STA_CONN_SUCCESS: c_int = 0;
pub const ESP_BLUFI_STA_CONN_FAIL: c_int = 1;
pub const ESP_BLUFI_STA_CONNECTING: c_int = 2;
pub const ESP_BLUFI_STA_NO_IP: c_int = 3;
pub const esp_blufi_sta_conn_state_t = c_uint;
pub const ESP_BLUFI_INIT_OK: c_int = 0;
pub const ESP_BLUFI_INIT_FAILED: c_int = 1;
pub const esp_blufi_init_state_t = c_uint;
pub const ESP_BLUFI_DEINIT_OK: c_int = 0;
pub const ESP_BLUFI_DEINIT_FAILED: c_int = 1;
pub const esp_blufi_deinit_state_t = c_uint;
pub const ESP_BLUFI_SEQUENCE_ERROR: c_int = 0;
pub const ESP_BLUFI_CHECKSUM_ERROR: c_int = 1;
pub const ESP_BLUFI_DECRYPT_ERROR: c_int = 2;
pub const ESP_BLUFI_ENCRYPT_ERROR: c_int = 3;
pub const ESP_BLUFI_INIT_SECURITY_ERROR: c_int = 4;
pub const ESP_BLUFI_DH_MALLOC_ERROR: c_int = 5;
pub const ESP_BLUFI_DH_PARAM_ERROR: c_int = 6;
pub const ESP_BLUFI_READ_PARAM_ERROR: c_int = 7;
pub const ESP_BLUFI_MAKE_PUBLIC_ERROR: c_int = 8;
pub const ESP_BLUFI_DATA_FORMAT_ERROR: c_int = 9;
pub const ESP_BLUFI_CALC_MD5_ERROR: c_int = 10;
pub const ESP_BLUFI_WIFI_SCAN_FAIL: c_int = 11;
pub const ESP_BLUFI_MSG_STATE_ERROR: c_int = 12;
pub const esp_blufi_error_state_t = c_uint;
pub const esp_blufi_extra_info_t = extern struct {
    sta_bssid: [6]u8 = std.mem.zeroes([6]u8),
    sta_bssid_set: bool = std.mem.zeroes(bool),
    sta_ssid: [*c]u8 = std.mem.zeroes([*c]u8),
    sta_ssid_len: c_int = std.mem.zeroes(c_int),
    sta_passwd: [*c]u8 = std.mem.zeroes([*c]u8),
    sta_passwd_len: c_int = std.mem.zeroes(c_int),
    softap_ssid: [*c]u8 = std.mem.zeroes([*c]u8),
    softap_ssid_len: c_int = std.mem.zeroes(c_int),
    softap_passwd: [*c]u8 = std.mem.zeroes([*c]u8),
    softap_passwd_len: c_int = std.mem.zeroes(c_int),
    softap_authmode: u8 = std.mem.zeroes(u8),
    softap_authmode_set: bool = std.mem.zeroes(bool),
    softap_max_conn_num: u8 = std.mem.zeroes(u8),
    softap_max_conn_num_set: bool = std.mem.zeroes(bool),
    softap_channel: u8 = std.mem.zeroes(u8),
    softap_channel_set: bool = std.mem.zeroes(bool),
    sta_max_conn_retry: u8 = std.mem.zeroes(u8),
    sta_max_conn_retry_set: bool = std.mem.zeroes(bool),
    sta_conn_end_reason: u8 = std.mem.zeroes(u8),
    sta_conn_end_reason_set: bool = std.mem.zeroes(bool),
    sta_conn_rssi: i8 = std.mem.zeroes(i8),
    sta_conn_rssi_set: bool = std.mem.zeroes(bool),
};
pub const esp_blufi_ap_record_t = extern struct {
    ssid: [33]u8 = std.mem.zeroes([33]u8),
    rssi: i8 = std.mem.zeroes(i8),
};
pub const esp_blufi_bd_addr_t = [6]u8;
pub const blufi_init_finish_evt_param_20 = extern struct {
    state: esp_blufi_init_state_t = std.mem.zeroes(esp_blufi_init_state_t),
};
pub const blufi_deinit_finish_evt_param_21 = extern struct {
    state: esp_blufi_deinit_state_t = std.mem.zeroes(esp_blufi_deinit_state_t),
};
pub const blufi_set_wifi_mode_evt_param_22 = extern struct {
    op_mode: wifi_mode_t = std.mem.zeroes(wifi_mode_t),
};
pub const blufi_connect_evt_param_23 = extern struct {
    remote_bda: esp_blufi_bd_addr_t = std.mem.zeroes(esp_blufi_bd_addr_t),
    server_if: u8 = std.mem.zeroes(u8),
    conn_id: u16 = std.mem.zeroes(u16),
};
pub const blufi_disconnect_evt_param_24 = extern struct {
    remote_bda: esp_blufi_bd_addr_t = std.mem.zeroes(esp_blufi_bd_addr_t),
};
pub const blufi_recv_sta_bssid_evt_param_25 = extern struct {
    bssid: [6]u8 = std.mem.zeroes([6]u8),
};
pub const blufi_recv_sta_ssid_evt_param_26 = extern struct {
    ssid: [*c]u8 = std.mem.zeroes([*c]u8),
    ssid_len: c_int = std.mem.zeroes(c_int),
};
pub const blufi_recv_sta_passwd_evt_param_27 = extern struct {
    passwd: [*c]u8 = std.mem.zeroes([*c]u8),
    passwd_len: c_int = std.mem.zeroes(c_int),
};
pub const blufi_recv_softap_ssid_evt_param_28 = extern struct {
    ssid: [*c]u8 = std.mem.zeroes([*c]u8),
    ssid_len: c_int = std.mem.zeroes(c_int),
};
pub const blufi_recv_softap_passwd_evt_param_29 = extern struct {
    passwd: [*c]u8 = std.mem.zeroes([*c]u8),
    passwd_len: c_int = std.mem.zeroes(c_int),
};
pub const blufi_recv_softap_max_conn_num_evt_param_30 = extern struct {
    max_conn_num: c_int = std.mem.zeroes(c_int),
};
pub const blufi_recv_softap_auth_mode_evt_param_31 = extern struct {
    auth_mode: wifi_auth_mode_t = std.mem.zeroes(wifi_auth_mode_t),
};
pub const blufi_recv_softap_channel_evt_param_32 = extern struct {
    channel: u8 = std.mem.zeroes(u8),
};
pub const blufi_recv_username_evt_param_33 = extern struct {
    name: [*c]u8 = std.mem.zeroes([*c]u8),
    name_len: c_int = std.mem.zeroes(c_int),
};
pub const blufi_recv_ca_evt_param_34 = extern struct {
    cert: [*c]u8 = std.mem.zeroes([*c]u8),
    cert_len: c_int = std.mem.zeroes(c_int),
};
pub const blufi_recv_client_cert_evt_param_35 = extern struct {
    cert: [*c]u8 = std.mem.zeroes([*c]u8),
    cert_len: c_int = std.mem.zeroes(c_int),
};
pub const blufi_recv_server_cert_evt_param_36 = extern struct {
    cert: [*c]u8 = std.mem.zeroes([*c]u8),
    cert_len: c_int = std.mem.zeroes(c_int),
};
pub const blufi_recv_client_pkey_evt_param_37 = extern struct {
    pkey: [*c]u8 = std.mem.zeroes([*c]u8),
    pkey_len: c_int = std.mem.zeroes(c_int),
};
pub const blufi_recv_server_pkey_evt_param_38 = extern struct {
    pkey: [*c]u8 = std.mem.zeroes([*c]u8),
    pkey_len: c_int = std.mem.zeroes(c_int),
};
pub const blufi_get_error_evt_param_39 = extern struct {
    state: esp_blufi_error_state_t = std.mem.zeroes(esp_blufi_error_state_t),
};
pub const blufi_recv_custom_data_evt_param_40 = extern struct {
    data: [*c]u8 = std.mem.zeroes([*c]u8),
    data_len: u32 = std.mem.zeroes(u32),
};
pub const esp_blufi_cb_param_t = extern union {
    init_finish: blufi_init_finish_evt_param_20,
    deinit_finish: blufi_deinit_finish_evt_param_21,
    wifi_mode: blufi_set_wifi_mode_evt_param_22,
    connect: blufi_connect_evt_param_23,
    disconnect: blufi_disconnect_evt_param_24,
    sta_bssid: blufi_recv_sta_bssid_evt_param_25,
    sta_ssid: blufi_recv_sta_ssid_evt_param_26,
    sta_passwd: blufi_recv_sta_passwd_evt_param_27,
    softap_ssid: blufi_recv_softap_ssid_evt_param_28,
    softap_passwd: blufi_recv_softap_passwd_evt_param_29,
    softap_max_conn_num: blufi_recv_softap_max_conn_num_evt_param_30,
    softap_auth_mode: blufi_recv_softap_auth_mode_evt_param_31,
    softap_channel: blufi_recv_softap_channel_evt_param_32,
    username: blufi_recv_username_evt_param_33,
    ca: blufi_recv_ca_evt_param_34,
    client_cert: blufi_recv_client_cert_evt_param_35,
    server_cert: blufi_recv_server_cert_evt_param_36,
    client_pkey: blufi_recv_client_pkey_evt_param_37,
    server_pkey: blufi_recv_server_pkey_evt_param_38,
    report_error: blufi_get_error_evt_param_39,
    custom_data: blufi_recv_custom_data_evt_param_40,
};
pub const esp_blufi_event_cb_t = ?*const fn (esp_blufi_cb_event_t, [*c]esp_blufi_cb_param_t) callconv(.C) void;
pub const esp_blufi_negotiate_data_handler_t = ?*const fn ([*c]u8, c_int, [*c][*c]u8, [*c]c_int, [*c]bool) callconv(.C) void;
pub const esp_blufi_encrypt_func_t = ?*const fn (u8, [*c]u8, c_int) callconv(.C) c_int;
pub const esp_blufi_decrypt_func_t = ?*const fn (u8, [*c]u8, c_int) callconv(.C) c_int;
pub const esp_blufi_checksum_func_t = ?*const fn (u8, [*c]u8, c_int) callconv(.C) u16;
pub const esp_blufi_callbacks_t = extern struct {
    event_cb: esp_blufi_event_cb_t = std.mem.zeroes(esp_blufi_event_cb_t),
    negotiate_data_handler: esp_blufi_negotiate_data_handler_t = std.mem.zeroes(esp_blufi_negotiate_data_handler_t),
    encrypt_func: esp_blufi_encrypt_func_t = std.mem.zeroes(esp_blufi_encrypt_func_t),
    decrypt_func: esp_blufi_decrypt_func_t = std.mem.zeroes(esp_blufi_decrypt_func_t),
    checksum_func: esp_blufi_checksum_func_t = std.mem.zeroes(esp_blufi_checksum_func_t),
};
pub extern fn esp_blufi_register_callbacks(callbacks: [*c]esp_blufi_callbacks_t) esp_err_t;
pub extern fn esp_blufi_profile_init() esp_err_t;
pub extern fn esp_blufi_profile_deinit() esp_err_t;
pub extern fn esp_blufi_send_wifi_conn_report(opmode: wifi_mode_t, sta_conn_state: esp_blufi_sta_conn_state_t, softap_conn_num: u8, extra_info: [*c]esp_blufi_extra_info_t) esp_err_t;
pub extern fn esp_blufi_send_wifi_list(apCount: u16, list: [*c]esp_blufi_ap_record_t) esp_err_t;
pub extern fn esp_blufi_get_version() u16;
pub extern fn esp_blufi_send_error_info(state: esp_blufi_error_state_t) esp_err_t;
pub extern fn esp_blufi_send_custom_data(data: [*c]u8, data_len: u32) esp_err_t;
pub const esp_ble_key_type_t = u8;
pub const esp_ble_auth_req_t = u8;
pub const esp_ble_io_cap_t = u8;
pub const esp_ble_dtm_pkt_payload_t = u8;
pub const ESP_GAP_BLE_ADV_DATA_SET_COMPLETE_EVT: c_int = 0;
pub const ESP_GAP_BLE_SCAN_RSP_DATA_SET_COMPLETE_EVT: c_int = 1;
pub const ESP_GAP_BLE_SCAN_PARAM_SET_COMPLETE_EVT: c_int = 2;
pub const ESP_GAP_BLE_SCAN_RESULT_EVT: c_int = 3;
pub const ESP_GAP_BLE_ADV_DATA_RAW_SET_COMPLETE_EVT: c_int = 4;
pub const ESP_GAP_BLE_SCAN_RSP_DATA_RAW_SET_COMPLETE_EVT: c_int = 5;
pub const ESP_GAP_BLE_ADV_START_COMPLETE_EVT: c_int = 6;
pub const ESP_GAP_BLE_SCAN_START_COMPLETE_EVT: c_int = 7;
pub const ESP_GAP_BLE_AUTH_CMPL_EVT: c_int = 8;
pub const ESP_GAP_BLE_KEY_EVT: c_int = 9;
pub const ESP_GAP_BLE_SEC_REQ_EVT: c_int = 10;
pub const ESP_GAP_BLE_PASSKEY_NOTIF_EVT: c_int = 11;
pub const ESP_GAP_BLE_PASSKEY_REQ_EVT: c_int = 12;
pub const ESP_GAP_BLE_OOB_REQ_EVT: c_int = 13;
pub const ESP_GAP_BLE_LOCAL_IR_EVT: c_int = 14;
pub const ESP_GAP_BLE_LOCAL_ER_EVT: c_int = 15;
pub const ESP_GAP_BLE_NC_REQ_EVT: c_int = 16;
pub const ESP_GAP_BLE_ADV_STOP_COMPLETE_EVT: c_int = 17;
pub const ESP_GAP_BLE_SCAN_STOP_COMPLETE_EVT: c_int = 18;
pub const ESP_GAP_BLE_SET_STATIC_RAND_ADDR_EVT: c_int = 19;
pub const ESP_GAP_BLE_UPDATE_CONN_PARAMS_EVT: c_int = 20;
pub const ESP_GAP_BLE_SET_PKT_LENGTH_COMPLETE_EVT: c_int = 21;
pub const ESP_GAP_BLE_SET_LOCAL_PRIVACY_COMPLETE_EVT: c_int = 22;
pub const ESP_GAP_BLE_REMOVE_BOND_DEV_COMPLETE_EVT: c_int = 23;
pub const ESP_GAP_BLE_CLEAR_BOND_DEV_COMPLETE_EVT: c_int = 24;
pub const ESP_GAP_BLE_GET_BOND_DEV_COMPLETE_EVT: c_int = 25;
pub const ESP_GAP_BLE_READ_RSSI_COMPLETE_EVT: c_int = 26;
pub const ESP_GAP_BLE_UPDATE_WHITELIST_COMPLETE_EVT: c_int = 27;
pub const ESP_GAP_BLE_UPDATE_DUPLICATE_EXCEPTIONAL_LIST_COMPLETE_EVT: c_int = 28;
pub const ESP_GAP_BLE_SET_CHANNELS_EVT: c_int = 29;
pub const ESP_GAP_BLE_READ_PHY_COMPLETE_EVT: c_int = 30;
pub const ESP_GAP_BLE_SET_PREFERRED_DEFAULT_PHY_COMPLETE_EVT: c_int = 31;
pub const ESP_GAP_BLE_SET_PREFERRED_PHY_COMPLETE_EVT: c_int = 32;
pub const ESP_GAP_BLE_EXT_ADV_SET_RAND_ADDR_COMPLETE_EVT: c_int = 33;
pub const ESP_GAP_BLE_EXT_ADV_SET_PARAMS_COMPLETE_EVT: c_int = 34;
pub const ESP_GAP_BLE_EXT_ADV_DATA_SET_COMPLETE_EVT: c_int = 35;
pub const ESP_GAP_BLE_EXT_SCAN_RSP_DATA_SET_COMPLETE_EVT: c_int = 36;
pub const ESP_GAP_BLE_EXT_ADV_START_COMPLETE_EVT: c_int = 37;
pub const ESP_GAP_BLE_EXT_ADV_STOP_COMPLETE_EVT: c_int = 38;
pub const ESP_GAP_BLE_EXT_ADV_SET_REMOVE_COMPLETE_EVT: c_int = 39;
pub const ESP_GAP_BLE_EXT_ADV_SET_CLEAR_COMPLETE_EVT: c_int = 40;
pub const ESP_GAP_BLE_PERIODIC_ADV_SET_PARAMS_COMPLETE_EVT: c_int = 41;
pub const ESP_GAP_BLE_PERIODIC_ADV_DATA_SET_COMPLETE_EVT: c_int = 42;
pub const ESP_GAP_BLE_PERIODIC_ADV_START_COMPLETE_EVT: c_int = 43;
pub const ESP_GAP_BLE_PERIODIC_ADV_STOP_COMPLETE_EVT: c_int = 44;
pub const ESP_GAP_BLE_PERIODIC_ADV_CREATE_SYNC_COMPLETE_EVT: c_int = 45;
pub const ESP_GAP_BLE_PERIODIC_ADV_SYNC_CANCEL_COMPLETE_EVT: c_int = 46;
pub const ESP_GAP_BLE_PERIODIC_ADV_SYNC_TERMINATE_COMPLETE_EVT: c_int = 47;
pub const ESP_GAP_BLE_PERIODIC_ADV_ADD_DEV_COMPLETE_EVT: c_int = 48;
pub const ESP_GAP_BLE_PERIODIC_ADV_REMOVE_DEV_COMPLETE_EVT: c_int = 49;
pub const ESP_GAP_BLE_PERIODIC_ADV_CLEAR_DEV_COMPLETE_EVT: c_int = 50;
pub const ESP_GAP_BLE_SET_EXT_SCAN_PARAMS_COMPLETE_EVT: c_int = 51;
pub const ESP_GAP_BLE_EXT_SCAN_START_COMPLETE_EVT: c_int = 52;
pub const ESP_GAP_BLE_EXT_SCAN_STOP_COMPLETE_EVT: c_int = 53;
pub const ESP_GAP_BLE_PREFER_EXT_CONN_PARAMS_SET_COMPLETE_EVT: c_int = 54;
pub const ESP_GAP_BLE_PHY_UPDATE_COMPLETE_EVT: c_int = 55;
pub const ESP_GAP_BLE_EXT_ADV_REPORT_EVT: c_int = 56;
pub const ESP_GAP_BLE_SCAN_TIMEOUT_EVT: c_int = 57;
pub const ESP_GAP_BLE_ADV_TERMINATED_EVT: c_int = 58;
pub const ESP_GAP_BLE_SCAN_REQ_RECEIVED_EVT: c_int = 59;
pub const ESP_GAP_BLE_CHANNEL_SELECT_ALGORITHM_EVT: c_int = 60;
pub const ESP_GAP_BLE_PERIODIC_ADV_REPORT_EVT: c_int = 61;
pub const ESP_GAP_BLE_PERIODIC_ADV_SYNC_LOST_EVT: c_int = 62;
pub const ESP_GAP_BLE_PERIODIC_ADV_SYNC_ESTAB_EVT: c_int = 63;
pub const ESP_GAP_BLE_SC_OOB_REQ_EVT: c_int = 64;
pub const ESP_GAP_BLE_SC_CR_LOC_OOB_EVT: c_int = 65;
pub const ESP_GAP_BLE_GET_DEV_NAME_COMPLETE_EVT: c_int = 66;
pub const ESP_GAP_BLE_PERIODIC_ADV_RECV_ENABLE_COMPLETE_EVT: c_int = 67;
pub const ESP_GAP_BLE_PERIODIC_ADV_SYNC_TRANS_COMPLETE_EVT: c_int = 68;
pub const ESP_GAP_BLE_PERIODIC_ADV_SET_INFO_TRANS_COMPLETE_EVT: c_int = 69;
pub const ESP_GAP_BLE_SET_PAST_PARAMS_COMPLETE_EVT: c_int = 70;
pub const ESP_GAP_BLE_PERIODIC_ADV_SYNC_TRANS_RECV_EVT: c_int = 71;
pub const ESP_GAP_BLE_DTM_TEST_UPDATE_EVT: c_int = 72;
pub const ESP_GAP_BLE_ADV_CLEAR_COMPLETE_EVT: c_int = 73;
pub const ESP_GAP_BLE_EVT_MAX: c_int = 74;
pub const esp_gap_ble_cb_event_t = c_uint;
pub const esp_gap_ble_channels = [5]u8;
pub const ESP_BLE_AD_TYPE_FLAG: c_int = 1;
pub const ESP_BLE_AD_TYPE_16SRV_PART: c_int = 2;
pub const ESP_BLE_AD_TYPE_16SRV_CMPL: c_int = 3;
pub const ESP_BLE_AD_TYPE_32SRV_PART: c_int = 4;
pub const ESP_BLE_AD_TYPE_32SRV_CMPL: c_int = 5;
pub const ESP_BLE_AD_TYPE_128SRV_PART: c_int = 6;
pub const ESP_BLE_AD_TYPE_128SRV_CMPL: c_int = 7;
pub const ESP_BLE_AD_TYPE_NAME_SHORT: c_int = 8;
pub const ESP_BLE_AD_TYPE_NAME_CMPL: c_int = 9;
pub const ESP_BLE_AD_TYPE_TX_PWR: c_int = 10;
pub const ESP_BLE_AD_TYPE_DEV_CLASS: c_int = 13;
pub const ESP_BLE_AD_TYPE_SM_TK: c_int = 16;
pub const ESP_BLE_AD_TYPE_SM_OOB_FLAG: c_int = 17;
pub const ESP_BLE_AD_TYPE_INT_RANGE: c_int = 18;
pub const ESP_BLE_AD_TYPE_SOL_SRV_UUID: c_int = 20;
pub const ESP_BLE_AD_TYPE_128SOL_SRV_UUID: c_int = 21;
pub const ESP_BLE_AD_TYPE_SERVICE_DATA: c_int = 22;
pub const ESP_BLE_AD_TYPE_PUBLIC_TARGET: c_int = 23;
pub const ESP_BLE_AD_TYPE_RANDOM_TARGET: c_int = 24;
pub const ESP_BLE_AD_TYPE_APPEARANCE: c_int = 25;
pub const ESP_BLE_AD_TYPE_ADV_INT: c_int = 26;
pub const ESP_BLE_AD_TYPE_LE_DEV_ADDR: c_int = 27;
pub const ESP_BLE_AD_TYPE_LE_ROLE: c_int = 28;
pub const ESP_BLE_AD_TYPE_SPAIR_C256: c_int = 29;
pub const ESP_BLE_AD_TYPE_SPAIR_R256: c_int = 30;
pub const ESP_BLE_AD_TYPE_32SOL_SRV_UUID: c_int = 31;
pub const ESP_BLE_AD_TYPE_32SERVICE_DATA: c_int = 32;
pub const ESP_BLE_AD_TYPE_128SERVICE_DATA: c_int = 33;
pub const ESP_BLE_AD_TYPE_LE_SECURE_CONFIRM: c_int = 34;
pub const ESP_BLE_AD_TYPE_LE_SECURE_RANDOM: c_int = 35;
pub const ESP_BLE_AD_TYPE_URI: c_int = 36;
pub const ESP_BLE_AD_TYPE_INDOOR_POSITION: c_int = 37;
pub const ESP_BLE_AD_TYPE_TRANS_DISC_DATA: c_int = 38;
pub const ESP_BLE_AD_TYPE_LE_SUPPORT_FEATURE: c_int = 39;
pub const ESP_BLE_AD_TYPE_CHAN_MAP_UPDATE: c_int = 40;
pub const ESP_BLE_AD_MANUFACTURER_SPECIFIC_TYPE: c_int = 255;
pub const esp_ble_adv_data_type = c_uint;
pub const ADV_TYPE_IND: c_int = 0;
pub const ADV_TYPE_DIRECT_IND_HIGH: c_int = 1;
pub const ADV_TYPE_SCAN_IND: c_int = 2;
pub const ADV_TYPE_NONCONN_IND: c_int = 3;
pub const ADV_TYPE_DIRECT_IND_LOW: c_int = 4;
pub const esp_ble_adv_type_t = c_uint;
pub const ADV_CHNL_37: c_int = 1;
pub const ADV_CHNL_38: c_int = 2;
pub const ADV_CHNL_39: c_int = 4;
pub const ADV_CHNL_ALL: c_int = 7;
pub const esp_ble_adv_channel_t = c_uint;
pub const ADV_FILTER_ALLOW_SCAN_ANY_CON_ANY: c_int = 0;
pub const ADV_FILTER_ALLOW_SCAN_WLST_CON_ANY: c_int = 1;
pub const ADV_FILTER_ALLOW_SCAN_ANY_CON_WLST: c_int = 2;
pub const ADV_FILTER_ALLOW_SCAN_WLST_CON_WLST: c_int = 3;
pub const esp_ble_adv_filter_t = c_uint;
pub const ESP_BLE_SEC_ENCRYPT: c_int = 1;
pub const ESP_BLE_SEC_ENCRYPT_NO_MITM: c_int = 2;
pub const ESP_BLE_SEC_ENCRYPT_MITM: c_int = 3;
pub const esp_ble_sec_act_t = c_uint;
pub const ESP_BLE_SM_PASSKEY: c_int = 0;
pub const ESP_BLE_SM_AUTHEN_REQ_MODE: c_int = 1;
pub const ESP_BLE_SM_IOCAP_MODE: c_int = 2;
pub const ESP_BLE_SM_SET_INIT_KEY: c_int = 3;
pub const ESP_BLE_SM_SET_RSP_KEY: c_int = 4;
pub const ESP_BLE_SM_MAX_KEY_SIZE: c_int = 5;
pub const ESP_BLE_SM_MIN_KEY_SIZE: c_int = 6;
pub const ESP_BLE_SM_SET_STATIC_PASSKEY: c_int = 7;
pub const ESP_BLE_SM_CLEAR_STATIC_PASSKEY: c_int = 8;
pub const ESP_BLE_SM_ONLY_ACCEPT_SPECIFIED_SEC_AUTH: c_int = 9;
pub const ESP_BLE_SM_OOB_SUPPORT: c_int = 10;
pub const ESP_BLE_APP_ENC_KEY_SIZE: c_int = 11;
pub const ESP_BLE_SM_MAX_PARAM: c_int = 12;
pub const esp_ble_sm_param_t = c_uint;
pub const DTM_TX_START_EVT: c_int = 0;
pub const DTM_RX_START_EVT: c_int = 1;
pub const DTM_TEST_STOP_EVT: c_int = 2;
pub const esp_ble_dtm_update_evt_t = c_uint;
pub const esp_ble_dtm_tx_t = extern struct {
    tx_channel: u8 = std.mem.zeroes(u8),
    len_of_data: u8 = std.mem.zeroes(u8),
    pkt_payload: esp_ble_dtm_pkt_payload_t = std.mem.zeroes(esp_ble_dtm_pkt_payload_t),
};
pub const esp_ble_dtm_rx_t = extern struct {
    rx_channel: u8 = std.mem.zeroes(u8),
};
pub const esp_ble_adv_params_t = extern struct {
    adv_int_min: u16 = std.mem.zeroes(u16),
    adv_int_max: u16 = std.mem.zeroes(u16),
    adv_type: esp_ble_adv_type_t = std.mem.zeroes(esp_ble_adv_type_t),
    own_addr_type: esp_ble_addr_type_t = std.mem.zeroes(esp_ble_addr_type_t),
    peer_addr: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
    peer_addr_type: esp_ble_addr_type_t = std.mem.zeroes(esp_ble_addr_type_t),
    channel_map: esp_ble_adv_channel_t = std.mem.zeroes(esp_ble_adv_channel_t),
    adv_filter_policy: esp_ble_adv_filter_t = std.mem.zeroes(esp_ble_adv_filter_t),
};
pub const esp_ble_adv_data_t = extern struct {
    set_scan_rsp: bool = std.mem.zeroes(bool),
    include_name: bool = std.mem.zeroes(bool),
    include_txpower: bool = std.mem.zeroes(bool),
    min_interval: c_int = std.mem.zeroes(c_int),
    max_interval: c_int = std.mem.zeroes(c_int),
    appearance: c_int = std.mem.zeroes(c_int),
    manufacturer_len: u16 = std.mem.zeroes(u16),
    p_manufacturer_data: [*c]u8 = std.mem.zeroes([*c]u8),
    service_data_len: u16 = std.mem.zeroes(u16),
    p_service_data: [*c]u8 = std.mem.zeroes([*c]u8),
    service_uuid_len: u16 = std.mem.zeroes(u16),
    p_service_uuid: [*c]u8 = std.mem.zeroes([*c]u8),
    flag: u8 = std.mem.zeroes(u8),
};
pub const BLE_SCAN_TYPE_PASSIVE: c_int = 0;
pub const BLE_SCAN_TYPE_ACTIVE: c_int = 1;
pub const esp_ble_scan_type_t = c_uint;
pub const BLE_SCAN_FILTER_ALLOW_ALL: c_int = 0;
pub const BLE_SCAN_FILTER_ALLOW_ONLY_WLST: c_int = 1;
pub const BLE_SCAN_FILTER_ALLOW_UND_RPA_DIR: c_int = 2;
pub const BLE_SCAN_FILTER_ALLOW_WLIST_RPA_DIR: c_int = 3;
pub const esp_ble_scan_filter_t = c_uint;
pub const BLE_SCAN_DUPLICATE_DISABLE: c_int = 0;
pub const BLE_SCAN_DUPLICATE_ENABLE: c_int = 1;
pub const BLE_SCAN_DUPLICATE_ENABLE_RESET: c_int = 2;
pub const BLE_SCAN_DUPLICATE_MAX: c_int = 3;
pub const esp_ble_scan_duplicate_t = c_uint;
pub const esp_ble_scan_params_t = extern struct {
    scan_type: esp_ble_scan_type_t = std.mem.zeroes(esp_ble_scan_type_t),
    own_addr_type: esp_ble_addr_type_t = std.mem.zeroes(esp_ble_addr_type_t),
    scan_filter_policy: esp_ble_scan_filter_t = std.mem.zeroes(esp_ble_scan_filter_t),
    scan_interval: u16 = std.mem.zeroes(u16),
    scan_window: u16 = std.mem.zeroes(u16),
    scan_duplicate: esp_ble_scan_duplicate_t = std.mem.zeroes(esp_ble_scan_duplicate_t),
};
pub const esp_gap_conn_params_t = extern struct {
    interval: u16 = std.mem.zeroes(u16),
    latency: u16 = std.mem.zeroes(u16),
    timeout: u16 = std.mem.zeroes(u16),
};
pub const esp_ble_conn_update_params_t = extern struct {
    bda: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
    min_int: u16 = std.mem.zeroes(u16),
    max_int: u16 = std.mem.zeroes(u16),
    latency: u16 = std.mem.zeroes(u16),
    timeout: u16 = std.mem.zeroes(u16),
};
pub const esp_ble_pkt_data_length_params_t = extern struct {
    rx_len: u16 = std.mem.zeroes(u16),
    tx_len: u16 = std.mem.zeroes(u16),
};
pub const esp_ble_penc_keys_t = extern struct {
    ltk: esp_bt_octet16_t = std.mem.zeroes(esp_bt_octet16_t),
    rand: esp_bt_octet8_t = std.mem.zeroes(esp_bt_octet8_t),
    ediv: u16 = std.mem.zeroes(u16),
    sec_level: u8 = std.mem.zeroes(u8),
    key_size: u8 = std.mem.zeroes(u8),
};
pub const esp_ble_pcsrk_keys_t = extern struct {
    counter: u32 = std.mem.zeroes(u32),
    csrk: esp_bt_octet16_t = std.mem.zeroes(esp_bt_octet16_t),
    sec_level: u8 = std.mem.zeroes(u8),
};
pub const esp_ble_pid_keys_t = extern struct {
    irk: esp_bt_octet16_t = std.mem.zeroes(esp_bt_octet16_t),
    addr_type: esp_ble_addr_type_t = std.mem.zeroes(esp_ble_addr_type_t),
    static_addr: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
};
pub const esp_ble_lenc_keys_t = extern struct {
    ltk: esp_bt_octet16_t = std.mem.zeroes(esp_bt_octet16_t),
    div: u16 = std.mem.zeroes(u16),
    key_size: u8 = std.mem.zeroes(u8),
    sec_level: u8 = std.mem.zeroes(u8),
};
pub const esp_ble_lcsrk_keys = extern struct {
    counter: u32 = std.mem.zeroes(u32),
    div: u16 = std.mem.zeroes(u16),
    sec_level: u8 = std.mem.zeroes(u8),
    csrk: esp_bt_octet16_t = std.mem.zeroes(esp_bt_octet16_t),
};
pub const esp_ble_sec_key_notif_t = extern struct {
    bd_addr: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
    passkey: u32 = std.mem.zeroes(u32),
};
pub const esp_ble_sec_req_t = extern struct {
    bd_addr: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
};
pub const esp_ble_key_value_t = extern union {
    penc_key: esp_ble_penc_keys_t,
    pcsrk_key: esp_ble_pcsrk_keys_t,
    pid_key: esp_ble_pid_keys_t,
    lenc_key: esp_ble_lenc_keys_t,
    lcsrk_key: esp_ble_lcsrk_keys,
};
pub const esp_ble_bond_key_info_t = extern struct {
    key_mask: esp_ble_key_mask_t = std.mem.zeroes(esp_ble_key_mask_t),
    penc_key: esp_ble_penc_keys_t = std.mem.zeroes(esp_ble_penc_keys_t),
    pcsrk_key: esp_ble_pcsrk_keys_t = std.mem.zeroes(esp_ble_pcsrk_keys_t),
    pid_key: esp_ble_pid_keys_t = std.mem.zeroes(esp_ble_pid_keys_t),
};
pub const esp_ble_bond_dev_t = extern struct {
    bd_addr: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
    bond_key: esp_ble_bond_key_info_t = std.mem.zeroes(esp_ble_bond_key_info_t),
};
pub const esp_ble_key_t = extern struct {
    bd_addr: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
    key_type: esp_ble_key_type_t = std.mem.zeroes(esp_ble_key_type_t),
    p_key_value: esp_ble_key_value_t = std.mem.zeroes(esp_ble_key_value_t),
};
pub const esp_ble_local_id_keys_t = extern struct {
    ir: esp_bt_octet16_t = std.mem.zeroes(esp_bt_octet16_t),
    irk: esp_bt_octet16_t = std.mem.zeroes(esp_bt_octet16_t),
    dhk: esp_bt_octet16_t = std.mem.zeroes(esp_bt_octet16_t),
};
pub const esp_ble_local_oob_data_t = extern struct {
    oob_c: esp_bt_octet16_t = std.mem.zeroes(esp_bt_octet16_t),
    oob_r: esp_bt_octet16_t = std.mem.zeroes(esp_bt_octet16_t),
};
pub const esp_ble_auth_cmpl_t = extern struct {
    bd_addr: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
    key_present: bool = std.mem.zeroes(bool),
    key: esp_link_key = std.mem.zeroes(esp_link_key),
    key_type: u8 = std.mem.zeroes(u8),
    success: bool = std.mem.zeroes(bool),
    fail_reason: u8 = std.mem.zeroes(u8),
    addr_type: esp_ble_addr_type_t = std.mem.zeroes(esp_ble_addr_type_t),
    dev_type: esp_bt_dev_type_t = std.mem.zeroes(esp_bt_dev_type_t),
    auth_mode: esp_ble_auth_req_t = std.mem.zeroes(esp_ble_auth_req_t),
};
pub const esp_ble_sec_t = extern union {
    key_notif: esp_ble_sec_key_notif_t,
    ble_req: esp_ble_sec_req_t,
    ble_key: esp_ble_key_t,
    ble_id_keys: esp_ble_local_id_keys_t,
    oob_data: esp_ble_local_oob_data_t,
    auth_cmpl: esp_ble_auth_cmpl_t,
};
pub const ESP_GAP_SEARCH_INQ_RES_EVT: c_int = 0;
pub const ESP_GAP_SEARCH_INQ_CMPL_EVT: c_int = 1;
pub const ESP_GAP_SEARCH_DISC_RES_EVT: c_int = 2;
pub const ESP_GAP_SEARCH_DISC_BLE_RES_EVT: c_int = 3;
pub const ESP_GAP_SEARCH_DISC_CMPL_EVT: c_int = 4;
pub const ESP_GAP_SEARCH_DI_DISC_CMPL_EVT: c_int = 5;
pub const ESP_GAP_SEARCH_SEARCH_CANCEL_CMPL_EVT: c_int = 6;
pub const ESP_GAP_SEARCH_INQ_DISCARD_NUM_EVT: c_int = 7;
pub const esp_gap_search_evt_t = c_uint;
pub const ESP_BLE_EVT_CONN_ADV: c_int = 0;
pub const ESP_BLE_EVT_CONN_DIR_ADV: c_int = 1;
pub const ESP_BLE_EVT_DISC_ADV: c_int = 2;
pub const ESP_BLE_EVT_NON_CONN_ADV: c_int = 3;
pub const ESP_BLE_EVT_SCAN_RSP: c_int = 4;
pub const esp_ble_evt_type_t = c_uint;
pub const ESP_BLE_WHITELIST_REMOVE: c_int = 0;
pub const ESP_BLE_WHITELIST_ADD: c_int = 1;
pub const ESP_BLE_WHITELIST_CLEAR: c_int = 2;
pub const esp_ble_wl_operation_t = c_uint;
pub const ESP_BLE_DUPLICATE_EXCEPTIONAL_LIST_ADD: c_int = 0;
pub const ESP_BLE_DUPLICATE_EXCEPTIONAL_LIST_REMOVE: c_int = 1;
pub const ESP_BLE_DUPLICATE_EXCEPTIONAL_LIST_CLEAN: c_int = 2;
pub const esp_bt_duplicate_exceptional_subcode_type_t = c_uint;
pub const ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_INFO_ADV_ADDR: c_int = 0;
pub const ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_INFO_MESH_LINK_ID: c_int = 1;
pub const ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_INFO_MESH_BEACON_TYPE: c_int = 2;
pub const ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_INFO_MESH_PROV_SRV_ADV: c_int = 3;
pub const ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_INFO_MESH_PROXY_SRV_ADV: c_int = 4;
pub const ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_INFO_MESH_PROXY_SOLIC_ADV: c_int = 5;
pub const ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_INFO_MESH_URI_ADV: c_int = 6;
pub const esp_ble_duplicate_exceptional_info_type_t = c_uint;
pub const ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_ADDR_LIST: c_int = 1;
pub const ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_MESH_LINK_ID_LIST: c_int = 2;
pub const ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_MESH_BEACON_TYPE_LIST: c_int = 4;
pub const ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_MESH_PROV_SRV_ADV_LIST: c_int = 8;
pub const ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_MESH_PROXY_SRV_ADV_LIST: c_int = 16;
pub const ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_MESH_PROXY_SOLIC_ADV_LIST: c_int = 32;
pub const ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_MESH_URI_ADV_LIST: c_int = 64;
pub const ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_ALL_LIST: c_int = 65535;
pub const esp_duplicate_scan_exceptional_list_type_t = c_uint;
pub const esp_duplicate_info_t = [6]u8;
pub const esp_ble_ext_adv_type_mask_t = u16;
pub const esp_ble_gap_phy_t = u8;
pub const esp_ble_gap_all_phys_t = u8;
pub const esp_ble_gap_pri_phy_t = u8;
pub const esp_ble_gap_phy_mask_t = u8;
pub const esp_ble_gap_prefer_phy_options_t = u16;
pub const esp_ble_ext_scan_cfg_mask_t = u8;
pub const esp_ble_gap_ext_adv_data_status_t = u8;
pub const esp_ble_gap_sync_t = u8;
pub const esp_ble_gap_adv_type_t = u8;
pub const esp_ble_gap_ext_adv_params_t = extern struct {
    type: esp_ble_ext_adv_type_mask_t = std.mem.zeroes(esp_ble_ext_adv_type_mask_t),
    interval_min: u32 = std.mem.zeroes(u32),
    interval_max: u32 = std.mem.zeroes(u32),
    channel_map: esp_ble_adv_channel_t = std.mem.zeroes(esp_ble_adv_channel_t),
    own_addr_type: esp_ble_addr_type_t = std.mem.zeroes(esp_ble_addr_type_t),
    peer_addr_type: esp_ble_addr_type_t = std.mem.zeroes(esp_ble_addr_type_t),
    peer_addr: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
    filter_policy: esp_ble_adv_filter_t = std.mem.zeroes(esp_ble_adv_filter_t),
    tx_power: i8 = std.mem.zeroes(i8),
    primary_phy: esp_ble_gap_pri_phy_t = std.mem.zeroes(esp_ble_gap_pri_phy_t),
    max_skip: u8 = std.mem.zeroes(u8),
    secondary_phy: esp_ble_gap_phy_t = std.mem.zeroes(esp_ble_gap_phy_t),
    sid: u8 = std.mem.zeroes(u8),
    scan_req_notif: bool = std.mem.zeroes(bool),
};
pub const esp_ble_ext_scan_cfg_t = extern struct {
    scan_type: esp_ble_scan_type_t = std.mem.zeroes(esp_ble_scan_type_t),
    scan_interval: u16 = std.mem.zeroes(u16),
    scan_window: u16 = std.mem.zeroes(u16),
};
pub const esp_ble_ext_scan_params_t = extern struct {
    own_addr_type: esp_ble_addr_type_t = std.mem.zeroes(esp_ble_addr_type_t),
    filter_policy: esp_ble_scan_filter_t = std.mem.zeroes(esp_ble_scan_filter_t),
    scan_duplicate: esp_ble_scan_duplicate_t = std.mem.zeroes(esp_ble_scan_duplicate_t),
    cfg_mask: esp_ble_ext_scan_cfg_mask_t = std.mem.zeroes(esp_ble_ext_scan_cfg_mask_t),
    uncoded_cfg: esp_ble_ext_scan_cfg_t = std.mem.zeroes(esp_ble_ext_scan_cfg_t),
    coded_cfg: esp_ble_ext_scan_cfg_t = std.mem.zeroes(esp_ble_ext_scan_cfg_t),
};
pub const esp_ble_gap_conn_params_t = extern struct {
    scan_interval: u16 = std.mem.zeroes(u16),
    scan_window: u16 = std.mem.zeroes(u16),
    interval_min: u16 = std.mem.zeroes(u16),
    interval_max: u16 = std.mem.zeroes(u16),
    latency: u16 = std.mem.zeroes(u16),
    supervision_timeout: u16 = std.mem.zeroes(u16),
    min_ce_len: u16 = std.mem.zeroes(u16),
    max_ce_len: u16 = std.mem.zeroes(u16),
};
pub const esp_ble_gap_ext_adv_t = extern struct {
    instance: u8 = std.mem.zeroes(u8),
    duration: c_int = std.mem.zeroes(c_int),
    max_events: c_int = std.mem.zeroes(c_int),
};
pub const esp_ble_gap_periodic_adv_params_t = extern struct {
    interval_min: u16 = std.mem.zeroes(u16),
    interval_max: u16 = std.mem.zeroes(u16),
    properties: u8 = std.mem.zeroes(u8),
};
pub const esp_ble_gap_periodic_adv_sync_params_t = extern struct {
    filter_policy: esp_ble_gap_sync_t = std.mem.zeroes(esp_ble_gap_sync_t),
    sid: u8 = std.mem.zeroes(u8),
    addr_type: esp_ble_addr_type_t = std.mem.zeroes(esp_ble_addr_type_t),
    addr: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
    skip: u16 = std.mem.zeroes(u16),
    sync_timeout: u16 = std.mem.zeroes(u16),
};
pub const esp_ble_gap_ext_adv_reprot_t = extern struct {
    event_type: esp_ble_gap_adv_type_t = std.mem.zeroes(esp_ble_gap_adv_type_t),
    addr_type: u8 = std.mem.zeroes(u8),
    addr: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
    primary_phy: esp_ble_gap_pri_phy_t = std.mem.zeroes(esp_ble_gap_pri_phy_t),
    secondly_phy: esp_ble_gap_phy_t = std.mem.zeroes(esp_ble_gap_phy_t),
    sid: u8 = std.mem.zeroes(u8),
    tx_power: u8 = std.mem.zeroes(u8),
    rssi: i8 = std.mem.zeroes(i8),
    per_adv_interval: u16 = std.mem.zeroes(u16),
    dir_addr_type: u8 = std.mem.zeroes(u8),
    dir_addr: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
    data_status: esp_ble_gap_ext_adv_data_status_t = std.mem.zeroes(esp_ble_gap_ext_adv_data_status_t),
    adv_data_len: u8 = std.mem.zeroes(u8),
    adv_data: [251]u8 = std.mem.zeroes([251]u8),
};
pub const esp_ble_gap_periodic_adv_report_t = extern struct {
    sync_handle: u16 = std.mem.zeroes(u16),
    tx_power: u8 = std.mem.zeroes(u8),
    rssi: i8 = std.mem.zeroes(i8),
    data_status: esp_ble_gap_ext_adv_data_status_t = std.mem.zeroes(esp_ble_gap_ext_adv_data_status_t),
    data_length: u8 = std.mem.zeroes(u8),
    data: [251]u8 = std.mem.zeroes([251]u8),
};
pub const esp_ble_gap_periodic_adv_sync_estab_t = extern struct {
    status: u8 = std.mem.zeroes(u8),
    sync_handle: u16 = std.mem.zeroes(u16),
    sid: u8 = std.mem.zeroes(u8),
    addr_type: esp_ble_addr_type_t = std.mem.zeroes(esp_ble_addr_type_t),
    adv_addr: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
    adv_phy: esp_ble_gap_phy_t = std.mem.zeroes(esp_ble_gap_phy_t),
    period_adv_interval: u16 = std.mem.zeroes(u16),
    adv_clk_accuracy: u8 = std.mem.zeroes(u8),
};
pub const esp_ble_dtm_enh_tx_t = extern struct {
    tx_channel: u8 = std.mem.zeroes(u8),
    len_of_data: u8 = std.mem.zeroes(u8),
    pkt_payload: esp_ble_dtm_pkt_payload_t = std.mem.zeroes(esp_ble_dtm_pkt_payload_t),
    phy: esp_ble_gap_phy_t = std.mem.zeroes(esp_ble_gap_phy_t),
};
pub const esp_ble_dtm_enh_rx_t = extern struct {
    rx_channel: u8 = std.mem.zeroes(u8),
    phy: esp_ble_gap_phy_t = std.mem.zeroes(esp_ble_gap_phy_t),
    modulation_idx: u8 = std.mem.zeroes(u8),
};
pub const esp_ble_gap_past_mode_t = u8;
pub const esp_ble_gap_past_params_t = extern struct {
    mode: esp_ble_gap_past_mode_t = std.mem.zeroes(esp_ble_gap_past_mode_t),
    skip: u16 = std.mem.zeroes(u16),
    sync_timeout: u16 = std.mem.zeroes(u16),
    cte_type: u8 = std.mem.zeroes(u8),
};
pub const ble_get_dev_name_cmpl_evt_param_41 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
    name: [*c]u8 = std.mem.zeroes([*c]u8),
};
pub const ble_adv_data_cmpl_evt_param_42 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_scan_rsp_data_cmpl_evt_param_43 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_scan_param_cmpl_evt_param_44 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_scan_result_evt_param_45 = extern struct {
    search_evt: esp_gap_search_evt_t = std.mem.zeroes(esp_gap_search_evt_t),
    bda: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
    dev_type: esp_bt_dev_type_t = std.mem.zeroes(esp_bt_dev_type_t),
    ble_addr_type: esp_ble_addr_type_t = std.mem.zeroes(esp_ble_addr_type_t),
    ble_evt_type: esp_ble_evt_type_t = std.mem.zeroes(esp_ble_evt_type_t),
    rssi: c_int = std.mem.zeroes(c_int),
    ble_adv: [62]u8 = std.mem.zeroes([62]u8),
    flag: c_int = std.mem.zeroes(c_int),
    num_resps: c_int = std.mem.zeroes(c_int),
    adv_data_len: u8 = std.mem.zeroes(u8),
    scan_rsp_len: u8 = std.mem.zeroes(u8),
    num_dis: u32 = std.mem.zeroes(u32),
};
pub const ble_adv_data_raw_cmpl_evt_param_46 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_scan_rsp_data_raw_cmpl_evt_param_47 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_adv_start_cmpl_evt_param_48 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_scan_start_cmpl_evt_param_49 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_scan_stop_cmpl_evt_param_50 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_adv_stop_cmpl_evt_param_51 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_adv_clear_cmpl_evt_param_52 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_set_rand_cmpl_evt_param_53 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_update_conn_params_evt_param_54 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
    bda: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
    min_int: u16 = std.mem.zeroes(u16),
    max_int: u16 = std.mem.zeroes(u16),
    latency: u16 = std.mem.zeroes(u16),
    conn_int: u16 = std.mem.zeroes(u16),
    timeout: u16 = std.mem.zeroes(u16),
};
pub const ble_pkt_data_length_cmpl_evt_param_55 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
    params: esp_ble_pkt_data_length_params_t = std.mem.zeroes(esp_ble_pkt_data_length_params_t),
};
pub const ble_local_privacy_cmpl_evt_param_56 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_remove_bond_dev_cmpl_evt_param_57 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
    bd_addr: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
};
pub const ble_clear_bond_dev_cmpl_evt_param_58 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_get_bond_dev_cmpl_evt_param_59 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
    dev_num: u8 = std.mem.zeroes(u8),
    bond_dev: [*c]esp_ble_bond_dev_t = std.mem.zeroes([*c]esp_ble_bond_dev_t),
};
pub const ble_read_rssi_cmpl_evt_param_60 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
    rssi: i8 = std.mem.zeroes(i8),
    remote_addr: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
};
pub const ble_update_whitelist_cmpl_evt_param_61 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
    wl_operation: esp_ble_wl_operation_t = std.mem.zeroes(esp_ble_wl_operation_t),
};
pub const ble_update_duplicate_exceptional_list_cmpl_evt_param_62 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
    subcode: u8 = std.mem.zeroes(u8),
    length: u16 = std.mem.zeroes(u16),
    device_info: esp_duplicate_info_t = std.mem.zeroes(esp_duplicate_info_t),
};
pub const ble_set_channels_evt_param_63 = extern struct {
    stat: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_read_phy_cmpl_evt_param_64 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
    bda: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
    tx_phy: esp_ble_gap_phy_t = std.mem.zeroes(esp_ble_gap_phy_t),
    rx_phy: esp_ble_gap_phy_t = std.mem.zeroes(esp_ble_gap_phy_t),
};
pub const ble_set_perf_def_phy_cmpl_evt_param_65 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_set_perf_phy_cmpl_evt_param_66 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_ext_adv_set_rand_addr_cmpl_evt_param_67 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_ext_adv_set_params_cmpl_evt_param_68 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_ext_adv_data_set_cmpl_evt_param_69 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_ext_adv_scan_rsp_set_cmpl_evt_param_70 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_ext_adv_start_cmpl_evt_param_71 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_ext_adv_stop_cmpl_evt_param_72 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_ext_adv_set_remove_cmpl_evt_param_73 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_ext_adv_set_clear_cmpl_evt_param_74 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_periodic_adv_set_params_cmpl_param_75 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_periodic_adv_data_set_cmpl_param_76 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_periodic_adv_start_cmpl_param_77 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_periodic_adv_stop_cmpl_param_78 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_period_adv_create_sync_cmpl_param_79 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_period_adv_sync_cancel_cmpl_param_80 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_period_adv_sync_terminate_cmpl_param_81 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_period_adv_add_dev_cmpl_param_82 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_period_adv_remove_dev_cmpl_param_83 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_period_adv_clear_dev_cmpl_param_84 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_set_ext_scan_params_cmpl_param_85 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_ext_scan_start_cmpl_param_86 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_ext_scan_stop_cmpl_param_87 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_ext_conn_params_set_cmpl_param_88 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_adv_terminate_param_89 = extern struct {
    status: u8 = std.mem.zeroes(u8),
    adv_instance: u8 = std.mem.zeroes(u8),
    conn_idx: u16 = std.mem.zeroes(u16),
    completed_event: u8 = std.mem.zeroes(u8),
};
pub const ble_scan_req_received_param_90 = extern struct {
    adv_instance: u8 = std.mem.zeroes(u8),
    scan_addr_type: esp_ble_addr_type_t = std.mem.zeroes(esp_ble_addr_type_t),
    scan_addr: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
};
pub const ble_channel_sel_alg_param_91 = extern struct {
    conn_handle: u16 = std.mem.zeroes(u16),
    channel_sel_alg: u8 = std.mem.zeroes(u8),
};
pub const ble_periodic_adv_sync_lost_param_92 = extern struct {
    sync_handle: u16 = std.mem.zeroes(u16),
};
pub const ble_periodic_adv_sync_estab_param_93 = extern struct {
    status: u8 = std.mem.zeroes(u8),
    sync_handle: u16 = std.mem.zeroes(u16),
    sid: u8 = std.mem.zeroes(u8),
    adv_addr_type: esp_ble_addr_type_t = std.mem.zeroes(esp_ble_addr_type_t),
    adv_addr: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
    adv_phy: esp_ble_gap_phy_t = std.mem.zeroes(esp_ble_gap_phy_t),
    period_adv_interval: u16 = std.mem.zeroes(u16),
    adv_clk_accuracy: u8 = std.mem.zeroes(u8),
};
pub const ble_phy_update_cmpl_param_94 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
    bda: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
    tx_phy: esp_ble_gap_phy_t = std.mem.zeroes(esp_ble_gap_phy_t),
    rx_phy: esp_ble_gap_phy_t = std.mem.zeroes(esp_ble_gap_phy_t),
};
pub const ble_ext_adv_report_param_95 = extern struct {
    params: esp_ble_gap_ext_adv_reprot_t = std.mem.zeroes(esp_ble_gap_ext_adv_reprot_t),
};
pub const ble_periodic_adv_report_param_96 = extern struct {
    params: esp_ble_gap_periodic_adv_report_t = std.mem.zeroes(esp_ble_gap_periodic_adv_report_t),
};
pub const ble_periodic_adv_recv_enable_cmpl_param_97 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
};
pub const ble_periodic_adv_sync_trans_cmpl_param_98 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
    bda: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
};
pub const ble_periodic_adv_set_info_trans_cmpl_param_99 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
    bda: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
};
pub const ble_set_past_params_cmpl_param_100 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
    bda: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
};
pub const ble_periodic_adv_sync_trans_recv_param_101 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
    bda: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
    service_data: u16 = std.mem.zeroes(u16),
    sync_handle: u16 = std.mem.zeroes(u16),
    adv_sid: u8 = std.mem.zeroes(u8),
    adv_addr_type: u8 = std.mem.zeroes(u8),
    adv_addr: esp_bd_addr_t = std.mem.zeroes(esp_bd_addr_t),
    adv_phy: esp_ble_gap_phy_t = std.mem.zeroes(esp_ble_gap_phy_t),
    adv_interval: u16 = std.mem.zeroes(u16),
    adv_clk_accuracy: u8 = std.mem.zeroes(u8),
};
pub const ble_dtm_state_update_evt_param_102 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
    update_evt: esp_ble_dtm_update_evt_t = std.mem.zeroes(esp_ble_dtm_update_evt_t),
    num_of_pkt: u16 = std.mem.zeroes(u16),
};
pub const esp_ble_gap_cb_param_t = extern union {
    get_dev_name_cmpl: ble_get_dev_name_cmpl_evt_param_41,
    adv_data_cmpl: ble_adv_data_cmpl_evt_param_42,
    scan_rsp_data_cmpl: ble_scan_rsp_data_cmpl_evt_param_43,
    scan_param_cmpl: ble_scan_param_cmpl_evt_param_44,
    scan_rst: ble_scan_result_evt_param_45,
    adv_data_raw_cmpl: ble_adv_data_raw_cmpl_evt_param_46,
    scan_rsp_data_raw_cmpl: ble_scan_rsp_data_raw_cmpl_evt_param_47,
    adv_start_cmpl: ble_adv_start_cmpl_evt_param_48,
    scan_start_cmpl: ble_scan_start_cmpl_evt_param_49,
    ble_security: esp_ble_sec_t,
    scan_stop_cmpl: ble_scan_stop_cmpl_evt_param_50,
    adv_stop_cmpl: ble_adv_stop_cmpl_evt_param_51,
    adv_clear_cmpl: ble_adv_clear_cmpl_evt_param_52,
    set_rand_addr_cmpl: ble_set_rand_cmpl_evt_param_53,
    update_conn_params: ble_update_conn_params_evt_param_54,
    pkt_data_length_cmpl: ble_pkt_data_length_cmpl_evt_param_55,
    local_privacy_cmpl: ble_local_privacy_cmpl_evt_param_56,
    remove_bond_dev_cmpl: ble_remove_bond_dev_cmpl_evt_param_57,
    clear_bond_dev_cmpl: ble_clear_bond_dev_cmpl_evt_param_58,
    get_bond_dev_cmpl: ble_get_bond_dev_cmpl_evt_param_59,
    read_rssi_cmpl: ble_read_rssi_cmpl_evt_param_60,
    update_whitelist_cmpl: ble_update_whitelist_cmpl_evt_param_61,
    update_duplicate_exceptional_list_cmpl: ble_update_duplicate_exceptional_list_cmpl_evt_param_62,
    ble_set_channels: ble_set_channels_evt_param_63,
    read_phy: ble_read_phy_cmpl_evt_param_64,
    set_perf_def_phy: ble_set_perf_def_phy_cmpl_evt_param_65,
    set_perf_phy: ble_set_perf_phy_cmpl_evt_param_66,
    ext_adv_set_rand_addr: ble_ext_adv_set_rand_addr_cmpl_evt_param_67,
    ext_adv_set_params: ble_ext_adv_set_params_cmpl_evt_param_68,
    ext_adv_data_set: ble_ext_adv_data_set_cmpl_evt_param_69,
    scan_rsp_set: ble_ext_adv_scan_rsp_set_cmpl_evt_param_70,
    ext_adv_start: ble_ext_adv_start_cmpl_evt_param_71,
    ext_adv_stop: ble_ext_adv_stop_cmpl_evt_param_72,
    ext_adv_remove: ble_ext_adv_set_remove_cmpl_evt_param_73,
    ext_adv_clear: ble_ext_adv_set_clear_cmpl_evt_param_74,
    peroid_adv_set_params: ble_periodic_adv_set_params_cmpl_param_75,
    period_adv_data_set: ble_periodic_adv_data_set_cmpl_param_76,
    period_adv_start: ble_periodic_adv_start_cmpl_param_77,
    period_adv_stop: ble_periodic_adv_stop_cmpl_param_78,
    period_adv_create_sync: ble_period_adv_create_sync_cmpl_param_79,
    period_adv_sync_cancel: ble_period_adv_sync_cancel_cmpl_param_80,
    period_adv_sync_term: ble_period_adv_sync_terminate_cmpl_param_81,
    period_adv_add_dev: ble_period_adv_add_dev_cmpl_param_82,
    period_adv_remove_dev: ble_period_adv_remove_dev_cmpl_param_83,
    period_adv_clear_dev: ble_period_adv_clear_dev_cmpl_param_84,
    set_ext_scan_params: ble_set_ext_scan_params_cmpl_param_85,
    ext_scan_start: ble_ext_scan_start_cmpl_param_86,
    ext_scan_stop: ble_ext_scan_stop_cmpl_param_87,
    ext_conn_params_set: ble_ext_conn_params_set_cmpl_param_88,
    adv_terminate: ble_adv_terminate_param_89,
    scan_req_received: ble_scan_req_received_param_90,
    channel_sel_alg: ble_channel_sel_alg_param_91,
    periodic_adv_sync_lost: ble_periodic_adv_sync_lost_param_92,
    periodic_adv_sync_estab: ble_periodic_adv_sync_estab_param_93,
    phy_update: ble_phy_update_cmpl_param_94,
    ext_adv_report: ble_ext_adv_report_param_95,
    period_adv_report: ble_periodic_adv_report_param_96,
    period_adv_recv_enable: ble_periodic_adv_recv_enable_cmpl_param_97,
    period_adv_sync_trans: ble_periodic_adv_sync_trans_cmpl_param_98,
    period_adv_set_info_trans: ble_periodic_adv_set_info_trans_cmpl_param_99,
    set_past_params: ble_set_past_params_cmpl_param_100,
    past_received: ble_periodic_adv_sync_trans_recv_param_101,
    dtm_state_update: ble_dtm_state_update_evt_param_102,
};
pub const esp_gap_ble_cb_t = ?*const fn (esp_gap_ble_cb_event_t, [*c]esp_ble_gap_cb_param_t) callconv(.C) void;
pub extern fn esp_ble_gap_register_callback(callback: esp_gap_ble_cb_t) esp_err_t;
pub extern fn esp_ble_gap_get_callback() esp_gap_ble_cb_t;
pub extern fn esp_ble_gap_config_adv_data(adv_data: [*c]esp_ble_adv_data_t) esp_err_t;
pub extern fn esp_ble_gap_set_scan_params(scan_params: [*c]esp_ble_scan_params_t) esp_err_t;
pub extern fn esp_ble_gap_start_scanning(duration: u32) esp_err_t;
pub extern fn esp_ble_gap_stop_scanning() esp_err_t;
pub extern fn esp_ble_gap_start_advertising(adv_params: [*c]esp_ble_adv_params_t) esp_err_t;
pub extern fn esp_ble_gap_stop_advertising() esp_err_t;
pub extern fn esp_ble_gap_update_conn_params(params: [*c]esp_ble_conn_update_params_t) esp_err_t;
pub extern fn esp_ble_gap_set_pkt_data_len(remote_device: [*c]u8, tx_data_length: u16) esp_err_t;
pub extern fn esp_ble_gap_set_rand_addr(rand_addr: [*c]u8) esp_err_t;
pub extern fn esp_ble_gap_clear_rand_addr() esp_err_t;
pub extern fn esp_ble_gap_config_local_privacy(privacy_enable: bool) esp_err_t;
pub extern fn esp_ble_gap_config_local_icon(icon: u16) esp_err_t;
pub extern fn esp_ble_gap_update_whitelist(add_remove: bool, remote_bda: [*c]u8, wl_addr_type: esp_ble_wl_addr_type_t) esp_err_t;
pub extern fn esp_ble_gap_clear_whitelist() esp_err_t;
pub extern fn esp_ble_gap_get_whitelist_size(length: [*c]u16) esp_err_t;
pub extern fn esp_ble_gap_set_prefer_conn_params(bd_addr: [*c]u8, min_conn_int: u16, max_conn_int: u16, slave_latency: u16, supervision_tout: u16) esp_err_t;
pub extern fn esp_ble_gap_set_device_name(name: [*c]const u8) esp_err_t;
pub extern fn esp_ble_gap_get_device_name() esp_err_t;
pub extern fn esp_ble_gap_get_local_used_addr(local_used_addr: [*c]u8, addr_type: [*c]u8) esp_err_t;
pub extern fn esp_ble_resolve_adv_data(adv_data: [*c]u8, @"type": u8, length: [*c]u8) [*c]u8;
pub extern fn esp_ble_gap_config_adv_data_raw(raw_data: [*c]u8, raw_data_len: u32) esp_err_t;
pub extern fn esp_ble_gap_config_scan_rsp_data_raw(raw_data: [*c]u8, raw_data_len: u32) esp_err_t;
pub extern fn esp_ble_gap_read_rssi(remote_addr: [*c]u8) esp_err_t;
pub extern fn esp_ble_gap_add_duplicate_scan_exceptional_device(@"type": esp_ble_duplicate_exceptional_info_type_t, device_info: [*c]u8) esp_err_t;
pub extern fn esp_ble_gap_remove_duplicate_scan_exceptional_device(@"type": esp_ble_duplicate_exceptional_info_type_t, device_info: [*c]u8) esp_err_t;
pub extern fn esp_ble_gap_clean_duplicate_scan_exceptional_list(list_type: esp_duplicate_scan_exceptional_list_type_t) esp_err_t;
pub extern fn esp_ble_gap_set_security_param(param_type: esp_ble_sm_param_t, value: ?*anyopaque, len: u8) esp_err_t;
pub extern fn esp_ble_gap_security_rsp(bd_addr: [*c]u8, accept: bool) esp_err_t;
pub extern fn esp_ble_set_encryption(bd_addr: [*c]u8, sec_act: esp_ble_sec_act_t) esp_err_t;
pub extern fn esp_ble_passkey_reply(bd_addr: [*c]u8, accept: bool, passkey: u32) esp_err_t;
pub extern fn esp_ble_confirm_reply(bd_addr: [*c]u8, accept: bool) esp_err_t;
pub extern fn esp_ble_remove_bond_device(bd_addr: [*c]u8) esp_err_t;
pub extern fn esp_ble_get_bond_device_num() c_int;
pub extern fn esp_ble_get_bond_device_list(dev_num: [*c]c_int, dev_list: [*c]esp_ble_bond_dev_t) esp_err_t;
pub extern fn esp_ble_oob_req_reply(bd_addr: [*c]u8, TK: [*c]u8, len: u8) esp_err_t;
pub extern fn esp_ble_sc_oob_req_reply(bd_addr: [*c]u8, p_c: [*c]u8, p_r: [*c]u8) esp_err_t;
pub extern fn esp_ble_create_sc_oob_data() esp_err_t;
pub extern fn esp_ble_gap_disconnect(remote_device: [*c]u8) esp_err_t;
pub extern fn esp_ble_get_current_conn_params(bd_addr: [*c]u8, conn_params: [*c]esp_gap_conn_params_t) esp_err_t;
pub extern fn esp_gap_ble_set_channels(channels: [*c]u8) esp_err_t;
pub extern fn esp_gap_ble_set_authorization(bd_addr: [*c]u8, authorize: bool) esp_err_t;
pub extern fn esp_ble_gap_read_phy(bd_addr: [*c]u8) esp_err_t;
pub extern fn esp_ble_gap_set_preferred_default_phy(tx_phy_mask: esp_ble_gap_phy_mask_t, rx_phy_mask: esp_ble_gap_phy_mask_t) esp_err_t;
pub extern fn esp_ble_gap_set_preferred_phy(bd_addr: [*c]u8, all_phys_mask: esp_ble_gap_all_phys_t, tx_phy_mask: esp_ble_gap_phy_mask_t, rx_phy_mask: esp_ble_gap_phy_mask_t, phy_options: esp_ble_gap_prefer_phy_options_t) esp_err_t;
pub extern fn esp_ble_gap_ext_adv_set_rand_addr(instance: u8, rand_addr: [*c]u8) esp_err_t;
pub extern fn esp_ble_gap_ext_adv_set_params(instance: u8, params: [*c]const esp_ble_gap_ext_adv_params_t) esp_err_t;
pub extern fn esp_ble_gap_config_ext_adv_data_raw(instance: u8, length: u16, data: [*c]const u8) esp_err_t;
pub extern fn esp_ble_gap_config_ext_scan_rsp_data_raw(instance: u8, length: u16, scan_rsp_data: [*c]const u8) esp_err_t;
pub extern fn esp_ble_gap_ext_adv_start(num_adv: u8, ext_adv: [*c]const esp_ble_gap_ext_adv_t) esp_err_t;
pub extern fn esp_ble_gap_ext_adv_stop(num_adv: u8, ext_adv_inst: [*c]const u8) esp_err_t;
pub extern fn esp_ble_gap_ext_adv_set_remove(instance: u8) esp_err_t;
pub extern fn esp_ble_gap_ext_adv_set_clear() esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_set_params(instance: u8, params: [*c]const esp_ble_gap_periodic_adv_params_t) esp_err_t;
pub extern fn esp_ble_gap_config_periodic_adv_data_raw(instance: u8, length: u16, data: [*c]const u8) esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_start(instance: u8) esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_stop(instance: u8) esp_err_t;
pub extern fn esp_ble_gap_set_ext_scan_params(params: [*c]const esp_ble_ext_scan_params_t) esp_err_t;
pub extern fn esp_ble_gap_start_ext_scan(duration: u32, period: u16) esp_err_t;
pub extern fn esp_ble_gap_stop_ext_scan() esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_create_sync(params: [*c]const esp_ble_gap_periodic_adv_sync_params_t) esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_sync_cancel() esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_sync_terminate(sync_handle: u16) esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_add_dev_to_list(addr_type: esp_ble_addr_type_t, addr: [*c]u8, sid: u8) esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_remove_dev_from_list(addr_type: esp_ble_addr_type_t, addr: [*c]u8, sid: u8) esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_clear_dev() esp_err_t;
pub extern fn esp_ble_gap_prefer_ext_connect_params_set(addr: [*c]u8, phy_mask: esp_ble_gap_phy_mask_t, phy_1m_conn_params: [*c]const esp_ble_gap_conn_params_t, phy_2m_conn_params: [*c]const esp_ble_gap_conn_params_t, phy_coded_conn_params: [*c]const esp_ble_gap_conn_params_t) esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_recv_enable(sync_handle: u16, enable: u8) esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_sync_trans(addr: [*c]u8, service_data: u16, sync_handle: u16) esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_set_info_trans(addr: [*c]u8, service_data: u16, adv_handle: u8) esp_err_t;
pub extern fn esp_ble_gap_set_periodic_adv_sync_trans_params(addr: [*c]u8, params: [*c]const esp_ble_gap_past_params_t) esp_err_t;
pub extern fn esp_ble_dtm_tx_start(tx_params: [*c]const esp_ble_dtm_tx_t) esp_err_t;
pub extern fn esp_ble_dtm_rx_start(rx_params: [*c]const esp_ble_dtm_rx_t) esp_err_t;
pub extern fn esp_ble_dtm_enh_tx_start(tx_params: [*c]const esp_ble_dtm_enh_tx_t) esp_err_t;
pub extern fn esp_ble_dtm_enh_rx_start(rx_params: [*c]const esp_ble_dtm_enh_rx_t) esp_err_t;
pub extern fn esp_ble_dtm_stop() esp_err_t;
pub extern fn esp_ble_gap_clear_advertising() esp_err_t;
pub extern fn esp_blufi_close(gatts_if: u8, conn_id: u16) esp_err_t;
pub extern fn esp_blufi_gap_event_handler(event: esp_gap_ble_cb_event_t, param: [*c]esp_ble_gap_cb_param_t) void;
pub extern fn esp_blufi_init() u8;
pub extern fn bleprph_advertise() void;
pub extern fn esp_blufi_send_notify(arg: ?*anyopaque) void;
pub extern fn esp_blufi_deinit() void;
pub extern fn esp_blufi_disconnect() void;
pub extern fn esp_blufi_adv_stop() void;
pub extern fn esp_blufi_adv_start() void;
pub extern fn esp_blufi_send_encap(arg: ?*anyopaque) void;

pub const sched_param = extern struct {
    sched_priority: c_int = std.mem.zeroes(c_int),
};
pub extern fn sched_yield() c_int;
pub const pthread_t = c_uint;
pub const pthread_attr_t = extern struct {
    is_initialized: c_int = std.mem.zeroes(c_int),
    stackaddr: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    stacksize: c_int = std.mem.zeroes(c_int),
    contentionscope: c_int = std.mem.zeroes(c_int),
    inheritsched: c_int = std.mem.zeroes(c_int),
    schedpolicy: c_int = std.mem.zeroes(c_int),
    schedparam: sched_param = std.mem.zeroes(sched_param),
    detachstate: c_int = std.mem.zeroes(c_int),
};
pub const pthread_mutex_t = c_uint;
pub const pthread_mutexattr_t = extern struct {
    is_initialized: c_int = std.mem.zeroes(c_int),
    type: c_int = std.mem.zeroes(c_int),
    recursive: c_int = std.mem.zeroes(c_int),
};
pub const pthread_cond_t = c_uint;
pub const pthread_condattr_t = extern struct {
    is_initialized: c_int = std.mem.zeroes(c_int),
    clock: c_ulong = std.mem.zeroes(c_ulong),
};
pub const pthread_key_t = c_uint;
pub const pthread_once_t = extern struct {
    is_initialized: c_int = std.mem.zeroes(c_int),
    init_executed: c_int = std.mem.zeroes(c_int),
};
pub const bintime = extern struct {
    sec: i64 = std.mem.zeroes(i64),
    frac: u64 = std.mem.zeroes(u64),
};
pub const pthread_cleanup_context = extern struct {
    _routine: ?*const fn (?*anyopaque) callconv(.C) void = std.mem.zeroes(?*const fn (?*anyopaque) callconv(.C) void),
    _arg: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    _canceltype: c_int = std.mem.zeroes(c_int),
    _previous: [*c]pthread_cleanup_context = std.mem.zeroes([*c]pthread_cleanup_context),
};
pub extern fn pthread_mutexattr_init(__attr: [*c]pthread_mutexattr_t) c_int;
pub extern fn pthread_mutexattr_destroy(__attr: [*c]pthread_mutexattr_t) c_int;
pub extern fn pthread_mutexattr_getpshared(__attr: [*c]const pthread_mutexattr_t, __pshared: [*c]c_int) c_int;
pub extern fn pthread_mutexattr_setpshared(__attr: [*c]pthread_mutexattr_t, __pshared: c_int) c_int;
pub extern fn pthread_mutexattr_gettype(__attr: [*c]const pthread_mutexattr_t, __kind: [*c]c_int) c_int;
pub extern fn pthread_mutexattr_settype(__attr: [*c]pthread_mutexattr_t, __kind: c_int) c_int;
pub extern fn pthread_mutex_init(__mutex: [*c]pthread_mutex_t, __attr: [*c]const pthread_mutexattr_t) c_int;
pub extern fn pthread_mutex_destroy(__mutex: [*c]pthread_mutex_t) c_int;
pub extern fn pthread_mutex_lock(__mutex: [*c]pthread_mutex_t) c_int;
pub extern fn pthread_mutex_trylock(__mutex: [*c]pthread_mutex_t) c_int;
pub extern fn pthread_mutex_unlock(__mutex: [*c]pthread_mutex_t) c_int;
pub extern fn pthread_mutex_timedlock(__mutex: [*c]pthread_mutex_t, __timeout: [*c]const timespec) c_int;
pub extern fn pthread_condattr_init(__attr: [*c]pthread_condattr_t) c_int;
pub extern fn pthread_condattr_destroy(__attr: [*c]pthread_condattr_t) c_int;
pub extern fn pthread_condattr_getclock(noalias __attr: [*c]const pthread_condattr_t, noalias __clock_id: [*c]c_ulong) c_int;
pub extern fn pthread_condattr_setclock(__attr: [*c]pthread_condattr_t, __clock_id: c_ulong) c_int;
pub extern fn pthread_condattr_getpshared(__attr: [*c]const pthread_condattr_t, __pshared: [*c]c_int) c_int;
pub extern fn pthread_condattr_setpshared(__attr: [*c]pthread_condattr_t, __pshared: c_int) c_int;
pub extern fn pthread_cond_init(__cond: [*c]pthread_cond_t, __attr: [*c]const pthread_condattr_t) c_int;
pub extern fn pthread_cond_destroy(__mutex: [*c]pthread_cond_t) c_int;
pub extern fn pthread_cond_signal(__cond: [*c]pthread_cond_t) c_int;
pub extern fn pthread_cond_broadcast(__cond: [*c]pthread_cond_t) c_int;
pub extern fn pthread_cond_wait(__cond: [*c]pthread_cond_t, __mutex: [*c]pthread_mutex_t) c_int;
pub extern fn pthread_cond_timedwait(__cond: [*c]pthread_cond_t, __mutex: [*c]pthread_mutex_t, __abstime: [*c]const timespec) c_int;
pub extern fn pthread_attr_setschedparam(__attr: [*c]pthread_attr_t, __param: [*c]const sched_param) c_int;
pub extern fn pthread_attr_getschedparam(__attr: [*c]const pthread_attr_t, __param: [*c]sched_param) c_int;
pub extern fn pthread_attr_init(__attr: [*c]pthread_attr_t) c_int;
pub extern fn pthread_attr_destroy(__attr: [*c]pthread_attr_t) c_int;
pub extern fn pthread_attr_setstack(attr: [*c]pthread_attr_t, __stackaddr: ?*anyopaque, __stacksize: usize) c_int;
pub extern fn pthread_attr_getstack(attr: [*c]const pthread_attr_t, __stackaddr: [*c]?*anyopaque, __stacksize: [*c]usize) c_int;
pub extern fn pthread_attr_getstacksize(__attr: [*c]const pthread_attr_t, __stacksize: [*c]usize) c_int;
pub extern fn pthread_attr_setstacksize(__attr: [*c]pthread_attr_t, __stacksize: usize) c_int;
pub extern fn pthread_attr_getstackaddr(__attr: [*c]const pthread_attr_t, __stackaddr: [*c]?*anyopaque) c_int;
pub extern fn pthread_attr_setstackaddr(__attr: [*c]pthread_attr_t, __stackaddr: ?*anyopaque) c_int;
pub extern fn pthread_attr_getdetachstate(__attr: [*c]const pthread_attr_t, __detachstate: [*c]c_int) c_int;
pub extern fn pthread_attr_setdetachstate(__attr: [*c]pthread_attr_t, __detachstate: c_int) c_int;
pub extern fn pthread_attr_getguardsize(__attr: [*c]const pthread_attr_t, __guardsize: [*c]usize) c_int;
pub extern fn pthread_attr_setguardsize(__attr: [*c]pthread_attr_t, __guardsize: usize) c_int;
pub extern fn pthread_create(__pthread: [*c]pthread_t, __attr: [*c]const pthread_attr_t, __start_routine: ?*const fn (?*anyopaque) callconv(.C) ?*anyopaque, __arg: ?*anyopaque) c_int;
pub extern fn pthread_join(__pthread: pthread_t, __value_ptr: [*c]?*anyopaque) c_int;
pub extern fn pthread_detach(__pthread: pthread_t) c_int;
pub extern fn pthread_exit(__value_ptr: ?*anyopaque) noreturn;
pub extern fn pthread_self() pthread_t;
pub extern fn pthread_equal(__t1: pthread_t, __t2: pthread_t) c_int;
pub extern fn pthread_getcpuclockid(thread: pthread_t, clock_id: [*c]c_ulong) c_int;
pub extern fn pthread_setconcurrency(new_level: c_int) c_int;
pub extern fn pthread_getconcurrency() c_int;
pub extern fn pthread_yield() void;
pub extern fn pthread_once(__once_control: [*c]pthread_once_t, __init_routine: ?*const fn () callconv(.C) void) c_int;
pub extern fn pthread_key_create(__key: [*c]pthread_key_t, __destructor: ?*const fn (?*anyopaque) callconv(.C) void) c_int;
pub extern fn pthread_setspecific(__key: pthread_key_t, __value: ?*const anyopaque) c_int;
pub extern fn pthread_getspecific(__key: pthread_key_t) ?*anyopaque;
pub extern fn pthread_key_delete(__key: pthread_key_t) c_int;
pub extern fn pthread_cancel(__pthread: pthread_t) c_int;
pub extern fn pthread_setcancelstate(__state: c_int, __oldstate: [*c]c_int) c_int;
pub extern fn pthread_setcanceltype(__type: c_int, __oldtype: [*c]c_int) c_int;
pub extern fn pthread_testcancel() void;
pub extern fn _pthread_cleanup_push(_context: [*c]pthread_cleanup_context, _routine: ?*const fn (?*anyopaque) callconv(.C) void, _arg: ?*anyopaque) void;
pub extern fn _pthread_cleanup_pop(_context: [*c]pthread_cleanup_context, _execute: c_int) void;
pub const timespec = extern struct {
    tv_sec: i64 = std.mem.zeroes(i64),
    tv_nsec: c_long = std.mem.zeroes(c_long),
};
pub const itimerspec = extern struct {
    it_interval: timespec = std.mem.zeroes(timespec),
    it_value: timespec = std.mem.zeroes(timespec),
};
// TODO: port zig (std.Thread) to FreeRTOS
