// NimBLE wrapper — requires CONFIG_BT_NIMBLE_ENABLED in sdkconfig.
//
// Enable via:
//   idf.py menuconfig → Component config → Bluetooth → NimBLE
//
// When enabled, re-run `idf.py reconfigure` to regenerate the bindings.
// NimBLE symbols (ble_hs_*, ble_gap_*, ble_gatt_*) will appear in idf-sys.zig.
const sys = @import("sys");

comptime {
    if (!@hasDecl(sys, "CONFIG_BT_NIMBLE_ENABLED"))
        @compileError(
            \\NimBLE is not enabled. Enable it via:
            \\  idf.py menuconfig → Component config → Bluetooth
            \\  → Host → NimBLE - BLE stack
            \\Then run: idf.py reconfigure
        );
}

// ---------------------------------------------------------------------------
// NimBLE type aliases (available only when CONFIG_BT_NIMBLE_ENABLED=y)
// ---------------------------------------------------------------------------

pub const HsCfg = sys.ble_hs_cfg_t;
pub const GapConnDesc = sys.ble_gap_conn_desc;
pub const GapAdvParams = sys.ble_gap_adv_params;
pub const GapConnParams = sys.ble_gap_conn_params;
pub const GattSvcDef = sys.ble_gatt_svc_def;
pub const GattCharDef = sys.ble_gatt_chr_def;
pub const GattDscrDef = sys.ble_gatt_dsc_def;
pub const Uuid16 = sys.ble_uuid16_t;
pub const Uuid128 = sys.ble_uuid128_t;

// ---------------------------------------------------------------------------
// Host stack
// ---------------------------------------------------------------------------

pub const Host = struct {
    /// Initialize the NimBLE host stack (call before syncing).
    pub fn init() void {
        sys.nimble_port_init();
    }

    /// Start the NimBLE host task.
    pub fn run() void {
        sys.nimble_port_run();
    }

    /// Free task resources (call from host task on exit).
    pub fn freeThenResume() void {
        sys.nimble_port_freertos_deinit();
    }
};

// ---------------------------------------------------------------------------
// GAP (Generic Access Profile)
// ---------------------------------------------------------------------------

pub const Gap = struct {
    pub const AdvType = sys.ble_gap_adv_type;
    pub const EventCb = sys.ble_gap_event_fn;

    pub fn setDeviceName(name: [*:0]const u8) !void {
        const rc = sys.ble_svc_gap_device_name_set(name);
        if (rc != 0) return error.NimbleError;
    }

    pub fn advStart(
        own_addr_type: u8,
        direct_addr: ?*const sys.ble_addr_t,
        duration_ms: i32,
        params: ?*const GapAdvParams,
        cb: ?EventCb,
        cb_arg: ?*anyopaque,
    ) !void {
        const rc = sys.ble_gap_adv_start(own_addr_type, direct_addr, duration_ms, params, cb, cb_arg);
        if (rc != 0) return error.NimbleError;
    }

    pub fn advStop() !void {
        const rc = sys.ble_gap_adv_stop();
        if (rc != 0) return error.NimbleError;
    }

    pub fn connect(
        own_addr_type: u8,
        peer_addr: *const sys.ble_addr_t,
        duration_ms: i32,
        params: ?*const GapConnParams,
        cb: EventCb,
        cb_arg: ?*anyopaque,
    ) !void {
        const rc = sys.ble_gap_connect(own_addr_type, peer_addr, duration_ms, params, cb, cb_arg);
        if (rc != 0) return error.NimbleError;
    }

    pub fn terminate(conn_handle: u16, hci_reason: u8) !void {
        const rc = sys.ble_gap_terminate(conn_handle, hci_reason);
        if (rc != 0) return error.NimbleError;
    }
};

// ---------------------------------------------------------------------------
// GATT Server
// ---------------------------------------------------------------------------

pub const GattServer = struct {
    pub fn registerSvcs(svcs: []const GattSvcDef) !void {
        const rc = sys.ble_gatts_add_svcs(svcs.ptr);
        if (rc != 0) return error.NimbleError;
    }

    pub fn count(svcs: []const GattSvcDef, out: *sys.ble_gatt_svc_def_iter) !void {
        _ = svcs;
        _ = out;
    }

    pub fn notify(conn_handle: u16, attr_handle: u16) !void {
        const rc = sys.ble_gatts_notify(conn_handle, attr_handle);
        if (rc != 0) return error.NimbleError;
    }

    pub fn indicate(conn_handle: u16, attr_handle: u16) !void {
        const rc = sys.ble_gatts_indicate(conn_handle, attr_handle);
        if (rc != 0) return error.NimbleError;
    }
};

// ---------------------------------------------------------------------------
// Advertising data builder (OOP API)
// ---------------------------------------------------------------------------

pub const AdvFields = struct {
    fields: sys.ble_hs_adv_fields = .{},

    pub fn setFlags(self: *AdvFields, flags: u8) void {
        self.fields.flags = flags;
        self.fields.flags_is_present = 1;
    }

    pub fn setName(self: *AdvFields, name: [*:0]const u8, complete: bool) void {
        self.fields.name = name;
        self.fields.name_len = @intCast(std.mem.len(name));
        self.fields.name_is_complete = @intFromBool(complete);
    }

    pub fn setTxPwrLvl(self: *AdvFields, level: i8) void {
        self.fields.tx_pwr_lvl = level;
        self.fields.tx_pwr_lvl_is_present = 1;
    }

    pub fn build(self: *AdvFields, buf: []u8, out_len: *u8) !void {
        const rc = sys.ble_hs_adv_set_fields(&self.fields, buf.ptr, out_len, @intCast(buf.len));
        if (rc != 0) return error.NimbleError;
    }
};

const std = @import("std");
