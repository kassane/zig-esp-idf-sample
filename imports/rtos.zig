const sys = @import("sys");
const errors = @import("error");

// ---------------------------------------------------------------------------
// Type aliases — use these instead of raw C types at call sites.
// ---------------------------------------------------------------------------

pub const TaskHandle = sys.TaskHandle_t;
pub const QueueHandle = sys.QueueHandle_t;
pub const SemaphoreHandle = sys.QueueHandle_t;
pub const TimerHandle = sys.TimerHandle_t;
pub const EventGroupHandle = sys.EventGroupHandle_t;
pub const StreamBufferHandle = sys.StreamBufferHandle_t;
pub const RingbufHandle = sys.RingbufHandle_t;
pub const TickType = sys.TickType_t;
pub const BaseType = sys.BaseType_t;
pub const UBaseType = sys.UBaseType_t;

pub const portMAX_DELAY = sys.portMAX_DELAY;
pub const portTICK_PERIOD_MS = sys.portTICK_PERIOD_MS;

// ---------------------------------------------------------------------------
// Tick conversion helpers.
// ---------------------------------------------------------------------------

/// Convert milliseconds to ticks (truncating, matching FreeRTOS pdMS_TO_TICKS).
pub inline fn msToTicks(ms: TickType) TickType {
    return @divTrunc(ms * sys.configTICK_RATE_HZ, 1000);
}

/// Convert ticks to milliseconds (truncating).
pub inline fn ticksToMs(ticks: TickType) TickType {
    return @divTrunc(ticks * 1000, sys.configTICK_RATE_HZ);
}

/// Returns true if a FreeRTOS BaseType_t return value indicates success.
inline fn pdOK(ret: BaseType) bool {
    return ret == sys.pdTRUE;
}

// ---------------------------------------------------------------------------
// Task
// ---------------------------------------------------------------------------

