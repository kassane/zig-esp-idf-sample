const sys = @import("sys");
const errors = @import("error");

// ---------------------------------------------------------------------------
// Shim — BT_CONTROLLER_INIT_CONFIG_DEFAULT() macro cannot be translated by
// zig translate-c; placeholder.c exposes it as a regular C function.
// ---------------------------------------------------------------------------
extern fn zig_bt_controller_default_cfg() sys.esp_bt_controller_config_t;

// ---------------------------------------------------------------------------
// BT mode
// ---------------------------------------------------------------------------

pub const Mode = enum(sys.esp_bt_mode_t) {
    idle = sys.ESP_BT_MODE_IDLE,
    ble = sys.ESP_BT_MODE_BLE,
    classic = sys.ESP_BT_MODE_CLASSIC_BT,
    dual = sys.ESP_BT_MODE_BTDM,
};

// ---------------------------------------------------------------------------
// BLE power
// ---------------------------------------------------------------------------

pub const PowerType = sys.esp_ble_power_type_t;
pub const PowerLevel = sys.esp_power_level_t;

pub fn txPowerSet(power_type: PowerType, level: PowerLevel) !void {
    try errors.espCheckError(sys.esp_ble_tx_power_set(power_type, level));
}

pub fn txPowerGet(power_type: PowerType) PowerLevel {
    return sys.esp_ble_tx_power_get(power_type);
}

// ---------------------------------------------------------------------------
// Controller lifecycle
// ---------------------------------------------------------------------------

pub const Controller = struct {
    /// Return the default controller config.
    /// Wraps the BT_CONTROLLER_INIT_CONFIG_DEFAULT() macro via a static
    /// inline C function in include/bt_stubs.h (translated by translate-c).
    pub fn defaultConfig() sys.esp_bt_controller_config_t {
        return sys.zig_bt_controller_default_cfg();
    }

    pub fn init(cfg: *sys.esp_bt_controller_config_t) !void {
        try errors.espCheckError(sys.esp_bt_controller_init(cfg));
    }

    pub fn deinit() !void {
        try errors.espCheckError(sys.esp_bt_controller_deinit());
    }

    pub fn enable(mode: Mode) !void {
        try errors.espCheckError(sys.esp_bt_controller_enable(@intFromEnum(mode)));
    }

    pub fn disable() !void {
        try errors.espCheckError(sys.esp_bt_controller_disable());
    }

    pub fn getStatus() sys.esp_bt_controller_status_t {
        return sys.esp_bt_controller_get_status();
    }

    /// Release memory for a BT mode that won't be used (saves heap).
    /// Call before `init` when only BLE or only Classic BT is needed.
    pub fn memRelease(mode: Mode) !void {
        try errors.espCheckError(sys.esp_bt_controller_mem_release(@intFromEnum(mode)));
    }

    /// Release both controller and host memory for unused BT mode.
    pub fn memReleaseAll(mode: Mode) !void {
        try errors.espCheckError(sys.esp_bt_mem_release(@intFromEnum(mode)));
    }

    pub fn sleepEnable() !void {
        try errors.espCheckError(sys.esp_bt_sleep_enable());
    }

    pub fn sleepDisable() !void {
        try errors.espCheckError(sys.esp_bt_sleep_disable());
    }
};

// ---------------------------------------------------------------------------
// Bluedroid host stack lifecycle
// ---------------------------------------------------------------------------

pub const Bluedroid = struct {
    pub fn init() !void {
        try errors.espCheckError(sys.esp_bluedroid_init());
    }

    pub fn initWithCfg(cfg: *sys.esp_bluedroid_config_t) !void {
        try errors.espCheckError(sys.esp_bluedroid_init_with_cfg(cfg));
    }

    pub fn deinit() !void {
        try errors.espCheckError(sys.esp_bluedroid_deinit());
    }

    pub fn enable() !void {
        try errors.espCheckError(sys.esp_bluedroid_enable());
    }

    pub fn disable() !void {
        try errors.espCheckError(sys.esp_bluedroid_disable());
    }

    pub fn getStatus() sys.esp_bluedroid_status_t {
        return sys.esp_bluedroid_get_status();
    }
};

