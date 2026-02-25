const sys = @import("sys");
const errors = @import("error");

// ─────────────────────────────────────────────────────────────────────────────
// Re-export ESP-IDF types so callers only need to @import("uart")
// ─────────────────────────────────────────────────────────────────────────────
pub const Port = sys.uart_port_t;
pub const WordLength = sys.uart_word_length_t;
pub const StopBits = sys.uart_stop_bits_t;
pub const Parity = sys.uart_parity_t;
pub const HWFlowCtrl = sys.uart_hw_flowcontrol_t;
pub const Mode = sys.uart_mode_t;
pub const Sclk = sys.uart_sclk_t;
pub const Config = sys.uart_config_t;
pub const IntrConfig = sys.uart_intr_config_t;
pub const QueueHandle = sys.QueueHandle_t;
pub const TickType = sys.TickType_t;

// ─────────────────────────────────────────────────────────────────────────────
// Pin assignment sentinel — mirrors UART_PIN_NO_CHANGE from esp-idf
// ─────────────────────────────────────────────────────────────────────────────
pub const pin_no_change: c_int = -1;

// ─────────────────────────────────────────────────────────────────────────────
// Driver lifecycle
// ─────────────────────────────────────────────────────────────────────────────

pub const DriverConfig = struct {
    rx_buffer_size: usize,
    tx_buffer_size: usize = 0,
    /// Pass null to disable event queue.
    queue_size: c_int = 0,
    uart_queue: ?*QueueHandle = null,
    intr_alloc_flags: c_int = 0,
};

pub fn driverInstall(port: Port, cfg: DriverConfig) !void {
    return errors.espCheckError(sys.uart_driver_install(
        port,
        @intCast(cfg.rx_buffer_size),
        @intCast(cfg.tx_buffer_size),
        cfg.queue_size,
        cfg.uart_queue orelse null,
        cfg.intr_alloc_flags,
    ));
}

pub fn driverDelete(port: Port) !void {
    return errors.espCheckError(sys.uart_driver_delete(port));
}

pub fn isDriverInstalled(port: Port) bool {
    return sys.uart_is_driver_installed(port);
}

// ─────────────────────────────────────────────────────────────────────────────
// Parameter configuration (word length, stop bits, parity, baud rate …)
// ─────────────────────────────────────────────────────────────────────────────

pub fn paramConfig(port: Port, cfg: *const Config) !void {
    return errors.espCheckError(sys.uart_param_config(port, cfg));
}

pub fn setWordLength(port: Port, data_bit: WordLength) !void {
    return errors.espCheckError(sys.uart_set_word_length(port, data_bit));
}

pub fn getWordLength(port: Port) !WordLength {
    var v: WordLength = undefined;
    try errors.espCheckError(sys.uart_get_word_length(port, &v));
    return v;
}

pub fn setStopBits(port: Port, stop_bits: StopBits) !void {
    return errors.espCheckError(sys.uart_set_stop_bits(port, stop_bits));
}

pub fn getStopBits(port: Port) !StopBits {
    var v: StopBits = undefined;
    try errors.espCheckError(sys.uart_get_stop_bits(port, &v));
    return v;
}

pub fn setParity(port: Port, parity: Parity) !void {
    return errors.espCheckError(sys.uart_set_parity(port, parity));
}

pub fn getParity(port: Port) !Parity {
    var v: Parity = undefined;
    try errors.espCheckError(sys.uart_get_parity(port, &v));
    return v;
}

pub fn setBaudrate(port: Port, baudrate: u32) !void {
    return errors.espCheckError(sys.uart_set_baudrate(port, baudrate));
}

pub fn getBaudrate(port: Port) !u32 {
    var v: u32 = 0;
    try errors.espCheckError(sys.uart_get_baudrate(port, &v));
    return v;
}

pub fn getSclkFreq(sclk: Sclk) !u32 {
    var v: u32 = 0;
    try errors.espCheckError(sys.uart_get_sclk_freq(sclk, &v));
    return v;
}

pub fn setLineInverse(port: Port, inverse_mask: u32) !void {
    return errors.espCheckError(sys.uart_set_line_inverse(port, inverse_mask));
}

pub fn setMode(port: Port, mode: Mode) !void {
    return errors.espCheckError(sys.uart_set_mode(port, mode));
}

pub fn setLoopBack(port: Port, enable: bool) !void {
    return errors.espCheckError(sys.uart_set_loop_back(port, enable));
}

pub fn setAlwaysRxTimeout(port: Port, enable: bool) void {
    sys.uart_set_always_rx_timeout(port, enable);
}

// ─────────────────────────────────────────────────────────────────────────────
// Pin mapping
// ─────────────────────────────────────────────────────────────────────────────