pub const Task = struct {
    pub const Handle = TaskHandle;
    pub const Function = sys.TaskFunction_t;

    /// Create a task pinned to a specific core (pass `tskNO_AFFINITY` for any core).
    pub fn createPinnedToCore(
        task_fn: Function,
        name: [*:0]const u8,
        stack_size: u32,
        param: ?*anyopaque,
        priority: UBaseType,
        core_id: BaseType,
    ) !Handle {
        var handle: Handle = null;
        if (!pdOK(sys.xTaskCreatePinnedToCore(task_fn, name, stack_size, param, priority, &handle, core_id)))
            return error.TaskCreateFailed;
        return handle;
    }

    /// Create a task with no core affinity.
    pub fn create(
        task_fn: Function,
        name: [*:0]const u8,
        stack_size: u32,
        param: ?*anyopaque,
        priority: UBaseType,
    ) !Handle {
        var handle: Handle = null;
        if (!pdOK(sys.xTaskCreate(task_fn, name, stack_size, param, priority, &handle)))
            return error.TaskCreateFailed;
        return handle;
    }

    pub fn createStaticPinnedToCore(
        task_fn: Function,
        name: [*:0]const u8,
        stack_size: u32,
        param: ?*anyopaque,
        priority: UBaseType,
        stack_buf: [*]sys.StackType_t,
        task_buf: *sys.StaticTask_t,
        core_id: BaseType,
    ) Handle {
        return sys.xTaskCreateStaticPinnedToCore(task_fn, name, stack_size, param, priority, stack_buf, task_buf, core_id);
    }

    pub fn delete(handle: ?Handle) void {
        sys.vTaskDelete(handle);
    }

    pub fn delay(ticks: TickType) void {
        sys.vTaskDelay(ticks);
    }

    pub fn delayMs(ms: TickType) void {
        sys.vTaskDelay(msToTicks(ms));
    }

    pub fn delayUntil(prev_wake: *TickType, increment: TickType) bool {
        return pdOK(sys.xTaskDelayUntil(prev_wake, increment));
    }

    pub fn @"suspend"(handle: ?Handle) void {
        sys.vTaskSuspend(handle);
    }

    pub fn @"resume"(handle: Handle) void {
        sys.vTaskResume(handle);
    }

    pub fn resumeFromISR(handle: Handle) bool {
        return pdOK(sys.xTaskResumeFromISR(handle));
    }

    pub fn priorityGet(handle: ?Handle) UBaseType {
        return sys.uxTaskPriorityGet(handle);
    }

    pub fn prioritySet(handle: ?Handle, priority: UBaseType) void {
        sys.vTaskPrioritySet(handle, priority);
    }

    pub fn getName(handle: ?Handle) [*:0]const u8 {
        return sys.pcTaskGetName(handle);
    }

    pub fn getHandle(name: [*:0]const u8) ?Handle {
        return sys.xTaskGetHandle(name);
    }

    pub fn getCurrent() Handle {
        return sys.xTaskGetCurrentTaskHandle();
    }

    pub fn getTickCount() TickType {
        return sys.xTaskGetTickCount();
    }

    pub fn getTickCountFromISR() TickType {
        return sys.xTaskGetTickCountFromISR();
    }

    pub fn getNumberOfTasks() UBaseType {
        return sys.uxTaskGetNumberOfTasks();
    }

    pub fn getStackHighWaterMark(handle: ?Handle) UBaseType {
        return sys.uxTaskGetStackHighWaterMark(handle);
    }

    pub fn getSchedulerState() BaseType {
        return sys.xTaskGetSchedulerState();
    }

    pub fn abortDelay(handle: Handle) bool {
        return pdOK(sys.xTaskAbortDelay(handle));
    }

    pub fn startScheduler() void {
        sys.vTaskStartScheduler();
    }

    pub fn endScheduler() void {
        sys.vTaskEndScheduler();
    }

    pub fn suspendAll() void {
        sys.vTaskSuspendAll();
    }

    pub fn resumeAll() bool {
        return pdOK(sys.xTaskResumeAll());
    }

    pub fn setThreadLocalStoragePointer(handle: ?Handle, index: BaseType, value: ?*anyopaque) void {
        sys.vTaskSetThreadLocalStoragePointer(handle, index, value);
    }

    pub fn getThreadLocalStoragePointer(handle: ?Handle, index: BaseType) ?*anyopaque {
        return sys.pvTaskGetThreadLocalStoragePointer(handle, index);
    }

    /// Send a direct-to-task notification.
    pub fn notify(
        handle: Handle,
        value: u32,
        action: sys.eNotifyAction,
        index: UBaseType,
    ) !void {
        if (!pdOK(sys.xTaskGenericNotify(handle, index, value, action, null)))
            return error.TaskNotifyFailed;
    }

    pub fn notifyWait(
        index: UBaseType,
        clear_on_entry: u32,
        clear_on_exit: u32,
        out_value: ?*u32,
        ticks_to_wait: TickType,
    ) bool {
        return pdOK(sys.xTaskGenericNotifyWait(index, clear_on_entry, clear_on_exit, out_value, ticks_to_wait));
    }
};

// ---------------------------------------------------------------------------
// Queue
// ---------------------------------------------------------------------------

