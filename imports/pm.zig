const sys = @import("sys");
const errors = @import("error");

// ---------------------------------------------------------------------------
// Type aliases & enums
// ---------------------------------------------------------------------------

/// Unified power management configuration.
/// Fields: `max_freq_mhz`, `min_freq_mhz`, `light_sleep_enable`.
pub const Config = sys.esp_pm_config_t;

pub const LockHandle = sys.esp_pm_lock_handle_t;

/// Type of power management lock.
/// - `cpu_freq_max`: CPU runs at its maximum configured frequency while held.
/// - `apb_freq_max`: APB bus runs at maximum frequency while held.
/// - `no_light_sleep`: Prevents light sleep while held.
pub const LockType = enum(sys.esp_pm_lock_type_t) {
    cpu_freq_max = sys.ESP_PM_CPU_FREQ_MAX,
    apb_freq_max = sys.ESP_PM_APB_FREQ_MAX,
    no_light_sleep = sys.ESP_PM_NO_LIGHT_SLEEP,
};

// ---------------------------------------------------------------------------
// System-wide configuration
// ---------------------------------------------------------------------------

/// Apply a power management configuration.
/// `config` is a pointer to an `esp_pm_config_t` struct.
pub fn configure(config: *const Config) !void {
    try errors.espCheckError(sys.esp_pm_configure(config));
}

/// Retrieve the current power management configuration.
pub fn getConfiguration(config: *Config) !void {
    try errors.espCheckError(sys.esp_pm_get_configuration(config));
}

// ---------------------------------------------------------------------------
// Power management locks
// ---------------------------------------------------------------------------

pub const Lock = struct {
    /// Create a new PM lock.
    /// `lock_type`: the resource to hold.
    /// `arg`: only used for `cpu_freq_max`/`apb_freq_max` (target MHz); pass 0 otherwise.
    /// `name`: optional human-readable name for `esp_pm_dump_locks`.
    pub fn create(lock_type: LockType, arg: c_int, name: [*:0]const u8) !LockHandle {
        var handle: LockHandle = null;
        try errors.espCheckError(sys.esp_pm_lock_create(@intFromEnum(lock_type), arg, name, &handle));
        return handle;
    }

    /// Acquire a PM lock. Nesting is supported — matched `release` calls are required.
    pub fn acquire(handle: LockHandle) !void {
        try errors.espCheckError(sys.esp_pm_lock_acquire(handle));
    }

    /// Release a previously acquired PM lock.
    pub fn release(handle: LockHandle) !void {
        try errors.espCheckError(sys.esp_pm_lock_release(handle));
    }

    /// Delete a PM lock. The lock must not be held when deleted.
    pub fn delete(handle: LockHandle) !void {
        try errors.espCheckError(sys.esp_pm_lock_delete(handle));
    }
};