// ---------------------------------------------------------------------------
// Convenience: full BLE init / deinit sequence
// ---------------------------------------------------------------------------

/// Initialise BT controller (BLE-only mode) + Bluedroid stack.
/// Typical call sequence for BLE applications:
/// 1. `idf.nvs.flashInitOrErase()`
/// 2. `bluetooth.bleInit()`
/// 3. Register GAP + GATT callbacks
/// 4. `bluetooth.Gap.startAdvertising(&params)`
pub fn bleInit() !void {
    var cfg = Controller.defaultConfig();
    // Release Classic BT memory — we only need BLE.
    try Controller.memRelease(.classic);
    try Controller.init(&cfg);
    try Controller.enable(.ble);
    try Bluedroid.init();
    try Bluedroid.enable();
}

/// Graceful BLE teardown (reverse of `bleInit`).
pub fn bleDeinit() !void {
    try Bluedroid.disable();
    try Bluedroid.deinit();
    try Controller.disable();
    try Controller.deinit();
}

// ---------------------------------------------------------------------------
// Device
// ---------------------------------------------------------------------------

pub const Device = struct {
    /// Register a callback for generic BT device events.
    pub fn registerCallback(cb: sys.esp_bt_dev_cb_t) !void {
        try errors.espCheckError(sys.esp_bt_dev_register_callback(cb));
    }

    /// Get the local BT/BLE MAC address (6 bytes, big-endian).
    pub fn getAddress() [*]const u8 {
        return sys.esp_bt_dev_get_address();
    }
};

// ---------------------------------------------------------------------------
// GAP BLE
// ---------------------------------------------------------------------------