pub const Queue = struct {
    pub const Handle = QueueHandle;

    pub fn create(length: UBaseType, item_size: UBaseType) !Handle {
        const h = sys.xQueueGenericCreate(length, item_size, sys.queueQUEUE_TYPE_BASE);
        return h orelse error.QueueCreateFailed;
    }

    pub fn createStatic(
        length: UBaseType,
        item_size: UBaseType,
        storage: [*]u8,
        buf: *sys.StaticQueue_t,
    ) Handle {
        return sys.xQueueGenericCreateStatic(length, item_size, storage, buf, sys.queueQUEUE_TYPE_BASE);
    }

    pub fn delete(handle: Handle) void {
        sys.vQueueDelete(handle);
    }

    pub fn reset(handle: Handle) bool {
        return pdOK(sys.xQueueGenericReset(handle, 0));
    }

    pub fn send(handle: Handle, item: *const anyopaque, ticks_to_wait: TickType) bool {
        return pdOK(sys.xQueueGenericSend(handle, item, ticks_to_wait, sys.queueSEND_TO_BACK));
    }

    pub fn sendToFront(handle: Handle, item: *const anyopaque, ticks_to_wait: TickType) bool {
        return pdOK(sys.xQueueGenericSend(handle, item, ticks_to_wait, sys.queueSEND_TO_FRONT));
    }

    pub fn overwrite(handle: Handle, item: *const anyopaque) void {
        _ = sys.xQueueGenericSend(handle, item, 0, sys.queueOVERWRITE);
    }

    pub fn sendFromISR(handle: Handle, item: *const anyopaque, higher_prio_woken: *BaseType) bool {
        return pdOK(sys.xQueueGenericSendFromISR(handle, item, higher_prio_woken, sys.queueSEND_TO_BACK));
    }

    pub fn overwriteFromISR(handle: Handle, item: *const anyopaque, higher_prio_woken: *BaseType) void {
        _ = sys.xQueueGenericSendFromISR(handle, item, higher_prio_woken, sys.queueOVERWRITE);
    }

    pub fn receive(handle: Handle, out: *anyopaque, ticks_to_wait: TickType) bool {
        return pdOK(sys.xQueueReceive(handle, out, ticks_to_wait));
    }

    pub fn receiveFromISR(handle: Handle, out: *anyopaque, higher_prio_woken: *BaseType) bool {
        return pdOK(sys.xQueueReceiveFromISR(handle, out, higher_prio_woken));
    }

    pub fn peek(handle: Handle, out: *anyopaque, ticks_to_wait: TickType) bool {
        return pdOK(sys.xQueuePeek(handle, out, ticks_to_wait));
    }

    pub fn messagesWaiting(handle: Handle) UBaseType {
        return sys.uxQueueMessagesWaiting(handle);
    }

    pub fn spacesAvailable(handle: Handle) UBaseType {
        return sys.uxQueueSpacesAvailable(handle);
    }

    pub fn isEmptyFromISR(handle: Handle) bool {
        return pdOK(sys.xQueueIsQueueEmptyFromISR(handle));
    }

    pub fn isFullFromISR(handle: Handle) bool {
        return pdOK(sys.xQueueIsQueueFullFromISR(handle));
    }
};

// ---------------------------------------------------------------------------
// Semaphore
// ---------------------------------------------------------------------------

