const sys = @import("sys");

pub const xTimerCreate = sys.xTimerCreate;
pub const xTimerCreateStatic = sys.xTimerCreateStatic;
pub const pvTimerGetTimerID = sys.pvTimerGetTimerID;
pub const vTimerSetTimerID = sys.vTimerSetTimerID;
pub const xTimerIsTimerActive = sys.xTimerIsTimerActive;
pub const xTimerGetTimerDaemonTaskHandle = sys.xTimerGetTimerDaemonTaskHandle;
pub const xTimerPendFunctionCallFromISR = sys.xTimerPendFunctionCallFromISR;
pub const xTimerPendFunctionCall = sys.xTimerPendFunctionCall;
pub const pcTimerGetName = sys.pcTimerGetName;
pub const vTimerSetReloadMode = sys.vTimerSetReloadMode;
pub const uxTimerGetReloadMode = sys.uxTimerGetReloadMode;
pub const xTimerGetPeriod = sys.xTimerGetPeriod;
pub const xTimerGetExpiryTime = sys.xTimerGetExpiryTime;
pub const xTimerGetStaticBuffer = sys.xTimerGetStaticBuffer;
pub const xTimerCreateTimerTask = sys.xTimerCreateTimerTask;
pub const xTimerGenericCommandFromTask = sys.xTimerGenericCommandFromTask;
pub const xTimerGenericCommandFromISR = sys.xTimerGenericCommandFromISR;

pub const vApplicationGetTimerTaskMemory = sys.vApplicationGetTimerTaskMemory;

pub const xEventGroupCreate = sys.xEventGroupCreate;
pub const xEventGroupCreateStatic = sys.xEventGroupCreateStatic;
pub const xEventGroupWaitBits = sys.xEventGroupWaitBits;
pub const xEventGroupClearBits = sys.xEventGroupClearBits;
pub const xEventGroupSetBits = sys.xEventGroupSetBits;
pub const xEventGroupSync = sys.xEventGroupSync;
pub const xEventGroupGetBitsFromISR = sys.xEventGroupGetBitsFromISR;
pub const vEventGroupDelete = sys.vEventGroupDelete;
pub const xEventGroupGetStaticBuffer = sys.xEventGroupGetStaticBuffer;
pub const vEventGroupSetBitsCallback = sys.vEventGroupSetBitsCallback;
pub const vEventGroupClearBitsCallback = sys.vEventGroupClearBitsCallback;
pub const xStreamBufferGetStaticBuffers = sys.xStreamBufferGetStaticBuffers;
pub const xStreamBufferSend = sys.xStreamBufferSend;
pub const xStreamBufferSendFromISR = sys.xStreamBufferSendFromISR;
pub const xStreamBufferReceive = sys.xStreamBufferReceive;
pub const xStreamBufferReceiveFromISR = sys.xStreamBufferReceiveFromISR;
pub const vStreamBufferDelete = sys.vStreamBufferDelete;
pub const xStreamBufferIsFull = sys.xStreamBufferIsFull;
pub const xStreamBufferIsEmpty = sys.xStreamBufferIsEmpty;
pub const xStreamBufferReset = sys.xStreamBufferReset;
pub const xStreamBufferSpacesAvailable = sys.xStreamBufferSpacesAvailable;
pub const xStreamBufferBytesAvailable = sys.xStreamBufferBytesAvailable;
pub const xStreamBufferSetTriggerLevel = sys.xStreamBufferSetTriggerLevel;
pub const xStreamBufferSendCompletedFromISR = sys.xStreamBufferSendCompletedFromISR;
pub const xStreamBufferReceiveCompletedFromISR = sys.xStreamBufferReceiveCompletedFromISR;
pub const xStreamBufferGenericCreate = sys.xStreamBufferGenericCreate;
pub const xStreamBufferGenericCreateStatic = sys.xStreamBufferGenericCreateStatic;
pub const xStreamBufferNextMessageLengthBytes = sys.xStreamBufferNextMessageLengthBytes;

