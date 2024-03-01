//! esp-idf headers 'zig translate-c' v0.12.0 for xtensa target (re-edited by @kassane)

const std = @import("std");
pub const va_list = extern struct {
    __va_stk: [*c]c_int = std.mem.zeroes([*c]c_int),
    __va_reg: [*c]c_int = std.mem.zeroes([*c]c_int),
    __va_ndx: c_int = std.mem.zeroes(c_int),
};

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
    ErrorInvalidRonse,
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
    };
}

pub fn getIDFError(errc: esp_err_t) !void {
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
    try getIDFError(esp_register_shutdown_handler(handle));
}
extern fn esp_unregister_shutdown_handler(handle: shutdown_handler_t) esp_err_t;
pub fn espUnregisterShutdownHandler(handle: shutdown_handler_t) !void {
    try getIDFError(esp_unregister_shutdown_handler(handle));
}
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
pub const esp_log_level_t = enum(c_uint) {
    ESP_LOG_NONE = 0,
    ESP_LOG_ERROR = 1,
    ESP_LOG_WARN = 2,
    ESP_LOG_INFO = 3,
    ESP_LOG_DEBUG = 4,
    ESP_LOG_VERBOSE = 5,
};
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
pub extern fn _xtos_timer_2_delta(cycles: c_int) void; // /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:37:5: warning: TODO implement translation of stmt class GCCAsmStmtClass
// /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:28:50: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_get_core_id() u32; // /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:52:5: warning: TODO implement translation of stmt class GCCAsmStmtClass
// /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:47:50: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_get_raw_core_id() u32; // /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:64:5: warning: TODO implement translation of stmt class GCCAsmStmtClass
// /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:61:25: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_get_sp() ?*anyopaque; // /home/kassane/espressif/esp-idf/components/xtensa/include/xt_instr_macros.h:11:30: warning: TODO implement translation of stmt class GCCAsmStmtClass
// /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:68:28: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_get_cycle_count() u32; // /home/kassane/espressif/esp-idf/components/xtensa/include/xt_instr_macros.h:12:30: warning: TODO implement translation of stmt class GCCAsmStmtClass
// /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:75:20: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_set_cycle_count(arg_ccount: u32) callconv(.C) void; // /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:82:5: warning: TODO implement translation of stmt class GCCAsmStmtClass
// /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:80:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_wait_for_intr() void; // /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:95:5: warning: TODO implement translation of stmt class GCCAsmStmtClass
// /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:93:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_set_vecbase(arg_vecbase: u32) void; // /home/kassane/espressif/esp-idf/components/xtensa/include/xt_instr_macros.h:11:30: warning: TODO implement translation of stmt class GCCAsmStmtClass
// /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:100:28: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_intr_get_enabled_mask() u32; // /home/kassane/espressif/esp-idf/components/xtensa/include/xt_instr_macros.h:12:30: warning: TODO implement translation of stmt class GCCAsmStmtClass
// /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:117:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_set_breakpoint(arg_bp_num: c_int, arg_bp_addr: u32) void; // /home/kassane/espressif/esp-idf/components/xtensa/include/xt_instr_macros.h:11:30: warning: TODO implement translation of stmt class GCCAsmStmtClass
// /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:132:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_clear_breakpoint(arg_bp_num: c_int) void; // /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:156:35: warning: TODO implement function '__builtin_ffsll' in std.zig.c_builtins
// /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:148:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_set_watchpoint(arg_wp_num: c_int, arg_wp_addr: u32, arg_size: usize, arg_on_read: bool, arg_on_write: bool) void; // /home/kassane/espressif/esp-idf/components/xtensa/include/xt_instr_macros.h:12:30: warning: TODO implement translation of stmt class GCCAsmStmtClass
// /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:174:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_clear_watchpoint(arg_wp_num: c_int) void; // /home/kassane/espressif/esp-idf/components/xtensa/include/xt_instr_macros.h:15:30: warning: TODO implement translation of stmt class GCCAsmStmtClass
// /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:188:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_dbgr_is_attached() bool; // /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:198:5: warning: TODO implement translation of stmt class GCCAsmStmtClass
// /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:196:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_dbgr_break() void; // /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:216:5: warning: TODO implement translation of stmt class GCCAsmStmtClass
// /home/kassane/espressif/esp-idf/components/xtensa/include/xt_utils.h:205:24: warning: unable to translate function, demoted to extern
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
pub extern fn esp_intr_disable_source(inum: c_int) void; // /home/kassane/espressif/esp-idf/components/esp_hw_support/include/esp_intr_alloc.h:300:12: warning: TODO implement function '__builtin_ffs' in std.zig.c_builtins
// /home/kassane/espressif/esp-idf/components/esp_hw_support/include/esp_intr_alloc.h:298:19: warning: unable to translate function, demoted to extern
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
} // /home/kassane/espressif/esp-idf/components/newlib/platform_include/assert.h:30:23: warning: TODO implement function '__builtin_strrchr' in std.zig.c_builtins
// /home/kassane/espressif/esp-idf/components/esp_hw_support/include/esp_cpu.h:324:24: warning: unable to translate function, demoted to extern
pub extern fn esp_cpu_intr_has_handler(arg_intr_num: c_int) bool; // /home/kassane/espressif/esp-idf/components/newlib/platform_include/assert.h:30:23: warning: TODO implement function '__builtin_strrchr' in std.zig.c_builtins
// /home/kassane/espressif/esp-idf/components/esp_hw_support/include/esp_cpu.h:348:24: warning: unable to translate function, demoted to extern
pub extern fn esp_cpu_intr_set_handler(arg_intr_num: c_int, arg_handler: esp_cpu_intr_handler_t, arg_handler_arg: ?*anyopaque) void; // /home/kassane/espressif/esp-idf/components/newlib/platform_include/assert.h:30:23: warning: TODO implement function '__builtin_strrchr' in std.zig.c_builtins
// /home/kassane/espressif/esp-idf/components/esp_hw_support/include/esp_cpu.h:366:25: warning: unable to translate function, demoted to extern
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
} // /home/kassane/espressif/esp-idf/components/newlib/platform_include/assert.h:30:23: warning: TODO implement function '__builtin_strrchr' in std.zig.c_builtins
// /home/kassane/espressif/esp-idf/components/esp_hw_support/include/esp_cpu.h:427:24: warning: unable to translate function, demoted to extern
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
}; // /home/kassane/espressif/esp-idf/components/newlib/platform_include/assert.h:30:23: warning: TODO implement function '__builtin_strrchr' in std.zig.c_builtins
// /home/kassane/espressif/esp-idf/components/esp_hw_support/include/spinlock.h:51:51: warning: unable to translate function, demoted to extern
pub extern fn spinlock_initialize(arg_lock: [*c]spinlock_t) void; // /home/kassane/espressif/esp-idf/components/newlib/platform_include/assert.h:30:23: warning: TODO implement function '__builtin_strrchr' in std.zig.c_builtins
// /home/kassane/espressif/esp-idf/components/esp_hw_support/include/spinlock.h:74:51: warning: unable to translate function, demoted to extern
pub extern fn spinlock_acquire(arg_lock: [*c]spinlock_t, arg_timeout: i32) bool; // /home/kassane/espressif/esp-idf/components/newlib/platform_include/assert.h:30:23: warning: TODO implement function '__builtin_strrchr' in std.zig.c_builtins
// /home/kassane/espressif/esp-idf/components/esp_hw_support/include/spinlock.h:172:51: warning: unable to translate function, demoted to extern
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
pub extern fn xPortInterruptedFromISRContext() BaseType_t; // /home/kassane/espressif/esp-idf/components/xtensa/include/xtensa/xtruntime.h:92:4: warning: TODO implement translation of stmt class GCCAsmStmtClass
// /home/kassane/espressif/esp-idf/components/freertos/FreeRTOS-Kernel/portable/xtensa/include/freertos/portmacro.h:554:58: warning: unable to translate function, demoted to extern
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
pub extern fn vPortYieldOtherCore(coreid: BaseType_t) void; // /home/kassane/espressif/esp-idf/components/xtensa/include/xt_instr_macros.h:11:30: warning: TODO implement translation of stmt class GCCAsmStmtClass
// /home/kassane/espressif/esp-idf/components/freertos/FreeRTOS-Kernel/portable/xtensa/include/freertos/portmacro.h:606:24: warning: unable to translate function, demoted to extern
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
pub extern fn xTaskCreate(pxTaskCode: TaskFunction_t, pcName: [*:0]const u8, usStackDepth: u32, pvParameters: ?*anyopaque, uxPriority: UBaseType_t, pxCreatedTask: [*c]TaskHandle_t) BaseType_t;
pub extern fn xTaskCreateStatic(pxTaskCode: TaskFunction_t, pcName: [*:0]const u8, ulStackDepth: u32, pvParameters: ?*anyopaque, uxPriority: UBaseType_t, puxStackBuffer: [*c]StackType_t, pxTaskBuffer: [*c]StaticTask_t) TaskHandle_t;
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