pub const Semaphore = struct {
    pub const Handle = SemaphoreHandle;

    // Queue type constants (from FreeRTOS queue.h).
    const QUEUE_TYPE_BINARY_SEMAPHORE = sys.queueQUEUE_TYPE_BINARY_SEMAPHORE;
    const QUEUE_TYPE_MUTEX = sys.queueQUEUE_TYPE_MUTEX;
    const QUEUE_TYPE_RECURSIVE_MUTEX = sys.queueQUEUE_TYPE_RECURSIVE_MUTEX;
    const QUEUE_TYPE_COUNTING_SEMAPHORE = sys.queueQUEUE_TYPE_COUNTING_SEMAPHORE;

    pub fn createBinary() !Handle {
        const h = sys.xQueueGenericCreate(1, 0, QUEUE_TYPE_BINARY_SEMAPHORE);
        return h orelse error.SemaphoreCreateFailed;
    }

    pub fn createBinaryStatic(buf: *sys.StaticQueue_t) Handle {
        return sys.xQueueGenericCreateStatic(1, 0, null, buf, QUEUE_TYPE_BINARY_SEMAPHORE);
    }

    pub fn createMutex() !Handle {
        const h = sys.xQueueCreateMutex(QUEUE_TYPE_MUTEX);
        return h orelse error.SemaphoreCreateFailed;
    }

    pub fn createMutexStatic(buf: *sys.StaticQueue_t) Handle {
        return sys.xQueueCreateMutexStatic(QUEUE_TYPE_MUTEX, buf);
    }

    pub fn createRecursiveMutex() !Handle {
        const h = sys.xQueueCreateMutex(QUEUE_TYPE_RECURSIVE_MUTEX);
        return h orelse error.SemaphoreCreateFailed;
    }

    pub fn createRecursiveMutexStatic(buf: *sys.StaticQueue_t) Handle {
        return sys.xQueueCreateMutexStatic(QUEUE_TYPE_RECURSIVE_MUTEX, buf);
    }

    pub fn createCounting(max_count: UBaseType, initial_count: UBaseType) !Handle {
        const h = sys.xQueueCreateCountingSemaphore(max_count, initial_count);
        return h orelse error.SemaphoreCreateFailed;
    }

    pub fn createCountingStatic(max_count: UBaseType, initial_count: UBaseType, buf: *sys.StaticQueue_t) Handle {
        return sys.xQueueCreateCountingSemaphoreStatic(max_count, initial_count, buf);
    }

    pub fn delete(handle: Handle) void {
        sys.vQueueDelete(handle);
    }

    pub fn take(handle: Handle, ticks_to_wait: TickType) bool {
        return pdOK(sys.xQueueSemaphoreTake(handle, ticks_to_wait));
    }

    pub fn takeRecursive(handle: Handle, ticks_to_wait: TickType) bool {
        return pdOK(sys.xQueueTakeMutexRecursive(handle, ticks_to_wait));
    }

    pub fn takeFromISR(handle: Handle, higher_prio_woken: *BaseType) bool {
        return pdOK(sys.xQueueReceiveFromISR(handle, null, higher_prio_woken));
    }

    pub fn give(handle: Handle) bool {
        return pdOK(sys.xQueueGenericSend(handle, null, 0, sys.queueSEND_TO_BACK));
    }

    pub fn giveRecursive(handle: Handle) bool {
        return pdOK(sys.xQueueGiveMutexRecursive(handle));
    }

    pub fn giveFromISR(handle: Handle, higher_prio_woken: *BaseType) bool {
        return pdOK(sys.xQueueGiveFromISR(handle, higher_prio_woken));
    }

    pub fn getMutexHolder(handle: Handle) ?TaskHandle {
        return sys.xQueueGetMutexHolder(handle);
    }

    pub fn getMutexHolderFromISR(handle: Handle) ?TaskHandle {
        return sys.xQueueGetMutexHolderFromISR(handle);
    }

    pub fn getCount(handle: Handle) UBaseType {
        return sys.uxQueueMessagesWaiting(handle);
    }

    pub fn getCountFromISR(handle: Handle) UBaseType {
        return sys.uxQueueMessagesWaitingFromISR(handle);
    }
};

// ---------------------------------------------------------------------------
// Timer
// ---------------------------------------------------------------------------

