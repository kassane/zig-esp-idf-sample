const sys = @import("sys");
const errors = @import("error");

// ---------------------------------------------------------------------------
// Type aliases
// ---------------------------------------------------------------------------

pub const Base = sys.esp_event_base_t;
pub const LoopHandle = sys.esp_event_loop_handle_t;
pub const HandlerT = sys.esp_event_handler_t;
pub const HandlerInstance = sys.esp_event_handler_instance_t;
pub const LoopArgs = sys.esp_event_loop_args_t;

/// Match any event base when registering handlers.
pub const ANY_BASE: Base = sys.ESP_EVENT_ANY_BASE;
/// Match any event ID when registering handlers.
pub const ANY_ID: i32 = sys.ESP_EVENT_ANY_ID;

// ---------------------------------------------------------------------------
// Default event loop
// ---------------------------------------------------------------------------

/// Create the default event loop. Must be called once before posting events
/// or registering handlers on the default loop.
pub fn loopCreateDefault() !void {
    try errors.espCheckError(sys.esp_event_loop_create_default());
}

/// Delete the default event loop.
pub fn loopDeleteDefault() !void {
    try errors.espCheckError(sys.esp_event_loop_delete_default());
}

// ---------------------------------------------------------------------------
// Custom event loop
// ---------------------------------------------------------------------------

/// Create a custom event loop with the given configuration.
pub fn loopCreate(args: *const LoopArgs) !LoopHandle {
    var loop: LoopHandle = null;
    try errors.espCheckError(sys.esp_event_loop_create(args, &loop));
    return loop;
}

/// Delete a custom event loop.
pub fn loopDelete(loop: LoopHandle) !void {
    try errors.espCheckError(sys.esp_event_loop_delete(loop));
}

/// Run a custom event loop for up to `ticks_to_run` ticks.
pub fn loopRun(loop: LoopHandle, ticks_to_run: sys.TickType_t) !void {
    try errors.espCheckError(sys.esp_event_loop_run(loop, ticks_to_run));
}

// ---------------------------------------------------------------------------
// Handler registration — default loop
// ---------------------------------------------------------------------------

/// Register an event handler on the default event loop.
///
/// Pass `ANY_BASE` / `ANY_ID` as wildcards.
pub fn handlerRegister(
    event_base: Base,
    event_id: i32,
    handler: HandlerT,
    arg: ?*anyopaque,
) !void {
    try errors.espCheckError(sys.esp_event_handler_register(event_base, event_id, handler, arg));
}

/// Unregister a previously registered handler from the default loop.
pub fn handlerUnregister(
    event_base: Base,
    event_id: i32,
    handler: HandlerT,
) !void {
    try errors.espCheckError(sys.esp_event_handler_unregister(event_base, event_id, handler));
}

/// Register an instance-based handler on the default loop.
/// Returns an `HandlerInstance` token usable with `handlerInstanceUnregister`.
pub fn handlerInstanceRegister(
    event_base: Base,
    event_id: i32,
    handler: HandlerT,
    arg: ?*anyopaque,
) !HandlerInstance {
    var instance: HandlerInstance = null;
    try errors.espCheckError(sys.esp_event_handler_instance_register(event_base, event_id, handler, arg, &instance));
    return instance;
}

/// Unregister an instance-based handler from the default loop.
pub fn handlerInstanceUnregister(
    event_base: Base,
    event_id: i32,
    instance: HandlerInstance,
) !void {
    try errors.espCheckError(sys.esp_event_handler_instance_unregister(event_base, event_id, instance));
}

// ---------------------------------------------------------------------------
// Handler registration — custom loop
// ---------------------------------------------------------------------------

/// Register a handler on a custom event loop.
pub fn handlerRegisterWith(
    loop: LoopHandle,
    event_base: Base,
    event_id: i32,
    handler: HandlerT,
    arg: ?*anyopaque,
) !void {
    try errors.espCheckError(sys.esp_event_handler_register_with(loop, event_base, event_id, handler, arg));
}

/// Unregister a handler from a custom event loop.
pub fn handlerUnregisterWith(
    loop: LoopHandle,
    event_base: Base,
    event_id: i32,
    handler: HandlerT,
) !void {
    try errors.espCheckError(sys.esp_event_handler_unregister_with(loop, event_base, event_id, handler));
}

/// Register an instance-based handler on a custom event loop.
pub fn handlerInstanceRegisterWith(
    loop: LoopHandle,
    event_base: Base,
    event_id: i32,
    handler: HandlerT,
    arg: ?*anyopaque,
) !HandlerInstance {
    var instance: HandlerInstance = null;
    try errors.espCheckError(sys.esp_event_handler_instance_register_with(loop, event_base, event_id, handler, arg, &instance));
    return instance;
}

/// Unregister an instance-based handler from a custom event loop.
pub fn handlerInstanceUnregisterWith(
    loop: LoopHandle,
    event_base: Base,
    event_id: i32,
    instance: HandlerInstance,
) !void {
    try errors.espCheckError(sys.esp_event_handler_instance_unregister_with(loop, event_base, event_id, instance));
}

// ---------------------------------------------------------------------------
// Event posting
// ---------------------------------------------------------------------------

/// Post an event to the default event loop.
///
/// `event_data` may be null when `event_data_size` is 0.
/// `ticks_to_wait` is how long to block if the queue is full.
pub fn post(
    event_base: Base,
    event_id: i32,
    event_data: ?*const anyopaque,
    event_data_size: usize,
    ticks_to_wait: sys.TickType_t,
) !void {
    try errors.espCheckError(sys.esp_event_post(event_base, event_id, event_data, event_data_size, ticks_to_wait));
}

/// Post an event to a custom event loop.
pub fn postTo(
    loop: LoopHandle,
    event_base: Base,
    event_id: i32,
    event_data: ?*const anyopaque,
    event_data_size: usize,
    ticks_to_wait: sys.TickType_t,
) !void {
    try errors.espCheckError(sys.esp_event_post_to(loop, event_base, event_id, event_data, event_data_size, ticks_to_wait));
}

/// Post an event from an ISR to the default event loop.
/// Sets `*task_unblocked` to true if a higher-priority task was unblocked.
pub fn isrPost(
    event_base: Base,
    event_id: i32,
    event_data: ?*const anyopaque,
    event_data_size: usize,
    task_unblocked: *sys.BaseType_t,
) !void {
    try errors.espCheckError(sys.esp_event_isr_post(event_base, event_id, event_data, event_data_size, task_unblocked));
}

/// Post an event from an ISR to a custom event loop.
pub fn isrPostTo(
    loop: LoopHandle,
    event_base: Base,
    event_id: i32,
    event_data: ?*const anyopaque,
    event_data_size: usize,
    task_unblocked: *sys.BaseType_t,
) !void {
    try errors.espCheckError(sys.esp_event_isr_post_to(loop, event_base, event_id, event_data, event_data_size, task_unblocked));
}
