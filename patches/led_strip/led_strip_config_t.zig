pub const led_strip_config_t = extern struct {
    strip_gpio_num: c_int = 0,
    max_leds: u32 = 0,
    led_model: led_model_t = @import("std").mem.zeroes(led_model_t),
    color_component_format: led_color_component_format_t = @import("std").mem.zeroes(led_color_component_format_t),
    flags: led_strip_flags = @import("std").mem.zeroes(led_strip_flags),
    pub const led_strip_new_rmt_device = __root.led_strip_new_rmt_device;
    pub const led_strip_new_spi_device = __root.led_strip_new_spi_device;
    pub const device = __root.led_strip_new_rmt_device;
};
