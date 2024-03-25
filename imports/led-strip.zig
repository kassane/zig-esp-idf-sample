//! Suggestion, use: sys.py add-dependency espressif/led_strip

const sys = @import("sys");
const std = @import("std");

// Functions & types
pub const led_pixel_format_t = enum(c_uint) {
    LED_PIXEL_FORMAT_GRB = 0,
    LED_PIXEL_FORMAT_GRBW = 1,
    LED_PIXEL_FORMAT_INVALID = 2,
};
pub const led_model_t = enum(c_uint) {
    LED_MODEL_WS2812 = 0,
    LED_MODEL_SK6812 = 1,
    LED_MODEL_INVALID = 2,
};
pub const led_strip_t = opaque {};
pub const led_strip_handle_t = ?*led_strip_t;
// /espressif/zig-esp-idf-sample/managed_components/espressif__led_strip/include/led_strip_types.h:48:18: warning: struct demoted to opaque type - has bitfield
const unnamed_3 = extern struct { with_dma: bool = false };
pub const led_strip_config_t = extern struct {
    strip_gpio_num: c_int = std.mem.zeroes(c_int),
    max_leds: u32 = std.mem.zeroes(u32),
    led_pixel_format: led_pixel_format_t = std.mem.zeroes(led_pixel_format_t),
    led_model: led_model_t = std.mem.zeroes(led_model_t),
    flags: unnamed_3 = std.mem.zeroes(unnamed_3),
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
    SOC_RTC_FAST_CLK_SRC_XTAL_DIV = 0,
    SOC_RTC_FAST_CLK_SRC_RC_FAST = 1,
    SOC_RTC_FAST_CLK_SRC_INVALID = 2,
};
pub const soc_xtal_freq_t = enum(c_uint) {
    SOC_XTAL_FREQ_32M = 32,
    SOC_XTAL_FREQ_40M = 40,
};
pub const soc_module_clk_t = enum(c_uint) {
    SOC_MOD_CLK_CPU = 1,
    SOC_MOD_CLK_RTC_FAST = 2,
    SOC_MOD_CLK_RTC_SLOW = 3,
    SOC_MOD_CLK_APB = 4,
    SOC_MOD_CLK_PLL_F80M = 5,
    SOC_MOD_CLK_PLL_F160M = 6,
    SOC_MOD_CLK_XTAL32K = 7,
    SOC_MOD_CLK_RC_FAST = 8,
    SOC_MOD_CLK_RC_FAST_D256 = 9,
    SOC_MOD_CLK_XTAL = 10,
    SOC_MOD_CLK_INVALID = 11,
};
pub const soc_periph_systimer_clk_src_t = enum(c_uint) {
    SYSTIMER_CLK_SRC_XTAL = 10,
    SYSTIMER_CLK_SRC_DEFAULT = 10,
};
pub const soc_periph_gptimer_clk_src_t = enum(c_uint) {
    GPTIMER_CLK_SRC_APB = 4,
    GPTIMER_CLK_SRC_XTAL = 10,
    GPTIMER_CLK_SRC_DEFAULT = 4,
};
pub const soc_periph_tg_clk_src_legacy_t = enum(c_uint) {
    TIMER_SRC_CLK_APB = 4,
    TIMER_SRC_CLK_XTAL = 10,
    TIMER_SRC_CLK_DEFAULT = 4,
};
pub const soc_periph_rmt_clk_src_t = enum(c_uint) {
    RMT_CLK_SRC_APB = 4,
    RMT_CLK_SRC_RC_FAST = 8,
    RMT_CLK_SRC_XTAL = 10,
    RMT_CLK_SRC_DEFAULT = 4,
};
pub const soc_periph_rmt_clk_src_legacy_t = enum(c_uint) {
    RMT_BASECLK_APB = 4,
    RMT_BASECLK_XTAL = 10,
    RMT_BASECLK_DEFAULT = 4,
};
pub const soc_periph_i2s_clk_src_t = enum(c_int) {
    I2S_CLK_SRC_DEFAULT = 6,
    I2S_CLK_SRC_PLL_160M = 6,
    I2S_CLK_SRC_XTAL = 10,
    I2S_CLK_SRC_EXTERNAL = -1,
};
pub const soc_periph_i2c_clk_src_t = enum(c_uint) {
    I2C_CLK_SRC_XTAL = 10,
    I2C_CLK_SRC_RC_FAST = 8,
    I2C_CLK_SRC_DEFAULT = 10,
};
pub const soc_periph_spi_clk_src_t = enum(c_uint) {
    // SPI_CLK_SRC_DEFAULT = 4,
    SPI_CLK_SRC_APB = 4,
    SPI_CLK_SRC_XTAL = 10,
};
pub const soc_periph_sdm_clk_src_t = enum(c_uint) {
    SDM_CLK_SRC_APB = 4,
    SDM_CLK_SRC_DEFAULT = 4,
};
pub const soc_periph_glitch_filter_clk_src_t = enum(c_uint) {
    GLITCH_FILTER_CLK_SRC_APB = 4,
    GLITCH_FILTER_CLK_SRC_DEFAULT = 4,
};
pub const soc_periph_twai_clk_src_t = enum(c_uint) {
    TWAI_CLK_SRC_APB = 4,
    TWAI_CLK_SRC_DEFAULT = 4,
};
pub const soc_periph_adc_digi_clk_src_t = enum(c_uint) {
    ADC_DIGI_CLK_SRC_APB = 4,
    ADC_DIGI_CLK_SRC_DEFAULT = 4,
};
pub const soc_periph_mwdt_clk_src_t = enum(c_uint) {
    MWDT_CLK_SRC_XTAL = 10,
    MWDT_CLK_SRC_APB = 4,
    MWDT_CLK_SRC_DEFAULT = 10,
};
pub const soc_periph_ledc_clk_src_legacy_t = enum(c_uint) {
    LEDC_AUTO_CLK = 0,
    LEDC_USE_APB_CLK = 4,
    LEDC_USE_RC_FAST_CLK = 8,
    LEDC_USE_XTAL_CLK = 10,
    LEDC_USE_RTC8M_CLK = 8,
};
pub const soc_clkout_sig_id_t = enum(c_uint) {
    CLKOUT_SIG_PLL = 1,
    CLKOUT_SIG_RC_SLOW = 4,
    CLKOUT_SIG_XTAL = 5,
    CLKOUT_SIG_PLL_F80M = 13,
    CLKOUT_SIG_RC_FAST = 14,
    CLKOUT_SIG_INVALID = 255,
};
pub const rmt_clock_source_t = soc_periph_rmt_clk_src_t;
// /espressif/esp-idf/components/hal/include/hal/rmt_types.h:32:18: warning: struct demoted to opaque type - has bitfield
const unnamed_4 = opaque {};
pub const rmt_symbol_word_t = extern union {
    unnamed_0: unnamed_4,
    val: u32,
};
pub const rmt_channel_t = opaque {};
pub const rmt_channel_handle_t = ?*rmt_channel_t;
pub const rmt_sync_manager_t = opaque {};
pub const rmt_sync_manager_handle_t = ?*rmt_sync_manager_t;
pub const rmt_encoder_t = opaque {};
pub const rmt_encoder_handle_t = ?*rmt_encoder_t;
pub const rmt_tx_done_event_data_t = extern struct {
    num_symbols: usize = std.mem.zeroes(usize),
};
pub const rmt_tx_done_callback_t = ?*const fn (rmt_channel_handle_t, [*c]const rmt_tx_done_event_data_t, ?*anyopaque) callconv(.C) bool; // /home/kassane/espressif/esp-idf/components/esp_driver_rmt/include/driver/rmt_types.h:60:18: warning: struct demoted to opaque type - has bitfield
const unnamed_5 = opaque {};
pub const rmt_rx_done_event_data_t = extern struct {
    received_symbols: ?*rmt_symbol_word_t = std.mem.zeroes(?*rmt_symbol_word_t),
    num_symbols: usize = std.mem.zeroes(usize),
    flags: unnamed_5 = std.mem.zeroes(unnamed_5),
};
pub const rmt_rx_done_callback_t = ?*const fn (rmt_channel_handle_t, ?*const rmt_rx_done_event_data_t, ?*anyopaque) callconv(.C) bool; // /home/kassane/espressif/zig-esp-idf-sample/managed_components/espressif__led_strip/include/led_strip_rmt.h:33:18: warning: struct demoted to opaque type - has bitfield
const unnamed_6 = opaque {};
pub const led_strip_rmt_config_t = extern struct {
    clk_src: rmt_clock_source_t = std.mem.zeroes(rmt_clock_source_t),
    resolution_hz: u32 = std.mem.zeroes(u32),
    mem_block_symbols: usize = std.mem.zeroes(usize),
    flags: unnamed_6 = std.mem.zeroes(unnamed_6),
};
pub extern fn led_strip_new_rmt_device(led_config: ?*const led_strip_config_t, rmt_config: ?*const led_strip_rmt_config_t, ret_strip: [*c]led_strip_handle_t) sys.esp_err_t;
const unnamed_13 = extern struct { with_dma: bool = false };
pub const led_strip_spi_config_t = extern struct {
    clk_src: sys.spi_clock_source_t = .SPI_CLK_SRC_APB,
    spi_bus: sys.spi_host_device_t = std.mem.zeroes(sys.spi_host_device_t),
    flags: unnamed_13 = std.mem.zeroes(unnamed_13),
};
pub extern fn led_strip_new_spi_device(led_config: ?*const led_strip_config_t, spi_config: ?*const led_strip_spi_config_t, ret_strip: [*c]led_strip_handle_t) sys.esp_err_t;
pub extern fn led_strip_set_pixel(strip: led_strip_handle_t, index: u32, red: u32, green: u32, blue: u32) sys.esp_err_t;
pub extern fn led_strip_set_pixel_rgbw(strip: led_strip_handle_t, index: u32, red: u32, green: u32, blue: u32, white: u32) sys.esp_err_t;
pub extern fn led_strip_set_pixel_hsv(strip: led_strip_handle_t, index: u32, hue: u16, saturation: u8, value: u8) sys.esp_err_t;
pub extern fn led_strip_refresh(strip: led_strip_handle_t) sys.esp_err_t;
pub extern fn led_strip_clear(strip: led_strip_handle_t) sys.esp_err_t;
pub extern fn led_strip_del(strip: led_strip_handle_t) sys.esp_err_t;
