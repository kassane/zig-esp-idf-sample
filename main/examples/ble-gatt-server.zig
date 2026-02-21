/// BLE GATT Server example — "Hello World" BLE peripheral.
///
/// Advertises a custom service with one read/notify characteristic that
/// holds a counter value, incremented every second from a FreeRTOS task.
///
/// Requirements (sdkconfig):
///   CONFIG_BT_ENABLED=y
///   CONFIG_BT_BLUEDROID_ENABLED=y
///   CONFIG_BT_BLE_ENABLED=y
///   CONFIG_BT_GATTS_ENABLE=y
///
/// Tested on: ESP32 with IDF v6.0 + Zig 0.16.0-xtensa-dev
const std = @import("std");
const builtin = @import("builtin");
const idf = @import("esp_idf");
const sys = idf.sys;
const bt = idf.bt;

const log = std.log.scoped(.ble);

// ---------------------------------------------------------------------------
// UUIDs
// ---------------------------------------------------------------------------

/// Custom 16-bit service UUID: 0x00FF
const SVC_UUID: u16 = 0x00FF;
/// Counter characteristic UUID: 0xFF01
const CHAR_UUID: u16 = 0xFF01;
/// CCCD (Client Characteristic Configuration Descriptor): standard 0x2902
const CCCD_UUID: u16 = 0x2902;

// ---------------------------------------------------------------------------
// Attribute handle table indices
// ---------------------------------------------------------------------------

const Idx = struct {
    const svc: usize = 0;
    const char_decl: usize = 1;
    const char_val: usize = 2;
    const cccd: usize = 3;
    const count: usize = 4;
};

// GATT attribute property flags
const PROP_READ: sys.esp_gatt_char_prop_t = sys.ESP_GATT_CHAR_PROP_BIT_READ;
const PROP_NOTIFY: sys.esp_gatt_char_prop_t = sys.ESP_GATT_CHAR_PROP_BIT_NOTIFY;

// ---------------------------------------------------------------------------
// Mutable state
// ---------------------------------------------------------------------------

var handle_table: [Idx.count]u16 = .{0} ** Idx.count;
var conn_id: u16 = 0xFFFF;
var gatts_if_global: bt.GattIf = sys.ESP_GATT_IF_NONE;
var notify_enabled: bool = false;
var counter: u32 = 0;

// ---------------------------------------------------------------------------
// UUIDs (static storage — pointers passed to Bluedroid must remain valid)
// ---------------------------------------------------------------------------

var svc_uuid = sys.esp_bt_uuid_t{
    .len = sys.ESP_UUID_LEN_16,
    .uuid = .{ .uuid16 = SVC_UUID },
};
var char_uuid = sys.esp_bt_uuid_t{
    .len = sys.ESP_UUID_LEN_16,
    .uuid = .{ .uuid16 = CHAR_UUID },
};
var cccd_uuid = sys.esp_bt_uuid_t{
    .len = sys.ESP_UUID_LEN_16,
    .uuid = .{ .uuid16 = CCCD_UUID },
};

// ---------------------------------------------------------------------------
// Advertising data
// ---------------------------------------------------------------------------

var adv_data = sys.esp_ble_adv_data_t{
    .set_scan_rsp = false,
    .include_name = true,
    .include_txpower = false,
    .min_interval = 0x0006,
    .max_interval = 0x0010,
    .appearance = 0,
    .manufacturer_len = 0,
    .p_manufacturer_data = null,
    .service_data_len = 0,
    .p_service_data = null,
    .service_uuid_len = 0,
    .p_service_uuid = null,
    .flag = sys.ESP_BLE_ADV_FLAG_GEN_DISC | sys.ESP_BLE_ADV_FLAG_BREDR_NOT_SPT,
};

var adv_params = sys.esp_ble_adv_params_t{
    .adv_int_min = 0x20,
    .adv_int_max = 0x40,
    .adv_type = sys.ADV_TYPE_IND,
    .own_addr_type = sys.BLE_ADDR_TYPE_PUBLIC,
    .channel_map = sys.ADV_CHNL_ALL,
    .adv_filter_policy = sys.ADV_FILTER_ALLOW_SCAN_ANY_CON_ANY,
    .peer_addr = .{0} ** 6,
    .peer_addr_type = sys.BLE_ADDR_TYPE_PUBLIC,
};

