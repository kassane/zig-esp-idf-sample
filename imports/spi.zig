const sys = @import("sys");
const errors = @import("error");

pub fn busInitialize(host_id: sys.spi_host_device_t, bus_config: [*c]const sys.spi_bus_config_t, dma_chan: sys.spi_dma_chan_t) !void {
    return try errors.espCheckError(sys.spi_bus_initialize(host_id, bus_config, dma_chan));
}
pub fn busFree(host_id: sys.spi_host_device_t) !void {
    return try errors.espCheckError(sys.spi_bus_free(host_id));
}
pub fn busAddDevice(host_id: sys.spi_host_device_t, dev_config: [*c]const sys.spi_device_interface_config_t, handle: [*c]sys.spi_device_handle_t) !void {
    return try errors.espCheckError(sys.spi_bus_add_device(host_id, dev_config, handle));
}
pub fn busRemoveDevice(handle: sys.spi_device_handle_t) !void {
    return try errors.espCheckError(sys.spi_bus_remove_device(handle));
}
pub fn deviceQueueTrans(handle: sys.spi_device_handle_t, trans_desc: [*c]sys.spi_transaction_t, ticks_to_wait: sys.TickType_t) !void {
    return try errors.espCheckError(sys.spi_device_queue_trans(handle, trans_desc, ticks_to_wait));
}
pub fn deviceGetTransResult(handle: sys.spi_device_handle_t, trans_desc: [*c][*c]sys.spi_transaction_t, ticks_to_wait: sys.TickType_t) !void {
    return try errors.espCheckError(sys.spi_device_get_trans_result(handle, trans_desc, ticks_to_wait));
}
pub fn deviceTransmit(handle: sys.spi_device_handle_t, trans_desc: [*c]sys.spi_transaction_t) !void {
    return try errors.espCheckError(sys.spi_device_transmit(handle, trans_desc));
}
pub fn devicePollingStart(handle: sys.spi_device_handle_t, trans_desc: [*c]sys.spi_transaction_t, ticks_to_wait: sys.TickType_t) !void {
    return try errors.espCheckError(sys.spi_device_polling_start(handle, trans_desc, ticks_to_wait));
}
pub fn devicePollingEnd(handle: sys.spi_device_handle_t, ticks_to_wait: sys.TickType_t) !void {
    return try errors.espCheckError(sys.spi_device_polling_end(handle, ticks_to_wait));
}
pub fn devicePollingTransmit(handle: sys.spi_device_handle_t, trans_desc: [*c]sys.spi_transaction_t) !void {
    return try errors.espCheckError(sys.spi_device_polling_transmit(handle, trans_desc));
}
pub fn deviceAcquireBus(device: sys.spi_device_handle_t, wait: sys.TickType_t) !void {
    return try errors.espCheckError(sys.spi_device_acquire_bus(device, wait));
}
pub fn deviceReleaseBus(dev: sys.spi_device_handle_t) void {
    sys.spi_device_release_bus(dev);
}
pub fn deviceGetActualFreq(handle: sys.spi_device_handle_t, freq_khz: [*c]c_int) !void {
    return try errors.espCheckError(sys.spi_device_get_actual_freq(handle, freq_khz));
}
pub fn getActualClock(fapb: c_int, hz: c_int, duty_cycle: c_int) c_int {
    return sys.spi_get_actual_clock(fapb, hz, duty_cycle);
}
pub fn getTiming(gpio_is_used: bool, input_delay_ns: c_int, eff_clk: c_int, dummy_o: [*c]c_int, cycles_remain_o: [*c]c_int) void {
    sys.spi_get_timing(gpio_is_used, input_delay_ns, eff_clk, dummy_o, cycles_remain_o);
}
pub fn getFreqLimit(gpio_is_used: bool, input_delay_ns: c_int) c_int {
    return sys.spi_get_freq_limit(gpio_is_used, input_delay_ns);
}
pub fn busGetMaxTransactionLen(host_id: sys.spi_host_device_t, max_bytes: [*c]usize) !void {
    return try errors.espCheckError(sys.spi_bus_get_max_transaction_len(host_id, max_bytes));
}

pub const SDSPI = struct {
    pub const Host = struct {
        pub fn init() !void {
            return try errors.espCheckError(sys.sdspi_host_init());
        }
        pub fn initDevice(dev_config: [*c]const sys.sdspi_device_config_t, out_handle: [*c]sys.sdspi_dev_handle_t) !void {
            return try errors.espCheckError(sys.sdspi_host_init_device(dev_config, out_handle));
        }
        pub fn removeDevice(handle: sys.sdspi_dev_handle_t) !void {
            return try errors.espCheckError(sys.sdspi_host_remove_device(handle));
        }
        pub fn doTransaction(handle: sys.sdspi_dev_handle_t, cmdinfo: [*c]sys.sdmmc_command_t) !void {
            return try errors.espCheckError(sys.sdspi_host_do_transaction(handle, cmdinfo));
        }
        pub fn setCardClk(host: sys.sdspi_dev_handle_t, freq_khz: u32) !void {
            return try errors.espCheckError(sys.sdspi_host_set_card_clk(host, freq_khz));
        }
        pub fn getRealFreq(handle: sys.sdspi_dev_handle_t, real_freq_khz: [*c]c_int) !void {
            return try errors.espCheckError(sys.sdspi_host_get_real_freq(handle, real_freq_khz));
        }
        pub fn deinit() !void {
            return try errors.espCheckError(sys.sdspi_host_deinit());
        }
        pub const IO = struct {
            pub fn intEnable(handle: sys.sdspi_dev_handle_t) !void {
                return try errors.espCheckError(sys.sdspi_host_io_int_enable(handle));
            }
            pub fn intWait(handle: sys.sdspi_dev_handle_t, timeout_ticks: sys.TickType_t) !void {
                return try errors.espCheckError(sys.sdspi_host_io_int_wait(handle, timeout_ticks));
            }
        };
    };
};