pub const Timer = struct {
    pub const Handle = TimerHandle;
    pub const Callback = sys.TimerCallbackFunction_t;

    pub fn create(
        name: [*:0]const u8,
        period: TickType,
        auto_reload: bool,
        id: ?*anyopaque,
        callback: Callback,
    ) !Handle {
        const h = sys.xTimerCreate(name, period, @intFromBool(auto_reload), id, callback);
        return h orelse error.TimerCreateFailed;
    }

    pub fn createStatic(
        name: [*:0]const u8,
        period: TickType,
        auto_reload: bool,
        id: ?*anyopaque,
        callback: Callback,
        buf: *sys.StaticTimer_t,
    ) Handle {
        return sys.xTimerCreateStatic(name, period, @intFromBool(auto_reload), id, callback, buf);
    }

    pub fn start(handle: Handle, ticks_to_wait: TickType) bool {
        return pdOK(sys.xTimerGenericCommandFromTask(handle, sys.tmrCOMMAND_START, sys.xTaskGetTickCount(), null, ticks_to_wait));
    }

    pub fn stop(handle: Handle, ticks_to_wait: TickType) bool {
        return pdOK(sys.xTimerGenericCommandFromTask(handle, sys.tmrCOMMAND_STOP, 0, null, ticks_to_wait));
    }

    pub fn reset(handle: Handle, ticks_to_wait: TickType) bool {
        return pdOK(sys.xTimerGenericCommandFromTask(handle, sys.tmrCOMMAND_RESET, sys.xTaskGetTickCount(), null, ticks_to_wait));
    }

    pub fn changePeriod(handle: Handle, new_period: TickType, ticks_to_wait: TickType) bool {
        return pdOK(sys.xTimerGenericCommandFromTask(handle, sys.tmrCOMMAND_CHANGE_PERIOD, new_period, null, ticks_to_wait));
    }

    pub fn delete(handle: Handle, ticks_to_wait: TickType) bool {
        return pdOK(sys.xTimerGenericCommandFromTask(handle, sys.tmrCOMMAND_DELETE, 0, null, ticks_to_wait));
    }

    pub fn isActive(handle: Handle) bool {
        return pdOK(sys.xTimerIsTimerActive(handle));
    }

    pub fn getName(handle: Handle) [*:0]const u8 {
        return sys.pcTimerGetName(handle);
    }

    pub fn getPeriod(handle: Handle) TickType {
        return sys.xTimerGetPeriod(handle);
    }

    pub fn getID(handle: Handle) ?*anyopaque {
        return sys.pvTimerGetTimerID(handle);
    }

    pub fn setID(handle: Handle, id: ?*anyopaque) void {
        sys.vTimerSetTimerID(handle, id);
    }

    pub fn setReloadMode(handle: Handle, auto_reload: bool) void {
        sys.vTimerSetReloadMode(handle, @intFromBool(auto_reload));
    }

    pub fn pendFunctionCall(
        callback: sys.PendedFunction_t,
        param1: ?*anyopaque,
        param2: u32,
        ticks_to_wait: TickType,
    ) bool {
        return pdOK(sys.xTimerPendFunctionCall(callback, param1, param2, ticks_to_wait));
    }

    pub fn pendFunctionCallFromISR(
        callback: sys.PendedFunction_t,
        param1: ?*anyopaque,
        param2: u32,
        higher_prio_woken: *BaseType,
    ) bool {
        return pdOK(sys.xTimerPendFunctionCallFromISR(callback, param1, param2, higher_prio_woken));
    }
};

// ---------------------------------------------------------------------------
// EventGroup
// ---------------------------------------------------------------------------

pub const EventGroup = struct {
    pub const Handle = EventGroupHandle;
    pub const Bits = sys.EventBits_t;

    pub fn create() !Handle {
        const h = sys.xEventGroupCreate();
        return h orelse error.EventGroupCreateFailed;
    }

    pub fn createStatic(buf: *sys.StaticEventGroup_t) Handle {
        return sys.xEventGroupCreateStatic(buf);
    }

    pub fn delete(handle: Handle) void {
        sys.vEventGroupDelete(handle);
    }

    pub fn waitBits(
        handle: Handle,
        bits_to_wait: Bits,
        clear_on_exit: bool,
        wait_for_all: bool,
        ticks_to_wait: TickType,
    ) Bits {
        return sys.xEventGroupWaitBits(
            handle,
            bits_to_wait,
            @intFromBool(clear_on_exit),
            @intFromBool(wait_for_all),
            ticks_to_wait,
        );
    }

    pub fn setBits(handle: Handle, bits: Bits) Bits {
        return sys.xEventGroupSetBits(handle, bits);
    }

    pub fn clearBits(handle: Handle, bits: Bits) Bits {
        return sys.xEventGroupClearBits(handle, bits);
    }

    pub fn getBitsFromISR(handle: Handle) Bits {
        return sys.xEventGroupGetBitsFromISR(handle);
    }

    pub fn sync(
        handle: Handle,
        bits_to_set: Bits,
        bits_to_wait: Bits,
        ticks_to_wait: TickType,
    ) Bits {
        return sys.xEventGroupSync(handle, bits_to_set, bits_to_wait, ticks_to_wait);
    }
};

// ---------------------------------------------------------------------------
// StreamBuffer
// ---------------------------------------------------------------------------