// ---------------------------------------------------------------------------
// GAP callback
// ---------------------------------------------------------------------------

export fn gapEventHandler(
    event: sys.esp_gap_ble_cb_event_t,
    param: [*c]sys.esp_ble_gap_cb_param_t,
) callconv(.c) void {
    _ = param;
    switch (event) {
        sys.ESP_GAP_BLE_ADV_DATA_SET_COMPLETE_EVT => {
            log.info("Adv data set — starting advertising", .{});
            bt.Gap.startAdvertising(&adv_params) catch |err|
                log.err("startAdvertising: {s}", .{@errorName(err)});
        },
        sys.ESP_GAP_BLE_ADV_START_COMPLETE_EVT => {
            log.info("Advertising started", .{});
        },
        sys.ESP_GAP_BLE_ADV_STOP_COMPLETE_EVT => {
            log.info("Advertising stopped", .{});
        },
        sys.ESP_GAP_BLE_UPDATE_CONN_PARAMS_EVT => {
            log.debug("Connection params updated", .{});
        },
        else => {},
    }
}

// ---------------------------------------------------------------------------
// GATTS callback
// ---------------------------------------------------------------------------

export fn gattsEventHandler(
    event: sys.esp_gatts_cb_event_t,
    gatts_if: bt.GattIf,
    param: [*c]sys.esp_ble_gatts_cb_param_t,
) callconv(.c) void {
    switch (event) {
        sys.ESP_GATTS_REG_EVT => {
            log.info("GATTS app registered (app_id={d}, status={d})", .{
                param.*.reg.app_id,
                param.*.reg.status,
            });
            gatts_if_global = gatts_if;

            bt.Gap.setDeviceName("ESP32-BLE-ZIG") catch {};
            bt.Gap.configAdvData(&adv_data) catch {};

            // Service ID
            var srvc_id = sys.esp_gatt_srvc_id_t{
                .is_primary = true,
                .id = .{
                    .inst_id = 0,
                    .uuid = svc_uuid,
                },
            };
            bt.GattServer.createService(gatts_if, &srvc_id, Idx.count) catch |err|
                log.err("createService: {s}", .{@errorName(err)});
        },

        sys.ESP_GATTS_CREATE_EVT => {
            const svc_handle = param.*.create.service_handle;
            handle_table[Idx.svc] = svc_handle;
            log.info("Service created (handle={d})", .{svc_handle});

            bt.GattServer.startService(svc_handle) catch {};

            // Add read+notify characteristic
            bt.GattServer.addChar(
                svc_handle,
                &char_uuid,
                sys.ESP_GATT_PERM_READ,
                PROP_READ | PROP_NOTIFY,
                null,
                null,
            ) catch |err|
                log.err("addChar: {s}", .{@errorName(err)});
        },

        sys.ESP_GATTS_START_EVT => {
            log.info("Service started (handle={d})", .{handle_table[Idx.svc]});
        },

        sys.ESP_GATTS_ADD_CHAR_EVT => {
            handle_table[Idx.char_val] = param.*.add_char.attr_handle;
            log.info("Char added (handle={d})", .{handle_table[Idx.char_val]});

            // Add CCCD descriptor
            bt.GattServer.addCharDescr(
                handle_table[Idx.svc],
                &cccd_uuid,
                sys.ESP_GATT_PERM_READ | sys.ESP_GATT_PERM_WRITE,
                null,
                null,
            ) catch |err|
                log.err("addCharDescr: {s}", .{@errorName(err)});
        },

        sys.ESP_GATTS_ADD_CHAR_DESCR_EVT => {
            handle_table[Idx.cccd] = param.*.add_char_descr.attr_handle;
            log.info("CCCD added (handle={d})", .{handle_table[Idx.cccd]});
        },

        sys.ESP_GATTS_CONNECT_EVT => {
            conn_id = param.*.connect.conn_id;
            log.info("Client connected (conn_id={d})", .{conn_id});
            // Update connection params to reduce latency
            var conn_params = sys.esp_ble_conn_update_params_t{
                .bda = param.*.connect.remote_bda,
                .latency = 0,
                .max_int = 0x20,
                .min_int = 0x10,
                .timeout = 400,
            };
            bt.Gap.updateConnParams(&conn_params) catch {};
        },

        sys.ESP_GATTS_DISCONNECT_EVT => {
            log.info("Client disconnected", .{});
            conn_id = 0xFFFF;
            notify_enabled = false;
            // Restart advertising
            bt.Gap.startAdvertising(&adv_params) catch {};
        },

        sys.ESP_GATTS_READ_EVT => {
            log.debug("Read request (handle={d})", .{param.*.read.handle});
            var rsp = std.mem.zeroes(bt.GattServer.Rsp);
            rsp.attr_value.handle = param.*.read.handle;
            rsp.attr_value.len = 4;
            std.mem.writeInt(u32, rsp.attr_value.value[0..4], counter, .little);
            bt.GattServer.sendResponse(
                gatts_if,
                param.*.read.conn_id,
                param.*.read.trans_id,
                sys.ESP_GATT_OK,
                &rsp,
            ) catch {};
        },

        sys.ESP_GATTS_WRITE_EVT => {
            // CCCD write — enable or disable notifications
            if (param.*.write.handle == handle_table[Idx.cccd] and param.*.write.len == 2) {
                const val = std.mem.readInt(u16, param.*.write.value[0..2], .little);
                notify_enabled = (val == 0x0001);
                log.info("Notifications {s}", .{if (notify_enabled) "enabled" else "disabled"});
            }
        },

        sys.ESP_GATTS_MTU_EVT => {
            log.debug("MTU set to {d}", .{param.*.mtu.mtu});
        },

        else => {},
    }
}