pub const Gap = struct {
    pub const CbT = sys.esp_gap_ble_cb_t;
    pub const AdvData = sys.esp_ble_adv_data_t;
    pub const AdvParams = sys.esp_ble_adv_params_t;
    pub const ScanParams = sys.esp_ble_scan_params_t;
    pub const ConnUpdateParams = sys.esp_ble_conn_update_params_t;
    pub const AddrType = sys.esp_ble_addr_type_t;
    pub const SmParam = sys.esp_ble_sm_param_t;
    pub const BondDev = sys.esp_ble_bond_dev_t;

    pub fn registerCallback(cb: CbT) !void {
        try errors.espCheckError(sys.esp_ble_gap_register_callback(cb));
    }

    // -- Advertising ---------------------------------------------------------

    pub fn configAdvData(adv_data: *AdvData) !void {
        try errors.espCheckError(sys.esp_ble_gap_config_adv_data(adv_data));
    }

    pub fn configAdvDataRaw(raw_data: []u8) !void {
        try errors.espCheckError(sys.esp_ble_gap_config_adv_data_raw(raw_data.ptr, @intCast(raw_data.len)));
    }

    pub fn configScanRspDataRaw(raw_data: []u8) !void {
        try errors.espCheckError(sys.esp_ble_gap_config_scan_rsp_data_raw(raw_data.ptr, @intCast(raw_data.len)));
    }

    pub fn startAdvertising(params: *AdvParams) !void {
        try errors.espCheckError(sys.esp_ble_gap_start_advertising(params));
    }

    pub fn stopAdvertising() !void {
        try errors.espCheckError(sys.esp_ble_gap_stop_advertising());
    }

    // -- Scanning ------------------------------------------------------------

    pub fn setScanParams(scan_params: *ScanParams) !void {
        try errors.espCheckError(sys.esp_ble_gap_set_scan_params(scan_params));
    }

    /// Start scanning for `duration` seconds (0 = indefinite).
    pub fn startScanning(duration: u32) !void {
        try errors.espCheckError(sys.esp_ble_gap_start_scanning(duration));
    }

    pub fn stopScanning() !void {
        try errors.espCheckError(sys.esp_ble_gap_stop_scanning());
    }

    // -- Connection ----------------------------------------------------------

    pub fn updateConnParams(params: *ConnUpdateParams) !void {
        try errors.espCheckError(sys.esp_ble_gap_update_conn_params(params));
    }

    pub fn disconnect(remote_bda: []u8) !void {
        try errors.espCheckError(sys.esp_ble_gap_disconnect(remote_bda.ptr));
    }

    pub fn readRssi(remote_addr: []u8) !void {
        try errors.espCheckError(sys.esp_ble_gap_read_rssi(remote_addr.ptr));
    }

    // -- Local identity ------------------------------------------------------

    pub fn setDeviceName(name: [*:0]const u8) !void {
        try errors.espCheckError(sys.esp_ble_gap_set_device_name(name));
    }

    pub fn configLocalPrivacy(enable: bool) !void {
        try errors.espCheckError(sys.esp_ble_gap_config_local_privacy(enable));
    }

    // -- Security ------------------------------------------------------------

    pub fn setSecurityParam(param: SmParam, value: *anyopaque, len: u8) !void {
        try errors.espCheckError(sys.esp_ble_gap_set_security_param(param, value, len));
    }

    pub fn securityReply(bd_addr: []u8, accept: bool) !void {
        try errors.espCheckError(sys.esp_ble_gap_security_rsp(bd_addr.ptr, accept));
    }

    pub fn passkeyReply(bd_addr: []u8, accept: bool, passkey: u32) !void {
        try errors.espCheckError(sys.esp_ble_passkey_reply(bd_addr.ptr, accept, passkey));
    }

    pub fn confirmReply(bd_addr: []u8, accept: bool) !void {
        try errors.espCheckError(sys.esp_ble_confirm_reply(bd_addr.ptr, accept));
    }

    // -- Bond management -----------------------------------------------------

    pub fn removeBondDevice(bd_addr: []u8) !void {
        try errors.espCheckError(sys.esp_ble_remove_bond_device(bd_addr.ptr));
    }

    pub fn getBondDeviceNum() c_int {
        return sys.esp_ble_get_bond_device_num();
    }

    pub fn getBondDeviceList(dev_num: *c_int, dev_list: [*]BondDev) !void {
        try errors.espCheckError(sys.esp_ble_get_bond_device_list(dev_num, dev_list));
    }

    // -- Whitelist -----------------------------------------------------------

    pub fn updateWhitelist(add: bool, remote_bda: []u8, addr_type: sys.esp_ble_wl_addr_type_t) !void {
        try errors.espCheckError(sys.esp_ble_gap_update_whitelist(add, remote_bda.ptr, addr_type));
    }

    pub fn clearWhitelist() !void {
        try errors.espCheckError(sys.esp_ble_gap_clear_whitelist());
    }
};

// ---------------------------------------------------------------------------
// GATT common
// ---------------------------------------------------------------------------

pub const GattIf = sys.esp_gatt_if_t;
pub const Uuid = sys.esp_bt_uuid_t;
pub const GattStatus = sys.esp_gatt_status_t;
pub const GattPerm = sys.esp_gatt_perm_t;
pub const GattProp = sys.esp_gatt_char_prop_t;
pub const AttrValue = sys.esp_attr_value_t;
pub const AttrControl = sys.esp_attr_control_t;

// ---------------------------------------------------------------------------
// GATT Server (GATTS)
// ---------------------------------------------------------------------------

