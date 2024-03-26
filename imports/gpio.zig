const sys = @import("sys");
const std = @import("std");
const errors = @import("error");

pub fn newEtmEvent(cfg: [*c]const sys.gpio_etm_event_config_t, ret_event: [*c]sys.esp_etm_event_handle_t) !void {
    return try errors.espCheckError(sys.gpio_new_etm_event(cfg, ret_event));
}
pub fn etmEventBindGPIO(event: sys.esp_etm_event_handle_t, gpio_num: c_int) !void {
    return try errors.espCheckError(sys.gpio_etm_event_bind_gpio(event, gpio_num));
}
pub fn newEtmTask(cfg: [*c]const sys.gpio_etm_task_config_t, ret_task: [*c]sys.esp_etm_task_handle_t) !void {
    return try errors.espCheckError(sys.gpio_new_etm_task(cfg, ret_task));
}
pub fn etmTaskAddGPIO(task: sys.esp_etm_task_handle_t, gpio_num: c_int) !void {
    return try errors.espCheckError(sys.gpio_etm_task_add_gpio(task, gpio_num));
}
pub fn etmTaskRemoveGPIO(task: sys.esp_etm_task_handle_t, gpio_num: c_int) !void {
    return try errors.espCheckError(sys.gpio_etm_task_rm_gpio(task, gpio_num));
}

pub fn config(pGPIOConfig: [*c]const sys.gpio_config_t) !void {
    return try errors.espCheckError(sys.gpio_config(pGPIOConfig));
}
pub fn resetPin(gpio_num: sys.gpio_num_t) !void {
    return try errors.espCheckError(sys.gpio_reset_pin(gpio_num));
}
pub fn setIntrType(gpio_num: sys.gpio_num_t, intr_type: sys.gpio_int_type_t) !void {
    return try errors.espCheckError(sys.gpio_set_intr_type(gpio_num, intr_type));
}
pub fn intrEnable(gpio_num: sys.gpio_num_t) !void {
    return try errors.espCheckError(sys.gpio_intr_enable(gpio_num));
}
pub fn intrDisable(gpio_num: sys.gpio_num_t) !void {
    return try errors.espCheckError(sys.gpio_intr_disable(gpio_num));
}

pub const Level = struct {
    pub fn set(gpio_num: sys.gpio_num_t, level: u32) !void {
        return try errors.espCheckError(sys.gpio_set_level(gpio_num, level));
    }
    pub fn get(gpio_num: sys.gpio_num_t) bool {
        return @as(bool, sys.gpio_get_level(gpio_num));
    }
};
pub const Direction = struct {
    pub fn set(gpio_num: sys.gpio_num_t, mode: sys.gpio_mode_t) !void {
        return try errors.espCheckError(sys.gpio_set_direction(gpio_num, mode));
    }
    pub fn sleepSet(gpio_num: sys.gpio_num_t, mode: sys.gpio_mode_t) !void {
        return try errors.espCheckError(sys.gpio_sleep_set_direction(gpio_num, mode));
    }
};
pub fn setPullMode(gpio_num: sys.gpio_num_t, pull: sys.gpio_pull_mode_t) !void {
    return try errors.espCheckError(sys.gpio_set_pull_mode(gpio_num, pull));
}
pub fn wakeupEnable(gpio_num: sys.gpio_num_t, intr_type: sys.gpio_int_type_t) !void {
    return try errors.espCheckError(sys.gpio_wakeup_enable(gpio_num, intr_type));
}
pub fn wakeupDisable(gpio_num: sys.gpio_num_t) !void {
    return try errors.espCheckError(sys.gpio_wakeup_disable(gpio_num));
}
pub fn isrRegister(@"fn": ?*const fn (?*anyopaque) callconv(.C) void, arg: ?*anyopaque, intr_alloc_flags: c_int, handle: [*c]sys.gpio_isr_handle_t) !void {
    return try errors.espCheckError(sys.gpio_isr_register(@"fn", arg, intr_alloc_flags, handle));
}
pub const PULL = struct {
    pub fn upEn(gpio_num: sys.gpio_num_t) !void {
        return try errors.espCheckError(sys.gpio_pullup_en(gpio_num));
    }
    pub fn upDis(gpio_num: sys.gpio_num_t) !void {
        return try errors.espCheckError(sys.gpio_pullup_dis(gpio_num));
    }
    pub fn downEn(gpio_num: sys.gpio_num_t) !void {
        return try errors.espCheckError(sys.gpio_pulldown_en(gpio_num));
    }
    pub fn downDis(gpio_num: sys.gpio_num_t) !void {
        return try errors.espCheckError(sys.gpio_pulldown_dis(gpio_num));
    }
};
pub fn installISRService(intr_alloc_flags: c_int) !void {
    return try errors.espCheckError(sys.gpio_install_isr_service(intr_alloc_flags));
}
pub fn uninstallISRService() void {
    sys.gpio_uninstall_isr_service();
}
pub fn isrHandlerAdd(gpio_num: sys.gpio_num_t, isr_handler: sys.gpio_isr_t, args: ?*anyopaque) !void {
    return try errors.espCheckError(sys.gpio_isr_handler_add(gpio_num, isr_handler, args));
}
pub fn isrHandlerRemove(gpio_num: sys.gpio_num_t) !void {
    return try errors.espCheckError(sys.gpio_isr_handler_remove(gpio_num));
}
pub fn setDriveCapability(gpio_num: sys.gpio_num_t, strength: sys.gpio_drive_cap_t) !void {
    return try errors.espCheckError(sys.gpio_set_drive_capability(gpio_num, strength));
}
pub fn getDriveCapability(gpio_num: sys.gpio_num_t, strength: [*c]sys.gpio_drive_cap_t) !void {
    return try errors.espCheckError(sys.gpio_get_drive_capability(gpio_num, strength));
}
pub fn holdEn(gpio_num: sys.gpio_num_t) !void {
    return try errors.espCheckError(sys.gpio_hold_en(gpio_num));
}
pub fn holdDis(gpio_num: sys.gpio_num_t) !void {
    return try errors.espCheckError(sys.gpio_hold_dis(gpio_num));
}
pub fn deepSleepHoldEn() void {
    sys.gpio_deep_sleep_hold_en();
}
pub fn deepSleepHoldDis() void {
    sys.gpio_deep_sleep_hold_dis();
}
pub fn iomuxIn(gpio_num: u32, signal_idx: u32) void {
    sys.gpio_iomux_in(gpio_num, signal_idx);
}
pub fn iomuxOut(gpio_num: u8, func: c_int, oen_inv: bool) void {
    sys.gpio_iomux_out(gpio_num, func, oen_inv);
}
pub fn forceHoldAll() !void {
    return try errors.espCheckError(sys.gpio_force_hold_all());
}
pub fn forceUnholdAll() !void {
    return try errors.espCheckError(sys.gpio_force_unhold_all());
}
pub fn sleepSelEn(gpio_num: sys.gpio_num_t) !void {
    return try errors.espCheckError(sys.gpio_sleep_sel_en(gpio_num));
}
pub fn sleepSelDis(gpio_num: sys.gpio_num_t) !void {
    return try errors.espCheckError(sys.gpio_sleep_sel_dis(gpio_num));
}
pub fn sleepSetPullMode(gpio_num: sys.gpio_num_t, pull: sys.gpio_pull_mode_t) !void {
    return try errors.espCheckError(sys.gpio_sleep_set_pull_mode(gpio_num, pull));
}
pub fn deepSleepWakeupEnable(gpio_num: sys.gpio_num_t, intr_type: sys.gpio_int_type_t) !void {
    return try errors.espCheckError(sys.gpio_deep_sleep_wakeup_enable(gpio_num, intr_type));
}
pub fn deepSleepWakeupDisable(gpio_num: sys.gpio_num_t) !void {
    return try errors.espCheckError(sys.gpio_deep_sleep_wakeup_disable(gpio_num));
}
pub fn dumpIOConfiguration(out_stream: ?*std.c.FILE, io_bit_mask: u64) !void {
    return try errors.espCheckError(sys.gpio_dump_io_configuration(out_stream, io_bit_mask));
}

