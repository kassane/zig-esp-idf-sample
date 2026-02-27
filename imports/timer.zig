const sys = @import("sys");
const errors = @import("error");

// ---------------------------------------------------------------------------
// Type aliases
// ---------------------------------------------------------------------------

pub const Handle = sys.esp_timer_handle_t;
pub const Callback = sys.esp_timer_cb_t;
pub const CreateArgs = sys.esp_timer_create_args_t;

/// Dispatch method: callback runs in a dedicated high-priority task (TASK)
/// or directly from the ISR (ISR — use only for very short callbacks).
pub const Dispatch = enum(sys.esp_timer_dispatch_t) {
    task = sys.ESP_TIMER_TASK,
    max = sys.ESP_TIMER_MAX,
};

// ---------------------------------------------------------------------------
// High-resolution timer (esp_timer)
// ---------------------------------------------------------------------------

pub const Timer = struct {
    // ── Lifecycle ────────────────────────────────────────────────────────────

    /// Create a new timer. `args.callback` must be non-null.
    /// Returns the handle; caller owns it and must call `delete()` when done.
    pub fn create(args: *const CreateArgs) !Handle {
        var handle: Handle = null;
        try errors.espCheckError(sys.esp_timer_create(args, &handle));
        return handle;
    }

    /// Start a one-shot timer that fires after `timeout_us` microseconds.
    pub fn startOnce(handle: Handle, timeout_us: u64) !void {
        try errors.espCheckError(sys.esp_timer_start_once(handle, timeout_us));
    }

    /// Start a periodic timer that fires every `period_us` microseconds.
    pub fn startPeriodic(handle: Handle, period_us: u64) !void {
        try errors.espCheckError(sys.esp_timer_start_periodic(handle, period_us));
    }

    /// Restart a running timer with a new `timeout_us`.
    /// Works for both one-shot and periodic timers.
    pub fn restart(handle: Handle, timeout_us: u64) !void {
        try errors.espCheckError(sys.esp_timer_restart(handle, timeout_us));
    }

    /// Stop a running timer. Does not delete it.
    pub fn stop(handle: Handle) !void {
        try errors.espCheckError(sys.esp_timer_stop(handle));
    }

    /// Delete a timer. The timer must be stopped first.
    pub fn delete(handle: Handle) !void {
        try errors.espCheckError(sys.esp_timer_delete(handle));
    }

    // ── Query ────────────────────────────────────────────────────────────────

    /// Return current time in microseconds since boot.
    /// This never returns an error.
    pub fn getTime() i64 {
        return sys.esp_timer_get_time();
    }

    /// Return the expiry time (µs since boot) of the next pending alarm.
    pub fn getNextAlarm() i64 {
        return sys.esp_timer_get_next_alarm();
    }

    /// Return the expiry time of the next alarm that can wake the system.
    pub fn getNextAlarmForWakeUp() i64 {
        return sys.esp_timer_get_next_alarm_for_wake_up();
    }

    /// Return the period (µs) of a periodic timer.
    pub fn getPeriod(handle: Handle) !u64 {
        var period: u64 = 0;
        try errors.espCheckError(sys.esp_timer_get_period(handle, &period));
        return period;
    }

    /// Return the expiry time (µs since boot) for a one-shot timer.
    pub fn getExpiryTime(handle: Handle) !u64 {
        var expiry: u64 = 0;
        try errors.espCheckError(sys.esp_timer_get_expiry_time(handle, &expiry));
        return expiry;
    }

    /// Returns `true` if the timer is currently active (started, not yet fired / periodic).
    pub fn isActive(handle: Handle) bool {
        return sys.esp_timer_is_active(handle);
    }
};
