const sys = @import("sys");
const errors = @import("error");

pub const BUS = struct {
    pub fn add(bus_config: ?*const sys.i2c_master_bus_config_t, ret_bus_handle: [*c]sys.i2c_master_bus_handle_t) !void {
        return try errors.espCheckError(sys.i2c_new_master_bus(bus_config, ret_bus_handle));
    }
    pub fn addDevice(bus_handle: sys.i2c_master_bus_handle_t, dev_config: [*c]const sys.i2c_device_config_t, ret_handle: [*c]sys.i2c_master_dev_handle_t) !void {
        return try errors.espCheckError(sys.i2c_master_bus_add_device(bus_handle, dev_config, ret_handle));
    }
    pub fn del(bus_handle: sys.i2c_master_bus_handle_t) !void {
        return try errors.espCheckError(sys.i2c_del_master_bus(bus_handle));
    }
    pub fn removeDevice(handle: sys.i2c_master_dev_handle_t) !void {
        return try errors.espCheckError(sys.i2c_master_bus_rm_device(handle));
    }
    pub fn reset(handle: sys.i2c_master_bus_handle_t) !void {
        return try errors.espCheckError(sys.i2c_master_bus_reset(handle));
    }
};

pub fn transmit(i2c_dev: sys.i2c_master_dev_handle_t, write_buffer: [*:0]const u8, write_size: usize, xfer_timeout_ms: c_int) !void {
    return try errors.espCheckError(sys.i2c_master_transmit(i2c_dev, write_buffer, write_size, xfer_timeout_ms));
}
pub fn transmitReceive(i2c_dev: sys.i2c_master_dev_handle_t, write_buffer: [*:0]const u8, write_size: usize, read_buffer: [*:0]u8, read_size: usize, xfer_timeout_ms: c_int) !void {
    return try errors.espCheckError(sys.i2c_master_transmit_receive(i2c_dev, write_buffer, write_size, read_buffer, read_size, xfer_timeout_ms));
}
pub fn receive(i2c_dev: sys.i2c_master_dev_handle_t, read_buffer: [*:0]u8, read_size: usize, xfer_timeout_ms: c_int) !void {
    return try errors.espCheckError(sys.i2c_master_receive(i2c_dev, read_buffer, read_size, xfer_timeout_ms));
}
pub fn probe(i2c_master: sys.i2c_master_bus_handle_t, address: u16, xfer_timeout_ms: c_int) !void {
    return try errors.espCheckError(sys.i2c_master_probe(i2c_master, address, xfer_timeout_ms));
}
pub fn registerEventCallbacks(i2c_dev: sys.i2c_master_dev_handle_t, cbs: [*c]const sys.i2c_master_event_callbacks_t, user_data: ?*anyopaque) !void {
    return try errors.espCheckError(sys.i2c_master_register_event_callbacks(i2c_dev, cbs, user_data));
}
pub fn waitAllDone(i2c_master: sys.i2c_master_bus_handle_t, timeout_ms: c_int) !void {
    return try errors.espCheckError(sys.i2c_master_wait_all_done(i2c_master, timeout_ms));
}