pub const PinConfig = struct {
    tx: c_int = pin_no_change,
    rx: c_int = pin_no_change,
    rts: c_int = pin_no_change,
    cts: c_int = pin_no_change,
};

pub fn setPin(port: Port, pins: PinConfig) !void {
    return errors.espCheckError(sys.uart_set_pin(port, pins.tx, pins.rx, pins.rts, pins.cts));
}

/// Drive RTS line manually (level: true = high, false = low).
pub fn setRTS(port: Port, level: bool) !void {
    return errors.espCheckError(sys.uart_set_rts(port, @intFromBool(level)));
}

/// Drive DTR line manually.
pub fn setDTR(port: Port, level: bool) !void {
    return errors.espCheckError(sys.uart_set_dtr(port, @intFromBool(level)));
}

pub fn setTXIdleNum(port: Port, idle_num: u16) !void {
    return errors.espCheckError(sys.uart_set_tx_idle_num(port, idle_num));
}

// ─────────────────────────────────────────────────────────────────────────────
// Flow control
// ─────────────────────────────────────────────────────────────────────────────

pub fn setHWFlowCtrl(port: Port, flow_ctrl: HWFlowCtrl, rx_thresh: u8) !void {
    return errors.espCheckError(sys.uart_set_hw_flow_ctrl(port, flow_ctrl, rx_thresh));
}

pub fn getHWFlowCtrl(port: Port) !HWFlowCtrl {
    var v: HWFlowCtrl = undefined;
    try errors.espCheckError(sys.uart_get_hw_flow_ctrl(port, &v));
    return v;
}

pub fn setSWFlowCtrl(port: Port, enable: bool, rx_thresh_xon: u8, rx_thresh_xoff: u8) !void {
    return errors.espCheckError(sys.uart_set_sw_flow_ctrl(port, enable, rx_thresh_xon, rx_thresh_xoff));
}

// ─────────────────────────────────────────────────────────────────────────────
// Interrupt configuration
// ─────────────────────────────────────────────────────────────────────────────

pub fn intrConfig(port: Port, cfg: *const IntrConfig) !void {
    return errors.espCheckError(sys.uart_intr_config(port, cfg));
}

pub fn clearIntrStatus(port: Port, clr_mask: u32) !void {
    return errors.espCheckError(sys.uart_clear_intr_status(port, clr_mask));
}

pub fn enableIntrMask(port: Port, mask: u32) !void {
    return errors.espCheckError(sys.uart_enable_intr_mask(port, mask));
}

pub fn disableIntrMask(port: Port, mask: u32) !void {
    return errors.espCheckError(sys.uart_disable_intr_mask(port, mask));
}

pub fn enableRXIntr(port: Port) !void {
    return errors.espCheckError(sys.uart_enable_rx_intr(port));
}

pub fn disableRXIntr(port: Port) !void {
    return errors.espCheckError(sys.uart_disable_rx_intr(port));
}

pub fn enableTXIntr(port: Port, enable: bool, thresh: c_int) !void {
    return errors.espCheckError(sys.uart_enable_tx_intr(port, @intFromBool(enable), thresh));
}

pub fn disableTXIntr(port: Port) !void {
    return errors.espCheckError(sys.uart_disable_tx_intr(port));
}

// ─────────────────────────────────────────────────────────────────────────────
// RX / TX thresholds and timeouts
// ─────────────────────────────────────────────────────────────────────────────

pub fn setRXFullThreshold(port: Port, threshold: c_int) !void {
    return errors.espCheckError(sys.uart_set_rx_full_threshold(port, threshold));
}

pub fn setTXEmptyThreshold(port: Port, threshold: c_int) !void {
    return errors.espCheckError(sys.uart_set_tx_empty_threshold(port, threshold));
}

pub fn setRXTimeout(port: Port, tout_thresh: u8) !void {
    return errors.espCheckError(sys.uart_set_rx_timeout(port, tout_thresh));
}

// ─────────────────────────────────────────────────────────────────────────────
// Write
// ─────────────────────────────────────────────────────────────────────────────

/// Transmit raw bytes directly (no ring buffer).
/// Returns the number of bytes pushed into the TX FIFO.
pub fn txChars(port: Port, data: []const u8) usize {
    const rc = sys.uart_tx_chars(port, data.ptr, @intCast(data.len));
    return if (rc < 0) 0 else @intCast(rc);
}

/// Write bytes through the TX ring buffer (if installed) or directly.
/// Returns number of bytes written, or error on failure.
pub fn writeBytes(port: Port, data: []const u8) !usize {
    const rc = sys.uart_write_bytes(port, data.ptr, data.len);
    if (rc < 0) return error.UartWriteFailed;
    return @intCast(rc);
}

