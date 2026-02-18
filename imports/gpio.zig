const sys = @import("sys");
const std = @import("std");
const errors = @import("error");

// ---------------------------------------------------------------------------
// Num — generated enum containing only pins that exist on the current target.
// ---------------------------------------------------------------------------

pub fn Num() type {
    comptime var names: []const []const u8 = &.{};
    comptime var values: []const sys.gpio_num_t = &.{};

    // Always-present sentinels.
    names = names ++ &[_][]const u8{ "NC", "MAX" };
    values = values ++ &[_]sys.gpio_num_t{
        @intCast(sys.GPIO_NUM_NC),
        @intCast(sys.GPIO_NUM_MAX),
    };

    // Add only the pins the current target actually declares in sys.
    inline for (0..49) |n| {
        @setEvalBranchQuota(200000);
        const decl = std.fmt.comptimePrint("GPIO_NUM_{d}", .{n});
        if (@hasDecl(sys, decl)) {
            names = names ++ &[_][]const u8{std.fmt.comptimePrint("{d}", .{n})};
            values = values ++ &[_]sys.gpio_num_t{@intCast(@field(sys, decl))};
        }
    }

    // @Enum(TagInt, mode, field_names, field_values)
    return @Enum(
        sys.gpio_num_t,
        .exhaustive,
        names,
        values[0..],
    );
}

/// The GPIO pin enum for the current target.
/// Only pins declared by the BSP/sys module are present as fields.
/// Referencing a missing pin (e.g. `.@"22"` on ESP32-C3) is a compile error.
pub const GpioNum = Num();

/// Convert a GpioNum to the raw C type expected by esp-idf APIs.
pub inline fn numToC(gpio_num: GpioNum) sys.gpio_num_t {
    return @intFromEnum(gpio_num);
}

// ---------------------------------------------------------------------------
// Other enumerations
// ---------------------------------------------------------------------------

pub const Port = enum(sys.gpio_port_t) {
    GPIO_PORT_0 = sys.GPIO_PORT_0,
    GPIO_PORT_MAX = sys.GPIO_PORT_MAX,
};

pub const IntType = enum(sys.gpio_int_type_t) {
    disable = sys.GPIO_INTR_DISABLE,
    posedge = sys.GPIO_INTR_POSEDGE,
    negedge = sys.GPIO_INTR_NEGEDGE,
    anyedge = sys.GPIO_INTR_ANYEDGE,
    low_level = sys.GPIO_INTR_LOW_LEVEL,
    high_level = sys.GPIO_INTR_HIGH_LEVEL,
    max = sys.GPIO_INTR_MAX,
};

pub const Mode = enum(sys.gpio_mode_t) {
    disable = sys.GPIO_MODE_DISABLE,
    input = sys.GPIO_MODE_INPUT,
    output = sys.GPIO_MODE_OUTPUT,
    output_od = sys.GPIO_MODE_OUTPUT_OD,
    input_output_od = sys.GPIO_MODE_INPUT_OUTPUT_OD,
    input_output = sys.GPIO_MODE_INPUT_OUTPUT,
};

pub const Pullup = enum(sys.gpio_pullup_t) {
    disable = sys.GPIO_PULLUP_DISABLE,
    enable = sys.GPIO_PULLUP_ENABLE,
};

pub const Pulldown = enum(sys.gpio_pulldown_t) {
    disable = sys.GPIO_PULLDOWN_DISABLE,
    enable = sys.GPIO_PULLDOWN_ENABLE,
};

pub const PullMode = enum(sys.gpio_pull_mode_t) {
    pullup_only = sys.GPIO_PULLUP_ONLY,
    pulldown_only = sys.GPIO_PULLDOWN_ONLY,
    pullup_pulldown = sys.GPIO_PULLUP_PULLDOWN,
    floating = sys.GPIO_FLOATING,
};

pub const DriveCap = enum(sys.gpio_drive_cap_t) {
    cap_0 = sys.GPIO_DRIVE_CAP_0,
    cap_1 = sys.GPIO_DRIVE_CAP_1,
    cap_2 = sys.GPIO_DRIVE_CAP_2,
    default = sys.GPIO_DRIVE_CAP_DEFAULT,
    cap_3 = sys.GPIO_DRIVE_CAP_3,
    max = sys.GPIO_DRIVE_CAP_MAX,
};

