const sys = @import("sys");
const errors = @import("error");

// ---------------------------------------------------------------------------
// Type aliases & enums
// ---------------------------------------------------------------------------

pub const ChannelConfig = sys.ledc_channel_config_t;
pub const TimerConfig = sys.ledc_timer_config_t;
pub const IsrHandle = sys.ledc_isr_handle_t;
pub const CbParam = sys.ledc_cb_param_t;
pub const Cbs = sys.ledc_cbs_t;

/// Speed mode. Most modern ESP32 variants only support LOW_SPEED_MODE.
pub const SpeedMode = enum(sys.ledc_mode_t) {
    low = sys.LEDC_LOW_SPEED_MODE,
};

pub const IntrType = enum(sys.ledc_intr_type_t) {
    disable = sys.LEDC_INTR_DISABLE,
    fade_end = sys.LEDC_INTR_FADE_END,
};

pub const DutyDir = enum(sys.ledc_duty_direction_t) {
    decrease = sys.LEDC_DUTY_DIR_DECREASE,
    increase = sys.LEDC_DUTY_DIR_INCREASE,
};

pub const Timer = enum(sys.ledc_timer_t) {
    @"0" = sys.LEDC_TIMER_0,
    @"1" = sys.LEDC_TIMER_1,
    @"2" = sys.LEDC_TIMER_2,
    @"3" = sys.LEDC_TIMER_3,
};

pub const Channel = enum(sys.ledc_channel_t) {
    @"0" = sys.LEDC_CHANNEL_0,
    @"1" = sys.LEDC_CHANNEL_1,
    @"2" = sys.LEDC_CHANNEL_2,
    @"3" = sys.LEDC_CHANNEL_3,
    @"4" = sys.LEDC_CHANNEL_4,
    @"5" = sys.LEDC_CHANNEL_5,
};

pub const TimerBit = enum(sys.ledc_timer_bit_t) {
    @"1" = sys.LEDC_TIMER_1_BIT,
    @"2" = sys.LEDC_TIMER_2_BIT,
    @"3" = sys.LEDC_TIMER_3_BIT,
    @"4" = sys.LEDC_TIMER_4_BIT,
    @"5" = sys.LEDC_TIMER_5_BIT,
    @"6" = sys.LEDC_TIMER_6_BIT,
    @"7" = sys.LEDC_TIMER_7_BIT,
    @"8" = sys.LEDC_TIMER_8_BIT,
    @"9" = sys.LEDC_TIMER_9_BIT,
    @"10" = sys.LEDC_TIMER_10_BIT,
    @"11" = sys.LEDC_TIMER_11_BIT,
    @"12" = sys.LEDC_TIMER_12_BIT,
    @"13" = sys.LEDC_TIMER_13_BIT,
    @"14" = sys.LEDC_TIMER_14_BIT,
};

pub const FadeMode = enum(sys.ledc_fade_mode_t) {
    no_wait = sys.LEDC_FADE_NO_WAIT,
    wait_done = sys.LEDC_FADE_WAIT_DONE,
};

// ---------------------------------------------------------------------------
// Timer configuration and control
// ---------------------------------------------------------------------------

pub const TimerCtrl = struct {
    /// Configure a LEDC timer (frequency + duty resolution).
    pub fn config(cfg: *const TimerConfig) !void {
        try errors.espCheckError(sys.ledc_timer_config(cfg));
    }

    /// Reset a LEDC timer.
    pub fn reset(mode: SpeedMode, timer: Timer) !void {
        try errors.espCheckError(sys.ledc_timer_rst(@intFromEnum(mode), @intFromEnum(timer)));
    }

    /// Pause a LEDC timer.
    pub fn pause(mode: SpeedMode, timer: Timer) !void {
        try errors.espCheckError(sys.ledc_timer_pause(@intFromEnum(mode), @intFromEnum(timer)));
    }

    /// Resume a paused LEDC timer.
    pub fn @"resume"(mode: SpeedMode, timer: Timer) !void {
        try errors.espCheckError(sys.ledc_timer_resume(@intFromEnum(mode), @intFromEnum(timer)));
    }

    /// Set the frequency (Hz) of a running timer.
    pub fn setFreq(mode: SpeedMode, timer: Timer, freq_hz: u32) !void {
        try errors.espCheckError(sys.ledc_set_freq(@intFromEnum(mode), @intFromEnum(timer), freq_hz));
    }

    /// Get the current frequency (Hz) of a timer.
    pub fn getFreq(mode: SpeedMode, timer: Timer) u32 {
        return sys.ledc_get_freq(@intFromEnum(mode), @intFromEnum(timer));
    }

    /// Return the best duty resolution for a given source clock and target frequency.
    pub fn findSuitableDutyResolution(src_clk_freq: u32, timer_freq: u32) u32 {
        return sys.ledc_find_suitable_duty_resolution(src_clk_freq, timer_freq);
    }
};

// ---------------------------------------------------------------------------
// Channel configuration and control
// ---------------------------------------------------------------------------

