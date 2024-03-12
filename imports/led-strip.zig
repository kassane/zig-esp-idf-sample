//! Need: idf.py add-dependency espressif/led_strip
const idf = @import("esp_idf");
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
pub const struct_led_strip_t = opaque {};
pub const led_strip_handle_t = ?*struct_led_strip_t; // /home/kassane/espressif/zig-esp-idf-sample/managed_components/espressif__led_strip/include/led_strip_types.h:48:18: warning: struct demoted to opaque type - has bitfield
const struct_unnamed_3 = opaque {};
pub const led_strip_config_t = extern struct {
    strip_gpio_num: c_int = std.mem.zeroes(c_int),
    max_leds: u32 = std.mem.zeroes(u32),
    led_pixel_format: led_pixel_format_t = std.mem.zeroes(led_pixel_format_t),
    led_model: led_model_t = std.mem.zeroes(led_model_t),
    flags: struct_unnamed_3 = std.mem.zeroes(struct_unnamed_3),
};
pub const SOC_ROOT_CLK_INT_RC_FAST: c_int = 0;
pub const SOC_ROOT_CLK_INT_RC_SLOW: c_int = 1;
pub const SOC_ROOT_CLK_EXT_XTAL: c_int = 2;
pub const SOC_ROOT_CLK_EXT_XTAL32K: c_int = 3;
pub const soc_root_clk_t = c_uint;
pub const SOC_CPU_CLK_SRC_XTAL: c_int = 0;
pub const SOC_CPU_CLK_SRC_PLL: c_int = 1;
pub const SOC_CPU_CLK_SRC_RC_FAST: c_int = 2;
pub const SOC_CPU_CLK_SRC_INVALID: c_int = 3;
pub const soc_cpu_clk_src_t = c_uint;
pub const SOC_RTC_SLOW_CLK_SRC_RC_SLOW: c_int = 0;
pub const SOC_RTC_SLOW_CLK_SRC_XTAL32K: c_int = 1;
pub const SOC_RTC_SLOW_CLK_SRC_RC_FAST_D256: c_int = 2;
pub const SOC_RTC_SLOW_CLK_SRC_INVALID: c_int = 3;
pub const soc_rtc_slow_clk_src_t = c_uint;
pub const SOC_RTC_FAST_CLK_SRC_XTAL_D2: c_int = 0;
pub const SOC_RTC_FAST_CLK_SRC_XTAL_DIV: c_int = 0;
pub const SOC_RTC_FAST_CLK_SRC_RC_FAST: c_int = 1;
pub const SOC_RTC_FAST_CLK_SRC_INVALID: c_int = 2;
pub const soc_rtc_fast_clk_src_t = c_uint;
pub const SOC_XTAL_FREQ_32M: c_int = 32;
pub const SOC_XTAL_FREQ_40M: c_int = 40;
pub const soc_xtal_freq_t = c_uint;
pub const SOC_MOD_CLK_CPU: c_int = 1;
pub const SOC_MOD_CLK_RTC_FAST: c_int = 2;
pub const SOC_MOD_CLK_RTC_SLOW: c_int = 3;
pub const SOC_MOD_CLK_APB: c_int = 4;
pub const SOC_MOD_CLK_PLL_F80M: c_int = 5;
pub const SOC_MOD_CLK_PLL_F160M: c_int = 6;
pub const SOC_MOD_CLK_XTAL32K: c_int = 7;
pub const SOC_MOD_CLK_RC_FAST: c_int = 8;
pub const SOC_MOD_CLK_RC_FAST_D256: c_int = 9;
pub const SOC_MOD_CLK_XTAL: c_int = 10;
pub const SOC_MOD_CLK_INVALID: c_int = 11;
pub const soc_module_clk_t = c_uint;
pub const SYSTIMER_CLK_SRC_XTAL: c_int = 10;
pub const SYSTIMER_CLK_SRC_DEFAULT: c_int = 10;
pub const soc_periph_systimer_clk_src_t = c_uint;
pub const GPTIMER_CLK_SRC_APB: c_int = 4;
pub const GPTIMER_CLK_SRC_XTAL: c_int = 10;
pub const GPTIMER_CLK_SRC_DEFAULT: c_int = 4;
pub const soc_periph_gptimer_clk_src_t = c_uint;
pub const TIMER_SRC_CLK_APB: c_int = 4;
pub const TIMER_SRC_CLK_XTAL: c_int = 10;
pub const TIMER_SRC_CLK_DEFAULT: c_int = 4;
pub const soc_periph_tg_clk_src_legacy_t = c_uint;
pub const RMT_CLK_SRC_APB: c_int = 4;
pub const RMT_CLK_SRC_RC_FAST: c_int = 8;
pub const RMT_CLK_SRC_XTAL: c_int = 10;
pub const RMT_CLK_SRC_DEFAULT: c_int = 4;
pub const soc_periph_rmt_clk_src_t = c_uint;
pub const RMT_BASECLK_APB: c_int = 4;
pub const RMT_BASECLK_XTAL: c_int = 10;
pub const RMT_BASECLK_DEFAULT: c_int = 4;
pub const soc_periph_rmt_clk_src_legacy_t = c_uint;
pub const TEMPERATURE_SENSOR_CLK_SRC_XTAL: c_int = 10;
pub const TEMPERATURE_SENSOR_CLK_SRC_RC_FAST: c_int = 8;
pub const TEMPERATURE_SENSOR_CLK_SRC_DEFAULT: c_int = 10;
pub const soc_periph_temperature_sensor_clk_src_t = c_uint;
pub const UART_SCLK_APB: c_int = 4;
pub const UART_SCLK_RTC: c_int = 8;
pub const UART_SCLK_XTAL: c_int = 10;
pub const UART_SCLK_DEFAULT: c_int = 4;
pub const soc_periph_uart_clk_src_legacy_t = c_uint;
pub const I2S_CLK_SRC_DEFAULT: c_int = 6;
pub const I2S_CLK_SRC_PLL_160M: c_int = 6;
pub const I2S_CLK_SRC_XTAL: c_int = 10;
pub const I2S_CLK_SRC_EXTERNAL: c_int = -1;
pub const soc_periph_i2s_clk_src_t = c_int;
pub const I2C_CLK_SRC_XTAL: c_int = 10;
pub const I2C_CLK_SRC_RC_FAST: c_int = 8;
pub const I2C_CLK_SRC_DEFAULT: c_int = 10;
pub const soc_periph_i2c_clk_src_t = c_uint;
pub const SPI_CLK_SRC_DEFAULT: c_int = 4;
pub const SPI_CLK_SRC_APB: c_int = 4;
pub const SPI_CLK_SRC_XTAL: c_int = 10;
pub const soc_periph_spi_clk_src_t = c_uint;
pub const SDM_CLK_SRC_APB: c_int = 4;
pub const SDM_CLK_SRC_DEFAULT: c_int = 4;
pub const soc_periph_sdm_clk_src_t = c_uint;
pub const GLITCH_FILTER_CLK_SRC_APB: c_int = 4;
pub const GLITCH_FILTER_CLK_SRC_DEFAULT: c_int = 4;
pub const soc_periph_glitch_filter_clk_src_t = c_uint;
pub const TWAI_CLK_SRC_APB: c_int = 4;
pub const TWAI_CLK_SRC_DEFAULT: c_int = 4;
pub const soc_periph_twai_clk_src_t = c_uint;
pub const ADC_DIGI_CLK_SRC_APB: c_int = 4;
pub const ADC_DIGI_CLK_SRC_DEFAULT: c_int = 4;
pub const soc_periph_adc_digi_clk_src_t = c_uint;
pub const MWDT_CLK_SRC_XTAL: c_int = 10;
pub const MWDT_CLK_SRC_APB: c_int = 4;
pub const MWDT_CLK_SRC_DEFAULT: c_int = 10;
pub const soc_periph_mwdt_clk_src_t = c_uint;
pub const LEDC_AUTO_CLK: c_int = 0;
pub const LEDC_USE_APB_CLK: c_int = 4;
pub const LEDC_USE_RC_FAST_CLK: c_int = 8;
pub const LEDC_USE_XTAL_CLK: c_int = 10;
pub const LEDC_USE_RTC8M_CLK: c_int = 8;
pub const soc_periph_ledc_clk_src_legacy_t = c_uint;
pub const CLKOUT_SIG_PLL: c_int = 1;
pub const CLKOUT_SIG_RC_SLOW: c_int = 4;
pub const CLKOUT_SIG_XTAL: c_int = 5;
pub const CLKOUT_SIG_PLL_F80M: c_int = 13;
pub const CLKOUT_SIG_RC_FAST: c_int = 14;
pub const CLKOUT_SIG_INVALID: c_int = 255;
pub const soc_clkout_sig_id_t = c_uint;
pub const rmt_clock_source_t = soc_periph_rmt_clk_src_t; // /home/kassane/espressif/esp-idf/components/hal/include/hal/rmt_types.h:32:18: warning: struct demoted to opaque type - has bitfield
const struct_unnamed_4 = opaque {};
pub const rmt_symbol_word_t = extern union {
    unnamed_0: struct_unnamed_4,
    val: u32,
};
pub const struct_rmt_channel_t = opaque {};
pub const rmt_channel_handle_t = ?*struct_rmt_channel_t;
pub const struct_rmt_sync_manager_t = opaque {};
pub const rmt_sync_manager_handle_t = ?*struct_rmt_sync_manager_t;
pub const struct_rmt_encoder_t = opaque {};
pub const rmt_encoder_handle_t = ?*struct_rmt_encoder_t;
pub const rmt_tx_done_event_data_t = extern struct {
    num_symbols: usize = std.mem.zeroes(usize),
};
pub const rmt_tx_done_callback_t = ?*const fn (rmt_channel_handle_t, [*c]const rmt_tx_done_event_data_t, ?*anyopaque) callconv(.C) bool; // /home/kassane/espressif/esp-idf/components/esp_driver_rmt/include/driver/rmt_types.h:60:18: warning: struct demoted to opaque type - has bitfield
const struct_unnamed_5 = opaque {};
pub const rmt_rx_done_event_data_t = extern struct {
    received_symbols: ?*rmt_symbol_word_t = std.mem.zeroes(?*rmt_symbol_word_t),
    num_symbols: usize = std.mem.zeroes(usize),
    flags: struct_unnamed_5 = std.mem.zeroes(struct_unnamed_5),
};
pub const rmt_rx_done_callback_t = ?*const fn (rmt_channel_handle_t, ?*const rmt_rx_done_event_data_t, ?*anyopaque) callconv(.C) bool; // /home/kassane/espressif/zig-esp-idf-sample/managed_components/espressif__led_strip/include/led_strip_rmt.h:33:18: warning: struct demoted to opaque type - has bitfield
const struct_unnamed_6 = opaque {};
pub const led_strip_rmt_config_t = extern struct {
    clk_src: rmt_clock_source_t = std.mem.zeroes(rmt_clock_source_t),
    resolution_hz: u32 = std.mem.zeroes(u32),
    mem_block_symbols: usize = std.mem.zeroes(usize),
    flags: struct_unnamed_6 = std.mem.zeroes(struct_unnamed_6),
};
pub extern fn led_strip_new_rmt_device(led_config: ?*const led_strip_config_t, rmt_config: ?*const led_strip_rmt_config_t, ret_strip: [*c]led_strip_handle_t) idf.esp_err_t;
pub const SPI1_HOST: c_int = 0;
pub const SPI2_HOST: c_int = 1;
pub const SPI_HOST_MAX: c_int = 2;
pub const spi_host_device_t = c_uint;
pub const spi_clock_source_t = soc_periph_spi_clk_src_t;
pub const SPI_EV_BUF_TX: c_int = 1;
pub const SPI_EV_BUF_RX: c_int = 2;
pub const SPI_EV_SEND_DMA_READY: c_int = 4;
pub const SPI_EV_SEND: c_int = 8;
pub const SPI_EV_RECV_DMA_READY: c_int = 16;
pub const SPI_EV_RECV: c_int = 32;
pub const SPI_EV_CMD9: c_int = 64;
pub const SPI_EV_CMDA: c_int = 128;
pub const SPI_EV_TRANS: c_int = 256;
pub const spi_event_t = c_uint;
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
const union_unnamed_7 = extern union {
    mosi_io_num: c_int,
    data0_io_num: c_int,
};
const union_unnamed_8 = extern union {
    miso_io_num: c_int,
    data1_io_num: c_int,
};
const union_unnamed_9 = extern union {
    quadwp_io_num: c_int,
    data2_io_num: c_int,
};
const union_unnamed_10 = extern union {
    quadhd_io_num: c_int,
    data3_io_num: c_int,
};
pub const spi_bus_config_t = extern struct {
    unnamed_0: union_unnamed_7 = std.mem.zeroes(union_unnamed_7),
    unnamed_1: union_unnamed_8 = std.mem.zeroes(union_unnamed_8),
    sclk_io_num: c_int = std.mem.zeroes(c_int),
    unnamed_2: union_unnamed_9 = std.mem.zeroes(union_unnamed_9),
    unnamed_3: union_unnamed_10 = std.mem.zeroes(union_unnamed_10),
    data4_io_num: c_int = std.mem.zeroes(c_int),
    data5_io_num: c_int = std.mem.zeroes(c_int),
    data6_io_num: c_int = std.mem.zeroes(c_int),
    data7_io_num: c_int = std.mem.zeroes(c_int),
    max_transfer_sz: c_int = std.mem.zeroes(c_int),
    flags: u32 = std.mem.zeroes(u32),
    isr_cpu_id: idf.esp_intr_cpu_affinity_t = std.mem.zeroes(idf.esp_intr_cpu_affinity_t),
    intr_flags: c_int = std.mem.zeroes(c_int),
};
pub extern fn spi_bus_initialize(host_id: spi_host_device_t, bus_config: [*c]const spi_bus_config_t, dma_chan: spi_dma_chan_t) idf.esp_err_t;
pub extern fn spi_bus_free(host_id: spi_host_device_t) idf.esp_err_t;
const union_unnamed_11 = extern union {
    tx_buffer: ?*const anyopaque,
    tx_data: [4]u8,
};
const union_unnamed_12 = extern union {
    rx_buffer: ?*anyopaque,
    rx_data: [4]u8,
};
pub const struct_spi_transaction_t = extern struct {
    flags: u32 = std.mem.zeroes(u32),
    cmd: u16 = std.mem.zeroes(u16),
    addr: u64 = std.mem.zeroes(u64),
    length: usize = std.mem.zeroes(usize),
    rxlength: usize = std.mem.zeroes(usize),
    user: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    unnamed_0: union_unnamed_11 = std.mem.zeroes(union_unnamed_11),
    unnamed_1: union_unnamed_12 = std.mem.zeroes(union_unnamed_12),
};
pub const spi_transaction_t = struct_spi_transaction_t;
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
    base: struct_spi_transaction_t = std.mem.zeroes(struct_spi_transaction_t),
    command_bits: u8 = std.mem.zeroes(u8),
    address_bits: u8 = std.mem.zeroes(u8),
    dummy_bits: u8 = std.mem.zeroes(u8),
};
pub const struct_spi_device_t = opaque {};
pub const spi_device_handle_t = ?*struct_spi_device_t;
pub extern fn spi_bus_add_device(host_id: spi_host_device_t, dev_config: [*c]const spi_device_interface_config_t, handle: [*c]spi_device_handle_t) idf.esp_err_t;
pub extern fn spi_bus_remove_device(handle: spi_device_handle_t) idf.esp_err_t;
pub extern fn spi_device_queue_trans(handle: spi_device_handle_t, trans_desc: [*c]spi_transaction_t, ticks_to_wait: idf.TickType_t) idf.esp_err_t;
pub extern fn spi_device_get_trans_result(handle: spi_device_handle_t, trans_desc: [*c][*c]spi_transaction_t, ticks_to_wait: idf.TickType_t) idf.esp_err_t;
pub extern fn spi_device_transmit(handle: spi_device_handle_t, trans_desc: [*c]spi_transaction_t) idf.esp_err_t;
pub extern fn spi_device_polling_start(handle: spi_device_handle_t, trans_desc: [*c]spi_transaction_t, ticks_to_wait: idf.TickType_t) idf.esp_err_t;
pub extern fn spi_device_polling_end(handle: spi_device_handle_t, ticks_to_wait: idf.TickType_t) idf.esp_err_t;
pub extern fn spi_device_polling_transmit(handle: spi_device_handle_t, trans_desc: [*c]spi_transaction_t) idf.esp_err_t;
pub extern fn spi_device_acquire_bus(device: spi_device_handle_t, wait: idf.TickType_t) idf.esp_err_t;
pub extern fn spi_device_release_bus(dev: spi_device_handle_t) void;
pub extern fn spi_device_get_actual_freq(handle: spi_device_handle_t, freq_khz: [*c]c_int) idf.esp_err_t;
pub extern fn spi_get_actual_clock(fapb: c_int, hz: c_int, duty_cycle: c_int) c_int;
pub extern fn spi_get_timing(gpio_is_used: bool, input_delay_ns: c_int, eff_clk: c_int, dummy_o: [*c]c_int, cycles_remain_o: [*c]c_int) void;
pub extern fn spi_get_freq_limit(gpio_is_used: bool, input_delay_ns: c_int) c_int;
pub extern fn spi_bus_get_max_transaction_len(host_id: spi_host_device_t, max_bytes: [*c]usize) idf.esp_err_t; // /home/kassane/espressif/zig-esp-idf-sample/managed_components/espressif__led_strip/include/led_strip_spi.h:24:18: warning: struct demoted to opaque type - has bitfield
const struct_unnamed_13 = opaque {};
pub const led_strip_spi_config_t = extern struct {
    clk_src: spi_clock_source_t = std.mem.zeroes(spi_clock_source_t),
    spi_bus: spi_host_device_t = std.mem.zeroes(spi_host_device_t),
    flags: struct_unnamed_13 = std.mem.zeroes(struct_unnamed_13),
};
pub extern fn led_strip_new_spi_device(led_config: ?*const led_strip_config_t, spi_config: ?*const led_strip_spi_config_t, ret_strip: [*c]led_strip_handle_t) idf.esp_err_t;
pub extern fn led_strip_set_pixel(strip: led_strip_handle_t, index: u32, red: u32, green: u32, blue: u32) idf.esp_err_t;
pub extern fn led_strip_set_pixel_rgbw(strip: led_strip_handle_t, index: u32, red: u32, green: u32, blue: u32, white: u32) idf.esp_err_t;
pub extern fn led_strip_set_pixel_hsv(strip: led_strip_handle_t, index: u32, hue: u16, saturation: u8, value: u8) idf.esp_err_t;
pub extern fn led_strip_refresh(strip: led_strip_handle_t) idf.esp_err_t;
pub extern fn led_strip_clear(strip: led_strip_handle_t) idf.esp_err_t;
pub extern fn led_strip_del(strip: led_strip_handle_t) idf.esp_err_t;
pub extern fn esp_rom_gpio_pad_select_gpio(iopad_num: u32) void;
pub extern fn esp_rom_gpio_pad_pullup_only(iopad_num: u32) void;
pub extern fn esp_rom_gpio_pad_unhold(gpio_num: u32) void;
pub extern fn esp_rom_gpio_pad_set_drv(iopad_num: u32, drv: u32) void;
pub extern fn esp_rom_gpio_connect_in_signal(gpio_num: u32, signal_idx: u32, inv: bool) void;
pub extern fn esp_rom_gpio_connect_out_signal(gpio_num: u32, signal_idx: u32, out_inv: bool, oen_inv: bool) void;
pub const struct_esp_etm_channel_t = opaque {};
pub const esp_etm_channel_handle_t = ?*struct_esp_etm_channel_t;
pub const struct_esp_etm_event_t = opaque {};
pub const esp_etm_event_handle_t = ?*struct_esp_etm_event_t;
pub const struct_esp_etm_task_t = opaque {};
pub const esp_etm_task_handle_t = ?*struct_esp_etm_task_t;
pub const esp_etm_channel_config_t = extern struct {};
pub extern fn esp_etm_new_channel(config: [*c]const esp_etm_channel_config_t, ret_chan: [*c]esp_etm_channel_handle_t) idf.esp_err_t;
pub extern fn esp_etm_del_channel(chan: esp_etm_channel_handle_t) idf.esp_err_t;
pub extern fn esp_etm_channel_enable(chan: esp_etm_channel_handle_t) idf.esp_err_t;
pub extern fn esp_etm_channel_disable(chan: esp_etm_channel_handle_t) idf.esp_err_t;
pub extern fn esp_etm_channel_connect(chan: esp_etm_channel_handle_t, event: esp_etm_event_handle_t, task: esp_etm_task_handle_t) idf.esp_err_t;
pub extern fn esp_etm_del_event(event: esp_etm_event_handle_t) idf.esp_err_t;
pub extern fn esp_etm_del_task(task: esp_etm_task_handle_t) idf.esp_err_t;
pub extern fn esp_etm_dump(out_stream: std.c.FILE) idf.esp_err_t;
pub const gpio_etm_event_edge_t = enum(c_uint) {
    GPIO_ETM_EVENT_EDGE_POS = 0,
    GPIO_ETM_EVENT_EDGE_NEG = 1,
    GPIO_ETM_EVENT_EDGE_ANY = 2,
};
pub const gpio_etm_event_config_t = extern struct {
    edge: gpio_etm_event_edge_t = std.mem.zeroes(gpio_etm_event_edge_t),
};
pub extern fn gpio_new_etm_event(config: [*c]const gpio_etm_event_config_t, ret_event: [*c]esp_etm_event_handle_t) idf.esp_err_t;
pub extern fn gpio_etm_event_bind_gpio(event: esp_etm_event_handle_t, gpio_num: c_int) idf.esp_err_t;
pub const gpio_etm_task_action_t = enum(c_uint) {
    GPIO_ETM_TASK_ACTION_SET = 0,
    GPIO_ETM_TASK_ACTION_CLR = 1,
    GPIO_ETM_TASK_ACTION_TOG = 2,
};
pub const gpio_etm_task_config_t = extern struct {
    action: gpio_etm_task_action_t = std.mem.zeroes(gpio_etm_task_action_t),
};
pub extern fn gpio_new_etm_task(config: [*c]const gpio_etm_task_config_t, ret_task: [*c]esp_etm_task_handle_t) idf.esp_err_t;
pub extern fn gpio_etm_task_add_gpio(task: esp_etm_task_handle_t, gpio_num: c_int) idf.esp_err_t;
pub extern fn gpio_etm_task_rm_gpio(task: esp_etm_task_handle_t, gpio_num: c_int) idf.esp_err_t;
pub const gpio_isr_handle_t = idf.intr_handle_t;
pub const gpio_isr_t = ?*const fn (?*anyopaque) callconv(.C) void;
pub const gpio_config_t = extern struct {
    pin_bit_mask: u64 = std.mem.zeroes(u64),
    mode: idf.gpio_mode_t = std.mem.zeroes(idf.gpio_mode_t),
    pull_up_en: idf.gpio_pullup_t = std.mem.zeroes(idf.gpio_pullup_t),
    pull_down_en: idf.gpio_pulldown_t = std.mem.zeroes(idf.gpio_pulldown_t),
    intr_type: idf.gpio_int_type_t = std.mem.zeroes(idf.gpio_int_type_t),
};
pub extern fn gpio_config(pGPIOConfig: [*c]const gpio_config_t) idf.esp_err_t;
pub extern fn gpio_reset_pin(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_set_intr_type(gpio_num: idf.gpio_num_t, intr_type: idf.gpio_int_type_t) idf.esp_err_t;
pub extern fn gpio_intr_enable(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_intr_disable(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_set_level(gpio_num: idf.gpio_num_t, level: u32) idf.esp_err_t;
pub extern fn gpio_get_level(gpio_num: idf.gpio_num_t) c_int;
pub extern fn gpio_set_direction(gpio_num: idf.gpio_num_t, mode: idf.gpio_mode_t) idf.esp_err_t;
pub extern fn gpio_set_pull_mode(gpio_num: idf.gpio_num_t, pull: idf.gpio_pull_mode_t) idf.esp_err_t;
pub extern fn gpio_wakeup_enable(gpio_num: idf.gpio_num_t, intr_type: idf.gpio_int_type_t) idf.esp_err_t;
pub extern fn gpio_wakeup_disable(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_isr_register(@"fn": ?*const fn (?*anyopaque) callconv(.C) void, arg: ?*anyopaque, intr_alloc_flags: c_int, handle: [*c]gpio_isr_handle_t) idf.esp_err_t;
pub extern fn gpio_pullup_en(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_pullup_dis(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_pulldown_en(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_pulldown_dis(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_install_isr_service(intr_alloc_flags: c_int) idf.esp_err_t;
pub extern fn gpio_uninstall_isr_service() void;
pub extern fn gpio_isr_handler_add(gpio_num: idf.gpio_num_t, isr_handler: gpio_isr_t, args: ?*anyopaque) idf.esp_err_t;
pub extern fn gpio_isr_handler_remove(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_set_drive_capability(gpio_num: idf.gpio_num_t, strength: idf.gpio_drive_cap_t) idf.esp_err_t;
pub extern fn gpio_get_drive_capability(gpio_num: idf.gpio_num_t, strength: [*c]idf.gpio_drive_cap_t) idf.esp_err_t;
pub extern fn gpio_hold_en(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_hold_dis(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_deep_sleep_hold_en() void;
pub extern fn gpio_deep_sleep_hold_dis() void;
pub extern fn gpio_iomux_in(gpio_num: u32, signal_idx: u32) void;
pub extern fn gpio_iomux_out(gpio_num: u8, func: c_int, oen_inv: bool) void;
pub extern fn gpio_force_hold_all() idf.esp_err_t;
pub extern fn gpio_force_unhold_all() idf.esp_err_t;
pub extern fn gpio_sleep_sel_en(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_sleep_sel_dis(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_sleep_set_direction(gpio_num: idf.gpio_num_t, mode: idf.gpio_mode_t) idf.esp_err_t;
pub extern fn gpio_sleep_set_pull_mode(gpio_num: idf.gpio_num_t, pull: idf.gpio_pull_mode_t) idf.esp_err_t;
pub extern fn gpio_deep_sleep_wakeup_enable(gpio_num: idf.gpio_num_t, intr_type: idf.gpio_int_type_t) idf.esp_err_t;
pub extern fn gpio_deep_sleep_wakeup_disable(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_dump_io_configuration(out_stream: std.c.FILE, io_bit_mask: u64) idf.esp_err_t;

// Configs
pub const CONFIG_SOC_ADC_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_DEDICATED_GPIO_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_UART_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_GDMA_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_AHB_GDMA_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_GPTIMER_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_TWAI_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_BT_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_ASYNC_MEMCPY_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_USB_SERIAL_JTAG_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_TEMP_SENSOR_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_XT_WDT_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_WIFI_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_SUPPORTS_SECURE_DL_MODE: c_int = 1;
pub const CONFIG_SOC_EFUSE_KEY_PURPOSE_FIELD: c_int = 1;
pub const CONFIG_SOC_EFUSE_HAS_EFUSE_RST_BUG: c_int = 1;
pub const CONFIG_SOC_EFUSE_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_RTC_FAST_MEM_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_RTC_MEM_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_I2S_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_RMT_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_SDM_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_GPSPI_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_LEDC_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_I2C_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_SYSTIMER_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_SUPPORT_COEXISTENCE: c_int = 1;
pub const CONFIG_SOC_AES_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_MPI_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_SHA_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_HMAC_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_DIG_SIGN_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_FLASH_ENC_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_SECURE_BOOT_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_MEMPROT_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_BOD_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_CLK_TREE_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_ASSIST_DEBUG_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_WDT_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_SPI_FLASH_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_RNG_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_XTAL_SUPPORT_40M: c_int = 1;
pub const CONFIG_SOC_AES_SUPPORT_DMA: c_int = 1;
pub const CONFIG_SOC_AES_GDMA: c_int = 1;
pub const CONFIG_SOC_AES_SUPPORT_AES_128: c_int = 1;
pub const CONFIG_SOC_AES_SUPPORT_AES_256: c_int = 1;
pub const CONFIG_SOC_ADC_DIG_CTRL_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_ADC_ARBITER_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_ADC_DIG_IIR_FILTER_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_ADC_MONITOR_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_ADC_DMA_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_ADC_PERIPH_NUM: c_int = 2;
pub const CONFIG_SOC_ADC_MAX_CHANNEL_NUM: c_int = 5;
pub const CONFIG_SOC_ADC_ATTEN_NUM: c_int = 4;
pub const CONFIG_SOC_ADC_DIGI_CONTROLLER_NUM: c_int = 1;
pub const CONFIG_SOC_ADC_PATT_LEN_MAX: c_int = 8;
pub const CONFIG_SOC_ADC_DIGI_MIN_BITWIDTH: c_int = 12;
pub const CONFIG_SOC_ADC_DIGI_MAX_BITWIDTH: c_int = 12;
pub const CONFIG_SOC_ADC_DIGI_RESULT_BYTES: c_int = 4;
pub const CONFIG_SOC_ADC_DIGI_DATA_BYTES_PER_CONV: c_int = 4;
pub const CONFIG_SOC_ADC_DIGI_IIR_FILTER_NUM: c_int = 2;
pub const CONFIG_SOC_ADC_DIGI_MONITOR_NUM: c_int = 2;
pub const CONFIG_SOC_ADC_SAMPLE_FREQ_THRES_HIGH = std.zig.c_translation.promoteIntLiteral(c_int, 83333, .decimal);
pub const CONFIG_SOC_ADC_SAMPLE_FREQ_THRES_LOW: c_int = 611;
pub const CONFIG_SOC_ADC_RTC_MIN_BITWIDTH: c_int = 12;
pub const CONFIG_SOC_ADC_RTC_MAX_BITWIDTH: c_int = 12;
pub const CONFIG_SOC_ADC_CALIBRATION_V1_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_ADC_SELF_HW_CALI_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_ADC_SHARED_POWER: c_int = 1;
pub const CONFIG_SOC_APB_BACKUP_DMA: c_int = 1;
pub const CONFIG_SOC_BROWNOUT_RESET_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_SHARED_IDCACHE_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_CACHE_MEMORY_IBANK_SIZE: c_int = 0x4000;
pub const CONFIG_SOC_CPU_CORES_NUM: c_int = 1;
pub const CONFIG_SOC_CPU_INTR_NUM: c_int = 32;
pub const CONFIG_SOC_CPU_HAS_FLEXIBLE_INTC: c_int = 1;
pub const CONFIG_SOC_CPU_BREAKPOINTS_NUM: c_int = 8;
pub const CONFIG_SOC_CPU_WATCHPOINTS_NUM: c_int = 8;
pub const CONFIG_SOC_CPU_WATCHPOINT_MAX_REGION_SIZE = std.zig.c_translation.promoteIntLiteral(c_int, 0x80000000, .hex);
pub const CONFIG_SOC_DS_SIGNATURE_MAX_BIT_LEN: c_int = 3072;
pub const CONFIG_SOC_DS_KEY_PARAM_MD_IV_LENGTH: c_int = 16;
pub const CONFIG_SOC_DS_KEY_CHECK_MAX_WAIT_US: c_int = 1100;
pub const CONFIG_SOC_AHB_GDMA_VERSION: c_int = 1;
pub const CONFIG_SOC_GDMA_NUM_GROUPS_MAX: c_int = 1;
pub const CONFIG_SOC_GDMA_PAIRS_PER_GROUP_MAX: c_int = 3;
pub const CONFIG_SOC_GPIO_PORT: c_int = 1;
pub const CONFIG_SOC_GPIO_PIN_COUNT: c_int = 22;
pub const CONFIG_SOC_GPIO_SUPPORT_PIN_GLITCH_FILTER: c_int = 1;
pub const CONFIG_SOC_GPIO_FILTER_CLK_SUPPORT_APB: c_int = 1;
pub const CONFIG_SOC_GPIO_SUPPORT_FORCE_HOLD: c_int = 1;
pub const CONFIG_SOC_GPIO_SUPPORT_DEEPSLEEP_WAKEUP: c_int = 1;
pub const CONFIG_SOC_GPIO_IN_RANGE_MAX: c_int = 21;
pub const CONFIG_SOC_GPIO_OUT_RANGE_MAX: c_int = 21;
pub const CONFIG_SOC_GPIO_DEEP_SLEEP_WAKE_VALID_GPIO_MASK: c_int = 0;
pub const CONFIG_SOC_GPIO_VALID_DIGITAL_IO_PAD_MASK = std.zig.c_translation.promoteIntLiteral(c_int, 0x00000000003FFFC0, .hex);
pub const CONFIG_SOC_GPIO_CLOCKOUT_BY_GPIO_MATRIX: c_int = 1;
pub const CONFIG_SOC_DEDIC_GPIO_OUT_CHANNELS_NUM: c_int = 8;
pub const CONFIG_SOC_DEDIC_GPIO_IN_CHANNELS_NUM: c_int = 8;
pub const CONFIG_SOC_DEDIC_PERIPH_ALWAYS_ENABLE: c_int = 1;
pub const CONFIG_SOC_I2C_NUM: c_int = 1;
pub const CONFIG_SOC_I2C_FIFO_LEN: c_int = 32;
pub const CONFIG_SOC_I2C_CMD_REG_NUM: c_int = 8;
pub const CONFIG_SOC_I2C_SUPPORT_SLAVE: c_int = 1;
pub const CONFIG_SOC_I2C_SUPPORT_HW_CLR_BUS: c_int = 1;
pub const CONFIG_SOC_I2C_SUPPORT_XTAL: c_int = 1;
pub const CONFIG_SOC_I2C_SUPPORT_RTC: c_int = 1;
pub const CONFIG_SOC_I2C_SUPPORT_10BIT_ADDR: c_int = 1;
pub const CONFIG_SOC_I2C_SLAVE_SUPPORT_BROADCAST: c_int = 1;
pub const CONFIG_SOC_I2C_SLAVE_CAN_GET_STRETCH_CAUSE: c_int = 1;
pub const CONFIG_SOC_I2C_SLAVE_SUPPORT_I2CRAM_ACCESS: c_int = 1;
pub const CONFIG_SOC_I2S_NUM: c_int = 1;
pub const CONFIG_SOC_I2S_HW_VERSION_2: c_int = 1;
pub const CONFIG_SOC_I2S_SUPPORTS_XTAL: c_int = 1;
pub const CONFIG_SOC_I2S_SUPPORTS_PLL_F160M: c_int = 1;
pub const CONFIG_SOC_I2S_SUPPORTS_PCM: c_int = 1;
pub const CONFIG_SOC_I2S_SUPPORTS_PDM: c_int = 1;
pub const CONFIG_SOC_I2S_SUPPORTS_PDM_TX: c_int = 1;
pub const CONFIG_SOC_I2S_PDM_MAX_TX_LINES: c_int = 2;
pub const CONFIG_SOC_I2S_SUPPORTS_TDM: c_int = 1;
pub const CONFIG_SOC_LEDC_SUPPORT_APB_CLOCK: c_int = 1;
pub const CONFIG_SOC_LEDC_SUPPORT_XTAL_CLOCK: c_int = 1;
pub const CONFIG_SOC_LEDC_CHANNEL_NUM: c_int = 6;
pub const CONFIG_SOC_LEDC_TIMER_BIT_WIDTH: c_int = 14;
pub const CONFIG_SOC_LEDC_SUPPORT_FADE_STOP: c_int = 1;
pub const CONFIG_SOC_MMU_LINEAR_ADDRESS_REGION_NUM: c_int = 1;
pub const CONFIG_SOC_MMU_PERIPH_NUM: c_int = 1;
pub const CONFIG_SOC_MPU_MIN_REGION_SIZE = std.zig.c_translation.promoteIntLiteral(c_int, 0x20000000, .hex);
pub const CONFIG_SOC_MPU_REGIONS_MAX_NUM: c_int = 8;
pub const CONFIG_SOC_RMT_GROUPS: c_int = 1;
pub const CONFIG_SOC_RMT_TX_CANDIDATES_PER_GROUP: c_int = 2;
pub const CONFIG_SOC_RMT_RX_CANDIDATES_PER_GROUP: c_int = 2;
pub const CONFIG_SOC_RMT_CHANNELS_PER_GROUP: c_int = 4;
pub const CONFIG_SOC_RMT_MEM_WORDS_PER_CHANNEL: c_int = 48;
pub const CONFIG_SOC_RMT_SUPPORT_RX_PINGPONG: c_int = 1;
pub const CONFIG_SOC_RMT_SUPPORT_RX_DEMODULATION: c_int = 1;
pub const CONFIG_SOC_RMT_SUPPORT_TX_ASYNC_STOP: c_int = 1;
pub const CONFIG_SOC_RMT_SUPPORT_TX_LOOP_COUNT: c_int = 1;
pub const CONFIG_SOC_RMT_SUPPORT_TX_SYNCHRO: c_int = 1;
pub const CONFIG_SOC_RMT_SUPPORT_TX_CARRIER_DATA_ONLY: c_int = 1;
pub const CONFIG_SOC_RMT_SUPPORT_XTAL: c_int = 1;
pub const CONFIG_SOC_RMT_SUPPORT_APB: c_int = 1;
pub const CONFIG_SOC_RMT_SUPPORT_RC_FAST: c_int = 1;
pub const CONFIG_SOC_RTC_CNTL_CPU_PD_DMA_BUS_WIDTH: c_int = 128;
pub const CONFIG_SOC_RTC_CNTL_CPU_PD_REG_FILE_NUM: c_int = 108;
pub const CONFIG_SOC_RTCIO_PIN_COUNT: c_int = 0;
pub const CONFIG_SOC_MPI_MEM_BLOCKS_NUM: c_int = 4;
pub const CONFIG_SOC_MPI_OPERATIONS_NUM: c_int = 3;
pub const CONFIG_SOC_RSA_MAX_BIT_LEN: c_int = 3072;
pub const CONFIG_SOC_SHA_DMA_MAX_BUFFER_SIZE: c_int = 3968;
pub const CONFIG_SOC_SHA_SUPPORT_DMA: c_int = 1;
pub const CONFIG_SOC_SHA_SUPPORT_RESUME: c_int = 1;
pub const CONFIG_SOC_SHA_GDMA: c_int = 1;
pub const CONFIG_SOC_SHA_SUPPORT_SHA1: c_int = 1;
pub const CONFIG_SOC_SHA_SUPPORT_SHA224: c_int = 1;
pub const CONFIG_SOC_SHA_SUPPORT_SHA256: c_int = 1;
pub const CONFIG_SOC_SDM_GROUPS: c_int = 1;
pub const CONFIG_SOC_SDM_CHANNELS_PER_GROUP: c_int = 4;
pub const CONFIG_SOC_SDM_CLK_SUPPORT_APB: c_int = 1;
pub const CONFIG_SOC_SPI_PERIPH_NUM: c_int = 2;
pub const CONFIG_SOC_SPI_MAX_CS_NUM: c_int = 6;
pub const CONFIG_SOC_SPI_MAXIMUM_BUFFER_SIZE: c_int = 64;
pub const CONFIG_SOC_SPI_SUPPORT_DDRCLK: c_int = 1;
pub const CONFIG_SOC_SPI_SLAVE_SUPPORT_SEG_TRANS: c_int = 1;
pub const CONFIG_SOC_SPI_SUPPORT_CD_SIG: c_int = 1;
pub const CONFIG_SOC_SPI_SUPPORT_CONTINUOUS_TRANS: c_int = 1;
pub const CONFIG_SOC_SPI_SUPPORT_SLAVE_HD_VER2: c_int = 1;
pub const CONFIG_SOC_SPI_SUPPORT_CLK_APB: c_int = 1;
pub const CONFIG_SOC_SPI_SUPPORT_CLK_XTAL: c_int = 1;
pub const CONFIG_SOC_SPI_PERIPH_SUPPORT_CONTROL_DUMMY_OUT: c_int = 1;
pub const CONFIG_SOC_MEMSPI_IS_INDEPENDENT: c_int = 1;
pub const CONFIG_SOC_SPI_MAX_PRE_DIVIDER: c_int = 16;
pub const CONFIG_SOC_SPI_MEM_SUPPORT_AUTO_WAIT_IDLE: c_int = 1;
pub const CONFIG_SOC_SPI_MEM_SUPPORT_AUTO_SUSPEND: c_int = 1;
pub const CONFIG_SOC_SPI_MEM_SUPPORT_AUTO_RESUME: c_int = 1;
pub const CONFIG_SOC_SPI_MEM_SUPPORT_IDLE_INTR: c_int = 1;
pub const CONFIG_SOC_SPI_MEM_SUPPORT_SW_SUSPEND: c_int = 1;
pub const CONFIG_SOC_SPI_MEM_SUPPORT_CHECK_SUS: c_int = 1;
pub const CONFIG_SOC_SPI_MEM_SUPPORT_CONFIG_GPIO_BY_EFUSE: c_int = 1;
pub const CONFIG_SOC_SPI_MEM_SUPPORT_WRAP: c_int = 1;
pub const CONFIG_SOC_MEMSPI_SRC_FREQ_80M_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_MEMSPI_SRC_FREQ_40M_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_MEMSPI_SRC_FREQ_26M_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_MEMSPI_SRC_FREQ_20M_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_SYSTIMER_COUNTER_NUM: c_int = 2;
pub const CONFIG_SOC_SYSTIMER_ALARM_NUM: c_int = 3;
pub const CONFIG_SOC_SYSTIMER_BIT_WIDTH_LO: c_int = 32;
pub const CONFIG_SOC_SYSTIMER_BIT_WIDTH_HI: c_int = 20;
pub const CONFIG_SOC_SYSTIMER_FIXED_DIVIDER: c_int = 1;
pub const CONFIG_SOC_SYSTIMER_INT_LEVEL: c_int = 1;
pub const CONFIG_SOC_SYSTIMER_ALARM_MISS_COMPENSATE: c_int = 1;
pub const CONFIG_SOC_TIMER_GROUPS: c_int = 2;
pub const CONFIG_SOC_TIMER_GROUP_TIMERS_PER_GROUP: c_int = 1;
pub const CONFIG_SOC_TIMER_GROUP_COUNTER_BIT_WIDTH: c_int = 54;
pub const CONFIG_SOC_TIMER_GROUP_SUPPORT_XTAL: c_int = 1;
pub const CONFIG_SOC_TIMER_GROUP_SUPPORT_APB: c_int = 1;
pub const CONFIG_SOC_TIMER_GROUP_TOTAL_TIMERS: c_int = 2;
pub const CONFIG_SOC_MWDT_SUPPORT_XTAL: c_int = 1;
pub const CONFIG_SOC_TWAI_CONTROLLER_NUM: c_int = 1;
pub const CONFIG_SOC_TWAI_CLK_SUPPORT_APB: c_int = 1;
pub const CONFIG_SOC_TWAI_BRP_MIN: c_int = 2;
pub const CONFIG_SOC_TWAI_BRP_MAX: c_int = 16384;
pub const CONFIG_SOC_TWAI_SUPPORTS_RX_STATUS: c_int = 1;
pub const CONFIG_SOC_EFUSE_DIS_DOWNLOAD_ICACHE: c_int = 1;
pub const CONFIG_SOC_EFUSE_DIS_PAD_JTAG: c_int = 1;
pub const CONFIG_SOC_EFUSE_DIS_USB_JTAG: c_int = 1;
pub const CONFIG_SOC_EFUSE_DIS_DIRECT_BOOT: c_int = 1;
pub const CONFIG_SOC_EFUSE_SOFT_DIS_JTAG: c_int = 1;
pub const CONFIG_SOC_EFUSE_DIS_ICACHE: c_int = 1;
pub const CONFIG_SOC_EFUSE_BLOCK9_KEY_PURPOSE_QUIRK: c_int = 1;
pub const CONFIG_SOC_SECURE_BOOT_V2_RSA: c_int = 1;
pub const CONFIG_SOC_EFUSE_SECURE_BOOT_KEY_DIGESTS: c_int = 3;
pub const CONFIG_SOC_EFUSE_REVOKE_BOOT_KEY_DIGESTS: c_int = 1;
pub const CONFIG_SOC_SUPPORT_SECURE_BOOT_REVOKE_KEY: c_int = 1;
pub const CONFIG_SOC_FLASH_ENCRYPTED_XTS_AES_BLOCK_MAX: c_int = 32;
pub const CONFIG_SOC_FLASH_ENCRYPTION_XTS_AES: c_int = 1;
pub const CONFIG_SOC_FLASH_ENCRYPTION_XTS_AES_128: c_int = 1;
pub const CONFIG_SOC_MEMPROT_CPU_PREFETCH_PAD_SIZE: c_int = 16;
pub const CONFIG_SOC_MEMPROT_MEM_ALIGN_SIZE: c_int = 512;
pub const CONFIG_SOC_UART_NUM: c_int = 2;
pub const CONFIG_SOC_UART_HP_NUM: c_int = 2;
pub const CONFIG_SOC_UART_FIFO_LEN: c_int = 128;
pub const CONFIG_SOC_UART_BITRATE_MAX = std.zig.c_translation.promoteIntLiteral(c_int, 5000000, .decimal);
pub const CONFIG_SOC_UART_SUPPORT_APB_CLK: c_int = 1;
pub const CONFIG_SOC_UART_SUPPORT_RTC_CLK: c_int = 1;
pub const CONFIG_SOC_UART_SUPPORT_XTAL_CLK: c_int = 1;
pub const CONFIG_SOC_UART_SUPPORT_WAKEUP_INT: c_int = 1;
pub const CONFIG_SOC_UART_SUPPORT_FSM_TX_WAIT_SEND: c_int = 1;
pub const CONFIG_SOC_COEX_HW_PTI: c_int = 1;
pub const CONFIG_SOC_PHY_DIG_REGS_MEM_SIZE: c_int = 21;
pub const CONFIG_SOC_MAC_BB_PD_MEM_SIZE: c_int = 192;
pub const CONFIG_SOC_WIFI_LIGHT_SLEEP_CLK_WIDTH: c_int = 12;
pub const CONFIG_SOC_PM_SUPPORT_WIFI_WAKEUP: c_int = 1;
pub const CONFIG_SOC_PM_SUPPORT_BT_WAKEUP: c_int = 1;
pub const CONFIG_SOC_PM_SUPPORT_CPU_PD: c_int = 1;
pub const CONFIG_SOC_PM_SUPPORT_WIFI_PD: c_int = 1;
pub const CONFIG_SOC_PM_SUPPORT_BT_PD: c_int = 1;
pub const CONFIG_SOC_PM_SUPPORT_RC_FAST_PD: c_int = 1;
pub const CONFIG_SOC_PM_SUPPORT_VDDSDIO_PD: c_int = 1;
pub const CONFIG_SOC_PM_SUPPORT_MAC_BB_PD: c_int = 1;
pub const CONFIG_SOC_PM_CPU_RETENTION_BY_RTCCNTL: c_int = 1;
pub const CONFIG_SOC_PM_MODEM_RETENTION_BY_BACKUPDMA: c_int = 1;
pub const CONFIG_SOC_CLK_RC_FAST_D256_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_RTC_SLOW_CLK_SUPPORT_RC_FAST_D256: c_int = 1;
pub const CONFIG_SOC_CLK_RC_FAST_SUPPORT_CALIBRATION: c_int = 1;
pub const CONFIG_SOC_CLK_XTAL32K_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_TEMPERATURE_SENSOR_SUPPORT_FAST_RC: c_int = 1;
pub const CONFIG_SOC_TEMPERATURE_SENSOR_SUPPORT_XTAL: c_int = 1;
pub const CONFIG_SOC_WIFI_HW_TSF: c_int = 1;
pub const CONFIG_SOC_WIFI_FTM_SUPPORT: c_int = 1;
pub const CONFIG_SOC_WIFI_GCMP_SUPPORT: c_int = 1;
pub const CONFIG_SOC_WIFI_WAPI_SUPPORT: c_int = 1;
pub const CONFIG_SOC_WIFI_CSI_SUPPORT: c_int = 1;
pub const CONFIG_SOC_WIFI_MESH_SUPPORT: c_int = 1;
pub const CONFIG_SOC_WIFI_SUPPORT_VARIABLE_BEACON_WINDOW: c_int = 1;
pub const CONFIG_SOC_BLE_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_BLE_MESH_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_BLE_50_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_BLE_DEVICE_PRIVACY_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_BLUFI_SUPPORTED: c_int = 1;
pub const CONFIG_SOC_PHY_COMBO_MODULE: c_int = 1;
pub const CONFIG_IDF_CMAKE: c_int = 1;
pub const CONFIG_IDF_FIRMWARE_CHIP_ID: c_int = 0x0005;
pub const CONFIG_APP_BUILD_TYPE_APP_2NDBOOT: c_int = 1;
pub const CONFIG_APP_BUILD_GENERATE_BINARIES: c_int = 1;
pub const CONFIG_APP_BUILD_BOOTLOADER: c_int = 1;
pub const CONFIG_APP_BUILD_USE_FLASH_SECTIONS: c_int = 1;
pub const CONFIG_BOOTLOADER_COMPILE_TIME_DATE: c_int = 1;
pub const CONFIG_BOOTLOADER_PROJECT_VER: c_int = 1;
pub const CONFIG_BOOTLOADER_OFFSET_IN_FLASH: c_int = 0x0;
pub const CONFIG_BOOTLOADER_COMPILER_OPTIMIZATION_SIZE: c_int = 1;
pub const CONFIG_BOOTLOADER_LOG_LEVEL_INFO: c_int = 1;
pub const CONFIG_BOOTLOADER_LOG_LEVEL: c_int = 3;
pub const CONFIG_BOOTLOADER_FLASH_XMC_SUPPORT: c_int = 1;
pub const CONFIG_BOOTLOADER_REGION_PROTECTION_ENABLE: c_int = 1;
pub const CONFIG_BOOTLOADER_WDT_ENABLE: c_int = 1;
pub const CONFIG_BOOTLOADER_WDT_TIME_MS: c_int = 9000;
pub const CONFIG_BOOTLOADER_RESERVE_RTC_SIZE: c_int = 0x0;
pub const CONFIG_SECURE_BOOT_V2_RSA_SUPPORTED: c_int = 1;
pub const CONFIG_SECURE_BOOT_V2_PREFERRED: c_int = 1;
pub const CONFIG_SECURE_ROM_DL_MODE_ENABLED: c_int = 1;
pub const CONFIG_APP_COMPILE_TIME_DATE: c_int = 1;
pub const CONFIG_APP_RETRIEVE_LEN_ELF_SHA: c_int = 9;
pub const CONFIG_ESP_ROM_HAS_CRC_LE: c_int = 1;
pub const CONFIG_ESP_ROM_HAS_CRC_BE: c_int = 1;
pub const CONFIG_ESP_ROM_HAS_MZ_CRC32: c_int = 1;
pub const CONFIG_ESP_ROM_HAS_JPEG_DECODE: c_int = 1;
pub const CONFIG_ESP_ROM_UART_CLK_IS_XTAL: c_int = 1;
pub const CONFIG_ESP_ROM_USB_SERIAL_DEVICE_NUM: c_int = 3;
pub const CONFIG_ESP_ROM_HAS_RETARGETABLE_LOCKING: c_int = 1;
pub const CONFIG_ESP_ROM_HAS_ERASE_0_REGION_BUG: c_int = 1;
pub const CONFIG_ESP_ROM_GET_CLK_FREQ: c_int = 1;
pub const CONFIG_ESP_ROM_NEEDS_SWSETUP_WORKAROUND: c_int = 1;
pub const CONFIG_ESP_ROM_HAS_LAYOUT_TABLE: c_int = 1;
pub const CONFIG_ESP_ROM_HAS_SPI_FLASH: c_int = 1;
pub const CONFIG_ESP_ROM_HAS_ETS_PRINTF_BUG: c_int = 1;
pub const CONFIG_ESP_ROM_HAS_NEWLIB_NANO_FORMAT: c_int = 1;
pub const CONFIG_ESP_ROM_NEEDS_SET_CACHE_MMU_SIZE: c_int = 1;
pub const CONFIG_ESP_ROM_RAM_APP_NEEDS_MMU_INIT: c_int = 1;
pub const CONFIG_ESP_ROM_HAS_SW_FLOAT: c_int = 1;
pub const CONFIG_ESP_ROM_USB_OTG_NUM: c_int = -1;
pub const CONFIG_BOOT_ROM_LOG_ALWAYS_ON: c_int = 1;
pub const CONFIG_ESPTOOLPY_FLASHMODE_DIO: c_int = 1;
pub const CONFIG_ESPTOOLPY_FLASH_SAMPLE_MODE_STR: c_int = 1;
pub const CONFIG_ESPTOOLPY_FLASHMODE = "dio";
pub const CONFIG_ESPTOOLPY_FLASHFREQ_80M: c_int = 1;
pub const CONFIG_ESPTOOLPY_FLASHFREQ_80M_DEFAULT: c_int = 1;
pub const CONFIG_ESPTOOLPY_FLASHFREQ = "80m";
pub const CONFIG_ESPTOOLPY_FLASHSIZE_2MB: c_int = 1;
pub const CONFIG_ESPTOOLPY_FLASHSIZE = "2MB";
pub const CONFIG_ESPTOOLPY_BEFORE_RESET: c_int = 1;
pub const CONFIG_ESPTOOLPY_BEFORE = "default_reset";
pub const CONFIG_ESPTOOLPY_AFTER_RESET: c_int = 1;
pub const CONFIG_ESPTOOLPY_AFTER = "hard_reset";
pub const CONFIG_ESPTOOLPY_MONITOR_BAUD = std.zig.c_translation.promoteIntLiteral(c_int, 115200, .decimal);
pub const CONFIG_PARTITION_TABLE_SINGLE_APP: c_int = 1;
pub const CONFIG_PARTITION_TABLE_OFFSET = std.zig.c_translation.promoteIntLiteral(c_int, 0x8000, .hex);
pub const CONFIG_PARTITION_TABLE_MD5: c_int = 1;
pub const CONFIG_ENV_GPIO_RANGE_MIN: c_int = 0;
pub const CONFIG_ENV_GPIO_RANGE_MAX: c_int = 19;
pub const CONFIG_ENV_GPIO_IN_RANGE_MAX: c_int = 19;
pub const CONFIG_ENV_GPIO_OUT_RANGE_MAX: c_int = 19;
pub const CONFIG_BLINK_LED_GPIO: c_int = 1;
pub const CONFIG_BLINK_GPIO: c_int = 8;
pub const CONFIG_BLINK_PERIOD: c_int = 1000;
pub const CONFIG_COMPILER_OPTIMIZATION_DEBUG: c_int = 1;
pub const CONFIG_COMPILER_OPTIMIZATION_ASSERTIONS_ENABLE: c_int = 1;
pub const CONFIG_COMPILER_FLOAT_LIB_FROM_GCCLIB: c_int = 1;
pub const CONFIG_COMPILER_OPTIMIZATION_ASSERTION_LEVEL: c_int = 2;
pub const CONFIG_COMPILER_HIDE_PATHS_MACROS: c_int = 1;
pub const CONFIG_COMPILER_STACK_CHECK_MODE_NONE: c_int = 1;
pub const CONFIG_COMPILER_RT_LIB_GCCLIB: c_int = 1;
pub const CONFIG_COMPILER_RT_LIB_NAME = "gcc";
pub const CONFIG_APPTRACE_DEST_NONE: c_int = 1;
pub const CONFIG_APPTRACE_DEST_UART_NONE: c_int = 1;
pub const CONFIG_APPTRACE_UART_TASK_PRIO: c_int = 1;
pub const CONFIG_APPTRACE_LOCK_ENABLE: c_int = 1;
pub const CONFIG_TWAI_ERRATA_FIX_LISTEN_ONLY_DOM: c_int = 1;
pub const CONFIG_EFUSE_MAX_BLK_LEN: c_int = 256;
pub const CONFIG_ESP_TLS_USING_MBEDTLS: c_int = 1;
pub const CONFIG_ESP_TLS_USE_DS_PERIPHERAL: c_int = 1;
pub const CONFIG_ESP_ERR_TO_NAME_LOOKUP: c_int = 1;
pub const CONFIG_GPTIMER_ISR_HANDLER_IN_IRAM: c_int = 1;
pub const CONFIG_SPI_MASTER_ISR_IN_IRAM: c_int = 1;
pub const CONFIG_SPI_SLAVE_ISR_IN_IRAM: c_int = 1;
pub const CONFIG_ETH_ENABLED: c_int = 1;
pub const CONFIG_ETH_USE_SPI_ETHERNET: c_int = 1;
pub const CONFIG_ESP_EVENT_POST_FROM_ISR: c_int = 1;
pub const CONFIG_ESP_EVENT_POST_FROM_IRAM_ISR: c_int = 1;
pub const CONFIG_ESP_HTTP_CLIENT_ENABLE_HTTPS: c_int = 1;
pub const CONFIG_HTTPD_MAX_REQ_HDR_LEN: c_int = 512;
pub const CONFIG_HTTPD_MAX_URI_LEN: c_int = 512;
pub const CONFIG_HTTPD_ERR_RESP_NO_DELAY: c_int = 1;
pub const CONFIG_HTTPD_PURGE_BUF_LEN: c_int = 32;
pub const CONFIG_ESP32C3_REV_MIN_3: c_int = 1;
pub const CONFIG_ESP32C3_REV_MIN_FULL: c_int = 3;
pub const CONFIG_ESP_REV_MIN_FULL: c_int = 3;
pub const CONFIG_ESP32C3_REV_MAX_FULL: c_int = 199;
pub const CONFIG_ESP_REV_MAX_FULL: c_int = 199;
pub const CONFIG_ESP_MAC_ADDR_UNIVERSE_WIFI_STA: c_int = 1;
pub const CONFIG_ESP_MAC_ADDR_UNIVERSE_WIFI_AP: c_int = 1;
pub const CONFIG_ESP_MAC_ADDR_UNIVERSE_BT: c_int = 1;
pub const CONFIG_ESP_MAC_ADDR_UNIVERSE_ETH: c_int = 1;
pub const CONFIG_ESP_MAC_UNIVERSAL_MAC_ADDRESSES_FOUR: c_int = 1;
pub const CONFIG_ESP32C3_UNIVERSAL_MAC_ADDRESSES_FOUR: c_int = 1;
pub const CONFIG_ESP32C3_UNIVERSAL_MAC_ADDRESSES: c_int = 4;
pub const CONFIG_ESP_SLEEP_FLASH_LEAKAGE_WORKAROUND: c_int = 1;
pub const CONFIG_ESP_SLEEP_GPIO_RESET_WORKAROUND: c_int = 1;
pub const CONFIG_ESP_SLEEP_WAIT_FLASH_READY_EXTRA_DELAY: c_int = 0;
pub const CONFIG_ESP_SLEEP_GPIO_ENABLE_INTERNAL_RESISTORS: c_int = 1;
pub const CONFIG_ESP_SLEEP_SYSTIMER_STALL_WORKAROUND: c_int = 1;
pub const CONFIG_RTC_CLK_SRC_INT_RC: c_int = 1;
pub const CONFIG_RTC_CLK_CAL_CYCLES: c_int = 1024;
pub const CONFIG_PERIPH_CTRL_FUNC_IN_IRAM: c_int = 1;
pub const CONFIG_GDMA_CTRL_FUNC_IN_IRAM: c_int = 1;
pub const CONFIG_XTAL_FREQ_40: c_int = 1;
pub const CONFIG_XTAL_FREQ: c_int = 40;
pub const CONFIG_ESP_SPI_BUS_LOCK_ISR_FUNCS_IN_IRAM: c_int = 1;
pub const CONFIG_ESP_NETIF_IP_LOST_TIMER_INTERVAL: c_int = 120;
pub const CONFIG_ESP_NETIF_TCPIP_LWIP: c_int = 1;
pub const CONFIG_ESP_NETIF_USES_TCPIP_WITH_BSD_API: c_int = 1;
pub const CONFIG_ESP_PHY_CALIBRATION_AND_DATA_STORAGE: c_int = 1;
pub const CONFIG_ESP_PHY_MAX_WIFI_TX_POWER: c_int = 20;
pub const CONFIG_ESP_PHY_MAX_TX_POWER: c_int = 20;
pub const CONFIG_ESP_PHY_ENABLE_USB: c_int = 1;
pub const CONFIG_ESP_PHY_RF_CAL_PARTIAL: c_int = 1;
pub const CONFIG_ESP_PHY_CALIBRATION_MODE: c_int = 0;
pub const CONFIG_PM_POWER_DOWN_CPU_IN_LIGHT_SLEEP: c_int = 1;
pub const CONFIG_ESP_DEFAULT_CPU_FREQ_MHZ_160: c_int = 1;
pub const CONFIG_ESP_DEFAULT_CPU_FREQ_MHZ: c_int = 160;
pub const CONFIG_ESP_SYSTEM_PANIC_PRINT_REBOOT: c_int = 1;
pub const CONFIG_ESP_SYSTEM_PANIC_REBOOT_DELAY_SECONDS: c_int = 0;
pub const CONFIG_ESP_SYSTEM_SINGLE_CORE_MODE: c_int = 1;
pub const CONFIG_ESP_SYSTEM_RTC_FAST_MEM_AS_HEAP_DEPCHECK: c_int = 1;
pub const CONFIG_ESP_SYSTEM_ALLOW_RTC_FAST_MEM_AS_HEAP: c_int = 1;
pub const CONFIG_ESP_SYSTEM_MEMPROT_FEATURE: c_int = 1;
pub const CONFIG_ESP_SYSTEM_MEMPROT_FEATURE_LOCK: c_int = 1;
pub const CONFIG_ESP_SYSTEM_EVENT_QUEUE_SIZE: c_int = 32;
pub const CONFIG_ESP_SYSTEM_EVENT_TASK_STACK_SIZE: c_int = 2304;
pub const CONFIG_ESP_MAIN_TASK_STACK_SIZE: c_int = 3584;
pub const CONFIG_ESP_MAIN_TASK_AFFINITY_CPU0: c_int = 1;
pub const CONFIG_ESP_MAIN_TASK_AFFINITY: c_int = 0x0;
pub const CONFIG_ESP_MINIMAL_SHARED_STACK_SIZE: c_int = 2048;
pub const CONFIG_ESP_CONSOLE_UART_DEFAULT: c_int = 1;
pub const CONFIG_ESP_CONSOLE_SECONDARY_USB_SERIAL_JTAG: c_int = 1;
pub const CONFIG_ESP_CONSOLE_USB_SERIAL_JTAG_ENABLED: c_int = 1;
pub const CONFIG_ESP_CONSOLE_UART: c_int = 1;
pub const CONFIG_ESP_CONSOLE_UART_NUM: c_int = 0;
pub const CONFIG_ESP_CONSOLE_ROM_SERIAL_PORT_NUM: c_int = 0;
pub const CONFIG_ESP_CONSOLE_UART_BAUDRATE = std.zig.c_translation.promoteIntLiteral(c_int, 115200, .decimal);
pub const CONFIG_ESP_INT_WDT: c_int = 1;
pub const CONFIG_ESP_INT_WDT_TIMEOUT_MS: c_int = 300;
pub const CONFIG_ESP_TASK_WDT_EN: c_int = 1;
pub const CONFIG_ESP_TASK_WDT_INIT: c_int = 1;
pub const CONFIG_ESP_TASK_WDT_TIMEOUT_S: c_int = 5;
pub const CONFIG_ESP_TASK_WDT_CHECK_IDLE_TASK_CPU0: c_int = 1;
pub const CONFIG_ESP_DEBUG_OCDAWARE: c_int = 1;
pub const CONFIG_ESP_SYSTEM_CHECK_INT_LEVEL_4: c_int = 1;
pub const CONFIG_ESP_BROWNOUT_DET: c_int = 1;
pub const CONFIG_ESP_BROWNOUT_DET_LVL_SEL_7: c_int = 1;
pub const CONFIG_ESP_BROWNOUT_DET_LVL: c_int = 7;
pub const CONFIG_ESP_SYSTEM_BROWNOUT_INTR: c_int = 1;
pub const CONFIG_ESP_SYSTEM_HW_STACK_GUARD: c_int = 1;
pub const CONFIG_ESP_IPC_TASK_STACK_SIZE: c_int = 1024;
pub const CONFIG_ESP_TIME_FUNCS_USE_RTC_TIMER: c_int = 1;
pub const CONFIG_ESP_TIME_FUNCS_USE_ESP_TIMER: c_int = 1;
pub const CONFIG_ESP_TIMER_TASK_STACK_SIZE: c_int = 3584;
pub const CONFIG_ESP_TIMER_INTERRUPT_LEVEL: c_int = 1;
pub const CONFIG_ESP_TIMER_TASK_AFFINITY: c_int = 0x0;
pub const CONFIG_ESP_TIMER_TASK_AFFINITY_CPU0: c_int = 1;
pub const CONFIG_ESP_TIMER_ISR_AFFINITY_CPU0: c_int = 1;
pub const CONFIG_ESP_TIMER_IMPL_SYSTIMER: c_int = 1;
pub const CONFIG_ESP_WIFI_ENABLED: c_int = 1;
pub const CONFIG_ESP_WIFI_STATIC_RX_BUFFER_NUM: c_int = 10;
pub const CONFIG_ESP_WIFI_DYNAMIC_RX_BUFFER_NUM: c_int = 32;
pub const CONFIG_ESP_WIFI_DYNAMIC_TX_BUFFER: c_int = 1;
pub const CONFIG_ESP_WIFI_TX_BUFFER_TYPE: c_int = 1;
pub const CONFIG_ESP_WIFI_DYNAMIC_TX_BUFFER_NUM: c_int = 32;
pub const CONFIG_ESP_WIFI_STATIC_RX_MGMT_BUFFER: c_int = 1;
pub const CONFIG_ESP_WIFI_DYNAMIC_RX_MGMT_BUF: c_int = 0;
pub const CONFIG_ESP_WIFI_RX_MGMT_BUF_NUM_DEF: c_int = 5;
pub const CONFIG_ESP_WIFI_AMPDU_TX_ENABLED: c_int = 1;
pub const CONFIG_ESP_WIFI_TX_BA_WIN: c_int = 6;
pub const CONFIG_ESP_WIFI_AMPDU_RX_ENABLED: c_int = 1;
pub const CONFIG_ESP_WIFI_RX_BA_WIN: c_int = 6;
pub const CONFIG_ESP_WIFI_NVS_ENABLED: c_int = 1;
pub const CONFIG_ESP_WIFI_SOFTAP_BEACON_MAX_LEN: c_int = 752;
pub const CONFIG_ESP_WIFI_MGMT_SBUF_NUM: c_int = 32;
pub const CONFIG_ESP_WIFI_IRAM_OPT: c_int = 1;
pub const CONFIG_ESP_WIFI_RX_IRAM_OPT: c_int = 1;
pub const CONFIG_ESP_WIFI_ENABLE_WPA3_SAE: c_int = 1;
pub const CONFIG_ESP_WIFI_ENABLE_SAE_PK: c_int = 1;
pub const CONFIG_ESP_WIFI_SOFTAP_SAE_SUPPORT: c_int = 1;
pub const CONFIG_ESP_WIFI_ENABLE_WPA3_OWE_STA: c_int = 1;
pub const CONFIG_ESP_WIFI_STA_DISCONNECTED_PM_ENABLE: c_int = 1;
pub const CONFIG_ESP_WIFI_SOFTAP_SUPPORT: c_int = 1;
pub const CONFIG_ESP_WIFI_ESPNOW_MAX_ENCRYPT_NUM: c_int = 7;
pub const CONFIG_ESP_WIFI_MBEDTLS_CRYPTO: c_int = 1;
pub const CONFIG_ESP_WIFI_MBEDTLS_TLS_CLIENT: c_int = 1;
pub const CONFIG_ESP_WIFI_ENTERPRISE_SUPPORT: c_int = 1;
pub const CONFIG_ESP_COREDUMP_ENABLE_TO_NONE: c_int = 1;
pub const CONFIG_FATFS_VOLUME_COUNT: c_int = 2;
pub const CONFIG_FATFS_LFN_NONE: c_int = 1;
pub const CONFIG_FATFS_SECTOR_4096: c_int = 1;
pub const CONFIG_FATFS_CODEPAGE_437: c_int = 1;
pub const CONFIG_FATFS_CODEPAGE: c_int = 437;
pub const CONFIG_FATFS_FS_LOCK: c_int = 0;
pub const CONFIG_FATFS_TIMEOUT_MS: c_int = 10000;
pub const CONFIG_FATFS_PER_FILE_CACHE: c_int = 1;
pub const CONFIG_FATFS_VFS_FSTAT_BLKSIZE: c_int = 0;
pub const CONFIG_FATFS_LINK_LOCK: c_int = 1;
pub const CONFIG_FREERTOS_UNICORE: c_int = 1;
pub const CONFIG_FREERTOS_HZ: c_int = 100;
pub const CONFIG_FREERTOS_OPTIMIZED_SCHEDULER: c_int = 1;
pub const CONFIG_FREERTOS_CHECK_STACKOVERFLOW_CANARY: c_int = 1;
pub const CONFIG_FREERTOS_THREAD_LOCAL_STORAGE_POINTERS: c_int = 1;
pub const CONFIG_FREERTOS_IDLE_TASK_STACKSIZE: c_int = 1536;
pub const CONFIG_FREERTOS_MAX_TASK_NAME_LEN: c_int = 16;
pub const CONFIG_FREERTOS_TIMER_SERVICE_TASK_NAME = "Tmr Svc";
pub const CONFIG_FREERTOS_TIMER_TASK_NO_AFFINITY: c_int = 1;
pub const CONFIG_FREERTOS_TIMER_SERVICE_TASK_CORE_AFFINITY = std.zig.c_translation.promoteIntLiteral(c_int, 0x7FFFFFFF, .hex);
pub const CONFIG_FREERTOS_TIMER_TASK_PRIORITY: c_int = 1;
pub const CONFIG_FREERTOS_TIMER_TASK_STACK_DEPTH: c_int = 2048;
pub const CONFIG_FREERTOS_TIMER_QUEUE_LENGTH: c_int = 10;
pub const CONFIG_FREERTOS_QUEUE_REGISTRY_SIZE: c_int = 0;
pub const CONFIG_FREERTOS_TASK_NOTIFICATION_ARRAY_ENTRIES: c_int = 1;
pub const CONFIG_FREERTOS_TASK_FUNCTION_WRAPPER: c_int = 1;
pub const CONFIG_FREERTOS_TLSP_DELETION_CALLBACKS: c_int = 1;
pub const CONFIG_FREERTOS_CHECK_MUTEX_GIVEN_BY_OWNER: c_int = 1;
pub const CONFIG_FREERTOS_ISR_STACKSIZE: c_int = 1536;
pub const CONFIG_FREERTOS_INTERRUPT_BACKTRACE: c_int = 1;
pub const CONFIG_FREERTOS_TICK_SUPPORT_SYSTIMER: c_int = 1;
pub const CONFIG_FREERTOS_CORETIMER_SYSTIMER_LVL1: c_int = 1;
pub const CONFIG_FREERTOS_SYSTICK_USES_SYSTIMER: c_int = 1;
pub const CONFIG_FREERTOS_PORT: c_int = 1;
pub const CONFIG_FREERTOS_NO_AFFINITY = std.zig.c_translation.promoteIntLiteral(c_int, 0x7FFFFFFF, .hex);
pub const CONFIG_FREERTOS_SUPPORT_STATIC_ALLOCATION: c_int = 1;
pub const CONFIG_FREERTOS_DEBUG_OCDAWARE: c_int = 1;
pub const CONFIG_FREERTOS_ENABLE_TASK_SNAPSHOT: c_int = 1;
pub const CONFIG_FREERTOS_PLACE_SNAPSHOT_FUNS_INTO_FLASH: c_int = 1;
pub const CONFIG_HAL_ASSERTION_EQUALS_SYSTEM: c_int = 1;
pub const CONFIG_HAL_DEFAULT_ASSERTION_LEVEL: c_int = 2;
pub const CONFIG_HAL_SPI_MASTER_FUNC_IN_IRAM: c_int = 1;
pub const CONFIG_HAL_SPI_SLAVE_FUNC_IN_IRAM: c_int = 1;
pub const CONFIG_HEAP_POISONING_DISABLED: c_int = 1;
pub const CONFIG_HEAP_TRACING_OFF: c_int = 1;
pub const CONFIG_LOG_DEFAULT_LEVEL_INFO: c_int = 1;
pub const CONFIG_LOG_DEFAULT_LEVEL: c_int = 3;
pub const CONFIG_LOG_MAXIMUM_EQUALS_DEFAULT: c_int = 1;
pub const CONFIG_LOG_MAXIMUM_LEVEL: c_int = 3;
pub const CONFIG_LOG_COLORS: c_int = 1;
pub const CONFIG_LOG_TIMESTAMP_SOURCE_RTOS: c_int = 1;
pub const CONFIG_LWIP_ENABLE: c_int = 1;
pub const CONFIG_LWIP_LOCAL_HOSTNAME = "espressif";
pub const CONFIG_LWIP_TCPIP_TASK_PRIO: c_int = 18;
pub const CONFIG_LWIP_DNS_SUPPORT_MDNS_QUERIES: c_int = 1;
pub const CONFIG_LWIP_TIMERS_ONDEMAND: c_int = 1;
pub const CONFIG_LWIP_ND6: c_int = 1;
pub const CONFIG_LWIP_MAX_SOCKETS: c_int = 10;
pub const CONFIG_LWIP_SO_REUSE: c_int = 1;
pub const CONFIG_LWIP_SO_REUSE_RXTOALL: c_int = 1;
pub const CONFIG_LWIP_IP_DEFAULT_TTL: c_int = 64;
pub const CONFIG_LWIP_IP4_FRAG: c_int = 1;
pub const CONFIG_LWIP_IP6_FRAG: c_int = 1;
pub const CONFIG_LWIP_IP_REASS_MAX_PBUFS: c_int = 10;
pub const CONFIG_LWIP_ESP_GRATUITOUS_ARP: c_int = 1;
pub const CONFIG_LWIP_GARP_TMR_INTERVAL: c_int = 60;
pub const CONFIG_LWIP_ESP_MLDV6_REPORT: c_int = 1;
pub const CONFIG_LWIP_MLDV6_TMR_INTERVAL: c_int = 40;
pub const CONFIG_LWIP_TCPIP_RECVMBOX_SIZE: c_int = 32;
pub const CONFIG_LWIP_DHCP_DOES_ARP_CHECK: c_int = 1;
pub const CONFIG_LWIP_DHCP_DISABLE_VENDOR_CLASS_ID: c_int = 1;
pub const CONFIG_LWIP_DHCP_OPTIONS_LEN: c_int = 68;
pub const CONFIG_LWIP_NUM_NETIF_CLIENT_DATA: c_int = 0;
pub const CONFIG_LWIP_DHCP_COARSE_TIMER_SECS: c_int = 1;
pub const CONFIG_LWIP_DHCPS: c_int = 1;
pub const CONFIG_LWIP_DHCPS_LEASE_UNIT: c_int = 60;
pub const CONFIG_LWIP_DHCPS_MAX_STATION_NUM: c_int = 8;
pub const CONFIG_LWIP_DHCPS_STATIC_ENTRIES: c_int = 1;
pub const CONFIG_LWIP_IPV4: c_int = 1;
pub const CONFIG_LWIP_IPV6: c_int = 1;
pub const CONFIG_LWIP_IPV6_NUM_ADDRESSES: c_int = 3;
pub const CONFIG_LWIP_NETIF_LOOPBACK: c_int = 1;
pub const CONFIG_LWIP_LOOPBACK_MAX_PBUFS: c_int = 8;
pub const CONFIG_LWIP_MAX_ACTIVE_TCP: c_int = 16;
pub const CONFIG_LWIP_MAX_LISTENING_TCP: c_int = 16;
pub const CONFIG_LWIP_TCP_HIGH_SPEED_RETRANSMISSION: c_int = 1;
pub const CONFIG_LWIP_TCP_MAXRTX: c_int = 12;
pub const CONFIG_LWIP_TCP_SYNMAXRTX: c_int = 12;
pub const CONFIG_LWIP_TCP_MSS: c_int = 1440;
pub const CONFIG_LWIP_TCP_TMR_INTERVAL: c_int = 250;
pub const CONFIG_LWIP_TCP_MSL = std.zig.c_translation.promoteIntLiteral(c_int, 60000, .decimal);
pub const CONFIG_LWIP_TCP_FIN_WAIT_TIMEOUT: c_int = 20000;
pub const CONFIG_LWIP_TCP_SND_BUF_DEFAULT: c_int = 5760;
pub const CONFIG_LWIP_TCP_WND_DEFAULT: c_int = 5760;
pub const CONFIG_LWIP_TCP_RECVMBOX_SIZE: c_int = 6;
pub const CONFIG_LWIP_TCP_ACCEPTMBOX_SIZE: c_int = 6;
pub const CONFIG_LWIP_TCP_QUEUE_OOSEQ: c_int = 1;
pub const CONFIG_LWIP_TCP_OOSEQ_TIMEOUT: c_int = 6;
pub const CONFIG_LWIP_TCP_OOSEQ_MAX_PBUFS: c_int = 4;
pub const CONFIG_LWIP_TCP_OVERSIZE_MSS: c_int = 1;
pub const CONFIG_LWIP_TCP_RTO_TIME: c_int = 1500;
pub const CONFIG_LWIP_MAX_UDP_PCBS: c_int = 16;
pub const CONFIG_LWIP_UDP_RECVMBOX_SIZE: c_int = 6;
pub const CONFIG_LWIP_CHECKSUM_CHECK_ICMP: c_int = 1;
pub const CONFIG_LWIP_TCPIP_TASK_STACK_SIZE: c_int = 3072;
pub const CONFIG_LWIP_TCPIP_TASK_AFFINITY_NO_AFFINITY: c_int = 1;
pub const CONFIG_LWIP_TCPIP_TASK_AFFINITY = std.zig.c_translation.promoteIntLiteral(c_int, 0x7FFFFFFF, .hex);
pub const CONFIG_LWIP_IPV6_MEMP_NUM_ND6_QUEUE: c_int = 3;
pub const CONFIG_LWIP_IPV6_ND6_NUM_NEIGHBORS: c_int = 5;
pub const CONFIG_LWIP_ICMP: c_int = 1;
pub const CONFIG_LWIP_MAX_RAW_PCBS: c_int = 16;
pub const CONFIG_LWIP_SNTP_MAX_SERVERS: c_int = 1;
pub const CONFIG_LWIP_SNTP_UPDATE_DELAY = std.zig.c_translation.promoteIntLiteral(c_int, 3600000, .decimal);
pub const CONFIG_LWIP_DNS_MAX_SERVERS: c_int = 3;
pub const CONFIG_LWIP_BRIDGEIF_MAX_PORTS: c_int = 7;
pub const CONFIG_LWIP_ESP_LWIP_ASSERT: c_int = 1;
pub const CONFIG_LWIP_HOOK_TCP_ISN_DEFAULT: c_int = 1;
pub const CONFIG_LWIP_HOOK_IP6_ROUTE_NONE: c_int = 1;
pub const CONFIG_LWIP_HOOK_ND6_GET_GW_NONE: c_int = 1;
pub const CONFIG_LWIP_HOOK_IP6_SELECT_SRC_ADDR_NONE: c_int = 1;
pub const CONFIG_LWIP_HOOK_NETCONN_EXT_RESOLVE_NONE: c_int = 1;
pub const CONFIG_LWIP_HOOK_IP6_INPUT_NONE: c_int = 1;
pub const CONFIG_MBEDTLS_INTERNAL_MEM_ALLOC: c_int = 1;
pub const CONFIG_MBEDTLS_ASYMMETRIC_CONTENT_LEN: c_int = 1;
pub const CONFIG_MBEDTLS_SSL_IN_CONTENT_LEN: c_int = 16384;
pub const CONFIG_MBEDTLS_SSL_OUT_CONTENT_LEN: c_int = 4096;
pub const CONFIG_MBEDTLS_SSL_KEEP_PEER_CERTIFICATE: c_int = 1;
pub const CONFIG_MBEDTLS_PKCS7_C: c_int = 1;
pub const CONFIG_MBEDTLS_CERTIFICATE_BUNDLE: c_int = 1;
pub const CONFIG_MBEDTLS_CERTIFICATE_BUNDLE_DEFAULT_FULL: c_int = 1;
pub const CONFIG_MBEDTLS_CERTIFICATE_BUNDLE_MAX_CERTS: c_int = 200;
pub const CONFIG_MBEDTLS_CMAC_C: c_int = 1;
pub const CONFIG_MBEDTLS_HARDWARE_AES: c_int = 1;
pub const CONFIG_MBEDTLS_AES_USE_INTERRUPT: c_int = 1;
pub const CONFIG_MBEDTLS_AES_INTERRUPT_LEVEL: c_int = 0;
pub const CONFIG_MBEDTLS_HARDWARE_MPI: c_int = 1;
pub const CONFIG_MBEDTLS_MPI_USE_INTERRUPT: c_int = 1;
pub const CONFIG_MBEDTLS_MPI_INTERRUPT_LEVEL: c_int = 0;
pub const CONFIG_MBEDTLS_HARDWARE_SHA: c_int = 1;
pub const CONFIG_MBEDTLS_ROM_MD5: c_int = 1;
pub const CONFIG_MBEDTLS_HAVE_TIME: c_int = 1;
pub const CONFIG_MBEDTLS_ECDSA_DETERMINISTIC: c_int = 1;
pub const CONFIG_MBEDTLS_SHA512_C: c_int = 1;
pub const CONFIG_MBEDTLS_TLS_SERVER_AND_CLIENT: c_int = 1;
pub const CONFIG_MBEDTLS_TLS_SERVER: c_int = 1;
pub const CONFIG_MBEDTLS_TLS_CLIENT: c_int = 1;
pub const CONFIG_MBEDTLS_TLS_ENABLED: c_int = 1;
pub const CONFIG_MBEDTLS_KEY_EXCHANGE_RSA: c_int = 1;
pub const CONFIG_MBEDTLS_KEY_EXCHANGE_ELLIPTIC_CURVE: c_int = 1;
pub const CONFIG_MBEDTLS_KEY_EXCHANGE_ECDHE_RSA: c_int = 1;
pub const CONFIG_MBEDTLS_KEY_EXCHANGE_ECDHE_ECDSA: c_int = 1;
pub const CONFIG_MBEDTLS_KEY_EXCHANGE_ECDH_ECDSA: c_int = 1;
pub const CONFIG_MBEDTLS_KEY_EXCHANGE_ECDH_RSA: c_int = 1;
pub const CONFIG_MBEDTLS_SSL_RENEGOTIATION: c_int = 1;
pub const CONFIG_MBEDTLS_SSL_PROTO_TLS1_2: c_int = 1;
pub const CONFIG_MBEDTLS_SSL_ALPN: c_int = 1;
pub const CONFIG_MBEDTLS_CLIENT_SSL_SESSION_TICKETS: c_int = 1;
pub const CONFIG_MBEDTLS_SERVER_SSL_SESSION_TICKETS: c_int = 1;
pub const CONFIG_MBEDTLS_AES_C: c_int = 1;
pub const CONFIG_MBEDTLS_CCM_C: c_int = 1;
pub const CONFIG_MBEDTLS_GCM_C: c_int = 1;
pub const CONFIG_MBEDTLS_PEM_PARSE_C: c_int = 1;
pub const CONFIG_MBEDTLS_PEM_WRITE_C: c_int = 1;
pub const CONFIG_MBEDTLS_X509_CRL_PARSE_C: c_int = 1;
pub const CONFIG_MBEDTLS_X509_CSR_PARSE_C: c_int = 1;
pub const CONFIG_MBEDTLS_ECP_C: c_int = 1;
pub const CONFIG_MBEDTLS_ECDH_C: c_int = 1;
pub const CONFIG_MBEDTLS_ECDSA_C: c_int = 1;
pub const CONFIG_MBEDTLS_ECP_DP_SECP192R1_ENABLED: c_int = 1;
pub const CONFIG_MBEDTLS_ECP_DP_SECP224R1_ENABLED: c_int = 1;
pub const CONFIG_MBEDTLS_ECP_DP_SECP256R1_ENABLED: c_int = 1;
pub const CONFIG_MBEDTLS_ECP_DP_SECP384R1_ENABLED: c_int = 1;
pub const CONFIG_MBEDTLS_ECP_DP_SECP521R1_ENABLED: c_int = 1;
pub const CONFIG_MBEDTLS_ECP_DP_SECP192K1_ENABLED: c_int = 1;
pub const CONFIG_MBEDTLS_ECP_DP_SECP224K1_ENABLED: c_int = 1;
pub const CONFIG_MBEDTLS_ECP_DP_SECP256K1_ENABLED: c_int = 1;
pub const CONFIG_MBEDTLS_ECP_DP_BP256R1_ENABLED: c_int = 1;
pub const CONFIG_MBEDTLS_ECP_DP_BP384R1_ENABLED: c_int = 1;
pub const CONFIG_MBEDTLS_ECP_DP_BP512R1_ENABLED: c_int = 1;
pub const CONFIG_MBEDTLS_ECP_DP_CURVE25519_ENABLED: c_int = 1;
pub const CONFIG_MBEDTLS_ECP_NIST_OPTIM: c_int = 1;
pub const CONFIG_MBEDTLS_ECP_FIXED_POINT_OPTIM: c_int = 1;
pub const CONFIG_MBEDTLS_LARGE_KEY_SOFTWARE_MPI: c_int = 1;
pub const CONFIG_MQTT_PROTOCOL_311: c_int = 1;
pub const CONFIG_MQTT_TRANSPORT_SSL: c_int = 1;
pub const CONFIG_MQTT_TRANSPORT_WEBSOCKET: c_int = 1;
pub const CONFIG_MQTT_TRANSPORT_WEBSOCKET_SECURE: c_int = 1;
pub const CONFIG_NEWLIB_STDOUT_LINE_ENDING_CRLF: c_int = 1;
pub const CONFIG_NEWLIB_STDIN_LINE_ENDING_CR: c_int = 1;
pub const CONFIG_NEWLIB_TIME_SYSCALL_USE_RTC_HRT: c_int = 1;
pub const CONFIG_OPENTHREAD_NETWORK_NAME = "OpenThread-ESP";
pub const CONFIG_OPENTHREAD_MESH_LOCAL_PREFIX = "fd00:db8:a0:0::/64";
pub const CONFIG_OPENTHREAD_NETWORK_CHANNEL: c_int = 15;
pub const CONFIG_OPENTHREAD_NETWORK_PANID: c_int = 0x1234;
pub const CONFIG_OPENTHREAD_NETWORK_EXTPANID = "dead00beef00cafe";
pub const CONFIG_OPENTHREAD_NETWORK_MASTERKEY = "00112233445566778899aabbccddeeff";
pub const CONFIG_OPENTHREAD_NETWORK_PSKC = "104810e2315100afd6bc9215a6bfac53";
pub const CONFIG_OPENTHREAD_XTAL_ACCURACY: c_int = 130;
pub const CONFIG_OPENTHREAD_RX_ON_WHEN_IDLE: c_int = 1;
pub const CONFIG_ESP_PROTOCOMM_SUPPORT_SECURITY_VERSION_0: c_int = 1;
pub const CONFIG_ESP_PROTOCOMM_SUPPORT_SECURITY_VERSION_1: c_int = 1;
pub const CONFIG_ESP_PROTOCOMM_SUPPORT_SECURITY_VERSION_2: c_int = 1;
pub const CONFIG_PTHREAD_TASK_PRIO_DEFAULT: c_int = 5;
pub const CONFIG_PTHREAD_TASK_STACK_SIZE_DEFAULT: c_int = 3072;
pub const CONFIG_PTHREAD_STACK_MIN: c_int = 768;
pub const CONFIG_PTHREAD_TASK_CORE_DEFAULT: c_int = -1;
pub const CONFIG_PTHREAD_TASK_NAME_DEFAULT = "pthread";
pub const CONFIG_MMU_PAGE_SIZE_64KB: c_int = 1;
pub const CONFIG_MMU_PAGE_MODE = "64KB";
pub const CONFIG_MMU_PAGE_SIZE = std.zig.c_translation.promoteIntLiteral(c_int, 0x10000, .hex);
pub const CONFIG_SPI_FLASH_BROWNOUT_RESET_XMC: c_int = 1;
pub const CONFIG_SPI_FLASH_BROWNOUT_RESET: c_int = 1;
pub const CONFIG_SPI_FLASH_SUSPEND_QVL_SUPPORTED: c_int = 1;
pub const CONFIG_SPI_FLASH_SUSPEND_TSUS_VAL_US: c_int = 50;
pub const CONFIG_SPI_FLASH_ROM_DRIVER_PATCH: c_int = 1;
pub const CONFIG_SPI_FLASH_DANGEROUS_WRITE_ABORTS: c_int = 1;
pub const CONFIG_SPI_FLASH_YIELD_DURING_ERASE: c_int = 1;
pub const CONFIG_SPI_FLASH_ERASE_YIELD_DURATION_MS: c_int = 20;
pub const CONFIG_SPI_FLASH_ERASE_YIELD_TICKS: c_int = 1;
pub const CONFIG_SPI_FLASH_WRITE_CHUNK_SIZE: c_int = 8192;
pub const CONFIG_SPI_FLASH_VENDOR_XMC_SUPPORTED: c_int = 1;
pub const CONFIG_SPI_FLASH_VENDOR_GD_SUPPORTED: c_int = 1;
pub const CONFIG_SPI_FLASH_VENDOR_ISSI_SUPPORTED: c_int = 1;
pub const CONFIG_SPI_FLASH_VENDOR_MXIC_SUPPORTED: c_int = 1;
pub const CONFIG_SPI_FLASH_VENDOR_WINBOND_SUPPORTED: c_int = 1;
pub const CONFIG_SPI_FLASH_VENDOR_BOYA_SUPPORTED: c_int = 1;
pub const CONFIG_SPI_FLASH_VENDOR_TH_SUPPORTED: c_int = 1;
pub const CONFIG_SPI_FLASH_SUPPORT_ISSI_CHIP: c_int = 1;
pub const CONFIG_SPI_FLASH_SUPPORT_MXIC_CHIP: c_int = 1;
pub const CONFIG_SPI_FLASH_SUPPORT_GD_CHIP: c_int = 1;
pub const CONFIG_SPI_FLASH_SUPPORT_WINBOND_CHIP: c_int = 1;
pub const CONFIG_SPI_FLASH_SUPPORT_BOYA_CHIP: c_int = 1;
pub const CONFIG_SPI_FLASH_SUPPORT_TH_CHIP: c_int = 1;
pub const CONFIG_SPI_FLASH_ENABLE_ENCRYPTED_READ_WRITE: c_int = 1;
pub const CONFIG_SPIFFS_MAX_PARTITIONS: c_int = 3;
pub const CONFIG_SPIFFS_CACHE: c_int = 1;
pub const CONFIG_SPIFFS_CACHE_WR: c_int = 1;
pub const CONFIG_SPIFFS_PAGE_CHECK: c_int = 1;
pub const CONFIG_SPIFFS_GC_MAX_RUNS: c_int = 10;
pub const CONFIG_SPIFFS_PAGE_SIZE: c_int = 256;
pub const CONFIG_SPIFFS_OBJ_NAME_LEN: c_int = 32;
pub const CONFIG_SPIFFS_USE_MAGIC: c_int = 1;
pub const CONFIG_SPIFFS_USE_MAGIC_LENGTH: c_int = 1;
pub const CONFIG_SPIFFS_META_LENGTH: c_int = 4;
pub const CONFIG_SPIFFS_USE_MTIME: c_int = 1;
pub const CONFIG_WS_TRANSPORT: c_int = 1;
pub const CONFIG_WS_BUFFER_SIZE: c_int = 1024;
pub const CONFIG_UNITY_ENABLE_FLOAT: c_int = 1;
pub const CONFIG_UNITY_ENABLE_DOUBLE: c_int = 1;
pub const CONFIG_UNITY_ENABLE_IDF_TEST_RUNNER: c_int = 1;
pub const CONFIG_VFS_SUPPORT_IO: c_int = 1;
pub const CONFIG_VFS_SUPPORT_DIR: c_int = 1;
pub const CONFIG_VFS_SUPPORT_SELECT: c_int = 1;
pub const CONFIG_VFS_SUPPRESS_SELECT_DEBUG_OUTPUT: c_int = 1;
pub const CONFIG_VFS_SUPPORT_TERMIOS: c_int = 1;
pub const CONFIG_VFS_MAX_COUNT: c_int = 8;
pub const CONFIG_VFS_SEMIHOSTFS_MAX_MOUNT_POINTS: c_int = 1;
pub const CONFIG_WL_SECTOR_SIZE_4096: c_int = 1;
pub const CONFIG_WL_SECTOR_SIZE: c_int = 4096;
pub const CONFIG_WIFI_PROV_SCAN_MAX_ENTRIES: c_int = 16;
pub const CONFIG_WIFI_PROV_AUTOSTOP_TIMEOUT: c_int = 30;
pub const CONFIG_WIFI_PROV_STA_ALL_CHANNEL_SCAN: c_int = 1;
pub const CONFIG_BROWNOUT_DET = CONFIG_ESP_BROWNOUT_DET;
pub const CONFIG_BROWNOUT_DET_LVL = CONFIG_ESP_BROWNOUT_DET_LVL;
pub const CONFIG_BROWNOUT_DET_LVL_SEL_7 = CONFIG_ESP_BROWNOUT_DET_LVL_SEL_7;
pub const CONFIG_COMPILER_OPTIMIZATION_DEFAULT = CONFIG_COMPILER_OPTIMIZATION_DEBUG;
pub const CONFIG_COMPILER_OPTIMIZATION_LEVEL_DEBUG = CONFIG_COMPILER_OPTIMIZATION_DEBUG;
pub const CONFIG_CONSOLE_UART = CONFIG_ESP_CONSOLE_UART;
pub const CONFIG_CONSOLE_UART_BAUDRATE = CONFIG_ESP_CONSOLE_UART_BAUDRATE;
pub const CONFIG_CONSOLE_UART_DEFAULT = CONFIG_ESP_CONSOLE_UART_DEFAULT;
pub const CONFIG_CONSOLE_UART_NUM = CONFIG_ESP_CONSOLE_UART_NUM;
pub const CONFIG_ESP32C3_BROWNOUT_DET = CONFIG_ESP_BROWNOUT_DET;
pub const CONFIG_ESP32C3_BROWNOUT_DET_LVL = CONFIG_ESP_BROWNOUT_DET_LVL;
pub const CONFIG_ESP32C3_BROWNOUT_DET_LVL_SEL_7 = CONFIG_ESP_BROWNOUT_DET_LVL_SEL_7;
pub const CONFIG_ESP32C3_DEBUG_OCDAWARE = CONFIG_ESP_DEBUG_OCDAWARE;
pub const CONFIG_ESP32C3_DEFAULT_CPU_FREQ_160 = CONFIG_ESP_DEFAULT_CPU_FREQ_MHZ_160;
pub const CONFIG_ESP32C3_DEFAULT_CPU_FREQ_MHZ = CONFIG_ESP_DEFAULT_CPU_FREQ_MHZ;
pub const CONFIG_ESP32C3_LIGHTSLEEP_GPIO_RESET_WORKAROUND = CONFIG_ESP_SLEEP_GPIO_RESET_WORKAROUND;
pub const CONFIG_ESP32C3_MEMPROT_FEATURE = CONFIG_ESP_SYSTEM_MEMPROT_FEATURE;
pub const CONFIG_ESP32C3_MEMPROT_FEATURE_LOCK = CONFIG_ESP_SYSTEM_MEMPROT_FEATURE_LOCK;
pub const CONFIG_ESP32C3_RTC_CLK_CAL_CYCLES = CONFIG_RTC_CLK_CAL_CYCLES;
pub const CONFIG_ESP32C3_RTC_CLK_SRC_INT_RC = CONFIG_RTC_CLK_SRC_INT_RC;
pub const CONFIG_ESP32C3_TIME_SYSCALL_USE_RTC_SYSTIMER = CONFIG_NEWLIB_TIME_SYSCALL_USE_RTC_HRT;
pub const CONFIG_ESP32_APPTRACE_DEST_NONE = CONFIG_APPTRACE_DEST_NONE;
pub const CONFIG_ESP32_APPTRACE_LOCK_ENABLE = CONFIG_APPTRACE_LOCK_ENABLE;
pub const CONFIG_ESP32_ENABLE_COREDUMP_TO_NONE = CONFIG_ESP_COREDUMP_ENABLE_TO_NONE;
pub const CONFIG_ESP32_PHY_CALIBRATION_AND_DATA_STORAGE = CONFIG_ESP_PHY_CALIBRATION_AND_DATA_STORAGE;
pub const CONFIG_ESP32_PHY_MAX_TX_POWER = CONFIG_ESP_PHY_MAX_TX_POWER;
pub const CONFIG_ESP32_PHY_MAX_WIFI_TX_POWER = CONFIG_ESP_PHY_MAX_WIFI_TX_POWER;
pub const CONFIG_ESP32_PTHREAD_STACK_MIN = CONFIG_PTHREAD_STACK_MIN;
pub const CONFIG_ESP32_PTHREAD_TASK_CORE_DEFAULT = CONFIG_PTHREAD_TASK_CORE_DEFAULT;
pub const CONFIG_ESP32_PTHREAD_TASK_NAME_DEFAULT = CONFIG_PTHREAD_TASK_NAME_DEFAULT;
pub const CONFIG_ESP32_PTHREAD_TASK_PRIO_DEFAULT = CONFIG_PTHREAD_TASK_PRIO_DEFAULT;
pub const CONFIG_ESP32_PTHREAD_TASK_STACK_SIZE_DEFAULT = CONFIG_PTHREAD_TASK_STACK_SIZE_DEFAULT;
pub const CONFIG_ESP32_WIFI_AMPDU_RX_ENABLED = CONFIG_ESP_WIFI_AMPDU_RX_ENABLED;
pub const CONFIG_ESP32_WIFI_AMPDU_TX_ENABLED = CONFIG_ESP_WIFI_AMPDU_TX_ENABLED;
pub const CONFIG_ESP32_WIFI_DYNAMIC_RX_BUFFER_NUM = CONFIG_ESP_WIFI_DYNAMIC_RX_BUFFER_NUM;
pub const CONFIG_ESP32_WIFI_DYNAMIC_TX_BUFFER = CONFIG_ESP_WIFI_DYNAMIC_TX_BUFFER;
pub const CONFIG_ESP32_WIFI_DYNAMIC_TX_BUFFER_NUM = CONFIG_ESP_WIFI_DYNAMIC_TX_BUFFER_NUM;
pub const CONFIG_ESP32_WIFI_ENABLED = CONFIG_ESP_WIFI_ENABLED;
pub const CONFIG_ESP32_WIFI_ENABLE_WPA3_OWE_STA = CONFIG_ESP_WIFI_ENABLE_WPA3_OWE_STA;
pub const CONFIG_ESP32_WIFI_ENABLE_WPA3_SAE = CONFIG_ESP_WIFI_ENABLE_WPA3_SAE;
pub const CONFIG_ESP32_WIFI_IRAM_OPT = CONFIG_ESP_WIFI_IRAM_OPT;
pub const CONFIG_ESP32_WIFI_MGMT_SBUF_NUM = CONFIG_ESP_WIFI_MGMT_SBUF_NUM;
pub const CONFIG_ESP32_WIFI_NVS_ENABLED = CONFIG_ESP_WIFI_NVS_ENABLED;
pub const CONFIG_ESP32_WIFI_RX_BA_WIN = CONFIG_ESP_WIFI_RX_BA_WIN;
pub const CONFIG_ESP32_WIFI_RX_IRAM_OPT = CONFIG_ESP_WIFI_RX_IRAM_OPT;
pub const CONFIG_ESP32_WIFI_SOFTAP_BEACON_MAX_LEN = CONFIG_ESP_WIFI_SOFTAP_BEACON_MAX_LEN;
pub const CONFIG_ESP32_WIFI_STATIC_RX_BUFFER_NUM = CONFIG_ESP_WIFI_STATIC_RX_BUFFER_NUM;
pub const CONFIG_ESP32_WIFI_TX_BA_WIN = CONFIG_ESP_WIFI_TX_BA_WIN;
pub const CONFIG_ESP32_WIFI_TX_BUFFER_TYPE = CONFIG_ESP_WIFI_TX_BUFFER_TYPE;
pub const CONFIG_ESP_GRATUITOUS_ARP = CONFIG_LWIP_ESP_GRATUITOUS_ARP;
pub const CONFIG_ESP_SYSTEM_PM_POWER_DOWN_CPU = CONFIG_PM_POWER_DOWN_CPU_IN_LIGHT_SLEEP;
pub const CONFIG_ESP_TASK_WDT = CONFIG_ESP_TASK_WDT_INIT;
pub const CONFIG_FLASHMODE_DIO = CONFIG_ESPTOOLPY_FLASHMODE_DIO;
pub const CONFIG_GARP_TMR_INTERVAL = CONFIG_LWIP_GARP_TMR_INTERVAL;
pub const CONFIG_INT_WDT = CONFIG_ESP_INT_WDT;
pub const CONFIG_INT_WDT_TIMEOUT_MS = CONFIG_ESP_INT_WDT_TIMEOUT_MS;
pub const CONFIG_IPC_TASK_STACK_SIZE = CONFIG_ESP_IPC_TASK_STACK_SIZE;
pub const CONFIG_LOG_BOOTLOADER_LEVEL = CONFIG_BOOTLOADER_LOG_LEVEL;
pub const CONFIG_LOG_BOOTLOADER_LEVEL_INFO = CONFIG_BOOTLOADER_LOG_LEVEL_INFO;
pub const CONFIG_MAIN_TASK_STACK_SIZE = CONFIG_ESP_MAIN_TASK_STACK_SIZE;
pub const CONFIG_MONITOR_BAUD = CONFIG_ESPTOOLPY_MONITOR_BAUD;
pub const CONFIG_OPTIMIZATION_ASSERTIONS_ENABLED = CONFIG_COMPILER_OPTIMIZATION_ASSERTIONS_ENABLE;
pub const CONFIG_OPTIMIZATION_ASSERTION_LEVEL = CONFIG_COMPILER_OPTIMIZATION_ASSERTION_LEVEL;
pub const CONFIG_OPTIMIZATION_LEVEL_DEBUG = CONFIG_COMPILER_OPTIMIZATION_DEBUG;
pub const CONFIG_POST_EVENTS_FROM_IRAM_ISR = CONFIG_ESP_EVENT_POST_FROM_IRAM_ISR;
pub const CONFIG_POST_EVENTS_FROM_ISR = CONFIG_ESP_EVENT_POST_FROM_ISR;
pub const CONFIG_SEMIHOSTFS_MAX_MOUNT_POINTS = CONFIG_VFS_SEMIHOSTFS_MAX_MOUNT_POINTS;
pub const CONFIG_SPI_FLASH_WRITING_DANGEROUS_REGIONS_ABORTS = CONFIG_SPI_FLASH_DANGEROUS_WRITE_ABORTS;
pub const CONFIG_STACK_CHECK_NONE = CONFIG_COMPILER_STACK_CHECK_MODE_NONE;
pub const CONFIG_SUPPORT_TERMIOS = CONFIG_VFS_SUPPORT_TERMIOS;
pub const CONFIG_SUPPRESS_SELECT_DEBUG_OUTPUT = CONFIG_VFS_SUPPRESS_SELECT_DEBUG_OUTPUT;
pub const CONFIG_SYSTEM_EVENT_QUEUE_SIZE = CONFIG_ESP_SYSTEM_EVENT_QUEUE_SIZE;
pub const CONFIG_SYSTEM_EVENT_TASK_STACK_SIZE = CONFIG_ESP_SYSTEM_EVENT_TASK_STACK_SIZE;
pub const CONFIG_TASK_WDT = CONFIG_ESP_TASK_WDT_INIT;
pub const CONFIG_TASK_WDT_CHECK_IDLE_TASK_CPU0 = CONFIG_ESP_TASK_WDT_CHECK_IDLE_TASK_CPU0;
pub const CONFIG_TASK_WDT_TIMEOUT_S = CONFIG_ESP_TASK_WDT_TIMEOUT_S;
pub const CONFIG_TCPIP_RECVMBOX_SIZE = CONFIG_LWIP_TCPIP_RECVMBOX_SIZE;
pub const CONFIG_TCPIP_TASK_AFFINITY = CONFIG_LWIP_TCPIP_TASK_AFFINITY;
pub const CONFIG_TCPIP_TASK_AFFINITY_NO_AFFINITY = CONFIG_LWIP_TCPIP_TASK_AFFINITY_NO_AFFINITY;
pub const CONFIG_TCPIP_TASK_STACK_SIZE = CONFIG_LWIP_TCPIP_TASK_STACK_SIZE;
pub const CONFIG_TCP_MAXRTX = CONFIG_LWIP_TCP_MAXRTX;
pub const CONFIG_TCP_MSL = CONFIG_LWIP_TCP_MSL;
pub const CONFIG_TCP_MSS = CONFIG_LWIP_TCP_MSS;
pub const CONFIG_TCP_OVERSIZE_MSS = CONFIG_LWIP_TCP_OVERSIZE_MSS;
pub const CONFIG_TCP_QUEUE_OOSEQ = CONFIG_LWIP_TCP_QUEUE_OOSEQ;
pub const CONFIG_TCP_RECVMBOX_SIZE = CONFIG_LWIP_TCP_RECVMBOX_SIZE;
pub const CONFIG_TCP_SND_BUF_DEFAULT = CONFIG_LWIP_TCP_SND_BUF_DEFAULT;
pub const CONFIG_TCP_SYNMAXRTX = CONFIG_LWIP_TCP_SYNMAXRTX;
pub const CONFIG_TCP_WND_DEFAULT = CONFIG_LWIP_TCP_WND_DEFAULT;
pub const CONFIG_TIMER_QUEUE_LENGTH = CONFIG_FREERTOS_TIMER_QUEUE_LENGTH;
pub const CONFIG_TIMER_TASK_PRIORITY = CONFIG_FREERTOS_TIMER_TASK_PRIORITY;
pub const CONFIG_TIMER_TASK_STACK_DEPTH = CONFIG_FREERTOS_TIMER_TASK_STACK_DEPTH;
pub const CONFIG_TIMER_TASK_STACK_SIZE = CONFIG_ESP_TIMER_TASK_STACK_SIZE;
pub const CONFIG_UDP_RECVMBOX_SIZE = CONFIG_LWIP_UDP_RECVMBOX_SIZE;
pub const CONFIG_WPA_MBEDTLS_CRYPTO = CONFIG_ESP_WIFI_MBEDTLS_CRYPTO;
pub const CONFIG_WPA_MBEDTLS_TLS_CLIENT = CONFIG_ESP_WIFI_MBEDTLS_TLS_CLIENT;
