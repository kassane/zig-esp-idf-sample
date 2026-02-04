const sys = @import("sys");
const std = @import("std");
const errors = @import("error");

pub const Num = enum(sys.gpio_num_t) {
    GPIO_NUM_NC = sys.GPIO_NUM_NC,
    GPIO_NUM_0 = if (@hasDecl(sys, "GPIO_NUM_0")) sys.GPIO_NUM_0 else sys.GPIO_NUM_MAX + 1000,
    GPIO_NUM_1 = if (@hasDecl(sys, "GPIO_NUM_1")) sys.GPIO_NUM_1 else sys.GPIO_NUM_MAX + 1001,
    GPIO_NUM_2 = if (@hasDecl(sys, "GPIO_NUM_2")) sys.GPIO_NUM_2 else sys.GPIO_NUM_MAX + 1002,
    GPIO_NUM_3 = if (@hasDecl(sys, "GPIO_NUM_3")) sys.GPIO_NUM_3 else sys.GPIO_NUM_MAX + 1003,
    GPIO_NUM_4 = if (@hasDecl(sys, "GPIO_NUM_4")) sys.GPIO_NUM_4 else sys.GPIO_NUM_MAX + 1004,
    GPIO_NUM_5 = if (@hasDecl(sys, "GPIO_NUM_5")) sys.GPIO_NUM_5 else sys.GPIO_NUM_MAX + 1005,
    GPIO_NUM_6 = if (@hasDecl(sys, "GPIO_NUM_6")) sys.GPIO_NUM_6 else sys.GPIO_NUM_MAX + 1006,
    GPIO_NUM_7 = if (@hasDecl(sys, "GPIO_NUM_7")) sys.GPIO_NUM_7 else sys.GPIO_NUM_MAX + 1007,
    GPIO_NUM_8 = if (@hasDecl(sys, "GPIO_NUM_8")) sys.GPIO_NUM_8 else sys.GPIO_NUM_MAX + 1008,
    GPIO_NUM_9 = if (@hasDecl(sys, "GPIO_NUM_9")) sys.GPIO_NUM_9 else sys.GPIO_NUM_MAX + 1009,
    GPIO_NUM_10 = if (@hasDecl(sys, "GPIO_NUM_10")) sys.GPIO_NUM_10 else sys.GPIO_NUM_MAX + 1010,
    GPIO_NUM_11 = if (@hasDecl(sys, "GPIO_NUM_11")) sys.GPIO_NUM_11 else sys.GPIO_NUM_MAX + 1011,
    GPIO_NUM_12 = if (@hasDecl(sys, "GPIO_NUM_12")) sys.GPIO_NUM_12 else sys.GPIO_NUM_MAX + 1012,
    GPIO_NUM_13 = if (@hasDecl(sys, "GPIO_NUM_13")) sys.GPIO_NUM_13 else sys.GPIO_NUM_MAX + 1013,
    GPIO_NUM_14 = if (@hasDecl(sys, "GPIO_NUM_14")) sys.GPIO_NUM_14 else sys.GPIO_NUM_MAX + 1014,
    GPIO_NUM_15 = if (@hasDecl(sys, "GPIO_NUM_15")) sys.GPIO_NUM_15 else sys.GPIO_NUM_MAX + 1015,
    GPIO_NUM_16 = if (@hasDecl(sys, "GPIO_NUM_16")) sys.GPIO_NUM_16 else sys.GPIO_NUM_MAX + 1016,
    GPIO_NUM_17 = if (@hasDecl(sys, "GPIO_NUM_17")) sys.GPIO_NUM_17 else sys.GPIO_NUM_MAX + 1017,
    GPIO_NUM_18 = if (@hasDecl(sys, "GPIO_NUM_18")) sys.GPIO_NUM_18 else sys.GPIO_NUM_MAX + 1018,
    GPIO_NUM_19 = if (@hasDecl(sys, "GPIO_NUM_19")) sys.GPIO_NUM_19 else sys.GPIO_NUM_MAX + 1019,
    GPIO_NUM_20 = if (@hasDecl(sys, "GPIO_NUM_20")) sys.GPIO_NUM_20 else sys.GPIO_NUM_MAX + 1020,
    GPIO_NUM_21 = if (@hasDecl(sys, "GPIO_NUM_21")) sys.GPIO_NUM_21 else sys.GPIO_NUM_MAX + 1021,
    GPIO_NUM_22 = if (@hasDecl(sys, "GPIO_NUM_22")) sys.GPIO_NUM_22 else sys.GPIO_NUM_MAX + 1022,
    GPIO_NUM_23 = if (@hasDecl(sys, "GPIO_NUM_23")) sys.GPIO_NUM_23 else sys.GPIO_NUM_MAX + 1023,
    GPIO_NUM_24 = if (@hasDecl(sys, "GPIO_NUM_24")) sys.GPIO_NUM_24 else sys.GPIO_NUM_MAX + 1024,
    GPIO_NUM_25 = if (@hasDecl(sys, "GPIO_NUM_25")) sys.GPIO_NUM_25 else sys.GPIO_NUM_MAX + 1025,
    GPIO_NUM_26 = if (@hasDecl(sys, "GPIO_NUM_26")) sys.GPIO_NUM_26 else sys.GPIO_NUM_MAX + 1026,
    GPIO_NUM_27 = if (@hasDecl(sys, "GPIO_NUM_27")) sys.GPIO_NUM_27 else sys.GPIO_NUM_MAX + 1027,
    GPIO_NUM_28 = if (@hasDecl(sys, "GPIO_NUM_28")) sys.GPIO_NUM_28 else sys.GPIO_NUM_MAX + 1028,
    GPIO_NUM_29 = if (@hasDecl(sys, "GPIO_NUM_29")) sys.GPIO_NUM_29 else sys.GPIO_NUM_MAX + 1029,
    GPIO_NUM_30 = if (@hasDecl(sys, "GPIO_NUM_30")) sys.GPIO_NUM_30 else sys.GPIO_NUM_MAX + 1030,
    GPIO_NUM_31 = if (@hasDecl(sys, "GPIO_NUM_31")) sys.GPIO_NUM_31 else sys.GPIO_NUM_MAX + 1031,
    GPIO_NUM_32 = if (@hasDecl(sys, "GPIO_NUM_32")) sys.GPIO_NUM_32 else sys.GPIO_NUM_MAX + 1032,
    GPIO_NUM_33 = if (@hasDecl(sys, "GPIO_NUM_33")) sys.GPIO_NUM_33 else sys.GPIO_NUM_MAX + 1033,
    GPIO_NUM_34 = if (@hasDecl(sys, "GPIO_NUM_34")) sys.GPIO_NUM_34 else sys.GPIO_NUM_MAX + 1034,
    GPIO_NUM_35 = if (@hasDecl(sys, "GPIO_NUM_35")) sys.GPIO_NUM_35 else sys.GPIO_NUM_MAX + 1035,
    GPIO_NUM_36 = if (@hasDecl(sys, "GPIO_NUM_36")) sys.GPIO_NUM_36 else sys.GPIO_NUM_MAX + 1036,
    GPIO_NUM_37 = if (@hasDecl(sys, "GPIO_NUM_37")) sys.GPIO_NUM_37 else sys.GPIO_NUM_MAX + 1037,
    GPIO_NUM_38 = if (@hasDecl(sys, "GPIO_NUM_38")) sys.GPIO_NUM_38 else sys.GPIO_NUM_MAX + 1038,
    GPIO_NUM_39 = if (@hasDecl(sys, "GPIO_NUM_39")) sys.GPIO_NUM_39 else sys.GPIO_NUM_MAX + 1039,
    GPIO_NUM_40 = if (@hasDecl(sys, "GPIO_NUM_40")) sys.GPIO_NUM_40 else sys.GPIO_NUM_MAX + 1040,
    GPIO_NUM_41 = if (@hasDecl(sys, "GPIO_NUM_41")) sys.GPIO_NUM_41 else sys.GPIO_NUM_MAX + 1041,
    GPIO_NUM_42 = if (@hasDecl(sys, "GPIO_NUM_42")) sys.GPIO_NUM_42 else sys.GPIO_NUM_MAX + 1042,
    GPIO_NUM_43 = if (@hasDecl(sys, "GPIO_NUM_43")) sys.GPIO_NUM_43 else sys.GPIO_NUM_MAX + 1043,
    GPIO_NUM_44 = if (@hasDecl(sys, "GPIO_NUM_44")) sys.GPIO_NUM_44 else sys.GPIO_NUM_MAX + 1044,
    GPIO_NUM_45 = if (@hasDecl(sys, "GPIO_NUM_45")) sys.GPIO_NUM_45 else sys.GPIO_NUM_MAX + 1045,
    GPIO_NUM_46 = if (@hasDecl(sys, "GPIO_NUM_46")) sys.GPIO_NUM_46 else sys.GPIO_NUM_MAX + 1046,
    GPIO_NUM_47 = if (@hasDecl(sys, "GPIO_NUM_47")) sys.GPIO_NUM_47 else sys.GPIO_NUM_MAX + 1047,
    GPIO_NUM_48 = if (@hasDecl(sys, "GPIO_NUM_48")) sys.GPIO_NUM_48 else sys.GPIO_NUM_MAX + 1048,
    GPIO_NUM_MAX = sys.GPIO_NUM_MAX,
};

