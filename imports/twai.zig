const sys = @import("sys");
const errors = @import("error");

// ---------------------------------------------------------------------------
// Type aliases
// ---------------------------------------------------------------------------

pub const Handle = sys.twai_handle_t;
pub const Message = sys.twai_message_t;
pub const FilterConfig = sys.twai_filter_config_t;
pub const TimingConfig = sys.twai_timing_config_t;
pub const GeneralConfig = sys.twai_general_config_t;
pub const StatusInfo = sys.twai_status_info_t;
pub const FrameHeader = sys.twai_frame_header_t;

/// TWAI operating mode.
pub const Mode = enum(sys.twai_mode_t) {
    normal = sys.TWAI_MODE_NORMAL,
    no_ack = sys.TWAI_MODE_NO_ACK,
    listen_only = sys.TWAI_MODE_LISTEN_ONLY,
};

/// Bus error state.
pub const ErrorState = enum(sys.twai_error_state_t) {
    active = sys.TWAI_ERROR_ACTIVE,
    warning = sys.TWAI_ERROR_WARNING,
    passive = sys.TWAI_ERROR_PASSIVE,
    bus_off = sys.TWAI_ERROR_BUS_OFF,
};

/// Driver state.
pub const State = enum(sys.twai_state_t) {
    stopped = sys.TWAI_STATE_STOPPED,
    running = sys.TWAI_STATE_RUNNING,
    bus_off = sys.TWAI_STATE_BUS_OFF,
    recovering = sys.TWAI_STATE_RECOVERING,
};

// ---------------------------------------------------------------------------
// Alert flag constants
// ---------------------------------------------------------------------------

pub const Alert = struct {
    pub const tx_idle: u32 = sys.TWAI_ALERT_TX_IDLE;
    pub const tx_success: u32 = sys.TWAI_ALERT_TX_SUCCESS;
    pub const rx_data: u32 = sys.TWAI_ALERT_RX_DATA;
    pub const below_err_warn: u32 = sys.TWAI_ALERT_BELOW_ERR_WARN;
    pub const err_active: u32 = sys.TWAI_ALERT_ERR_ACTIVE;
    pub const recovery_in_progress: u32 = sys.TWAI_ALERT_RECOVERY_IN_PROGRESS;
    pub const bus_recovered: u32 = sys.TWAI_ALERT_BUS_RECOVERED;
    pub const arb_lost: u32 = sys.TWAI_ALERT_ARB_LOST;
    pub const above_err_warn: u32 = sys.TWAI_ALERT_ABOVE_ERR_WARN;
    pub const bus_error: u32 = sys.TWAI_ALERT_BUS_ERROR;
    pub const tx_failed: u32 = sys.TWAI_ALERT_TX_FAILED;
    pub const rx_queue_full: u32 = sys.TWAI_ALERT_RX_QUEUE_FULL;
    pub const err_pass: u32 = sys.TWAI_ALERT_ERR_PASS;
    pub const bus_off: u32 = sys.TWAI_ALERT_BUS_OFF;
    pub const rx_fifo_overrun: u32 = sys.TWAI_ALERT_RX_FIFO_OVERRUN;
    pub const tx_retried: u32 = sys.TWAI_ALERT_TX_RETRIED;
    pub const periph_reset: u32 = sys.TWAI_ALERT_PERIPH_RESET;
    pub const all: u32 = sys.TWAI_ALERT_ALL;
    pub const none: u32 = sys.TWAI_ALERT_NONE;
    pub const and_log: u32 = sys.TWAI_ALERT_AND_LOG;
};

// ---------------------------------------------------------------------------
// Message flag constants
// ---------------------------------------------------------------------------

pub const MsgFlag = struct {
    pub const none: u32 = sys.TWAI_MSG_FLAG_NONE;
    pub const extd: u32 = sys.TWAI_MSG_FLAG_EXTD;
    pub const rtr: u32 = sys.TWAI_MSG_FLAG_RTR;
    pub const ss: u32 = sys.TWAI_MSG_FLAG_SS;
    pub const self: u32 = sys.TWAI_MSG_FLAG_SELF;
    pub const dlc_non_comp: u32 = sys.TWAI_MSG_FLAG_DLC_NON_COMP;
};

