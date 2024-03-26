const sys = @import("sys");
const errors = @import("error");

pub fn driverInstall(uart_num: sys.uart_port_t, rx_buffer_size: c_int, tx_buffer_size: c_int, queue_size: c_int, uart_queue: [*c]sys.QueueHandle_t, intr_alloc_flags: c_int) !void {
    return try errors.espCheckError(sys.uart_driver_install(uart_num, rx_buffer_size, tx_buffer_size, queue_size, uart_queue, intr_alloc_flags));
}
pub fn driverDelete(uart_num: sys.uart_port_t) !void {
    return try errors.espCheckError(sys.uart_driver_delete(uart_num));
}
pub fn isDriverInstalled(uart_num: sys.uart_port_t) bool {
    return sys.uart_is_driver_installed(uart_num);
}
pub fn setWordLength(uart_num: sys.uart_port_t, data_bit: sys.uart_word_length_t) !void {
    return try errors.espCheckError(sys.uart_set_word_length(uart_num, data_bit));
}
pub fn getWordLength(uart_num: sys.uart_port_t, data_bit: [*c]sys.uart_word_length_t) !void {
    return try errors.espCheckError(sys.uart_get_word_length(uart_num, data_bit));
}
pub fn setStopBits(uart_num: sys.uart_port_t, stop_bits: sys.uart_stop_bits_t) !void {
    return try errors.espCheckError(sys.uart_set_stop_bits(uart_num, stop_bits));
}
pub fn getStopBits(uart_num: sys.uart_port_t, stop_bits: [*c]sys.uart_stop_bits_t) !void {
    return try errors.espCheckError(sys.uart_get_stop_bits(uart_num, stop_bits));
}
pub fn setParity(uart_num: sys.uart_port_t, parity_mode: sys.uart_parity_t) !void {
    return try errors.espCheckError(sys.uart_set_parity(uart_num, parity_mode));
}
pub fn getParity(uart_num: sys.uart_port_t, parity_mode: [*c]sys.uart_parity_t) !void {
    return try errors.espCheckError(sys.uart_get_parity(uart_num, parity_mode));
}
pub fn getSclkFreq(sclk: sys.uart_sclk_t, out_freq_hz: [*c]u32) !void {
    return try errors.espCheckError(sys.uart_get_sclk_freq(sclk, out_freq_hz));
}
pub fn setBaudrate(uart_num: sys.uart_port_t, baudrate: u32) !void {
    return try errors.espCheckError(sys.uart_set_baudrate(uart_num, baudrate));
}
pub fn getBaudrate(uart_num: sys.uart_port_t, baudrate: [*c]u32) !void {
    return try errors.espCheckError(sys.uart_get_baudrate(uart_num, baudrate));
}
pub fn setLineInverse(uart_num: sys.uart_port_t, inverse_mask: u32) !void {
    return try errors.espCheckError(sys.uart_set_line_inverse(uart_num, inverse_mask));
}
pub fn setHWFlowCtrl(uart_num: sys.uart_port_t, flow_ctrl: sys.uart_hw_flowcontrol_t, rx_thresh: u8) !void {
    return try errors.espCheckError(sys.uart_set_hw_flow_ctrl(uart_num, flow_ctrl, rx_thresh));
}
pub fn setSWFlowCtrl(uart_num: sys.uart_port_t, enable: bool, rx_thresh_xon: u8, rx_thresh_xoff: u8) !void {
    return try errors.espCheckError(sys.uart_set_sw_flow_ctrl(uart_num, enable, rx_thresh_xon, rx_thresh_xoff));
}
pub fn getHWFlowCtrl(uart_num: sys.uart_port_t, flow_ctrl: [*c]sys.uart_hw_flowcontrol_t) !void {
    return try errors.espCheckError(sys.uart_get_hw_flow_ctrl(uart_num, flow_ctrl));
}
pub fn clearIntrStatus(uart_num: sys.uart_port_t, clr_mask: u32) !void {
    return try errors.espCheckError(sys.uart_clear_intr_status(uart_num, clr_mask));
}
pub fn enableIntrMask(uart_num: sys.uart_port_t, enable_mask: u32) !void {
    return try errors.espCheckError(sys.uart_enable_intr_mask(uart_num, enable_mask));
}
pub fn disable_intr_mask(uart_num: sys.uart_port_t, disable_mask: u32) !void {
    return try errors.espCheckError(sys.uart_disable_intr_mask(uart_num, disable_mask));
}
pub fn enableRXIntr(uart_num: sys.uart_port_t) !void {
    return try errors.espCheckError(sys.uart_enable_rx_intr(uart_num));
}
pub fn disableRXIntr(uart_num: sys.uart_port_t) !void {
    return try errors.espCheckError(sys.uart_disable_rx_intr(uart_num));
}
pub fn disableTXIntr(uart_num: sys.uart_port_t) !void {
    return try errors.espCheckError(sys.uart_disable_tx_intr(uart_num));
}
pub fn enableTXIntr(uart_num: sys.uart_port_t, enable: c_int, thresh: c_int) !void {
    return try errors.espCheckError(sys.uart_enable_tx_intr(uart_num, enable, thresh));
}
pub fn setPin(uart_num: sys.uart_port_t, tx_io_num: c_int, rx_io_num: c_int, rts_io_num: c_int, cts_io_num: c_int) !void {
    return try errors.espCheckError(sys.uart_set_pin(uart_num, tx_io_num, rx_io_num, rts_io_num, cts_io_num));
}
pub fn setRTS(uart_num: sys.uart_port_t, level: c_int) !void {
    return try errors.espCheckError(sys.uart_set_rts(uart_num, level));
}
pub fn setDTR(uart_num: sys.uart_port_t, level: c_int) !void {
    return try errors.espCheckError(sys.uart_set_dtr(uart_num, level));
}
pub fn setTXIdleNum(uart_num: sys.uart_port_t, idle_num: u16) !void {
    return try errors.espCheckError(sys.uart_set_tx_idle_num(uart_num, idle_num));
}
pub fn paramConfig(uart_num: sys.uart_port_t, uart_config: [*c]const sys.uart_config_t) !void {
    return try errors.espCheckError(sys.uart_param_config(uart_num, uart_config));
}
pub fn intrConfig(uart_num: sys.uart_port_t, intr_conf: [*c]const sys.uart_intr_config_t) !void {
    return try errors.espCheckError(sys.uart_intr_config(uart_num, intr_conf));
}
pub fn waitTXDone(uart_num: sys.uart_port_t, ticks_to_wait: sys.TickType_t) !void {
    return try errors.espCheckError(sys.uart_wait_tx_done(uart_num, ticks_to_wait));
}
pub fn txChars(uart_num: sys.uart_port_t, buffer: [*:0]const u8, len: u32) c_int {
    return sys.uart_tx_chars(uart_num, buffer, len);
}
pub fn writeBytes(uart_num: sys.uart_port_t, src: ?*const anyopaque, size: usize) c_int {
    return sys.uart_write_bytes(uart_num, src, size);
}
pub fn writeBytesWithBreak(uart_num: sys.uart_port_t, src: ?*const anyopaque, size: usize, brk_len: c_int) c_int {
    return sys.uart_write_bytes_with_break(uart_num, src, size, brk_len);
}
pub fn readBytes(uart_num: sys.uart_port_t, buf: ?*anyopaque, length: u32, ticks_to_wait: sys.TickType_t) c_int {
    return sys.uart_read_bytes(uart_num, buf, length, ticks_to_wait);
}
pub fn flush(uart_num: sys.uart_port_t) !void {
    return try errors.espCheckError(sys.uart_flush(uart_num));
}
pub fn flushInput(uart_num: sys.uart_port_t) !void {
    return try errors.espCheckError(sys.uart_flush_input(uart_num));
}
pub fn getBufferedDataLen(uart_num: sys.uart_port_t, size: [*c]usize) !void {
    return try errors.espCheckError(sys.uart_get_buffered_data_len(uart_num, size));
}
pub fn getTXBufferFreeSize(uart_num: sys.uart_port_t, size: [*c]usize) !void {
    return try errors.espCheckError(sys.uart_get_tx_buffer_free_size(uart_num, size));
}
pub fn disablePatternDetIntr(uart_num: sys.uart_port_t) !void {
    return try errors.espCheckError(sys.uart_disable_pattern_det_intr(uart_num));
}
pub fn enablePatternDetBaudIntr(uart_num: sys.uart_port_t, pattern_chr: u8, chr_num: u8, chr_tout: c_int, post_idle: c_int, pre_idle: c_int) !void {
    return try errors.espCheckError(sys.uart_enable_pattern_det_baud_intr(uart_num, pattern_chr, chr_num, chr_tout, post_idle, pre_idle));
}
pub fn patternPopPos(uart_num: sys.uart_port_t) c_int {
    return sys.uart_pattern_pop_pos(uart_num);
}
pub fn patternGePos(uart_num: sys.uart_port_t) c_int {
    return sys.uart_pattern_get_pos(uart_num);
}
pub fn patternQueueReset(uart_num: sys.uart_port_t, queue_length: c_int) !void {
    return try errors.espCheckError(sys.uart_pattern_queue_reset(uart_num, queue_length));
}
pub fn setMode(uart_num: sys.uart_port_t, mode: sys.uart_mode_t) !void {
    return try errors.espCheckError(sys.uart_set_mode(uart_num, mode));
}
pub fn setRXFullThreshold(uart_num: sys.uart_port_t, threshold: c_int) !void {
    return try errors.espCheckError(sys.uart_set_rx_full_threshold(uart_num, threshold));
}
pub fn setTXEmptyThreshold(uart_num: sys.uart_port_t, threshold: c_int) !void {
    return try errors.espCheckError(sys.uart_set_tx_empty_threshold(uart_num, threshold));
}
pub fn setRXTimeout(uart_num: sys.uart_port_t, tout_thresh: u8) !void {
    return try errors.espCheckError(sys.uart_set_rx_timeout(uart_num, tout_thresh));
}
pub fn getCollisionFlag(uart_num: sys.uart_port_t, collision_flag: [*c]bool) !void {
    return try errors.espCheckError(sys.uart_get_collision_flag(uart_num, collision_flag));
}
pub fn setWakeupThreshold(uart_num: sys.uart_port_t, wakeup_threshold: c_int) !void {
    return try errors.espCheckError(sys.uart_set_wakeup_threshold(uart_num, wakeup_threshold));
}
pub fn getWakeupThreshold(uart_num: sys.uart_port_t, out_wakeup_threshold: [*c]c_int) !void {
    return try errors.espCheckError(sys.uart_get_wakeup_threshold(uart_num, out_wakeup_threshold));
}
pub fn waitTXIdlePolling(uart_num: sys.uart_port_t) !void {
    return try errors.espCheckError(sys.uart_wait_tx_idle_polling(uart_num));
}
pub fn setLoopBack(uart_num: sys.uart_port_t, loop_back_en: bool) !void {
    return try errors.espCheckError(sys.uart_set_loop_back(uart_num, loop_back_en));
}
pub fn setAlwaysRXTimeout(uart_num: sys.uart_port_t, always_rx_timeout_en: bool) void {
    sys.uart_set_always_rx_timeout(uart_num, always_rx_timeout_en);
}
