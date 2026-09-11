const has_lp_uart = if (@hasDecl(@This(), "SOC_UART_LP_NUM"))
    @field(@This(), "SOC_UART_LP_NUM") >= 1
else false;

const lp_source_clk_type = if (has_lp_uart) @field(@This(), "lp_uart_sclk_t") else void;

pub const uart_source_clk = extern union {
    source_clk: uart_sclk_t,
    lp_source_clk: lp_source_clk_type,
};

pub const uart_config_flags = packed struct(u32) {
    allow_pd: u1 = 0,
    backup_before_sleep: u1 = 0,
    _padding: u30 = 0,
};

pub const uart_config_t = extern struct {
    baud_rate: c_int = 115200,
    data_bits: uart_word_length_t = UART_DATA_8_BITS,
    parity: uart_parity_t = UART_PARITY_DISABLE,
    stop_bits: uart_stop_bits_t = UART_STOP_BITS_1,
    flow_ctrl: uart_hw_flowcontrol_t = UART_HW_FLOWCTRL_DISABLE,
    rx_flow_ctrl_thresh: u8 = 122,
    clk_source: uart_source_clk = undefined,
    flags: uart_config_flags = undefined,
};