pub const xQueueGenericSend = sys.xQueueGenericSend;
pub const xQueuePeek = sys.xQueuePeek;
pub const xQueuePeekFromISR = sys.xQueuePeekFromISR;
pub const xQueueReceive = sys.xQueueReceive;
pub const uxQueueMessagesWaiting = sys.uxQueueMessagesWaiting;
pub const uxQueueSpacesAvailable = sys.uxQueueSpacesAvailable;
pub const vQueueDelete = sys.vQueueDelete;
pub const xQueueGenericSendFromISR = sys.xQueueGenericSendFromISR;
pub const xQueueGiveFromISR = sys.xQueueGiveFromISR;
pub const xQueueReceiveFromISR = sys.xQueueReceiveFromISR;
pub const xQueueIsQueueEmptyFromISR = sys.xQueueIsQueueEmptyFromISR;
pub const xQueueIsQueueFullFromISR = sys.xQueueIsQueueFullFromISR;
pub const uxQueueMessagesWaitingFromISR = sys.uxQueueMessagesWaitingFromISR;
pub const xQueueCRSendFromISR = sys.xQueueCRSendFromISR;
pub const xQueueCRReceiveFromISR = sys.xQueueCRReceiveFromISR;
pub const xQueueCRSend = sys.xQueueCRSend;
pub const xQueueCRReceive = sys.xQueueCRReceive;
pub const xQueueCreateMutex = sys.xQueueCreateMutex;
pub const xQueueCreateMutexStatic = sys.xQueueCreateMutexStatic;
pub const xQueueCreateCountingSemaphore = sys.xQueueCreateCountingSemaphore;
pub const xQueueCreateCountingSemaphoreStatic = sys.xQueueCreateCountingSemaphoreStatic;
pub const xQueueSemaphoreTake = sys.xQueueSemaphoreTake;
pub const xQueueGetMutexHolder = sys.xQueueGetMutexHolder;
pub const xQueueGetMutexHolderFromISR = sys.xQueueGetMutexHolderFromISR;
pub const xQueueTakeMutexRecursive = sys.xQueueTakeMutexRecursive;
pub const xQueueGiveMutexRecursive = sys.xQueueGiveMutexRecursive;
pub const xQueueGenericCreate = sys.xQueueGenericCreate;
pub const xQueueGenericCreateStatic = sys.xQueueGenericCreateStatic;
pub const xQueueGenericGetStaticBuffers = sys.xQueueGenericGetStaticBuffers;
pub const xQueueCreateSet = sys.xQueueCreateSet;
pub const xQueueAddToSet = sys.xQueueAddToSet;
pub const xQueueRemoveFromSet = sys.xQueueRemoveFromSet;
pub const xQueueSelectFromSet = sys.xQueueSelectFromSet;
pub const xQueueSelectFromSetFromISR = sys.xQueueSelectFromSetFromISR;
pub const vQueueWaitForMessageRestricted = sys.vQueueWaitForMessageRestricted;
pub const xQueueGenericReset = sys.xQueueGenericReset;
pub const vQueueSetQueueNumber = sys.vQueueSetQueueNumber;
pub const uxQueueGetQueueNumber = sys.uxQueueGetQueueNumber;
pub const ucQueueGetQueueType = sys.ucQueueGetQueueType;