pub const GattServer = struct {
    pub const CbT = sys.esp_gatts_cb_t;
    pub const SrvcId = sys.esp_gatt_srvc_id_t;
    pub const AttrDb = sys.esp_gatts_attr_db_t;
    pub const Rsp = sys.esp_gatt_rsp_t;

    pub fn registerCallback(cb: CbT) !void {
        try errors.espCheckError(sys.esp_ble_gatts_register_callback(cb));
    }

    pub fn appRegister(app_id: u16) !void {
        try errors.espCheckError(sys.esp_ble_gatts_app_register(app_id));
    }

    pub fn appUnregister(gatts_if: GattIf) !void {
        try errors.espCheckError(sys.esp_ble_gatts_app_unregister(gatts_if));
    }

    pub fn createService(gatts_if: GattIf, service_id: *SrvcId, num_handle: u16) !void {
        try errors.espCheckError(sys.esp_ble_gatts_create_service(gatts_if, service_id, num_handle));
    }

    /// Create all attributes in one call using an attribute table.
    pub fn createAttrTab(attr_db: []const AttrDb, gatts_if: GattIf, srvc_inst_id: u8) !void {
        try errors.espCheckError(sys.esp_ble_gatts_create_attr_tab(attr_db.ptr, gatts_if, @intCast(attr_db.len), srvc_inst_id));
    }

    pub fn addChar(
        service_handle: u16,
        char_uuid: *Uuid,
        perm: GattPerm,
        property: GattProp,
        char_val: ?*AttrValue,
        control: ?*AttrControl,
    ) !void {
        try errors.espCheckError(sys.esp_ble_gatts_add_char(service_handle, char_uuid, perm, property, char_val, control));
    }

    pub fn addCharDescr(
        service_handle: u16,
        descr_uuid: *Uuid,
        perm: GattPerm,
        val: ?*AttrValue,
        control: ?*AttrControl,
    ) !void {
        try errors.espCheckError(sys.esp_ble_gatts_add_char_descr(service_handle, descr_uuid, perm, val, control));
    }

    pub fn deleteService(service_handle: u16) !void {
        try errors.espCheckError(sys.esp_ble_gatts_delete_service(service_handle));
    }

    pub fn startService(service_handle: u16) !void {
        try errors.espCheckError(sys.esp_ble_gatts_start_service(service_handle));
    }

    pub fn stopService(service_handle: u16) !void {
        try errors.espCheckError(sys.esp_ble_gatts_stop_service(service_handle));
    }

    /// Send a notification or indication to a connected client.
    pub fn sendIndicate(
        gatts_if: GattIf,
        conn_id: u16,
        attr_handle: u16,
        value: []u8,
        need_confirm: bool,
    ) !void {
        try errors.espCheckError(sys.esp_ble_gatts_send_indicate(
            gatts_if,
            conn_id,
            attr_handle,
            @intCast(value.len),
            value.ptr,
            need_confirm,
        ));
    }

    pub fn sendResponse(
        gatts_if: GattIf,
        conn_id: u16,
        trans_id: u32,
        status: GattStatus,
        rsp: *Rsp,
    ) !void {
        try errors.espCheckError(sys.esp_ble_gatts_send_response(gatts_if, conn_id, trans_id, status, rsp));
    }

    pub fn setAttrValue(attr_handle: u16, value: []const u8) !void {
        try errors.espCheckError(sys.esp_ble_gatts_set_attr_value(attr_handle, @intCast(value.len), value.ptr));
    }

    pub fn getAttrValue(attr_handle: u16, length: *u16, value: *[*]const u8) GattStatus {
        return sys.esp_ble_gatts_get_attr_value(attr_handle, length, value);
    }

    pub fn open(gatts_if: GattIf, remote_bda: []u8, is_direct: bool) !void {
        try errors.espCheckError(sys.esp_ble_gatts_open(gatts_if, remote_bda.ptr, is_direct));
    }

    pub fn close(gatts_if: GattIf, conn_id: u16) !void {
        try errors.espCheckError(sys.esp_ble_gatts_close(gatts_if, conn_id));
    }

    pub fn showLocalDatabase() !void {
        try errors.espCheckError(sys.esp_ble_gatts_show_local_database());
    }
};

// ---------------------------------------------------------------------------
// GATT Client (GATTC)
// ---------------------------------------------------------------------------