pub const Port = enum(sys.gpio_port_t) {
    GPIO_PORT_0 = sys.GPIO_PORT_0,
    GPIO_PORT_MAX = sys.GPIO_PORT_MAX,
};

pub const IntType = enum(sys.gpio_int_type_t) {
    GPIO_INTR_DISABLE = sys.GPIO_INTR_DISABLE,
    GPIO_INTR_POSEDGE = sys.GPIO_INTR_POSEDGE,
    GPIO_INTR_NEGEDGE = sys.GPIO_INTR_NEGEDGE,
    GPIO_INTR_ANYEDGE = sys.GPIO_INTR_ANYEDGE,
    GPIO_INTR_LOW_LEVEL = sys.GPIO_INTR_LOW_LEVEL,
    GPIO_INTR_HIGH_LEVEL = sys.GPIO_INTR_HIGH_LEVEL,
    GPIO_INTR_MAX = sys.GPIO_INTR_MAX,
};

pub const Mode = enum(sys.gpio_mode_t) {
    GPIO_MODE_DISABLE = sys.GPIO_MODE_DISABLE,
    GPIO_MODE_INPUT = sys.GPIO_MODE_INPUT,
    GPIO_MODE_OUTPUT = sys.GPIO_MODE_OUTPUT,
    GPIO_MODE_OUTPUT_OD = sys.GPIO_MODE_OUTPUT_OD,
    GPIO_MODE_INPUT_OUTPUT_OD = sys.GPIO_MODE_INPUT_OUTPUT_OD,
    GPIO_MODE_INPUT_OUTPUT = sys.GPIO_MODE_INPUT_OUTPUT,
};