pub const xTaskCreatePinnedToCore = sys.xTaskCreatePinnedToCore;
pub const xTaskCreate = sys.xTaskCreate;
pub const xTaskCreateStaticPinnedToCore = sys.xTaskCreateStaticPinnedToCore;
pub const xTaskCreateStatic = sys.xTaskCreateStatic;
pub const vTaskAllocateMPURegions = sys.vTaskAllocateMPURegions;
pub const vTaskDelete = sys.vTaskDelete;
pub const vTaskDelay = sys.vTaskDelay;
pub const xTaskDelayUntil = sys.xTaskDelayUntil;
pub const xTaskAbortDelay = sys.xTaskAbortDelay;
pub const uxTaskPriorityGet = sys.uxTaskPriorityGet;
pub const uxTaskPriorityGetFromISR = sys.uxTaskPriorityGetFromISR;
pub const eTaskGetState = sys.eTaskGetState;
pub const vTaskGetInfo = sys.vTaskGetInfo;
pub const vTaskPrioritySet = sys.vTaskPrioritySet;
pub const vTaskSuspend = sys.vTaskSuspend;
pub const vTaskResume = sys.vTaskResume;
pub const xTaskResumeFromISR = sys.xTaskResumeFromISR;
pub const vTaskPreemptionDisable = sys.vTaskPreemptionDisable;
pub const vTaskPreemptionEnable = sys.vTaskPreemptionEnable;
pub const vTaskStartScheduler = sys.vTaskStartScheduler;
pub const vTaskEndScheduler = sys.vTaskEndScheduler;
pub const vTaskSuspendAll = sys.vTaskSuspendAll;
pub const xTaskResumeAll = sys.xTaskResumeAll;
pub const xTaskGetTickCount = sys.xTaskGetTickCount;
pub const xTaskGetTickCountFromISR = sys.xTaskGetTickCountFromISR;
pub const uxTaskGetNumberOfTasks = sys.uxTaskGetNumberOfTasks;
pub const pcTaskGetName = sys.pcTaskGetName;
pub const xTaskGetHandle = sys.xTaskGetHandle;
pub const xTaskGetStaticBuffers = sys.xTaskGetStaticBuffers;
pub const uxTaskGetStackHighWaterMark = sys.uxTaskGetStackHighWaterMark;
pub const uxTaskGetStackHighWaterMark2 = sys.uxTaskGetStackHighWaterMark2;
pub const vTaskSetThreadLocalStoragePointer = sys.vTaskSetThreadLocalStoragePointer;
pub const pvTaskGetThreadLocalStoragePointer = sys.pvTaskGetThreadLocalStoragePointer;
pub const vApplicationStackOverflowHook = sys.vApplicationStackOverflowHook;
pub const vApplicationGetIdleTaskMemory = sys.vApplicationGetIdleTaskMemory;
pub const xTaskCallApplicationTaskHook = sys.xTaskCallApplicationTaskHook;
pub const xTaskGetIdleTaskHandle = sys.xTaskGetIdleTaskHandle;
pub const uxTaskGetSystemState = sys.uxTaskGetSystemState;
pub const vTaskList = sys.vTaskList;
pub const vTaskGetRunTimeStats = sys.vTaskGetRunTimeStats;
pub const ulTaskGetIdleRunTimeCounter = sys.ulTaskGetIdleRunTimeCounter;
pub const xTaskGenericNotify = sys.xTaskGenericNotify;
pub const xTaskGenericNotifyFromISR = sys.xTaskGenericNotifyFromISR;
pub const xTaskGenericNotifyWait = sys.xTaskGenericNotifyWait;
pub const vTaskGenericNotifyGiveFromISR = sys.vTaskGenericNotifyGiveFromISR;
pub const ulTaskGenericNotifyTake = sys.ulTaskGenericNotifyTake;
pub const xTaskGenericNotifyStateClear = sys.xTaskGenericNotifyStateClear;
pub const ulTaskGenericNotifyValueClear = sys.ulTaskGenericNotifyValueClear;
pub const vTaskSetTimeOutState = sys.vTaskSetTimeOutState;
pub const xTaskCheckForTimeOut = sys.xTaskCheckForTimeOut;
pub const xTaskCatchUpTicks = sys.xTaskCatchUpTicks;
pub const xTaskIncrementTick = sys.xTaskIncrementTick;
pub const vTaskPlaceOnEventList = sys.vTaskPlaceOnEventList;
pub const vTaskPlaceOnUnorderedEventList = sys.vTaskPlaceOnUnorderedEventList;
pub const vTaskPlaceOnEventListRestricted = sys.vTaskPlaceOnEventListRestricted;
pub const xTaskRemoveFromEventList = sys.xTaskRemoveFromEventList;
pub const vTaskRemoveFromUnorderedEventList = sys.vTaskRemoveFromUnorderedEventList;
pub const vTaskSwitchContext = sys.vTaskSwitchContext;
pub const uxTaskResetEventItemValue = sys.uxTaskResetEventItemValue;
pub const xTaskGetCurrentTaskHandle = sys.xTaskGetCurrentTaskHandle;
pub const xTaskGetCurrentTaskHandleCPU = sys.xTaskGetCurrentTaskHandleCPU;
pub const vTaskMissedYield = sys.vTaskMissedYield;
pub const xTaskGetSchedulerState = sys.xTaskGetSchedulerState;
pub const xTaskPriorityInherit = sys.xTaskPriorityInherit;
pub const xTaskPriorityDisinherit = sys.xTaskPriorityDisinherit;
pub const vTaskPriorityDisinheritAfterTimeout = sys.vTaskPriorityDisinheritAfterTimeout;
pub const uxTaskGetTaskNumber = sys.uxTaskGetTaskNumber;
pub const vTaskSetTaskNumber = sys.vTaskSetTaskNumber;
pub const vTaskStepTick = sys.vTaskStepTick;
pub const eTaskConfirmSleepModeStatus = sys.eTaskConfirmSleepModeStatus;
pub const pvTaskIncrementMutexHeldCount = sys.pvTaskIncrementMutexHeldCount;
pub const vTaskInternalSetTimeOutState = sys.vTaskInternalSetTimeOutState;
pub const vTaskYieldWithinAPI = sys.vTaskYieldWithinAPI;

