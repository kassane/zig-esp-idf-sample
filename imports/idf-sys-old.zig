// esp-idf headers 'zig translate-c' v0.12.0 for xtensa target (re-edited by @kassane)

const std = @import("std");
const builtin = @import("builtin");

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
pub extern fn esp_register_shutdown_handler(handle: shutdown_handler_t) esp_err_t;
pub extern fn esp_unregister_shutdown_handler(handle: shutdown_handler_t) esp_err_t;
pub extern fn esp_restart() noreturn;
pub extern fn esp_reset_reason() esp_reset_reason_t;
pub extern fn esp_get_free_heap_size() u32;
pub extern fn esp_get_free_internal_heap_size() u32;
pub extern fn esp_get_minimum_free_heap_size() u32;
pub extern fn esp_system_abort(details: [*:0]const u8) noreturn;
pub fn esp_rom_crc32(crc: u32, buf: [*:0]const u8, len: u32) u32 {
    return switch (builtin.cpu.arch.endian()) {
        .little => esp_rom_crc32_le(crc, buf, len),
        else => esp_rom_crc32_be(crc, buf, len),
    };
}
extern fn esp_rom_crc32_be(crc: u32, buf: [*:0]const u8, len: u32) u32;
extern fn esp_rom_crc32_le(crc: u32, buf: [*:0]const u8, len: u32) u32;
pub fn esp_rom_crc16(crc: u32, buf: [*:0]const u8, len: u32) u32 {
    return switch (builtin.cpu.arch.endian()) {
        .little => esp_rom_crc16_le(crc, buf, len),
        else => esp_rom_crc16_be(crc, buf, len),
    };
}
extern fn esp_rom_crc16_le(crc: u16, buf: [*:0]const u8, len: u32) u16;
extern fn esp_rom_crc16_be(crc: u16, buf: [*:0]const u8, len: u32) u16;
pub fn esp_rom_crc8(crc: u32, buf: [*:0]const u8, len: u32) u32 {
    return switch (builtin.cpu.arch.endian()) {
        .little => esp_rom_crc8_le(crc, buf, len),
        else => esp_rom_crc8_be(crc, buf, len),
    };
}
extern fn esp_rom_crc8_le(crc: u8, buf: [*:0]const u8, len: u32) u8;
extern fn esp_rom_crc8_be(crc: u8, buf: [*:0]const u8, len: u32) u8;
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
pub fn xt_set_intset(arg: c_uint) callconv(.C) void {
    xthal_set_intset(arg);
}
pub fn xt_set_intclear(arg: c_uint) callconv(.C) void {
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
pub fn _xtos_interrupt_enable(intnum: c_uint) callconv(.C) void {
    _ = _xtos_ints_on(@as(c_uint, 1) << @intCast(intnum));
}
pub fn _xtos_interrupt_disable(intnum: c_uint) callconv(.C) void {
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
pub extern fn xt_utils_set_cycle_count(ccount: u32) callconv(.C) void; // esp-idf/components/xtensa/include/xt_utils.h:82:5: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:80:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_wait_for_intr() void; // esp-idf/components/xtensa/include/xt_utils.h:95:5: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:93:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_set_vecbase(vecbase: u32) void; // esp-idf/components/xtensa/include/xt_instr_macros.h:11:30: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:100:28: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_intr_get_enabled_mask() u32; // esp-idf/components/xtensa/include/xt_instr_macros.h:12:30: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:117:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_set_breakpoint(bp_num: c_int, bp_addr: u32) void; // esp-idf/components/xtensa/include/xt_instr_macros.h:11:30: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:132:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_clear_breakpoint(bp_num: c_int) void; // esp-idf/components/xtensa/include/xt_utils.h:156:35: warning: TODO implement function '__builtin_ffsll' in std.zig.c_builtins
// esp-idf/components/xtensa/include/xt_utils.h:148:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_set_watchpoint(wp_num: c_int, wp_addr: u32, size: usize, on_read: bool, on_write: bool) void; // esp-idf/components/xtensa/include/xt_instr_macros.h:12:30: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:174:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_clear_watchpoint(wp_num: c_int) void; // esp-idf/components/xtensa/include/xt_instr_macros.h:15:30: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:188:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_dbgr_is_attached() bool; // esp-idf/components/xtensa/include/xt_utils.h:198:5: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:196:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_dbgr_break() void; // esp-idf/components/xtensa/include/xt_utils.h:216:5: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/xtensa/include/xt_utils.h:205:24: warning: unable to translate function, demoted to extern
pub extern fn xt_utils_compare_and_set(addr: [*c]volatile u32, compare_value: u32, new_value: u32) bool;
pub const intr_handler_t = ?*const fn (?*anyopaque) callconv(.C) void;
pub const intr_handle_data_t = opaque {};
pub const intr_handle_t = ?*intr_handle_data_t;
pub const esp_intr_cpu_affinity_t = enum(c_uint) {
    ESP_INTR_CPU_AFFINITY_AUTO = 0,
    ESP_INTR_CPU_AFFINITY_0 = 1,
    ESP_INTR_CPU_AFFINITY_1 = 2,
};
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
pub extern fn esp_intr_disable_source(inum: c_int) void;
// esp-idf/components/esp_hw_support/include/esp_intr_alloc.h:300:12: warning: TODO implement function '__builtin_ffs' in std.zig.c_builtins
// esp-idf/components/esp_hw_support/include/esp_intr_alloc.h:298:19: warning: unable to translate function, demoted to extern
pub extern fn esp_intr_flags_to_level(flags: c_int) callconv(.C) c_int;
pub fn esp_intr_level_to_flags(level: c_int) callconv(.C) c_int {
    return if (level > @as(c_int, 0)) (@as(c_int, 1) << @intCast(level)) & (((((((@as(c_int, 1) << @intCast(1)) | (@as(c_int, 1) << @intCast(2))) | (@as(c_int, 1) << @intCast(3))) | (@as(c_int, 1) << @intCast(4))) | (@as(c_int, 1) << @intCast(5))) | (@as(c_int, 1) << @intCast(6))) | (@as(c_int, 1) << @intCast(7))) else @as(c_int, 0);
}
pub extern fn esp_intr_dump(stream: ?*std.c.FILE) esp_err_t;
pub const esp_cpu_cycle_count_t = u32;
pub const esp_cpu_intr_type_t = enum(c_uint) {
    ESP_CPU_INTR_TYPE_LEVEL = 0,
    ESP_CPU_INTR_TYPE_EDGE = 1,
    ESP_CPU_INTR_TYPE_NA = 2,
};
pub const esp_cpu_intr_desc_t = extern struct {
    priority: c_int = std.mem.zeroes(c_int),
    type: esp_cpu_intr_type_t = std.mem.zeroes(esp_cpu_intr_type_t),
    flags: u32 = std.mem.zeroes(u32),
};
pub const esp_cpu_intr_handler_t = ?*const fn (?*anyopaque) callconv(.C) void;
pub const esp_cpu_watchpoint_trigger_t = enum(c_uint) {
    ESP_CPU_WATCHPOINT_LOAD = 0,
    ESP_CPU_WATCHPOINT_STORE = 1,
    ESP_CPU_WATCHPOINT_ACCESS = 2,
};
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
pub inline fn esp_cpu_set_cycle_count(cycle_count: esp_cpu_cycle_count_t) void {
    xt_utils_set_cycle_count(@as(u32, @bitCast(cycle_count)));
}
pub inline fn esp_cpu_pc_to_addr(pc: u32) ?*anyopaque {
    return @as(?*anyopaque, @ptrFromInt((pc & @as(c_uint, 1073741823)) | @as(c_uint, 1073741824)));
}
pub extern fn esp_cpu_intr_get_desc(core_id: c_int, intr_num: c_int, intr_desc_ret: [*c]esp_cpu_intr_desc_t) void;
pub inline fn esp_cpu_intr_set_ivt_addr(ivt_addr: ?*const anyopaque) void {
    xt_utils_set_vecbase(@as(u32, @intCast(@intFromPtr(ivt_addr))));
}
// esp-idf/components/newlib/platform_include/assert.h:30:23: warning: TODO implement function '__builtin_strrchr' in std.zig.c_builtins
// esp-idf/components/esp_hw_support/include/esp_cpu.h:324:24: warning: unable to translate function, demoted to extern
pub extern fn esp_cpu_intr_has_handler(intr_num: c_int) bool;
// esp-idf/components/newlib/platform_include/assert.h:30:23: warning: TODO implement function '__builtin_strrchr' in std.zig.c_builtins
// esp-idf/components/esp_hw_support/include/esp_cpu.h:348:24: warning: unable to translate function, demoted to extern
pub extern fn esp_cpu_intr_set_handler(intr_num: c_int, handler: esp_cpu_intr_handler_t, handler_arg: ?*anyopaque) void; // esp-idf/components/newlib/platform_include/assert.h:30:23: warning: TODO implement function '__builtin_strrchr' in std.zig.c_builtins
// esp-idf/components/esp_hw_support/include/esp_cpu.h:366:25: warning: unable to translate function, demoted to extern
pub extern fn esp_cpu_intr_get_handler_arg(intr_num: c_int) ?*anyopaque;
pub inline fn esp_cpu_intr_enable(intr_mask: u32) void {
    xt_ints_on(intr_mask);
}
pub inline fn esp_cpu_intr_disable(intr_mask: u32) void {
    xt_ints_off(intr_mask);
}
pub inline fn esp_cpu_intr_get_enabled_mask() u32 {
    return xt_utils_intr_get_enabled_mask();
} // esp-idf/components/newlib/platform_include/assert.h:30:23: warning: TODO implement function '__builtin_strrchr' in std.zig.c_builtins
// esp-idf/components/esp_hw_support/include/esp_cpu.h:427:24: warning: unable to translate function, demoted to extern
pub extern fn esp_cpu_intr_edge_ack(intr_num: c_int) void;
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
pub inline fn esp_cpu_get_call_addr(return_address: isize) isize {
    return return_address - @as(c_int, 3);
}
pub extern fn esp_cpu_compare_and_set(addr: [*c]volatile u32, compare_value: u32, new_value: u32) bool;
pub const esp_backtrace_frame_t = extern struct {
    pc: u32 = std.mem.zeroes(u32),
    sp: u32 = std.mem.zeroes(u32),
    next_pc: u32 = std.mem.zeroes(u32),
    exc_frame: ?*const anyopaque = null,
};
pub extern fn esp_set_breakpoint_if_jtag(@"fn": ?*anyopaque) void;
pub extern fn esp_backtrace_get_start(pc: [*c]u32, sp: [*c]u32, next_pc: [*c]u32) void;
pub extern fn esp_backtrace_get_next_frame(frame: [*c]esp_backtrace_frame_t) bool;
pub extern fn esp_backtrace_print_from_frame(depth: c_int, frame: [*c]const esp_backtrace_frame_t, panic: bool) esp_err_t;
pub extern fn esp_backtrace_print(depth: c_int) esp_err_t;
pub extern fn esp_backtrace_print_all_tasks(depth: c_int) esp_err_t;
pub fn esp_set_watchpoint(no: c_int, adr: ?*anyopaque, size: c_int, flag: c_int) callconv(.C) esp_err_t {
    return esp_cpu_set_watchpoint(no, adr, @as(usize, @bitCast(size)), @as(c_uint, @bitCast(flag)));
}
pub fn esp_clear_watchpoint(no: c_int) callconv(.C) void {
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
pub const touch_pad_intr_mask_t = enum(c_uint) {
    TOUCH_PAD_INTR_MASK_DONE = 1,
    TOUCH_PAD_INTR_MASK_ACTIVE = 2,
    TOUCH_PAD_INTR_MASK_INACTIVE = 4,
    TOUCH_PAD_INTR_MASK_SCAN_DONE = 8,
    TOUCH_PAD_INTR_MASK_TIMEOUT = 16,
    TOUCH_PAD_INTR_MASK_MAX = 17,
};
pub const touch_pad_denoise_grade_t = enum(c_uint) {
    TOUCH_PAD_DENOISE_BIT12 = 0,
    TOUCH_PAD_DENOISE_BIT10 = 1,
    TOUCH_PAD_DENOISE_BIT8 = 2,
    TOUCH_PAD_DENOISE_BIT4 = 3,
    TOUCH_PAD_DENOISE_MAX = 4,
};
pub const touch_pad_denoise_cap_t = enum(c_uint) {
    TOUCH_PAD_DENOISE_CAP_L0 = 0,
    TOUCH_PAD_DENOISE_CAP_L1 = 1,
    TOUCH_PAD_DENOISE_CAP_L2 = 2,
    TOUCH_PAD_DENOISE_CAP_L3 = 3,
    TOUCH_PAD_DENOISE_CAP_L4 = 4,
    TOUCH_PAD_DENOISE_CAP_L5 = 5,
    TOUCH_PAD_DENOISE_CAP_L6 = 6,
    TOUCH_PAD_DENOISE_CAP_L7 = 7,
    TOUCH_PAD_DENOISE_CAP_MAX = 8,
};
pub const touch_pad_denoise = extern struct {
    grade: touch_pad_denoise_grade_t = std.mem.zeroes(touch_pad_denoise_grade_t),
    cap_level: touch_pad_denoise_cap_t = std.mem.zeroes(touch_pad_denoise_cap_t),
};
pub const touch_pad_denoise_t = touch_pad_denoise;
pub const touch_pad_shield_driver_t = enum(c_uint) {
    TOUCH_PAD_SHIELD_DRV_L0 = 0,
    TOUCH_PAD_SHIELD_DRV_L1 = 1,
    TOUCH_PAD_SHIELD_DRV_L2 = 2,
    TOUCH_PAD_SHIELD_DRV_L3 = 3,
    TOUCH_PAD_SHIELD_DRV_L4 = 4,
    TOUCH_PAD_SHIELD_DRV_L5 = 5,
    TOUCH_PAD_SHIELD_DRV_L6 = 6,
    TOUCH_PAD_SHIELD_DRV_L7 = 7,
    TOUCH_PAD_SHIELD_DRV_MAX = 8,
};
pub const touch_pad_waterproof = extern struct {
    guard_ring_pad: touch_pad_t = std.mem.zeroes(touch_pad_t),
    shield_driver: touch_pad_shield_driver_t = std.mem.zeroes(touch_pad_shield_driver_t),
};
pub const touch_pad_waterproof_t = touch_pad_waterproof;
pub const touch_pad_conn_type_t = enum(c_uint) {
    TOUCH_PAD_CONN_HIGHZ = 0,
    TOUCH_PAD_CONN_GND = 1,
    TOUCH_PAD_CONN_MAX = 2,
};
pub const touch_filter_mode_t = enum(c_uint) {
    TOUCH_PAD_FILTER_IIR_4 = 0,
    TOUCH_PAD_FILTER_IIR_8 = 1,
    TOUCH_PAD_FILTER_IIR_16 = 2,
    TOUCH_PAD_FILTER_IIR_32 = 3,
    TOUCH_PAD_FILTER_IIR_64 = 4,
    TOUCH_PAD_FILTER_IIR_128 = 5,
    TOUCH_PAD_FILTER_IIR_256 = 6,
    TOUCH_PAD_FILTER_JITTER = 7,
    TOUCH_PAD_FILTER_MAX = 8,
};
pub const touch_smooth_mode_t = enum(c_uint) {
    TOUCH_PAD_SMOOTH_OFF = 0,
    TOUCH_PAD_SMOOTH_IIR_2 = 1,
    TOUCH_PAD_SMOOTH_IIR_4 = 2,
    TOUCH_PAD_SMOOTH_IIR_8 = 3,
    TOUCH_PAD_SMOOTH_MAX = 4,
};
pub const touch_filter_config = extern struct {
    mode: touch_filter_mode_t = std.mem.zeroes(touch_filter_mode_t),
    debounce_cnt: u32 = std.mem.zeroes(u32),
    noise_thr: u32 = std.mem.zeroes(u32),
    jitter_step: u32 = std.mem.zeroes(u32),
    smh_lvl: touch_smooth_mode_t = std.mem.zeroes(touch_smooth_mode_t),
};
pub const touch_filter_config_t = touch_filter_config;
pub const touch_pad_sleep_channel_t = extern struct {
    touch_num: touch_pad_t = std.mem.zeroes(touch_pad_t),
    en_proximity: bool = std.mem.zeroes(bool),
};

pub const RingbufHandle_t = ?*anyopaque;
pub const RingbufferType_t = enum(c_uint) {
    RINGBUF_TYPE_NOSPLIT = 0,
    RINGBUF_TYPE_ALLOWSPLIT = 1,
    RINGBUF_TYPE_u8BUF = 2,
    RINGBUF_TYPE_MAX = 3,
};
pub const uart_port_t = enum(c_uint) {
    UART_NUM_0 = 0,
    UART_NUM_1 = 1,
    UART_NUM_2 = 2,
    UART_NUM_MAX = 3,
};
pub const uart_mode_t = enum(c_uint) {
    UART_MODE_UART = 0,
    UART_MODE_RS485_HALF_DUPLEX = 1,
    UART_MODE_IRDA = 2,
    UART_MODE_RS485_COLLISION_DETECT = 3,
    UART_MODE_RS485_APP_CTRL = 4,
};
pub const uart_word_length_t = enum(c_uint) {
    UART_DATA_5_BITS = 0,
    UART_DATA_6_BITS = 1,
    UART_DATA_7_BITS = 2,
    UART_DATA_8_BITS = 3,
    UART_DATA_BITS_MAX = 4,
};
pub const uart_stop_bits_t = enum(c_uint) {
    UART_STOP_BITS_1 = 1,
    UART_STOP_BITS_1_5 = 2,
    UART_STOP_BITS_2 = 3,
    UART_STOP_BITS_MAX = 4,
};
pub const uart_parity_t = enum(c_uint) {
    UART_PARITY_DISABLE = 0,
    UART_PARITY_EVEN = 2,
    UART_PARITY_ODD = 3,
};
pub const uart_hw_flowcontrol_t = enum(c_uint) {
    UART_HW_FLOWCTRL_DISABLE = 0,
    UART_HW_FLOWCTRL_RTS = 1,
    UART_HW_FLOWCTRL_CTS = 2,
    UART_HW_FLOWCTRL_CTS_RTS = 3,
    UART_HW_FLOWCTRL_MAX = 4,
};
pub const uart_signal_inv_t = enum(c_uint) {
    UART_SIGNAL_INV_DISABLE = 0,
    UART_SIGNAL_IRDA_TX_INV = 1,
    UART_SIGNAL_IRDA_RX_INV = 2,
    UART_SIGNAL_RXD_INV = 4,
    UART_SIGNAL_CTS_INV = 8,
    UART_SIGNAL_DSR_INV = 16,
    UART_SIGNAL_TXD_INV = 32,
    UART_SIGNAL_RTS_INV = 64,
    UART_SIGNAL_DTR_INV = 128,
};
pub const soc_periph_uart_clk_src_legacy_t = enum(c_uint) {
    UART_SCLK_APB = 4,
    UART_SCLK_RTC = 8,
    UART_SCLK_XTAL = 10,
    UART_SCLK_DEFAULT = 4,
};
pub const uart_sclk_t = soc_periph_uart_clk_src_legacy_t;
pub const uart_at_cmd_t = extern struct {
    cmd_char: u8 = std.mem.zeroes(u8),
    char_num: u8 = std.mem.zeroes(u8),
    gap_tout: u32 = std.mem.zeroes(u32),
    pre_idle: u32 = std.mem.zeroes(u32),
    post_idle: u32 = std.mem.zeroes(u32),
};
pub const uart_sw_flowctrl_t = extern struct {
    xon_char: u8 = std.mem.zeroes(u8),
    xoff_char: u8 = std.mem.zeroes(u8),
    xon_thrd: u8 = std.mem.zeroes(u8),
    xoff_thrd: u8 = std.mem.zeroes(u8),
};
const union_unnamed_52 = extern union {
    source_clk: uart_sclk_t,
};
pub const uart_config_t = extern struct {
    baud_rate: c_int = std.mem.zeroes(c_int),
    data_bits: uart_word_length_t = std.mem.zeroes(uart_word_length_t),
    parity: uart_parity_t = std.mem.zeroes(uart_parity_t),
    stop_bits: uart_stop_bits_t = std.mem.zeroes(uart_stop_bits_t),
    flow_ctrl: uart_hw_flowcontrol_t = std.mem.zeroes(uart_hw_flowcontrol_t),
    rx_flow_ctrl_thresh: u8 = std.mem.zeroes(u8),
    unnamed_0: union_unnamed_52 = std.mem.zeroes(union_unnamed_52),
};
pub const uart_intr_config_t = extern struct {
    intr_enable_mask: u32 = std.mem.zeroes(u32),
    rx_timeout_thresh: u8 = std.mem.zeroes(u8),
    txfifo_empty_intr_thresh: u8 = std.mem.zeroes(u8),
    rxfifo_full_thresh: u8 = std.mem.zeroes(u8),
};
pub const uart_event_type_t = enum(c_uint) {
    UART_DATA = 0,
    UART_BREAK = 1,
    UART_BUFFER_FULL = 2,
    UART_FIFO_OVF = 3,
    UART_FRAME_ERR = 4,
    UART_PARITY_ERR = 5,
    UART_DATA_BREAK = 6,
    UART_PATTERN_DET = 7,
    UART_WAKEUP = 8,
    UART_EVENT_MAX = 9,
};
pub const uart_event_t = extern struct {
    type: uart_event_type_t = std.mem.zeroes(uart_event_type_t),
    size: usize = std.mem.zeroes(usize),
    timeout_flag: bool = std.mem.zeroes(bool),
};
pub const uart_isr_handle_t = intr_handle_t;
pub extern fn uart_driver_install(uart_num: uart_port_t, rx_buffer_size: c_int, tx_buffer_size: c_int, queue_size: c_int, uart_queue: [*c]QueueHandle_t, intr_alloc_flags: c_int) esp_err_t;
pub extern fn uart_driver_delete(uart_num: uart_port_t) esp_err_t;
pub extern fn uart_is_driver_installed(uart_num: uart_port_t) bool;
pub extern fn uart_set_word_length(uart_num: uart_port_t, data_bit: uart_word_length_t) esp_err_t;
pub extern fn uart_get_word_length(uart_num: uart_port_t, data_bit: [*c]uart_word_length_t) esp_err_t;
pub extern fn uart_set_stop_bits(uart_num: uart_port_t, stop_bits: uart_stop_bits_t) esp_err_t;
pub extern fn uart_get_stop_bits(uart_num: uart_port_t, stop_bits: [*c]uart_stop_bits_t) esp_err_t;
pub extern fn uart_set_parity(uart_num: uart_port_t, parity_mode: uart_parity_t) esp_err_t;
pub extern fn uart_get_parity(uart_num: uart_port_t, parity_mode: [*c]uart_parity_t) esp_err_t;
pub extern fn uart_get_sclk_freq(sclk: uart_sclk_t, out_freq_hz: [*c]u32) esp_err_t;
pub extern fn uart_set_baudrate(uart_num: uart_port_t, baudrate: u32) esp_err_t;
pub extern fn uart_get_baudrate(uart_num: uart_port_t, baudrate: [*c]u32) esp_err_t;
pub extern fn uart_set_line_inverse(uart_num: uart_port_t, inverse_mask: u32) esp_err_t;
pub extern fn uart_set_hw_flow_ctrl(uart_num: uart_port_t, flow_ctrl: uart_hw_flowcontrol_t, rx_thresh: u8) esp_err_t;
pub extern fn uart_set_sw_flow_ctrl(uart_num: uart_port_t, enable: bool, rx_thresh_xon: u8, rx_thresh_xoff: u8) esp_err_t;
pub extern fn uart_get_hw_flow_ctrl(uart_num: uart_port_t, flow_ctrl: [*c]uart_hw_flowcontrol_t) esp_err_t;
pub extern fn uart_clear_intr_status(uart_num: uart_port_t, clr_mask: u32) esp_err_t;
pub extern fn uart_enable_intr_mask(uart_num: uart_port_t, enable_mask: u32) esp_err_t;
pub extern fn uart_disable_intr_mask(uart_num: uart_port_t, disable_mask: u32) esp_err_t;
pub extern fn uart_enable_rx_intr(uart_num: uart_port_t) esp_err_t;
pub extern fn uart_disable_rx_intr(uart_num: uart_port_t) esp_err_t;
pub extern fn uart_disable_tx_intr(uart_num: uart_port_t) esp_err_t;
pub extern fn uart_enable_tx_intr(uart_num: uart_port_t, enable: c_int, thresh: c_int) esp_err_t;
pub extern fn uart_set_pin(uart_num: uart_port_t, tx_io_num: c_int, rx_io_num: c_int, rts_io_num: c_int, cts_io_num: c_int) esp_err_t;
pub extern fn uart_set_rts(uart_num: uart_port_t, level: c_int) esp_err_t;
pub extern fn uart_set_dtr(uart_num: uart_port_t, level: c_int) esp_err_t;
pub extern fn uart_set_tx_idle_num(uart_num: uart_port_t, idle_num: u16) esp_err_t;
pub extern fn uart_param_config(uart_num: uart_port_t, uart_config: [*c]const uart_config_t) esp_err_t;
pub extern fn uart_intr_config(uart_num: uart_port_t, intr_conf: [*c]const uart_intr_config_t) esp_err_t;
pub extern fn uart_wait_tx_done(uart_num: uart_port_t, ticks_to_wait: TickType_t) esp_err_t;
pub extern fn uart_tx_chars(uart_num: uart_port_t, buffer: [*:0]const u8, len: u32) c_int;
pub extern fn uart_write_bytes(uart_num: uart_port_t, src: ?*const anyopaque, size: usize) c_int;
pub extern fn uart_write_bytes_with_break(uart_num: uart_port_t, src: ?*const anyopaque, size: usize, brk_len: c_int) c_int;
pub extern fn uart_read_bytes(uart_num: uart_port_t, buf: ?*anyopaque, length: u32, ticks_to_wait: TickType_t) c_int;
pub extern fn uart_flush(uart_num: uart_port_t) esp_err_t;
pub extern fn uart_flush_input(uart_num: uart_port_t) esp_err_t;
pub extern fn uart_get_buffered_data_len(uart_num: uart_port_t, size: [*c]usize) esp_err_t;
pub extern fn uart_get_tx_buffer_free_size(uart_num: uart_port_t, size: [*c]usize) esp_err_t;
pub extern fn uart_disable_pattern_det_intr(uart_num: uart_port_t) esp_err_t;
pub extern fn uart_enable_pattern_det_baud_intr(uart_num: uart_port_t, pattern_chr: u8, chr_num: u8, chr_tout: c_int, post_idle: c_int, pre_idle: c_int) esp_err_t;
pub extern fn uart_pattern_pop_pos(uart_num: uart_port_t) c_int;
pub extern fn uart_pattern_get_pos(uart_num: uart_port_t) c_int;
pub extern fn uart_pattern_queue_reset(uart_num: uart_port_t, queue_length: c_int) esp_err_t;
pub extern fn uart_set_mode(uart_num: uart_port_t, mode: uart_mode_t) esp_err_t;
pub extern fn uart_set_rx_full_threshold(uart_num: uart_port_t, threshold: c_int) esp_err_t;
pub extern fn uart_set_tx_empty_threshold(uart_num: uart_port_t, threshold: c_int) esp_err_t;
pub extern fn uart_set_rx_timeout(uart_num: uart_port_t, tout_thresh: u8) esp_err_t;
pub extern fn uart_get_collision_flag(uart_num: uart_port_t, collision_flag: [*c]bool) esp_err_t;
pub extern fn uart_set_wakeup_threshold(uart_num: uart_port_t, wakeup_threshold: c_int) esp_err_t;
pub extern fn uart_get_wakeup_threshold(uart_num: uart_port_t, out_wakeup_threshold: [*c]c_int) esp_err_t;
pub extern fn uart_wait_tx_idle_polling(uart_num: uart_port_t) esp_err_t;
pub extern fn uart_set_loop_back(uart_num: uart_port_t, loop_back_en: bool) esp_err_t;
pub extern fn uart_set_always_rx_timeout(uart_num: uart_port_t, always_rx_timeout_en: bool) void;
const unnamed_53 = extern struct {
    rxfifo_rd_byte: u32 = std.mem.zeroes(u32),
};
pub const uart_fifo_reg_t = extern union {
    unnamed_0: unnamed_53,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:44:18: warning: struct demoted to opaque type - has bitfield
const unnamed_54 = opaque {};
pub const uart_mem_conf_reg_t = extern union {
    unnamed_0: unnamed_54,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:90:18: warning: struct demoted to opaque type - has bitfield
const unnamed_55 = opaque {};
pub const uart_int_raw_reg_t = extern union {
    unnamed_0: unnamed_55,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:199:18: warning: struct demoted to opaque type - has bitfield
const unnamed_56 = opaque {};
pub const uart_int_st_reg_t = extern union {
    unnamed_0: unnamed_56,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:294:18: warning: struct demoted to opaque type - has bitfield
const unnamed_57 = opaque {};
pub const uart_int_ena_reg_t = extern union {
    unnamed_0: unnamed_57,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:384:18: warning: struct demoted to opaque type - has bitfield
const unnamed_58 = opaque {};
pub const uart_int_clr_reg_t = extern union {
    unnamed_0: unnamed_58,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:476:18: warning: struct demoted to opaque type - has bitfield
const unnamed_59 = opaque {};
pub const uart_clkdiv_reg_t = extern union {
    unnamed_0: unnamed_59,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:495:18: warning: struct demoted to opaque type - has bitfield
const unnamed_60 = opaque {};
pub const uart_rx_filt_reg_t = extern union {
    unnamed_0: unnamed_60,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:513:18: warning: struct demoted to opaque type - has bitfield
const unnamed_61 = opaque {};
pub const uart_conf0_reg_t = extern union {
    unnamed_0: unnamed_61,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:638:18: warning: struct demoted to opaque type - has bitfield
const unnamed_62 = opaque {};
pub const uart_conf1_reg_t = extern union {
    unnamed_0: unnamed_62,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:674:18: warning: struct demoted to opaque type - has bitfield
const unnamed_63 = opaque {};
pub const uart_flow_conf_reg_t = extern union {
    unnamed_0: unnamed_63,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:709:18: warning: struct demoted to opaque type - has bitfield
const unnamed_64 = opaque {};
pub const uart_sleep_conf_reg_t = extern union {
    unnamed_0: unnamed_64,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:724:18: warning: struct demoted to opaque type - has bitfield
const unnamed_65 = opaque {};
pub const uart_swfc_conf0_reg_t = extern union {
    unnamed_0: unnamed_65,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:743:18: warning: struct demoted to opaque type - has bitfield
const unnamed_66 = opaque {};
pub const uart_swfc_conf1_reg_t = extern union {
    unnamed_0: unnamed_66,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:762:18: warning: struct demoted to opaque type - has bitfield
const unnamed_67 = opaque {};
pub const uart_txbrk_conf_reg_t = extern union {
    unnamed_0: unnamed_67,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:777:18: warning: struct demoted to opaque type - has bitfield
const unnamed_68 = opaque {};
pub const uart_idle_conf_reg_t = extern union {
    unnamed_0: unnamed_68,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:795:18: warning: struct demoted to opaque type - has bitfield
const unnamed_69 = opaque {};
pub const uart_rs485_conf_reg_t = extern union {
    unnamed_0: unnamed_69,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:834:18: warning: struct demoted to opaque type - has bitfield
const unnamed_70 = opaque {};
pub const uart_clk_conf_reg_t = extern union {
    unnamed_0: unnamed_70,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:886:18: warning: struct demoted to opaque type - has bitfield
const unnamed_71 = opaque {};
pub const uart_status_reg_t = extern union {
    unnamed_0: unnamed_71,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:930:18: warning: struct demoted to opaque type - has bitfield
const unnamed_72 = opaque {};
pub const uart_mem_tx_status_reg_t = extern union {
    unnamed_0: unnamed_72,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:951:18: warning: struct demoted to opaque type - has bitfield
const unnamed_73 = opaque {};
pub const uart_mem_rx_status_reg_t = extern union {
    unnamed_0: unnamed_73,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:971:18: warning: struct demoted to opaque type - has bitfield
const unnamed_74 = opaque {};
pub const uart_fsm_status_reg_t = extern union {
    unnamed_0: unnamed_74,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:992:18: warning: struct demoted to opaque type - has bitfield
const unnamed_75 = opaque {};
pub const uart_lowpulse_reg_t = extern union {
    unnamed_0: unnamed_75,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:1007:18: warning: struct demoted to opaque type - has bitfield
const unnamed_76 = opaque {};
pub const uart_highpulse_reg_t = extern union {
    unnamed_0: unnamed_76,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:1022:18: warning: struct demoted to opaque type - has bitfield
const unnamed_77 = opaque {};
pub const uart_rxd_cnt_reg_t = extern union {
    unnamed_0: unnamed_77,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:1037:18: warning: struct demoted to opaque type - has bitfield
const unnamed_78 = opaque {};
pub const uart_pospulse_reg_t = extern union {
    unnamed_0: unnamed_78,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:1052:18: warning: struct demoted to opaque type - has bitfield
const unnamed_79 = opaque {};
pub const uart_negpulse_reg_t = extern union {
    unnamed_0: unnamed_79,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:1069:18: warning: struct demoted to opaque type - has bitfield
const unnamed_80 = opaque {};
pub const uart_at_cmd_precnt_reg_t = extern union {
    unnamed_0: unnamed_80,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:1084:18: warning: struct demoted to opaque type - has bitfield
const unnamed_81 = opaque {};
pub const uart_at_cmd_postcnt_reg_t = extern union {
    unnamed_0: unnamed_81,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:1098:18: warning: struct demoted to opaque type - has bitfield
const unnamed_82 = opaque {};
pub const uart_at_cmd_gaptout_reg_t = extern union {
    unnamed_0: unnamed_82,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:1112:18: warning: struct demoted to opaque type - has bitfield
const unnamed_83 = opaque {};
pub const uart_at_cmd_char_reg_t = extern union {
    unnamed_0: unnamed_83,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:1133:18: warning: struct demoted to opaque type - has bitfield
const unnamed_84 = opaque {};
pub const uart_date_reg_t = extern union {
    unnamed_0: unnamed_84,
    val: u32,
}; // /espressif/esp-idf/components/soc/esp32s3/include/soc/uart_struct.h:1146:18: warning: struct demoted to opaque type - has bitfield
const unnamed_85 = opaque {};
pub const uart_id_reg_t = extern union {
    unnamed_0: unnamed_85,
    val: u32,
};
pub const uart_dev_t = extern struct {
    fifo: uart_fifo_reg_t = std.mem.zeroes(uart_fifo_reg_t),
    int_raw: uart_int_raw_reg_t = std.mem.zeroes(uart_int_raw_reg_t),
    int_st: uart_int_st_reg_t = std.mem.zeroes(uart_int_st_reg_t),
    int_ena: uart_int_ena_reg_t = std.mem.zeroes(uart_int_ena_reg_t),
    int_clr: uart_int_clr_reg_t = std.mem.zeroes(uart_int_clr_reg_t),
    clkdiv: uart_clkdiv_reg_t = std.mem.zeroes(uart_clkdiv_reg_t),
    rx_filt: uart_rx_filt_reg_t = std.mem.zeroes(uart_rx_filt_reg_t),
    status: uart_status_reg_t = std.mem.zeroes(uart_status_reg_t),
    conf0: uart_conf0_reg_t = std.mem.zeroes(uart_conf0_reg_t),
    conf1: uart_conf1_reg_t = std.mem.zeroes(uart_conf1_reg_t),
    lowpulse: uart_lowpulse_reg_t = std.mem.zeroes(uart_lowpulse_reg_t),
    highpulse: uart_highpulse_reg_t = std.mem.zeroes(uart_highpulse_reg_t),
    rxd_cnt: uart_rxd_cnt_reg_t = std.mem.zeroes(uart_rxd_cnt_reg_t),
    flow_conf: uart_flow_conf_reg_t = std.mem.zeroes(uart_flow_conf_reg_t),
    sleep_conf: uart_sleep_conf_reg_t = std.mem.zeroes(uart_sleep_conf_reg_t),
    swfc_conf0: uart_swfc_conf0_reg_t = std.mem.zeroes(uart_swfc_conf0_reg_t),
    swfc_conf1: uart_swfc_conf1_reg_t = std.mem.zeroes(uart_swfc_conf1_reg_t),
    txbrk_conf: uart_txbrk_conf_reg_t = std.mem.zeroes(uart_txbrk_conf_reg_t),
    idle_conf: uart_idle_conf_reg_t = std.mem.zeroes(uart_idle_conf_reg_t),
    rs485_conf: uart_rs485_conf_reg_t = std.mem.zeroes(uart_rs485_conf_reg_t),
    at_cmd_precnt: uart_at_cmd_precnt_reg_t = std.mem.zeroes(uart_at_cmd_precnt_reg_t),
    at_cmd_postcnt: uart_at_cmd_postcnt_reg_t = std.mem.zeroes(uart_at_cmd_postcnt_reg_t),
    at_cmd_gaptout: uart_at_cmd_gaptout_reg_t = std.mem.zeroes(uart_at_cmd_gaptout_reg_t),
    at_cmd_char: uart_at_cmd_char_reg_t = std.mem.zeroes(uart_at_cmd_char_reg_t),
    mem_conf: uart_mem_conf_reg_t = std.mem.zeroes(uart_mem_conf_reg_t),
    mem_tx_status: uart_mem_tx_status_reg_t = std.mem.zeroes(uart_mem_tx_status_reg_t),
    mem_rx_status: uart_mem_rx_status_reg_t = std.mem.zeroes(uart_mem_rx_status_reg_t),
    fsm_status: uart_fsm_status_reg_t = std.mem.zeroes(uart_fsm_status_reg_t),
    pospulse: uart_pospulse_reg_t = std.mem.zeroes(uart_pospulse_reg_t),
    negpulse: uart_negpulse_reg_t = std.mem.zeroes(uart_negpulse_reg_t),
    clk_conf: uart_clk_conf_reg_t = std.mem.zeroes(uart_clk_conf_reg_t),
    date: uart_date_reg_t = std.mem.zeroes(uart_date_reg_t),
    id: uart_id_reg_t = std.mem.zeroes(uart_id_reg_t),
};

const unnamed_11 = opaque {};
const union_unnamed_10 = extern union {
    unnamed_0: unnamed_11,
    val: u32,
}; // /esp-idf/components/soc/esp32s3/include/soc/gpio_struct.h:30:22: warning: struct demoted to opaque type - has bitfield
const unnamed_13 = opaque {};
const union_unnamed_12 = extern union {
    unnamed_0: unnamed_13,
    val: u32,
}; // /esp-idf/components/soc/esp32s3/include/soc/gpio_struct.h:37:22: warning: struct demoted to opaque type - has bitfield
const unnamed_115 = opaque {};
const union_unnamed_14 = extern union {
    unnamed_0: unnamed_115,
    val: u32,
}; // /esp-idf/components/soc/esp32s3/include/soc/gpio_struct.h:44:22: warning: struct demoted to opaque type - has bitfield
const unnamed_17 = opaque {};
const union_unnamed_16 = extern union {
    unnamed_0: unnamed_17,
    val: u32,
}; // /esp-idf/components/soc/esp32s3/include/soc/gpio_struct.h:54:22: warning: struct demoted to opaque type - has bitfield
const unnamed_19 = opaque {};
const union_unnamed_18 = extern union {
    unnamed_0: unnamed_19,
    val: u32,
}; // /esp-idf/components/soc/esp32s3/include/soc/gpio_struct.h:61:22: warning: struct demoted to opaque type - has bitfield
const unnamed_21 = opaque {};
const union_unnamed_20 = extern union {
    unnamed_0: unnamed_21,
    val: u32,
}; // /esp-idf/components/soc/esp32s3/include/soc/gpio_struct.h:68:22: warning: struct demoted to opaque type - has bitfield
const unnamed_23 = opaque {};
const union_unnamed_22 = extern union {
    unnamed_0: unnamed_23,
    val: u32,
}; // /esp-idf/components/soc/esp32s3/include/soc/gpio_struct.h:75:22: warning: struct demoted to opaque type - has bitfield
const unnamed_25 = opaque {};
const union_unnamed_24 = extern union {
    unnamed_0: unnamed_25,
    val: u32,
}; // /esp-idf/components/soc/esp32s3/include/soc/gpio_struct.h:83:22: warning: struct demoted to opaque type - has bitfield
const unnamed_27 = opaque {};
const union_unnamed_26 = extern union {
    unnamed_0: unnamed_27,
    val: u32,
}; // /esp-idf/components/soc/esp32s3/include/soc/gpio_struct.h:93:22: warning: struct demoted to opaque type - has bitfield
const unnamed_29 = opaque {};
const union_unnamed_28 = extern union {
    unnamed_0: unnamed_29,
    val: u32,
}; // /esp-idf/components/soc/esp32s3/include/soc/gpio_struct.h:100:22: warning: struct demoted to opaque type - has bitfield
const unnamed_31 = opaque {};
const union_unnamed_30 = extern union {
    unnamed_0: unnamed_31,
    val: u32,
}; // /esp-idf/components/soc/esp32s3/include/soc/gpio_struct.h:107:22: warning: struct demoted to opaque type - has bitfield
const unnamed_33 = opaque {};
const union_unnamed_32 = extern union {
    unnamed_0: unnamed_33,
    val: u32,
}; // /esp-idf/components/soc/esp32s3/include/soc/gpio_struct.h:117:22: warning: struct demoted to opaque type - has bitfield
const unnamed_35 = opaque {};
const union_unnamed_34 = extern union {
    unnamed_0: unnamed_35,
    val: u32,
}; // /esp-idf/components/soc/esp32s3/include/soc/gpio_struct.h:124:22: warning: struct demoted to opaque type - has bitfield
const unnamed_37 = opaque {};
const union_unnamed_36 = extern union {
    unnamed_0: unnamed_37,
    val: u32,
}; // /esp-idf/components/soc/esp32s3/include/soc/gpio_struct.h:131:22: warning: struct demoted to opaque type - has bitfield
const unnamed_39 = opaque {};
const union_unnamed_38 = extern union {
    unnamed_0: unnamed_39,
    val: u32,
}; // /esp-idf/components/soc/esp32s3/include/soc/gpio_struct.h:138:22: warning: struct demoted to opaque type - has bitfield
const unnamed_41 = opaque {};
const union_unnamed_40 = extern union {
    unnamed_0: unnamed_41,
    val: u32,
}; // /esp-idf/components/soc/esp32s3/include/soc/gpio_struct.h:153:22: warning: struct demoted to opaque type - has bitfield
const unnamed_43 = opaque {};
const union_unnamed_42 = extern union {
    unnamed_0: unnamed_43,
    val: u32,
}; // /esp-idf/components/soc/esp32s3/include/soc/gpio_struct.h:160:22: warning: struct demoted to opaque type - has bitfield
const unnamed_45 = opaque {};
const union_unnamed_44 = extern union {
    unnamed_0: unnamed_45,
    val: u32,
}; // /esp-idf/components/soc/esp32s3/include/soc/gpio_struct.h:169:22: warning: struct demoted to opaque type - has bitfield
const unnamed_47 = opaque {};
const union_unnamed_46 = extern union {
    unnamed_0: unnamed_47,
    val: u32,
}; // /esp-idf/components/soc/esp32s3/include/soc/gpio_struct.h:179:22: warning: struct demoted to opaque type - has bitfield
const unnamed_49 = opaque {};
const union_unnamed_48 = extern union {
    unnamed_0: unnamed_49,
    val: u32,
}; // /esp-idf/components/soc/esp32s3/include/soc/gpio_struct.h:237:22: warning: struct demoted to opaque type - has bitfield
const unnamed_51 = opaque {};
const union_unnamed_50 = extern union {
    unnamed_0: unnamed_51,
    val: u32,
};
pub const gpio_dev_t = extern struct {
    bt_select: u32 = std.mem.zeroes(u32),
    out: u32 = std.mem.zeroes(u32),
    out_w1ts: u32 = std.mem.zeroes(u32),
    out_w1tc: u32 = std.mem.zeroes(u32),
    out1: union_unnamed_10 = std.mem.zeroes(union_unnamed_10),
    out1_w1ts: union_unnamed_12 = std.mem.zeroes(union_unnamed_12),
    out1_w1tc: union_unnamed_14 = std.mem.zeroes(union_unnamed_14),
    sdio_select: union_unnamed_16 = std.mem.zeroes(union_unnamed_16),
    enable: u32 = std.mem.zeroes(u32),
    enable_w1ts: u32 = std.mem.zeroes(u32),
    enable_w1tc: u32 = std.mem.zeroes(u32),
    enable1: union_unnamed_18 = std.mem.zeroes(union_unnamed_18),
    enable1_w1ts: union_unnamed_20 = std.mem.zeroes(union_unnamed_20),
    enable1_w1tc: union_unnamed_22 = std.mem.zeroes(union_unnamed_22),
    strap: union_unnamed_24 = std.mem.zeroes(union_unnamed_24),
    in: u32 = std.mem.zeroes(u32),
    in1: union_unnamed_26 = std.mem.zeroes(union_unnamed_26),
    status: u32 = std.mem.zeroes(u32),
    status_w1ts: u32 = std.mem.zeroes(u32),
    status_w1tc: u32 = std.mem.zeroes(u32),
    status1: union_unnamed_28 = std.mem.zeroes(union_unnamed_28),
    status1_w1ts: union_unnamed_30 = std.mem.zeroes(union_unnamed_30),
    status1_w1tc: union_unnamed_32 = std.mem.zeroes(union_unnamed_32),
    pcpu_int: u32 = std.mem.zeroes(u32),
    pcpu_nmi_int: u32 = std.mem.zeroes(u32),
    cpusdio_int: u32 = std.mem.zeroes(u32),
    pcpu_int1: union_unnamed_34 = std.mem.zeroes(union_unnamed_34),
    pcpu_nmi_int1: union_unnamed_36 = std.mem.zeroes(union_unnamed_36),
    cpusdio_int1: union_unnamed_38 = std.mem.zeroes(union_unnamed_38),
    pin: [54]union_unnamed_40 = std.mem.zeroes([54]union_unnamed_40),
    status_next: u32 = std.mem.zeroes(u32),
    status_next1: union_unnamed_42 = std.mem.zeroes(union_unnamed_42),
    func_in_sel_cfg: [256]union_unnamed_44 = std.mem.zeroes([256]union_unnamed_44),
    func_out_sel_cfg: [54]union_unnamed_46 = std.mem.zeroes([54]union_unnamed_46),
    clock_gate: union_unnamed_48 = std.mem.zeroes(union_unnamed_48),
    reserved_630: u32 = std.mem.zeroes(u32),
    reserved_634: u32 = std.mem.zeroes(u32),
    reserved_638: u32 = std.mem.zeroes(u32),
    reserved_63c: u32 = std.mem.zeroes(u32),
    reserved_640: u32 = std.mem.zeroes(u32),
    reserved_644: u32 = std.mem.zeroes(u32),
    reserved_648: u32 = std.mem.zeroes(u32),
    reserved_64c: u32 = std.mem.zeroes(u32),
    reserved_650: u32 = std.mem.zeroes(u32),
    reserved_654: u32 = std.mem.zeroes(u32),
    reserved_658: u32 = std.mem.zeroes(u32),
    reserved_65c: u32 = std.mem.zeroes(u32),
    reserved_660: u32 = std.mem.zeroes(u32),
    reserved_664: u32 = std.mem.zeroes(u32),
    reserved_668: u32 = std.mem.zeroes(u32),
    reserved_66c: u32 = std.mem.zeroes(u32),
    reserved_670: u32 = std.mem.zeroes(u32),
    reserved_674: u32 = std.mem.zeroes(u32),
    reserved_678: u32 = std.mem.zeroes(u32),
    reserved_67c: u32 = std.mem.zeroes(u32),
    reserved_680: u32 = std.mem.zeroes(u32),
    reserved_684: u32 = std.mem.zeroes(u32),
    reserved_688: u32 = std.mem.zeroes(u32),
    reserved_68c: u32 = std.mem.zeroes(u32),
    reserved_690: u32 = std.mem.zeroes(u32),
    reserved_694: u32 = std.mem.zeroes(u32),
    reserved_698: u32 = std.mem.zeroes(u32),
    reserved_69c: u32 = std.mem.zeroes(u32),
    reserved_6a0: u32 = std.mem.zeroes(u32),
    reserved_6a4: u32 = std.mem.zeroes(u32),
    reserved_6a8: u32 = std.mem.zeroes(u32),
    reserved_6ac: u32 = std.mem.zeroes(u32),
    reserved_6b0: u32 = std.mem.zeroes(u32),
    reserved_6b4: u32 = std.mem.zeroes(u32),
    reserved_6b8: u32 = std.mem.zeroes(u32),
    reserved_6bc: u32 = std.mem.zeroes(u32),
    reserved_6c0: u32 = std.mem.zeroes(u32),
    reserved_6c4: u32 = std.mem.zeroes(u32),
    reserved_6c8: u32 = std.mem.zeroes(u32),
    reserved_6cc: u32 = std.mem.zeroes(u32),
    reserved_6d0: u32 = std.mem.zeroes(u32),
    reserved_6d4: u32 = std.mem.zeroes(u32),
    reserved_6d8: u32 = std.mem.zeroes(u32),
    reserved_6dc: u32 = std.mem.zeroes(u32),
    reserved_6e0: u32 = std.mem.zeroes(u32),
    reserved_6e4: u32 = std.mem.zeroes(u32),
    reserved_6e8: u32 = std.mem.zeroes(u32),
    reserved_6ec: u32 = std.mem.zeroes(u32),
    reserved_6f0: u32 = std.mem.zeroes(u32),
    reserved_6f4: u32 = std.mem.zeroes(u32),
    reserved_6f8: u32 = std.mem.zeroes(u32),
    date: union_unnamed_50 = std.mem.zeroes(union_unnamed_50),
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
    GPIO_NUM_40 = 40,
    GPIO_NUM_41 = 41,
    GPIO_NUM_42 = 42,
    GPIO_NUM_43 = 43,
    GPIO_NUM_44 = 44,
    GPIO_NUM_45 = 45,
    GPIO_NUM_46 = 46,
    GPIO_NUM_47 = 47,
    GPIO_NUM_48 = 48,
    GPIO_NUM_MAX = 49,
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
const unnamed_3 = enum(c_uint) {
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
pub extern fn spinlock_initialize(lock: [*c]spinlock_t) void; // esp-idf/components/newlib/platform_include/assert.h:30:23: warning: TODO implement function '__builtin_strrchr' in std.zig.c_builtins
// esp-idf/components/esp_hw_support/include/spinlock.h:74:51: warning: unable to translate function, demoted to extern
pub extern fn spinlock_acquire(lock: [*c]spinlock_t, timeout: i32) bool; // esp-idf/components/newlib/platform_include/assert.h:30:23: warning: TODO implement function '__builtin_strrchr' in std.zig.c_builtins
// esp-idf/components/esp_hw_support/include/spinlock.h:172:51: warning: unable to translate function, demoted to extern
pub extern fn spinlock_release(lock: [*c]spinlock_t) void;
pub extern fn esp_crosscore_int_init() void;
pub extern fn esp_crosscore_int_send_yield(core_id: c_int) void;
pub extern fn esp_crosscore_int_send_freq_switch(core_id: c_int) void;
pub extern fn esp_crosscore_int_send_gdb_call(core_id: c_int) void;
pub extern fn esp_crosscore_int_send_print_backtrace(core_id: c_int) void;
pub extern fn esp_crosscore_int_send_twdt_abort(core_id: c_int) void; // /.espressif/tools/xtensa-esp-elf/esp-13.2.0_20230928/xtensa-esp-elf/xtensa-esp-elf/include/assert.h:45:24: warning: ignoring StaticAssert declaration
// /.espressif/tools/xtensa-esp-elf/esp-13.2.0_20230928/xtensa-esp-elf/xtensa-esp-elf/include/assert.h:45:24: warning: ignoring StaticAssert declaration
pub inline fn esp_dram_match_iram() bool {
    return (@as(c_int, 1073405952) == @as(c_int, 1074266112)) and (@as(c_int, 1073741824) == @as(c_int, 1074438144));
}
pub inline fn esp_ptr_in_iram(p: ?*const anyopaque) bool {
    return (@as(isize, @intCast(@intFromPtr(p))) >= @as(c_int, 1074266112)) and (@as(isize, @intCast(@intFromPtr(p))) < @as(c_int, 1074438144));
}
pub inline fn esp_ptr_in_dram(p: ?*const anyopaque) bool {
    return (@as(isize, @intCast(@intFromPtr(p))) >= @as(c_int, 1073405952)) and (@as(isize, @intCast(@intFromPtr(p))) < @as(c_int, 1073741824));
}
pub inline fn esp_ptr_in_diram_dram(p: ?*const anyopaque) bool {
    return (@as(isize, @intCast(@intFromPtr(p))) >= @as(c_int, 1073610752)) and (@as(isize, @intCast(@intFromPtr(p))) < @as(c_int, 1073741824));
}
pub inline fn esp_ptr_in_diram_iram(p: ?*const anyopaque) bool {
    return (@as(isize, @intCast(@intFromPtr(p))) >= @as(c_int, 1074397184)) and (@as(isize, @intCast(@intFromPtr(p))) < @as(c_int, 1074528256));
}
pub inline fn esp_ptr_in_rtc_iram_fast(p: ?*const anyopaque) bool {
    return (@as(isize, @intCast(@intFromPtr(p))) >= @as(c_int, 1074528256)) and (@as(isize, @intCast(@intFromPtr(p))) < @as(c_int, 1074536448));
}
pub inline fn esp_ptr_in_rtc_dram_fast(p: ?*const anyopaque) bool {
    return (@as(isize, @intCast(@intFromPtr(p))) >= @as(c_int, 1073217536)) and (@as(isize, @intCast(@intFromPtr(p))) < @as(c_int, 1073225728));
}
pub inline fn esp_ptr_in_rtc_slow(p: ?*const anyopaque) bool {
    return (@as(isize, @intCast(@intFromPtr(p))) >= @as(c_int, 1342177280)) and (@as(isize, @intCast(@intFromPtr(p))) < @as(c_int, 1342185472));
}
pub inline fn esp_ptr_diram_dram_to_iram(p: ?*const anyopaque) ?*anyopaque {
    return @as(?*anyopaque, @ptrFromInt((@as(c_int, 1074397184) + (@as(c_int, 1073741824) - @as(isize, @intCast(@intFromPtr(p))))) - @as(c_int, 4)));
}
pub inline fn esp_ptr_diram_iram_to_dram(p: ?*const anyopaque) ?*anyopaque {
    return @as(?*anyopaque, @ptrFromInt((@as(c_int, 1073610752) + (@as(c_int, 1074528256) - @as(isize, @intCast(@intFromPtr(p))))) - @as(c_int, 4)));
}
pub inline fn esp_ptr_dma_capable(p: ?*const anyopaque) bool {
    return (@as(isize, @intCast(@intFromPtr(p))) >= @as(c_int, 1073405952)) and (@as(isize, @intCast(@intFromPtr(p))) < @as(c_int, 1073741824));
}
pub extern fn esp_ptr_dma_ext_capable(p: ?*const anyopaque) bool;
pub inline fn esp_ptr_word_aligned(p: ?*const anyopaque) bool {
    return std.zig.c_translation.signedRemainder(@as(isize, @intCast(@intFromPtr(p))), @as(c_int, 4)) == @as(c_int, 0);
}
pub inline fn esp_ptr_executable(p: ?*const anyopaque) bool {
    var ip: isize = @as(isize, @intCast(@intFromPtr(p)));
    _ = &ip;
    return ((((ip >= @as(c_int, 1074593792)) and (ip < @as(c_int, 1077936128))) or ((ip >= @as(c_int, 1074266112)) and (ip < @as(c_int, 1074438144)))) or ((ip >= @as(c_int, 1073741824)) and (ip < @as(c_int, 1074200576)))) or ((ip >= @as(c_int, 1074528256)) and (ip < @as(c_int, 1074536448)));
}
pub extern fn esp_ptr_byte_accessible(p: ?*const anyopaque) bool;
pub inline fn esp_ptr_internal(p: ?*const anyopaque) bool {
    var r: bool = undefined;
    _ = &r;
    r = (@as(isize, @intCast(@intFromPtr(p))) >= @as(c_int, 1073283072)) and (@as(isize, @intCast(@intFromPtr(p))) < @as(c_int, 1074536448));
    r |= @as(bool, (@as(isize, @intCast(@intFromPtr(p))) >= @as(c_int, 1342177280)) and (@as(isize, @intCast(@intFromPtr(p))) < @as(c_int, 1342185472)));
    return r;
}
pub extern fn esp_ptr_external_ram(p: ?*const anyopaque) bool;
pub inline fn esp_ptr_in_drom(p: ?*const anyopaque) bool {
    var drom_start_addr: i32 = 1061158912;
    _ = &drom_start_addr;
    return (@as(isize, @intCast(@intFromPtr(p))) >= drom_start_addr) and (@as(isize, @intCast(@intFromPtr(p))) < @as(c_int, 1065353216));
}
pub inline fn esp_stack_ptr_in_dram(sp: u32) bool {
    return !(((sp < @as(u32, @bitCast(@as(c_int, 1073405952) + @as(c_int, 16)))) or (sp > @as(u32, @bitCast(@as(c_int, 1073741824) - @as(c_int, 16))))) or ((sp & @as(u32, @bitCast(@as(c_int, 15)))) != @as(u32, @bitCast(@as(c_int, 0)))));
}
pub inline fn esp_stack_ptr_is_sane(sp: u32) bool {
    return esp_stack_ptr_in_dram(sp);
}
pub extern fn esp_newlib_time_init() void;
pub const _reent = opaque {};
pub extern fn esp_reent_init(r: ?*_reent) void;
pub extern fn esp_newlib_init_global_stdio(stdio_dev: [*:0]const u8) void;
pub extern fn esp_reent_cleanup() void;
pub extern fn esp_newlib_init() void;
pub extern fn esp_setup_syscall_table() void;
pub extern fn esp_set_time_from_rtc() void;
pub extern fn esp_sync_timekeeping_timers() void;
pub extern fn esp_newlib_locks_init() void;
pub const multi_heap_info = extern struct {
    lock: ?*anyopaque = null,
    free_bytes: usize = std.mem.zeroes(usize),
    minimum_free_bytes: usize = std.mem.zeroes(usize),
    pool_size: usize = std.mem.zeroes(usize),
    heap_data: ?*anyopaque = null,
};
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
pub extern fn heap_caps_dump(caps: Caps) void;
pub extern fn heap_caps_dump_all() void;
pub extern fn heap_caps_get_allocated_size(ptr: ?*anyopaque) usize;
pub const StackType_t = u8;
pub const BaseType_t = c_int;
pub const UBaseType_t = c_uint;
pub const TickType_t = u32;
pub extern fn xPortInIsrContext() BaseType_t;
pub extern fn vPortAssertIfInISR() void;
pub extern fn xPortInterruptedFromISRContext() BaseType_t;
// esp-idf/components/xtensa/include/xtensa/xtruntime.h:92:4: warning: TODO implement translation of stmt class GCCAsmStmtClass
// esp-idf/components/freertos/FreeRTOS-Kernel/portable/xtensa/include/freertos/portmacro.h:554:58: warning: unable to translate function, demoted to extern
pub extern fn xPortSetInterruptMaskFromISR() UBaseType_t;
pub inline fn vPortClearInterruptMaskFromISR(prev_level: UBaseType_t) void {
    _ = _xtos_set_intlevel(@as(c_int, @bitCast(prev_level)));
}
pub const portMUX_TYPE = spinlock_t;
pub extern fn xPortEnterCriticalTimeout(mux: [*c]portMUX_TYPE, timeout: BaseType_t) BaseType_t;
pub inline fn vPortEnterCritical(mux: [*c]portMUX_TYPE) void {
    _ = xPortEnterCriticalTimeout(mux, -@as(c_int, 1));
}
pub extern fn vPortExitCritical(mux: [*c]portMUX_TYPE) void;
pub extern fn xPortEnterCriticalTimeoutCompliance(mux: [*c]portMUX_TYPE, timeout: BaseType_t) BaseType_t;
pub inline fn vPortEnterCriticalCompliance(mux: [*c]portMUX_TYPE) void {
    _ = xPortEnterCriticalTimeoutCompliance(mux, -@as(c_int, 1));
}
pub extern fn vPortExitCriticalCompliance(mux: [*c]portMUX_TYPE) void;
pub inline fn xPortEnterCriticalTimeoutSafe(mux: [*c]portMUX_TYPE, timeout: BaseType_t) BaseType_t {
    var ret: BaseType_t = undefined;
    if (xPortInIsrContext() != 0) {
        ret = xPortEnterCriticalTimeout(mux, timeout);
    } else {
        ret = xPortEnterCriticalTimeout(mux, timeout);
    }
    return ret;
}
pub inline fn vPortEnterCriticalSafe(mux: [*c]portMUX_TYPE) void {
    _ = xPortEnterCriticalTimeoutSafe(mux, -@as(c_int, 1));
}
pub inline fn vPortExitCriticalSafe(mux: [*c]portMUX_TYPE) void {
    if (xPortInIsrContext() != 0) {
        vPortExitCritical(mux);
    } else {
        vPortExitCritical(mux);
    }
}
pub extern fn vPortYield() void;
pub extern fn vPortYieldOtherCore(coreid: BaseType_t) void;
// esp-idf/components/xtensa/include/xt_instr_macros.h:11:30: warning: TODO implement translation of stmt class GCCAsmStmtClass
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
    pvDummy3: ?*anyopaque = null,
    xDummy4: StaticMiniListItem_t = std.mem.zeroes(StaticMiniListItem_t),
};
pub const StaticList_t = xSTATIC_LIST;
pub const xSTATIC_TCB = extern struct {
    pxDummy1: ?*anyopaque = null,
    xDummy3: [2]StaticListItem_t = std.mem.zeroes([2]StaticListItem_t),
    uxDummy5: UBaseType_t = std.mem.zeroes(UBaseType_t),
    pxDummy6: ?*anyopaque = null,
    xDummy23: [2]BaseType_t = std.mem.zeroes([2]BaseType_t),
    ucDummy7: [16]u8 = std.mem.zeroes([16]u8),
    pxDummy8: ?*anyopaque = null,
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
    pvDummy7: ?*anyopaque = null,
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
    pvDummy1: ?*anyopaque = null,
    xDummy2: StaticListItem_t = std.mem.zeroes(StaticListItem_t),
    xDummy3: TickType_t = std.mem.zeroes(TickType_t),
    pvDummy5: ?*anyopaque = null,
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
    pvOwner: ?*anyopaque = null,
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
pub const eTaskState = enum(c_uint) {
    eRunning = 0,
    eReady = 1,
    eBlocked = 2,
    eSuspended = 3,
    eDeleted = 4,
    eInvalid = 5,
};
pub const eNotifyAction = enum(c_uint) {
    eNoAction = 0,
    eSetBits = 1,
    eIncrement = 2,
    eSetValueWithOverwrite = 3,
    eSetValueWithoutOverwrite = 4,
};
pub const xTIME_OUT = extern struct {
    xOverflowCount: BaseType_t = std.mem.zeroes(BaseType_t),
    xTimeOnEntering: TickType_t = std.mem.zeroes(TickType_t),
};
pub const TimeOut_t = xTIME_OUT;
pub const xMEMORY_REGION = extern struct {
    pvBaseAddress: ?*anyopaque = null,
    ulLengthInBytes: u32 = std.mem.zeroes(u32),
    ulParameters: u32 = std.mem.zeroes(u32),
};
pub const MemoryRegion_t = xMEMORY_REGION;
pub const xTASK_PARAMETERS = extern struct {
    pvTaskCode: TaskFunction_t = std.mem.zeroes(TaskFunction_t),
    pcName: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    usStackDepth: u32 = std.mem.zeroes(u32),
    pvParameters: ?*anyopaque = null,
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
pub const eSleepModeStatus = enum(c_uint) {
    eAbortSleep = 0,
    eStandardSleep = 1,
    eNoTasksWaitingTimeout = 2,
};
pub extern fn xTaskCreatePinnedToCore(pxTaskCode: TaskFunction_t, pcName: [*:0]const u8, usStackDepth: u32, pvParameters: ?*anyopaque, uxPriority: UBaseType_t, pvCreatedTask: [*c]TaskHandle_t, xCoreID: BaseType_t) BaseType_t;
pub inline fn xTaskCreate(pxTaskCode: TaskFunction_t, pcName: [*:0]const u8, usStackDepth: u32, pvParameters: ?*anyopaque, uxPriority: UBaseType_t, pxCreatedTask: [*c]TaskHandle_t) BaseType_t {
    return xTaskCreatePinnedToCore(pxTaskCode, pcName, usStackDepth, pvParameters, uxPriority, pxCreatedTask, @as(BaseType_t, @bitCast(@as(c_int, 2147483647))));
}
pub extern fn xTaskCreateStaticPinnedToCore(pxTaskCode: TaskFunction_t, pcName: [*:0]const u8, ulStackDepth: u32, pvParameters: ?*anyopaque, uxPriority: UBaseType_t, pxStackBuffer: [*c]StackType_t, pxTaskBuffer: [*c]StaticTask_t, xCoreID: BaseType_t) TaskHandle_t;
pub inline fn xTaskCreateStatic(pxTaskCode: TaskFunction_t, pcName: [*:0]const u8, ulStackDepth: u32, pvParameters: ?*anyopaque, uxPriority: UBaseType_t, puxStackBuffer: [*c]StackType_t, pxTaskBuffer: [*c]StaticTask_t) TaskHandle_t {
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
pub fn Atomic_CompareAndSwap_u32(pulDestination: [*c]volatile u32, ulExchange: u32, ulComparand: u32) callconv(.C) u32 {
    var ulReturnValue: u32 = 0;
    const uxCriticalSectionType: UBaseType_t = xPortSetInterruptMaskFromISR();
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
pub fn Atomic_SwapPointers_p32(ppvDestination: [*c]volatile ?*anyopaque, pvExchange: ?*anyopaque) callconv(.C) ?*anyopaque {
    var pReturnValue: ?*anyopaque = null;
    const uxCriticalSectionType: UBaseType_t = xPortSetInterruptMaskFromISR();
    {
        pReturnValue = ppvDestination.*;
        ppvDestination.* = pvExchange;
    }
    vPortClearInterruptMaskFromISR(uxCriticalSectionType);
    return pReturnValue;
}
pub fn Atomic_CompareAndSwapPointers_p32(ppvDestination: [*c]volatile ?*anyopaque, pvExchange: ?*anyopaque, pvComparand: ?*anyopaque) callconv(.C) u32 {
    var ulReturnValue: u32 = 0;
    const uxCriticalSectionType: UBaseType_t = xPortSetInterruptMaskFromISR();
    {
        if (ppvDestination.* == pvComparand) {
            ppvDestination.* = pvExchange;
            ulReturnValue = 1;
        }
    }
    vPortClearInterruptMaskFromISR(uxCriticalSectionType);
    return ulReturnValue;
}
pub fn Atomic_Add_u32(pulAddend: [*c]volatile u32, ulCount: u32) callconv(.C) u32 {
    var ulCurrent: u32 = 0;
    const uxCriticalSectionType: UBaseType_t = xPortSetInterruptMaskFromISR();
    {
        ulCurrent = pulAddend.*;
        pulAddend.* +%= @as(u32, @bitCast(ulCount));
    }
    vPortClearInterruptMaskFromISR(uxCriticalSectionType);
    return ulCurrent;
}
pub fn Atomic_Subtract_u32(pulAddend: [*c]volatile u32, ulCount: u32) callconv(.C) u32 {
    var ulCurrent: u32 = 0;
    const uxCriticalSectionType: UBaseType_t = xPortSetInterruptMaskFromISR();
    {
        ulCurrent = pulAddend.*;
        pulAddend.* -%= @as(u32, @bitCast(ulCount));
    }
    vPortClearInterruptMaskFromISR(uxCriticalSectionType);
    return ulCurrent;
}
pub fn Atomic_Increment_u32(pulAddend: [*c]volatile u32) callconv(.C) u32 {
    var ulCurrent: u32 = 0;
    const uxCriticalSectionType: UBaseType_t = xPortSetInterruptMaskFromISR();
    {
        ulCurrent = pulAddend.*;
        pulAddend.* +%= @as(u32, @bitCast(@as(u32, @bitCast(@as(c_int, 1)))));
    }
    vPortClearInterruptMaskFromISR(uxCriticalSectionType);
    return ulCurrent;
}
pub fn Atomic_Decrement_u32(pulAddend: [*c]volatile u32) callconv(.C) u32 {
    var ulCurrent: u32 = 0;
    const uxCriticalSectionType: UBaseType_t = xPortSetInterruptMaskFromISR();
    {
        ulCurrent = pulAddend.*;
        pulAddend.* -%= @as(u32, @bitCast(@as(u32, @bitCast(@as(c_int, 1)))));
    }
    vPortClearInterruptMaskFromISR(uxCriticalSectionType);
    return ulCurrent;
}
pub fn Atomic_OR_u32(pulDestination: [*c]volatile u32, ulValue: u32) callconv(.C) u32 {
    var ulCurrent: u32 = 0;
    const uxCriticalSectionType: UBaseType_t = xPortSetInterruptMaskFromISR();
    {
        ulCurrent = pulDestination.*;
        pulDestination.* |= @as(u32, @bitCast(ulValue));
    }
    vPortClearInterruptMaskFromISR(uxCriticalSectionType);
    return ulCurrent;
}
pub fn Atomic_AND_u32(pulDestination: [*c]volatile u32, ulValue: u32) callconv(.C) u32 {
    var ulCurrent: u32 = 0;
    const uxCriticalSectionType: UBaseType_t = xPortSetInterruptMaskFromISR();
    {
        ulCurrent = pulDestination.*;
        pulDestination.* &= @as(u32, @bitCast(ulValue));
    }
    vPortClearInterruptMaskFromISR(uxCriticalSectionType);
    return ulCurrent;
}
pub fn Atomic_NAND_u32(pulDestination: [*c]volatile u32, ulValue: u32) callconv(.C) u32 {
    var ulCurrent: u32 = 0;
    const uxCriticalSectionType: UBaseType_t = xPortSetInterruptMaskFromISR();
    {
        ulCurrent = pulDestination.*;
        pulDestination.* = ~(ulCurrent & ulValue);
    }
    vPortClearInterruptMaskFromISR(uxCriticalSectionType);
    return ulCurrent;
}
pub fn Atomic_XOR_u32(pulDestination: [*c]volatile u32, ulValue: u32) callconv(.C) u32 {
    var ulCurrent: u32 = 0;
    const uxCriticalSectionType: UBaseType_t = xPortSetInterruptMaskFromISR();
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
pub const queueSEND_TO_BACK = std.zig.c_translation.cast(BaseType_t, @as(c_int, 0));
pub const queueSEND_TO_FRONT = std.zig.c_translation.cast(BaseType_t, @as(c_int, 1));
pub const queueOVERWRITE = std.zig.c_translation.cast(BaseType_t, @as(c_int, 2));
pub const queueQUEUE_TYPE_BASE = std.zig.c_translation.cast(u8, @as(c_uint, 0));
pub const queueQUEUE_TYPE_SET = std.zig.c_translation.cast(u8, @as(c_uint, 0));
pub const queueQUEUE_TYPE_MUTEX = std.zig.c_translation.cast(u8, @as(c_uint, 1));
pub const queueQUEUE_TYPE_COUNTING_SEMAPHORE = std.zig.c_translation.cast(u8, @as(c_uint, 2));
pub const queueQUEUE_TYPE_BINARY_SEMAPHORE = std.zig.c_translation.cast(u8, @as(c_uint, 3));
pub const queueQUEUE_TYPE_RECURSIVE_MUTEX = std.zig.c_translation.cast(u8, @as(c_uint, 4));
pub const SemaphoreHandle_t = QueueHandle_t;
pub const xTASK_SNAPSHOT = extern struct {
    pxTCB: ?*anyopaque = null,
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
pub const StaticRingbuffer_t = extern struct {
    xDummy1: [2]usize = std.mem.zeroes([2]usize),
    uxDummy2: UBaseType_t = std.mem.zeroes(UBaseType_t),
    pvDummy3: [11]?*anyopaque = std.mem.zeroes([11]?*anyopaque),
    xDummy4: BaseType_t = std.mem.zeroes(BaseType_t),
    xDummy5: [2]StaticList_t = std.mem.zeroes([2]StaticList_t),
    pvDummy6: ?*anyopaque = null,
    muxDummy: portMUX_TYPE = std.mem.zeroes(portMUX_TYPE),
};
pub extern fn xRingbufferCreate(xBufferSize: usize, xBufferType: RingbufferType_t) RingbufHandle_t;
pub extern fn xRingbufferCreateNoSplit(xItemSize: usize, xItemNum: usize) RingbufHandle_t;
pub extern fn xRingbufferCreateStatic(xBufferSize: usize, xBufferType: RingbufferType_t, pucRingbufferStorage: [*:0]u8, pxStaticRingbuffer: [*c]StaticRingbuffer_t) RingbufHandle_t;
pub extern fn xRingbufferSend(xRingbuffer: RingbufHandle_t, pvItem: ?*const anyopaque, xItemSize: usize, xTicksToWait: TickType_t) BaseType_t;
pub extern fn xRingbufferSendFromISR(xRingbuffer: RingbufHandle_t, pvItem: ?*const anyopaque, xItemSize: usize, pxHigherPriorityTaskWoken: [*c]BaseType_t) BaseType_t;
pub extern fn xRingbufferSendAcquire(xRingbuffer: RingbufHandle_t, ppvItem: [*c]?*anyopaque, xItemSize: usize, xTicksToWait: TickType_t) BaseType_t;
pub extern fn xRingbufferSendComplete(xRingbuffer: RingbufHandle_t, pvItem: ?*anyopaque) BaseType_t;
pub extern fn xRingbufferReceive(xRingbuffer: RingbufHandle_t, pxItemSize: [*c]usize, xTicksToWait: TickType_t) ?*anyopaque;
pub extern fn xRingbufferReceiveFromISR(xRingbuffer: RingbufHandle_t, pxItemSize: [*c]usize) ?*anyopaque;
pub extern fn xRingbufferReceiveSplit(xRingbuffer: RingbufHandle_t, ppvHeadItem: [*c]?*anyopaque, ppvTailItem: [*c]?*anyopaque, pxHeadItemSize: [*c]usize, pxTailItemSize: [*c]usize, xTicksToWait: TickType_t) BaseType_t;
pub extern fn xRingbufferReceiveSplitFromISR(xRingbuffer: RingbufHandle_t, ppvHeadItem: [*c]?*anyopaque, ppvTailItem: [*c]?*anyopaque, pxHeadItemSize: [*c]usize, pxTailItemSize: [*c]usize) BaseType_t;
pub extern fn xRingbufferReceiveUpTo(xRingbuffer: RingbufHandle_t, pxItemSize: [*c]usize, xTicksToWait: TickType_t, xMaxSize: usize) ?*anyopaque;
pub extern fn xRingbufferReceiveUpToFromISR(xRingbuffer: RingbufHandle_t, pxItemSize: [*c]usize, xMaxSize: usize) ?*anyopaque;
pub extern fn vRingbufferReturnItem(xRingbuffer: RingbufHandle_t, pvItem: ?*anyopaque) void;
pub extern fn vRingbufferReturnItemFromISR(xRingbuffer: RingbufHandle_t, pvItem: ?*anyopaque, pxHigherPriorityTaskWoken: [*c]BaseType_t) void;
pub extern fn vRingbufferDelete(xRingbuffer: RingbufHandle_t) void;
pub extern fn xRingbufferGetMaxItemSize(xRingbuffer: RingbufHandle_t) usize;
pub extern fn xRingbufferGetCurFreeSize(xRingbuffer: RingbufHandle_t) usize;
pub extern fn xRingbufferAddToQueueSetRead(xRingbuffer: RingbufHandle_t, xQueueSet: QueueSetHandle_t) BaseType_t;
pub fn xRingbufferCanRead(xRingbuffer: RingbufHandle_t, xMember: QueueSetMemberHandle_t) callconv(.C) BaseType_t {
    return if (xMember == @as(QueueSetMemberHandle_t, @ptrCast(xRingbuffer))) @as(BaseType_t, @bitCast(@as(c_int, 1))) else @as(BaseType_t, @bitCast(@as(c_int, 0)));
}
pub extern fn xRingbufferRemoveFromQueueSetRead(xRingbuffer: RingbufHandle_t, xQueueSet: QueueSetHandle_t) BaseType_t;
pub extern fn vRingbufferGetInfo(xRingbuffer: RingbufHandle_t, uxFree: [*c]UBaseType_t, uxRead: [*c]UBaseType_t, uxWrite: [*c]UBaseType_t, uxAcquire: [*c]UBaseType_t, uxItemsWaiting: [*c]UBaseType_t) void;
pub extern fn xRingbufferPrintInfo(xRingbuffer: RingbufHandle_t) void;
pub extern fn xRingbufferGetStaticBuffer(xRingbuffer: RingbufHandle_t, ppucRingbufferStorage: [*c][*c]u8, ppxStaticRingbuffer: [*c][*c]StaticRingbuffer_t) BaseType_t;
pub extern fn xRingbufferCreateWithCaps(xBufferSize: usize, xBufferType: RingbufferType_t, uxMemoryCaps: UBaseType_t) RingbufHandle_t;
pub extern fn vRingbufferDeleteWithCaps(xRingbuffer: RingbufHandle_t) void;

pub const esp_event_base_t = [*:0]const u8;
pub const esp_event_loop_handle_t = ?*anyopaque;
pub const esp_event_handler_t = ?*const fn (?*anyopaque, esp_event_base_t, i32, ?*anyopaque) callconv(.C) void;
pub const esp_event_handler_instance_t = ?*anyopaque;
pub const esp_event_loop_args_t = extern struct {
    queue_size: i32 = std.mem.zeroes(i32),
    task_name: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
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
pub extern fn esp_event_dump(file: ?*std.c.FILE) esp_err_t;
pub const nvs_handle_t = u32;
pub const nvs_handle = nvs_handle_t;
pub const nvs_open_mode_t = enum(c_uint) {
    NVS_READONLY = 0,
    NVS_READWRITE = 1,
};
pub const nvs_open_mode = nvs_open_mode_t;
pub const nvs_type_t = enum(c_uint) {
    NVS_TYPE_U8 = 1,
    NVS_TYPE_I8 = 17,
    NVS_TYPE_U16 = 2,
    NVS_TYPE_I16 = 18,
    NVS_TYPE_U32 = 4,
    NVS_TYPE_I32 = 20,
    NVS_TYPE_U64 = 8,
    NVS_TYPE_I64 = 24,
    NVS_TYPE_STR = 33,
    NVS_TYPE_BLOB = 66,
    NVS_TYPE_ANY = 255,
};
pub const nvs_entry_info_t = extern struct {
    namespace_name: [16]u8 = std.mem.zeroes([16]u8),
    key: [16]u8 = std.mem.zeroes([16]u8),
    type: nvs_type_t = std.mem.zeroes(nvs_type_t),
};
pub const nvs_opaque_iterator_t = opaque {};
pub const nvs_iterator_t = ?*nvs_opaque_iterator_t;
pub extern fn nvs_open(namespace_name: [*:0]const u8, open_mode: nvs_open_mode_t, out_handle: [*c]nvs_handle_t) esp_err_t;
pub extern fn nvs_open_from_partition(part_name: [*:0]const u8, namespace_name: [*:0]const u8, open_mode: nvs_open_mode_t, out_handle: [*c]nvs_handle_t) esp_err_t;
pub extern fn nvs_set_i8(handle: nvs_handle_t, key: [*:0]const u8, value: i8) esp_err_t;
pub extern fn nvs_set_u8(handle: nvs_handle_t, key: [*:0]const u8, value: u8) esp_err_t;
pub extern fn nvs_set_i16(handle: nvs_handle_t, key: [*:0]const u8, value: i16) esp_err_t;
pub extern fn nvs_set_u16(handle: nvs_handle_t, key: [*:0]const u8, value: u16) esp_err_t;
pub extern fn nvs_set_i32(handle: nvs_handle_t, key: [*:0]const u8, value: i32) esp_err_t;
pub extern fn nvs_set_u32(handle: nvs_handle_t, key: [*:0]const u8, value: u32) esp_err_t;
pub extern fn nvs_set_i64(handle: nvs_handle_t, key: [*:0]const u8, value: i64) esp_err_t;
pub extern fn nvs_set_u64(handle: nvs_handle_t, key: [*:0]const u8, value: u64) esp_err_t;
pub extern fn nvs_set_str(handle: nvs_handle_t, key: [*:0]const u8, value: [*:0]const u8) esp_err_t;
pub extern fn nvs_set_blob(handle: nvs_handle_t, key: [*:0]const u8, value: ?*const anyopaque, length: usize) esp_err_t;
pub extern fn nvs_get_i8(handle: nvs_handle_t, key: [*:0]const u8, out_value: [*:0]i8) esp_err_t;
pub extern fn nvs_get_u8(handle: nvs_handle_t, key: [*:0]const u8, out_value: [*:0]u8) esp_err_t;
pub extern fn nvs_get_i16(handle: nvs_handle_t, key: [*:0]const u8, out_value: [*c]i16) esp_err_t;
pub extern fn nvs_get_u16(handle: nvs_handle_t, key: [*:0]const u8, out_value: [*c]u16) esp_err_t;
pub extern fn nvs_get_i32(handle: nvs_handle_t, key: [*:0]const u8, out_value: [*c]i32) esp_err_t;
pub extern fn nvs_get_u32(handle: nvs_handle_t, key: [*:0]const u8, out_value: [*c]u32) esp_err_t;
pub extern fn nvs_get_i64(handle: nvs_handle_t, key: [*:0]const u8, out_value: [*c]i64) esp_err_t;
pub extern fn nvs_get_u64(handle: nvs_handle_t, key: [*:0]const u8, out_value: [*c]u64) esp_err_t;
pub extern fn nvs_get_str(handle: nvs_handle_t, key: [*:0]const u8, out_value: [*:0]u8, length: [*c]usize) esp_err_t;
pub extern fn nvs_get_blob(handle: nvs_handle_t, key: [*:0]const u8, out_value: ?*anyopaque, length: [*c]usize) esp_err_t;
pub extern fn nvs_find_key(handle: nvs_handle_t, key: [*:0]const u8, out_type: [*c]nvs_type_t) esp_err_t;
pub extern fn nvs_erase_key(handle: nvs_handle_t, key: [*:0]const u8) esp_err_t;
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
pub extern fn nvs_get_stats(part_name: [*:0]const u8, nvs_stats: [*c]nvs_stats_t) esp_err_t;
pub extern fn nvs_get_used_entry_count(handle: nvs_handle_t, used_entries: [*c]usize) esp_err_t;
pub extern fn nvs_entry_find(part_name: [*:0]const u8, namespace_name: [*:0]const u8, @"type": nvs_type_t, output_iterator: [*c]nvs_iterator_t) esp_err_t;
pub extern fn nvs_entry_find_in_handle(handle: nvs_handle_t, @"type": nvs_type_t, output_iterator: [*c]nvs_iterator_t) esp_err_t;
pub extern fn nvs_entry_next(iterator: [*c]nvs_iterator_t) esp_err_t;
pub extern fn nvs_entry_info(iterator: nvs_iterator_t, out_info: [*c]nvs_entry_info_t) esp_err_t;
pub extern fn nvs_release_iterator(iterator: nvs_iterator_t) void;
pub const esp_flash_t = opaque {};
pub const esp_partition_mmap_memory_t = enum(c_uint) {
    ESP_PARTITION_MMAP_DATA = 0,
    ESP_PARTITION_MMAP_INST = 1,
};
pub const esp_partition_mmap_handle_t = u32;
pub const esp_partition_type_t = enum(c_uint) {
    ESP_PARTITION_TYPE_APP = 0,
    ESP_PARTITION_TYPE_DATA = 1,
    ESP_PARTITION_TYPE_ANY = 255,
};
pub const esp_partition_subtype_t = enum(c_uint) {
    ESP_PARTITION_SUBTYPE_APP_FACTORY = 0,
    ESP_PARTITION_SUBTYPE_APP_OTA_MIN = 16,
    ESP_PARTITION_SUBTYPE_APP_OTA_0 = 16,
    ESP_PARTITION_SUBTYPE_APP_OTA_1 = 17,
    ESP_PARTITION_SUBTYPE_APP_OTA_2 = 18,
    ESP_PARTITION_SUBTYPE_APP_OTA_3 = 19,
    ESP_PARTITION_SUBTYPE_APP_OTA_4 = 20,
    ESP_PARTITION_SUBTYPE_APP_OTA_5 = 21,
    ESP_PARTITION_SUBTYPE_APP_OTA_6 = 22,
    ESP_PARTITION_SUBTYPE_APP_OTA_7 = 23,
    ESP_PARTITION_SUBTYPE_APP_OTA_8 = 24,
    ESP_PARTITION_SUBTYPE_APP_OTA_9 = 25,
    ESP_PARTITION_SUBTYPE_APP_OTA_10 = 26,
    ESP_PARTITION_SUBTYPE_APP_OTA_11 = 27,
    ESP_PARTITION_SUBTYPE_APP_OTA_12 = 28,
    ESP_PARTITION_SUBTYPE_APP_OTA_13 = 29,
    ESP_PARTITION_SUBTYPE_APP_OTA_14 = 30,
    ESP_PARTITION_SUBTYPE_APP_OTA_15 = 31,
    ESP_PARTITION_SUBTYPE_APP_OTA_MAX = 32,
    ESP_PARTITION_SUBTYPE_APP_TEST = 32,
    ESP_PARTITION_SUBTYPE_DATA_OTA = 0,
    ESP_PARTITION_SUBTYPE_DATA_PHY = 1,
    ESP_PARTITION_SUBTYPE_DATA_NVS = 2,
    ESP_PARTITION_SUBTYPE_DATA_COREDUMP = 3,
    ESP_PARTITION_SUBTYPE_DATA_NVS_KEYS = 4,
    ESP_PARTITION_SUBTYPE_DATA_EFUSE_EM = 5,
    ESP_PARTITION_SUBTYPE_DATA_UNDEFINED = 6,
    ESP_PARTITION_SUBTYPE_DATA_ESPHTTPD = 128,
    ESP_PARTITION_SUBTYPE_DATA_FAT = 129,
    ESP_PARTITION_SUBTYPE_DATA_SPIFFS = 130,
    ESP_PARTITION_SUBTYPE_DATA_LITTLEFS = 131,
    ESP_PARTITION_SUBTYPE_ANY = 255,
};
pub const esp_partition_iterator_opaque_ = opaque {};
pub const esp_partition_iterator_t = ?*esp_partition_iterator_opaque_;
pub const esp_partition_t = extern struct {
    flash_chip: ?*esp_flash_t = null,
    type: esp_partition_type_t = std.mem.zeroes(esp_partition_type_t),
    subtype: esp_partition_subtype_t = std.mem.zeroes(esp_partition_subtype_t),
    address: u32 = std.mem.zeroes(u32),
    size: u32 = std.mem.zeroes(u32),
    erase_size: u32 = std.mem.zeroes(u32),
    label: [17]u8 = std.mem.zeroes([17]u8),
    encrypted: bool = std.mem.zeroes(bool),
    readonly: bool = std.mem.zeroes(bool),
};
pub extern fn esp_partition_find(@"type": esp_partition_type_t, subtype: esp_partition_subtype_t, label: [*:0]const u8) esp_partition_iterator_t;
pub extern fn esp_partition_find_first(@"type": esp_partition_type_t, subtype: esp_partition_subtype_t, label: [*:0]const u8) [*c]const esp_partition_t;
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
pub extern fn esp_partition_get_sha256(partition: [*c]const esp_partition_t, sha_256: [*:0]u8) esp_err_t;
pub extern fn esp_partition_check_identity(partition_1: [*c]const esp_partition_t, partition_2: [*c]const esp_partition_t) bool;
pub extern fn esp_partition_register_external(flash_chip: ?*esp_flash_t, offset: usize, size: usize, label: [*:0]const u8, @"type": esp_partition_type_t, subtype: esp_partition_subtype_t, out_partition: [*c][*c]const esp_partition_t) esp_err_t;
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
    scheme_data: ?*anyopaque = null,
    nvs_flash_key_gen: nvs_flash_generate_keys_t = std.mem.zeroes(nvs_flash_generate_keys_t),
    nvs_flash_read_cfg: nvs_flash_read_cfg_t = std.mem.zeroes(nvs_flash_read_cfg_t),
};
pub extern fn nvs_flash_init() esp_err_t;
pub extern fn nvs_flash_init_partition(partition_label: [*:0]const u8) esp_err_t;
pub extern fn nvs_flash_init_partition_ptr(partition: [*c]const esp_partition_t) esp_err_t;
pub extern fn nvs_flash_deinit() esp_err_t;
pub extern fn nvs_flash_deinit_partition(partition_label: [*:0]const u8) esp_err_t;
pub extern fn nvs_flash_erase() esp_err_t;
pub extern fn nvs_flash_erase_partition(part_name: [*:0]const u8) esp_err_t;
pub extern fn nvs_flash_erase_partition_ptr(partition: [*c]const esp_partition_t) esp_err_t;
pub extern fn nvs_flash_secure_init(cfg: [*c]nvs_sec_cfg_t) esp_err_t;
pub extern fn nvs_flash_secure_init_partition(partition_label: [*:0]const u8, cfg: [*c]nvs_sec_cfg_t) esp_err_t;
pub extern fn nvs_flash_generate_keys(partition: [*c]const esp_partition_t, cfg: [*c]nvs_sec_cfg_t) esp_err_t;
pub extern fn nvs_flash_read_security_cfg(partition: [*c]const esp_partition_t, cfg: [*c]nvs_sec_cfg_t) esp_err_t;
pub extern fn nvs_flash_register_security_scheme(scheme_cfg: [*c]nvs_sec_scheme_t) esp_err_t;
pub extern fn nvs_flash_get_default_security_scheme() [*c]nvs_sec_scheme_t;
pub extern fn nvs_flash_generate_keys_v2(scheme_cfg: [*c]nvs_sec_scheme_t, cfg: [*c]nvs_sec_cfg_t) esp_err_t;
pub extern fn nvs_flash_read_security_cfg_v2(scheme_cfg: [*c]nvs_sec_scheme_t, cfg: [*c]nvs_sec_cfg_t) esp_err_t;

pub const esp_bt_mode_t = enum(c_uint) {
    ESP_BT_MODE_IDLE = 0,
    ESP_BT_MODE_BLE = 1,
    ESP_BT_MODE_CLASSIC_BT = 2,
    ESP_BT_MODE_BTDM = 3,
};
pub const esp_bt_ctrl_hci_tl_t = enum(c_uint) {
    ESP_BT_CTRL_HCI_TL_UART = 0,
    ESP_BT_CTRL_HCI_TL_VHCI = 1,
};
pub const esp_ble_ce_len_t = enum(c_uint) {
    ESP_BLE_CE_LEN_TYPE_ORIG = 0,
    ESP_BLE_CE_LEN_TYPE_CE = 1,
    ESP_BLE_CE_LEN_TYPE_SD = 1,
};
pub const esp_bt_sleep_mode_t = enum(c_uint) {
    ESP_BT_SLEEP_MODE_NONE = 0,
    ESP_BT_SLEEP_MODE_1 = 1,
};
pub const esp_bt_sleep_clock_t = enum(c_uint) {
    ESP_BT_SLEEP_CLOCK_NONE = 0,
    ESP_BT_SLEEP_CLOCK_MAIN_XTAL = 1,
    ESP_BT_SLEEP_CLOCK_EXT_32K_XTAL = 2,
    ESP_BT_SLEEP_CLOCK_RTC_SLOW = 3,
    ESP_BT_SLEEP_CLOCK_FPGA_32K = 4,
};
const unnamed_15 = enum(c_uint) {
    ESP_BT_ANT_IDX_0 = 0,
    ESP_BT_ANT_IDX_1 = 1,
};
const unnamed_16 = enum(c_uint) {
    ESP_BT_COEX_PHY_CODED_TX_RX_TIME_LIMIT_FORCE_DISABLE = 0,
    ESP_BT_COEX_PHY_CODED_TX_RX_TIME_LIMIT_FORCE_ENABLE = 1,
};
pub const esp_bt_hci_tl_callback_t = ?*const fn (?*anyopaque, u8) callconv(.C) void;
pub const esp_bt_hci_tl_t = extern struct {
    _magic: u32 = std.mem.zeroes(u32),
    _version: u32 = std.mem.zeroes(u32),
    _reserved: u32 = std.mem.zeroes(u32),
    _open: ?*const fn () callconv(.C) c_int = std.mem.zeroes(?*const fn () callconv(.C) c_int),
    _close: ?*const fn () callconv(.C) void = std.mem.zeroes(?*const fn () callconv(.C) void),
    _finish_transfers: ?*const fn () callconv(.C) void = std.mem.zeroes(?*const fn () callconv(.C) void),
    _recv: ?*const fn ([*:0]u8, u32, esp_bt_hci_tl_callback_t, ?*anyopaque) callconv(.C) void = std.mem.zeroes(?*const fn ([*:0]u8, u32, esp_bt_hci_tl_callback_t, ?*anyopaque) callconv(.C) void),
    _send: ?*const fn ([*:0]u8, u32, esp_bt_hci_tl_callback_t, ?*anyopaque) callconv(.C) void = std.mem.zeroes(?*const fn ([*:0]u8, u32, esp_bt_hci_tl_callback_t, ?*anyopaque) callconv(.C) void),
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
pub const esp_bt_controller_status_t = enum(c_uint) {
    ESP_BT_CONTROLLER_STATUS_IDLE = 0,
    ESP_BT_CONTROLLER_STATUS_INITED = 1,
    ESP_BT_CONTROLLER_STATUS_ENABLED = 2,
    ESP_BT_CONTROLLER_STATUS_NUM = 3,
};
pub const esp_ble_power_type_t = enum(c_uint) {
    ESP_BLE_PWR_TYPE_CONN_HDL0 = 0,
    ESP_BLE_PWR_TYPE_CONN_HDL1 = 1,
    ESP_BLE_PWR_TYPE_CONN_HDL2 = 2,
    ESP_BLE_PWR_TYPE_CONN_HDL3 = 3,
    ESP_BLE_PWR_TYPE_CONN_HDL4 = 4,
    ESP_BLE_PWR_TYPE_CONN_HDL5 = 5,
    ESP_BLE_PWR_TYPE_CONN_HDL6 = 6,
    ESP_BLE_PWR_TYPE_CONN_HDL7 = 7,
    ESP_BLE_PWR_TYPE_CONN_HDL8 = 8,
    ESP_BLE_PWR_TYPE_ADV = 9,
    ESP_BLE_PWR_TYPE_SCAN = 10,
    ESP_BLE_PWR_TYPE_DEFAULT = 11,
    ESP_BLE_PWR_TYPE_NUM = 12,
};
pub const esp_power_level_t = enum(c_uint) {
    ESP_PWR_LVL_N24 = 0,
    ESP_PWR_LVL_N21 = 1,
    ESP_PWR_LVL_N18 = 2,
    ESP_PWR_LVL_N15 = 3,
    ESP_PWR_LVL_N12 = 4,
    ESP_PWR_LVL_N9 = 5,
    ESP_PWR_LVL_N6 = 6,
    ESP_PWR_LVL_N3 = 7,
    ESP_PWR_LVL_N0 = 8,
    ESP_PWR_LVL_P3 = 9,
    ESP_PWR_LVL_P6 = 10,
    ESP_PWR_LVL_P9 = 11,
    ESP_PWR_LVL_P12 = 12,
    ESP_PWR_LVL_P15 = 13,
    ESP_PWR_LVL_P18 = 14,
    ESP_PWR_LVL_P21 = 15,
    ESP_PWR_LVL_INVALID = 255,
};
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
    notify_host_recv: ?*const fn ([*:0]u8, u16) callconv(.C) c_int = std.mem.zeroes(?*const fn ([*:0]u8, u16) callconv(.C) c_int),
};
pub const esp_vhci_host_callback_t = esp_vhci_host_callback;
pub extern fn esp_vhci_host_check_send_available() bool;
pub extern fn esp_vhci_host_send_packet(data: [*:0]u8, len: u16) void;
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
pub const esp_bluedroid_status_t = enum(c_uint) {
    ESP_BLUEDROID_STATUS_UNINITIALIZED = 0,
    ESP_BLUEDROID_STATUS_INITIALIZED = 1,
    ESP_BLUEDROID_STATUS_ENABLED = 2,
};
pub const esp_bluedroid_config_t = extern struct {
    ssp_en: bool = std.mem.zeroes(bool),
};
pub extern fn esp_bluedroid_get_status() esp_bluedroid_status_t;
pub extern fn esp_bluedroid_enable() esp_err_t;
pub extern fn esp_bluedroid_disable() esp_err_t;
pub extern fn esp_bluedroid_init() esp_err_t;
pub extern fn esp_bluedroid_init_with_cfg(cfg: [*c]esp_bluedroid_config_t) esp_err_t;
pub extern fn esp_bluedroid_deinit() esp_err_t;
pub const esp_bt_status_t = enum(c_uint) {
    ESP_BT_STATUS_SUCCESS = 0,
    ESP_BT_STATUS_FAIL = 1,
    ESP_BT_STATUS_NOT_READY = 2,
    ESP_BT_STATUS_NOMEM = 3,
    ESP_BT_STATUS_BUSY = 4,
    ESP_BT_STATUS_DONE = 5,
    ESP_BT_STATUS_UNSUPPORTED = 6,
    ESP_BT_STATUS_PARM_INVALID = 7,
    ESP_BT_STATUS_UNHANDLED = 8,
    ESP_BT_STATUS_AUTH_FAILURE = 9,
    ESP_BT_STATUS_RMT_DEV_DOWN = 10,
    ESP_BT_STATUS_AUTH_REJECTED = 11,
    ESP_BT_STATUS_INVALID_STATIC_RAND_ADDR = 12,
    ESP_BT_STATUS_PENDING = 13,
    ESP_BT_STATUS_UNACCEPT_CONN_INTERVAL = 14,
    ESP_BT_STATUS_PARAM_OUT_OF_RANGE = 15,
    ESP_BT_STATUS_TIMEOUT = 16,
    ESP_BT_STATUS_PEER_LE_DATA_LEN_UNSUPPORTED = 17,
    ESP_BT_STATUS_CONTROL_LE_DATA_LEN_UNSUPPORTED = 18,
    ESP_BT_STATUS_ERR_ILLEGAL_PARAMETER_FMT = 19,
    ESP_BT_STATUS_MEMORY_FULL = 20,
    ESP_BT_STATUS_EIR_TOO_LARGE = 21,
    ESP_BT_STATUS_HCI_SUCCESS = 256,
    ESP_BT_STATUS_HCI_ILLEGAL_COMMAND = 257,
    ESP_BT_STATUS_HCI_NO_CONNECTION = 258,
    ESP_BT_STATUS_HCI_HW_FAILURE = 259,
    ESP_BT_STATUS_HCI_PAGE_TIMEOUT = 260,
    ESP_BT_STATUS_HCI_AUTH_FAILURE = 261,
    ESP_BT_STATUS_HCI_KEY_MISSING = 262,
    ESP_BT_STATUS_HCI_MEMORY_FULL = 263,
    ESP_BT_STATUS_HCI_CONNECTION_TOUT = 264,
    ESP_BT_STATUS_HCI_MAX_NUM_OF_CONNECTIONS = 265,
    ESP_BT_STATUS_HCI_MAX_NUM_OF_SCOS = 266,
    ESP_BT_STATUS_HCI_CONNECTION_EXISTS = 267,
    ESP_BT_STATUS_HCI_COMMAND_DISALLOWED = 268,
    ESP_BT_STATUS_HCI_HOST_REJECT_RESOURCES = 269,
    ESP_BT_STATUS_HCI_HOST_REJECT_SECURITY = 270,
    ESP_BT_STATUS_HCI_HOST_REJECT_DEVICE = 271,
    ESP_BT_STATUS_HCI_HOST_TIMEOUT = 272,
    ESP_BT_STATUS_HCI_UNSUPPORTED_VALUE = 273,
    ESP_BT_STATUS_HCI_ILLEGAL_PARAMETER_FMT = 274,
    ESP_BT_STATUS_HCI_PEER_USER = 275,
    ESP_BT_STATUS_HCI_PEER_LOW_RESOURCES = 276,
    ESP_BT_STATUS_HCI_PEER_POWER_OFF = 277,
    ESP_BT_STATUS_HCI_CONN_CAUSE_LOCAL_HOST = 278,
    ESP_BT_STATUS_HCI_REPEATED_ATTEMPTS = 279,
    ESP_BT_STATUS_HCI_PAIRING_NOT_ALLOWED = 280,
    ESP_BT_STATUS_HCI_UNKNOWN_LMP_PDU = 281,
    ESP_BT_STATUS_HCI_UNSUPPORTED_REM_FEATURE = 282,
    ESP_BT_STATUS_HCI_SCO_OFFSET_REJECTED = 283,
    ESP_BT_STATUS_HCI_SCO_INTERVAL_REJECTED = 284,
    ESP_BT_STATUS_HCI_SCO_AIR_MODE = 285,
    ESP_BT_STATUS_HCI_INVALID_LMP_PARAM = 286,
    ESP_BT_STATUS_HCI_UNSPECIFIED = 287,
    ESP_BT_STATUS_HCI_UNSUPPORTED_LMP_PARAMETERS = 288,
    ESP_BT_STATUS_HCI_ROLE_CHANGE_NOT_ALLOWED = 289,
    ESP_BT_STATUS_HCI_LMP_RESPONSE_TIMEOUT = 290,
    ESP_BT_STATUS_HCI_LMP_ERR_TRANS_COLLISION = 291,
    ESP_BT_STATUS_HCI_LMP_PDU_NOT_ALLOWED = 292,
    ESP_BT_STATUS_HCI_ENCRY_MODE_NOT_ACCEPTABLE = 293,
    ESP_BT_STATUS_HCI_UNIT_KEY_USED = 294,
    ESP_BT_STATUS_HCI_QOS_NOT_SUPPORTED = 295,
    ESP_BT_STATUS_HCI_INSTANT_PASSED = 296,
    ESP_BT_STATUS_HCI_PAIRING_WITH_UNIT_KEY_NOT_SUPPORTED = 297,
    ESP_BT_STATUS_HCI_DIFF_TRANSACTION_COLLISION = 298,
    ESP_BT_STATUS_HCI_UNDEFINED_0x2B = 299,
    ESP_BT_STATUS_HCI_QOS_UNACCEPTABLE_PARAM = 300,
    ESP_BT_STATUS_HCI_QOS_REJECTED = 301,
    ESP_BT_STATUS_HCI_CHAN_CLASSIF_NOT_SUPPORTED = 302,
    ESP_BT_STATUS_HCI_INSUFFCIENT_SECURITY = 303,
    ESP_BT_STATUS_HCI_PARAM_OUT_OF_RANGE = 304,
    ESP_BT_STATUS_HCI_UNDEFINED_0x31 = 305,
    ESP_BT_STATUS_HCI_ROLE_SWITCH_PENDING = 306,
    ESP_BT_STATUS_HCI_UNDEFINED_0x33 = 307,
    ESP_BT_STATUS_HCI_RESERVED_SLOT_VIOLATION = 308,
    ESP_BT_STATUS_HCI_ROLE_SWITCH_FAILED = 309,
    ESP_BT_STATUS_HCI_INQ_RSP_DATA_TOO_LARGE = 310,
    ESP_BT_STATUS_HCI_SIMPLE_PAIRING_NOT_SUPPORTED = 311,
    ESP_BT_STATUS_HCI_HOST_BUSY_PAIRING = 312,
    ESP_BT_STATUS_HCI_REJ_NO_SUITABLE_CHANNEL = 313,
    ESP_BT_STATUS_HCI_CONTROLLER_BUSY = 314,
    ESP_BT_STATUS_HCI_UNACCEPT_CONN_INTERVAL = 315,
    ESP_BT_STATUS_HCI_DIRECTED_ADVERTISING_TIMEOUT = 316,
    ESP_BT_STATUS_HCI_CONN_TOUT_DUE_TO_MIC_FAILURE = 317,
    ESP_BT_STATUS_HCI_CONN_FAILED_ESTABLISHMENT = 318,
    ESP_BT_STATUS_HCI_MAC_CONNECTION_FAILED = 319,
};
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
pub const esp_bt_dev_type_t = enum(c_uint) {
    ESP_BT_DEVICE_TYPE_BREDR = 1,
    ESP_BT_DEVICE_TYPE_BLE = 2,
    ESP_BT_DEVICE_TYPE_DUMO = 3,
};
pub const esp_bd_addr_t = [6]u8;
pub const esp_ble_addr_type_t = enum(c_uint) {
    BLE_ADDR_TYPE_PUBLIC = 0,
    BLE_ADDR_TYPE_RANDOM = 1,
    BLE_ADDR_TYPE_RPA_PUBLIC = 2,
    BLE_ADDR_TYPE_RPA_RANDOM = 3,
};
pub const esp_ble_wl_addr_type_t = enum(c_uint) {
    BLE_WL_ADDR_TYPE_PUBLIC = 0,
    BLE_WL_ADDR_TYPE_RANDOM = 1,
};
pub const esp_ble_key_mask_t = u8;
pub const esp_bt_dev_coex_op_t = u8;
pub const esp_bt_dev_coex_type_t = enum(c_uint) {
    ESP_BT_DEV_COEX_TYPE_BLE = 1,
    ESP_BT_DEV_COEX_TYPE_BT = 2,
};
pub const esp_bt_dev_cb_event_t = enum(c_uint) {
    ESP_BT_DEV_NAME_RES_EVT = 0,
    ESP_BT_DEV_EVT_MAX = 1,
};
pub const name_res_param_18 = extern struct {
    status: esp_bt_status_t = std.mem.zeroes(esp_bt_status_t),
    name: [*:0]u8 = std.mem.zeroes([*:0]u8),
};
pub const esp_bt_dev_cb_param_t = extern union {
    name_res: name_res_param_18,
};
pub const esp_bt_dev_cb_t = ?*const fn (esp_bt_dev_cb_event_t, [*c]esp_bt_dev_cb_param_t) callconv(.C) void;
pub extern fn esp_bt_dev_register_callback(callback: esp_bt_dev_cb_t) esp_err_t;
pub extern fn esp_bt_dev_get_address() [*:0]const u8;
pub extern fn esp_bt_dev_set_device_name(name: [*:0]const u8) esp_err_t;
pub extern fn esp_bt_dev_get_device_name() esp_err_t;
pub extern fn esp_bt_dev_coex_status_config(@"type": esp_bt_dev_coex_type_t, op: esp_bt_dev_coex_op_t, status: u8) esp_err_t;
pub extern fn esp_bt_config_file_path_update(file_path: [*:0]const u8) esp_err_t;
pub const wifi_mode_t = enum(c_uint) {
    WIFI_MODE_NULL = 0,
    WIFI_MODE_STA = 1,
    WIFI_MODE_AP = 2,
    WIFI_MODE_APSTA = 3,
    WIFI_MODE_NAN = 4,
    WIFI_MODE_MAX = 5,
};
pub const wifi_interface_t = enum(c_uint) {
    WIFI_IF_STA = 0,
    WIFI_IF_AP = 1,
    WIFI_IF_NAN = 2,
    WIFI_IF_MAX = 3,
};
pub const wifi_country_policy_t = enum(c_uint) {
    WIFI_COUNTRY_POLICY_AUTO = 0,
    WIFI_COUNTRY_POLICY_MANUAL = 1,
};
pub const wifi_country_t = extern struct {
    cc: [3]u8 = std.mem.zeroes([3]u8),
    schan: u8 = std.mem.zeroes(u8),
    nchan: u8 = std.mem.zeroes(u8),
    max_tx_power: i8 = std.mem.zeroes(i8),
    policy: wifi_country_policy_t = std.mem.zeroes(wifi_country_policy_t),
};
pub const wifi_auth_mode_t = enum(c_uint) {
    WIFI_AUTH_OPEN = 0,
    WIFI_AUTH_WEP = 1,
    WIFI_AUTH_WPA_PSK = 2,
    WIFI_AUTH_WPA2_PSK = 3,
    WIFI_AUTH_WPA_WPA2_PSK = 4,
    WIFI_AUTH_ENTERPRISE = 5,
    WIFI_AUTH_WPA2_ENTERPRISE = 5,
    WIFI_AUTH_WPA3_PSK = 6,
    WIFI_AUTH_WPA2_WPA3_PSK = 7,
    WIFI_AUTH_WAPI_PSK = 8,
    WIFI_AUTH_OWE = 9,
    WIFI_AUTH_WPA3_ENT_192 = 10,
    WIFI_AUTH_WPA3_EXT_PSK = 11,
    WIFI_AUTH_WPA3_EXT_PSK_MIXED_MODE = 12,
    WIFI_AUTH_MAX = 13,
};
pub const wifi_err_reason_t = enum(c_uint) {
    WIFI_REASON_UNSPECIFIED = 1,
    WIFI_REASON_AUTH_EXPIRE = 2,
    WIFI_REASON_AUTH_LEAVE = 3,
    WIFI_REASON_ASSOC_EXPIRE = 4,
    WIFI_REASON_ASSOC_TOOMANY = 5,
    WIFI_REASON_NOT_AUTHED = 6,
    WIFI_REASON_NOT_ASSOCED = 7,
    WIFI_REASON_ASSOC_LEAVE = 8,
    WIFI_REASON_ASSOC_NOT_AUTHED = 9,
    WIFI_REASON_DISASSOC_PWRCAP_BAD = 10,
    WIFI_REASON_DISASSOC_SUPCHAN_BAD = 11,
    WIFI_REASON_BSS_TRANSITION_DISASSOC = 12,
    WIFI_REASON_IE_INVALID = 13,
    WIFI_REASON_MIC_FAILURE = 14,
    WIFI_REASON_4WAY_HANDSHAKE_TIMEOUT = 15,
    WIFI_REASON_GROUP_KEY_UPDATE_TIMEOUT = 16,
    WIFI_REASON_IE_IN_4WAY_DIFFERS = 17,
    WIFI_REASON_GROUP_CIPHER_INVALID = 18,
    WIFI_REASON_PAIRWISE_CIPHER_INVALID = 19,
    WIFI_REASON_AKMP_INVALID = 20,
    WIFI_REASON_UNSUPP_RSN_IE_VERSION = 21,
    WIFI_REASON_INVALID_RSN_IE_CAP = 22,
    WIFI_REASON_802_1X_AUTH_FAILED = 23,
    WIFI_REASON_CIPHER_SUITE_REJECTED = 24,
    WIFI_REASON_TDLS_PEER_UNREACHABLE = 25,
    WIFI_REASON_TDLS_UNSPECIFIED = 26,
    WIFI_REASON_SSP_REQUESTED_DISASSOC = 27,
    WIFI_REASON_NO_SSP_ROAMING_AGREEMENT = 28,
    WIFI_REASON_BAD_CIPHER_OR_AKM = 29,
    WIFI_REASON_NOT_AUTHORIZED_THIS_LOCATION = 30,
    WIFI_REASON_SERVICE_CHANGE_PERCLUDES_TS = 31,
    WIFI_REASON_UNSPECIFIED_QOS = 32,
    WIFI_REASON_NOT_ENOUGH_BANDWIDTH = 33,
    WIFI_REASON_MISSING_ACKS = 34,
    WIFI_REASON_EXCEEDED_TXOP = 35,
    WIFI_REASON_STA_LEAVING = 36,
    WIFI_REASON_END_BA = 37,
    WIFI_REASON_UNKNOWN_BA = 38,
    WIFI_REASON_TIMEOUT = 39,
    WIFI_REASON_PEER_INITIATED = 46,
    WIFI_REASON_AP_INITIATED = 47,
    WIFI_REASON_INVALID_FT_ACTION_FRAME_COUNT = 48,
    WIFI_REASON_INVALID_PMKID = 49,
    WIFI_REASON_INVALID_MDE = 50,
    WIFI_REASON_INVALID_FTE = 51,
    WIFI_REASON_TRANSMISSION_LINK_ESTABLISH_FAILED = 67,
    WIFI_REASON_ALTERATIVE_CHANNEL_OCCUPIED = 68,
    WIFI_REASON_BEACON_TIMEOUT = 200,
    WIFI_REASON_NO_AP_FOUND = 201,
    WIFI_REASON_AUTH_FAIL = 202,
    WIFI_REASON_ASSOC_FAIL = 203,
    WIFI_REASON_HANDSHAKE_TIMEOUT = 204,
    WIFI_REASON_CONNECTION_FAIL = 205,
    WIFI_REASON_AP_TSF_RESET = 206,
    WIFI_REASON_ROAMING = 207,
    WIFI_REASON_ASSOC_COMEBACK_TIME_TOO_LONG = 208,
    WIFI_REASON_SA_QUERY_TIMEOUT = 209,
    WIFI_REASON_NO_AP_FOUND_W_COMPATIBLE_SECURITY = 210,
    WIFI_REASON_NO_AP_FOUND_IN_AUTHMODE_THRESHOLD = 211,
    WIFI_REASON_NO_AP_FOUND_IN_RSSI_THRESHOLD = 212,
};
pub const wifi_second_chan_t = enum(c_uint) {
    WIFI_SECOND_CHAN_NONE = 0,
    WIFI_SECOND_CHAN_ABOVE = 1,
    WIFI_SECOND_CHAN_BELOW = 2,
};
pub const wifi_scan_type_t = enum(c_uint) {
    WIFI_SCAN_TYPE_ACTIVE = 0,
    WIFI_SCAN_TYPE_PASSIVE = 1,
};
pub const wifi_active_scan_time_t = extern struct {
    min: u32 = std.mem.zeroes(u32),
    max: u32 = std.mem.zeroes(u32),
};
pub const wifi_scan_time_t = extern struct {
    active: wifi_active_scan_time_t = std.mem.zeroes(wifi_active_scan_time_t),
    passive: u32 = std.mem.zeroes(u32),
};
pub const wifi_scan_config_t = extern struct {
    ssid: [*:0]u8 = std.mem.zeroes([*:0]u8),
    bssid: [*:0]u8 = std.mem.zeroes([*:0]u8),
    channel: u8 = std.mem.zeroes(u8),
    show_hidden: bool = std.mem.zeroes(bool),
    scan_type: wifi_scan_type_t = std.mem.zeroes(wifi_scan_type_t),
    scan_time: wifi_scan_time_t = std.mem.zeroes(wifi_scan_time_t),
    home_chan_dwell_time: u8 = std.mem.zeroes(u8),
};
pub const wifi_cipher_type_t = enum(c_uint) {
    WIFI_CIPHER_TYPE_NONE = 0,
    WIFI_CIPHER_TYPE_WEP40 = 1,
    WIFI_CIPHER_TYPE_WEP104 = 2,
    WIFI_CIPHER_TYPE_TKIP = 3,
    WIFI_CIPHER_TYPE_CCMP = 4,
    WIFI_CIPHER_TYPE_TKIP_CCMP = 5,
    WIFI_CIPHER_TYPE_AES_CMAC128 = 6,
    WIFI_CIPHER_TYPE_SMS4 = 7,
    WIFI_CIPHER_TYPE_GCMP = 8,
    WIFI_CIPHER_TYPE_GCMP256 = 9,
    WIFI_CIPHER_TYPE_AES_GMAC128 = 10,
    WIFI_CIPHER_TYPE_AES_GMAC256 = 11,
    WIFI_CIPHER_TYPE_UNKNOWN = 12,
};
pub const wifi_ant_t = enum(c_uint) {
    WIFI_ANT_ANT0 = 0,
    WIFI_ANT_ANT1 = 1,
    WIFI_ANT_MAX = 2,
};
// esp-idf/components/esp_wifi/include/esp_wifi_types_generic.h:207:13: warning: struct demoted to opaque type - has bitfield
pub const wifi_he_ap_info_t = opaque {};
// esp-idf/components/esp_wifi/include/esp_wifi_types_generic.h:224:14: warning: struct demoted to opaque type - has bitfield
pub const wifi_ap_record_t = opaque {};
pub const wifi_scan_method_t = enum(c_uint) {
    WIFI_FAST_SCAN = 0,
    WIFI_ALL_CHANNEL_SCAN = 1,
};
pub const wifi_sort_method_t = enum(c_uint) {
    WIFI_CONNECT_AP_BY_SIGNAL = 0,
    WIFI_CONNECT_AP_BY_SECURITY = 1,
};
pub const wifi_scan_threshold_t = extern struct {
    rssi: i8 = std.mem.zeroes(i8),
    authmode: wifi_auth_mode_t = std.mem.zeroes(wifi_auth_mode_t),
};

pub const wifi_ps_type_t = enum(c_uint) {
    WIFI_PS_NONE = 0,
    WIFI_PS_MIN_MODEM = 1,
    WIFI_PS_MAX_MODEM = 2,
};
pub const wifi_bandwidth_t = enum(c_uint) {
    WIFI_BW_HT20 = 1,
    WIFI_BW_HT40 = 2,
};
pub const wifi_pmf_config_t = extern struct {
    capable: bool = std.mem.zeroes(bool),
    required: bool = std.mem.zeroes(bool),
};
pub const wifi_sae_pwe_method_t = enum(c_uint) {
    WPA3_SAE_PWE_UNSPECIFIED = 0,
    WPA3_SAE_PWE_HUNT_AND_PECK = 1,
    WPA3_SAE_PWE_HASH_TO_ELEMENT = 2,
    WPA3_SAE_PWE_BOTH = 3,
};
pub const wifi_sae_pk_mode_t = enum(c_uint) {
    WPA3_SAE_PK_MODE_AUTOMATIC = 0,
    WPA3_SAE_PK_MODE_ONLY = 1,
    WPA3_SAE_PK_MODE_DISABLED = 2,
};
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
pub const wifi_storage_t = enum(c_uint) {
    WIFI_STORAGE_FLASH = 0,
    WIFI_STORAGE_RAM = 1,
};
pub const wifi_vendor_ie_type_t = enum(c_uint) {
    WIFI_VND_IE_TYPE_BEACON = 0,
    WIFI_VND_IE_TYPE_PROBE_REQ = 1,
    WIFI_VND_IE_TYPE_PROBE_RESP = 2,
    WIFI_VND_IE_TYPE_ASSOC_REQ = 3,
    WIFI_VND_IE_TYPE_ASSOC_RESP = 4,
};
pub const wifi_vendor_ie_id_t = enum(c_uint) {
    WIFI_VND_IE_ID_0 = 0,
    WIFI_VND_IE_ID_1 = 1,
};
pub const wifi_phy_mode_t = enum(c_uint) {
    WIFI_PHY_MODE_LR = 0,
    WIFI_PHY_MODE_11B = 1,
    WIFI_PHY_MODE_11G = 2,
    WIFI_PHY_MODE_HT20 = 3,
    WIFI_PHY_MODE_HT40 = 4,
    WIFI_PHY_MODE_HE20 = 5,
};
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
pub const wifi_promiscuous_pkt_type_t = enum(c_uint) {
    WIFI_PKT_MGMT = 0,
    WIFI_PKT_CTRL = 1,
    WIFI_PKT_DATA = 2,
    WIFI_PKT_MISC = 3,
};
pub const wifi_promiscuous_filter_t = extern struct {
    filter_mask: u32 = std.mem.zeroes(u32),
};
pub const wifi_csi_info_t = extern struct {
    rx_ctrl: wifi_pkt_rx_ctrl_t = std.mem.zeroes(wifi_pkt_rx_ctrl_t),
    mac: [6]u8 = std.mem.zeroes([6]u8),
    dmac: [6]u8 = std.mem.zeroes([6]u8),
    first_word_invalid: bool = std.mem.zeroes(bool),
    buf: [*:0]i8 = std.mem.zeroes([*:0]i8),
    len: u16 = std.mem.zeroes(u16),
    hdr: [*:0]u8 = std.mem.zeroes([*:0]u8),
    payload: [*:0]u8 = std.mem.zeroes([*:0]u8),
    payload_len: u16 = std.mem.zeroes(u16),
};
// esp-idf/components/esp_wifi/include/esp_wifi_types_generic.h:490:13: warning: struct demoted to opaque type - has bitfield
pub const wifi_ant_gpio_t = opaque {};
pub const wifi_ant_gpio_config_t = extern struct {
    gpio_cfg: [4]wifi_ant_gpio_t = std.mem.zeroes([4]wifi_ant_gpio_t),
};
pub const wifi_ant_mode_t = enum(c_uint) {
    WIFI_ANT_MODE_ANT0 = 0,
    WIFI_ANT_MODE_ANT1 = 1,
    WIFI_ANT_MODE_AUTO = 2,
    WIFI_ANT_MODE_MAX = 3,
};
// esp-idf/components/esp_wifi/include/esp_wifi_types_generic.h:521:21: warning: struct demoted to opaque type - has bitfield
pub const wifi_ant_config_t = opaque {};
pub const wifi_action_rx_cb_t = ?*const fn ([*:0]u8, [*:0]u8, usize, u8) callconv(.C) c_int;
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

pub const wifi_nan_service_type_t = enum(c_uint) {
    NAN_PUBLISH_SOLICITED = 0,
    NAN_PUBLISH_UNSOLICITED = 1,
    NAN_SUBSCRIBE_ACTIVE = 2,
    NAN_SUBSCRIBE_PASSIVE = 3,
};
// esp-idf/components/esp_wifi/include/esp_wifi_types_generic.h:591:13: warning: struct demoted to opaque type - has bitfield
pub const wifi_nan_publish_cfg_t = opaque {};
// esp-idf/components/esp_wifi/include/esp_wifi_types_generic.h:605:13: warning: struct demoted to opaque type - has bitfield
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
pub const wifi_phy_rate_t = enum(c_uint) {
    WIFI_PHY_RATE_1M_L = 0,
    WIFI_PHY_RATE_2M_L = 1,
    WIFI_PHY_RATE_5M_L = 2,
    WIFI_PHY_RATE_11M_L = 3,
    WIFI_PHY_RATE_2M_S = 5,
    WIFI_PHY_RATE_5M_S = 6,
    WIFI_PHY_RATE_11M_S = 7,
    WIFI_PHY_RATE_48M = 8,
    WIFI_PHY_RATE_24M = 9,
    WIFI_PHY_RATE_12M = 10,
    WIFI_PHY_RATE_6M = 11,
    WIFI_PHY_RATE_54M = 12,
    WIFI_PHY_RATE_36M = 13,
    WIFI_PHY_RATE_18M = 14,
    WIFI_PHY_RATE_9M = 15,
    WIFI_PHY_RATE_MCS0_LGI = 16,
    WIFI_PHY_RATE_MCS1_LGI = 17,
    WIFI_PHY_RATE_MCS2_LGI = 18,
    WIFI_PHY_RATE_MCS3_LGI = 19,
    WIFI_PHY_RATE_MCS4_LGI = 20,
    WIFI_PHY_RATE_MCS5_LGI = 21,
    WIFI_PHY_RATE_MCS6_LGI = 22,
    WIFI_PHY_RATE_MCS7_LGI = 23,
    WIFI_PHY_RATE_MCS8_LGI = 24,
    WIFI_PHY_RATE_MCS9_LGI = 25,
    WIFI_PHY_RATE_MCS0_SGI = 26,
    WIFI_PHY_RATE_MCS1_SGI = 27,
    WIFI_PHY_RATE_MCS2_SGI = 28,
    WIFI_PHY_RATE_MCS3_SGI = 29,
    WIFI_PHY_RATE_MCS4_SGI = 30,
    WIFI_PHY_RATE_MCS5_SGI = 31,
    WIFI_PHY_RATE_MCS6_SGI = 32,
    WIFI_PHY_RATE_MCS7_SGI = 33,
    WIFI_PHY_RATE_MCS8_SGI = 34,
    WIFI_PHY_RATE_MCS9_SGI = 35,
    WIFI_PHY_RATE_LORA_250K = 41,
    WIFI_PHY_RATE_LORA_500K = 42,
    WIFI_PHY_RATE_MAX = 43,
};
pub const wifi_event_t = enum(c_uint) {
    WIFI_EVENT_WIFI_READY = 0,
    WIFI_EVENT_SCAN_DONE = 1,
    WIFI_EVENT_STA_START = 2,
    WIFI_EVENT_STA_STOP = 3,
    WIFI_EVENT_STA_CONNECTED = 4,
    WIFI_EVENT_STA_DISCONNECTED = 5,
    WIFI_EVENT_STA_AUTHMODE_CHANGE = 6,
    WIFI_EVENT_STA_WPS_ER_SUCCESS = 7,
    WIFI_EVENT_STA_WPS_ER_FAILED = 8,
    WIFI_EVENT_STA_WPS_ER_TIMEOUT = 9,
    WIFI_EVENT_STA_WPS_ER_PIN = 10,
    WIFI_EVENT_STA_WPS_ER_PBC_OVERLAP = 11,
    WIFI_EVENT_AP_START = 12,
    WIFI_EVENT_AP_STOP = 13,
    WIFI_EVENT_AP_STACONNECTED = 14,
    WIFI_EVENT_AP_STADISCONNECTED = 15,
    WIFI_EVENT_AP_PROBEREQRECVED = 16,
    WIFI_EVENT_FTM_REPORT = 17,
    WIFI_EVENT_STA_BSS_RSSI_LOW = 18,
    WIFI_EVENT_ACTION_TX_STATUS = 19,
    WIFI_EVENT_ROC_DONE = 20,
    WIFI_EVENT_STA_BEACON_TIMEOUT = 21,
    WIFI_EVENT_CONNECTIONLESS_MODULE_WAKE_INTERVAL_START = 22,
    WIFI_EVENT_AP_WPS_RG_SUCCESS = 23,
    WIFI_EVENT_AP_WPS_RG_FAILED = 24,
    WIFI_EVENT_AP_WPS_RG_TIMEOUT = 25,
    WIFI_EVENT_AP_WPS_RG_PIN = 26,
    WIFI_EVENT_AP_WPS_RG_PBC_OVERLAP = 27,
    WIFI_EVENT_ITWT_SETUP = 28,
    WIFI_EVENT_ITWT_TEARDOWN = 29,
    WIFI_EVENT_ITWT_PROBE = 30,
    WIFI_EVENT_ITWT_SUSPEND = 31,
    WIFI_EVENT_NAN_STARTED = 32,
    WIFI_EVENT_NAN_STOPPED = 33,
    WIFI_EVENT_NAN_SVC_MATCH = 34,
    WIFI_EVENT_NAN_REPLIED = 35,
    WIFI_EVENT_NAN_RECEIVE = 36,
    WIFI_EVENT_NDP_INDICATION = 37,
    WIFI_EVENT_NDP_CONFIRM = 38,
    WIFI_EVENT_NDP_TERMINATED = 39,
    WIFI_EVENT_HOME_CHANNEL_CHANGE = 40,
    WIFI_EVENT_MAX = 41,
};
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
pub const wifi_event_sta_wps_fail_reason_t = enum(c_uint) {
    WPS_FAIL_REASON_NORMAL = 0,
    WPS_FAIL_REASON_RECV_M2D = 1,
    WPS_FAIL_REASON_MAX = 2,
};
const unnamed_91 = extern struct {
    ssid: [32]u8 = std.mem.zeroes([32]u8),
    passphrase: [64]u8 = std.mem.zeroes([64]u8),
};
pub const wifi_event_sta_wps_er_success_t = extern struct {
    ap_cred_cnt: u8 = std.mem.zeroes(u8),
    ap_cred: [3]unnamed_91 = std.mem.zeroes([3]unnamed_91),
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
pub const wifi_ftm_status_t = enum(c_uint) {
    FTM_STATUS_SUCCESS = 0,
    FTM_STATUS_UNSUPPORTED = 1,
    FTM_STATUS_CONF_REJECTED = 2,
    FTM_STATUS_NO_RESPONSE = 3,
    FTM_STATUS_FAIL = 4,
};
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
pub const wps_fail_reason_t = enum(c_uint) {
    WPS_AP_FAIL_REASON_NORMAL = 0,
    WPS_AP_FAIL_REASON_CONFIG = 1,
    WPS_AP_FAIL_REASON_AUTH = 2,
    WPS_AP_FAIL_REASON_MAX = 3,
};
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
pub const esp_blufi_cb_event_t = enum(c_uint) {
    ESP_BLUFI_EVENT_INIT_FINISH = 0,
    ESP_BLUFI_EVENT_DEINIT_FINISH = 1,
    ESP_BLUFI_EVENT_SET_WIFI_OPMODE = 2,
    ESP_BLUFI_EVENT_BLE_CONNECT = 3,
    ESP_BLUFI_EVENT_BLE_DISCONNECT = 4,
    ESP_BLUFI_EVENT_REQ_CONNECT_TO_AP = 5,
    ESP_BLUFI_EVENT_REQ_DISCONNECT_FROM_AP = 6,
    ESP_BLUFI_EVENT_GET_WIFI_STATUS = 7,
    ESP_BLUFI_EVENT_DEAUTHENTICATE_STA = 8,
    ESP_BLUFI_EVENT_RECV_STA_BSSID = 9,
    ESP_BLUFI_EVENT_RECV_STA_SSID = 10,
    ESP_BLUFI_EVENT_RECV_STA_PASSWD = 11,
    ESP_BLUFI_EVENT_RECV_SOFTAP_SSID = 12,
    ESP_BLUFI_EVENT_RECV_SOFTAP_PASSWD = 13,
    ESP_BLUFI_EVENT_RECV_SOFTAP_MAX_CONN_NUM = 14,
    ESP_BLUFI_EVENT_RECV_SOFTAP_AUTH_MODE = 15,
    ESP_BLUFI_EVENT_RECV_SOFTAP_CHANNEL = 16,
    ESP_BLUFI_EVENT_RECV_USERNAME = 17,
    ESP_BLUFI_EVENT_RECV_CA_CERT = 18,
    ESP_BLUFI_EVENT_RECV_CLIENT_CERT = 19,
    ESP_BLUFI_EVENT_RECV_SERVER_CERT = 20,
    ESP_BLUFI_EVENT_RECV_CLIENT_PRIV_KEY = 21,
    ESP_BLUFI_EVENT_RECV_SERVER_PRIV_KEY = 22,
    ESP_BLUFI_EVENT_RECV_SLAVE_DISCONNECT_BLE = 23,
    ESP_BLUFI_EVENT_GET_WIFI_LIST = 24,
    ESP_BLUFI_EVENT_REPORT_ERROR = 25,
    ESP_BLUFI_EVENT_RECV_CUSTOM_DATA = 26,
};
pub const esp_blufi_sta_conn_state_t = enum(c_uint) {
    ESP_BLUFI_STA_CONN_SUCCESS = 0,
    ESP_BLUFI_STA_CONN_FAIL = 1,
    ESP_BLUFI_STA_CONNECTING = 2,
    ESP_BLUFI_STA_NO_IP = 3,
};
pub const esp_blufi_init_state_t = enum(c_uint) {
    ESP_BLUFI_INIT_OK = 0,
    ESP_BLUFI_INIT_FAILED = 1,
};
pub const esp_blufi_deinit_state_t = enum(c_uint) {
    ESP_BLUFI_DEINIT_OK = 0,
    ESP_BLUFI_DEINIT_FAILED = 1,
};
pub const esp_blufi_error_state_t = enum(c_uint) {
    ESP_BLUFI_SEQUENCE_ERROR = 0,
    ESP_BLUFI_CHECKSUM_ERROR = 1,
    ESP_BLUFI_DECRYPT_ERROR = 2,
    ESP_BLUFI_ENCRYPT_ERROR = 3,
    ESP_BLUFI_INIT_SECURITY_ERROR = 4,
    ESP_BLUFI_DH_MALLOC_ERROR = 5,
    ESP_BLUFI_DH_PARAM_ERROR = 6,
    ESP_BLUFI_READ_PARAM_ERROR = 7,
    ESP_BLUFI_MAKE_PUBLIC_ERROR = 8,
    ESP_BLUFI_DATA_FORMAT_ERROR = 9,
    ESP_BLUFI_CALC_MD5_ERROR = 10,
    ESP_BLUFI_WIFI_SCAN_FAIL = 11,
    ESP_BLUFI_MSG_STATE_ERROR = 12,
};
pub const esp_blufi_extra_info_t = extern struct {
    sta_bssid: [6]u8 = std.mem.zeroes([6]u8),
    sta_bssid_set: bool = std.mem.zeroes(bool),
    sta_ssid: [*:0]u8 = std.mem.zeroes([*:0]u8),
    sta_ssid_len: c_int = std.mem.zeroes(c_int),
    sta_passwd: [*:0]u8 = std.mem.zeroes([*:0]u8),
    sta_passwd_len: c_int = std.mem.zeroes(c_int),
    softap_ssid: [*:0]u8 = std.mem.zeroes([*:0]u8),
    softap_ssid_len: c_int = std.mem.zeroes(c_int),
    softap_passwd: [*:0]u8 = std.mem.zeroes([*:0]u8),
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
    ssid: [*:0]u8 = std.mem.zeroes([*:0]u8),
    ssid_len: c_int = std.mem.zeroes(c_int),
};
pub const blufi_recv_sta_passwd_evt_param_27 = extern struct {
    passwd: [*:0]u8 = std.mem.zeroes([*:0]u8),
    passwd_len: c_int = std.mem.zeroes(c_int),
};
pub const blufi_recv_softap_ssid_evt_param_28 = extern struct {
    ssid: [*:0]u8 = std.mem.zeroes([*:0]u8),
    ssid_len: c_int = std.mem.zeroes(c_int),
};
pub const blufi_recv_softap_passwd_evt_param_29 = extern struct {
    passwd: [*:0]u8 = std.mem.zeroes([*:0]u8),
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
    name: [*:0]u8 = std.mem.zeroes([*:0]u8),
    name_len: c_int = std.mem.zeroes(c_int),
};
pub const blufi_recv_ca_evt_param_34 = extern struct {
    cert: [*:0]u8 = std.mem.zeroes([*:0]u8),
    cert_len: c_int = std.mem.zeroes(c_int),
};
pub const blufi_recv_client_cert_evt_param_35 = extern struct {
    cert: [*:0]u8 = std.mem.zeroes([*:0]u8),
    cert_len: c_int = std.mem.zeroes(c_int),
};
pub const blufi_recv_server_cert_evt_param_36 = extern struct {
    cert: [*:0]u8 = std.mem.zeroes([*:0]u8),
    cert_len: c_int = std.mem.zeroes(c_int),
};
pub const blufi_recv_client_pkey_evt_param_37 = extern struct {
    pkey: [*:0]u8 = std.mem.zeroes([*:0]u8),
    pkey_len: c_int = std.mem.zeroes(c_int),
};
pub const blufi_recv_server_pkey_evt_param_38 = extern struct {
    pkey: [*:0]u8 = std.mem.zeroes([*:0]u8),
    pkey_len: c_int = std.mem.zeroes(c_int),
};
pub const blufi_get_error_evt_param_39 = extern struct {
    state: esp_blufi_error_state_t = std.mem.zeroes(esp_blufi_error_state_t),
};
pub const blufi_recv_custom_data_evt_param_40 = extern struct {
    data: [*:0]u8 = std.mem.zeroes([*:0]u8),
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
pub const esp_blufi_negotiate_data_handler_t = ?*const fn ([*:0]u8, c_int, [*c][*c]u8, [*c]c_int, [*c]bool) callconv(.C) void;
pub const esp_blufi_encrypt_func_t = ?*const fn (u8, [*:0]u8, c_int) callconv(.C) c_int;
pub const esp_blufi_decrypt_func_t = ?*const fn (u8, [*:0]u8, c_int) callconv(.C) c_int;
pub const esp_blufi_checksum_func_t = ?*const fn (u8, [*:0]u8, c_int) callconv(.C) u16;
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
pub extern fn esp_blufi_send_custom_data(data: [*:0]u8, data_len: u32) esp_err_t;
pub const esp_ble_key_type_t = u8;
pub const esp_ble_auth_req_t = u8;
pub const esp_ble_io_cap_t = u8;
pub const esp_ble_dtm_pkt_payload_t = u8;
pub const esp_gap_ble_cb_event_t = enum(c_uint) {
    ESP_GAP_BLE_ADV_DATA_SET_COMPLETE_EVT = 0,
    ESP_GAP_BLE_SCAN_RSP_DATA_SET_COMPLETE_EVT = 1,
    ESP_GAP_BLE_SCAN_PARAM_SET_COMPLETE_EVT = 2,
    ESP_GAP_BLE_SCAN_RESULT_EVT = 3,
    ESP_GAP_BLE_ADV_DATA_RAW_SET_COMPLETE_EVT = 4,
    ESP_GAP_BLE_SCAN_RSP_DATA_RAW_SET_COMPLETE_EVT = 5,
    ESP_GAP_BLE_ADV_START_COMPLETE_EVT = 6,
    ESP_GAP_BLE_SCAN_START_COMPLETE_EVT = 7,
    ESP_GAP_BLE_AUTH_CMPL_EVT = 8,
    ESP_GAP_BLE_KEY_EVT = 9,
    ESP_GAP_BLE_SEC_REQ_EVT = 10,
    ESP_GAP_BLE_PASSKEY_NOTIF_EVT = 11,
    ESP_GAP_BLE_PASSKEY_REQ_EVT = 12,
    ESP_GAP_BLE_OOB_REQ_EVT = 13,
    ESP_GAP_BLE_LOCAL_IR_EVT = 14,
    ESP_GAP_BLE_LOCAL_ER_EVT = 15,
    ESP_GAP_BLE_NC_REQ_EVT = 16,
    ESP_GAP_BLE_ADV_STOP_COMPLETE_EVT = 17,
    ESP_GAP_BLE_SCAN_STOP_COMPLETE_EVT = 18,
    ESP_GAP_BLE_SET_STATIC_RAND_ADDR_EVT = 19,
    ESP_GAP_BLE_UPDATE_CONN_PARAMS_EVT = 20,
    ESP_GAP_BLE_SET_PKT_LENGTH_COMPLETE_EVT = 21,
    ESP_GAP_BLE_SET_LOCAL_PRIVACY_COMPLETE_EVT = 22,
    ESP_GAP_BLE_REMOVE_BOND_DEV_COMPLETE_EVT = 23,
    ESP_GAP_BLE_CLEAR_BOND_DEV_COMPLETE_EVT = 24,
    ESP_GAP_BLE_GET_BOND_DEV_COMPLETE_EVT = 25,
    ESP_GAP_BLE_READ_RSSI_COMPLETE_EVT = 26,
    ESP_GAP_BLE_UPDATE_WHITELIST_COMPLETE_EVT = 27,
    ESP_GAP_BLE_UPDATE_DUPLICATE_EXCEPTIONAL_LIST_COMPLETE_EVT = 28,
    ESP_GAP_BLE_SET_CHANNELS_EVT = 29,
    ESP_GAP_BLE_READ_PHY_COMPLETE_EVT = 30,
    ESP_GAP_BLE_SET_PREFERRED_DEFAULT_PHY_COMPLETE_EVT = 31,
    ESP_GAP_BLE_SET_PREFERRED_PHY_COMPLETE_EVT = 32,
    ESP_GAP_BLE_EXT_ADV_SET_RAND_ADDR_COMPLETE_EVT = 33,
    ESP_GAP_BLE_EXT_ADV_SET_PARAMS_COMPLETE_EVT = 34,
    ESP_GAP_BLE_EXT_ADV_DATA_SET_COMPLETE_EVT = 35,
    ESP_GAP_BLE_EXT_SCAN_RSP_DATA_SET_COMPLETE_EVT = 36,
    ESP_GAP_BLE_EXT_ADV_START_COMPLETE_EVT = 37,
    ESP_GAP_BLE_EXT_ADV_STOP_COMPLETE_EVT = 38,
    ESP_GAP_BLE_EXT_ADV_SET_REMOVE_COMPLETE_EVT = 39,
    ESP_GAP_BLE_EXT_ADV_SET_CLEAR_COMPLETE_EVT = 40,
    ESP_GAP_BLE_PERIODIC_ADV_SET_PARAMS_COMPLETE_EVT = 41,
    ESP_GAP_BLE_PERIODIC_ADV_DATA_SET_COMPLETE_EVT = 42,
    ESP_GAP_BLE_PERIODIC_ADV_START_COMPLETE_EVT = 43,
    ESP_GAP_BLE_PERIODIC_ADV_STOP_COMPLETE_EVT = 44,
    ESP_GAP_BLE_PERIODIC_ADV_CREATE_SYNC_COMPLETE_EVT = 45,
    ESP_GAP_BLE_PERIODIC_ADV_SYNC_CANCEL_COMPLETE_EVT = 46,
    ESP_GAP_BLE_PERIODIC_ADV_SYNC_TERMINATE_COMPLETE_EVT = 47,
    ESP_GAP_BLE_PERIODIC_ADV_ADD_DEV_COMPLETE_EVT = 48,
    ESP_GAP_BLE_PERIODIC_ADV_REMOVE_DEV_COMPLETE_EVT = 49,
    ESP_GAP_BLE_PERIODIC_ADV_CLEAR_DEV_COMPLETE_EVT = 50,
    ESP_GAP_BLE_SET_EXT_SCAN_PARAMS_COMPLETE_EVT = 51,
    ESP_GAP_BLE_EXT_SCAN_START_COMPLETE_EVT = 52,
    ESP_GAP_BLE_EXT_SCAN_STOP_COMPLETE_EVT = 53,
    ESP_GAP_BLE_PREFER_EXT_CONN_PARAMS_SET_COMPLETE_EVT = 54,
    ESP_GAP_BLE_PHY_UPDATE_COMPLETE_EVT = 55,
    ESP_GAP_BLE_EXT_ADV_REPORT_EVT = 56,
    ESP_GAP_BLE_SCAN_TIMEOUT_EVT = 57,
    ESP_GAP_BLE_ADV_TERMINATED_EVT = 58,
    ESP_GAP_BLE_SCAN_REQ_RECEIVED_EVT = 59,
    ESP_GAP_BLE_CHANNEL_SELECT_ALGORITHM_EVT = 60,
    ESP_GAP_BLE_PERIODIC_ADV_REPORT_EVT = 61,
    ESP_GAP_BLE_PERIODIC_ADV_SYNC_LOST_EVT = 62,
    ESP_GAP_BLE_PERIODIC_ADV_SYNC_ESTAB_EVT = 63,
    ESP_GAP_BLE_SC_OOB_REQ_EVT = 64,
    ESP_GAP_BLE_SC_CR_LOC_OOB_EVT = 65,
    ESP_GAP_BLE_GET_DEV_NAME_COMPLETE_EVT = 66,
    ESP_GAP_BLE_PERIODIC_ADV_RECV_ENABLE_COMPLETE_EVT = 67,
    ESP_GAP_BLE_PERIODIC_ADV_SYNC_TRANS_COMPLETE_EVT = 68,
    ESP_GAP_BLE_PERIODIC_ADV_SET_INFO_TRANS_COMPLETE_EVT = 69,
    ESP_GAP_BLE_SET_PAST_PARAMS_COMPLETE_EVT = 70,
    ESP_GAP_BLE_PERIODIC_ADV_SYNC_TRANS_RECV_EVT = 71,
    ESP_GAP_BLE_DTM_TEST_UPDATE_EVT = 72,
    ESP_GAP_BLE_ADV_CLEAR_COMPLETE_EVT = 73,
    ESP_GAP_BLE_EVT_MAX = 74,
};
pub const esp_gap_ble_channels = [5]u8;
pub const esp_ble_adv_data_type = enum(c_uint) {
    ESP_BLE_AD_TYPE_FLAG = 1,
    ESP_BLE_AD_TYPE_16SRV_PART = 2,
    ESP_BLE_AD_TYPE_16SRV_CMPL = 3,
    ESP_BLE_AD_TYPE_32SRV_PART = 4,
    ESP_BLE_AD_TYPE_32SRV_CMPL = 5,
    ESP_BLE_AD_TYPE_128SRV_PART = 6,
    ESP_BLE_AD_TYPE_128SRV_CMPL = 7,
    ESP_BLE_AD_TYPE_NAME_SHORT = 8,
    ESP_BLE_AD_TYPE_NAME_CMPL = 9,
    ESP_BLE_AD_TYPE_TX_PWR = 10,
    ESP_BLE_AD_TYPE_DEV_CLASS = 13,
    ESP_BLE_AD_TYPE_SM_TK = 16,
    ESP_BLE_AD_TYPE_SM_OOB_FLAG = 17,
    ESP_BLE_AD_TYPE_INT_RANGE = 18,
    ESP_BLE_AD_TYPE_SOL_SRV_UUID = 20,
    ESP_BLE_AD_TYPE_128SOL_SRV_UUID = 21,
    ESP_BLE_AD_TYPE_SERVICE_DATA = 22,
    ESP_BLE_AD_TYPE_PUBLIC_TARGET = 23,
    ESP_BLE_AD_TYPE_RANDOM_TARGET = 24,
    ESP_BLE_AD_TYPE_APPEARANCE = 25,
    ESP_BLE_AD_TYPE_ADV_INT = 26,
    ESP_BLE_AD_TYPE_LE_DEV_ADDR = 27,
    ESP_BLE_AD_TYPE_LE_ROLE = 28,
    ESP_BLE_AD_TYPE_SPAIR_C256 = 29,
    ESP_BLE_AD_TYPE_SPAIR_R256 = 30,
    ESP_BLE_AD_TYPE_32SOL_SRV_UUID = 31,
    ESP_BLE_AD_TYPE_32SERVICE_DATA = 32,
    ESP_BLE_AD_TYPE_128SERVICE_DATA = 33,
    ESP_BLE_AD_TYPE_LE_SECURE_CONFIRM = 34,
    ESP_BLE_AD_TYPE_LE_SECURE_RANDOM = 35,
    ESP_BLE_AD_TYPE_URI = 36,
    ESP_BLE_AD_TYPE_INDOOR_POSITION = 37,
    ESP_BLE_AD_TYPE_TRANS_DISC_DATA = 38,
    ESP_BLE_AD_TYPE_LE_SUPPORT_FEATURE = 39,
    ESP_BLE_AD_TYPE_CHAN_MAP_UPDATE = 40,
    ESP_BLE_AD_MANUFACTURER_SPECIFIC_TYPE = 255,
};
pub const esp_ble_adv_type_t = enum(c_uint) {
    ADV_TYPE_IND = 0,
    ADV_TYPE_DIRECT_IND_HIGH = 1,
    ADV_TYPE_SCAN_IND = 2,
    ADV_TYPE_NONCONN_IND = 3,
    ADV_TYPE_DIRECT_IND_LOW = 4,
};
pub const esp_ble_adv_channel_t = enum(c_uint) {
    ADV_CHNL_37 = 1,
    ADV_CHNL_38 = 2,
    ADV_CHNL_39 = 4,
    ADV_CHNL_ALL = 7,
};
pub const esp_ble_adv_filter_t = enum(c_uint) {
    ADV_FILTER_ALLOW_SCAN_ANY_CON_ANY = 0,
    ADV_FILTER_ALLOW_SCAN_WLST_CON_ANY = 1,
    ADV_FILTER_ALLOW_SCAN_ANY_CON_WLST = 2,
    ADV_FILTER_ALLOW_SCAN_WLST_CON_WLST = 3,
};
pub const esp_ble_sec_act_t = enum(c_uint) {
    ESP_BLE_SEC_ENCRYPT = 1,
    ESP_BLE_SEC_ENCRYPT_NO_MITM = 2,
    ESP_BLE_SEC_ENCRYPT_MITM = 3,
};
pub const esp_ble_sm_param_t = enum(c_uint) {
    ESP_BLE_SM_PASSKEY = 0,
    ESP_BLE_SM_AUTHEN_REQ_MODE = 1,
    ESP_BLE_SM_IOCAP_MODE = 2,
    ESP_BLE_SM_SET_INIT_KEY = 3,
    ESP_BLE_SM_SET_RSP_KEY = 4,
    ESP_BLE_SM_MAX_KEY_SIZE = 5,
    ESP_BLE_SM_MIN_KEY_SIZE = 6,
    ESP_BLE_SM_SET_STATIC_PASSKEY = 7,
    ESP_BLE_SM_CLEAR_STATIC_PASSKEY = 8,
    ESP_BLE_SM_ONLY_ACCEPT_SPECIFIED_SEC_AUTH = 9,
    ESP_BLE_SM_OOB_SUPPORT = 10,
    ESP_BLE_APP_ENC_KEY_SIZE = 11,
    ESP_BLE_SM_MAX_PARAM = 12,
};
pub const esp_ble_dtm_update_evt_t = enum(c_uint) {
    DTM_TX_START_EVT = 0,
    DTM_RX_START_EVT = 1,
    DTM_TEST_STOP_EVT = 2,
};
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
    p_manufacturer_data: [*:0]u8 = std.mem.zeroes([*:0]u8),
    service_data_len: u16 = std.mem.zeroes(u16),
    p_service_data: [*:0]u8 = std.mem.zeroes([*:0]u8),
    service_uuid_len: u16 = std.mem.zeroes(u16),
    p_service_uuid: [*:0]u8 = std.mem.zeroes([*:0]u8),
    flag: u8 = std.mem.zeroes(u8),
};
pub const esp_ble_scan_type_t = enum(c_uint) {
    BLE_SCAN_TYPE_PASSIVE = 0,
    BLE_SCAN_TYPE_ACTIVE = 1,
};
pub const esp_ble_scan_filter_t = enum(c_uint) {
    BLE_SCAN_FILTER_ALLOW_ALL = 0,
    BLE_SCAN_FILTER_ALLOW_ONLY_WLST = 1,
    BLE_SCAN_FILTER_ALLOW_UND_RPA_DIR = 2,
    BLE_SCAN_FILTER_ALLOW_WLIST_RPA_DIR = 3,
};
pub const esp_ble_scan_duplicate_t = enum(c_uint) {
    BLE_SCAN_DUPLICATE_DISABLE = 0,
    BLE_SCAN_DUPLICATE_ENABLE = 1,
    BLE_SCAN_DUPLICATE_ENABLE_RESET = 2,
    BLE_SCAN_DUPLICATE_MAX = 3,
};
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
pub const esp_gap_search_evt_t = enum(c_uint) {
    ESP_GAP_SEARCH_INQ_RES_EVT = 0,
    ESP_GAP_SEARCH_INQ_CMPL_EVT = 1,
    ESP_GAP_SEARCH_DISC_RES_EVT = 2,
    ESP_GAP_SEARCH_DISC_BLE_RES_EVT = 3,
    ESP_GAP_SEARCH_DISC_CMPL_EVT = 4,
    ESP_GAP_SEARCH_DI_DISC_CMPL_EVT = 5,
    ESP_GAP_SEARCH_SEARCH_CANCEL_CMPL_EVT = 6,
    ESP_GAP_SEARCH_INQ_DISCARD_NUM_EVT = 7,
};
pub const esp_ble_evt_type_t = enum(c_uint) {
    ESP_BLE_EVT_CONN_ADV = 0,
    ESP_BLE_EVT_CONN_DIR_ADV = 1,
    ESP_BLE_EVT_DISC_ADV = 2,
    ESP_BLE_EVT_NON_CONN_ADV = 3,
    ESP_BLE_EVT_SCAN_RSP = 4,
};
pub const esp_ble_wl_operation_t = enum(c_uint) {
    ESP_BLE_WHITELIST_REMOVE = 0,
    ESP_BLE_WHITELIST_ADD = 1,
    ESP_BLE_WHITELIST_CLEAR = 2,
};
pub const esp_bt_duplicate_exceptional_subcode_type_t = enum(c_uint) {
    ESP_BLE_DUPLICATE_EXCEPTIONAL_LIST_ADD = 0,
    ESP_BLE_DUPLICATE_EXCEPTIONAL_LIST_REMOVE = 1,
    ESP_BLE_DUPLICATE_EXCEPTIONAL_LIST_CLEAN = 2,
};
pub const esp_ble_duplicate_exceptional_info_type_t = enum(c_uint) {
    ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_INFO_ADV_ADDR = 0,
    ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_INFO_MESH_LINK_ID = 1,
    ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_INFO_MESH_BEACON_TYPE = 2,
    ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_INFO_MESH_PROV_SRV_ADV = 3,
    ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_INFO_MESH_PROXY_SRV_ADV = 4,
    ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_INFO_MESH_PROXY_SOLIC_ADV = 5,
    ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_INFO_MESH_URI_ADV = 6,
};
pub const esp_duplicate_scan_exceptional_list_type_t = enum(c_uint) {
    ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_ADDR_LIST = 1,
    ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_MESH_LINK_ID_LIST = 2,
    ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_MESH_BEACON_TYPE_LIST = 4,
    ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_MESH_PROV_SRV_ADV_LIST = 8,
    ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_MESH_PROXY_SRV_ADV_LIST = 16,
    ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_MESH_PROXY_SOLIC_ADV_LIST = 32,
    ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_MESH_URI_ADV_LIST = 64,
    ESP_BLE_DUPLICATE_SCAN_EXCEPTIONAL_ALL_LIST = 65535,
};
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
    name: [*:0]u8 = std.mem.zeroes([*:0]u8),
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
pub extern fn esp_ble_gap_set_pkt_data_len(remote_device: [*:0]u8, tx_data_length: u16) esp_err_t;
pub extern fn esp_ble_gap_set_rand_addr(rand_addr: [*:0]u8) esp_err_t;
pub extern fn esp_ble_gap_clear_rand_addr() esp_err_t;
pub extern fn esp_ble_gap_config_local_privacy(privacy_enable: bool) esp_err_t;
pub extern fn esp_ble_gap_config_local_icon(icon: u16) esp_err_t;
pub extern fn esp_ble_gap_update_whitelist(add_remove: bool, remote_bda: [*:0]u8, wl_addr_type: esp_ble_wl_addr_type_t) esp_err_t;
pub extern fn esp_ble_gap_clear_whitelist() esp_err_t;
pub extern fn esp_ble_gap_get_whitelist_size(length: [*c]u16) esp_err_t;
pub extern fn esp_ble_gap_set_prefer_conn_params(bd_addr: [*:0]u8, min_conn_int: u16, max_conn_int: u16, slave_latency: u16, supervision_tout: u16) esp_err_t;
pub extern fn esp_ble_gap_set_device_name(name: [*:0]const u8) esp_err_t;
pub extern fn esp_ble_gap_get_device_name() esp_err_t;
pub extern fn esp_ble_gap_get_local_used_addr(local_used_addr: [*:0]u8, addr_type: [*:0]u8) esp_err_t;
pub extern fn esp_ble_resolve_adv_data(adv_data: [*:0]u8, @"type": u8, length: [*:0]u8) [*:0]u8;
pub extern fn esp_ble_gap_config_adv_data_raw(raw_data: [*:0]u8, raw_data_len: u32) esp_err_t;
pub extern fn esp_ble_gap_config_scan_rsp_data_raw(raw_data: [*:0]u8, raw_data_len: u32) esp_err_t;
pub extern fn esp_ble_gap_read_rssi(remote_addr: [*:0]u8) esp_err_t;
pub extern fn esp_ble_gap_add_duplicate_scan_exceptional_device(@"type": esp_ble_duplicate_exceptional_info_type_t, device_info: [*:0]u8) esp_err_t;
pub extern fn esp_ble_gap_remove_duplicate_scan_exceptional_device(@"type": esp_ble_duplicate_exceptional_info_type_t, device_info: [*:0]u8) esp_err_t;
pub extern fn esp_ble_gap_clean_duplicate_scan_exceptional_list(list_type: esp_duplicate_scan_exceptional_list_type_t) esp_err_t;
pub extern fn esp_ble_gap_set_security_param(param_type: esp_ble_sm_param_t, value: ?*anyopaque, len: u8) esp_err_t;
pub extern fn esp_ble_gap_security_rsp(bd_addr: [*:0]u8, accept: bool) esp_err_t;
pub extern fn esp_ble_set_encryption(bd_addr: [*:0]u8, sec_act: esp_ble_sec_act_t) esp_err_t;
pub extern fn esp_ble_passkey_reply(bd_addr: [*:0]u8, accept: bool, passkey: u32) esp_err_t;
pub extern fn esp_ble_confirm_reply(bd_addr: [*:0]u8, accept: bool) esp_err_t;
pub extern fn esp_ble_remove_bond_device(bd_addr: [*:0]u8) esp_err_t;
pub extern fn esp_ble_get_bond_device_num() c_int;
pub extern fn esp_ble_get_bond_device_list(dev_num: [*c]c_int, dev_list: [*c]esp_ble_bond_dev_t) esp_err_t;
pub extern fn esp_ble_oob_req_reply(bd_addr: [*:0]u8, TK: [*:0]u8, len: u8) esp_err_t;
pub extern fn esp_ble_sc_oob_req_reply(bd_addr: [*:0]u8, p_c: [*:0]u8, p_r: [*:0]u8) esp_err_t;
pub extern fn esp_ble_create_sc_oob_data() esp_err_t;
pub extern fn esp_ble_gap_disconnect(remote_device: [*:0]u8) esp_err_t;
pub extern fn esp_ble_get_current_conn_params(bd_addr: [*:0]u8, conn_params: [*c]esp_gap_conn_params_t) esp_err_t;
pub extern fn esp_gap_ble_set_channels(channels: [*:0]u8) esp_err_t;
pub extern fn esp_gap_ble_set_authorization(bd_addr: [*:0]u8, authorize: bool) esp_err_t;
pub extern fn esp_ble_gap_read_phy(bd_addr: [*:0]u8) esp_err_t;
pub extern fn esp_ble_gap_set_preferred_default_phy(tx_phy_mask: esp_ble_gap_phy_mask_t, rx_phy_mask: esp_ble_gap_phy_mask_t) esp_err_t;
pub extern fn esp_ble_gap_set_preferred_phy(bd_addr: [*:0]u8, all_phys_mask: esp_ble_gap_all_phys_t, tx_phy_mask: esp_ble_gap_phy_mask_t, rx_phy_mask: esp_ble_gap_phy_mask_t, phy_options: esp_ble_gap_prefer_phy_options_t) esp_err_t;
pub extern fn esp_ble_gap_ext_adv_set_rand_addr(instance: u8, rand_addr: [*:0]u8) esp_err_t;
pub extern fn esp_ble_gap_ext_adv_set_params(instance: u8, params: [*c]const esp_ble_gap_ext_adv_params_t) esp_err_t;
pub extern fn esp_ble_gap_config_ext_adv_data_raw(instance: u8, length: u16, data: [*:0]const u8) esp_err_t;
pub extern fn esp_ble_gap_config_ext_scan_rsp_data_raw(instance: u8, length: u16, scan_rsp_data: [*:0]const u8) esp_err_t;
pub extern fn esp_ble_gap_ext_adv_start(num_adv: u8, ext_adv: [*c]const esp_ble_gap_ext_adv_t) esp_err_t;
pub extern fn esp_ble_gap_ext_adv_stop(num_adv: u8, ext_adv_inst: [*:0]const u8) esp_err_t;
pub extern fn esp_ble_gap_ext_adv_set_remove(instance: u8) esp_err_t;
pub extern fn esp_ble_gap_ext_adv_set_clear() esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_set_params(instance: u8, params: [*c]const esp_ble_gap_periodic_adv_params_t) esp_err_t;
pub extern fn esp_ble_gap_config_periodic_adv_data_raw(instance: u8, length: u16, data: [*:0]const u8) esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_start(instance: u8) esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_stop(instance: u8) esp_err_t;
pub extern fn esp_ble_gap_set_ext_scan_params(params: [*c]const esp_ble_ext_scan_params_t) esp_err_t;
pub extern fn esp_ble_gap_start_ext_scan(duration: u32, period: u16) esp_err_t;
pub extern fn esp_ble_gap_stop_ext_scan() esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_create_sync(params: [*c]const esp_ble_gap_periodic_adv_sync_params_t) esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_sync_cancel() esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_sync_terminate(sync_handle: u16) esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_add_dev_to_list(addr_type: esp_ble_addr_type_t, addr: [*:0]u8, sid: u8) esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_remove_dev_from_list(addr_type: esp_ble_addr_type_t, addr: [*:0]u8, sid: u8) esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_clear_dev() esp_err_t;
pub extern fn esp_ble_gap_prefer_ext_connect_params_set(addr: [*:0]u8, phy_mask: esp_ble_gap_phy_mask_t, phy_1m_conn_params: [*c]const esp_ble_gap_conn_params_t, phy_2m_conn_params: [*c]const esp_ble_gap_conn_params_t, phy_coded_conn_params: [*c]const esp_ble_gap_conn_params_t) esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_recv_enable(sync_handle: u16, enable: u8) esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_sync_trans(addr: [*:0]u8, service_data: u16, sync_handle: u16) esp_err_t;
pub extern fn esp_ble_gap_periodic_adv_set_info_trans(addr: [*:0]u8, service_data: u16, adv_handle: u8) esp_err_t;
pub extern fn esp_ble_gap_set_periodic_adv_sync_trans_params(addr: [*:0]u8, params: [*c]const esp_ble_gap_past_params_t) esp_err_t;
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
pub extern fn esp_random() u32;
pub extern fn esp_fill_random(buf: ?*anyopaque, len: usize) void;

pub const heap_trace_mode_t = enum(c_uint) {
    HEAP_TRACE_ALL = 0,
    HEAP_TRACE_LEAKS = 1,
};
pub const heap_trace_record_t = extern struct {
    ccount: u32 align(4) = std.mem.zeroes(u32),
    address: ?*anyopaque = null,
    size: usize = std.mem.zeroes(usize),
    alloced_by: [0]?*anyopaque = std.mem.zeroes([0]?*anyopaque),
    pub fn freed_by(self: anytype) std.zig.c_translation.FlexibleArrayType(@TypeOf(self), ?*anyopaque) {
        const Intermediate = std.zig.c_translation.FlexibleArrayType(@TypeOf(self), u8);
        const ReturnType = std.zig.c_translation.FlexibleArrayType(@TypeOf(self), ?*anyopaque);
        return @as(ReturnType, @ptrCast(@alignCast(@as(Intermediate, @ptrCast(self)) + 12)));
    }
};
pub const heap_trace_summary_t = extern struct {
    mode: heap_trace_mode_t = std.mem.zeroes(heap_trace_mode_t),
    total_allocations: usize = std.mem.zeroes(usize),
    total_frees: usize = std.mem.zeroes(usize),
    count: usize = std.mem.zeroes(usize),
    capacity: usize = std.mem.zeroes(usize),
    high_water_mark: usize = std.mem.zeroes(usize),
    has_overflowed: usize = std.mem.zeroes(usize),
};
pub extern fn heap_trace_init_standalone(record_buffer: [*c]heap_trace_record_t, num_records: usize) esp_err_t;
pub extern fn heap_trace_init_tohost() esp_err_t;
pub extern fn heap_trace_start(mode: heap_trace_mode_t) esp_err_t;
pub extern fn heap_trace_stop() esp_err_t;
pub extern fn heap_trace_resume() esp_err_t;
pub extern fn heap_trace_get_count() usize;
pub extern fn heap_trace_get(index: usize, record: [*c]heap_trace_record_t) esp_err_t;
pub extern fn heap_trace_dump() void;
pub extern fn heap_trace_dump_caps(caps: u32) void;
pub extern fn heap_trace_summary(summary: [*c]heap_trace_summary_t) esp_err_t;
pub const SEGGER_RTT_BUFFER_UP = extern struct {
    sName: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    pBuffer: [*:0]u8 = std.mem.zeroes([*:0]u8),
    SizeOfBuffer: c_uint = std.mem.zeroes(c_uint),
    WrOff: c_uint = std.mem.zeroes(c_uint),
    RdOff: c_uint = std.mem.zeroes(c_uint),
    Flags: c_uint = std.mem.zeroes(c_uint),
};
pub const SEGGER_RTT_BUFFER_DOWN = extern struct {
    sName: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    pBuffer: [*:0]u8 = std.mem.zeroes([*:0]u8),
    SizeOfBuffer: c_uint = std.mem.zeroes(c_uint),
    WrOff: c_uint = std.mem.zeroes(c_uint),
    RdOff: c_uint = std.mem.zeroes(c_uint),
    Flags: c_uint = std.mem.zeroes(c_uint),
};
pub const SEGGER_RTT_CB = extern struct {
    acID: [16]u8 = std.mem.zeroes([16]u8),
    MaxNumUpBuffers: c_int = std.mem.zeroes(c_int),
    MaxNumDownBuffers: c_int = std.mem.zeroes(c_int),
    aUp: [3]SEGGER_RTT_BUFFER_UP = std.mem.zeroes([3]SEGGER_RTT_BUFFER_UP),
    aDown: [3]SEGGER_RTT_BUFFER_DOWN = std.mem.zeroes([3]SEGGER_RTT_BUFFER_DOWN),
};
pub extern var _SEGGER_RTT: SEGGER_RTT_CB;
pub extern fn SEGGER_RTT_AllocDownBuffer(sName: [*:0]const u8, pBuffer: ?*anyopaque, BufferSize: c_uint, Flags: c_uint) c_int;
pub extern fn SEGGER_RTT_AllocUpBuffer(sName: [*:0]const u8, pBuffer: ?*anyopaque, BufferSize: c_uint, Flags: c_uint) c_int;
pub extern fn SEGGER_RTT_ConfigUpBuffer(BufferIndex: c_uint, sName: [*:0]const u8, pBuffer: ?*anyopaque, BufferSize: c_uint, Flags: c_uint) c_int;
pub extern fn SEGGER_RTT_ConfigDownBuffer(BufferIndex: c_uint, sName: [*:0]const u8, pBuffer: ?*anyopaque, BufferSize: c_uint, Flags: c_uint) c_int;
pub extern fn SEGGER_RTT_GetKey() c_int;
pub extern fn SEGGER_RTT_HasData(BufferIndex: c_uint) c_uint;
pub extern fn SEGGER_RTT_HasKey() c_int;
pub extern fn SEGGER_RTT_HasDataUp(BufferIndex: c_uint) c_uint;
pub extern fn SEGGER_RTT_Init() void;
pub extern fn SEGGER_RTT_Read(BufferIndex: c_uint, pBuffer: ?*anyopaque, BufferSize: c_uint) c_uint;
pub extern fn SEGGER_RTT_ReadNoLock(BufferIndex: c_uint, pData: ?*anyopaque, BufferSize: c_uint) c_uint;
pub extern fn SEGGER_RTT_SetNameDownBuffer(BufferIndex: c_uint, sName: [*:0]const u8) c_int;
pub extern fn SEGGER_RTT_SetNameUpBuffer(BufferIndex: c_uint, sName: [*:0]const u8) c_int;
pub extern fn SEGGER_RTT_SetFlagsDownBuffer(BufferIndex: c_uint, Flags: c_uint) c_int;
pub extern fn SEGGER_RTT_SetFlagsUpBuffer(BufferIndex: c_uint, Flags: c_uint) c_int;
pub extern fn SEGGER_RTT_WaitKey() c_int;
pub extern fn SEGGER_RTT_Write(BufferIndex: c_uint, pBuffer: ?*const anyopaque, NumBytes: c_uint) c_uint;
pub extern fn SEGGER_RTT_WriteNoLock(BufferIndex: c_uint, pBuffer: ?*const anyopaque, NumBytes: c_uint) c_uint;
pub extern fn SEGGER_RTT_WriteSkipNoLock(BufferIndex: c_uint, pBuffer: ?*const anyopaque, NumBytes: c_uint) c_uint;
pub extern fn SEGGER_RTT_ASM_WriteSkipNoLock(BufferIndex: c_uint, pBuffer: ?*const anyopaque, NumBytes: c_uint) c_uint;
pub extern fn SEGGER_RTT_WriteString(BufferIndex: c_uint, s: [*:0]const u8) c_uint;
pub extern fn SEGGER_RTT_WriteWithOverwriteNoLock(BufferIndex: c_uint, pBuffer: ?*const anyopaque, NumBytes: c_uint) void;
pub extern fn SEGGER_RTT_PutChar(BufferIndex: c_uint, c: u8) c_uint;
pub extern fn SEGGER_RTT_PutCharSkip(BufferIndex: c_uint, c: u8) c_uint;
pub extern fn SEGGER_RTT_PutCharSkipNoLock(BufferIndex: c_uint, c: u8) c_uint;
pub extern fn SEGGER_RTT_GetAvailWriteSpace(BufferIndex: c_uint) c_uint;
pub extern fn SEGGER_RTT_GetBytesInBuffer(BufferIndex: c_uint) c_uint;
pub extern fn SEGGER_RTT_ESP_FlushNoLock(min_sz: c_ulong, tmo: c_ulong) void;
pub extern fn SEGGER_RTT_ESP_Flush(min_sz: c_ulong, tmo: c_ulong) void;
pub extern fn SEGGER_RTT_ReadUpBuffer(BufferIndex: c_uint, pBuffer: ?*anyopaque, BufferSize: c_uint) c_uint;
pub extern fn SEGGER_RTT_ReadUpBufferNoLock(BufferIndex: c_uint, pData: ?*anyopaque, BufferSize: c_uint) c_uint;
pub extern fn SEGGER_RTT_WriteDownBuffer(BufferIndex: c_uint, pBuffer: ?*const anyopaque, NumBytes: c_uint) c_uint;
pub extern fn SEGGER_RTT_WriteDownBufferNoLock(BufferIndex: c_uint, pBuffer: ?*const anyopaque, NumBytes: c_uint) c_uint;
pub extern fn SEGGER_RTT_SetTerminal(TerminalId: u8) c_int;
pub extern fn SEGGER_RTT_TerminalOut(TerminalId: u8, s: [*:0]const u8) c_int;
pub extern fn SEGGER_RTT_printf(BufferIndex: c_uint, sFormat: [*:0]const u8, ...) c_int;
pub extern fn SEGGER_RTT_vprintf(BufferIndex: c_uint, sFormat: [*:0]const u8, pParamList: [*c]va_list) c_int;
pub const intr_type = enum(c_uint) {
    INTR_TYPE_LEVEL = 0,
    INTR_TYPE_EDGE = 1,
};
pub const esp_timer = opaque {};
pub const esp_timer_handle_t = ?*esp_timer;
pub const esp_timer_cb_t = ?*const fn (?*anyopaque) callconv(.C) void;
pub const esp_timer_dispatch_t = enum(c_uint) {
    ESP_TIMER_TASK = 0,
    ESP_TIMER_MAX = 1,
};
pub const esp_timer_create_args_t = extern struct {
    callback: esp_timer_cb_t = std.mem.zeroes(esp_timer_cb_t),
    arg: ?*anyopaque = null,
    dispatch_method: esp_timer_dispatch_t = std.mem.zeroes(esp_timer_dispatch_t),
    name: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    skip_unhandled_events: bool = std.mem.zeroes(bool),
};
pub extern fn esp_timer_early_init() esp_err_t;
pub extern fn esp_timer_init() esp_err_t;
pub extern fn esp_timer_deinit() esp_err_t;
pub extern fn esp_timer_create(create_args: [*c]const esp_timer_create_args_t, out_handle: [*c]esp_timer_handle_t) esp_err_t;
pub extern fn esp_timer_start_once(timer: esp_timer_handle_t, timeout_us: u64) esp_err_t;
pub extern fn esp_timer_start_periodic(timer: esp_timer_handle_t, period: u64) esp_err_t;
pub extern fn esp_timer_restart(timer: esp_timer_handle_t, timeout_us: u64) esp_err_t;
pub extern fn esp_timer_stop(timer: esp_timer_handle_t) esp_err_t;
pub extern fn esp_timer_delete(timer: esp_timer_handle_t) esp_err_t;
pub extern fn esp_timer_get_time() i64;
pub extern fn esp_timer_get_next_alarm() i64;
pub extern fn esp_timer_get_next_alarm_for_wake_up() i64;
pub extern fn esp_timer_get_period(timer: esp_timer_handle_t, period: [*c]u64) esp_err_t;
pub extern fn esp_timer_get_expiry_time(timer: esp_timer_handle_t, expiry: [*c]u64) esp_err_t;
pub extern fn esp_timer_dump(stream: ?*std.c.FILE) esp_err_t;
pub extern fn esp_timer_is_active(timer: esp_timer_handle_t) bool;
pub extern fn esp_timer_new_etm_alarm_event(out_event: [*c]esp_etm_event_handle_t) esp_err_t;
pub const esp_apptrace_tmo_t = extern struct {
    start: i64 = std.mem.zeroes(i64),
    tmo: i64 = std.mem.zeroes(i64),
    elapsed: i64 = std.mem.zeroes(i64),
};
pub fn esp_apptrace_tmo_init(tmo: [*c]esp_apptrace_tmo_t, user_tmo: u32) callconv(.C) void {
    tmo.*.start = esp_timer_get_time();
    tmo.*.tmo = if (user_tmo == @as(u32, @bitCast(-@as(c_int, 1)))) @as(i64, @bitCast(@as(c_longlong, -@as(c_int, 1)))) else @as(i64, @bitCast(@as(c_ulonglong, user_tmo)));
    tmo.*.elapsed = 0;
}
pub extern fn esp_apptrace_tmo_check(tmo: [*c]esp_apptrace_tmo_t) esp_err_t;
pub fn esp_apptrace_tmo_remaining_us(tmo: [*c]esp_apptrace_tmo_t) callconv(.C) u32 {
    return @as(u32, @bitCast(@as(c_int, @truncate(if (tmo.*.tmo != @as(i64, @bitCast(@as(c_longlong, -@as(c_int, 1))))) tmo.*.elapsed - tmo.*.tmo else @as(i64, @bitCast(@as(c_ulonglong, @as(u32, @bitCast(-@as(c_int, 1))))))))));
}
pub const esp_apptrace_lock_t = extern struct {
    mux: spinlock_t = std.mem.zeroes(spinlock_t),
    int_state: c_uint = std.mem.zeroes(c_uint),
};
pub fn esp_apptrace_lock_init(lock: [*c]esp_apptrace_lock_t) callconv(.C) void {
    spinlock_initialize(&lock.*.mux);
    lock.*.int_state = 0;
}
pub extern fn esp_apptrace_lock_take(lock: [*c]esp_apptrace_lock_t, tmo: [*c]esp_apptrace_tmo_t) esp_err_t;
pub extern fn esp_apptrace_lock_give(lock: [*c]esp_apptrace_lock_t) esp_err_t;
pub const esp_apptrace_rb_t = extern struct {
    data: [*:0]u8 = std.mem.zeroes([*:0]u8),
    size: u32 = std.mem.zeroes(u32),
    cur_size: u32 = std.mem.zeroes(u32),
    rd: u32 = std.mem.zeroes(u32),
    wr: u32 = std.mem.zeroes(u32),
};
pub fn esp_apptrace_rb_init(rb: [*c]esp_apptrace_rb_t, data: [*:0]u8, size: u32) callconv(.C) void {
    rb.*.data = data;
    rb.*.size = blk: {
        const tmp = size;
        rb.*.cur_size = tmp;
        break :blk tmp;
    };
    rb.*.rd = 0;
    rb.*.wr = 0;
}
pub extern fn esp_apptrace_rb_produce(rb: [*c]esp_apptrace_rb_t, size: u32) [*:0]u8;
pub extern fn esp_apptrace_rb_consume(rb: [*c]esp_apptrace_rb_t, size: u32) [*:0]u8;
pub extern fn esp_apptrace_rb_read_size_get(rb: [*c]esp_apptrace_rb_t) u32;
pub extern fn esp_apptrace_rb_write_size_get(rb: [*c]esp_apptrace_rb_t) u32;
pub extern fn esp_apptrace_log_lock() c_int;
pub extern fn esp_apptrace_log_unlock() void;
pub fn esp_sysview_flush(tmo: u32) callconv(.C) esp_err_t {
    SEGGER_RTT_ESP_Flush(@as(c_ulong, @bitCast(@as(c_long, @as(c_int, 0)))), @as(c_ulong, @bitCast(@as(c_ulong, tmo))));
    return 0;
}
pub extern fn esp_sysview_vprintf(format: [*:0]const u8, args: va_list) c_int;
pub extern fn esp_sysview_heap_trace_start(tmo: u32) esp_err_t;
pub extern fn esp_sysview_heap_trace_stop() esp_err_t;
pub extern fn esp_sysview_heap_trace_alloc(addr: ?*anyopaque, size: u32, callers: ?*const anyopaque) void;
pub extern fn esp_sysview_heap_trace_free(addr: ?*anyopaque, callers: ?*const anyopaque) void;

pub const esp_crypto_hash_alg_t = enum(c_uint) {
    ESP_CRYPTO_HASH_ALG_MD5 = 0,
    ESP_CRYPTO_HASH_ALG_SHA1 = 1,
    ESP_CRYPTO_HASH_ALG_HMAC_MD5 = 2,
    ESP_CRYPTO_HASH_ALG_HMAC_SHA1 = 3,
    ESP_CRYPTO_HASH_ALG_SHA256 = 4,
    ESP_CRYPTO_HASH_ALG_HMAC_SHA256 = 5,
};
pub const esp_crypto_cipher_alg_t = enum(c_uint) {
    ESP_CRYPTO_CIPHER_NULL = 0,
    ESP_CRYPTO_CIPHER_ALG_AES = 1,
    ESP_CRYPTO_CIPHER_ALG_3DES = 2,
    ESP_CRYPTO_CIPHER_ALG_DES = 3,
    ESP_CRYPTO_CIPHER_ALG_RC2 = 4,
    ESP_CRYPTO_CIPHER_ALG_RC4 = 5,
};
pub const crypto_hash = opaque {};
pub const esp_crypto_hash_t = crypto_hash;
pub const crypto_cipher = opaque {};
pub const esp_crypto_cipher_t = crypto_cipher;
pub const esp_aes_128_encrypt_t = ?*const fn ([*:0]const u8, [*:0]const u8, [*:0]u8, c_int) callconv(.C) c_int;
pub const esp_aes_128_decrypt_t = ?*const fn ([*:0]const u8, [*:0]const u8, [*:0]u8, c_int) callconv(.C) c_int;
pub const esp_aes_wrap_t = ?*const fn ([*:0]const u8, c_int, [*:0]const u8, [*:0]u8) callconv(.C) c_int;
pub const esp_aes_unwrap_t = ?*const fn ([*:0]const u8, c_int, [*:0]const u8, [*:0]u8) callconv(.C) c_int;
pub const esp_hmac_sha256_vector_t = ?*const fn ([*:0]const u8, c_int, c_int, [*c][*c]const u8, [*c]const c_int, [*:0]u8) callconv(.C) c_int;
pub const esp_sha256_prf_t = ?*const fn ([*:0]const u8, c_int, [*:0]const u8, [*:0]const u8, c_int, [*:0]u8, c_int) callconv(.C) c_int;
pub const esp_hmac_md5_t = ?*const fn ([*:0]const u8, c_uint, [*:0]const u8, c_uint, [*:0]u8) callconv(.C) c_int;
pub const esp_hmac_md5_vector_t = ?*const fn ([*:0]const u8, c_uint, c_uint, [*c][*c]const u8, [*c]const c_uint, [*:0]u8) callconv(.C) c_int;
pub const esp_hmac_sha1_t = ?*const fn ([*:0]const u8, c_uint, [*:0]const u8, c_uint, [*:0]u8) callconv(.C) c_int;
pub const esp_hmac_sha1_vector_t = ?*const fn ([*:0]const u8, c_uint, c_uint, [*c][*c]const u8, [*c]const c_uint, [*:0]u8) callconv(.C) c_int;
pub const esp_sha1_prf_t = ?*const fn ([*:0]const u8, c_uint, [*:0]const u8, [*:0]const u8, c_uint, [*:0]u8, c_uint) callconv(.C) c_int;
pub const esp_sha1_vector_t = ?*const fn (c_uint, [*c][*c]const u8, [*c]const c_uint, [*:0]u8) callconv(.C) c_int;
pub const esp_pbkdf2_sha1_t = ?*const fn ([*:0]const u8, [*:0]const u8, c_uint, c_int, [*:0]u8, c_uint) callconv(.C) c_int;
pub const esp_rc4_skip_t = ?*const fn ([*:0]const u8, c_uint, c_uint, [*:0]u8, c_uint) callconv(.C) c_int;
pub const esp_md5_vector_t = ?*const fn (c_uint, [*c][*c]const u8, [*c]const c_uint, [*:0]u8) callconv(.C) c_int;
pub const esp_aes_encrypt_t = ?*const fn (?*anyopaque, [*:0]const u8, [*:0]u8) callconv(.C) void;
pub const esp_aes_encrypt_init_t = ?*const fn ([*:0]const u8, c_uint) callconv(.C) ?*anyopaque;
pub const esp_aes_encrypt_deinit_t = ?*const fn (?*anyopaque) callconv(.C) void;
pub const esp_aes_decrypt_t = ?*const fn (?*anyopaque, [*:0]const u8, [*:0]u8) callconv(.C) void;
pub const esp_aes_decrypt_init_t = ?*const fn ([*:0]const u8, c_uint) callconv(.C) ?*anyopaque;
pub const esp_aes_decrypt_deinit_t = ?*const fn (?*anyopaque) callconv(.C) void;
pub const esp_omac1_aes_128_t = ?*const fn ([*:0]const u8, [*:0]const u8, usize, [*:0]u8) callconv(.C) c_int;
pub const esp_ccmp_decrypt_t = ?*const fn ([*:0]const u8, [*:0]const u8, [*:0]const u8, usize, [*c]usize, bool) callconv(.C) [*:0]u8;
pub const esp_ccmp_encrypt_t = ?*const fn ([*:0]const u8, [*:0]u8, usize, usize, [*:0]u8, c_int, [*c]usize) callconv(.C) [*:0]u8;
pub const esp_aes_gmac_t = ?*const fn ([*:0]const u8, usize, [*:0]const u8, usize, [*:0]const u8, usize, [*:0]u8) callconv(.C) c_int;
pub const esp_sha256_vector_t = ?*const fn (usize, [*c][*c]const u8, [*c]const usize, [*:0]u8) callconv(.C) c_int;
pub const esp_crc32_le_t = ?*const fn (u32, [*:0]const u8, u32) callconv(.C) u32;
pub const wpa_crypto_funcs_t = extern struct {
    size: u32 = std.mem.zeroes(u32),
    version: u32 = std.mem.zeroes(u32),
    aes_wrap: esp_aes_wrap_t = std.mem.zeroes(esp_aes_wrap_t),
    aes_unwrap: esp_aes_unwrap_t = std.mem.zeroes(esp_aes_unwrap_t),
    hmac_sha256_vector: esp_hmac_sha256_vector_t = std.mem.zeroes(esp_hmac_sha256_vector_t),
    sha256_prf: esp_sha256_prf_t = std.mem.zeroes(esp_sha256_prf_t),
    hmac_md5: esp_hmac_md5_t = std.mem.zeroes(esp_hmac_md5_t),
    hamc_md5_vector: esp_hmac_md5_vector_t = std.mem.zeroes(esp_hmac_md5_vector_t),
    hmac_sha1: esp_hmac_sha1_t = std.mem.zeroes(esp_hmac_sha1_t),
    hmac_sha1_vector: esp_hmac_sha1_vector_t = std.mem.zeroes(esp_hmac_sha1_vector_t),
    sha1_prf: esp_sha1_prf_t = std.mem.zeroes(esp_sha1_prf_t),
    sha1_vector: esp_sha1_vector_t = std.mem.zeroes(esp_sha1_vector_t),
    pbkdf2_sha1: esp_pbkdf2_sha1_t = std.mem.zeroes(esp_pbkdf2_sha1_t),
    rc4_skip: esp_rc4_skip_t = std.mem.zeroes(esp_rc4_skip_t),
    md5_vector: esp_md5_vector_t = std.mem.zeroes(esp_md5_vector_t),
    aes_encrypt: esp_aes_encrypt_t = std.mem.zeroes(esp_aes_encrypt_t),
    aes_encrypt_init: esp_aes_encrypt_init_t = std.mem.zeroes(esp_aes_encrypt_init_t),
    aes_encrypt_deinit: esp_aes_encrypt_deinit_t = std.mem.zeroes(esp_aes_encrypt_deinit_t),
    aes_decrypt: esp_aes_decrypt_t = std.mem.zeroes(esp_aes_decrypt_t),
    aes_decrypt_init: esp_aes_decrypt_init_t = std.mem.zeroes(esp_aes_decrypt_init_t),
    aes_decrypt_deinit: esp_aes_decrypt_deinit_t = std.mem.zeroes(esp_aes_decrypt_deinit_t),
    aes_128_encrypt: esp_aes_128_encrypt_t = std.mem.zeroes(esp_aes_128_encrypt_t),
    aes_128_decrypt: esp_aes_128_decrypt_t = std.mem.zeroes(esp_aes_128_decrypt_t),
    omac1_aes_128: esp_omac1_aes_128_t = std.mem.zeroes(esp_omac1_aes_128_t),
    ccmp_decrypt: esp_ccmp_decrypt_t = std.mem.zeroes(esp_ccmp_decrypt_t),
    ccmp_encrypt: esp_ccmp_encrypt_t = std.mem.zeroes(esp_ccmp_encrypt_t),
    aes_gmac: esp_aes_gmac_t = std.mem.zeroes(esp_aes_gmac_t),
    sha256_vector: esp_sha256_vector_t = std.mem.zeroes(esp_sha256_vector_t),
    crc32: esp_crc32_le_t = std.mem.zeroes(esp_crc32_le_t),
};
pub const mesh_crypto_funcs_t = extern struct {
    aes_128_encrypt: esp_aes_128_encrypt_t = std.mem.zeroes(esp_aes_128_encrypt_t),
    aes_128_decrypt: esp_aes_128_decrypt_t = std.mem.zeroes(esp_aes_128_decrypt_t),
};
pub const esp_ip6_addr = extern struct {
    addr: [4]u32 = std.mem.zeroes([4]u32),
    zone: u8 = std.mem.zeroes(u8),
};
pub const esp_ip4_addr = extern struct {
    addr: u32 = std.mem.zeroes(u32),
};
pub const esp_ip4_addr_t = esp_ip4_addr;
pub const esp_ip6_addr_t = esp_ip6_addr;
const union_unnamed_5 = extern union {
    ip6: esp_ip6_addr_t,
    ip4: esp_ip4_addr_t,
};
pub const _ip_addr = extern struct {
    u_addr: union_unnamed_5 = std.mem.zeroes(union_unnamed_5),
    type: u8 = std.mem.zeroes(u8),
};
pub const esp_ip_addr_t = _ip_addr;
pub const esp_ip6_addr_type_t = enum(c_uint) {
    ESP_IP6_ADDR_IS_UNKNOWN = 0,
    ESP_IP6_ADDR_IS_GLOBAL = 1,
    ESP_IP6_ADDR_IS_LINK_LOCAL = 2,
    ESP_IP6_ADDR_IS_SITE_LOCAL = 3,
    ESP_IP6_ADDR_IS_UNIQUE_LOCAL = 4,
    ESP_IP6_ADDR_IS_IPV4_MAPPED_IPV6 = 5,
};
pub extern fn esp_netif_ip6_get_addr_type(ip6_addr: [*c]esp_ip6_addr_t) esp_ip6_addr_type_t;
pub fn esp_netif_ip_addr_copy(dest: [*c]esp_ip_addr_t, src: [*c]const esp_ip_addr_t) callconv(.C) void {
    dest.*.type = src.*.type;
    if (@as(c_uint, @bitCast(@as(c_uint, src.*.type))) == @as(c_uint, 6)) {
        dest.*.u_addr.ip6.addr[@as(c_uint, @intCast(@as(c_int, 0)))] = src.*.u_addr.ip6.addr[@as(c_uint, @intCast(@as(c_int, 0)))];
        dest.*.u_addr.ip6.addr[@as(c_uint, @intCast(@as(c_int, 1)))] = src.*.u_addr.ip6.addr[@as(c_uint, @intCast(@as(c_int, 1)))];
        dest.*.u_addr.ip6.addr[@as(c_uint, @intCast(@as(c_int, 2)))] = src.*.u_addr.ip6.addr[@as(c_uint, @intCast(@as(c_int, 2)))];
        dest.*.u_addr.ip6.addr[@as(c_uint, @intCast(@as(c_int, 3)))] = src.*.u_addr.ip6.addr[@as(c_uint, @intCast(@as(c_int, 3)))];
        dest.*.u_addr.ip6.zone = src.*.u_addr.ip6.zone;
    } else {
        dest.*.u_addr.ip4.addr = src.*.u_addr.ip4.addr;
        dest.*.u_addr.ip6.addr[@as(c_uint, @intCast(@as(c_int, 1)))] = 0;
        dest.*.u_addr.ip6.addr[@as(c_uint, @intCast(@as(c_int, 2)))] = 0;
        dest.*.u_addr.ip6.addr[@as(c_uint, @intCast(@as(c_int, 3)))] = 0;
        dest.*.u_addr.ip6.zone = 0;
    }
}
pub const esp_netif_obj = opaque {};
pub const esp_netif_t = esp_netif_obj;
pub const esp_netif_dns_type_t = enum(c_uint) {
    ESP_NETIF_DNS_MAIN = 0,
    ESP_NETIF_DNS_BACKUP = 1,
    ESP_NETIF_DNS_FALLBACK = 2,
    ESP_NETIF_DNS_MAX = 3,
};
pub const esp_netif_dns_info_t = extern struct {
    ip: esp_ip_addr_t = std.mem.zeroes(esp_ip_addr_t),
};
pub const esp_netif_dhcp_status_t = enum(c_uint) {
    ESP_NETIF_DHCP_INIT = 0,
    ESP_NETIF_DHCP_STARTED = 1,
    ESP_NETIF_DHCP_STOPPED = 2,
    ESP_NETIF_DHCP_STATUS_MAX = 3,
};
pub const esp_netif_dhcp_option_mode_t = enum(c_uint) {
    ESP_NETIF_OP_START = 0,
    ESP_NETIF_OP_SET = 1,
    ESP_NETIF_OP_GET = 2,
    ESP_NETIF_OP_MAX = 3,
};
pub const esp_netif_dhcp_option_id_t = enum(c_uint) {
    ESP_NETIF_SUBNET_MASK = 1,
    ESP_NETIF_DOMAIN_NAME_SERVER = 6,
    ESP_NETIF_ROUTER_SOLICITATION_ADDRESS = 32,
    ESP_NETIF_REQUESTED_IP_ADDRESS = 50,
    ESP_NETIF_IP_ADDRESS_LEASE_TIME = 51,
    ESP_NETIF_IP_REQUEST_RETRY_TIME = 52,
    ESP_NETIF_VENDOR_CLASS_IDENTIFIER = 60,
    ESP_NETIF_VENDOR_SPECIFIC_INFO = 43,
};
pub const ip_event_t = enum(c_uint) {
    IP_EVENT_STA_GOT_IP = 0,
    IP_EVENT_STA_LOST_IP = 1,
    IP_EVENT_AP_STAIPASSIGNED = 2,
    IP_EVENT_GOT_IP6 = 3,
    IP_EVENT_ETH_GOT_IP = 4,
    IP_EVENT_ETH_LOST_IP = 5,
    IP_EVENT_PPP_GOT_IP = 6,
    IP_EVENT_PPP_LOST_IP = 7,
};
pub extern const IP_EVENT: esp_event_base_t;
pub const esp_netif_ip_info_t = extern struct {
    ip: esp_ip4_addr_t = std.mem.zeroes(esp_ip4_addr_t),
    netmask: esp_ip4_addr_t = std.mem.zeroes(esp_ip4_addr_t),
    gw: esp_ip4_addr_t = std.mem.zeroes(esp_ip4_addr_t),
};
pub const esp_netif_ip6_info_t = extern struct {
    ip: esp_ip6_addr_t = std.mem.zeroes(esp_ip6_addr_t),
};
pub const ip_event_got_ip_t = extern struct {
    esp_netif: ?*esp_netif_t = std.mem.zeroes(?*esp_netif_t),
    ip_info: esp_netif_ip_info_t = std.mem.zeroes(esp_netif_ip_info_t),
    ip_changed: bool = std.mem.zeroes(bool),
};
pub const ip_event_got_ip6_t = extern struct {
    esp_netif: ?*esp_netif_t = std.mem.zeroes(?*esp_netif_t),
    ip6_info: esp_netif_ip6_info_t = std.mem.zeroes(esp_netif_ip6_info_t),
    ip_index: c_int = std.mem.zeroes(c_int),
};
pub const ip_event_add_ip6_t = extern struct {
    addr: esp_ip6_addr_t = std.mem.zeroes(esp_ip6_addr_t),
    preferred: bool = std.mem.zeroes(bool),
};
pub const ip_event_ap_staipassigned_t = extern struct {
    esp_netif: ?*esp_netif_t = std.mem.zeroes(?*esp_netif_t),
    ip: esp_ip4_addr_t = std.mem.zeroes(esp_ip4_addr_t),
    mac: [6]u8 = std.mem.zeroes([6]u8),
};
pub const esp_netif_flags = enum(c_uint) {
    ESP_NETIF_DHCP_CLIENT = 1,
    ESP_NETIF_DHCP_SERVER = 2,
    ESP_NETIF_FLAG_AUTOUP = 4,
    ESP_NETIF_FLAG_GARP = 8,
    ESP_NETIF_FLAG_EVENT_IP_MODIFIED = 16,
    ESP_NETIF_FLAG_IS_PPP = 32,
    ESP_NETIF_FLAG_IS_BRIDGE = 64,
    ESP_NETIF_FLAG_MLDV6_REPORT = 128,
};
pub const esp_netif_flags_t = esp_netif_flags;
pub const esp_netif_ip_event_type = enum(c_uint) {
    ESP_NETIF_IP_EVENT_GOT_IP = 1,
    ESP_NETIF_IP_EVENT_LOST_IP = 2,
};
pub const esp_netif_ip_event_type_t = esp_netif_ip_event_type;
pub const bridgeif_config = extern struct {
    max_fdb_dyn_entries: u16 = std.mem.zeroes(u16),
    max_fdb_sta_entries: u16 = std.mem.zeroes(u16),
    max_ports: u8 = std.mem.zeroes(u8),
};
pub const bridgeif_config_t = bridgeif_config;
pub const esp_netif_inherent_config = extern struct {
    flags: esp_netif_flags_t = std.mem.zeroes(esp_netif_flags_t),
    mac: [6]u8 = std.mem.zeroes([6]u8),
    ip_info: [*c]const esp_netif_ip_info_t = std.mem.zeroes([*c]const esp_netif_ip_info_t),
    get_ip_event: u32 = std.mem.zeroes(u32),
    lost_ip_event: u32 = std.mem.zeroes(u32),
    if_key: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    if_desc: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    route_prio: c_int = std.mem.zeroes(c_int),
    bridge_info: [*c]bridgeif_config_t = std.mem.zeroes([*c]bridgeif_config_t),
};
pub const esp_netif_inherent_config_t = esp_netif_inherent_config;
pub const esp_netif_iodriver_handle = ?*anyopaque;
pub const esp_netif_driver_ifconfig = extern struct {
    handle: esp_netif_iodriver_handle = std.mem.zeroes(esp_netif_iodriver_handle),
    transmit: ?*const fn (?*anyopaque, ?*anyopaque, usize) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn (?*anyopaque, ?*anyopaque, usize) callconv(.C) esp_err_t),
    transmit_wrap: ?*const fn (?*anyopaque, ?*anyopaque, usize, ?*anyopaque) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn (?*anyopaque, ?*anyopaque, usize, ?*anyopaque) callconv(.C) esp_err_t),
    driver_free_rx_buffer: ?*const fn (?*anyopaque, ?*anyopaque) callconv(.C) void = std.mem.zeroes(?*const fn (?*anyopaque, ?*anyopaque) callconv(.C) void),
};
pub const esp_netif_driver_ifconfig_t = esp_netif_driver_ifconfig;
pub const esp_netif_netstack_config = opaque {};
pub const esp_netif_netstack_config_t = esp_netif_netstack_config;
pub const esp_netif_config = extern struct {
    base: [*c]const esp_netif_inherent_config_t = std.mem.zeroes([*c]const esp_netif_inherent_config_t),
    driver: [*c]const esp_netif_driver_ifconfig_t = std.mem.zeroes([*c]const esp_netif_driver_ifconfig_t),
    stack: ?*const esp_netif_netstack_config_t = std.mem.zeroes(?*const esp_netif_netstack_config_t),
};
pub const esp_netif_config_t = esp_netif_config;
pub const esp_netif_driver_base_s = extern struct {
    post_attach: ?*const fn (?*esp_netif_t, esp_netif_iodriver_handle) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn (?*esp_netif_t, esp_netif_iodriver_handle) callconv(.C) esp_err_t),
    netif: ?*esp_netif_t = std.mem.zeroes(?*esp_netif_t),
};
pub const esp_netif_driver_base_t = esp_netif_driver_base_s;
pub const esp_netif_pair_mac_ip_t = extern struct {
    mac: [6]u8 = std.mem.zeroes([6]u8),
    ip: esp_ip4_addr_t = std.mem.zeroes(esp_ip4_addr_t),
};
pub const esp_netif_receive_t = ?*const fn (?*esp_netif_t, ?*anyopaque, usize, ?*anyopaque) callconv(.C) esp_err_t;
pub extern var _g_esp_netif_netstack_default_eth: ?*const esp_netif_netstack_config_t;
pub extern var _g_esp_netif_netstack_default_br: ?*const esp_netif_netstack_config_t;
pub extern var _g_esp_netif_netstack_default_wifi_sta: ?*const esp_netif_netstack_config_t;
pub extern var _g_esp_netif_netstack_default_wifi_ap: ?*const esp_netif_netstack_config_t;
pub extern const _g_esp_netif_inherent_sta_config: esp_netif_inherent_config_t;
pub extern const _g_esp_netif_inherent_ap_config: esp_netif_inherent_config_t;
pub extern const _g_esp_netif_inherent_eth_config: esp_netif_inherent_config_t;
pub extern const _g_esp_netif_soft_ap_ip: esp_netif_ip_info_t;
pub extern fn esp_netif_init() esp_err_t;
pub extern fn esp_netif_deinit() esp_err_t;
pub extern fn esp_netif_new(esp_netif_config: [*c]const esp_netif_config_t) ?*esp_netif_t;
pub extern fn esp_netif_destroy(esp_netif: ?*esp_netif_t) void;
pub extern fn esp_netif_set_driver_config(esp_netif: ?*esp_netif_t, driver_config: [*c]const esp_netif_driver_ifconfig_t) esp_err_t;
pub extern fn esp_netif_attach(esp_netif: ?*esp_netif_t, driver_handle: esp_netif_iodriver_handle) esp_err_t;
pub extern fn esp_netif_receive(esp_netif: ?*esp_netif_t, buffer: ?*anyopaque, len: usize, eb: ?*anyopaque) esp_err_t;
pub extern fn esp_netif_action_start(esp_netif: ?*anyopaque, base: esp_event_base_t, event_id: i32, data: ?*anyopaque) void;
pub extern fn esp_netif_action_stop(esp_netif: ?*anyopaque, base: esp_event_base_t, event_id: i32, data: ?*anyopaque) void;
pub extern fn esp_netif_action_connected(esp_netif: ?*anyopaque, base: esp_event_base_t, event_id: i32, data: ?*anyopaque) void;
pub extern fn esp_netif_action_disconnected(esp_netif: ?*anyopaque, base: esp_event_base_t, event_id: i32, data: ?*anyopaque) void;
pub extern fn esp_netif_action_got_ip(esp_netif: ?*anyopaque, base: esp_event_base_t, event_id: i32, data: ?*anyopaque) void;
pub extern fn esp_netif_action_join_ip6_multicast_group(esp_netif: ?*anyopaque, base: esp_event_base_t, event_id: i32, data: ?*anyopaque) void;
pub extern fn esp_netif_action_leave_ip6_multicast_group(esp_netif: ?*anyopaque, base: esp_event_base_t, event_id: i32, data: ?*anyopaque) void;
pub extern fn esp_netif_action_add_ip6_address(esp_netif: ?*anyopaque, base: esp_event_base_t, event_id: i32, data: ?*anyopaque) void;
pub extern fn esp_netif_action_remove_ip6_address(esp_netif: ?*anyopaque, base: esp_event_base_t, event_id: i32, data: ?*anyopaque) void;
pub extern fn esp_netif_set_default_netif(esp_netif: ?*esp_netif_t) esp_err_t;
pub extern fn esp_netif_get_default_netif() ?*esp_netif_t;
pub extern fn esp_netif_join_ip6_multicast_group(esp_netif: ?*esp_netif_t, addr: [*c]const esp_ip6_addr_t) esp_err_t;
pub extern fn esp_netif_leave_ip6_multicast_group(esp_netif: ?*esp_netif_t, addr: [*c]const esp_ip6_addr_t) esp_err_t;
pub extern fn esp_netif_set_mac(esp_netif: ?*esp_netif_t, mac: [*:0]u8) esp_err_t;
pub extern fn esp_netif_get_mac(esp_netif: ?*esp_netif_t, mac: [*:0]u8) esp_err_t;
pub extern fn esp_netif_set_hostname(esp_netif: ?*esp_netif_t, hostname: [*:0]const u8) esp_err_t;
pub extern fn esp_netif_get_hostname(esp_netif: ?*esp_netif_t, hostname: [*c][*c]const u8) esp_err_t;
pub extern fn esp_netif_is_netif_up(esp_netif: ?*esp_netif_t) bool;
pub extern fn esp_netif_get_ip_info(esp_netif: ?*esp_netif_t, ip_info: [*c]esp_netif_ip_info_t) esp_err_t;
pub extern fn esp_netif_get_old_ip_info(esp_netif: ?*esp_netif_t, ip_info: [*c]esp_netif_ip_info_t) esp_err_t;
pub extern fn esp_netif_set_ip_info(esp_netif: ?*esp_netif_t, ip_info: [*c]const esp_netif_ip_info_t) esp_err_t;
pub extern fn esp_netif_set_old_ip_info(esp_netif: ?*esp_netif_t, ip_info: [*c]const esp_netif_ip_info_t) esp_err_t;
pub extern fn esp_netif_get_netif_impl_index(esp_netif: ?*esp_netif_t) c_int;
pub extern fn esp_netif_get_netif_impl_name(esp_netif: ?*esp_netif_t, name: [*:0]u8) esp_err_t;
pub extern fn esp_netif_napt_enable(esp_netif: ?*esp_netif_t) esp_err_t;
pub extern fn esp_netif_napt_disable(esp_netif: ?*esp_netif_t) esp_err_t;
pub extern fn esp_netif_dhcps_option(esp_netif: ?*esp_netif_t, opt_op: esp_netif_dhcp_option_mode_t, opt_id: esp_netif_dhcp_option_id_t, opt_val: ?*anyopaque, opt_len: u32) esp_err_t;
pub extern fn esp_netif_dhcpc_option(esp_netif: ?*esp_netif_t, opt_op: esp_netif_dhcp_option_mode_t, opt_id: esp_netif_dhcp_option_id_t, opt_val: ?*anyopaque, opt_len: u32) esp_err_t;
pub extern fn esp_netif_dhcpc_start(esp_netif: ?*esp_netif_t) esp_err_t;
pub extern fn esp_netif_dhcpc_stop(esp_netif: ?*esp_netif_t) esp_err_t;
pub extern fn esp_netif_dhcpc_get_status(esp_netif: ?*esp_netif_t, status: [*c]esp_netif_dhcp_status_t) esp_err_t;
pub extern fn esp_netif_dhcps_get_status(esp_netif: ?*esp_netif_t, status: [*c]esp_netif_dhcp_status_t) esp_err_t;
pub extern fn esp_netif_dhcps_start(esp_netif: ?*esp_netif_t) esp_err_t;
pub extern fn esp_netif_dhcps_stop(esp_netif: ?*esp_netif_t) esp_err_t;
pub extern fn esp_netif_dhcps_get_clients_by_mac(esp_netif: ?*esp_netif_t, num: c_int, mac_ip_pair: [*c]esp_netif_pair_mac_ip_t) esp_err_t;
pub extern fn esp_netif_set_dns_info(esp_netif: ?*esp_netif_t, @"type": esp_netif_dns_type_t, dns: [*c]esp_netif_dns_info_t) esp_err_t;
pub extern fn esp_netif_get_dns_info(esp_netif: ?*esp_netif_t, @"type": esp_netif_dns_type_t, dns: [*c]esp_netif_dns_info_t) esp_err_t;
pub extern fn esp_netif_create_ip6_linklocal(esp_netif: ?*esp_netif_t) esp_err_t;
pub extern fn esp_netif_get_ip6_linklocal(esp_netif: ?*esp_netif_t, if_ip6: [*c]esp_ip6_addr_t) esp_err_t;
pub extern fn esp_netif_get_ip6_global(esp_netif: ?*esp_netif_t, if_ip6: [*c]esp_ip6_addr_t) esp_err_t;
pub extern fn esp_netif_get_all_ip6(esp_netif: ?*esp_netif_t, if_ip6: [*c]esp_ip6_addr_t) c_int;
pub extern fn esp_netif_add_ip6_address(esp_netif: ?*esp_netif_t, addr: esp_ip6_addr_t, preferred: bool) esp_err_t;
pub extern fn esp_netif_remove_ip6_address(esp_netif: ?*esp_netif_t, addr: [*c]const esp_ip6_addr_t) esp_err_t;
pub extern fn esp_netif_set_ip4_addr(addr: [*c]esp_ip4_addr_t, a: u8, b: u8, c: u8, d: u8) void;
pub extern fn esp_ip4addr_ntoa(addr: [*c]const esp_ip4_addr_t, buf: [*:0]u8, buflen: c_int) [*:0]u8;
pub extern fn esp_ip4addr_aton(addr: [*:0]const u8) u32;
pub extern fn esp_netif_str_to_ip4(src: [*:0]const u8, dst: [*c]esp_ip4_addr_t) esp_err_t;
pub extern fn esp_netif_str_to_ip6(src: [*:0]const u8, dst: [*c]esp_ip6_addr_t) esp_err_t;
pub extern fn esp_netif_get_io_driver(esp_netif: ?*esp_netif_t) esp_netif_iodriver_handle;
pub extern fn esp_netif_get_handle_from_ifkey(if_key: [*:0]const u8) ?*esp_netif_t;
pub extern fn esp_netif_get_flags(esp_netif: ?*esp_netif_t) esp_netif_flags_t;
pub extern fn esp_netif_get_ifkey(esp_netif: ?*esp_netif_t) [*:0]const u8;
pub extern fn esp_netif_get_desc(esp_netif: ?*esp_netif_t) [*:0]const u8;
pub extern fn esp_netif_get_route_prio(esp_netif: ?*esp_netif_t) c_int;
pub extern fn esp_netif_get_event_id(esp_netif: ?*esp_netif_t, event_type: esp_netif_ip_event_type_t) i32;
pub extern fn esp_netif_next(esp_netif: ?*esp_netif_t) ?*esp_netif_t;
pub extern fn esp_netif_next_unsafe(esp_netif: ?*esp_netif_t) ?*esp_netif_t;
pub const esp_netif_find_predicate_t = ?*const fn (?*esp_netif_t, ?*anyopaque) callconv(.C) bool;
pub extern fn esp_netif_find_if(@"fn": esp_netif_find_predicate_t, ctx: ?*anyopaque) ?*esp_netif_t;
pub extern fn esp_netif_get_nr_of_ifs() usize;
pub extern fn esp_netif_netstack_buf_ref(netstack_buf: ?*anyopaque) void;
pub extern fn esp_netif_netstack_buf_free(netstack_buf: ?*anyopaque) void;
pub const esp_netif_callback_fn = ?*const fn (?*anyopaque) callconv(.C) esp_err_t;
pub extern fn esp_netif_tcpip_exec(@"fn": esp_netif_callback_fn, ctx: ?*anyopaque) esp_err_t;
pub extern fn esp_netif_attach_wifi_station(esp_netif: ?*esp_netif_t) esp_err_t;
pub extern fn esp_netif_attach_wifi_ap(esp_netif: ?*esp_netif_t) esp_err_t;
pub extern fn esp_wifi_set_default_wifi_sta_handlers() esp_err_t;
pub extern fn esp_wifi_set_default_wifi_ap_handlers() esp_err_t;
pub extern fn esp_wifi_set_default_wifi_nan_handlers() esp_err_t;
pub extern fn esp_wifi_clear_default_wifi_driver_and_handlers(esp_netif: ?*anyopaque) esp_err_t;
pub extern fn esp_netif_create_default_wifi_ap() ?*esp_netif_t;
pub extern fn esp_netif_create_default_wifi_sta() ?*esp_netif_t;
pub extern fn esp_netif_create_default_wifi_nan() ?*esp_netif_t;
pub extern fn esp_netif_destroy_default_wifi(esp_netif: ?*anyopaque) void;
pub extern fn esp_netif_create_wifi(wifi_if: wifi_interface_t, esp_netif_config: [*c]const esp_netif_inherent_config_t) ?*esp_netif_t;
pub extern fn esp_netif_create_default_wifi_mesh_netifs(p_netif_sta: [*c]?*esp_netif_t, p_netif_ap: [*c]?*esp_netif_t) esp_err_t;
pub const wifi_osi_funcs_t = opaque {};
pub const wifi_init_config_t = extern struct {
    osi_funcs: ?*wifi_osi_funcs_t = std.mem.zeroes(?*wifi_osi_funcs_t),
    wpa_crypto_funcs: wpa_crypto_funcs_t = std.mem.zeroes(wpa_crypto_funcs_t),
    static_rx_buf_num: c_int = std.mem.zeroes(c_int),
    dynamic_rx_buf_num: c_int = std.mem.zeroes(c_int),
    tx_buf_type: c_int = std.mem.zeroes(c_int),
    static_tx_buf_num: c_int = std.mem.zeroes(c_int),
    dynamic_tx_buf_num: c_int = std.mem.zeroes(c_int),
    rx_mgmt_buf_type: c_int = std.mem.zeroes(c_int),
    rx_mgmt_buf_num: c_int = std.mem.zeroes(c_int),
    cache_tx_buf_num: c_int = std.mem.zeroes(c_int),
    csi_enable: c_int = std.mem.zeroes(c_int),
    ampdu_rx_enable: c_int = std.mem.zeroes(c_int),
    ampdu_tx_enable: c_int = std.mem.zeroes(c_int),
    amsdu_tx_enable: c_int = std.mem.zeroes(c_int),
    nvs_enable: c_int = std.mem.zeroes(c_int),
    nano_enable: c_int = std.mem.zeroes(c_int),
    rx_ba_win: c_int = std.mem.zeroes(c_int),
    wifi_task_core_id: c_int = std.mem.zeroes(c_int),
    beacon_max_len: c_int = std.mem.zeroes(c_int),
    mgmt_sbuf_num: c_int = std.mem.zeroes(c_int),
    feature_caps: u64 = std.mem.zeroes(u64),
    sta_disconnected_pm: bool = std.mem.zeroes(bool),
    espnow_max_encrypt_num: c_int = std.mem.zeroes(c_int),
    magic: c_int = std.mem.zeroes(c_int),
};
pub extern const g_wifi_default_wpa_crypto_funcs: wpa_crypto_funcs_t;
pub extern var g_wifi_osi_funcs: wifi_osi_funcs_t;
pub extern fn esp_wifi_init(config: ?*const wifi_init_config_t) esp_err_t;
pub extern fn esp_wifi_deinit() esp_err_t;
pub extern fn esp_wifi_set_mode(mode: wifi_mode_t) esp_err_t;
pub extern fn esp_wifi_get_mode(mode: [*c]wifi_mode_t) esp_err_t;
pub extern fn esp_wifi_start() esp_err_t;
pub extern fn esp_wifi_stop() esp_err_t;
pub extern fn esp_wifi_restore() esp_err_t;
pub extern fn esp_wifi_connect() esp_err_t;
pub extern fn esp_wifi_disconnect() esp_err_t;
pub extern fn esp_wifi_clear_fast_connect() esp_err_t;
pub extern fn esp_wifi_deauth_sta(aid: u16) esp_err_t;
pub extern fn esp_wifi_scan_start(config: [*c]const wifi_scan_config_t, block: bool) esp_err_t;
pub extern fn esp_wifi_scan_stop() esp_err_t;
pub extern fn esp_wifi_scan_get_ap_num(number: [*c]u16) esp_err_t;
pub extern fn esp_wifi_scan_get_ap_records(number: [*c]u16, ap_records: ?*wifi_ap_record_t) esp_err_t;
pub extern fn esp_wifi_scan_get_ap_record(ap_record: ?*wifi_ap_record_t) esp_err_t;
pub extern fn esp_wifi_clear_ap_list() esp_err_t;
pub extern fn esp_wifi_sta_get_ap_info(ap_info: ?*wifi_ap_record_t) esp_err_t;
pub extern fn esp_wifi_set_ps(@"type": wifi_ps_type_t) esp_err_t;
pub extern fn esp_wifi_get_ps(@"type": [*c]wifi_ps_type_t) esp_err_t;
pub extern fn esp_wifi_set_protocol(ifx: wifi_interface_t, protocol_bitmap: u8) esp_err_t;
pub extern fn esp_wifi_get_protocol(ifx: wifi_interface_t, protocol_bitmap: [*:0]u8) esp_err_t;
pub extern fn esp_wifi_set_bandwidth(ifx: wifi_interface_t, bw: wifi_bandwidth_t) esp_err_t;
pub extern fn esp_wifi_get_bandwidth(ifx: wifi_interface_t, bw: [*c]wifi_bandwidth_t) esp_err_t;
pub extern fn esp_wifi_set_channel(primary: u8, second: wifi_second_chan_t) esp_err_t;
pub extern fn esp_wifi_get_channel(primary: [*:0]u8, second: [*c]wifi_second_chan_t) esp_err_t;
pub extern fn esp_wifi_set_country(country: [*c]const wifi_country_t) esp_err_t;
pub extern fn esp_wifi_get_country(country: [*c]wifi_country_t) esp_err_t;
pub extern fn esp_wifi_set_mac(ifx: wifi_interface_t, mac: [*:0]const u8) esp_err_t;
pub extern fn esp_wifi_get_mac(ifx: wifi_interface_t, mac: [*:0]u8) esp_err_t;
pub const wifi_promiscuous_cb_t = ?*const fn (?*anyopaque, wifi_promiscuous_pkt_type_t) callconv(.C) void;
pub extern fn esp_wifi_set_promiscuous_rx_cb(cb: wifi_promiscuous_cb_t) esp_err_t;
pub extern fn esp_wifi_set_promiscuous(en: bool) esp_err_t;
pub extern fn esp_wifi_get_promiscuous(en: [*c]bool) esp_err_t;
pub extern fn esp_wifi_set_promiscuous_filter(filter: [*c]const wifi_promiscuous_filter_t) esp_err_t;
pub extern fn esp_wifi_get_promiscuous_filter(filter: [*c]wifi_promiscuous_filter_t) esp_err_t;
pub extern fn esp_wifi_set_promiscuous_ctrl_filter(filter: [*c]const wifi_promiscuous_filter_t) esp_err_t;
pub extern fn esp_wifi_get_promiscuous_ctrl_filter(filter: [*c]wifi_promiscuous_filter_t) esp_err_t;
pub extern fn esp_wifi_set_config(interface: wifi_interface_t, conf: ?*wifi_config_t) esp_err_t;
pub extern fn esp_wifi_get_config(interface: wifi_interface_t, conf: ?*wifi_config_t) esp_err_t;
pub extern fn esp_wifi_ap_get_sta_list(sta: ?*wifi_sta_list_t) esp_err_t;
pub extern fn esp_wifi_ap_get_sta_aid(mac: [*:0]const u8, aid: [*c]u16) esp_err_t;
pub extern fn esp_wifi_set_storage(storage: wifi_storage_t) esp_err_t;
pub const esp_vendor_ie_cb_t = ?*const fn (?*anyopaque, wifi_vendor_ie_type_t, [*:0]const u8, [*c]const vendor_ie_data_t, c_int) callconv(.C) void;
pub extern fn esp_wifi_set_vendor_ie(enable: bool, @"type": wifi_vendor_ie_type_t, idx: wifi_vendor_ie_id_t, vnd_ie: ?*const anyopaque) esp_err_t;
pub extern fn esp_wifi_set_vendor_ie_cb(cb: esp_vendor_ie_cb_t, ctx: ?*anyopaque) esp_err_t;
pub extern fn esp_wifi_set_max_tx_power(power: i8) esp_err_t;
pub extern fn esp_wifi_get_max_tx_power(power: [*:0]i8) esp_err_t;
pub extern fn esp_wifi_set_event_mask(mask: u32) esp_err_t;
pub extern fn esp_wifi_get_event_mask(mask: [*c]u32) esp_err_t;
pub extern fn esp_wifi_80211_tx(ifx: wifi_interface_t, buffer: ?*const anyopaque, len: c_int, en_sys_seq: bool) esp_err_t;
pub const wifi_csi_cb_t = ?*const fn (?*anyopaque, ?*wifi_csi_info_t) callconv(.C) void;
pub extern fn esp_wifi_set_csi_rx_cb(cb: wifi_csi_cb_t, ctx: ?*anyopaque) esp_err_t;
pub extern fn esp_wifi_set_csi_config(config: ?*const wifi_csi_config_t) esp_err_t;
pub extern fn esp_wifi_set_csi(en: bool) esp_err_t;
pub extern fn esp_wifi_set_ant_gpio(config: [*c]const wifi_ant_gpio_config_t) esp_err_t;
pub extern fn esp_wifi_get_ant_gpio(config: [*c]wifi_ant_gpio_config_t) esp_err_t;
pub extern fn esp_wifi_set_ant(config: ?*const wifi_ant_config_t) esp_err_t;
pub extern fn esp_wifi_get_ant(config: ?*wifi_ant_config_t) esp_err_t;
pub extern fn esp_wifi_get_tsf_time(interface: wifi_interface_t) i64;
pub extern fn esp_wifi_set_inactive_time(ifx: wifi_interface_t, sec: u16) esp_err_t;
pub extern fn esp_wifi_get_inactive_time(ifx: wifi_interface_t, sec: [*c]u16) esp_err_t;
pub extern fn esp_wifi_statis_dump(modules: u32) esp_err_t;
pub extern fn esp_wifi_set_rssi_threshold(rssi: i32) esp_err_t;
pub extern fn esp_wifi_ftm_initiate_session(cfg: [*c]wifi_ftm_initiator_cfg_t) esp_err_t;
pub extern fn esp_wifi_ftm_end_session() esp_err_t;
pub extern fn esp_wifi_ftm_resp_set_offset(offset_cm: i16) esp_err_t;
pub extern fn esp_wifi_config_11b_rate(ifx: wifi_interface_t, disable: bool) esp_err_t;
pub extern fn esp_wifi_connectionless_module_set_wake_interval(wake_interval: u16) esp_err_t;
pub extern fn esp_wifi_force_wakeup_acquire() esp_err_t;
pub extern fn esp_wifi_force_wakeup_release() esp_err_t;
pub extern fn esp_wifi_set_country_code(country: [*:0]const u8, ieee80211d_enabled: bool) esp_err_t;
pub extern fn esp_wifi_get_country_code(country: [*:0]u8) esp_err_t;
pub extern fn esp_wifi_config_80211_tx_rate(ifx: wifi_interface_t, rate: wifi_phy_rate_t) esp_err_t;
pub extern fn esp_wifi_disable_pmf_config(ifx: wifi_interface_t) esp_err_t;
pub extern fn esp_wifi_sta_get_aid(aid: [*c]u16) esp_err_t;
pub extern fn esp_wifi_sta_get_negotiated_phymode(phymode: [*c]wifi_phy_mode_t) esp_err_t;
pub extern fn esp_wifi_set_dynamic_cs(enabled: bool) esp_err_t;
pub extern fn esp_wifi_sta_get_rssi(rssi: [*c]c_int) esp_err_t;

// ------------------------------ wifi internal STUBS
pub export fn esp_wifi_internal_set_sta_ip() callconv(.C) esp_err_t {
    return .ESP_OK;
}

pub const wifi_netstack_buf_ref_cb_t = ?*const fn (?*anyopaque) callconv(.C) void;
pub const wifi_netstack_buf_free_cb_t = ?*const fn (?*anyopaque) callconv(.C) void;
pub export fn esp_wifi_internal_reg_netstack_buf_cb(ref: wifi_netstack_buf_ref_cb_t, free: wifi_netstack_buf_free_cb_t) esp_err_t {
    _ = ref; // unused
    _ = free; // unused
    return .ESP_OK;
}

pub export fn esp_wifi_internal_free_rx_buffer(buffer: ?*anyopaque) void {
    std.c.free(buffer);
}
const struct_esp_remote_channel = opaque {};
pub const esp_remote_channel_t = ?*struct_esp_remote_channel;
pub const esp_remote_channel_tx_fn_t = ?*const fn (?*anyopaque, ?*anyopaque, usize) callconv(.C) esp_err_t;
var s_tx_cb: [2]esp_remote_channel_tx_fn_t = std.mem.zeroes([2]esp_remote_channel_tx_fn_t);
var s_channel: [2]esp_remote_channel_t = std.mem.zeroes([2]esp_remote_channel_t);
var s_rx_fn: [2]wifi_rxcb_t = std.mem.zeroes([2]wifi_rxcb_t);
pub const wifi_rxcb_t = ?*const fn (?*anyopaque, u16, ?*anyopaque) callconv(.C) esp_err_t;

pub export fn esp_wifi_internal_tx(ifx: wifi_interface_t, buffer: ?*anyopaque, len: u16) esp_err_t {
    if (ifx == .WIFI_IF_STA) {
        return s_tx_cb[@as(c_uint, @intCast(@as(c_int, 0)))].?(@as(?*anyopaque, @ptrCast(s_channel[@as(c_uint, @intCast(@as(c_int, 0)))])), buffer, @as(usize, @bitCast(@as(c_ulong, len))));
    }
    if (ifx == .WIFI_IF_AP) {
        return s_tx_cb[@as(c_uint, @intCast(@as(c_int, 1)))].?(@as(?*anyopaque, @ptrCast(s_channel[@as(c_uint, @intCast(@as(c_int, 1)))])), buffer, @as(usize, @bitCast(@as(c_ulong, len))));
    }
    return .ESP_FAIL;
}
pub export fn esp_wifi_internal_reg_rxcb(ifx: wifi_interface_t, @"fn": wifi_rxcb_t) esp_err_t {
    if (ifx == .WIFI_IF_STA) {
        s_rx_fn[@as(c_uint, @intCast(@as(c_int, 0)))] = @"fn";
        return .ESP_OK;
    }
    if (ifx == .WIFI_IF_AP) {
        s_rx_fn[@as(c_uint, @intCast(@as(c_int, 1)))] = @"fn";
        return .ESP_OK;
    }
    return .ESP_FAIL;
}
// -------------------------------------------------
pub const linenoiseCompletions = opaque {};
pub const esp_console_config_t = extern struct {
    max_cmdline_length: usize = std.mem.zeroes(usize),
    max_cmdline_args: usize = std.mem.zeroes(usize),
    heap_alloc_caps: u32 = std.mem.zeroes(u32),
    hint_color: c_int = std.mem.zeroes(c_int),
    hint_bold: c_int = std.mem.zeroes(c_int),
};
pub const esp_console_repl_config_t = extern struct {
    max_history_len: u32 = std.mem.zeroes(u32),
    history_save_path: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    task_stack_size: u32 = std.mem.zeroes(u32),
    task_priority: u32 = std.mem.zeroes(u32),
    prompt: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    max_cmdline_length: usize = std.mem.zeroes(usize),
};
pub const esp_console_dev_uart_config_t = extern struct {
    channel: c_int = std.mem.zeroes(c_int),
    baud_rate: c_int = std.mem.zeroes(c_int),
    tx_gpio_num: c_int = std.mem.zeroes(c_int),
    rx_gpio_num: c_int = std.mem.zeroes(c_int),
};
pub extern fn esp_console_init(config: [*c]const esp_console_config_t) esp_err_t;
pub extern fn esp_console_deinit() esp_err_t;
pub const esp_console_cmd_func_t = ?*const fn (c_int, [*c][*c]u8) callconv(.C) c_int;
pub const esp_console_cmd_t = extern struct {
    command: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    help: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    hint: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    func: esp_console_cmd_func_t = std.mem.zeroes(esp_console_cmd_func_t),
    argtable: ?*anyopaque = null,
};
pub extern fn esp_console_cmd_register(cmd: [*c]const esp_console_cmd_t) esp_err_t;
pub extern fn esp_console_run(cmdline: [*:0]const u8, cmd_ret: [*c]c_int) esp_err_t;
pub extern fn esp_console_split_argv(line: [*:0]u8, argv: [*c][*c]u8, argv_size: usize) usize;
pub extern fn esp_console_get_completion(buf: [*:0]const u8, lc: ?*linenoiseCompletions) void;
pub extern fn esp_console_get_hint(buf: [*:0]const u8, color: [*c]c_int, bold: [*c]c_int) [*:0]const u8;
pub extern fn esp_console_register_help_command() esp_err_t;
pub const esp_console_repl_t = esp_console_repl_s;
pub const esp_console_repl_s = extern struct {
    del: ?*const fn ([*c]esp_console_repl_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_console_repl_t) callconv(.C) esp_err_t),
};
pub extern fn esp_console_new_repl_uart(dev_config: [*c]const esp_console_dev_uart_config_t, repl_config: [*c]const esp_console_repl_config_t, ret_repl: [*c][*c]esp_console_repl_t) esp_err_t;
pub extern fn esp_console_start_repl(repl: [*c]esp_console_repl_t) esp_err_t;

pub const va_list = extern struct {
    __va_stk: [*c]c_int = std.mem.zeroes([*c]c_int),
    __va_reg: [*c]c_int = std.mem.zeroes([*c]c_int),
    __va_ndx: c_int = std.mem.zeroes(c_int),
};

/// C Wrapper
pub const gpio_etm_event_edge_t = enum(c_uint) {
    GPIO_ETM_EVENT_EDGE_POS = 0,
    GPIO_ETM_EVENT_EDGE_NEG = 1,
    GPIO_ETM_EVENT_EDGE_ANY = 2,
};
pub const gpio_etm_event_config_t = extern struct {
    edge: gpio_etm_event_edge_t = std.mem.zeroes(gpio_etm_event_edge_t),
};
pub extern fn gpio_new_etm_event(config: [*c]const gpio_etm_event_config_t, ret_event: [*c]esp_etm_event_handle_t) esp_err_t;
pub extern fn gpio_etm_event_bind_gpio(event: esp_etm_event_handle_t, gpio_num: c_int) esp_err_t;
pub const gpio_etm_task_action_t = enum(c_uint) {
    GPIO_ETM_TASK_ACTION_SET = 0,
    GPIO_ETM_TASK_ACTION_CLR = 1,
    GPIO_ETM_TASK_ACTION_TOG = 2,
};
pub const gpio_etm_task_config_t = extern struct {
    action: gpio_etm_task_action_t = std.mem.zeroes(gpio_etm_task_action_t),
};
pub extern fn gpio_new_etm_task(config: [*c]const gpio_etm_task_config_t, ret_task: [*c]esp_etm_task_handle_t) esp_err_t;
pub extern fn gpio_etm_task_add_gpio(task: esp_etm_task_handle_t, gpio_num: c_int) esp_err_t;
pub extern fn gpio_etm_task_rm_gpio(task: esp_etm_task_handle_t, gpio_num: c_int) esp_err_t;
pub const gpio_isr_handle_t = intr_handle_t;
pub const gpio_isr_t = ?*const fn (?*anyopaque) callconv(.C) void;
pub const gpio_config_t = extern struct {
    pin_bit_mask: u64 = std.mem.zeroes(u64),
    mode: gpio_mode_t = std.mem.zeroes(gpio_mode_t),
    pull_up_en: gpio_pullup_t = std.mem.zeroes(gpio_pullup_t),
    pull_down_en: gpio_pulldown_t = std.mem.zeroes(gpio_pulldown_t),
    intr_type: gpio_int_type_t = std.mem.zeroes(gpio_int_type_t),
};
pub extern fn gpio_config(pGPIOConfig: [*c]const gpio_config_t) esp_err_t;
pub extern fn gpio_reset_pin(gpio_num: gpio_num_t) esp_err_t;
pub extern fn gpio_set_intr_type(gpio_num: gpio_num_t, intr_type: gpio_int_type_t) esp_err_t;
pub extern fn gpio_intr_enable(gpio_num: gpio_num_t) esp_err_t;
pub extern fn gpio_intr_disable(gpio_num: gpio_num_t) esp_err_t;
pub extern fn gpio_set_level(gpio_num: gpio_num_t, level: u32) esp_err_t;
pub extern fn gpio_get_level(gpio_num: gpio_num_t) c_int;
pub extern fn gpio_set_direction(gpio_num: gpio_num_t, mode: gpio_mode_t) esp_err_t;
pub extern fn gpio_set_pull_mode(gpio_num: gpio_num_t, pull: gpio_pull_mode_t) esp_err_t;
pub extern fn gpio_wakeup_enable(gpio_num: gpio_num_t, intr_type: gpio_int_type_t) esp_err_t;
pub extern fn gpio_wakeup_disable(gpio_num: gpio_num_t) esp_err_t;
pub extern fn gpio_isr_register(@"fn": ?*const fn (?*anyopaque) callconv(.C) void, arg: ?*anyopaque, intr_alloc_flags: c_int, handle: [*c]gpio_isr_handle_t) esp_err_t;
pub extern fn gpio_pullup_en(gpio_num: gpio_num_t) esp_err_t;
pub extern fn gpio_pullup_dis(gpio_num: gpio_num_t) esp_err_t;
pub extern fn gpio_pulldown_en(gpio_num: gpio_num_t) esp_err_t;
pub extern fn gpio_pulldown_dis(gpio_num: gpio_num_t) esp_err_t;
pub extern fn gpio_install_isr_service(intr_alloc_flags: c_int) esp_err_t;
pub extern fn gpio_uninstall_isr_service() void;
pub extern fn gpio_isr_handler_add(gpio_num: gpio_num_t, isr_handler: gpio_isr_t, args: ?*anyopaque) esp_err_t;
pub extern fn gpio_isr_handler_remove(gpio_num: gpio_num_t) esp_err_t;
pub extern fn gpio_set_drive_capability(gpio_num: gpio_num_t, strength: gpio_drive_cap_t) esp_err_t;
pub extern fn gpio_get_drive_capability(gpio_num: gpio_num_t, strength: [*c]gpio_drive_cap_t) esp_err_t;
pub extern fn gpio_hold_en(gpio_num: gpio_num_t) esp_err_t;
pub extern fn gpio_hold_dis(gpio_num: gpio_num_t) esp_err_t;
pub extern fn gpio_deep_sleep_hold_en() void;
pub extern fn gpio_deep_sleep_hold_dis() void;
pub extern fn gpio_iomux_in(gpio_num: u32, signal_idx: u32) void;
pub extern fn gpio_iomux_out(gpio_num: u8, func: c_int, oen_inv: bool) void;
pub extern fn gpio_force_hold_all() esp_err_t;
pub extern fn gpio_force_unhold_all() esp_err_t;
pub extern fn gpio_sleep_sel_en(gpio_num: gpio_num_t) esp_err_t;
pub extern fn gpio_sleep_sel_dis(gpio_num: gpio_num_t) esp_err_t;
pub extern fn gpio_sleep_set_direction(gpio_num: gpio_num_t, mode: gpio_mode_t) esp_err_t;
pub extern fn gpio_sleep_set_pull_mode(gpio_num: gpio_num_t, pull: gpio_pull_mode_t) esp_err_t;
pub extern fn gpio_deep_sleep_wakeup_enable(gpio_num: gpio_num_t, intr_type: gpio_int_type_t) esp_err_t;
pub extern fn gpio_deep_sleep_wakeup_disable(gpio_num: gpio_num_t) esp_err_t;
pub extern fn gpio_dump_io_configuration(out_stream: ?*std.c.FILE, io_bit_mask: u64) esp_err_t;
pub extern fn esp_rom_gpio_pad_select_gpio(iopad_num: u32) void;
pub extern fn esp_rom_gpio_pad_pullup_only(iopad_num: u32) void;
pub extern fn esp_rom_gpio_pad_unhold(gpio_num: u32) void;
pub extern fn esp_rom_gpio_pad_set_drv(iopad_num: u32, drv: u32) void;
pub extern fn esp_rom_gpio_connect_in_signal(gpio_num: u32, signal_idx: u32, inv: bool) void;
pub extern fn esp_rom_gpio_connect_out_signal(gpio_num: u32, signal_idx: u32, out_inv: bool, oen_inv: bool) void;
pub const esp_etm_channel_t = opaque {};
pub const esp_etm_channel_handle_t = ?*esp_etm_channel_t;
pub const esp_etm_event_t = opaque {};
pub const esp_etm_event_handle_t = ?*esp_etm_event_t;
pub const esp_etm_task_t = opaque {};
pub const esp_etm_task_handle_t = ?*esp_etm_task_t;
pub const esp_etm_channel_config_t = extern struct {};
pub extern fn esp_etm_new_channel(config: [*c]const esp_etm_channel_config_t, ret_chan: [*c]esp_etm_channel_handle_t) esp_err_t;
pub extern fn esp_etm_del_channel(chan: esp_etm_channel_handle_t) esp_err_t;
pub extern fn esp_etm_channel_enable(chan: esp_etm_channel_handle_t) esp_err_t;
pub extern fn esp_etm_channel_disable(chan: esp_etm_channel_handle_t) esp_err_t;
pub extern fn esp_etm_channel_connect(chan: esp_etm_channel_handle_t, event: esp_etm_event_handle_t, task: esp_etm_task_handle_t) esp_err_t;
pub extern fn esp_etm_del_event(event: esp_etm_event_handle_t) esp_err_t;
pub extern fn esp_etm_del_task(task: esp_etm_task_handle_t) esp_err_t;
pub extern fn esp_etm_dump(out_stream: ?*std.c.FILE) esp_err_t;

pub const sdmmc_erase_arg_t = enum(c_uint) {
    SDMMC_ERASE_ARG = 0,
    SDMMC_DISCARD_ARG = 1,
};
pub const soc_root_clk_t = enum(c_uint) {
    SOC_ROOT_CLK_INT_RC_FAST = 0,
    SOC_ROOT_CLK_INT_RC_SLOW = 1,
    SOC_ROOT_CLK_EXT_XTAL = 2,
    SOC_ROOT_CLK_EXT_XTAL32K = 3,
};
pub const soc_cpu_clk_src_t = enum(c_uint) {
    SOC_CPU_CLK_SRC_XTAL = 0,
    SOC_CPU_CLK_SRC_PLL = 1,
    SOC_CPU_CLK_SRC_RC_FAST = 2,
    SOC_CPU_CLK_SRC_INVALID = 3,
};
pub const soc_rtc_slow_clk_src_t = enum(c_uint) {
    SOC_RTC_SLOW_CLK_SRC_RC_SLOW = 0,
    SOC_RTC_SLOW_CLK_SRC_XTAL32K = 1,
    SOC_RTC_SLOW_CLK_SRC_RC_FAST_D256 = 2,
    SOC_RTC_SLOW_CLK_SRC_INVALID = 3,
};
pub const soc_rtc_fast_clk_src_t = enum(c_uint) {
    SOC_RTC_FAST_CLK_SRC_XTAL_D2 = 0,
    //SOC_RTC_FAST_CLK_SRC_XTAL_DIV = 0,
    SOC_RTC_FAST_CLK_SRC_RC_FAST = 1,
    SOC_RTC_FAST_CLK_SRC_INVALID = 2,
};
pub const soc_module_clk_t = enum(c_uint) {
    SOC_MOD_CLK_CPU = 1,
    SOC_MOD_CLK_RTC_FAST = 2,
    SOC_MOD_CLK_RTC_SLOW = 3,
    SOC_MOD_CLK_APB = 4,
    SOC_MOD_CLK_PLL_F80M = 5,
    SOC_MOD_CLK_PLL_F160M = 6,
    SOC_MOD_CLK_PLL_D2 = 7,
    SOC_MOD_CLK_XTAL32K = 8,
    SOC_MOD_CLK_RC_FAST = 9,
    SOC_MOD_CLK_RC_FAST_D256 = 10,
    SOC_MOD_CLK_XTAL = 11,
    SOC_MOD_CLK_TEMP_SENSOR = 12,
    SOC_MOD_CLK_INVALID = 13,
};
pub const soc_periph_systimer_clk_src_t = enum(c_uint) {
    SYSTIMER_CLK_SRC_XTAL = 11,
    //SYSTIMER_CLK_SRC_DEFAULT = 11,
};
pub const soc_periph_gptimer_clk_src_t = enum(c_uint) {
    GPTIMER_CLK_SRC_APB = 4,
    GPTIMER_CLK_SRC_XTAL = 11,
    //GPTIMER_CLK_SRC_DEFAULT = 4,
};
pub const soc_periph_tg_clk_src_legacy_t = enum(c_uint) {
    TIMER_SRC_CLK_APB = 4,
    TIMER_SRC_CLK_XTAL = 11,
    //TIMER_SRC_CLK_DEFAULT = 4,
};
pub const soc_periph_lcd_clk_src_t = enum(c_uint) {
    LCD_CLK_SRC_PLL160M = 6,
    LCD_CLK_SRC_PLL240M = 7,
    LCD_CLK_SRC_XTAL = 11,
    //LCD_CLK_SRC_DEFAULT = 6,
};
pub const soc_periph_rmt_clk_src_t = enum(c_uint) {
    RMT_CLK_SRC_APB = 4,
    RMT_CLK_SRC_RC_FAST = 9,
    RMT_CLK_SRC_XTAL = 11,
    //RMT_CLK_SRC_DEFAULT = 4,
};
pub const soc_periph_rmt_clk_src_legacy_t = enum(c_uint) {
    RMT_BASECLK_APB = 4,
    RMT_BASECLK_XTAL = 11,
    //RMT_BASECLK_DEFAULT = 4,
};
pub const soc_periph_temperature_sensor_clk_src_t = enum(c_uint) {
    TEMPERATURE_SENSOR_CLK_SRC_RC_FAST = 12,
    //TEMPERATURE_SENSOR_CLK_SRC_DEFAULT = 12,
};
pub const soc_periph_mcpwm_timer_clk_src_t = enum(c_uint) {
    MCPWM_TIMER_CLK_SRC_PLL160M = 6,
    //MCPWM_TIMER_CLK_SRC_DEFAULT = 6,
};
pub const soc_periph_mcpwm_capture_clk_src_t = enum(c_uint) {
    MCPWM_CAPTURE_CLK_SRC_APB = 4,
    //MCPWM_CAPTURE_CLK_SRC_DEFAULT = 4,
};
pub const soc_periph_mcpwm_carrier_clk_src_t = enum(c_uint) {
    MCPWM_CARRIER_CLK_SRC_PLL160M = 6,
    //MCPWM_CARRIER_CLK_SRC_DEFAULT = 6,
};
pub const soc_periph_i2s_clk_src_t = enum(c_int) {
    //I2S_CLK_SRC_DEFAULT = 6,
    I2S_CLK_SRC_PLL_160M = 6,
    I2S_CLK_SRC_XTAL = 11,
    I2S_CLK_SRC_EXTERNAL = -1,
};
pub const soc_periph_i2c_clk_src_t = enum(c_uint) {
    I2C_CLK_SRC_XTAL = 11,
    I2C_CLK_SRC_RC_FAST = 9,
    //I2C_CLK_SRC_DEFAULT = 11,
};
pub const soc_periph_spi_clk_src_t = enum(c_uint) {
    //SPI_CLK_SRC_DEFAULT = 4,
    SPI_CLK_SRC_APB = 4,
    SPI_CLK_SRC_XTAL = 11,
};
pub const soc_periph_sdm_clk_src_t = enum(c_uint) {
    SDM_CLK_SRC_APB = 4,
    //SDM_CLK_SRC_DEFAULT = 4,
};
pub const soc_periph_glitch_filter_clk_src_t = enum(c_uint) {
    GLITCH_FILTER_CLK_SRC_APB = 4,
    //GLITCH_FILTER_CLK_SRC_DEFAULT = 4,
};
pub const soc_periph_twai_clk_src_t = enum(c_uint) {
    TWAI_CLK_SRC_APB = 4,
    //TWAI_CLK_SRC_DEFAULT = 4,
};
pub const soc_periph_adc_digi_clk_src_t = enum(c_uint) {
    ADC_DIGI_CLK_SRC_APB = 4,
    ADC_DIGI_CLK_SRC_PLL_F240M = 7,
    //ADC_DIGI_CLK_SRC_DEFAULT = 4,
};
pub const soc_periph_adc_rtc_clk_src_t = enum(c_uint) {
    ADC_RTC_CLK_SRC_RC_FAST = 9,
    //ADC_RTC_CLK_SRC_DEFAULT = 9,
};
pub const soc_periph_mwdt_clk_src_t = enum(c_uint) {
    MWDT_CLK_SRC_APB = 4,
    //MWDT_CLK_SRC_DEFAULT = 4,
};
pub const soc_periph_ledc_clk_src_legacy_t = enum(c_uint) {
    LEDC_AUTO_CLK = 0,
    LEDC_USE_APB_CLK = 4,
    LEDC_USE_RC_FAST_CLK = 9,
    LEDC_USE_XTAL_CLK = 11,
    LEDC_USE_RTC8M_CLK = 9,
};
pub const soc_periph_sdmmc_clk_src_t = enum(c_uint) {
    //SDMMC_CLK_SRC_DEFAULT = 6,
    SDMMC_CLK_SRC_PLL160M = 6,
    SDMMC_CLK_SRC_XTAL = 11,
};
pub const soc_clkout_sig_id_t = enum(c_uint) {
    CLKOUT_SIG_PLL = 1,
    CLKOUT_SIG_RC_SLOW = 4,
    CLKOUT_SIG_XTAL = 5,
    CLKOUT_SIG_PLL_F80M = 13,
    CLKOUT_SIG_RC_FAST = 14,
    CLKOUT_SIG_INVALID = 255,
};
pub const spi_host_device_t = enum(c_uint) {
    SPI1_HOST = 0,
    SPI2_HOST = 1,
    SPI3_HOST = 2,
    SPI_HOST_MAX = 3,
};
pub const spi_clock_source_t = soc_periph_spi_clk_src_t;
pub const spi_event_t = enum(c_uint) {
    SPI_EV_BUF_TX = 1,
    SPI_EV_BUF_RX = 2,
    SPI_EV_SEND_DMA_READY = 4,
    SPI_EV_SEND = 8,
    SPI_EV_RECV_DMA_READY = 16,
    SPI_EV_RECV = 32,
    SPI_EV_CMD9 = 64,
    SPI_EV_CMDA = 128,
    SPI_EV_TRANS = 256,
};
pub const spi_line_mode_t = extern struct {
    cmd_lines: u8 = std.mem.zeroes(u8),
    addr_lines: u8 = std.mem.zeroes(u8),
    data_lines: u8 = std.mem.zeroes(u8),
};
pub const spi_command_t = enum(c_uint) {
    SPI_CMD_HD_WRBUF = 1,
    SPI_CMD_HD_RDBUF = 2,
    SPI_CMD_HD_WRDMA = 4,
    SPI_CMD_HD_RDDMA = 8,
    SPI_CMD_HD_SEG_END = 16,
    SPI_CMD_HD_EN_QPI = 32,
    SPI_CMD_HD_WR_END = 64,
    SPI_CMD_HD_INT0 = 128,
    SPI_CMD_HD_INT1 = 256,
    SPI_CMD_HD_INT2 = 512,
};
pub const spi_common_dma_t = enum(c_uint) {
    SPI_DMA_DISABLED = 0,
    SPI_DMA_CH_AUTO = 3,
};
pub const spi_dma_chan_t = spi_common_dma_t;
const union_unnamed_6 = extern union {
    mosi_io_num: c_int,
    data0_io_num: c_int,
};
const union_unnamed_7 = extern union {
    miso_io_num: c_int,
    data1_io_num: c_int,
};
const union_unnamed_8 = extern union {
    quadwp_io_num: c_int,
    data2_io_num: c_int,
};
const union_unnamed_9 = extern union {
    quadhd_io_num: c_int,
    data3_io_num: c_int,
};
pub const spi_bus_config_t = extern struct {
    unnamed_0: union_unnamed_6 = std.mem.zeroes(union_unnamed_6),
    unnamed_1: union_unnamed_7 = std.mem.zeroes(union_unnamed_7),
    sclk_io_num: c_int = std.mem.zeroes(c_int),
    unnamed_2: union_unnamed_8 = std.mem.zeroes(union_unnamed_8),
    unnamed_3: union_unnamed_9 = std.mem.zeroes(union_unnamed_9),
    data4_io_num: c_int = std.mem.zeroes(c_int),
    data5_io_num: c_int = std.mem.zeroes(c_int),
    data6_io_num: c_int = std.mem.zeroes(c_int),
    data7_io_num: c_int = std.mem.zeroes(c_int),
    max_transfer_sz: c_int = std.mem.zeroes(c_int),
    flags: u32 = std.mem.zeroes(u32),
    isr_cpu_id: esp_intr_cpu_affinity_t = std.mem.zeroes(esp_intr_cpu_affinity_t),
    intr_flags: c_int = std.mem.zeroes(c_int),
};
pub extern fn spi_bus_initialize(host_id: spi_host_device_t, bus_config: [*c]const spi_bus_config_t, dma_chan: spi_dma_chan_t) esp_err_t;
pub extern fn spi_bus_free(host_id: spi_host_device_t) esp_err_t;
const union_unnamed_100 = extern union {
    tx_buffer: ?*const anyopaque,
    tx_data: [4]u8,
};
const union_unnamed_110 = extern union {
    rx_buffer: ?*anyopaque,
    rx_data: [4]u8,
};
pub const spi_transaction_t = extern struct {
    flags: u32 = std.mem.zeroes(u32),
    cmd: u16 = std.mem.zeroes(u16),
    addr: u64 = std.mem.zeroes(u64),
    length: usize = std.mem.zeroes(usize),
    rxlength: usize = std.mem.zeroes(usize),
    user: ?*anyopaque = null,
    unnamed_0: union_unnamed_100 = std.mem.zeroes(union_unnamed_100),
    unnamed_1: union_unnamed_110 = std.mem.zeroes(union_unnamed_110),
};
pub const transaction_cb_t = ?*const fn ([*c]spi_transaction_t) callconv(.C) void;
pub const spi_device_interface_config_t = extern struct {
    command_bits: u8 = std.mem.zeroes(u8),
    address_bits: u8 = std.mem.zeroes(u8),
    dummy_bits: u8 = std.mem.zeroes(u8),
    mode: u8 = std.mem.zeroes(u8),
    clock_source: spi_clock_source_t = std.mem.zeroes(spi_clock_source_t),
    duty_cycle_pos: u16 = std.mem.zeroes(u16),
    cs_ena_pretrans: u16 = std.mem.zeroes(u16),
    cs_ena_posttrans: u8 = std.mem.zeroes(u8),
    clock_speed_hz: c_int = std.mem.zeroes(c_int),
    input_delay_ns: c_int = std.mem.zeroes(c_int),
    spics_io_num: c_int = std.mem.zeroes(c_int),
    flags: u32 = std.mem.zeroes(u32),
    queue_size: c_int = std.mem.zeroes(c_int),
    pre_cb: transaction_cb_t = std.mem.zeroes(transaction_cb_t),
    post_cb: transaction_cb_t = std.mem.zeroes(transaction_cb_t),
};
pub const spi_transaction_ext_t = extern struct {
    base: spi_transaction_t = std.mem.zeroes(spi_transaction_t),
    command_bits: u8 = std.mem.zeroes(u8),
    address_bits: u8 = std.mem.zeroes(u8),
    dummy_bits: u8 = std.mem.zeroes(u8),
};
pub const spi_device_t = opaque {};
pub const spi_device_handle_t = ?*spi_device_t;
pub extern fn spi_bus_add_device(host_id: spi_host_device_t, dev_config: [*c]const spi_device_interface_config_t, handle: [*c]spi_device_handle_t) esp_err_t;
pub extern fn spi_bus_remove_device(handle: spi_device_handle_t) esp_err_t;
pub extern fn spi_device_queue_trans(handle: spi_device_handle_t, trans_desc: [*c]spi_transaction_t, ticks_to_wait: TickType_t) esp_err_t;
pub extern fn spi_device_get_trans_result(handle: spi_device_handle_t, trans_desc: [*c][*c]spi_transaction_t, ticks_to_wait: TickType_t) esp_err_t;
pub extern fn spi_device_transmit(handle: spi_device_handle_t, trans_desc: [*c]spi_transaction_t) esp_err_t;
pub extern fn spi_device_polling_start(handle: spi_device_handle_t, trans_desc: [*c]spi_transaction_t, ticks_to_wait: TickType_t) esp_err_t;
pub extern fn spi_device_polling_end(handle: spi_device_handle_t, ticks_to_wait: TickType_t) esp_err_t;
pub extern fn spi_device_polling_transmit(handle: spi_device_handle_t, trans_desc: [*c]spi_transaction_t) esp_err_t;
pub extern fn spi_device_acquire_bus(device: spi_device_handle_t, wait: TickType_t) esp_err_t;
pub extern fn spi_device_release_bus(dev: spi_device_handle_t) void;
pub extern fn spi_device_get_actual_freq(handle: spi_device_handle_t, freq_khz: [*c]c_int) esp_err_t;
pub extern fn spi_get_actual_clock(fapb: c_int, hz: c_int, duty_cycle: c_int) c_int;
pub extern fn spi_get_timing(gpio_is_used: bool, input_delay_ns: c_int, eff_clk: c_int, dummy_o: [*c]c_int, cycles_remain_o: [*c]c_int) void;
pub extern fn spi_get_freq_limit(gpio_is_used: bool, input_delay_ns: c_int) c_int;
pub extern fn spi_bus_get_max_transaction_len(host_id: spi_host_device_t, max_bytes: [*c]usize) esp_err_t;
pub const sdspi_dev_handle_t = c_int;
pub const sdspi_device_config_t = extern struct {
    host_id: spi_host_device_t = std.mem.zeroes(spi_host_device_t),
    gpio_cs: gpio_num_t = std.mem.zeroes(gpio_num_t),
    gpio_cd: gpio_num_t = std.mem.zeroes(gpio_num_t),
    gpio_wp: gpio_num_t = std.mem.zeroes(gpio_num_t),
    gpio_int: gpio_num_t = std.mem.zeroes(gpio_num_t),
    gpio_wp_polarity: bool = std.mem.zeroes(bool),
};
pub extern fn sdspi_host_init() esp_err_t;
pub extern fn sdspi_host_init_device(dev_config: [*c]const sdspi_device_config_t, out_handle: [*c]sdspi_dev_handle_t) esp_err_t;
pub extern fn sdspi_host_remove_device(handle: sdspi_dev_handle_t) esp_err_t;
pub extern fn sdspi_host_do_transaction(handle: sdspi_dev_handle_t, cmdinfo: [*c]sdmmc_command_t) esp_err_t;
pub extern fn sdspi_host_set_card_clk(host: sdspi_dev_handle_t, freq_khz: u32) esp_err_t;
pub extern fn sdspi_host_get_real_freq(handle: sdspi_dev_handle_t, real_freq_khz: [*c]c_int) esp_err_t;
pub extern fn sdspi_host_deinit() esp_err_t;
pub extern fn sdspi_host_io_int_enable(handle: sdspi_dev_handle_t) esp_err_t;
pub extern fn sdspi_host_io_int_wait(handle: sdspi_dev_handle_t, timeout_ticks: TickType_t) esp_err_t;
pub const temperature_sensor_obj_t = opaque {};
pub const temperature_sensor_handle_t = ?*temperature_sensor_obj_t;
pub const temperature_sensor_clk_src_t = soc_periph_temperature_sensor_clk_src_t;
pub const temperature_sensor_config_t = extern struct {
    range_min: c_int = std.mem.zeroes(c_int),
    range_max: c_int = std.mem.zeroes(c_int),
    clk_src: temperature_sensor_clk_src_t = std.mem.zeroes(temperature_sensor_clk_src_t),
};
pub extern fn temperature_sensor_install(tsens_config: [*c]const temperature_sensor_config_t, ret_tsens: [*c]temperature_sensor_handle_t) esp_err_t;
pub extern fn temperature_sensor_uninstall(tsens: temperature_sensor_handle_t) esp_err_t;
pub extern fn temperature_sensor_enable(tsens: temperature_sensor_handle_t) esp_err_t;
pub extern fn temperature_sensor_disable(tsens: temperature_sensor_handle_t) esp_err_t;
pub extern fn temperature_sensor_get_celsius(tsens: temperature_sensor_handle_t, out_celsius: [*c]f32) esp_err_t;

pub const sdmmc_csd_t = extern struct {
    csd_ver: c_int = std.mem.zeroes(c_int),
    mmc_ver: c_int = std.mem.zeroes(c_int),
    capacity: c_int = std.mem.zeroes(c_int),
    sector_size: c_int = std.mem.zeroes(c_int),
    read_block_len: c_int = std.mem.zeroes(c_int),
    card_command_class: c_int = std.mem.zeroes(c_int),
    tr_speed: c_int = std.mem.zeroes(c_int),
};
pub const sdmmc_cid_t = extern struct {
    mfg_id: c_int = std.mem.zeroes(c_int),
    oem_id: c_int = std.mem.zeroes(c_int),
    name: [8]u8 = std.mem.zeroes([8]u8),
    revision: c_int = std.mem.zeroes(c_int),
    serial: c_int = std.mem.zeroes(c_int),
    date: c_int = std.mem.zeroes(c_int),
}; // /espressif/esp-idf/components/driver/sdmmc/include/driver/sdmmc_types.h:65:14: warning: struct demoted to opaque type - has bitfield
pub const sdmmc_scr_t = opaque {}; // /espressif/esp-idf/components/driver/sdmmc/include/driver/sdmmc_types.h:77:14: warning: struct demoted to opaque type - has bitfield
pub const sdmmc_ssr_t = opaque {};
pub const sdmmc_ext_csd_t = extern struct {
    rev: u8 = std.mem.zeroes(u8),
    power_class: u8 = std.mem.zeroes(u8),
    erase_mem_state: u8 = std.mem.zeroes(u8),
    sec_feature: u8 = std.mem.zeroes(u8),
};
pub const sdmmc_response_t = [4]u32;
pub const sdmmc_switch_func_rsp_t = extern struct {
    data: [16]u32 = std.mem.zeroes([16]u32),
};
pub const sdmmc_command_t = extern struct {
    opcode: u32 = std.mem.zeroes(u32),
    arg: u32 = std.mem.zeroes(u32),
    response: sdmmc_response_t = std.mem.zeroes(sdmmc_response_t),
    data: ?*anyopaque = null,
    datalen: usize = std.mem.zeroes(usize),
    buflen: usize = std.mem.zeroes(usize),
    blklen: usize = std.mem.zeroes(usize),
    flags: c_int = std.mem.zeroes(c_int),
    @"error": esp_err_t = std.mem.zeroes(esp_err_t),
    timeout_ms: u32 = std.mem.zeroes(u32),
};
pub const sdmmc_delay_phase_t = enum(c_uint) {
    SDMMC_DELAY_PHASE_0 = 0,
    SDMMC_DELAY_PHASE_1 = 1,
    SDMMC_DELAY_PHASE_2 = 2,
    SDMMC_DELAY_PHASE_3 = 3,
};
const union_unnamed_94 = extern union {
    deinit: ?*const fn () callconv(.C) esp_err_t,
    deinit_p: ?*const fn (c_int) callconv(.C) esp_err_t,
};
pub const sdmmc_host_t = extern struct {
    flags: u32 = std.mem.zeroes(u32),
    slot: c_int = std.mem.zeroes(c_int),
    max_freq_khz: c_int = std.mem.zeroes(c_int),
    io_voltage: f32 = std.mem.zeroes(f32),
    init: ?*const fn () callconv(.C) esp_err_t = std.mem.zeroes(?*const fn () callconv(.C) esp_err_t),
    set_bus_width: ?*const fn (c_int, usize) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn (c_int, usize) callconv(.C) esp_err_t),
    get_bus_width: ?*const fn (c_int) callconv(.C) usize = std.mem.zeroes(?*const fn (c_int) callconv(.C) usize),
    set_bus_ddr_mode: ?*const fn (c_int, bool) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn (c_int, bool) callconv(.C) esp_err_t),
    set_card_clk: ?*const fn (c_int, u32) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn (c_int, u32) callconv(.C) esp_err_t),
    set_cclk_always_on: ?*const fn (c_int, bool) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn (c_int, bool) callconv(.C) esp_err_t),
    do_transaction: ?*const fn (c_int, [*c]sdmmc_command_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn (c_int, [*c]sdmmc_command_t) callconv(.C) esp_err_t),
    unnamed_0: union_unnamed_94 = std.mem.zeroes(union_unnamed_94),
    io_int_enable: ?*const fn (c_int) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn (c_int) callconv(.C) esp_err_t),
    io_int_wait: ?*const fn (c_int, TickType_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn (c_int, TickType_t) callconv(.C) esp_err_t),
    command_timeout_ms: c_int = std.mem.zeroes(c_int),
    get_real_freq: ?*const fn (c_int, [*c]c_int) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn (c_int, [*c]c_int) callconv(.C) esp_err_t),
    input_delay_phase: sdmmc_delay_phase_t = std.mem.zeroes(sdmmc_delay_phase_t),
    set_input_delay: ?*const fn (c_int, sdmmc_delay_phase_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn (c_int, sdmmc_delay_phase_t) callconv(.C) esp_err_t),
};
pub const esp_phy_wifi_rate_t = enum(c_uint) {
    PHY_RATE_1M = 0,
    PHY_RATE_2M = 1,
    PHY_RATE_5M5 = 2,
    PHY_RATE_11M = 3,
    PHY_RATE_6M = 11,
    PHY_RATE_9M = 15,
    PHY_RATE_12M = 10,
    PHY_RATE_18M = 14,
    PHY_RATE_24M = 9,
    PHY_RATE_36M = 13,
    PHY_RATE_48M = 8,
    PHY_RATE_54M = 12,
    PHY_RATE_MCS0 = 16,
    PHY_RATE_MCS1 = 17,
    PHY_RATE_MCS2 = 18,
    PHY_RATE_MCS3 = 19,
    PHY_RATE_MCS4 = 20,
    PHY_RATE_MCS5 = 21,
    PHY_RATE_MCS6 = 22,
    PHY_RATE_MCS7 = 23,
    PHY_WIFI_RATE_MAX = 24,
};
pub const esp_phy_ble_rate_t = enum(c_uint) {
    PHY_BLE_RATE_1M = 0,
    PHY_BLE_RATE_2M = 1,
    PHY_BLE_RATE_125K = 2,
    PHY_BLE_RATE_500k = 3,
    PHY_BLE_RATE_MAX = 4,
};
pub const esp_phy_ble_type_t = enum(c_uint) {
    PHY_BLE_TYPE_1010 = 0,
    PHY_BLE_TYPE_00001111 = 1,
    PHY_BLE_TYPE_prbs9 = 2,
    PHY_BLE_TYPE_00111100 = 4,
    PHY_BLE_TYPE_MAX = 5,
};
pub const esp_phy_rx_result_t = extern struct {
    phy_rx_correct_count: u32 = std.mem.zeroes(u32),
    phy_rx_rssi: c_int = std.mem.zeroes(c_int),
    phy_rx_total_count: u32 = std.mem.zeroes(u32),
    phy_rx_result_flag: u32 = std.mem.zeroes(u32),
};
pub extern fn esp_wifi_power_domain_on() void;
pub extern fn esp_wifi_power_domain_off() void;
pub extern fn esp_phy_rftest_config(conf: u8) void;
pub extern fn esp_phy_rftest_init() void;
pub extern fn esp_phy_tx_contin_en(contin_en: bool) void;
pub extern fn esp_phy_cbw40m_en(en: bool) void;
pub extern fn esp_phy_wifi_tx(chan: u32, rate: esp_phy_wifi_rate_t, backoff: i8, length_byte: u32, packet_delay: u32, packet_num: u32) void;
pub extern fn esp_phy_test_start_stop(value: u8) void;
pub extern fn esp_phy_wifi_rx(chan: u32, rate: esp_phy_wifi_rate_t) void;
pub extern fn esp_phy_wifi_tx_tone(start: u32, chan: u32, backoff: u32) void;
pub extern fn esp_phy_ble_tx(txpwr: u32, chan: u32, len: u32, data_type: esp_phy_ble_type_t, syncw: u32, rate: esp_phy_ble_rate_t, tx_num_in: u32) void;
pub extern fn esp_phy_ble_rx(chan: u32, syncw: u32, rate: esp_phy_ble_rate_t) void;
pub extern fn esp_phy_bt_tx_tone(start: u32, chan: u32, power: u32) void;
pub extern fn esp_phy_get_rx_result(rx_result: [*c]esp_phy_rx_result_t) void;

pub const i2c_port_t = enum(c_uint) {
    I2C_NUM_0 = 0,
    I2C_NUM_1 = 1,
    I2C_NUM_MAX = 2,
};
pub const i2c_addr_bit_len_t = enum(c_uint) {
    I2C_ADDR_BIT_LEN_7 = 0,
    I2C_ADDR_BIT_LEN_10 = 1,
};
pub const i2c_hal_clk_config_t = extern struct {
    clkm_div: u16 = std.mem.zeroes(u16),
    scl_low: u16 = std.mem.zeroes(u16),
    scl_high: u16 = std.mem.zeroes(u16),
    scl_wait_high: u16 = std.mem.zeroes(u16),
    sda_hold: u16 = std.mem.zeroes(u16),
    sda_sample: u16 = std.mem.zeroes(u16),
    setup: u16 = std.mem.zeroes(u16),
    hold: u16 = std.mem.zeroes(u16),
    tout: u16 = std.mem.zeroes(u16),
};
pub const i2c_mode_t = enum(c_uint) {
    I2C_MODE_SLAVE = 0,
    I2C_MODE_MASTER = 1,
    I2C_MODE_MAX = 2,
};
pub const i2c_rw_t = enum(c_uint) {
    I2C_MASTER_WRITE = 0,
    I2C_MASTER_READ = 1,
};
pub const i2c_trans_mode_t = enum(c_uint) {
    I2C_DATA_MODE_MSB_FIRST = 0,
    I2C_DATA_MODE_LSB_FIRST = 1,
    I2C_DATA_MODE_MAX = 2,
};
pub const i2c_addr_mode_t = enum(c_uint) {
    I2C_ADDR_BIT_7 = 0,
    I2C_ADDR_BIT_10 = 1,
    I2C_ADDR_BIT_MAX = 2,
};
pub const i2c_ack_type_t = enum(c_uint) {
    I2C_MASTER_ACK = 0,
    I2C_MASTER_NACK = 1,
    I2C_MASTER_LAST_NACK = 2,
    I2C_MASTER_ACK_MAX = 3,
};
pub const i2c_slave_stretch_cause_t = enum(c_uint) {
    I2C_SLAVE_STRETCH_CAUSE_ADDRESS_MATCH = 0,
    I2C_SLAVE_STRETCH_CAUSE_TX_EMPTY = 1,
    I2C_SLAVE_STRETCH_CAUSE_RX_FULL = 2,
    I2C_SLAVE_STRETCH_CAUSE_SENDING_ACK = 3,
};
pub const i2c_clock_source_t = soc_periph_i2c_clk_src_t;
pub const i2c_port_num_t = c_int;
pub const i2c_master_status_t = enum(c_uint) {
    I2C_STATUS_READ = 0,
    I2C_STATUS_WRITE = 1,
    I2C_STATUS_START = 2,
    I2C_STATUS_STOP = 3,
    I2C_STATUS_IDLE = 4,
    I2C_STATUS_ACK_ERROR = 5,
    I2C_STATUS_DONE = 6,
    I2C_STATUS_TIMEOUT = 7,
};
pub const i2c_master_event_t = enum(c_uint) {
    I2C_EVENT_ALIVE = 0,
    I2C_EVENT_DONE = 1,
    I2C_EVENT_NACK = 2,
};
pub const i2c_master_bus_t = opaque {};
pub const i2c_master_bus_handle_t = ?*i2c_master_bus_t;
pub const i2c_master_dev_t = opaque {};
pub const i2c_master_dev_handle_t = ?*i2c_master_dev_t;
pub const i2c_slave_dev_t = opaque {};
pub const i2c_slave_dev_handle_t = ?*i2c_slave_dev_t;
pub const i2c_master_event_data_t = extern struct {
    event: i2c_master_event_t = std.mem.zeroes(i2c_master_event_t),
};
pub const i2c_master_callback_t = ?*const fn (i2c_master_dev_handle_t, [*c]const i2c_master_event_data_t, ?*anyopaque) callconv(.C) bool;
pub const i2c_slave_rx_done_event_data_t = extern struct {
    buffer: [*:0]u8 = std.mem.zeroes([*:0]u8),
};
pub const i2c_slave_received_callback_t = ?*const fn (i2c_slave_dev_handle_t, [*c]const i2c_slave_rx_done_event_data_t, ?*anyopaque) callconv(.C) bool;
pub const i2c_master_bus_config_t = extern struct {
    i2c_port: i2c_port_num_t = std.mem.zeroes(i2c_port_num_t),
    sda_io_num: gpio_num_t = std.mem.zeroes(gpio_num_t),
    scl_io_num: gpio_num_t = std.mem.zeroes(gpio_num_t),
    clk_source: i2c_clock_source_t = std.mem.zeroes(i2c_clock_source_t),
    glitch_ignore_cnt: u8 = std.mem.zeroes(u8),
    intr_priority: c_int = std.mem.zeroes(c_int),
    trans_queue_depth: usize = std.mem.zeroes(usize),
    flags: opaque {} = std.mem.zeroes(opaque {}),
};
pub const i2c_device_config_t = extern struct {
    dev_addr_length: i2c_addr_bit_len_t = std.mem.zeroes(i2c_addr_bit_len_t),
    device_address: u16 = std.mem.zeroes(u16),
    scl_speed_hz: u32 = std.mem.zeroes(u32),
};
pub const i2c_master_event_callbacks_t = extern struct {
    on_trans_done: i2c_master_callback_t = std.mem.zeroes(i2c_master_callback_t),
};
pub extern fn i2c_new_master_bus(bus_config: ?*const i2c_master_bus_config_t, ret_bus_handle: [*c]i2c_master_bus_handle_t) esp_err_t;
pub extern fn i2c_master_bus_add_device(bus_handle: i2c_master_bus_handle_t, dev_config: [*c]const i2c_device_config_t, ret_handle: [*c]i2c_master_dev_handle_t) esp_err_t;
pub extern fn i2c_del_master_bus(bus_handle: i2c_master_bus_handle_t) esp_err_t;
pub extern fn i2c_master_bus_rm_device(handle: i2c_master_dev_handle_t) esp_err_t;
pub extern fn i2c_master_transmit(i2c_dev: i2c_master_dev_handle_t, write_buffer: [*:0]const u8, write_size: usize, xfer_timeout_ms: c_int) esp_err_t;
pub extern fn i2c_master_transmit_receive(i2c_dev: i2c_master_dev_handle_t, write_buffer: [*:0]const u8, write_size: usize, read_buffer: [*:0]u8, read_size: usize, xfer_timeout_ms: c_int) esp_err_t;
pub extern fn i2c_master_receive(i2c_dev: i2c_master_dev_handle_t, read_buffer: [*:0]u8, read_size: usize, xfer_timeout_ms: c_int) esp_err_t;
pub extern fn i2c_master_probe(i2c_master: i2c_master_bus_handle_t, address: u16, xfer_timeout_ms: c_int) esp_err_t;
pub extern fn i2c_master_register_event_callbacks(i2c_dev: i2c_master_dev_handle_t, cbs: [*c]const i2c_master_event_callbacks_t, user_data: ?*anyopaque) esp_err_t;
pub extern fn i2c_master_bus_reset(handle: i2c_master_bus_handle_t) esp_err_t;
pub extern fn i2c_master_wait_all_done(i2c_master: i2c_master_bus_handle_t, timeout_ms: c_int) esp_err_t;

// const union_unnamed_5 = extern union {
//     cid: sdmmc_cid_t,
//     raw_cid: sdmmc_response_t,
// };
pub const i2s_slot_mode_t = enum(c_uint) {
    I2S_SLOT_MODE_MONO = 1,
    I2S_SLOT_MODE_STEREO = 2,
};
pub const i2s_dir_t = enum(c_uint) {
    I2S_DIR_RX = 1,
    I2S_DIR_TX = 2,
};
pub const i2s_role_t = enum(c_uint) {
    I2S_ROLE_MASTER = 0,
    I2S_ROLE_SLAVE = 1,
};
pub const i2s_data_bit_width_t = enum(c_uint) {
    I2S_DATA_BIT_WIDTH_8BIT = 8,
    I2S_DATA_BIT_WIDTH_16BIT = 16,
    I2S_DATA_BIT_WIDTH_24BIT = 24,
    I2S_DATA_BIT_WIDTH_32BIT = 32,
};
pub const i2s_slot_bit_width_t = enum(c_uint) {
    I2S_SLOT_BIT_WIDTH_AUTO = 0,
    I2S_SLOT_BIT_WIDTH_8BIT = 8,
    I2S_SLOT_BIT_WIDTH_16BIT = 16,
    I2S_SLOT_BIT_WIDTH_24BIT = 24,
    I2S_SLOT_BIT_WIDTH_32BIT = 32,
};
pub const i2s_clock_src_t = soc_periph_i2s_clk_src_t;
pub const i2s_pcm_compress_t = enum(c_uint) {
    I2S_PCM_DISABLE = 0,
    I2S_PCM_A_DECOMPRESS = 1,
    I2S_PCM_A_COMPRESS = 2,
    I2S_PCM_U_DECOMPRESS = 3,
    I2S_PCM_U_COMPRESS = 4,
};
pub const i2s_pdm_dsr_t = enum(c_uint) {
    I2S_PDM_DSR_8S = 0,
    I2S_PDM_DSR_16S = 1,
    I2S_PDM_DSR_MAX = 2,
};
pub const i2s_pdm_sig_scale_t = enum(c_uint) {
    I2S_PDM_SIG_SCALING_DIV_2 = 0,
    I2S_PDM_SIG_SCALING_MUL_1 = 1,
    I2S_PDM_SIG_SCALING_MUL_2 = 2,
    I2S_PDM_SIG_SCALING_MUL_4 = 3,
};
pub const i2s_pdm_tx_line_mode_t = enum(c_uint) {
    I2S_PDM_TX_ONE_LINE_CODEC = 0,
    I2S_PDM_TX_ONE_LINE_DAC = 1,
    I2S_PDM_TX_TWO_LINE_DAC = 2,
};
pub const i2s_std_slot_mask_t = enum(c_uint) {
    I2S_STD_SLOT_LEFT = 1,
    I2S_STD_SLOT_RIGHT = 2,
    I2S_STD_SLOT_BOTH = 3,
};
pub const i2s_pdm_slot_mask_t = enum(c_uint) {
    I2S_PDM_SLOT_RIGHT = 1,
    I2S_PDM_SLOT_LEFT = 2,
    I2S_PDM_SLOT_BOTH = 3,
    I2S_PDM_RX_LINE0_SLOT_RIGHT = 1,
    I2S_PDM_RX_LINE0_SLOT_LEFT = 2,
    I2S_PDM_RX_LINE1_SLOT_RIGHT = 4,
    I2S_PDM_RX_LINE1_SLOT_LEFT = 8,
    I2S_PDM_RX_LINE2_SLOT_RIGHT = 16,
    I2S_PDM_RX_LINE2_SLOT_LEFT = 32,
    I2S_PDM_RX_LINE3_SLOT_RIGHT = 64,
    I2S_PDM_RX_LINE3_SLOT_LEFT = 128,
    I2S_PDM_LINE_SLOT_ALL = 255,
};
pub const i2s_tdm_slot_mask_t = enum(c_uint) {
    I2S_TDM_SLOT0 = 1,
    I2S_TDM_SLOT1 = 2,
    I2S_TDM_SLOT2 = 4,
    I2S_TDM_SLOT3 = 8,
    I2S_TDM_SLOT4 = 16,
    I2S_TDM_SLOT5 = 32,
    I2S_TDM_SLOT6 = 64,
    I2S_TDM_SLOT7 = 128,
    I2S_TDM_SLOT8 = 256,
    I2S_TDM_SLOT9 = 512,
    I2S_TDM_SLOT10 = 1024,
    I2S_TDM_SLOT11 = 2048,
    I2S_TDM_SLOT12 = 4096,
    I2S_TDM_SLOT13 = 8192,
    I2S_TDM_SLOT14 = 16384,
    I2S_TDM_SLOT15 = 32768,
};
pub const i2s_port_t = enum(c_uint) {
    I2S_NUM_0 = 0,
    I2S_NUM_1 = 1,
    I2S_NUM_AUTO = 2,
};
pub const i2s_comm_mode_t = enum(c_uint) {
    I2S_COMM_MODE_STD = 0,
    I2S_COMM_MODE_PDM = 1,
    I2S_COMM_MODE_TDM = 2,
    I2S_COMM_MODE_NONE = 3,
};
pub const i2s_mclk_multiple_t = enum(c_uint) {
    I2S_MCLK_MULTIPLE_128 = 128,
    I2S_MCLK_MULTIPLE_256 = 256,
    I2S_MCLK_MULTIPLE_384 = 384,
    I2S_MCLK_MULTIPLE_512 = 512,
};
pub const i2s_event_data_t = extern struct {
    data: ?*anyopaque = null,
    size: usize = std.mem.zeroes(usize),
};
pub const i2s_channel_obj_t = opaque {};
pub const i2s_chan_handle_t = ?*i2s_channel_obj_t;
pub const i2s_isr_callback_t = ?*const fn (i2s_chan_handle_t, [*c]i2s_event_data_t, ?*anyopaque) callconv(.C) bool;
pub const i2s_event_callbacks_t = extern struct {
    on_recv: i2s_isr_callback_t = std.mem.zeroes(i2s_isr_callback_t),
    on_recv_q_ovf: i2s_isr_callback_t = std.mem.zeroes(i2s_isr_callback_t),
    on_sent: i2s_isr_callback_t = std.mem.zeroes(i2s_isr_callback_t),
    on_send_q_ovf: i2s_isr_callback_t = std.mem.zeroes(i2s_isr_callback_t),
};
pub const i2s_chan_config_t = extern struct {
    id: i2s_port_t = std.mem.zeroes(i2s_port_t),
    role: i2s_role_t = std.mem.zeroes(i2s_role_t),
    dma_desc_num: u32 = std.mem.zeroes(u32),
    dma_frame_num: u32 = std.mem.zeroes(u32),
    auto_clear: bool = std.mem.zeroes(bool),
    intr_priority: c_int = std.mem.zeroes(c_int),
};
pub const i2s_chan_info_t = extern struct {
    id: i2s_port_t = std.mem.zeroes(i2s_port_t),
    role: i2s_role_t = std.mem.zeroes(i2s_role_t),
    dir: i2s_dir_t = std.mem.zeroes(i2s_dir_t),
    mode: i2s_comm_mode_t = std.mem.zeroes(i2s_comm_mode_t),
    pair_chan: i2s_chan_handle_t = std.mem.zeroes(i2s_chan_handle_t),
};
pub extern fn i2s_new_channel(chan_cfg: [*c]const i2s_chan_config_t, ret_tx_handle: [*c]i2s_chan_handle_t, ret_rx_handle: [*c]i2s_chan_handle_t) esp_err_t;
pub extern fn i2s_del_channel(handle: i2s_chan_handle_t) esp_err_t;
pub extern fn i2s_channel_get_info(handle: i2s_chan_handle_t, chan_info: [*c]i2s_chan_info_t) esp_err_t;
pub extern fn i2s_channel_enable(handle: i2s_chan_handle_t) esp_err_t;
pub extern fn i2s_channel_disable(handle: i2s_chan_handle_t) esp_err_t;
pub extern fn i2s_channel_preload_data(tx_handle: i2s_chan_handle_t, src: ?*const anyopaque, size: usize, bytes_loaded: [*c]usize) esp_err_t;
pub extern fn i2s_channel_write(handle: i2s_chan_handle_t, src: ?*const anyopaque, size: usize, bytes_written: [*c]usize, timeout_ms: u32) esp_err_t;
pub extern fn i2s_channel_read(handle: i2s_chan_handle_t, dest: ?*anyopaque, size: usize, bytes_read: [*c]usize, timeout_ms: u32) esp_err_t;
pub extern fn i2s_channel_register_event_callback(handle: i2s_chan_handle_t, callbacks: [*c]const i2s_event_callbacks_t, user_data: ?*anyopaque) esp_err_t;
pub const i2s_pdm_rx_slot_config_t = extern struct {
    data_bit_width: i2s_data_bit_width_t = std.mem.zeroes(i2s_data_bit_width_t),
    slot_bit_width: i2s_slot_bit_width_t = std.mem.zeroes(i2s_slot_bit_width_t),
    slot_mode: i2s_slot_mode_t = std.mem.zeroes(i2s_slot_mode_t),
    slot_mask: i2s_pdm_slot_mask_t = std.mem.zeroes(i2s_pdm_slot_mask_t),
};
pub const i2s_pdm_rx_clk_config_t = extern struct {
    sample_rate_hz: u32 = std.mem.zeroes(u32),
    clk_src: i2s_clock_src_t = std.mem.zeroes(i2s_clock_src_t),
    mclk_multiple: i2s_mclk_multiple_t = std.mem.zeroes(i2s_mclk_multiple_t),
    dn_sample_mode: i2s_pdm_dsr_t = std.mem.zeroes(i2s_pdm_dsr_t),
    bclk_div: u32 = std.mem.zeroes(u32),
};
const union_unnamed_92 = extern union {
    din: gpio_num_t,
    dins: [4]gpio_num_t,
};
// /espressif/esp-idf/components/driver/i2s/include/driver/i2s_pdm.h:116:20: warning: struct demoted to opaque type - has bitfield
const unnamed_93 = opaque {};
pub const i2s_pdm_rx_gpio_config_t = extern struct {
    clk: gpio_num_t = std.mem.zeroes(gpio_num_t),
    unnamed_0: union_unnamed_92 = std.mem.zeroes(union_unnamed_92),
    invert_flags: unnamed_93 = std.mem.zeroes(unnamed_93),
};
pub const i2s_pdm_rx_config_t = extern struct {
    clk_cfg: i2s_pdm_rx_clk_config_t = std.mem.zeroes(i2s_pdm_rx_clk_config_t),
    slot_cfg: i2s_pdm_rx_slot_config_t = std.mem.zeroes(i2s_pdm_rx_slot_config_t),
    gpio_cfg: i2s_pdm_rx_gpio_config_t = std.mem.zeroes(i2s_pdm_rx_gpio_config_t),
};
pub extern fn i2s_channel_init_pdm_rx_mode(handle: i2s_chan_handle_t, pdm_rx_cfg: ?*const i2s_pdm_rx_config_t) esp_err_t;
pub extern fn i2s_channel_reconfig_pdm_rx_clock(handle: i2s_chan_handle_t, clk_cfg: [*c]const i2s_pdm_rx_clk_config_t) esp_err_t;
pub extern fn i2s_channel_reconfig_pdm_rx_slot(handle: i2s_chan_handle_t, slot_cfg: [*c]const i2s_pdm_rx_slot_config_t) esp_err_t;
pub extern fn i2s_channel_reconfig_pdm_rx_gpio(handle: i2s_chan_handle_t, gpio_cfg: ?*const i2s_pdm_rx_gpio_config_t) esp_err_t;
pub const i2s_pdm_tx_slot_config_t = extern struct {
    data_bit_width: i2s_data_bit_width_t = std.mem.zeroes(i2s_data_bit_width_t),
    slot_bit_width: i2s_slot_bit_width_t = std.mem.zeroes(i2s_slot_bit_width_t),
    slot_mode: i2s_slot_mode_t = std.mem.zeroes(i2s_slot_mode_t),
    sd_prescale: u32 = std.mem.zeroes(u32),
    sd_scale: i2s_pdm_sig_scale_t = std.mem.zeroes(i2s_pdm_sig_scale_t),
    hp_scale: i2s_pdm_sig_scale_t = std.mem.zeroes(i2s_pdm_sig_scale_t),
    lp_scale: i2s_pdm_sig_scale_t = std.mem.zeroes(i2s_pdm_sig_scale_t),
    sinc_scale: i2s_pdm_sig_scale_t = std.mem.zeroes(i2s_pdm_sig_scale_t),
    line_mode: i2s_pdm_tx_line_mode_t = std.mem.zeroes(i2s_pdm_tx_line_mode_t),
    hp_en: bool = std.mem.zeroes(bool),
    hp_cut_off_freq_hz: f32 = std.mem.zeroes(f32),
    sd_dither: u32 = std.mem.zeroes(u32),
    sd_dither2: u32 = std.mem.zeroes(u32),
};
pub const i2s_pdm_tx_clk_config_t = extern struct {
    sample_rate_hz: u32 = std.mem.zeroes(u32),
    clk_src: i2s_clock_src_t = std.mem.zeroes(i2s_clock_src_t),
    mclk_multiple: i2s_mclk_multiple_t = std.mem.zeroes(i2s_mclk_multiple_t),
    up_sample_fp: u32 = std.mem.zeroes(u32),
    up_sample_fs: u32 = std.mem.zeroes(u32),
    bclk_div: u32 = std.mem.zeroes(u32),
};
// /esp-idf/components/driver/i2s/include/driver/i2s_pdm.h:371:20: warning: struct demoted to opaque type - has bitfield
const unnamed_14 = opaque {};
pub const i2s_pdm_tx_gpio_config_t = extern struct {
    clk: gpio_num_t = std.mem.zeroes(gpio_num_t),
    dout: gpio_num_t = std.mem.zeroes(gpio_num_t),
    dout2: gpio_num_t = std.mem.zeroes(gpio_num_t),
    invert_flags: unnamed_14 = std.mem.zeroes(unnamed_14),
};
pub const i2s_pdm_tx_config_t = extern struct {
    clk_cfg: i2s_pdm_tx_clk_config_t = std.mem.zeroes(i2s_pdm_tx_clk_config_t),
    slot_cfg: i2s_pdm_tx_slot_config_t = std.mem.zeroes(i2s_pdm_tx_slot_config_t),
    gpio_cfg: i2s_pdm_tx_gpio_config_t = std.mem.zeroes(i2s_pdm_tx_gpio_config_t),
};
pub extern fn i2s_channel_init_pdm_tx_mode(handle: i2s_chan_handle_t, pdm_tx_cfg: ?*const i2s_pdm_tx_config_t) esp_err_t;
pub extern fn i2s_channel_reconfig_pdm_tx_clock(handle: i2s_chan_handle_t, clk_cfg: [*c]const i2s_pdm_tx_clk_config_t) esp_err_t;
pub extern fn i2s_channel_reconfig_pdm_tx_slot(handle: i2s_chan_handle_t, slot_cfg: [*c]const i2s_pdm_tx_slot_config_t) esp_err_t;
pub extern fn i2s_channel_reconfig_pdm_tx_gpio(handle: i2s_chan_handle_t, gpio_cfg: ?*const i2s_pdm_tx_gpio_config_t) esp_err_t;
pub extern fn sdmmc_card_init(host: [*c]const sdmmc_host_t, out_card: ?*sdmmc_card_t) esp_err_t;
pub extern fn sdmmc_card_print_info(stream: ?*std.c.FILE, card: ?*const sdmmc_card_t) void;
pub extern fn sdmmc_get_status(card: ?*sdmmc_card_t) esp_err_t;
pub extern fn sdmmc_write_sectors(card: ?*sdmmc_card_t, src: ?*const anyopaque, start_sector: usize, sector_count: usize) esp_err_t;
pub extern fn sdmmc_read_sectors(card: ?*sdmmc_card_t, dst: ?*anyopaque, start_sector: usize, sector_count: usize) esp_err_t;
pub extern fn sdmmc_erase_sectors(card: ?*sdmmc_card_t, start_sector: usize, sector_count: usize, arg: sdmmc_erase_arg_t) esp_err_t;
pub extern fn sdmmc_can_discard(card: ?*sdmmc_card_t) esp_err_t;
pub extern fn sdmmc_can_trim(card: ?*sdmmc_card_t) esp_err_t;
pub extern fn sdmmc_mmc_can_sanitize(card: ?*sdmmc_card_t) esp_err_t;
pub extern fn sdmmc_mmc_sanitize(card: ?*sdmmc_card_t, timeout_ms: u32) esp_err_t;
pub extern fn sdmmc_full_erase(card: ?*sdmmc_card_t) esp_err_t;
pub extern fn sdmmc_io_read_byte(card: ?*sdmmc_card_t, function: u32, reg: u32, out_byte: [*:0]u8) esp_err_t;
pub extern fn sdmmc_io_write_byte(card: ?*sdmmc_card_t, function: u32, reg: u32, in_byte: u8, out_byte: [*:0]u8) esp_err_t;
pub extern fn sdmmc_io_read_bytes(card: ?*sdmmc_card_t, function: u32, addr: u32, dst: ?*anyopaque, size: usize) esp_err_t;
pub extern fn sdmmc_io_write_bytes(card: ?*sdmmc_card_t, function: u32, addr: u32, src: ?*const anyopaque, size: usize) esp_err_t;
pub extern fn sdmmc_io_read_blocks(card: ?*sdmmc_card_t, function: u32, addr: u32, dst: ?*anyopaque, size: usize) esp_err_t;
pub extern fn sdmmc_io_write_blocks(card: ?*sdmmc_card_t, function: u32, addr: u32, src: ?*const anyopaque, size: usize) esp_err_t;
pub extern fn sdmmc_io_enable_int(card: ?*sdmmc_card_t) esp_err_t;
pub extern fn sdmmc_io_wait_int(card: ?*sdmmc_card_t, timeout_ticks: TickType_t) esp_err_t;
pub extern fn sdmmc_io_get_cis_data(card: ?*sdmmc_card_t, out_buffer: [*:0]u8, buffer_size: usize, inout_cis_size: [*c]usize) esp_err_t;
pub extern fn sdmmc_io_print_cis_info(buffer: [*:0]u8, buffer_size: usize, fp: ?*std.c.FILE) esp_err_t;
pub const sdmmc_card_t = opaque {};
pub const wl_handle_t = i32;
pub extern fn wl_mount(partition: [*c]const esp_partition_t, out_handle: [*c]wl_handle_t) esp_err_t;
pub extern fn wl_unmount(handle: wl_handle_t) esp_err_t;
pub extern fn wl_erase_range(handle: wl_handle_t, start_addr: usize, size: usize) esp_err_t;
pub extern fn wl_write(handle: wl_handle_t, dest_addr: usize, src: ?*const anyopaque, size: usize) esp_err_t;
pub extern fn wl_read(handle: wl_handle_t, src_addr: usize, dest: ?*anyopaque, size: usize) esp_err_t;
pub extern fn wl_size(handle: wl_handle_t) usize;
pub extern fn wl_sector_size(handle: wl_handle_t) usize;
pub extern fn esp_vfs_fat_register(base_path: [*:0]const u8, fat_drive: [*:0]const u8, max_files: usize, out_fs: [*c][*c]FATFS) esp_err_t;
pub extern fn esp_vfs_fat_unregister_path(base_path: [*:0]const u8) esp_err_t;
pub const esp_vfs_fat_mount_config_t = extern struct {
    format_if_mount_failed: bool = std.mem.zeroes(bool),
    max_files: c_int = std.mem.zeroes(c_int),
    allocation_unit_size: usize = std.mem.zeroes(usize),
    disk_status_check_enable: bool = std.mem.zeroes(bool),
};
pub const PARTITION = extern struct {
    pd: u8 = std.mem.zeroes(u8),
    pt: u8 = std.mem.zeroes(u8),
};
pub const VolToPart: [*c]const PARTITION = @extern([*c]const PARTITION, .{
    .name = "VolToPart",
});
pub const FATFS = extern struct {
    fs_type: u8 = std.mem.zeroes(u8),
    pdrv: u8 = std.mem.zeroes(u8),
    ldrv: u8 = std.mem.zeroes(u8),
    n_fats: u8 = std.mem.zeroes(u8),
    wflag: u8 = std.mem.zeroes(u8),
    fsi_flag: u8 = std.mem.zeroes(u8),
    id: u16 = std.mem.zeroes(u16),
    n_rootdir: u16 = std.mem.zeroes(u16),
    csize: u16 = std.mem.zeroes(u16),
    ssize: u16 = std.mem.zeroes(u16),
    last_clst: u32 = std.mem.zeroes(u32),
    free_clst: u32 = std.mem.zeroes(u32),
    n_fatent: u32 = std.mem.zeroes(u32),
    fsize: u32 = std.mem.zeroes(u32),
    volbase: u32 = std.mem.zeroes(u32),
    fatbase: u32 = std.mem.zeroes(u32),
    dirbase: u32 = std.mem.zeroes(u32),
    database: u32 = std.mem.zeroes(u32),
    winsect: u32 = std.mem.zeroes(u32),
    win: [4096]u8 = std.mem.zeroes([4096]u8),
};
pub const FFOBJID = extern struct {
    fs: [*c]FATFS = std.mem.zeroes([*c]FATFS),
    id: u16 = std.mem.zeroes(u16),
    attr: u8 = std.mem.zeroes(u8),
    stat: u8 = std.mem.zeroes(u8),
    sclust: u32 = std.mem.zeroes(u32),
    objsize: u32 = std.mem.zeroes(u32),
};
pub const FIL = extern struct {
    obj: FFOBJID = std.mem.zeroes(FFOBJID),
    flag: u8 = std.mem.zeroes(u8),
    err: u8 = std.mem.zeroes(u8),
    fptr: u32 = std.mem.zeroes(u32),
    clust: u32 = std.mem.zeroes(u32),
    sect: u32 = std.mem.zeroes(u32),
    dir_sect: u32 = std.mem.zeroes(u32),
    dir_ptr: [*:0]u8 = std.mem.zeroes([*:0]u8),
    buf: [4096]u8 = std.mem.zeroes([4096]u8),
};
pub const FF_DIR = extern struct {
    obj: FFOBJID = std.mem.zeroes(FFOBJID),
    dptr: u32 = std.mem.zeroes(u32),
    clust: u32 = std.mem.zeroes(u32),
    sect: u32 = std.mem.zeroes(u32),
    dir: [*:0]u8 = std.mem.zeroes([*:0]u8),
    @"fn": [12]u8 = std.mem.zeroes([12]u8),
};
pub const FILINFO = extern struct {
    fsize: u32 = std.mem.zeroes(u32),
    fdate: u16 = std.mem.zeroes(u16),
    ftime: u16 = std.mem.zeroes(u16),
    fattrib: u8 = std.mem.zeroes(u8),
    fname: [13]u8 = std.mem.zeroes([13]u8),
};
pub const MKFS_PARM = extern struct {
    fmt: u8 = std.mem.zeroes(u8),
    n_fat: u8 = std.mem.zeroes(u8),
    @"align": c_uint = std.mem.zeroes(c_uint),
    n_root: c_uint = std.mem.zeroes(c_uint),
    au_size: u32 = std.mem.zeroes(u32),
};
pub const esp_vfs_fat_sdmmc_mount_config_t = esp_vfs_fat_mount_config_t;
pub extern fn esp_vfs_fat_sdmmc_mount(base_path: [*:0]const u8, host_config: [*c]const sdmmc_host_t, slot_config: ?*const anyopaque, mount_config: [*c]const esp_vfs_fat_mount_config_t, out_card: [*c]?*sdmmc_card_t) esp_err_t;
pub extern fn esp_vfs_fat_sdspi_mount(base_path: [*:0]const u8, host_config_input: [*c]const sdmmc_host_t, slot_config: [*c]const sdspi_device_config_t, mount_config: [*c]const esp_vfs_fat_mount_config_t, out_card: [*c]?*sdmmc_card_t) esp_err_t;
pub extern fn esp_vfs_fat_sdmmc_unmount() esp_err_t;
pub extern fn esp_vfs_fat_sdcard_unmount(base_path: [*:0]const u8, card: ?*sdmmc_card_t) esp_err_t;
pub extern fn esp_vfs_fat_sdcard_format(base_path: [*:0]const u8, card: ?*sdmmc_card_t) esp_err_t;
pub extern fn esp_vfs_fat_spiflash_mount_rw_wl(base_path: [*:0]const u8, partition_label: [*:0]const u8, mount_config: [*c]const esp_vfs_fat_mount_config_t, wl_handle: [*c]wl_handle_t) esp_err_t;
pub extern fn esp_vfs_fat_spiflash_unmount_rw_wl(base_path: [*:0]const u8, wl_handle: wl_handle_t) esp_err_t;
pub extern fn esp_vfs_fat_spiflash_format_rw_wl(base_path: [*:0]const u8, partition_label: [*:0]const u8) esp_err_t;
pub extern fn esp_vfs_fat_spiflash_mount_ro(base_path: [*:0]const u8, partition_label: [*:0]const u8, mount_config: [*c]const esp_vfs_fat_mount_config_t) esp_err_t;
pub extern fn esp_vfs_fat_spiflash_unmount_ro(base_path: [*:0]const u8, partition_label: [*:0]const u8) esp_err_t;
pub extern fn esp_vfs_fat_info(base_path: [*:0]const u8, out_total_bytes: [*c]u64, out_free_bytes: [*c]u64) esp_err_t;
pub extern fn esp_vfs_fat_spiflash_mount(base_path: [*:0]const u8, partition_label: [*:0]const u8, mount_config: [*c]const esp_vfs_fat_mount_config_t, wl_handle: [*c]wl_handle_t) esp_err_t;
pub extern fn esp_vfs_fat_spiflash_unmount(base_path: [*:0]const u8, wl_handle: wl_handle_t) esp_err_t;
pub extern fn esp_vfs_fat_rawflash_mount(base_path: [*:0]const u8, partition_label: [*:0]const u8, mount_config: [*c]const esp_vfs_fat_mount_config_t) esp_err_t;
pub extern fn esp_vfs_fat_rawflash_unmount(base_path: [*:0]const u8, partition_label: [*:0]const u8) esp_err_t;

pub extern const ESP_HTTP_SERVER_EVENT: esp_event_base_t;
pub const esp_http_server_event_id_t = enum(c_uint) {
    HTTP_SERVER_EVENT_ERROR = 0,
    HTTP_SERVER_EVENT_START = 1,
    HTTP_SERVER_EVENT_ON_CONNECTED = 2,
    HTTP_SERVER_EVENT_ON_HEADER = 3,
    HTTP_SERVER_EVENT_HEADERS_SENT = 4,
    HTTP_SERVER_EVENT_ON_DATA = 5,
    HTTP_SERVER_EVENT_SENT_DATA = 6,
    HTTP_SERVER_EVENT_DISCONNECTED = 7,
    HTTP_SERVER_EVENT_STOP = 8,
};
pub const esp_http_server_event_data = extern struct {
    fd: c_int = std.mem.zeroes(c_int),
    data_len: c_int = std.mem.zeroes(c_int),
};
pub const httpd_handle_t = ?*anyopaque;
pub const httpd_method_t = http_method;
pub const httpd_free_ctx_fn_t = ?*const fn (?*anyopaque) callconv(.C) void;
pub const httpd_open_func_t = ?*const fn (httpd_handle_t, c_int) callconv(.C) esp_err_t;
pub const httpd_close_func_t = ?*const fn (httpd_handle_t, c_int) callconv(.C) void;
pub const httpd_uri_match_func_t = ?*const fn ([*:0]const u8, [*:0]const u8, usize) callconv(.C) bool;
pub const httpd_config_t = extern struct {
    task_priority: c_uint = std.mem.zeroes(c_uint),
    stack_size: usize = std.mem.zeroes(usize),
    core_id: BaseType_t = std.mem.zeroes(BaseType_t),
    server_port: u16 = std.mem.zeroes(u16),
    ctrl_port: u16 = std.mem.zeroes(u16),
    max_open_sockets: u16 = std.mem.zeroes(u16),
    max_uri_handlers: u16 = std.mem.zeroes(u16),
    max_resp_headers: u16 = std.mem.zeroes(u16),
    backlog_conn: u16 = std.mem.zeroes(u16),
    lru_purge_enable: bool = std.mem.zeroes(bool),
    recv_wait_timeout: u16 = std.mem.zeroes(u16),
    send_wait_timeout: u16 = std.mem.zeroes(u16),
    global_user_ctx: ?*anyopaque = null,
    global_user_ctx_free_fn: httpd_free_ctx_fn_t = std.mem.zeroes(httpd_free_ctx_fn_t),
    global_transport_ctx: ?*anyopaque = null,
    global_transport_ctx_free_fn: httpd_free_ctx_fn_t = std.mem.zeroes(httpd_free_ctx_fn_t),
    enable_so_linger: bool = std.mem.zeroes(bool),
    linger_timeout: c_int = std.mem.zeroes(c_int),
    keep_alive_enable: bool = std.mem.zeroes(bool),
    keep_alive_idle: c_int = std.mem.zeroes(c_int),
    keep_alive_interval: c_int = std.mem.zeroes(c_int),
    keep_alive_count: c_int = std.mem.zeroes(c_int),
    open_fn: httpd_open_func_t = std.mem.zeroes(httpd_open_func_t),
    close_fn: httpd_close_func_t = std.mem.zeroes(httpd_close_func_t),
    uri_match_fn: httpd_uri_match_func_t = std.mem.zeroes(httpd_uri_match_func_t),
};
pub extern fn httpd_start(handle: [*c]httpd_handle_t, config: [*c]const httpd_config_t) esp_err_t;
pub extern fn httpd_stop(handle: httpd_handle_t) esp_err_t;
pub const httpd_req_t = extern struct {
    handle: httpd_handle_t = std.mem.zeroes(httpd_handle_t),
    method: c_int = std.mem.zeroes(c_int),
    uri: [513]u8 = std.mem.zeroes([513]u8),
    content_len: usize = std.mem.zeroes(usize),
    aux: ?*anyopaque = null,
    user_ctx: ?*anyopaque = null,
    sess_ctx: ?*anyopaque = null,
    free_ctx: httpd_free_ctx_fn_t = std.mem.zeroes(httpd_free_ctx_fn_t),
    ignore_sess_ctx_changes: bool = std.mem.zeroes(bool),
};
pub const httpd_uri_t = extern struct {
    uri: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    method: httpd_method_t = std.mem.zeroes(httpd_method_t),
    handler: ?*const fn ([*c]httpd_req_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]httpd_req_t) callconv(.C) esp_err_t),
    user_ctx: ?*anyopaque = null,
};
pub extern fn httpd_register_uri_handler(handle: httpd_handle_t, uri_handler: [*c]const httpd_uri_t) esp_err_t;
pub extern fn httpd_unregister_uri_handler(handle: httpd_handle_t, uri: [*:0]const u8, method: httpd_method_t) esp_err_t;
pub extern fn httpd_unregister_uri(handle: httpd_handle_t, uri: [*:0]const u8) esp_err_t;
pub const httpd_err_code_t = enum(c_uint) {
    HTTPD_500_INTERNAL_SERVER_ERROR = 0,
    HTTPD_501_METHOD_NOT_IMPLEMENTED = 1,
    HTTPD_505_VERSION_NOT_SUPPORTED = 2,
    HTTPD_400_BAD_REQUEST = 3,
    HTTPD_401_UNAUTHORIZED = 4,
    HTTPD_403_FORBIDDEN = 5,
    HTTPD_404_NOT_FOUND = 6,
    HTTPD_405_METHOD_NOT_ALLOWED = 7,
    HTTPD_408_REQ_TIMEOUT = 8,
    HTTPD_411_LENGTH_REQUIRED = 9,
    HTTPD_414_URI_TOO_LONG = 10,
    HTTPD_431_REQ_HDR_FIELDS_TOO_LARGE = 11,
    HTTPD_ERR_CODE_MAX = 12,
};
pub const httpd_err_handler_func_t = ?*const fn ([*c]httpd_req_t, httpd_err_code_t) callconv(.C) esp_err_t;
pub extern fn httpd_register_err_handler(handle: httpd_handle_t, @"error": httpd_err_code_t, handler_fn: httpd_err_handler_func_t) esp_err_t;
pub const httpd_send_func_t = ?*const fn (httpd_handle_t, c_int, [*:0]const u8, usize, c_int) callconv(.C) c_int;
pub const httpd_recv_func_t = ?*const fn (httpd_handle_t, c_int, [*:0]u8, usize, c_int) callconv(.C) c_int;
pub const httpd_pending_func_t = ?*const fn (httpd_handle_t, c_int) callconv(.C) c_int;
pub extern fn httpd_sess_set_recv_override(hd: httpd_handle_t, sockfd: c_int, recv_func: httpd_recv_func_t) esp_err_t;
pub extern fn httpd_sess_set_send_override(hd: httpd_handle_t, sockfd: c_int, send_func: httpd_send_func_t) esp_err_t;
pub extern fn httpd_sess_set_pending_override(hd: httpd_handle_t, sockfd: c_int, pending_func: httpd_pending_func_t) esp_err_t;
pub extern fn httpd_req_async_handler_begin(r: [*c]httpd_req_t, out: [*c][*c]httpd_req_t) esp_err_t;
pub extern fn httpd_req_async_handler_complete(r: [*c]httpd_req_t) esp_err_t;
pub extern fn httpd_req_to_sockfd(r: [*c]httpd_req_t) c_int;
pub extern fn httpd_req_recv(r: [*c]httpd_req_t, buf: [*:0]u8, buf_len: usize) c_int;
pub extern fn httpd_req_get_hdr_value_len(r: [*c]httpd_req_t, field: [*:0]const u8) usize;
pub extern fn httpd_req_get_hdr_value_str(r: [*c]httpd_req_t, field: [*:0]const u8, val: [*:0]u8, val_size: usize) esp_err_t;
pub extern fn httpd_req_get_url_query_len(r: [*c]httpd_req_t) usize;
pub extern fn httpd_req_get_url_query_str(r: [*c]httpd_req_t, buf: [*:0]u8, buf_len: usize) esp_err_t;
pub extern fn httpd_query_key_value(qry: [*:0]const u8, key: [*:0]const u8, val: [*:0]u8, val_size: usize) esp_err_t;
pub extern fn httpd_req_get_cookie_val(req: [*c]httpd_req_t, cookie_name: [*:0]const u8, val: [*:0]u8, val_size: [*c]usize) esp_err_t;
pub extern fn httpd_uri_match_wildcard(uri_template: [*:0]const u8, uri_to_match: [*:0]const u8, match_upto: usize) bool;
pub extern fn httpd_resp_send(r: [*c]httpd_req_t, buf: [*:0]const u8, buf_len: isize) esp_err_t;
pub extern fn httpd_resp_send_chunk(r: [*c]httpd_req_t, buf: [*:0]const u8, buf_len: isize) esp_err_t;
pub fn httpd_resp_sendstr(r: [*c]httpd_req_t, str: [*:0]const u8) callconv(.C) esp_err_t {
    return httpd_resp_send(r, str, std.mem.len(str));
}
pub fn httpd_resp_sendstr_chunk(r: [*c]httpd_req_t, str: [*:0]const u8) callconv(.C) esp_err_t {
    return httpd_resp_send_chunk(r, str, std.mem.len(str));
}
pub extern fn httpd_resp_set_status(r: [*c]httpd_req_t, status: [*:0]const u8) esp_err_t;
pub extern fn httpd_resp_set_type(r: [*c]httpd_req_t, @"type": [*:0]const u8) esp_err_t;
pub extern fn httpd_resp_set_hdr(r: [*c]httpd_req_t, field: [*:0]const u8, value: [*:0]const u8) esp_err_t;
pub extern fn httpd_resp_send_err(req: [*c]httpd_req_t, @"error": httpd_err_code_t, msg: [*:0]const u8) esp_err_t;
pub fn httpd_resp_send_404(r: [*c]httpd_req_t) callconv(.C) esp_err_t {
    return httpd_resp_send_err(r, .HTTPD_404_NOT_FOUND, "Error: 404 Not Found");
}
pub fn httpd_resp_send_408(r: [*c]httpd_req_t) callconv(.C) esp_err_t {
    return httpd_resp_send_err(r, .HTTPD_408_REQ_TIMEOUT, "Error: 408 Request Timeout");
}
pub fn httpd_resp_send_500(r: [*c]httpd_req_t) callconv(.C) esp_err_t {
    return httpd_resp_send_err(r, .HTTPD_500_INTERNAL_SERVER_ERROR, "Error: 500 Internal Server");
}
pub extern fn httpd_send(r: [*c]httpd_req_t, buf: [*:0]const u8, buf_len: usize) c_int;
pub extern fn httpd_socket_send(hd: httpd_handle_t, sockfd: c_int, buf: [*:0]const u8, buf_len: usize, flags: c_int) c_int;
pub extern fn httpd_socket_recv(hd: httpd_handle_t, sockfd: c_int, buf: [*:0]u8, buf_len: usize, flags: c_int) c_int;
pub extern fn httpd_sess_get_ctx(handle: httpd_handle_t, sockfd: c_int) ?*anyopaque;
pub extern fn httpd_sess_set_ctx(handle: httpd_handle_t, sockfd: c_int, ctx: ?*anyopaque, free_fn: httpd_free_ctx_fn_t) void;
pub extern fn httpd_sess_get_transport_ctx(handle: httpd_handle_t, sockfd: c_int) ?*anyopaque;
pub extern fn httpd_sess_set_transport_ctx(handle: httpd_handle_t, sockfd: c_int, ctx: ?*anyopaque, free_fn: httpd_free_ctx_fn_t) void;
pub extern fn httpd_get_global_user_ctx(handle: httpd_handle_t) ?*anyopaque;
pub extern fn httpd_get_global_transport_ctx(handle: httpd_handle_t) ?*anyopaque;
pub extern fn httpd_sess_trigger_close(handle: httpd_handle_t, sockfd: c_int) esp_err_t;
pub extern fn httpd_sess_update_lru_counter(handle: httpd_handle_t, sockfd: c_int) esp_err_t;
pub extern fn httpd_get_client_list(handle: httpd_handle_t, fds: [*c]usize, client_fds: [*c]c_int) esp_err_t;
pub const httpd_work_fn_t = ?*const fn (?*anyopaque) callconv(.C) void;
pub extern fn httpd_queue_work(handle: httpd_handle_t, work: httpd_work_fn_t, arg: ?*anyopaque) esp_err_t;

pub const esp_http_client_on_data = extern struct {
    client: esp_http_client_handle_t = std.mem.zeroes(esp_http_client_handle_t),
    data_process: i64 = std.mem.zeroes(i64),
};
pub const esp_http_client_redirect_event_data = extern struct {
    client: esp_http_client_handle_t = std.mem.zeroes(esp_http_client_handle_t),
    status_code: c_int = std.mem.zeroes(c_int),
};
pub const esp_http_client_event_id_t = enum(c_uint) {
    HTTP_EVENT_ERROR = 0,
    HTTP_EVENT_ON_CONNECTED = 1,
    HTTP_EVENT_HEADERS_SENT = 2,
    HTTP_EVENT_HEADER_SENT = 2,
    HTTP_EVENT_ON_HEADER = 3,
    HTTP_EVENT_ON_DATA = 4,
    HTTP_EVENT_ON_FINISH = 5,
    HTTP_EVENT_DISCONNECTED = 6,
    HTTP_EVENT_REDIRECT = 7,
};
pub const esp_http_client_handle_t = ?*anyopaque;
pub const esp_http_client_event_t = extern struct {
    event_id: esp_http_client_event_id_t = std.mem.zeroes(esp_http_client_event_id_t),
    client: esp_http_client_handle_t = std.mem.zeroes(esp_http_client_handle_t),
    data: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    data_len: c_int = std.mem.zeroes(c_int),
    user_data: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    header_key: [*c]u8 = std.mem.zeroes([*c]u8),
    header_value: [*c]u8 = std.mem.zeroes([*c]u8),
};
pub const esp_http_client_proto_ver_t = enum(c_uint) {
    ESP_HTTP_CLIENT_TLS_VER_ANY = 0,
    ESP_HTTP_CLIENT_TLS_VER_TLS_1_2 = 1,
    ESP_HTTP_CLIENT_TLS_VER_TLS_1_3 = 2,
    ESP_HTTP_CLIENT_TLS_VER_MAX = 3,
};
pub const http_event_handle_cb = ?*const fn ([*c]esp_http_client_event_t) callconv(.C) esp_err_t;
pub const esp_http_client_method_t = enum(c_uint) {
    HTTP_METHOD_GET = 0,
    HTTP_METHOD_POST = 1,
    HTTP_METHOD_PUT = 2,
    HTTP_METHOD_PATCH = 3,
    HTTP_METHOD_DELETE = 4,
    HTTP_METHOD_HEAD = 5,
    HTTP_METHOD_NOTIFY = 6,
    HTTP_METHOD_SUBSCRIBE = 7,
    HTTP_METHOD_UNSUBSCRIBE = 8,
    HTTP_METHOD_OPTIONS = 9,
    HTTP_METHOD_COPY = 10,
    HTTP_METHOD_MOVE = 11,
    HTTP_METHOD_LOCK = 12,
    HTTP_METHOD_UNLOCK = 13,
    HTTP_METHOD_PROPFIND = 14,
    HTTP_METHOD_PROPPATCH = 15,
    HTTP_METHOD_MKCOL = 16,
    HTTP_METHOD_MAX = 17,
};
pub const esp_http_client_auth_type_t = enum(c_uint) {
    HTTP_AUTH_TYPE_NONE = 0,
    HTTP_AUTH_TYPE_BASIC = 1,
    HTTP_AUTH_TYPE_DIGEST = 2,
};
pub const esp_http_client_transport_t = enum(c_uint) {
    HTTP_TRANSPORT_UNKNOWN = 0,
    HTTP_TRANSPORT_OVER_TCP = 1,
    HTTP_TRANSPORT_OVER_SSL = 2,
};
pub const esp_http_client_config_t = extern struct {
    url: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    host: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    port: c_int = std.mem.zeroes(c_int),
    username: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    password: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    auth_type: esp_http_client_auth_type_t = std.mem.zeroes(esp_http_client_auth_type_t),
    path: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    query: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    cert_pem: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    cert_len: usize = std.mem.zeroes(usize),
    client_cert_pem: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    client_cert_len: usize = std.mem.zeroes(usize),
    client_key_pem: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    client_key_len: usize = std.mem.zeroes(usize),
    client_key_password: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    client_key_password_len: usize = std.mem.zeroes(usize),
    tls_version: esp_http_client_proto_ver_t = std.mem.zeroes(esp_http_client_proto_ver_t),
    user_agent: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    method: esp_http_client_method_t = std.mem.zeroes(esp_http_client_method_t),
    timeout_ms: c_int = std.mem.zeroes(c_int),
    disable_auto_redirect: bool = std.mem.zeroes(bool),
    max_redirection_count: c_int = std.mem.zeroes(c_int),
    max_authorization_retries: c_int = std.mem.zeroes(c_int),
    event_handler: http_event_handle_cb = std.mem.zeroes(http_event_handle_cb),
    transport_type: esp_http_client_transport_t = std.mem.zeroes(esp_http_client_transport_t),
    buffer_size: c_int = std.mem.zeroes(c_int),
    buffer_size_tx: c_int = std.mem.zeroes(c_int),
    user_data: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    is_async: bool = std.mem.zeroes(bool),
    use_global_ca_store: bool = std.mem.zeroes(bool),
    skip_cert_common_name_check: bool = std.mem.zeroes(bool),
    common_name: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    crt_bundle_attach: ?*const fn (?*anyopaque) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn (?*anyopaque) callconv(.C) esp_err_t),
    keep_alive_enable: bool = std.mem.zeroes(bool),
    keep_alive_idle: c_int = std.mem.zeroes(c_int),
    keep_alive_interval: c_int = std.mem.zeroes(c_int),
    keep_alive_count: c_int = std.mem.zeroes(c_int),
    if_name: [*c]ifreq = std.mem.zeroes([*c]ifreq),
};
pub const ifreq = extern struct {
    ifr_name: [6]u8 = std.mem.zeroes([6]u8),
};
pub const HttpStatus_Code = enum(c_uint) {
    HttpStatus_Ok = 200,
    HttpStatus_MultipleChoices = 300,
    HttpStatus_MovedPermanently = 301,
    HttpStatus_Found = 302,
    HttpStatus_SeeOther = 303,
    HttpStatus_TemporaryRedirect = 307,
    HttpStatus_PermanentRedirect = 308,
    HttpStatus_BadRequest = 400,
    HttpStatus_Unauthorized = 401,
    HttpStatus_Forbidden = 403,
    HttpStatus_NotFound = 404,
    HttpStatus_InternalError = 500,
};
pub extern fn esp_http_client_init(config: [*c]const esp_http_client_config_t) esp_http_client_handle_t;
pub extern fn esp_http_client_perform(client: esp_http_client_handle_t) esp_err_t;
pub extern fn esp_http_client_cancel_request(client: esp_http_client_handle_t) esp_err_t;
pub extern fn esp_http_client_set_url(client: esp_http_client_handle_t, url: [*:0]const u8) esp_err_t;
pub extern fn esp_http_client_set_post_field(client: esp_http_client_handle_t, data: [*:0]const u8, len: c_int) esp_err_t;
pub extern fn esp_http_client_get_post_field(client: esp_http_client_handle_t, data: [*c][*c]u8) c_int;
pub extern fn esp_http_client_set_header(client: esp_http_client_handle_t, key: [*:0]const u8, value: [*:0]const u8) esp_err_t;
pub extern fn esp_http_client_get_header(client: esp_http_client_handle_t, key: [*:0]const u8, value: [*c][*c]u8) esp_err_t;
pub extern fn esp_http_client_get_username(client: esp_http_client_handle_t, value: [*c][*c]u8) esp_err_t;
pub extern fn esp_http_client_set_username(client: esp_http_client_handle_t, username: [*:0]const u8) esp_err_t;
pub extern fn esp_http_client_get_password(client: esp_http_client_handle_t, value: [*c][*c]u8) esp_err_t;
pub extern fn esp_http_client_set_password(client: esp_http_client_handle_t, password: [*:0]const u8) esp_err_t;
pub extern fn esp_http_client_set_authtype(client: esp_http_client_handle_t, auth_type: esp_http_client_auth_type_t) esp_err_t;
pub extern fn esp_http_client_get_user_data(client: esp_http_client_handle_t, data: [*c]?*anyopaque) esp_err_t;
pub extern fn esp_http_client_set_user_data(client: esp_http_client_handle_t, data: ?*anyopaque) esp_err_t;
pub extern fn esp_http_client_get_errno(client: esp_http_client_handle_t) c_int;
pub extern fn esp_http_client_set_method(client: esp_http_client_handle_t, method: esp_http_client_method_t) esp_err_t;
pub extern fn esp_http_client_set_timeout_ms(client: esp_http_client_handle_t, timeout_ms: c_int) esp_err_t;
pub extern fn esp_http_client_delete_header(client: esp_http_client_handle_t, key: [*:0]const u8) esp_err_t;
pub extern fn esp_http_client_open(client: esp_http_client_handle_t, write_len: c_int) esp_err_t;
pub extern fn esp_http_client_write(client: esp_http_client_handle_t, buffer: [*:0]const u8, len: c_int) c_int;
pub extern fn esp_http_client_fetch_headers(client: esp_http_client_handle_t) i64;
pub extern fn esp_http_client_is_chunked_response(client: esp_http_client_handle_t) bool;
pub extern fn esp_http_client_read(client: esp_http_client_handle_t, buffer: [*:0]u8, len: c_int) c_int;
pub extern fn esp_http_client_get_status_code(client: esp_http_client_handle_t) c_int;
pub extern fn esp_http_client_get_content_length(client: esp_http_client_handle_t) i64;
pub extern fn esp_http_client_close(client: esp_http_client_handle_t) esp_err_t;
pub extern fn esp_http_client_cleanup(client: esp_http_client_handle_t) esp_err_t;
pub extern fn esp_http_client_get_transport_type(client: esp_http_client_handle_t) esp_http_client_transport_t;
pub extern fn esp_http_client_set_redirection(client: esp_http_client_handle_t) esp_err_t;
pub extern fn esp_http_client_reset_redirect_counter(client: esp_http_client_handle_t) esp_err_t;
pub extern fn esp_http_client_set_auth_data(client: esp_http_client_handle_t, auth_data: [*:0]const u8, len: c_int) esp_err_t;
pub extern fn esp_http_client_add_auth(client: esp_http_client_handle_t) void;
pub extern fn esp_http_client_is_complete_data_received(client: esp_http_client_handle_t) bool;
pub extern fn esp_http_client_read_response(client: esp_http_client_handle_t, buffer: [*:0]u8, len: c_int) c_int;
pub extern fn esp_http_client_flush_response(client: esp_http_client_handle_t, len: [*c]c_int) esp_err_t;
pub extern fn esp_http_client_get_url(client: esp_http_client_handle_t, url: [*:0]u8, len: c_int) esp_err_t;
pub extern fn esp_http_client_get_chunk_length(client: esp_http_client_handle_t, len: [*c]c_int) esp_err_t;
pub const eth_data_interface_t = enum(c_uint) {
    EMAC_DATA_INTERFACE_RMII = 0,
    EMAC_DATA_INTERFACE_MII = 1,
};
pub const eth_link_t = enum(c_uint) {
    ETH_LINK_UP = 0,
    ETH_LINK_DOWN = 1,
};
pub const eth_speed_t = enum(c_uint) {
    ETH_SPEED_10M = 0,
    ETH_SPEED_100M = 1,
    ETH_SPEED_MAX = 2,
};
pub const eth_duplex_t = enum(c_uint) {
    ETH_DUPLEX_HALF = 0,
    ETH_DUPLEX_FULL = 1,
};
pub const eth_checksum_t = enum(c_uint) {
    ETH_CHECKSUM_SW = 0,
    ETH_CHECKSUM_HW = 1,
};
pub const eth_mac_dma_burst_len_t = enum(c_uint) {
    ETH_DMA_BURST_LEN_32 = 0,
    ETH_DMA_BURST_LEN_16 = 1,
    ETH_DMA_BURST_LEN_8 = 2,
    ETH_DMA_BURST_LEN_4 = 3,
    ETH_DMA_BURST_LEN_2 = 4,
    ETH_DMA_BURST_LEN_1 = 5,
};
pub const esp_eth_state_t = enum(c_uint) {
    ETH_STATE_LLINIT = 0,
    ETH_STATE_DEINIT = 1,
    ETH_STATE_LINK = 2,
    ETH_STATE_SPEED = 3,
    ETH_STATE_DUPLEX = 4,
    ETH_STATE_PAUSE = 5,
};
pub const esp_eth_mediator_t = extern struct {
    phy_reg_read: ?*const fn ([*c]esp_eth_mediator_t, u32, u32, [*c]u32) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mediator_t, u32, u32, [*c]u32) callconv(.C) esp_err_t),
    phy_reg_write: ?*const fn ([*c]esp_eth_mediator_t, u32, u32, u32) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mediator_t, u32, u32, u32) callconv(.C) esp_err_t),
    stack_input: ?*const fn ([*c]esp_eth_mediator_t, [*:0]u8, u32) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mediator_t, [*:0]u8, u32) callconv(.C) esp_err_t),
    on_state_changed: ?*const fn ([*c]esp_eth_mediator_t, esp_eth_state_t, ?*anyopaque) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mediator_t, esp_eth_state_t, ?*anyopaque) callconv(.C) esp_err_t),
};
pub const eth_event_t = enum(c_uint) {
    ETHERNET_EVENT_START = 0,
    ETHERNET_EVENT_STOP = 1,
    ETHERNET_EVENT_CONNECTED = 2,
    ETHERNET_EVENT_DISCONNECTED = 3,
};
pub extern const ETH_EVENT: esp_event_base_t;
pub const esp_eth_mac_t = extern struct {
    set_mediator: ?*const fn ([*c]esp_eth_mac_t, [*c]esp_eth_mediator_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mac_t, [*c]esp_eth_mediator_t) callconv(.C) esp_err_t),
    init: ?*const fn ([*c]esp_eth_mac_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mac_t) callconv(.C) esp_err_t),
    deinit: ?*const fn ([*c]esp_eth_mac_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mac_t) callconv(.C) esp_err_t),
    start: ?*const fn ([*c]esp_eth_mac_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mac_t) callconv(.C) esp_err_t),
    stop: ?*const fn ([*c]esp_eth_mac_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mac_t) callconv(.C) esp_err_t),
    transmit: ?*const fn ([*c]esp_eth_mac_t, [*:0]u8, u32) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mac_t, [*:0]u8, u32) callconv(.C) esp_err_t),
    transmit_vargs: ?*const fn ([*c]esp_eth_mac_t, u32, va_list) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mac_t, u32, va_list) callconv(.C) esp_err_t),
    receive: ?*const fn ([*c]esp_eth_mac_t, [*:0]u8, [*c]u32) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mac_t, [*:0]u8, [*c]u32) callconv(.C) esp_err_t),
    read_phy_reg: ?*const fn ([*c]esp_eth_mac_t, u32, u32, [*c]u32) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mac_t, u32, u32, [*c]u32) callconv(.C) esp_err_t),
    write_phy_reg: ?*const fn ([*c]esp_eth_mac_t, u32, u32, u32) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mac_t, u32, u32, u32) callconv(.C) esp_err_t),
    set_addr: ?*const fn ([*c]esp_eth_mac_t, [*:0]u8) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mac_t, [*:0]u8) callconv(.C) esp_err_t),
    get_addr: ?*const fn ([*c]esp_eth_mac_t, [*:0]u8) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mac_t, [*:0]u8) callconv(.C) esp_err_t),
    set_speed: ?*const fn ([*c]esp_eth_mac_t, eth_speed_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mac_t, eth_speed_t) callconv(.C) esp_err_t),
    set_duplex: ?*const fn ([*c]esp_eth_mac_t, eth_duplex_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mac_t, eth_duplex_t) callconv(.C) esp_err_t),
    set_link: ?*const fn ([*c]esp_eth_mac_t, eth_link_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mac_t, eth_link_t) callconv(.C) esp_err_t),
    set_promiscuous: ?*const fn ([*c]esp_eth_mac_t, bool) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mac_t, bool) callconv(.C) esp_err_t),
    enable_flow_ctrl: ?*const fn ([*c]esp_eth_mac_t, bool) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mac_t, bool) callconv(.C) esp_err_t),
    set_peer_pause_ability: ?*const fn ([*c]esp_eth_mac_t, u32) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mac_t, u32) callconv(.C) esp_err_t),
    custom_ioctl: ?*const fn ([*c]esp_eth_mac_t, u32, ?*anyopaque) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mac_t, u32, ?*anyopaque) callconv(.C) esp_err_t),
    del: ?*const fn ([*c]esp_eth_mac_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_mac_t) callconv(.C) esp_err_t),
};
pub const emac_rmii_clock_mode_t = enum(c_uint) {
    EMAC_CLK_DEFAULT = 0,
    EMAC_CLK_EXT_IN = 1,
    EMAC_CLK_OUT = 2,
};
pub const emac_rmii_clock_gpio_t = enum(c_uint) {
    EMAC_CLK_IN_GPIO = 0,
    EMAC_APPL_CLK_OUT_GPIO = 0,
    EMAC_CLK_OUT_GPIO = 16,
    EMAC_CLK_OUT_180_GPIO = 17,
};
const struct_unnamed_11 = extern struct {};
const struct_unnamed_12 = extern struct {
    clock_mode: emac_rmii_clock_mode_t = std.mem.zeroes(emac_rmii_clock_mode_t),
    clock_gpio: emac_rmii_clock_gpio_t = std.mem.zeroes(emac_rmii_clock_gpio_t),
};
pub const eth_mac_clock_config_t = extern union {
    mii: struct_unnamed_11,
    rmii: struct_unnamed_12,
};
pub const eth_mac_config_t = extern struct {
    sw_reset_timeout_ms: u32 = std.mem.zeroes(u32),
    rx_task_stack_size: u32 = std.mem.zeroes(u32),
    rx_task_prio: u32 = std.mem.zeroes(u32),
    flags: u32 = std.mem.zeroes(u32),
};
pub const eth_spi_custom_driver_config_t = extern struct {
    config: ?*anyopaque = null,
    init: ?*const fn (?*const anyopaque) callconv(.C) ?*anyopaque = std.mem.zeroes(?*const fn (?*const anyopaque) callconv(.C) ?*anyopaque),
    deinit: ?*const fn (?*anyopaque) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn (?*anyopaque) callconv(.C) esp_err_t),
    read: ?*const fn (?*anyopaque, u32, u32, ?*anyopaque, u32) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn (?*anyopaque, u32, u32, ?*anyopaque, u32) callconv(.C) esp_err_t),
    write: ?*const fn (?*anyopaque, u32, u32, ?*const anyopaque, u32) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn (?*anyopaque, u32, u32, ?*const anyopaque, u32) callconv(.C) esp_err_t),
};
pub const eth_phy_autoneg_cmd_t = enum(c_uint) {
    ESP_ETH_PHY_AUTONEGO_RESTART = 0,
    ESP_ETH_PHY_AUTONEGO_EN = 1,
    ESP_ETH_PHY_AUTONEGO_DIS = 2,
    ESP_ETH_PHY_AUTONEGO_G_STAT = 3,
};
pub const esp_eth_phy_t = extern struct {
    set_mediator: ?*const fn ([*c]esp_eth_phy_t, [*c]esp_eth_mediator_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_phy_t, [*c]esp_eth_mediator_t) callconv(.C) esp_err_t),
    reset: ?*const fn ([*c]esp_eth_phy_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_phy_t) callconv(.C) esp_err_t),
    reset_hw: ?*const fn ([*c]esp_eth_phy_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_phy_t) callconv(.C) esp_err_t),
    init: ?*const fn ([*c]esp_eth_phy_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_phy_t) callconv(.C) esp_err_t),
    deinit: ?*const fn ([*c]esp_eth_phy_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_phy_t) callconv(.C) esp_err_t),
    autonego_ctrl: ?*const fn ([*c]esp_eth_phy_t, eth_phy_autoneg_cmd_t, [*c]bool) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_phy_t, eth_phy_autoneg_cmd_t, [*c]bool) callconv(.C) esp_err_t),
    get_link: ?*const fn ([*c]esp_eth_phy_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_phy_t) callconv(.C) esp_err_t),
    pwrctl: ?*const fn ([*c]esp_eth_phy_t, bool) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_phy_t, bool) callconv(.C) esp_err_t),
    set_addr: ?*const fn ([*c]esp_eth_phy_t, u32) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_phy_t, u32) callconv(.C) esp_err_t),
    get_addr: ?*const fn ([*c]esp_eth_phy_t, [*c]u32) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_phy_t, [*c]u32) callconv(.C) esp_err_t),
    advertise_pause_ability: ?*const fn ([*c]esp_eth_phy_t, u32) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_phy_t, u32) callconv(.C) esp_err_t),
    loopback: ?*const fn ([*c]esp_eth_phy_t, bool) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_phy_t, bool) callconv(.C) esp_err_t),
    set_speed: ?*const fn ([*c]esp_eth_phy_t, eth_speed_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_phy_t, eth_speed_t) callconv(.C) esp_err_t),
    set_duplex: ?*const fn ([*c]esp_eth_phy_t, eth_duplex_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_phy_t, eth_duplex_t) callconv(.C) esp_err_t),
    custom_ioctl: ?*const fn ([*c]esp_eth_phy_t, u32, ?*anyopaque) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_phy_t, u32, ?*anyopaque) callconv(.C) esp_err_t),
    del: ?*const fn ([*c]esp_eth_phy_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn ([*c]esp_eth_phy_t) callconv(.C) esp_err_t),
};
pub const eth_phy_config_t = extern struct {
    phy_addr: i32 = std.mem.zeroes(i32),
    reset_timeout_ms: u32 = std.mem.zeroes(u32),
    autonego_timeout_ms: u32 = std.mem.zeroes(u32),
    reset_gpio_num: c_int = std.mem.zeroes(c_int),
};
pub extern fn esp_eth_phy_new_ip101(config: [*c]const eth_phy_config_t) [*c]esp_eth_phy_t;
pub extern fn esp_eth_phy_new_rtl8201(config: [*c]const eth_phy_config_t) [*c]esp_eth_phy_t;
pub extern fn esp_eth_phy_new_lan87xx(config: [*c]const eth_phy_config_t) [*c]esp_eth_phy_t;
pub extern fn esp_eth_phy_new_dp83848(config: [*c]const eth_phy_config_t) [*c]esp_eth_phy_t;
pub extern fn esp_eth_phy_new_ksz80xx(config: [*c]const eth_phy_config_t) [*c]esp_eth_phy_t;
pub const esp_eth_handle_t = ?*anyopaque;
pub const esp_eth_config_t = extern struct {
    mac: [*c]esp_eth_mac_t = std.mem.zeroes([*c]esp_eth_mac_t),
    phy: [*c]esp_eth_phy_t = std.mem.zeroes([*c]esp_eth_phy_t),
    check_link_period_ms: u32 = std.mem.zeroes(u32),
    stack_input: ?*const fn (esp_eth_handle_t, [*:0]u8, u32, ?*anyopaque) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn (esp_eth_handle_t, [*:0]u8, u32, ?*anyopaque) callconv(.C) esp_err_t),
    on_lowlevel_init_done: ?*const fn (esp_eth_handle_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn (esp_eth_handle_t) callconv(.C) esp_err_t),
    on_lowlevel_deinit_done: ?*const fn (esp_eth_handle_t) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn (esp_eth_handle_t) callconv(.C) esp_err_t),
    read_phy_reg: ?*const fn (esp_eth_handle_t, u32, u32, [*c]u32) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn (esp_eth_handle_t, u32, u32, [*c]u32) callconv(.C) esp_err_t),
    write_phy_reg: ?*const fn (esp_eth_handle_t, u32, u32, u32) callconv(.C) esp_err_t = std.mem.zeroes(?*const fn (esp_eth_handle_t, u32, u32, u32) callconv(.C) esp_err_t),
};
pub const esp_eth_io_cmd_t = enum(c_uint) {
    ETH_CMD_G_MAC_ADDR = 0,
    ETH_CMD_S_MAC_ADDR = 1,
    ETH_CMD_G_PHY_ADDR = 2,
    ETH_CMD_S_PHY_ADDR = 3,
    ETH_CMD_G_AUTONEGO = 4,
    ETH_CMD_S_AUTONEGO = 5,
    ETH_CMD_G_SPEED = 6,
    ETH_CMD_S_SPEED = 7,
    ETH_CMD_S_PROMISCUOUS = 8,
    ETH_CMD_S_FLOW_CTRL = 9,
    ETH_CMD_G_DUPLEX_MODE = 10,
    ETH_CMD_S_DUPLEX_MODE = 11,
    ETH_CMD_S_PHY_LOOPBACK = 12,
    ETH_CMD_CUSTOM_MAC_CMDS = 4095,
    ETH_CMD_CUSTOM_PHY_CMDS = 8191,
};
pub extern fn esp_eth_driver_install(config: [*c]const esp_eth_config_t, out_hdl: [*c]esp_eth_handle_t) esp_err_t;
pub extern fn esp_eth_driver_uninstall(hdl: esp_eth_handle_t) esp_err_t;
pub extern fn esp_eth_start(hdl: esp_eth_handle_t) esp_err_t;
pub extern fn esp_eth_stop(hdl: esp_eth_handle_t) esp_err_t;
pub extern fn esp_eth_update_input_path(hdl: esp_eth_handle_t, stack_input: ?*const fn (esp_eth_handle_t, [*:0]u8, u32, ?*anyopaque) callconv(.C) esp_err_t, priv: ?*anyopaque) esp_err_t;
pub extern fn esp_eth_transmit(hdl: esp_eth_handle_t, buf: ?*anyopaque, length: usize) esp_err_t;
pub extern fn esp_eth_transmit_vargs(hdl: esp_eth_handle_t, argc: u32, ...) esp_err_t;
pub extern fn esp_eth_ioctl(hdl: esp_eth_handle_t, cmd: esp_eth_io_cmd_t, data: ?*anyopaque) esp_err_t;
pub extern fn esp_eth_increase_reference(hdl: esp_eth_handle_t) esp_err_t;
pub extern fn esp_eth_decrease_reference(hdl: esp_eth_handle_t) esp_err_t;
pub const esp_eth_netif_glue_t = opaque {};
pub const esp_eth_netif_glue_handle_t = ?*esp_eth_netif_glue_t;
pub extern fn esp_eth_new_netif_glue(eth_hdl: esp_eth_handle_t) esp_eth_netif_glue_handle_t;
pub extern fn esp_eth_del_netif_glue(eth_netif_glue: esp_eth_netif_glue_handle_t) esp_err_t;
pub extern fn esp_crypto_sha1(input: [*:0]const u8, ilen: usize, output: [*:0]u8) c_int;
pub extern fn esp_crypto_base64_encode(dst: [*:0]u8, dlen: usize, olen: [*c]usize, src: [*:0]const u8, slen: usize) c_int;
// /espressif/esp-idf/components/http_parser/http_parser.h:224:16: warning: struct demoted to opaque type - has bitfield
pub const http_parser = opaque {};
pub const http_cb = ?*const fn (?*http_parser) callconv(.C) c_int;
pub const http_data_cb = ?*const fn (?*http_parser, [*:0]const u8, usize) callconv(.C) c_int;
pub const http_parser_settings = extern struct {
    on_message_begin: http_cb = std.mem.zeroes(http_cb),
    on_url: http_data_cb = std.mem.zeroes(http_data_cb),
    on_status: http_data_cb = std.mem.zeroes(http_data_cb),
    on_header_field: http_data_cb = std.mem.zeroes(http_data_cb),
    on_header_value: http_data_cb = std.mem.zeroes(http_data_cb),
    on_headers_complete: http_cb = std.mem.zeroes(http_cb),
    on_body: http_data_cb = std.mem.zeroes(http_data_cb),
    on_message_complete: http_cb = std.mem.zeroes(http_cb),
    on_chunk_header: http_cb = std.mem.zeroes(http_cb),
    on_chunk_complete: http_cb = std.mem.zeroes(http_cb),
};
pub const http_method = enum(c_uint) {
    HTTP_DELETE = 0,
    HTTP_GET = 1,
    HTTP_HEAD = 2,
    HTTP_POST = 3,
    HTTP_PUT = 4,
    HTTP_CONNECT = 5,
    HTTP_OPTIONS = 6,
    HTTP_TRACE = 7,
    HTTP_COPY = 8,
    HTTP_LOCK = 9,
    HTTP_MKCOL = 10,
    HTTP_MOVE = 11,
    HTTP_PROPFIND = 12,
    HTTP_PROPPATCH = 13,
    HTTP_SEARCH = 14,
    HTTP_UNLOCK = 15,
    HTTP_BIND = 16,
    HTTP_REBIND = 17,
    HTTP_UNBIND = 18,
    HTTP_ACL = 19,
    HTTP_REPORT = 20,
    HTTP_MKACTIVITY = 21,
    HTTP_CHECKOUT = 22,
    HTTP_MERGE = 23,
    HTTP_MSEARCH = 24,
    HTTP_NOTIFY = 25,
    HTTP_SUBSCRIBE = 26,
    HTTP_UNSUBSCRIBE = 27,
    HTTP_PATCH = 28,
    HTTP_PURGE = 29,
    HTTP_MKCALENDAR = 30,
    HTTP_LINK = 31,
    HTTP_UNLINK = 32,
};
pub const http_parser_type = enum(c_uint) {
    HTTP_REQUEST = 0,
    HTTP_RESPONSE = 1,
    HTTP_BOTH = 2,
};
pub const flags = enum(c_uint) {
    F_CHUNKED = 1,
    F_CONNECTION_KEEP_ALIVE = 2,
    F_CONNECTION_CLOSE = 4,
    F_CONNECTION_UPGRADE = 8,
    F_TRAILING = 16,
    F_UPGRADE = 32,
    F_SKIPBODY = 64,
    F_CONTENTLENGTH = 128,
};
pub const http_errno = enum(c_uint) {
    HPE_OK = 0,
    HPE_CB_message_begin = 1,
    HPE_CB_url = 2,
    HPE_CB_header_field = 3,
    HPE_CB_header_value = 4,
    HPE_CB_headers_complete = 5,
    HPE_CB_body = 6,
    HPE_CB_message_complete = 7,
    HPE_CB_status = 8,
    HPE_CB_chunk_header = 9,
    HPE_CB_chunk_complete = 10,
    HPE_INVALID_EOF_STATE = 11,
    HPE_HEADER_OVERFLOW = 12,
    HPE_CLOSED_CONNECTION = 13,
    HPE_INVALID_VERSION = 14,
    HPE_INVALID_STATUS = 15,
    HPE_INVALID_METHOD = 16,
    HPE_INVALID_URL = 17,
    HPE_INVALID_HOST = 18,
    HPE_INVALID_PORT = 19,
    HPE_INVALID_PATH = 20,
    HPE_INVALID_QUERY_STRING = 21,
    HPE_INVALID_FRAGMENT = 22,
    HPE_LF_EXPECTED = 23,
    HPE_INVALID_HEADER_TOKEN = 24,
    HPE_INVALID_CONTENT_LENGTH = 25,
    HPE_UNEXPECTED_CONTENT_LENGTH = 26,
    HPE_INVALID_CHUNK_SIZE = 27,
    HPE_INVALID_CONSTANT = 28,
    HPE_INVALID_INTERNAL_STATE = 29,
    HPE_STRICT = 30,
    HPE_PAUSED = 31,
    HPE_UNKNOWN = 32,
};
pub const http_parser_url_fields = enum(c_uint) {
    UF_SCHEMA = 0,
    UF_HOST = 1,
    UF_PORT = 2,
    UF_PATH = 3,
    UF_QUERY = 4,
    UF_FRAGMENT = 5,
    UF_USERINFO = 6,
    UF_MAX = 7,
};
const struct_unnamed_4 = extern struct {
    off: u16 = std.mem.zeroes(u16),
    len: u16 = std.mem.zeroes(u16),
};
pub const http_parser_url = extern struct {
    field_set: u16 = std.mem.zeroes(u16),
    port: u16 = std.mem.zeroes(u16),
    field_data: [7]struct_unnamed_4 = std.mem.zeroes([7]struct_unnamed_4),
};
pub extern fn http_parser_version() c_ulong;
pub extern fn http_parser_init(parser: ?*http_parser, @"type": http_parser_type) void;
pub extern fn http_parser_settings_init(settings: [*c]http_parser_settings) void;
pub extern fn http_parser_execute(parser: ?*http_parser, settings: [*c]const http_parser_settings, data: [*:0]const u8, len: usize) usize;
pub extern fn http_should_keep_alive(parser: ?*const http_parser) c_int;
pub extern fn http_method_str(m: http_method) [*:0]const u8;
pub extern fn http_errno_name(err: http_errno) [*:0]const u8;
pub extern fn http_errno_description(err: http_errno) [*:0]const u8;
pub extern fn http_parser_url_init(u: [*c]http_parser_url) void;
pub extern fn http_parser_parse_url(buf: [*:0]const u8, buflen: usize, is_connect: c_int, u: [*c]http_parser_url) c_int;
pub extern fn http_parser_pause(parser: ?*http_parser, paused: c_int) void;
pub extern fn http_body_is_final(parser: ?*const http_parser) c_int;

pub const esp_now_send_status_t = enum(c_uint) {
    ESP_NOW_SEND_SUCCESS = 0,
    ESP_NOW_SEND_FAIL = 1,
};
pub const esp_now_peer_info = extern struct {
    peer_addr: [6]u8 = std.mem.zeroes([6]u8),
    lmk: [16]u8 = std.mem.zeroes([16]u8),
    channel: u8 = std.mem.zeroes(u8),
    ifidx: wifi_interface_t = std.mem.zeroes(wifi_interface_t),
    encrypt: bool = std.mem.zeroes(bool),
    priv: ?*anyopaque = null,
};
pub const esp_now_peer_info_t = esp_now_peer_info;
pub const esp_now_peer_num = extern struct {
    total_num: c_int = std.mem.zeroes(c_int),
    encrypt_num: c_int = std.mem.zeroes(c_int),
};
pub const esp_now_peer_num_t = esp_now_peer_num;
pub const esp_now_recv_info = extern struct {
    src_addr: [*:0]u8 = std.mem.zeroes([*:0]u8),
    des_addr: [*:0]u8 = std.mem.zeroes([*:0]u8),
    rx_ctrl: ?*wifi_pkt_rx_ctrl_t = std.mem.zeroes(?*wifi_pkt_rx_ctrl_t),
};
pub const esp_now_recv_info_t = esp_now_recv_info;
pub const esp_now_rate_config = extern struct {
    phymode: wifi_phy_mode_t = std.mem.zeroes(wifi_phy_mode_t),
    rate: wifi_phy_rate_t = std.mem.zeroes(wifi_phy_rate_t),
    ersu: bool = std.mem.zeroes(bool),
};
pub const esp_now_rate_config_t = esp_now_rate_config;
pub const esp_now_recv_cb_t = ?*const fn ([*c]const esp_now_recv_info_t, [*:0]const u8, c_int) callconv(.C) void;
pub const esp_now_send_cb_t = ?*const fn ([*:0]const u8, esp_now_send_status_t) callconv(.C) void;
pub extern fn esp_now_init() esp_err_t;
pub extern fn esp_now_deinit() esp_err_t;
pub extern fn esp_now_get_version(version: [*c]u32) esp_err_t;
pub extern fn esp_now_register_recv_cb(cb: esp_now_recv_cb_t) esp_err_t;
pub extern fn esp_now_unregister_recv_cb() esp_err_t;
pub extern fn esp_now_register_send_cb(cb: esp_now_send_cb_t) esp_err_t;
pub extern fn esp_now_unregister_send_cb() esp_err_t;
pub extern fn esp_now_send(peer_addr: [*:0]const u8, data: [*:0]const u8, len: usize) esp_err_t;
pub extern fn esp_now_add_peer(peer: [*c]const esp_now_peer_info_t) esp_err_t;
pub extern fn esp_now_del_peer(peer_addr: [*:0]const u8) esp_err_t;
pub extern fn esp_now_mod_peer(peer: [*c]const esp_now_peer_info_t) esp_err_t;
pub extern fn esp_wifi_config_espnow_rate(ifx: wifi_interface_t, rate: wifi_phy_rate_t) esp_err_t;
pub extern fn esp_now_set_peer_rate_config(peer_addr: [*:0]const u8, config: [*c]esp_now_rate_config_t) esp_err_t;
pub extern fn esp_now_get_peer(peer_addr: [*:0]const u8, peer: [*c]esp_now_peer_info_t) esp_err_t;
pub extern fn esp_now_fetch_peer(from_head: bool, peer: [*c]esp_now_peer_info_t) esp_err_t;
pub extern fn esp_now_is_peer_exist(peer_addr: [*:0]const u8) bool;
pub extern fn esp_now_get_peer_num(num: [*c]esp_now_peer_num_t) esp_err_t;
pub extern fn esp_now_set_pmk(pmk: [*:0]const u8) esp_err_t;
pub extern fn esp_now_set_wake_window(window: u16) esp_err_t;

pub const esp_eap_ttls_phase2_types = enum(c_uint) {
    ESP_EAP_TTLS_PHASE2_EAP = 0,
    ESP_EAP_TTLS_PHASE2_MSCHAPV2 = 1,
    ESP_EAP_TTLS_PHASE2_MSCHAP = 2,
    ESP_EAP_TTLS_PHASE2_PAP = 3,
    ESP_EAP_TTLS_PHASE2_CHAP = 4,
};
pub const esp_eap_fast_config = extern struct {
    fast_provisioning: c_int = std.mem.zeroes(c_int),
    fast_max_pac_list_len: c_int = std.mem.zeroes(c_int),
    fast_pac_format_binary: bool = std.mem.zeroes(bool),
};
pub extern fn esp_wifi_sta_enterprise_enable() esp_err_t;
pub extern fn esp_wifi_sta_enterprise_disable() esp_err_t;
pub extern fn esp_eap_client_set_identity(identity: [*:0]const u8, len: c_int) esp_err_t;
pub extern fn esp_eap_client_clear_identity() void;
pub extern fn esp_eap_client_set_username(username: [*:0]const u8, len: c_int) esp_err_t;
pub extern fn esp_eap_client_clear_username() void;
pub extern fn esp_eap_client_set_password(password: [*:0]const u8, len: c_int) esp_err_t;
pub extern fn esp_eap_client_clear_password() void;
pub extern fn esp_eap_client_set_new_password(new_password: [*:0]const u8, len: c_int) esp_err_t;
pub extern fn esp_eap_client_clear_new_password() void;
pub extern fn esp_eap_client_set_ca_cert(ca_cert: [*:0]const u8, ca_cert_len: c_int) esp_err_t;
pub extern fn esp_eap_client_clear_ca_cert() void;
pub extern fn esp_eap_client_set_certificate_and_key(client_cert: [*:0]const u8, client_cert_len: c_int, private_key: [*:0]const u8, private_key_len: c_int, private_key_password: [*:0]const u8, private_key_passwd_len: c_int) esp_err_t;
pub extern fn esp_eap_client_clear_certificate_and_key() void;
pub extern fn esp_eap_client_set_disable_time_check(disable: bool) esp_err_t;
pub extern fn esp_eap_client_get_disable_time_check(disable: [*c]bool) esp_err_t;
pub extern fn esp_eap_client_set_ttls_phase2_method(@"type": esp_eap_ttls_phase2_types) esp_err_t;
pub extern fn esp_eap_client_set_suiteb_192bit_certification(enable: bool) esp_err_t;
pub extern fn esp_eap_client_set_pac_file(pac_file: [*:0]const u8, pac_file_len: c_int) esp_err_t;
pub extern fn esp_eap_client_set_fast_params(config: esp_eap_fast_config) esp_err_t;
pub extern fn esp_eap_client_use_default_cert_bundle(use_default_bundle: bool) esp_err_t;

pub const esp_ota_handle_t = u32;
pub extern fn esp_ota_get_app_description() [*c]const esp_app_desc_t;
pub extern fn esp_ota_get_app_elf_sha256(dst: [*:0]u8, size: usize) c_int;
pub extern fn esp_ota_begin(partition: [*c]const esp_partition_t, image_size: usize, out_handle: [*c]esp_ota_handle_t) esp_err_t;
pub extern fn esp_ota_write(handle: esp_ota_handle_t, data: ?*const anyopaque, size: usize) esp_err_t;
pub extern fn esp_ota_write_with_offset(handle: esp_ota_handle_t, data: ?*const anyopaque, size: usize, offset: u32) esp_err_t;
pub extern fn esp_ota_end(handle: esp_ota_handle_t) esp_err_t;
pub extern fn esp_ota_abort(handle: esp_ota_handle_t) esp_err_t;
pub extern fn esp_ota_set_boot_partition(partition: [*c]const esp_partition_t) esp_err_t;
pub extern fn esp_ota_get_boot_partition() [*c]const esp_partition_t;
pub extern fn esp_ota_get_running_partition() [*c]const esp_partition_t;
pub extern fn esp_ota_get_next_update_partition(start_from: [*c]const esp_partition_t) [*c]const esp_partition_t;
pub extern fn esp_ota_get_partition_description(partition: [*c]const esp_partition_t, app_desc: [*c]esp_app_desc_t) esp_err_t;
pub extern fn esp_ota_get_bootloader_description(bootloader_partition: [*c]const esp_partition_t, desc: [*c]esp_bootloader_desc_t) esp_err_t;
pub extern fn esp_ota_get_app_partition_count() u8;
pub extern fn esp_ota_mark_app_valid_cancel_rollback() esp_err_t;
pub extern fn esp_ota_mark_app_invalid_rollback_and_reboot() esp_err_t;
pub extern fn esp_ota_get_last_invalid_partition() [*c]const esp_partition_t;
pub extern fn esp_ota_get_state_partition(partition: [*c]const esp_partition_t, ota_state: [*c]esp_ota_img_states_t) esp_err_t;
pub extern fn esp_ota_erase_last_boot_app_partition() esp_err_t;
pub extern fn esp_ota_check_rollback_is_possible() bool;
pub const esp_app_desc_t = extern struct {
    magic_word: u32 = std.mem.zeroes(u32),
    secure_version: u32 = std.mem.zeroes(u32),
    reserv1: [2]u32 = std.mem.zeroes([2]u32),
    version: [32]u8 = std.mem.zeroes([32]u8),
    project_name: [32]u8 = std.mem.zeroes([32]u8),
    time: [16]u8 = std.mem.zeroes([16]u8),
    date: [16]u8 = std.mem.zeroes([16]u8),
    idf_ver: [32]u8 = std.mem.zeroes([32]u8),
    app_elf_sha256: [32]u8 = std.mem.zeroes([32]u8),
    reserv2: [20]u32 = std.mem.zeroes([20]u32),
};
pub extern fn esp_app_get_description() [*c]const esp_app_desc_t;
pub extern fn esp_app_get_elf_sha256(dst: [*:0]u8, size: usize) c_int;
pub const app_elf_sha256_str: [*:0]u8 = @extern([*:0]u8, .{
    .name = "app_elf_sha256_str",
});
pub inline fn esp_app_get_elf_sha256_str() [*:0]u8 {
    return @as([*:0]u8, @ptrCast(@alignCast(&app_elf_sha256_str)));
}
pub const esp_bootloader_desc_t = extern struct {
    magic_byte: u8 = std.mem.zeroes(u8),
    reserved: [3]u8 = std.mem.zeroes([3]u8),
    version: u32 = std.mem.zeroes(u32),
    idf_ver: [32]u8 = std.mem.zeroes([32]u8),
    date_time: [24]u8 = std.mem.zeroes([24]u8),
    reserved2: [16]u8 = std.mem.zeroes([16]u8),
};

pub const esp_ota_img_states_t = enum(c_uint) {
    ESP_OTA_IMG_NEW = 0,
    ESP_OTA_IMG_PENDING_VERIFY = 1,
    ESP_OTA_IMG_VALID = 2,
    ESP_OTA_IMG_INVALID = 3,
    ESP_OTA_IMG_ABORTED = 4,
    ESP_OTA_IMG_UNDEFINED = 4294967295,
};

pub extern const ESP_HTTPS_OTA_EVENT: esp_event_base_t;

pub const esp_https_ota_event_t = enum(c_uint) {
    ESP_HTTPS_OTA_START = 0,
    ESP_HTTPS_OTA_CONNECTED = 1,
    ESP_HTTPS_OTA_GET_IMG_DESC = 2,
    ESP_HTTPS_OTA_VERIFY_CHIP_ID = 3,
    ESP_HTTPS_OTA_DECRYPT_CB = 4,
    ESP_HTTPS_OTA_WRITE_FLASH = 5,
    ESP_HTTPS_OTA_UPDATE_BOOT_PARTITION = 6,
    ESP_HTTPS_OTA_FINISH = 7,
    ESP_HTTPS_OTA_ABORT = 8,
};
pub const esp_https_ota_handle_t = ?*anyopaque;
pub const http_client_init_cb_t = ?*const fn (esp_http_client_handle_t) callconv(.C) esp_err_t;
pub const esp_https_ota_config_t = extern struct {
    http_config: [*c]const esp_http_client_config_t = std.mem.zeroes([*c]const esp_http_client_config_t),
    http_client_init_cb: http_client_init_cb_t = std.mem.zeroes(http_client_init_cb_t),
    bulk_flash_erase: bool = false,
    partial_http_download: bool = false,
    max_http_request_size: c_int = 0,
    buffer_caps: u32 = 0,
};
pub extern fn esp_https_ota(ota_config: [*c]const esp_https_ota_config_t) esp_err_t;
pub extern fn esp_https_ota_begin(ota_config: [*c]const esp_https_ota_config_t, handle: [*c]esp_https_ota_handle_t) esp_err_t;
pub extern fn esp_https_ota_perform(https_ota_handle: esp_https_ota_handle_t) esp_err_t;
pub extern fn esp_https_ota_is_complete_data_received(https_ota_handle: esp_https_ota_handle_t) bool;
pub extern fn esp_https_ota_finish(https_ota_handle: esp_https_ota_handle_t) esp_err_t;
pub extern fn esp_https_ota_abort(https_ota_handle: esp_https_ota_handle_t) esp_err_t;
pub extern fn esp_https_ota_get_img_desc(https_ota_handle: esp_https_ota_handle_t, new_app_info: [*c]esp_app_desc_t) esp_err_t;
pub extern fn esp_https_ota_get_image_len_read(https_ota_handle: esp_https_ota_handle_t) c_int;
pub extern fn esp_https_ota_get_image_size(https_ota_handle: esp_https_ota_handle_t) c_int;

pub const pcnt_channel_level_action_t = enum(c_uint) {
    PCNT_CHANNEL_LEVEL_ACTION_KEEP = 0,
    PCNT_CHANNEL_LEVEL_ACTION_INVERSE = 1,
    PCNT_CHANNEL_LEVEL_ACTION_HOLD = 2,
};
pub const pcnt_channel_edge_action_t = enum(c_uint) {
    PCNT_CHANNEL_EDGE_ACTION_HOLD = 0,
    PCNT_CHANNEL_EDGE_ACTION_INCREASE = 1,
    PCNT_CHANNEL_EDGE_ACTION_DECREASE = 2,
};
pub const pcnt_unit_zero_cross_mode_t = enum(c_uint) {
    PCNT_UNIT_ZERO_CROSS_POS_ZERO = 0,
    PCNT_UNIT_ZERO_CROSS_NEG_ZERO = 1,
    PCNT_UNIT_ZERO_CROSS_NEG_POS = 2,
    PCNT_UNIT_ZERO_CROSS_POS_NEG = 3,
};
pub const pcnt_unit_handle_t = ?*anyopaque;
pub const pcnt_channel_handle_t = ?*anyopaque;
pub const pcnt_watch_event_data_t = extern struct {
    watch_point_value: c_int = std.mem.zeroes(c_int),
    zero_cross_mode: pcnt_unit_zero_cross_mode_t = std.mem.zeroes(pcnt_unit_zero_cross_mode_t),
};
pub const pcnt_watch_cb_t = ?*const fn (pcnt_unit_handle_t, [*c]const pcnt_watch_event_data_t, ?*anyopaque) callconv(.C) bool;
pub const pcnt_event_callbacks_t = extern struct {
    on_reach: pcnt_watch_cb_t = std.mem.zeroes(pcnt_watch_cb_t),
};
// /home/kassane/esp/v5.3/esp-idf/components/esp_driver_pcnt/include/driver/pulse_cnt.h:67:18: warning: struct demoted to opaque type - has bitfield
const struct_unnamed_3 = opaque {};
pub const pcnt_unit_config_t = extern struct {
    low_limit: c_int = std.mem.zeroes(c_int),
    high_limit: c_int = std.mem.zeroes(c_int),
    intr_priority: c_int = std.mem.zeroes(c_int),
    flags: ?*anyerror = null,
};
// /home/kassane/esp/v5.3/esp-idf/components/esp_driver_pcnt/include/driver/pulse_cnt.h:78:18: warning: struct demoted to opaque type - has bitfield
const struct_unnamed_04 = opaque {};
pub const pcnt_chan_config_t = extern struct {
    edge_gpio_num: c_int = std.mem.zeroes(c_int),
    level_gpio_num: c_int = std.mem.zeroes(c_int),
    flags: struct_unnamed_04 = std.mem.zeroes(struct_unnamed_04),
};
pub const pcnt_glitch_filter_config_t = extern struct {
    max_glitch_ns: u32 = std.mem.zeroes(u32),
};
pub extern fn pcnt_new_unit(config: ?*const pcnt_unit_config_t, ret_unit: [*c]pcnt_unit_handle_t) esp_err_t;
pub extern fn pcnt_del_unit(unit: pcnt_unit_handle_t) esp_err_t;
pub extern fn pcnt_unit_set_glitch_filter(unit: pcnt_unit_handle_t, config: [*c]const pcnt_glitch_filter_config_t) esp_err_t;
pub extern fn pcnt_unit_enable(unit: pcnt_unit_handle_t) esp_err_t;
pub extern fn pcnt_unit_disable(unit: pcnt_unit_handle_t) esp_err_t;
pub extern fn pcnt_unit_start(unit: pcnt_unit_handle_t) esp_err_t;
pub extern fn pcnt_unit_stop(unit: pcnt_unit_handle_t) esp_err_t;
pub extern fn pcnt_unit_clear_count(unit: pcnt_unit_handle_t) esp_err_t;
pub extern fn pcnt_unit_get_count(unit: pcnt_unit_handle_t, value: [*c]c_int) esp_err_t;
pub extern fn pcnt_unit_register_event_callbacks(unit: pcnt_unit_handle_t, cbs: [*c]const pcnt_event_callbacks_t, user_data: ?*anyopaque) esp_err_t;
pub extern fn pcnt_unit_add_watch_point(unit: pcnt_unit_handle_t, watch_point: c_int) esp_err_t;
pub extern fn pcnt_unit_remove_watch_point(unit: pcnt_unit_handle_t, watch_point: c_int) esp_err_t;
pub extern fn pcnt_new_channel(unit: pcnt_unit_handle_t, config: ?*const pcnt_chan_config_t, ret_chan: [*c]pcnt_channel_handle_t) esp_err_t;
pub extern fn pcnt_del_channel(chan: pcnt_channel_handle_t) esp_err_t;
pub extern fn pcnt_channel_set_edge_action(chan: pcnt_channel_handle_t, pos_act: pcnt_channel_edge_action_t, neg_act: pcnt_channel_edge_action_t) esp_err_t;
pub extern fn pcnt_channel_set_level_action(chan: pcnt_channel_handle_t, high_act: pcnt_channel_level_action_t, low_act: pcnt_channel_level_action_t) esp_err_t;
