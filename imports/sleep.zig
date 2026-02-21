const sys = @import("sys");
const errors = @import("error");

// ---------------------------------------------------------------------------
// Wakeup cause
// ---------------------------------------------------------------------------

pub const WakeupCause = enum(sys.esp_sleep_wakeup_cause_t) {
    undefined_cause = sys.ESP_SLEEP_WAKEUP_UNDEFINED,
    all = sys.ESP_SLEEP_WAKEUP_ALL,
    ext0 = sys.ESP_SLEEP_WAKEUP_EXT0,
    ext1 = sys.ESP_SLEEP_WAKEUP_EXT1,
    timer = sys.ESP_SLEEP_WAKEUP_TIMER,
    touchpad = sys.ESP_SLEEP_WAKEUP_TOUCHPAD,
    ulp = sys.ESP_SLEEP_WAKEUP_ULP,
    gpio = sys.ESP_SLEEP_WAKEUP_GPIO,
    uart = sys.ESP_SLEEP_WAKEUP_UART,
    wifi = sys.ESP_SLEEP_WAKEUP_WIFI,
    bt = sys.ESP_SLEEP_WAKEUP_BT,
    _,
};

// ---------------------------------------------------------------------------
// Power domain configuration
// ---------------------------------------------------------------------------

pub const PdDomain = enum(sys.esp_sleep_pd_domain_t) {
    rtc_periph = sys.ESP_PD_DOMAIN_RTC_PERIPH,
    rtc_slow_mem = sys.ESP_PD_DOMAIN_RTC_SLOW_MEM,
    rtc_fast_mem = sys.ESP_PD_DOMAIN_RTC_FAST_MEM,
    xtal = sys.ESP_PD_DOMAIN_XTAL,
    rc_fast = sys.ESP_PD_DOMAIN_RC_FAST,
    vddsdio = sys.ESP_PD_DOMAIN_VDDSDIO,
    modem = sys.ESP_PD_DOMAIN_MODEM,
    max = sys.ESP_PD_DOMAIN_MAX,
};

pub const PdOption = enum(sys.esp_sleep_pd_option_t) {
    off = sys.ESP_PD_OPTION_OFF,
    on = sys.ESP_PD_OPTION_ON,
    auto = sys.ESP_PD_OPTION_AUTO,
};

/// Configure the power state of a peripheral domain during sleep.
pub fn pdConfig(domain: PdDomain, option: PdOption) !void {
    try errors.espCheckError(sys.esp_sleep_pd_config(@intFromEnum(domain), @intFromEnum(option)));
}

// ---------------------------------------------------------------------------
// Wakeup source configuration
// ---------------------------------------------------------------------------

/// Enable wakeup by timer after `time_in_us` microseconds.
pub fn enableTimerWakeup(time_in_us: u64) !void {
    try errors.espCheckError(sys.esp_sleep_enable_timer_wakeup(time_in_us));
}

/// Enable wakeup from a GPIO level change (light sleep only on most targets).
pub fn enableGpioWakeup() !void {
    try errors.espCheckError(sys.esp_sleep_enable_gpio_wakeup());
}

/// Enable wakeup by external signal on one RTC IO pin (ESP32 / ESP32-S* only).
pub fn enableExt0Wakeup(gpio_num: sys.gpio_num_t, level: c_int) !void {
    try errors.espCheckError(sys.esp_sleep_enable_ext0_wakeup(gpio_num, level));
}

/// Enable wakeup by any/all of the given RTC IO pins.
pub fn enableExt1Wakeup(io_mask: u64, level_mode: sys.esp_sleep_ext1_wakeup_mode_t) !void {
    try errors.espCheckError(sys.esp_sleep_enable_ext1_wakeup(io_mask, level_mode));
}

/// Enable wakeup from UART activity.
pub fn enableUartWakeup(uart_num: c_int) !void {
    try errors.espCheckError(sys.esp_sleep_enable_uart_wakeup(uart_num));
}

/// Enable Bluetooth as a wakeup source.
pub fn enableBtWakeup() !void {
    try errors.espCheckError(sys.esp_sleep_enable_bt_wakeup());
}

/// Enable WiFi as a wakeup source.
pub fn enableWifiWakeup() !void {
    try errors.espCheckError(sys.esp_sleep_enable_wifi_wakeup());
}

/// Enable ULP co-processor as a wakeup source.
pub fn enableUlpWakeup() !void {
    try errors.espCheckError(sys.esp_sleep_enable_ulp_wakeup());
}

/// Disable a wakeup source.
pub fn disableWakeupSource(source: sys.esp_sleep_source_t) !void {
    try errors.espCheckError(sys.esp_sleep_disable_wakeup_source(source));
}

// ---------------------------------------------------------------------------
// Sleep entry points
// ---------------------------------------------------------------------------

/// Enter deep sleep immediately. Does not return.
/// Configure wakeup sources before calling.
pub fn deepSleepStart() noreturn {
    sys.esp_deep_sleep_start();
    unreachable;
}

/// Enter deep sleep for exactly `time_in_us` microseconds.
/// Convenience shortcut — sets timer wakeup and enters deep sleep. Does not return.
pub fn deepSleep(time_in_us: u64) noreturn {
    sys.esp_deep_sleep(time_in_us);
    unreachable;
}

/// Try to enter deep sleep. Returns an error if not all conditions are met.
pub fn deepSleepTryToStart() !void {
    try errors.espCheckError(sys.esp_deep_sleep_try_to_start());
}

/// Enter light sleep. Returns when a wakeup event is triggered.
pub fn lightSleepStart() !void {
    try errors.espCheckError(sys.esp_light_sleep_start());
}

// ---------------------------------------------------------------------------
// Wakeup cause query
// ---------------------------------------------------------------------------

/// Get the reason the chip was last woken from sleep.
pub fn getWakeupCause() WakeupCause {
    return @enumFromInt(sys.esp_sleep_get_wakeup_cause());
}

/// Returns true if the wakeup cause matches `cause`.
pub fn wasWokenBy(cause: WakeupCause) bool {
    return getWakeupCause() == cause;
}

// ---------------------------------------------------------------------------
// Deep sleep hooks
// ---------------------------------------------------------------------------

/// Register a callback to run just before deep sleep entry.
pub fn registerDeepSleepHook(cb: sys.esp_deep_sleep_cb_t) !void {
    try errors.espCheckError(sys.esp_deep_sleep_register_hook(cb));
}

/// Unregister a previously registered deep sleep hook.
pub fn deregisterDeepSleepHook(cb: sys.esp_deep_sleep_cb_t) void {
    sys.esp_deep_sleep_deregister_hook(cb);
}