pub const portTICK_PERIOD_MS = sys.portTICK_PERIOD_MS;

pub const xRingbufferCreate = sys.xRingbufferCreate;
pub const xRingbufferCreateNoSplit = sys.xRingbufferCreateNoSplit;
pub const xRingbufferCreateStatic = sys.xRingbufferCreateStatic;
pub const xRingbufferSend = sys.xRingbufferSend;
pub const xRingbufferSendFromISR = sys.xRingbufferSendFromISR;
pub const xRingbufferSendAcquire = sys.xRingbufferSendAcquire;
pub const xRingbufferSendComplete = sys.xRingbufferSendComplete;
pub const xRingbufferReceive = sys.xRingbufferReceive;
pub const xRingbufferReceiveFromISR = sys.xRingbufferReceiveFromISR;
pub const xRingbufferReceiveSplit = sys.xRingbufferReceiveSplit;
pub const xRingbufferReceiveSplitFromISR = sys.xRingbufferReceiveSplitFromISR;
pub const xRingbufferReceiveUpTo = sys.xRingbufferReceiveUpTo;
pub const xRingbufferReceiveUpToFromISR = sys.xRingbufferReceiveUpToFromISR;
pub const vRingbufferReturnItem = sys.vRingbufferReturnItem;
pub const vRingbufferReturnItemFromISR = sys.vRingbufferReturnItemFromISR;
pub const vRingbufferDelete = sys.vRingbufferDelete;
pub const xRingbufferGetMaxItemSize = sys.xRingbufferGetMaxItemSize;
pub const xRingbufferGetCurFreeSize = sys.xRingbufferGetCurFreeSize;
pub const xRingbufferAddToQueueSetRead = sys.xRingbufferAddToQueueSetRead;
pub const xRingbufferCanRead = sys.xRingbufferCanRead;
pub const xRingbufferRemoveFromQueueSetRead = sys.xRingbufferRemoveFromQueueSetRead;
pub const vRingbufferGetInfo = sys.vRingbufferGetInfo;
pub const xRingbufferPrintInfo = sys.xRingbufferPrintInfo;
pub const xRingbufferGetStaticBuffer = sys.xRingbufferGetStaticBuffer;
pub const xRingbufferCreateWithCaps = sys.xRingbufferCreateWithCaps;
pub const vRingbufferDeleteWithCaps = sys.vRingbufferDeleteWithCaps;