pub const ChannelCtrl = struct {
    /// Configure a LEDC output channel.
    pub fn config(cfg: *const ChannelConfig) !void {
        try errors.espCheckError(sys.ledc_channel_config(cfg));
    }

    /// Re-assign a GPIO to an existing channel (without full reconfiguration).
    pub fn setPin(gpio_num: c_int, mode: SpeedMode, ch: Channel) !void {
        try errors.espCheckError(sys.ledc_set_pin(gpio_num, @intFromEnum(mode), @intFromEnum(ch)));
    }

    /// Stop the channel output and set the GPIO to `idle_level` (0 or 1).
    pub fn stop(mode: SpeedMode, ch: Channel, idle_level: u32) !void {
        try errors.espCheckError(sys.ledc_stop(@intFromEnum(mode), @intFromEnum(ch), idle_level));
    }

    /// Bind a channel to a different timer.
    pub fn bindTimer(mode: SpeedMode, ch: Channel, timer: Timer) !void {
        try errors.espCheckError(sys.ledc_bind_channel_timer(@intFromEnum(mode), @intFromEnum(ch), @intFromEnum(timer)));
    }

    // ── Duty ──────────────────────────────────────────────────────────────

    /// Set the duty cycle (without updating the hardware — call `updateDuty` after).
    pub fn setDuty(mode: SpeedMode, ch: Channel, duty: u32) !void {
        try errors.espCheckError(sys.ledc_set_duty(@intFromEnum(mode), @intFromEnum(ch), duty));
    }

    /// Set duty + hpoint (without updating hardware).
    pub fn setDutyWithHpoint(mode: SpeedMode, ch: Channel, duty: u32, hpoint: u32) !void {
        try errors.espCheckError(sys.ledc_set_duty_with_hpoint(@intFromEnum(mode), @intFromEnum(ch), duty, hpoint));
    }

    /// Latch the duty value set by `setDuty`/`setDutyWithHpoint` into hardware.
    pub fn updateDuty(mode: SpeedMode, ch: Channel) !void {
        try errors.espCheckError(sys.ledc_update_duty(@intFromEnum(mode), @intFromEnum(ch)));
    }

    /// Set duty and immediately apply it to hardware (combines set + update).
    pub fn setDutyAndUpdate(mode: SpeedMode, ch: Channel, duty: u32, hpoint: u32) !void {
        try errors.espCheckError(sys.ledc_set_duty_and_update(@intFromEnum(mode), @intFromEnum(ch), duty, hpoint));
    }

    /// Get the current duty cycle value.
    pub fn getDuty(mode: SpeedMode, ch: Channel) u32 {
        return sys.ledc_get_duty(@intFromEnum(mode), @intFromEnum(ch));
    }

    /// Get the current hpoint value.
    pub fn getHpoint(mode: SpeedMode, ch: Channel) c_int {
        return sys.ledc_get_hpoint(@intFromEnum(mode), @intFromEnum(ch));
    }

    // ── Callback ──────────────────────────────────────────────────────────

    /// Register a callback for fade-end events on a channel.
    pub fn registerCallback(mode: SpeedMode, ch: Channel, cbs: *Cbs, user_arg: ?*anyopaque) !void {
        try errors.espCheckError(sys.ledc_cb_register(@intFromEnum(mode), @intFromEnum(ch), cbs, user_arg));
    }
};

// ---------------------------------------------------------------------------
// Fade functions
// ---------------------------------------------------------------------------

pub const Fade = struct {
    /// Install the fade ISR service. Call once before using any fade functions.
    /// `intr_alloc_flags`: interrupt allocation flags (e.g. ESP_INTR_FLAG_IRAM).
    pub fn install(intr_alloc_flags: c_int) !void {
        try errors.espCheckError(sys.ledc_fade_func_install(intr_alloc_flags));
    }

    /// Uninstall the fade ISR service.
    pub fn uninstall() void {
        sys.ledc_fade_func_uninstall();
    }

    /// Start a fade previously configured with `setFadeStep` or `setFadeTime`.
    pub fn start(mode: SpeedMode, ch: Channel, fade_mode: FadeMode) !void {
        try errors.espCheckError(sys.ledc_fade_start(@intFromEnum(mode), @intFromEnum(ch), @intFromEnum(fade_mode)));
    }

    /// Stop an in-progress fade.
    pub fn stop(mode: SpeedMode, ch: Channel) !void {
        try errors.espCheckError(sys.ledc_fade_stop(@intFromEnum(mode), @intFromEnum(ch)));
    }

    /// Configure a fade by time: ramp from current duty to `target_duty` in `fade_time_ms`.
    pub fn setFadeTime(mode: SpeedMode, ch: Channel, target_duty: u32, fade_time_ms: c_int) !void {
        try errors.espCheckError(sys.ledc_set_fade_with_time(@intFromEnum(mode), @intFromEnum(ch), target_duty, fade_time_ms));
    }

    /// Configure a fade by step: ramp with a fixed `scale` increment every `cycle_num` PWM cycles.
    pub fn setFadeStep(mode: SpeedMode, ch: Channel, target_duty: u32, scale: u32, cycle_num: u32) !void {
        try errors.espCheckError(sys.ledc_set_fade_with_step(@intFromEnum(mode), @intFromEnum(ch), target_duty, scale, cycle_num));
    }

    /// Set fade time and immediately start it.
    pub fn setFadeTimeAndStart(mode: SpeedMode, ch: Channel, target_duty: u32, fade_time_ms: u32, fade_mode: FadeMode) !void {
        try errors.espCheckError(sys.ledc_set_fade_time_and_start(@intFromEnum(mode), @intFromEnum(ch), target_duty, fade_time_ms, @intFromEnum(fade_mode)));
    }

    /// Set fade step and immediately start it.
    pub fn setFadeStepAndStart(mode: SpeedMode, ch: Channel, target_duty: u32, scale: u32, cycle_num: u32, fade_mode: FadeMode) !void {
        try errors.espCheckError(sys.ledc_set_fade_step_and_start(@intFromEnum(mode), @intFromEnum(ch), target_duty, scale, cycle_num, @intFromEnum(fade_mode)));
    }
};