pub const StreamBuffer = struct {
    pub const Handle = StreamBufferHandle;

    pub fn create(size: usize, trigger_level: usize) !Handle {
        const h = sys.xStreamBufferGenericCreate(size, trigger_level, 0, null, null);
        return h orelse error.StreamBufferCreateFailed;
    }

    pub fn createStatic(
        size: usize,
        trigger_level: usize,
        storage: [*]u8,
        buf: *sys.StaticStreamBuffer_t,
    ) Handle {
        return sys.xStreamBufferGenericCreateStatic(size, trigger_level, 0, storage, buf, null, null);
    }

    pub fn delete(handle: Handle) void {
        sys.vStreamBufferDelete(handle);
    }

    pub fn send(handle: Handle, data: []const u8, ticks_to_wait: TickType) usize {
        return sys.xStreamBufferSend(handle, data.ptr, data.len, ticks_to_wait);
    }

    pub fn sendFromISR(handle: Handle, data: []const u8, higher_prio_woken: *BaseType) usize {
        return sys.xStreamBufferSendFromISR(handle, data.ptr, data.len, higher_prio_woken);
    }

    pub fn receive(handle: Handle, buf: []u8, ticks_to_wait: TickType) usize {
        return sys.xStreamBufferReceive(handle, buf.ptr, buf.len, ticks_to_wait);
    }

    pub fn receiveFromISR(handle: Handle, buf: []u8, higher_prio_woken: *BaseType) usize {
        return sys.xStreamBufferReceiveFromISR(handle, buf.ptr, buf.len, higher_prio_woken);
    }

    pub fn reset(handle: Handle) bool {
        return pdOK(sys.xStreamBufferReset(handle));
    }

    pub fn isFull(handle: Handle) bool {
        return pdOK(sys.xStreamBufferIsFull(handle));
    }

    pub fn isEmpty(handle: Handle) bool {
        return pdOK(sys.xStreamBufferIsEmpty(handle));
    }

    pub fn spacesAvailable(handle: Handle) usize {
        return sys.xStreamBufferSpacesAvailable(handle);
    }

    pub fn bytesAvailable(handle: Handle) usize {
        return sys.xStreamBufferBytesAvailable(handle);
    }

    pub fn setTriggerLevel(handle: Handle, trigger_level: usize) bool {
        return pdOK(sys.xStreamBufferSetTriggerLevel(handle, trigger_level));
    }
};

// ---------------------------------------------------------------------------
// MessageBuffer (thin wrapper over StreamBuffer with a 4-byte length header).
// ---------------------------------------------------------------------------

pub const MessageBuffer = struct {
    pub const Handle = StreamBufferHandle;

    pub fn create(size: usize) !Handle {
        const h = sys.xStreamBufferGenericCreate(size, 0, 1, null, null);
        return h orelse error.MessageBufferCreateFailed;
    }

    pub fn delete(handle: Handle) void {
        sys.vStreamBufferDelete(handle);
    }

    pub fn send(handle: Handle, data: []const u8, ticks_to_wait: TickType) usize {
        return sys.xStreamBufferSend(handle, data.ptr, data.len, ticks_to_wait);
    }

    pub fn receive(handle: Handle, buf: []u8, ticks_to_wait: TickType) usize {
        return sys.xStreamBufferReceive(handle, buf.ptr, buf.len, ticks_to_wait);
    }

    pub fn nextMessageLength(handle: Handle) usize {
        return sys.xStreamBufferNextMessageLengthBytes(handle);
    }
};

// ---------------------------------------------------------------------------
// RingBuffer (ESP-IDF extension)
// ---------------------------------------------------------------------------