pub const QueueHandle_t = sys.QueueHandle_t;

pub inline fn xSemaphoreCreateBinary() sys.QueueHandle_t {
    return xQueueGenericCreate(1, 1, 3);
}
pub inline fn xSemaphoreCreateBinaryStatic(pxStaticSemaphore: anytype) sys.QueueHandle_t {
    return xQueueGenericCreateStatic(@import("std").zig.c_translation.cast(sys.UBaseType_t, @as(c_int, 1)), 0, null, pxStaticSemaphore, 3);
}
pub inline fn xSemaphoreTake(xSemaphore: anytype, xBlockTime: anytype) sys.BaseType_t {
    return xQueueSemaphoreTake(xSemaphore, xBlockTime);
}
pub inline fn xSemaphoreTakeRecursive(xMutex: anytype, xBlockTime: anytype) sys.BaseType_t {
    return xQueueTakeMutexRecursive(xMutex, xBlockTime);
}
pub inline fn xSemaphoreGive(xSemaphore: anytype) sys.BaseType_t {
    return xQueueGenericSend(@import("std").zig.c_translation.cast(sys.QueueHandle_t, xSemaphore), null, 0, 0);
}
pub inline fn xSemaphoreGiveRecursive(xMutex: anytype) sys.BaseType_t {
    return xQueueGiveMutexRecursive(xMutex);
}
pub inline fn xSemaphoreGiveFromISR(xSemaphore: anytype, pxHigherPriorityTaskWoken: anytype) sys.BaseType_t {
    return xQueueGiveFromISR(@import("std").zig.c_translation.cast(sys.QueueHandle_t, xSemaphore), pxHigherPriorityTaskWoken);
}
pub inline fn xSemaphoreTakeFromISR(xSemaphore: anytype, pxHigherPriorityTaskWoken: anytype) sys.BaseType_t {
    return xQueueReceiveFromISR(@import("std").zig.c_translation.cast(sys.QueueHandle_t, xSemaphore), null, pxHigherPriorityTaskWoken);
}
pub inline fn xSemaphoreCreateMutex() sys.QueueHandle_t {
    return xQueueCreateMutex(3);
}
pub inline fn xSemaphoreCreateMutexStatic(pxMutexBuffer: anytype) sys.QueueHandle_t {
    return xQueueCreateMutexStatic(3, pxMutexBuffer);
}
pub inline fn xSemaphoreCreateRecursiveMutex() @TypeOf(xQueueCreateMutex(4)) {
    return xQueueCreateMutex(4);
}
pub inline fn xSemaphoreCreateRecursiveMutexStatic(pxStaticSemaphore: anytype) sys.QueueHandle_t {
    return xQueueCreateMutexStatic(4, pxStaticSemaphore);
}
pub inline fn xSemaphoreCreateCounting(uxMaxCount: anytype, uxInitialCount: anytype) sys.QueueHandle_t {
    return xQueueCreateCountingSemaphore(uxMaxCount, uxInitialCount);
}
pub inline fn xSemaphoreCreateCountingStatic(uxMaxCount: anytype, uxInitialCount: anytype, pxSemaphoreBuffer: anytype) sys.QueueHandle_t {
    return xQueueCreateCountingSemaphoreStatic(uxMaxCount, uxInitialCount, pxSemaphoreBuffer);
}
pub inline fn vSemaphoreDelete(xSemaphore: anytype) void {
    return vQueueDelete(@import("std").zig.c_translation.cast(sys.QueueHandle_t, xSemaphore));
}
pub inline fn xSemaphoreGetMutexHolder(xSemaphore: anytype) sys.TaskHandle_t {
    return xQueueGetMutexHolder(xSemaphore);
}
pub inline fn xSemaphoreGetMutexHolderFromISR(xSemaphore: anytype) sys.TaskHandle_t {
    return xQueueGetMutexHolderFromISR(xSemaphore);
}
pub inline fn uxSemaphoreGetCount(xSemaphore: anytype) sys.UBaseType_t {
    return uxQueueMessagesWaiting(@import("std").zig.c_translation.cast(sys.QueueHandle_t, xSemaphore));
}
pub inline fn uxSemaphoreGetCountFromISR(xSemaphore: anytype) sys.UBaseType_t {
    return uxQueueMessagesWaitingFromISR(@import("std").zig.c_translation.cast(sys.QueueHandle_t, xSemaphore));
}
pub inline fn xSemaphoreGetStaticBuffer(xSemaphore: anytype, ppxSemaphoreBuffer: anytype) sys.BaseType_t {
    return xQueueGenericGetStaticBuffers(@import("std").zig.c_translation.cast(sys.QueueHandle_t, xSemaphore), null, ppxSemaphoreBuffer);
}