// ---------------------------------------------------------------------------
// Configuration
// ---------------------------------------------------------------------------

pub fn config(cfg: [*c]const sys.gpio_config_t) !void {
    try errors.espCheckError(sys.gpio_config(cfg));
}

pub fn resetPin(gpio_num: GpioNum) !void {
    try errors.espCheckError(sys.gpio_reset_pin(numToC(gpio_num)));
}

// ---------------------------------------------------------------------------
// Interrupts
// ---------------------------------------------------------------------------

pub fn setIntrType(gpio_num: GpioNum, intr_type: IntType) !void {
    try errors.espCheckError(sys.gpio_set_intr_type(numToC(gpio_num), @intFromEnum(intr_type)));
}

pub fn intrEnable(gpio_num: GpioNum) !void {
    try errors.espCheckError(sys.gpio_intr_enable(numToC(gpio_num)));
}

pub fn intrDisable(gpio_num: GpioNum) !void {
    try errors.espCheckError(sys.gpio_intr_disable(numToC(gpio_num)));
}

pub fn installISRService(intr_alloc_flags: c_int) !void {
    try errors.espCheckError(sys.gpio_install_isr_service(intr_alloc_flags));
}

pub fn uninstallISRService() void {
    sys.gpio_uninstall_isr_service();
}

pub fn isrRegister(
    handler: ?*const fn (?*anyopaque) callconv(.c) void,
    arg: ?*anyopaque,
    intr_alloc_flags: c_int,
    handle: [*c]sys.gpio_isr_handle_t,
) !void {
    try errors.espCheckError(sys.gpio_isr_register(handler, arg, intr_alloc_flags, handle));
}

pub fn isrHandlerAdd(gpio_num: GpioNum, isr_handler: sys.gpio_isr_t, args: ?*anyopaque) !void {
    try errors.espCheckError(sys.gpio_isr_handler_add(numToC(gpio_num), isr_handler, args));
}

pub fn isrHandlerRemove(gpio_num: GpioNum) !void {
    try errors.espCheckError(sys.gpio_isr_handler_remove(numToC(gpio_num)));
}

// ---------------------------------------------------------------------------
// Level / Direction
// ---------------------------------------------------------------------------

pub const Level = struct {
    pub fn set(gpio_num: GpioNum, level: u32) !void {
        try errors.espCheckError(sys.gpio_set_level(numToC(gpio_num), level));
    }
    /// Returns true if the pin is high, false if low.
    pub fn get(gpio_num: GpioNum) bool {
        return sys.gpio_get_level(numToC(gpio_num)) != 0;
    }
};

pub const Direction = struct {
    pub fn set(gpio_num: GpioNum, mode: Mode) !void {
        try errors.espCheckError(sys.gpio_set_direction(numToC(gpio_num), @intFromEnum(mode)));
    }
    pub fn sleepSet(gpio_num: GpioNum, mode: Mode) !void {
        try errors.espCheckError(sys.gpio_sleep_set_direction(numToC(gpio_num), @intFromEnum(mode)));
    }
};

// ---------------------------------------------------------------------------
// Pull resistors
// ---------------------------------------------------------------------------

pub fn setPullMode(gpio_num: GpioNum, pull: PullMode) !void {
    try errors.espCheckError(sys.gpio_set_pull_mode(numToC(gpio_num), @intFromEnum(pull)));
}

pub fn sleepSetPullMode(gpio_num: GpioNum, pull: PullMode) !void {
    try errors.espCheckError(sys.gpio_sleep_set_pull_mode(numToC(gpio_num), @intFromEnum(pull)));
}

pub const PULL = struct {
    pub fn upEn(gpio_num: GpioNum) !void {
        try errors.espCheckError(sys.gpio_pullup_en(numToC(gpio_num)));
    }
    pub fn upDis(gpio_num: GpioNum) !void {
        try errors.espCheckError(sys.gpio_pullup_dis(numToC(gpio_num)));
    }
    pub fn downEn(gpio_num: GpioNum) !void {
        try errors.espCheckError(sys.gpio_pulldown_en(numToC(gpio_num)));
    }
    pub fn downDis(gpio_num: GpioNum) !void {
        try errors.espCheckError(sys.gpio_pulldown_dis(numToC(gpio_num)));
    }
};