pub const RingBuffer = struct {
    pub const Handle = RingbufHandle;
    pub const Type = sys.RingbufferType_t;

    pub fn create(size: usize, kind: Type) !Handle {
        const h = sys.xRingbufferCreate(size, kind);
        return h orelse error.RingbufferCreateFailed;
    }

    pub fn createNoSplit(item_size: usize, item_count: usize) !Handle {
        const h = sys.xRingbufferCreateNoSplit(item_size, item_count);
        return h orelse error.RingbufferCreateFailed;
    }

    pub fn createWithCaps(size: usize, kind: Type, caps: u32) !Handle {
        const h = sys.xRingbufferCreateWithCaps(size, kind, caps);
        return h orelse error.RingbufferCreateFailed;
    }

    pub fn delete(handle: Handle) void {
        sys.vRingbufferDelete(handle);
    }

    pub fn deleteWithCaps(handle: Handle) void {
        sys.vRingbufferDeleteWithCaps(handle);
    }

    pub fn send(handle: Handle, data: []const u8, ticks_to_wait: TickType) bool {
        return pdOK(sys.xRingbufferSend(handle, data.ptr, data.len, ticks_to_wait));
    }

    pub fn sendFromISR(handle: Handle, data: []const u8, higher_prio_woken: *BaseType) bool {
        return pdOK(sys.xRingbufferSendFromISR(handle, data.ptr, data.len, higher_prio_woken));
    }

    pub fn receive(handle: Handle, out_size: *usize, ticks_to_wait: TickType) ?[]u8 {
        var size: usize = 0;
        const ptr = sys.xRingbufferReceive(handle, &size, ticks_to_wait);
        if (ptr == null) return null;
        out_size.* = size;
        return @as([*]u8, @ptrCast(ptr))[0..size];
    }

    pub fn receiveFromISR(handle: Handle, out_size: *usize) ?[]u8 {
        var size: usize = 0;
        const ptr = sys.xRingbufferReceiveFromISR(handle, &size);
        if (ptr == null) return null;
        out_size.* = size;
        return @as([*]u8, @ptrCast(ptr))[0..size];
    }

    pub fn returnItem(handle: Handle, item: *anyopaque) void {
        sys.vRingbufferReturnItem(handle, item);
    }

    pub fn returnItemFromISR(handle: Handle, item: *anyopaque, higher_prio_woken: *BaseType) void {
        sys.vRingbufferReturnItemFromISR(handle, item, higher_prio_woken);
    }

    pub fn getMaxItemSize(handle: Handle) usize {
        return sys.xRingbufferGetMaxItemSize(handle);
    }

    pub fn getCurFreeSize(handle: Handle) usize {
        return sys.xRingbufferGetCurFreeSize(handle);
    }
};

// ---------------------------------------------------------------------------
// Hook (idle/tick callbacks)
// ---------------------------------------------------------------------------

pub const Hook = struct {
    pub const Register = struct {
        pub fn idleForCPU(cb: sys.esp_freertos_idle_cb_t, cpu_id: UBaseType) !void {
            try errors.espCheckError(sys.esp_register_freertos_idle_hook_for_cpu(cb, cpu_id));
        }
        pub fn idle(cb: sys.esp_freertos_idle_cb_t) !void {
            try errors.espCheckError(sys.esp_register_freertos_idle_hook(cb));
        }
        pub fn tickForCPU(cb: sys.esp_freertos_tick_cb_t, cpu_id: UBaseType) !void {
            try errors.espCheckError(sys.esp_register_freertos_tick_hook_for_cpu(cb, cpu_id));
        }
        pub fn tick(cb: sys.esp_freertos_tick_cb_t) !void {
            try errors.espCheckError(sys.esp_register_freertos_tick_hook(cb));
        }
    };

    pub const Deregister = struct {
        pub fn idleForCPU(cb: sys.esp_freertos_idle_cb_t, cpu_id: UBaseType) void {
            sys.esp_deregister_freertos_idle_hook_for_cpu(cb, cpu_id);
        }
        pub fn idle(cb: sys.esp_freertos_idle_cb_t) void {
            sys.esp_deregister_freertos_idle_hook(cb);
        }
        pub fn tickForCPU(cb: sys.esp_freertos_tick_cb_t, cpu_id: UBaseType) void {
            sys.esp_deregister_freertos_tick_hook_for_cpu(cb, cpu_id);
        }
        pub fn tick(cb: sys.esp_freertos_tick_cb_t) void {
            sys.esp_deregister_freertos_tick_hook(cb);
        }
    };
};