pub const GattClient = struct {
    pub const CbT = sys.esp_gattc_cb_t;
    pub const SvcElem = sys.esp_gattc_service_elem_t;
    pub const CharElem = sys.esp_gattc_char_elem_t;
    pub const DescrElem = sys.esp_gattc_descr_elem_t;
    pub const WriteType = sys.esp_gatt_write_type_t;
    pub const AuthReq = sys.esp_gatt_auth_req_t;

    pub fn registerCallback(cb: CbT) !void {
        try errors.espCheckError(sys.esp_ble_gattc_register_callback(cb));
    }

    pub fn appRegister(app_id: u16) !void {
        try errors.espCheckError(sys.esp_ble_gattc_app_register(app_id));
    }

    pub fn appUnregister(gattc_if: GattIf) !void {
        try errors.espCheckError(sys.esp_ble_gattc_app_unregister(gattc_if));
    }

    pub fn open(
        gattc_if: GattIf,
        remote_bda: []u8,
        addr_type: sys.esp_ble_addr_type_t,
        is_direct: bool,
    ) !void {
        try errors.espCheckError(sys.esp_ble_gattc_open(gattc_if, remote_bda.ptr, addr_type, is_direct));
    }

    pub fn close(gattc_if: GattIf, conn_id: u16) !void {
        try errors.espCheckError(sys.esp_ble_gattc_close(gattc_if, conn_id));
    }

    pub fn sendMtuReq(gattc_if: GattIf, conn_id: u16) !void {
        try errors.espCheckError(sys.esp_ble_gattc_send_mtu_req(gattc_if, conn_id));
    }

    pub fn searchService(gattc_if: GattIf, conn_id: u16, filter_uuid: ?*Uuid) !void {
        try errors.espCheckError(sys.esp_ble_gattc_search_service(gattc_if, conn_id, filter_uuid));
    }

    pub fn readChar(gattc_if: GattIf, conn_id: u16, handle: u16, auth_req: AuthReq) !void {
        try errors.espCheckError(sys.esp_ble_gattc_read_char(gattc_if, conn_id, handle, auth_req));
    }

    pub fn writeChar(
        gattc_if: GattIf,
        conn_id: u16,
        handle: u16,
        value: []u8,
        write_type: WriteType,
        auth_req: AuthReq,
    ) !void {
        try errors.espCheckError(sys.esp_ble_gattc_write_char(
            gattc_if,
            conn_id,
            handle,
            @intCast(value.len),
            value.ptr,
            write_type,
            auth_req,
        ));
    }

    pub fn writeCharDescr(
        gattc_if: GattIf,
        conn_id: u16,
        handle: u16,
        value: []u8,
        write_type: WriteType,
        auth_req: AuthReq,
    ) !void {
        try errors.espCheckError(sys.esp_ble_gattc_write_char_descr(
            gattc_if,
            conn_id,
            handle,
            @intCast(value.len),
            value.ptr,
            write_type,
            auth_req,
        ));
    }

    pub fn registerForNotify(gattc_if: GattIf, server_bda: []u8, handle: u16) !void {
        try errors.espCheckError(sys.esp_ble_gattc_register_for_notify(gattc_if, server_bda.ptr, handle));
    }

    pub fn unregisterForNotify(gattc_if: GattIf, server_bda: []u8, handle: u16) !void {
        try errors.espCheckError(sys.esp_ble_gattc_unregister_for_notify(gattc_if, server_bda.ptr, handle));
    }

    pub fn cacheRefresh(remote_bda: []u8) !void {
        try errors.espCheckError(sys.esp_ble_gattc_cache_refresh(remote_bda.ptr));
    }
};

// ---------------------------------------------------------------------------
// WiFi/BT power domain (shared with wifi.zig)
// ---------------------------------------------------------------------------

pub const PowerDomain = struct {
    pub fn on() void {
        sys.esp_wifi_bt_power_domain_on();
    }
    pub fn off() void {
        sys.esp_wifi_bt_power_domain_off();
    }
};