// ---------------------------------------------------------------------------
// Drive strength
// ---------------------------------------------------------------------------

pub fn setDriveCapability(gpio_num: GpioNum, strength: DriveCap) !void {
    try errors.espCheckError(sys.gpio_set_drive_capability(numToC(gpio_num), @intFromEnum(strength)));
}

/// Returns the drive capability of the given pin.
pub fn getDriveCapability(gpio_num: GpioNum) !DriveCap {
    var raw: sys.gpio_drive_cap_t = undefined;
    try errors.espCheckError(sys.gpio_get_drive_capability(numToC(gpio_num), &raw));
    return @enumFromInt(raw);
}

// ---------------------------------------------------------------------------
// Hold / deep-sleep
// ---------------------------------------------------------------------------

pub fn holdEn(gpio_num: GpioNum) !void {
    try errors.espCheckError(sys.gpio_hold_en(numToC(gpio_num)));
}

pub fn holdDis(gpio_num: GpioNum) !void {
    try errors.espCheckError(sys.gpio_hold_dis(numToC(gpio_num)));
}

pub fn forceHoldAll() !void {
    try errors.espCheckError(sys.gpio_force_hold_all());
}

pub fn forceUnholdAll() !void {
    try errors.espCheckError(sys.gpio_force_unhold_all());
}

pub fn deepSleepHoldEn() void {
    sys.gpio_deep_sleep_hold_en();
}

pub fn deepSleepHoldDis() void {
    sys.gpio_deep_sleep_hold_dis();
}

pub fn deepSleepWakeupEnable(gpio_num: GpioNum, intr_type: IntType) !void {
    try errors.espCheckError(sys.gpio_deep_sleep_wakeup_enable(numToC(gpio_num), @intFromEnum(intr_type)));
}

pub fn deepSleepWakeupDisable(gpio_num: GpioNum) !void {
    try errors.espCheckError(sys.gpio_deep_sleep_wakeup_disable(numToC(gpio_num)));
}

// ---------------------------------------------------------------------------
// Sleep select
// ---------------------------------------------------------------------------

pub fn sleepSelEn(gpio_num: GpioNum) !void {
    try errors.espCheckError(sys.gpio_sleep_sel_en(numToC(gpio_num)));
}

pub fn sleepSelDis(gpio_num: GpioNum) !void {
    try errors.espCheckError(sys.gpio_sleep_sel_dis(numToC(gpio_num)));
}

// ---------------------------------------------------------------------------
// Wakeup
// ---------------------------------------------------------------------------

pub fn wakeupEnable(gpio_num: GpioNum, intr_type: IntType) !void {
    try errors.espCheckError(sys.gpio_wakeup_enable(numToC(gpio_num), @intFromEnum(intr_type)));
}

pub fn wakeupDisable(gpio_num: GpioNum) !void {
    try errors.espCheckError(sys.gpio_wakeup_disable(numToC(gpio_num)));
}

// ---------------------------------------------------------------------------
// IOMUX
// ---------------------------------------------------------------------------

pub fn iomuxIn(gpio_num: GpioNum, signal_idx: u32) void {
    sys.gpio_iomux_in(numToC(gpio_num), signal_idx);
}

pub fn iomuxOut(gpio_num: GpioNum, func: c_int, oen_inv: bool) void {
    sys.gpio_iomux_out(numToC(gpio_num), func, oen_inv);
}

// ---------------------------------------------------------------------------
// Debug
// ---------------------------------------------------------------------------

pub fn dumpIOConfiguration(out_stream: ?*std.c.FILE, io_bit_mask: u64) !void {
    try errors.espCheckError(sys.gpio_dump_io_configuration(out_stream, io_bit_mask));
}

// ---------------------------------------------------------------------------
// ROM helpers
// ---------------------------------------------------------------------------