pub inline fn xQueueCreate(uxQueueLength: anytype, uxItemSize: anytype) @TypeOf(xQueueGenericCreate(uxQueueLength, uxItemSize, sys.queueQUEUE_TYPE_BASE)) {
    return xQueueGenericCreate(uxQueueLength, uxItemSize, sys.queueQUEUE_TYPE_BASE);
}
pub inline fn xQueueCreateStatic(uxQueueLength: anytype, uxItemSize: anytype, pucQueueStorage: anytype, pxQueueBuffer: anytype) @TypeOf(xQueueGenericCreateStatic(uxQueueLength, uxItemSize, pucQueueStorage, pxQueueBuffer, sys.queueQUEUE_TYPE_BASE)) {
    return xQueueGenericCreateStatic(uxQueueLength, uxItemSize, pucQueueStorage, pxQueueBuffer, sys.queueQUEUE_TYPE_BASE);
}
pub inline fn xQueueGetStaticBuffers(xQueue: anytype, ppucQueueStorage: anytype, ppxStaticQueue: anytype) @TypeOf(xQueueGenericGetStaticBuffers(xQueue, ppucQueueStorage, ppxStaticQueue)) {
    return xQueueGenericGetStaticBuffers(xQueue, ppucQueueStorage, ppxStaticQueue);
}
pub inline fn xQueueSendToFront(xQueue: anytype, pvItemToQueue: anytype, xTicksToWait: anytype) @TypeOf(xQueueGenericSend(xQueue, pvItemToQueue, xTicksToWait, sys.queueSEND_TO_FRONT)) {
    return xQueueGenericSend(xQueue, pvItemToQueue, xTicksToWait, sys.queueSEND_TO_FRONT);
}
pub inline fn xQueueSendToBack(xQueue: anytype, pvItemToQueue: anytype, xTicksToWait: anytype) @TypeOf(xQueueGenericSend(xQueue, pvItemToQueue, xTicksToWait, sys.queueSEND_TO_BACK)) {
    return xQueueGenericSend(xQueue, pvItemToQueue, xTicksToWait, sys.queueSEND_TO_BACK);
}
pub inline fn xQueueSend(xQueue: anytype, pvItemToQueue: anytype, xTicksToWait: anytype) @TypeOf(xQueueGenericSend(xQueue, pvItemToQueue, xTicksToWait, sys.queueSEND_TO_BACK)) {
    return xQueueGenericSend(xQueue, pvItemToQueue, xTicksToWait, sys.queueSEND_TO_BACK);
}
pub inline fn xQueueOverwrite(xQueue: anytype, pvItemToQueue: anytype) @TypeOf(xQueueGenericSend(xQueue, pvItemToQueue, @as(c_int, 0), sys.queueOVERWRITE)) {
    return xQueueGenericSend(xQueue, pvItemToQueue, @as(c_int, 0), sys.queueOVERWRITE);
}
pub inline fn xQueueSendToFrontFromISR(xQueue: anytype, pvItemToQueue: anytype, pxHigherPriorityTaskWoken: anytype) @TypeOf(xQueueGenericSendFromISR(xQueue, pvItemToQueue, pxHigherPriorityTaskWoken, sys.queueSEND_TO_FRONT)) {
    return xQueueGenericSendFromISR(xQueue, pvItemToQueue, pxHigherPriorityTaskWoken, sys.queueSEND_TO_FRONT);
}
pub inline fn xQueueSendToBackFromISR(xQueue: anytype, pvItemToQueue: anytype, pxHigherPriorityTaskWoken: anytype) @TypeOf(xQueueGenericSendFromISR(xQueue, pvItemToQueue, pxHigherPriorityTaskWoken, sys.queueSEND_TO_BACK)) {
    return xQueueGenericSendFromISR(xQueue, pvItemToQueue, pxHigherPriorityTaskWoken, sys.queueSEND_TO_BACK);
}
pub inline fn xQueueOverwriteFromISR(xQueue: anytype, pvItemToQueue: anytype, pxHigherPriorityTaskWoken: anytype) @TypeOf(xQueueGenericSendFromISR(xQueue, pvItemToQueue, pxHigherPriorityTaskWoken, sys.queueOVERWRITE)) {
    return xQueueGenericSendFromISR(xQueue, pvItemToQueue, pxHigherPriorityTaskWoken, sys.queueOVERWRITE);
}
pub inline fn xQueueSendFromISR(xQueue: anytype, pvItemToQueue: anytype, pxHigherPriorityTaskWoken: anytype) @TypeOf(xQueueGenericSendFromISR(xQueue, pvItemToQueue, pxHigherPriorityTaskWoken, sys.queueSEND_TO_BACK)) {
    return xQueueGenericSendFromISR(xQueue, pvItemToQueue, pxHigherPriorityTaskWoken, sys.queueSEND_TO_BACK);
}
pub inline fn xQueueReset(xQueue: anytype) @TypeOf(xQueueGenericReset(xQueue, @intFromBool(false))) {
    return xQueueGenericReset(xQueue, @intFromBool(false));
}