// ---------------------------------------------------------------------------
// Counter task — sends a BLE notification every second
// ---------------------------------------------------------------------------

export fn counterTask(_: ?*anyopaque) callconv(.c) void {
    var buf: [4]u8 = undefined;
    while (true) {
        idf.rtos.Task.delayMs(1000);
        counter +%= 1;
        if (notify_enabled and conn_id != 0xFFFF and gatts_if_global != sys.ESP_GATT_IF_NONE) {
            std.mem.writeInt(u32, &buf, counter, .little);
            bt.GattServer.sendIndicate(
                gatts_if_global,
                conn_id,
                handle_table[Idx.char_val],
                &buf,
                false, // notification (no confirm)
            ) catch |err|
                log.err("sendIndicate: {s}", .{@errorName(err)});
        }
    }
}

// ---------------------------------------------------------------------------
// Entry point
// ---------------------------------------------------------------------------

export fn app_main() callconv(.c) void {
    // NVS (required by BT controller for calibration storage)
    idf.nvs.flashInitOrErase() catch |err| {
        log.err("NVS init: {s}", .{@errorName(err)});
        return;
    };

    // BLE stack init: release Classic BT memory, start BLE controller + Bluedroid
    bt.bleInit() catch |err| {
        log.err("BLE init: {s}", .{@errorName(err)});
        return;
    };

    // Register GAP + GATTS callbacks
    bt.Gap.registerCallback(&gapEventHandler) catch |err| {
        log.err("GAP cb register: {s}", .{@errorName(err)});
        return;
    };
    bt.GattServer.registerCallback(&gattsEventHandler) catch |err| {
        log.err("GATTS cb register: {s}", .{@errorName(err)});
        return;
    };

    // Trigger ESP_GATTS_REG_EVT which drives the rest of the setup
    bt.GattServer.appRegister(0) catch |err| {
        log.err("GATTS app register: {s}", .{@errorName(err)});
        return;
    };

    // Kick off the notification task
    _ = idf.rtos.Task.create(&counterTask, "ble_counter", 1024 * 3, null, 5) catch {
        log.err("Failed to create counter task", .{});
        return;
    };

    log.info("BLE GATT server running — advertising as \"ESP32-BLE-ZIG\"", .{});
}

pub const panic = idf.esp_panic.panic;
pub const std_options: std.Options = .{
    .log_level = switch (builtin.mode) {
        .Debug => .debug,
        else => .info,
    },
    .logFn = idf.log.espLogFn,
};
