const sys = @import("sys");
const errors = @import("error");

pub const MAC_LEN = 6;

// ─────────────────────────────────────────────────────────────────────────────
// Re-exported / renamed types from sys
// ─────────────────────────────────────────────────────────────────────────────

pub const EspMacType = sys.esp_mac_type_t;
pub const EspResetReason = sys.esp_reset_reason_t;
pub const EspEventBase = sys.esp_event_base_t;
pub const EspHostedAppDesc = sys.esp_hosted_app_desc_t;
pub const EspHostedMemInfo = sys.esp_hosted_mem_info_t;
pub const EspHostedCapInfo = sys.esp_hosted_cap_info_t;
pub const EspHostedCurrMemInfo = sys.esp_hosted_curr_mem_info_t;

// ─────────────────────────────────────────────────────────────────────────────
// Constants & enums
// ─────────────────────────────────────────────────────────────────────────────

pub const EVENT_BASE = sys.ESP_HOSTED_EVENT;

pub const EventId = enum(c_int) {
    cp_init = sys.ESP_HOSTED_EVENT_CP_INIT,
    cp_heartbeat = sys.ESP_HOSTED_EVENT_CP_HEARTBEAT,
    transport_failure = sys.ESP_HOSTED_EVENT_TRANSPORT_FAILURE,
    transport_up = sys.ESP_HOSTED_EVENT_TRANSPORT_UP,
    transport_down = sys.ESP_HOSTED_EVENT_TRANSPORT_DOWN,
    mem_monitor = sys.ESP_HOSTED_EVENT_MEM_MONITOR,
    _,
};

pub const SlaveOtaStatus = enum(c_int) {
    activated = sys.ESP_HOSTED_SLAVE_OTA_ACTIVATED,
    completed = sys.ESP_HOSTED_SLAVE_OTA_COMPLETED,
    not_required = sys.ESP_HOSTED_SLAVE_OTA_NOT_REQUIRED,
    not_started = sys.ESP_HOSTED_SLAVE_OTA_NOT_STARTED,
    in_progress = sys.ESP_HOSTED_SLAVE_OTA_IN_PROGRESS,
    failed = sys.ESP_HOSTED_SLAVE_OTA_FAILED,
    _,
};

pub const MemMonitorConfig = enum(c_uint) {
    no_change = sys.ESP_HOSTED_MEMMONITOR_NO_CHANGE,
    disable = sys.ESP_HOSTED_MEMMONITOR_DISABLE,
    enable = sys.ESP_HOSTED_MEMMONITOR_ENABLE,
    _,
};

// ─────────────────────────────────────────────────────────────────────────────
// Callback types (Zig-friendly)
// ─────────────────────────────────────────────────────────────────────────────

pub const CustomDataCallback = *const fn (
    msg_id: u32,
    data: []const u8,
) void;

// ─────────────────────────────────────────────────────────────────────────────
// Internal adapter state
// ─────────────────────────────────────────────────────────────────────────────

var custom_data_cb: ?CustomDataCallback = null;

