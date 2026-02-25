const sys = @import("sys");
const errors = @import("error");

// ---------------------------------------------------------------------------
// Type aliases
// ---------------------------------------------------------------------------

pub const Config = sys.esp_task_wdt_config_t;
pub const UserHandle = sys.esp_task_wdt_user_handle_t;
pub const TaskHandle = sys.TaskHandle_t;

// ---------------------------------------------------------------------------
// Watchdog initialisation
// ---------------------------------------------------------------------------

/// Initialise the Task Watchdog Timer.
///
/// `config.timeout_ms`   — watchdog timeout in milliseconds
/// `config.idle_core_mask` — bitmask of idle tasks to subscribe (0 = none)
/// `config.trigger_panic` — whether to trigger a panic on timeout
pub fn init(config: *const Config) !void {
    try errors.espCheckError(sys.esp_task_wdt_init(config));
}

/// Reconfigure a running watchdog (does not reset the timer).
pub fn reconfigure(config: *const Config) !void {
    try errors.espCheckError(sys.esp_task_wdt_reconfigure(config));
}

/// De-initialise the Task Watchdog Timer.
pub fn deinit() !void {
    try errors.espCheckError(sys.esp_task_wdt_deinit());
}

// ---------------------------------------------------------------------------
// Task subscription
// ---------------------------------------------------------------------------

/// Subscribe a FreeRTOS task to the watchdog. Pass `null` for the calling task.
pub fn add(task_handle: TaskHandle) !void {
    try errors.espCheckError(sys.esp_task_wdt_add(task_handle));
}

/// Subscribe a named user (not a FreeRTOS task) to the watchdog.
/// Returns a `UserHandle` for resetting and unsubscribing.
pub fn addUser(user_name: [*:0]const u8) !UserHandle {
    var handle: UserHandle = null;
    try errors.espCheckError(sys.esp_task_wdt_add_user(user_name, &handle));
    return handle;
}

/// Unsubscribe a FreeRTOS task from the watchdog.
pub fn delete(task_handle: TaskHandle) !void {
    try errors.espCheckError(sys.esp_task_wdt_delete(task_handle));
}

/// Unsubscribe a user registered with `addUser`.
pub fn deleteUser(user_handle: UserHandle) !void {
    try errors.espCheckError(sys.esp_task_wdt_delete_user(user_handle));
}

// ---------------------------------------------------------------------------
// Watchdog reset (feed)
// ---------------------------------------------------------------------------

/// Reset (feed) the watchdog for the calling task.
/// Call at least once per watchdog period to prevent a timeout.
pub fn reset() !void {
    try errors.espCheckError(sys.esp_task_wdt_reset());
}

/// Reset the watchdog for a named user registered with `addUser`.
pub fn resetUser(user_handle: UserHandle) !void {
    try errors.espCheckError(sys.esp_task_wdt_reset_user(user_handle));
}

// ---------------------------------------------------------------------------
// Status query
// ---------------------------------------------------------------------------

/// Returns `ESP_OK` if `task_handle` is subscribed and has recently reset,
/// or an error if it is overdue or not subscribed.
pub fn status(task_handle: TaskHandle) !void {
    try errors.espCheckError(sys.esp_task_wdt_status(task_handle));
}
