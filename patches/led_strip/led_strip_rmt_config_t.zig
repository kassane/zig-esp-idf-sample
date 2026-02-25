pub const led_strip_rmt_config_t = extern struct {
    clk_src: rmt_clock_source_t = @import("std").mem.zeroes(rmt_clock_source_t),
    resolution_hz: u32 = 0,
    mem_block_symbols: usize = 0,
    flags: led_strip_flags = @import("std").mem.zeroes(led_strip_flags),
};

const led_strip_flags = extern struct {
    invert_out: u32,
};