/// Like `writeBytes` but appends a serial break signal of `brk_len` bit-periods.
pub fn writeBytesWithBreak(port: Port, data: []const u8, brk_len: c_int) !usize {
    const rc = sys.uart_write_bytes_with_break(port, data.ptr, data.len, brk_len);
    if (rc < 0) return error.UartWriteFailed;
    return @intCast(rc);
}

pub fn waitTXDone(port: Port, ticks_to_wait: TickType) !void {
    return errors.espCheckError(sys.uart_wait_tx_done(port, ticks_to_wait));
}

pub fn waitTXIdlePolling(port: Port) !void {
    return errors.espCheckError(sys.uart_wait_tx_idle_polling(port));
}

// ─────────────────────────────────────────────────────────────────────────────
// Read
// ─────────────────────────────────────────────────────────────────────────────

/// Read up to `buf.len` bytes from the RX ring buffer.
/// Returns the number of bytes actually read, or error on failure.
pub fn readBytes(port: Port, buf: []u8, ticks_to_wait: TickType) !usize {
    const rc = sys.uart_read_bytes(port, buf.ptr, @intCast(buf.len), ticks_to_wait);
    if (rc < 0) return error.UartReadFailed;
    return @intCast(rc);
}

/// Returns the number of bytes waiting in the RX ring buffer.
pub fn getBufferedDataLen(port: Port) !usize {
    var v: usize = 0;
    try errors.espCheckError(sys.uart_get_buffered_data_len(port, &v));
    return v;
}

/// Returns free space in the TX ring buffer (bytes).
pub fn getTXBufferFreeSize(port: Port) !usize {
    var v: usize = 0;
    try errors.espCheckError(sys.uart_get_tx_buffer_free_size(port, &v));
    return v;
}

// ─────────────────────────────────────────────────────────────────────────────
// Flush
// ─────────────────────────────────────────────────────────────────────────────

/// Flush TX FIFO — waits until all bytes are sent.
pub fn flush(port: Port) !void {
    return errors.espCheckError(sys.uart_flush(port));
}

/// Flush (discard) RX ring buffer contents.
pub fn flushInput(port: Port) !void {
    return errors.espCheckError(sys.uart_flush_input(port));
}

// ─────────────────────────────────────────────────────────────────────────────
// Pattern detection
// ─────────────────────────────────────────────────────────────────────────────

pub const PatternConfig = struct {
    /// Character to detect (e.g. '+' for AT commands).
    chr: u8,
    /// Number of consecutive pattern characters required.
    chr_num: u8,
    /// Maximum gap between characters (in baud ticks).
    chr_tout: c_int,
    /// Idle time after pattern (baud ticks).
    post_idle: c_int,
    /// Idle time before pattern (baud ticks).
    pre_idle: c_int,
};

pub fn enablePatternDetBaudIntr(port: Port, cfg: PatternConfig) !void {
    return errors.espCheckError(sys.uart_enable_pattern_det_baud_intr(
        port,
        cfg.chr,
        cfg.chr_num,
        cfg.chr_tout,
        cfg.post_idle,
        cfg.pre_idle,
    ));
}

pub fn disablePatternDetIntr(port: Port) !void {
    return errors.espCheckError(sys.uart_disable_pattern_det_intr(port));
}

/// Pop the oldest pattern position from the queue.
/// Returns `null` if the queue is empty or an error occurred.
pub fn patternPopPos(port: Port) ?usize {
    const rc = sys.uart_pattern_pop_pos(port);
    return if (rc < 0) null else @intCast(rc);
}

/// Peek at the oldest pattern position without removing it.
pub fn patternGetPos(port: Port) ?usize {
    const rc = sys.uart_pattern_get_pos(port);
    return if (rc < 0) null else @intCast(rc);
}

pub fn patternQueueReset(port: Port, queue_length: c_int) !void {
    return errors.espCheckError(sys.uart_pattern_queue_reset(port, queue_length));
}

// ─────────────────────────────────────────────────────────────────────────────
// RS-485 collision detection
// ─────────────────────────────────────────────────────────────────────────────

pub fn getCollisionFlag(port: Port) !bool {
    var v: bool = false;
    try errors.espCheckError(sys.uart_get_collision_flag(port, &v));
    return v;
}

// ─────────────────────────────────────────────────────────────────────────────
// Light-sleep wakeup
// ─────────────────────────────────────────────────────────────────────────────

pub fn setWakeupThreshold(port: Port, threshold: c_int) !void {
    return errors.espCheckError(sys.uart_set_wakeup_threshold(port, threshold));
}

pub fn getWakeupThreshold(port: Port) !c_int {
    var v: c_int = 0;
    try errors.espCheckError(sys.uart_get_wakeup_threshold(port, &v));
    return v;
}