pub const ROM = struct {
    pub fn padSelectGPIO(iopad_num: u32) void {
        sys.esp_rom_gpio_pad_select_gpio(iopad_num);
    }
    pub fn padPullupOnly(iopad_num: u32) void {
        sys.esp_rom_gpio_pad_pullup_only(iopad_num);
    }
    pub fn padUnhold(gpio_num: u32) void {
        sys.esp_rom_gpio_pad_unhold(gpio_num);
    }
    pub fn padSetDrive(iopad_num: u32, drv: u32) void {
        sys.esp_rom_gpio_pad_set_drv(iopad_num, drv);
    }
    pub fn connectInSignal(gpio_num: u32, signal_idx: u32, inv: bool) void {
        sys.esp_rom_gpio_connect_in_signal(gpio_num, signal_idx, inv);
    }
    pub fn connectOutSignal(gpio_num: u32, signal_idx: u32, out_inv: bool, oen_inv: bool) void {
        sys.esp_rom_gpio_connect_out_signal(gpio_num, signal_idx, out_inv, oen_inv);
    }
};

pub const ETM = struct {
    pub fn newChannel(cfg: [*c]const sys.esp_etm_channel_config_t, ret_chan: [*c]sys.esp_etm_channel_handle_t) !void {
        return try errors.espCheckError(sys.esp_etm_new_channel(cfg, ret_chan));
    }
    pub fn delChannel(chan: sys.esp_etm_channel_handle_t) !void {
        return try errors.espCheckError(sys.esp_etm_del_channel(chan));
    }
    pub fn channelEnable(chan: sys.esp_etm_channel_handle_t) !void {
        return try errors.espCheckError(sys.esp_etm_channel_enable(chan));
    }
    pub fn channelDisable(chan: sys.esp_etm_channel_handle_t) !void {
        return try errors.espCheckError(sys.esp_etm_channel_disable(chan));
    }
    pub fn channelConnect(chan: sys.esp_etm_channel_handle_t, event: sys.esp_etm_event_handle_t, task: sys.esp_etm_task_handle_t) !void {
        return try errors.espCheckError(sys.esp_etm_channel_connect(chan, event, task));
    }
    pub fn delEvent(event: sys.esp_etm_event_handle_t) !void {
        return try errors.espCheckError(sys.esp_etm_del_event(event));
    }
    pub fn delTask(task: sys.esp_etm_task_handle_t) !void {
        return try errors.espCheckError(sys.esp_etm_del_task(task));
    }
    pub fn dump(out_stream: ?*std.c.FILE) !void {
        return try errors.espCheckError(sys.esp_etm_dump(out_stream));
    }
};
