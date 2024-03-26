const sys = @import("sys");
const errors = @import("error");

pub fn newChannel(chan_cfg: [*c]const sys.i2s_chan_config_t, ret_tx_handle: [*c]sys.i2s_chan_handle_t, ret_rx_handle: [*c]sys.i2s_chan_handle_t) !void {
    return try errors.espCheckError(sys.i2s_new_channel(chan_cfg, ret_tx_handle, ret_rx_handle));
}
pub fn delChannel(handle: sys.i2s_chan_handle_t) !void {
    return try errors.espCheckError(sys.i2s_del_channel(handle));
}
pub fn channelGetInfo(handle: sys.i2s_chan_handle_t, chan_info: [*c]sys.i2s_chan_info_t) !void {
    return try errors.espCheckError(sys.i2s_channel_get_info(handle, chan_info));
}
pub fn channelEnable(handle: sys.i2s_chan_handle_t) !void {
    return try errors.espCheckError(sys.i2s_channel_enable(handle));
}
pub fn channelDisable(handle: sys.i2s_chan_handle_t) !void {
    return try errors.espCheckError(sys.i2s_channel_disable(handle));
}
pub fn channelPreloadData(tx_handle: sys.i2s_chan_handle_t, src: ?*const anyopaque, size: usize, bytes_loaded: [*c]usize) !void {
    return try errors.espCheckError(sys.i2s_channel_preload_data(tx_handle, src, size, bytes_loaded));
}
pub fn channelWrite(handle: sys.i2s_chan_handle_t, src: ?*const anyopaque, size: usize, bytes_written: [*c]usize, timeout_ms: u32) !void {
    return try errors.espCheckError(sys.i2s_channel_write(handle, src, size, bytes_written, timeout_ms));
}
pub fn channelRead(handle: sys.i2s_chan_handle_t, dest: ?*anyopaque, size: usize, bytes_read: [*c]usize, timeout_ms: u32) !void {
    return try errors.espCheckError(sys.i2s_channel_read(handle, dest, size, bytes_read, timeout_ms));
}
pub fn channelRegisterEventCallback(handle: sys.i2s_chan_handle_t, callbacks: [*c]const sys.i2s_event_callbacks_t, user_data: ?*anyopaque) !void {
    return try errors.espCheckError(sys.i2s_channel_register_event_callback(handle, callbacks, user_data));
}
pub fn channelInitPdmRXMode(handle: sys.i2s_chan_handle_t, pdm_rx_cfg: ?*const sys.i2s_pdm_rx_config_t) !void {
    return try errors.espCheckError(sys.i2s_channel_init_pdm_rx_mode(handle, pdm_rx_cfg));
}
pub fn channelReconfigPdmRXClock(handle: sys.i2s_chan_handle_t, clk_cfg: [*c]const sys.i2s_pdm_rx_clk_config_t) !void {
    return try errors.espCheckError(sys.i2s_channel_reconfig_pdm_rx_clock(handle, clk_cfg));
}
pub fn channelReconfigPdmRXSlot(handle: sys.i2s_chan_handle_t, slot_cfg: [*c]const sys.i2s_pdm_rx_slot_config_t) !void {
    return try errors.espCheckError(sys.i2s_channel_reconfig_pdm_rx_slot(handle, slot_cfg));
}
pub fn channelReconfigPdmRXGPIO(handle: sys.i2s_chan_handle_t, gpio_cfg: ?*const sys.i2s_pdm_rx_gpio_config_t) !void {
    return try errors.espCheckError(sys.i2s_channel_reconfig_pdm_rx_gpio(handle, gpio_cfg));
}
pub fn channelInitPdmTXMode(handle: sys.i2s_chan_handle_t, pdm_tx_cfg: ?*const sys.i2s_pdm_tx_config_t) !void {
    return try errors.espCheckError(sys.i2s_channel_init_pdm_tx_mode(handle, pdm_tx_cfg));
}
pub fn channelReconfigPdmTXClock(handle: sys.i2s_chan_handle_t, clk_cfg: [*c]const sys.i2s_pdm_tx_clk_config_t) !void {
    return try errors.espCheckError(sys.i2s_channel_reconfig_pdm_tx_clock(handle, clk_cfg));
}
pub fn channelReconfigPdmTXSlot(handle: sys.i2s_chan_handle_t, slot_cfg: [*c]const sys.i2s_pdm_tx_slot_config_t) !void {
    return try errors.espCheckError(sys.i2s_channel_reconfig_pdm_tx_slot(handle, slot_cfg));
}
pub fn channelReconfigPdmTXGPIO(handle: sys.i2s_chan_handle_t, gpio_cfg: ?*const sys.i2s_pdm_tx_gpio_config_t) !void {
    return try errors.espCheckError(sys.i2s_channel_reconfig_pdm_tx_gpio(handle, gpio_cfg));
}