pub const Hook = struct {
    pub const Register = struct {
        pub fn idleForCPU(new_idle_cb: sys.esp_freertos_idle_cb_t, cpuid: sys.UBaseType_t) !void {
            return try @import("error").espCheckError(sys.esp_register_freertos_idle_hook_for_cpu(new_idle_cb, cpuid));
        }
        pub fn idle(new_idle_cb: sys.esp_freertos_idle_cb_t) !void {
            return try @import("error").espCheckError(sys.esp_register_freertos_idle_hook(new_idle_cb));
        }
        pub fn tickForCPU(new_tick_cb: sys.esp_freertos_tick_cb_t, cpuid: sys.UBaseType_t) !void {
            return try @import("error").espCheckError(sys.esp_register_freertos_tick_hook_for_cpu(new_tick_cb, cpuid));
        }
        pub fn tick(new_tick_cb: sys.esp_freertos_tick_cb_t) !void {
            return try @import("error").espCheckError(sys.esp_register_freertos_tick_hook(new_tick_cb));
        }
    };
    pub const Deregister = struct {
        pub const idleForCPU = sys.esp_deregister_freertos_idle_hook_for_cpu;
        pub const idle = sys.esp_deregister_freertos_idle_hook;
        pub const tickForCPU = sys.esp_deregister_freertos_tick_hook_for_cpu;
        pub const tick = sys.esp_deregister_freertos_tick_hook;
    };
};

pub inline fn pdMS_TO_TICKS(xTimeInMs: anytype) sys.TickType_t {
    return @divExact(@as(sys.TickType_t, xTimeInMs) * sys.configTICK_RATE_HZ, @as(sys.TickType_t, 1000));
}
pub inline fn pdTICKS_TO_MS(xTicks: anytype) sys.TickType_t {
    return @divExact(@as(sys.TickType_t, xTicks) * @as(sys.TickType_t, 1000), sys.configTICK_RATE_HZ);
}