fn customDataCbAdapter(
    msg_id: u32,
    data: [*c]const u8,
    data_len: usize,
) callconv(.C) void {
    if (custom_data_cb) |cb| {
        cb(msg_id, data[0..data_len]);
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hosted API
// ─────────────────────────────────────────────────────────────────────────────

pub const Hosted = struct {

    // ─── Lifecycle ──────────────────────────────────────────────────────────────

    pub fn btControllerInit() !void {
        try errors.espCheckError(sys.esp_hosted_bt_controller_init());
    }

    pub fn btControllerDeinit(release_mem: bool) !void {
        try errors.espCheckError(sys.esp_hosted_bt_controller_deinit(release_mem));
    }

    pub fn btControllerEnable() !void {
        try errors.espCheckError(sys.esp_hosted_bt_controller_enable());
    }

    pub fn btControllerDisable() !void {
        try errors.espCheckError(sys.esp_hosted_bt_controller_disable());
    }

    // ─── MAC address management ─────────────────────────────────────────────────

    pub fn setInterfaceMac(typ: EspMacType, mac: []const u8) !void {
        if (mac.len != MAC_LEN) return error.InvalidMacLength;
        try errors.espCheckError(sys.esp_hosted_iface_mac_addr_set(@constCast(mac.ptr), mac.len, typ));
    }

    pub fn getInterfaceMac(typ: EspMacType) ![MAC_LEN]u8 {
        var mac: [MAC_LEN]u8 = undefined;
        try errors.espCheckError(sys.esp_hosted_iface_mac_addr_get(&mac, mac.len, typ));
        return mac;
    }

    pub fn getInterfaceMacLen(typ: EspMacType) usize {
        return sys.esp_hosted_iface_mac_addr_len_get(typ);
    }

    // ─── Coprocessor information ────────────────────────────────────────────────

    pub fn getCoprocessorAppDesc() !EspHostedAppDesc {
        var desc: EspHostedAppDesc = undefined;
        try errors.espCheckError(sys.esp_hosted_get_coprocessor_app_desc(&desc));
        return desc;
    }

    pub fn getCoprocessorFwVersion() ![3]u32 {
        var ver: [3]u32 = undefined;
        try errors.espCheckError(sys.esp_hosted_get_coprocessor_fwversion(&ver));
        return ver;
    }

    // ─── Custom data channel ────────────────────────────────────────────────────

    pub fn registerCustomDataCallback(cb: CustomDataCallback) !void {
        custom_data_cb = cb;
        try errors.espCheckError(sys.esp_hosted_register_custom_callback(0, customDataCbAdapter)); // msg_id currently ignored by most impls
    }

    pub fn sendCustomData(msg_id: u32, data: []const u8) !void {
        try errors.espCheckError(sys.esp_hosted_send_custom_data(msg_id, data.ptr, data.len));
    }

    // ─── Heartbeat ──────────────────────────────────────────────────────────────

    pub fn configureHeartbeat(enable: bool, duration_seconds: i32) !void {
        try errors.espCheckError(sys.esp_hosted_configure_heartbeat(enable, duration_seconds));
    }

    // ─── Memory monitor ─────────────────────────────────────────────────────────

    pub fn setMemoryMonitor(
        cfg: MemMonitorConfig,
        report_always: bool,
        interval_sec: u32,
        internal_thresholds: sys.esp_hosted_mem_monitor_threshold_t,
        external_thresholds: sys.esp_hosted_mem_monitor_threshold_t,
    ) !EspHostedCurrMemInfo {
        const config = sys.esp_hosted_config_mem_monitor_t{
            .config = @intFromEnum(cfg),
            .report_always = report_always,
            .interval_sec = interval_sec,
            .internal_mem = internal_thresholds,
            .external_mem = external_thresholds,
        };

        var curr: EspHostedCurrMemInfo = undefined;
        try errors.espCheckError(sys.esp_hosted_set_mem_monitor(&config, &curr));
        return curr;
    }

    // ─── Slave OTA (very basic blocking style) ──────────────────────────────────

    pub fn slaveOtaBegin() !void {
        try errors.espCheckError(sys.esp_hosted_slave_ota_begin());
    }

    pub fn slaveOtaWrite(data: []const u8) !void {
        try errors.espCheckError(sys.esp_hosted_slave_ota_write(@constCast(data.ptr), @intCast(data.len)));
    }

    pub fn slaveOtaEnd() !void {
        try errors.espCheckError(sys.esp_hosted_slave_ota_end());
    }

    pub fn slaveOtaActivate() !void {
        try errors.espCheckError(sys.esp_hosted_slave_ota_activate());
    }

    pub fn slaveOtaFromUrl(url: []const u8) !void {
        try errors.espCheckError(sys.esp_hosted_slave_ota(url.ptr));
    }
};