pub const ROM = struct {
    pub fn padSelectGPIO(iopad_num: u32) void {
        sys.esp_rom_gpio_pad_select_gpio(iopad_num);
    }
    pub fn padPullupOnly(iopad_num: u32) void {
        sys.esp_rom_gpio_pad_pullup_only(iopad_num);
    }
    pub fn padUnhold(gpio_num: GpioNum) void {
        sys.esp_rom_gpio_pad_unhold(numToC(gpio_num));
    }
    pub fn padSetDrive(iopad_num: u32, drv: u32) void {
        sys.esp_rom_gpio_pad_set_drv(iopad_num, drv);
    }
    pub fn connectInSignal(gpio_num: GpioNum, signal_idx: u32, inv: bool) void {
        sys.esp_rom_gpio_connect_in_signal(numToC(gpio_num), signal_idx, inv);
    }
    pub fn connectOutSignal(gpio_num: GpioNum, signal_idx: u32, out_inv: bool, oen_inv: bool) void {
        sys.esp_rom_gpio_connect_out_signal(numToC(gpio_num), signal_idx, out_inv, oen_inv);
    }
};

// ---------------------------------------------------------------------------
// ETM (Event Task Matrix)
// ---------------------------------------------------------------------------

pub const ETM = struct {
    pub fn newChannel(cfg: [*c]const sys.esp_etm_channel_config_t, ret_chan: [*c]sys.esp_etm_channel_handle_t) !void {
        try errors.espCheckError(sys.esp_etm_new_channel(cfg, ret_chan));
    }
    pub fn delChannel(chan: sys.esp_etm_channel_handle_t) !void {
        try errors.espCheckError(sys.esp_etm_del_channel(chan));
    }
    pub fn channelEnable(chan: sys.esp_etm_channel_handle_t) !void {
        try errors.espCheckError(sys.esp_etm_channel_enable(chan));
    }
    pub fn channelDisable(chan: sys.esp_etm_channel_handle_t) !void {
        try errors.espCheckError(sys.esp_etm_channel_disable(chan));
    }
    pub fn channelConnect(
        chan: sys.esp_etm_channel_handle_t,
        event: sys.esp_etm_event_handle_t,
        task: sys.esp_etm_task_handle_t,
    ) !void {
        try errors.espCheckError(sys.esp_etm_channel_connect(chan, event, task));
    }
    pub fn delEvent(event: sys.esp_etm_event_handle_t) !void {
        try errors.espCheckError(sys.esp_etm_del_event(event));
    }
    pub fn delTask(task: sys.esp_etm_task_handle_t) !void {
        try errors.espCheckError(sys.esp_etm_del_task(task));
    }
    pub fn dump(out_stream: ?*std.c.FILE) !void {
        try errors.espCheckError(sys.esp_etm_dump(out_stream));
    }
};

// ---------------------------------------------------------------------------
// GPIO ETM event/task binding
// ---------------------------------------------------------------------------

pub fn newEtmEvent(cfg: [*c]const sys.gpio_etm_event_config_t, ret_event: [*c]sys.esp_etm_event_handle_t) !void {
    try errors.espCheckError(sys.gpio_new_etm_event(cfg, ret_event));
}

pub fn etmEventBindGPIO(event: sys.esp_etm_event_handle_t, gpio_num: GpioNum) !void {
    try errors.espCheckError(sys.gpio_etm_event_bind_gpio(event, numToC(gpio_num)));
}

pub fn newEtmTask(cfg: [*c]const sys.gpio_etm_task_config_t, ret_task: [*c]sys.esp_etm_task_handle_t) !void {
    try errors.espCheckError(sys.gpio_new_etm_task(cfg, ret_task));
}

pub fn etmTaskAddGPIO(task: sys.esp_etm_task_handle_t, gpio_num: GpioNum) !void {
    try errors.espCheckError(sys.gpio_etm_task_add_gpio(task, numToC(gpio_num)));
}

pub fn etmTaskRemoveGPIO(task: sys.esp_etm_task_handle_t, gpio_num: GpioNum) !void {
    try errors.espCheckError(sys.gpio_etm_task_rm_gpio(task, numToC(gpio_num)));
}