pub const Pullup = enum(sys.gpio_pullup_t) {
    GPIO_PULLUP_DISABLE = sys.GPIO_PULLUP_DISABLE,
    GPIO_PULLUP_ENABLE = sys.GPIO_PULLUP_ENABLE,
};

pub const Pulldown = enum(sys.gpio_pulldown_t) {
    GPIO_PULLDOWN_DISABLE = sys.GPIO_PULLDOWN_DISABLE,
    GPIO_PULLDOWN_ENABLE = sys.GPIO_PULLDOWN_ENABLE,
};

pub const PullMode = enum(sys.gpio_pull_mode_t) {
    GPIO_PULLUP_ONLY = sys.GPIO_PULLUP_ONLY,
    GPIO_PULLDOWN_ONLY = sys.GPIO_PULLDOWN_ONLY,
    GPIO_PULLUP_PULLDOWN = sys.GPIO_PULLUP_PULLDOWN,
    GPIO_FLOATING = sys.GPIO_FLOATING,
};

pub const DriveCap = enum(sys.gpio_drive_cap_t) {
    GPIO_DRIVE_CAP_0 = sys.GPIO_DRIVE_CAP_0,
    GPIO_DRIVE_CAP_1 = sys.GPIO_DRIVE_CAP_1,
    GPIO_DRIVE_CAP_2 = sys.GPIO_DRIVE_CAP_2,
    GPIO_DRIVE_CAP_DEFAULT = sys.GPIO_DRIVE_CAP_DEFAULT,
    GPIO_DRIVE_CAP_3 = sys.GPIO_DRIVE_CAP_3,
    GPIO_DRIVE_CAP_MAX = sys.GPIO_DRIVE_CAP_MAX,
};