// ---------------------------------------------------------------------------
// Driver — v2 handle-based API (preferred)
// ---------------------------------------------------------------------------

pub const Driver = struct {
    // ── Lifecycle ────────────────────────────────────────────────────────────

    /// Install the TWAI driver and return a handle.
    /// Use `GPIO_NUM_NC` (-1) for unused clkout/bus_off pins.
    pub fn install(
        g_config: *const GeneralConfig,
        t_config: *const TimingConfig,
        f_config: *const FilterConfig,
    ) !Handle {
        var handle: Handle = null;
        try errors.espCheckError(sys.twai_driver_install_v2(g_config, t_config, f_config, &handle));
        return handle;
    }

    /// Uninstall a TWAI driver instance and release resources.
    pub fn uninstall(handle: Handle) !void {
        try errors.espCheckError(sys.twai_driver_uninstall_v2(handle));
    }

    /// Start the TWAI driver (enter running state).
    pub fn start(handle: Handle) !void {
        try errors.espCheckError(sys.twai_start_v2(handle));
    }

    /// Stop the TWAI driver (enter stopped state).
    pub fn stop(handle: Handle) !void {
        try errors.espCheckError(sys.twai_stop_v2(handle));
    }

    // ── Transmit / Receive ───────────────────────────────────────────────────

    /// Queue a message for transmission. `ticks_to_wait` is the FreeRTOS
    /// tick timeout (use `sys.portMAX_DELAY` to block indefinitely).
    pub fn transmit(handle: Handle, msg: *const Message, ticks_to_wait: sys.TickType_t) !void {
        try errors.espCheckError(sys.twai_transmit_v2(handle, msg, ticks_to_wait));
    }

    /// Receive a message. Blocks until a message is available or timeout.
    pub fn receive(handle: Handle, ticks_to_wait: sys.TickType_t) !Message {
        var msg: Message = std.mem.zeroes(Message);
        try errors.espCheckError(sys.twai_receive_v2(handle, &msg, ticks_to_wait));
        return msg;
    }

    // ── Alerts ───────────────────────────────────────────────────────────────

    /// Block until one of the enabled alerts fires (or timeout).
    /// Returns bitmask of triggered alerts.
    pub fn readAlerts(handle: Handle, ticks_to_wait: sys.TickType_t) !u32 {
        var alerts: u32 = 0;
        try errors.espCheckError(sys.twai_read_alerts_v2(handle, &alerts, ticks_to_wait));
        return alerts;
    }

    /// Change the set of enabled alerts at runtime.
    /// Returns the alerts that were pending at the time of reconfiguration.
    pub fn reconfigureAlerts(handle: Handle, alerts_enabled: u32) !u32 {
        var current: u32 = 0;
        try errors.espCheckError(sys.twai_reconfigure_alerts_v2(handle, alerts_enabled, &current));
        return current;
    }

    // ── Recovery ──────────────────────────────────────────────────────────────

    /// Initiate bus-off recovery. The driver must be in `bus_off` state.
    pub fn initiateRecovery(handle: Handle) !void {
        try errors.espCheckError(sys.twai_initiate_recovery_v2(handle));
    }

    // ── Status ────────────────────────────────────────────────────────────────

    /// Get the current driver and bus status.
    pub fn getStatus(handle: Handle) !StatusInfo {
        var info: StatusInfo = std.mem.zeroes(StatusInfo);
        try errors.espCheckError(sys.twai_get_status_info_v2(handle, &info));
        return info;
    }

    // ── Queue management ─────────────────────────────────────────────────────

    /// Discard all messages pending in the transmit queue.
    pub fn clearTxQueue(handle: Handle) !void {
        try errors.espCheckError(sys.twai_clear_transmit_queue_v2(handle));
    }

    /// Discard all messages in the receive queue.
    pub fn clearRxQueue(handle: Handle) !void {
        try errors.espCheckError(sys.twai_clear_receive_queue_v2(handle));
    }
};

const std = @import("std");