pub fn newEtmEvent(cfg: [*c]const sys.gpio_etm_event_config_t, ret_event: [*c]sys.esp_etm_event_handle_t) !void {
    return try errors.espCheckError(sys.gpio_new_etm_event(cfg, ret_event));
}
pub fn etmEventBindGPIO(event: sys.esp_etm_event_handle_t, gpio_num: Num) !void {
    return try errors.espCheckError(sys.gpio_etm_event_bind_gpio(event, @intFromEnum(gpio_num)));
}
pub fn newEtmTask(cfg: [*c]const sys.gpio_etm_task_config_t, ret_task: [*c]sys.esp_etm_task_handle_t) !void {
    return try errors.espCheckError(sys.gpio_new_etm_task(cfg, ret_task));
}
pub fn etmTaskAddGPIO(task: sys.esp_etm_task_handle_t, gpio_num: Num) !void {
    return try errors.espCheckError(sys.gpio_etm_task_add_gpio(task, @intFromEnum(gpio_num)));
}
pub fn etmTaskRemoveGPIO(task: sys.esp_etm_task_handle_t, gpio_num: Num) !void {
    return try errors.espCheckError(sys.gpio_etm_task_rm_gpio(task, @intFromEnum(gpio_num)));
}

pub fn config(pGPIOConfig: [*c]const sys.gpio_config_t) !void {
    return try errors.espCheckError(sys.gpio_config(pGPIOConfig));
}
pub fn resetPin(gpio_num: Num) !void {
    return try errors.espCheckError(sys.gpio_reset_pin(gpio_num));
}
pub fn setIntrType(gpio_num: Num, intr_type: sys.gpio_int_type_t) !void {
    return try errors.espCheckError(sys.gpio_set_intr_type(gpio_num, intr_type));
}
pub fn intrEnable(gpio_num: Num) !void {
    return try errors.espCheckError(sys.gpio_intr_enable(gpio_num));
}
pub fn intrDisable(gpio_num: Num) !void {
    return try errors.espCheckError(sys.gpio_intr_disable(gpio_num));
}

pub const Level = struct {
    pub fn set(gpio_num: Num, level: u32) !void {
        return try errors.espCheckError(sys.gpio_set_level(@intFromEnum(gpio_num), level));
    }
    pub fn get(gpio_num: Num) bool {
        return @as(bool, sys.gpio_get_level(@intFromEnum(gpio_num)));
    }
};
pub const Direction = struct {
    pub fn set(gpio_num: Num, mode: Mode) !void {
        return try errors.espCheckError(sys.gpio_set_direction(@intFromEnum(gpio_num), @intFromEnum(mode)));
    }
    pub fn sleepSet(gpio_num: Num, mode: Mode) !void {
        return try errors.espCheckError(sys.gpio_sleep_set_direction(@intFromEnum(gpio_num), @intFromEnum(mode)));
    }
};
pub fn setPullMode(gpio_num: Num, pull: sys.gpio_pull_mode_t) !void {
    return try errors.espCheckError(sys.gpio_set_pull_mode(@intFromEnum(gpio_num), pull));
}
pub fn wakeupEnable(gpio_num: Num, intr_type: sys.gpio_int_type_t) !void {
    return try errors.espCheckError(sys.gpio_wakeup_enable(@intFromEnum(gpio_num), intr_type));
}
pub fn wakeupDisable(gpio_num: Num) !void {
    return try errors.espCheckError(sys.gpio_wakeup_disable(gpio_num));
}
pub fn isrRegister(@"fn": ?*const fn (?*anyopaque) callconv(.C) void, arg: ?*anyopaque, intr_alloc_flags: c_int, handle: [*c]sys.gpio_isr_handle_t) !void {
    return try errors.espCheckError(sys.gpio_isr_register(@"fn", arg, intr_alloc_flags, handle));
}
pub const PULL = struct {
    pub fn upEn(gpio_num: Num) !void {
        return try errors.espCheckError(sys.gpio_pullup_en(@intFromEnum(gpio_num)));
    }
    pub fn upDis(gpio_num: Num) !void {
        return try errors.espCheckError(sys.gpio_pullup_dis(@intFromEnum(gpio_num)));
    }
    pub fn downEn(gpio_num: Num) !void {
        return try errors.espCheckError(sys.gpio_pulldown_en(@intFromEnum(gpio_num)));
    }
    pub fn downDis(gpio_num: Num) !void {
        return try errors.espCheckError(sys.gpio_pulldown_dis(@intFromEnum(gpio_num)));
    }
};
pub fn installISRService(intr_alloc_flags: c_int) !void {
    return try errors.espCheckError(sys.gpio_install_isr_service(intr_alloc_flags));
}
pub fn uninstallISRService() void {
    sys.gpio_uninstall_isr_service();
}
pub fn isrHandlerAdd(gpio_num: Num, isr_handler: sys.gpio_isr_t, args: ?*anyopaque) !void {
    return try errors.espCheckError(sys.gpio_isr_handler_add(@intFromEnum(gpio_num), isr_handler, args));
}
pub fn isrHandlerRemove(gpio_num: Num) !void {
    return try errors.espCheckError(sys.gpio_isr_handler_remove(@intFromEnum(gpio_num)));
}
pub fn setDriveCapability(gpio_num: Num, strength: DriveCap) !void {
    return try errors.espCheckError(sys.gpio_set_drive_capability(@intFromEnum(gpio_num), @intFromEnum(strength)));
}
pub fn getDriveCapability(gpio_num: Num, strength: [*c]sys.gpio_drive_cap_t) !void {
    return try errors.espCheckError(sys.gpio_get_drive_capability(@intFromEnum(gpio_num), @intFromEnum(strength)));
}
pub fn holdEn(gpio_num: Num) !void {
    return try errors.espCheckError(sys.gpio_hold_en(@intFromEnum(gpio_num)));
}
pub fn holdDis(gpio_num: Num) !void {
    return try errors.espCheckError(sys.gpio_hold_dis(@intFromEnum(gpio_num)));
}
pub fn deepSleepHoldEn() void {
    sys.gpio_deep_sleep_hold_en();
}
pub fn deepSleepHoldDis() void {
    sys.gpio_deep_sleep_hold_dis();
}
pub fn iomuxIn(gpio_num: Num, signal_idx: u32) void {
    sys.gpio_iomux_in(@intFromEnum(gpio_num), signal_idx);
}
pub fn iomuxOut(gpio_num: Num, func: c_int, oen_inv: bool) void {
    sys.gpio_iomux_out(@intFromEnum(gpio_num), func, oen_inv);
}
pub fn forceHoldAll() !void {
    return try errors.espCheckError(sys.gpio_force_hold_all());
}
pub fn forceUnholdAll() !void {
    return try errors.espCheckError(sys.gpio_force_unhold_all());
}
pub fn sleepSelEn(gpio_num: Num) !void {
    return try errors.espCheckError(sys.gpio_sleep_sel_en(@intFromEnum(gpio_num)));
}
pub fn sleepSelDis(gpio_num: Num) !void {
    return try errors.espCheckError(sys.gpio_sleep_sel_dis(@intFromEnum(gpio_num)));
}
pub fn sleepSetPullMode(gpio_num: Num, pull: PullMode) !void {
    return try errors.espCheckError(sys.gpio_sleep_set_pull_mode(@intFromEnum(gpio_num), @intFromEnum(pull)));
}
pub fn deepSleepWakeupEnable(gpio_num: Num, intr_type: IntType) !void {
    return try errors.espCheckError(sys.gpio_deep_sleep_wakeup_enable(@intFromEnum(gpio_num), @intFromEnum(intr_type)));
}
pub fn deepSleepWakeupDisable(gpio_num: Num) !void {
    return try errors.espCheckError(sys.gpio_deep_sleep_wakeup_disable(@intFromEnum(gpio_num)));
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
    pub fn padUnhold(gpio_num: Num) void {
        sys.esp_rom_gpio_pad_unhold(@intFromEnum(gpio_num));
    }
    pub fn padSetDrive(iopad_num: u32, drv: u32) void {
        sys.esp_rom_gpio_pad_set_drv(iopad_num, drv);
    }
    pub fn connectInSignal(gpio_num: Num, signal_idx: u32, inv: bool) void {
        sys.esp_rom_gpio_connect_in_signal(@intFromEnum(gpio_num), signal_idx, inv);
    }
    pub fn connectOutSignal(gpio_num: Num, signal_idx: u32, out_inv: bool, oen_inv: bool) void {
        sys.esp_rom_gpio_connect_out_signal(@intFromEnum(gpio_num), signal_idx, out_inv, oen_inv);
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
