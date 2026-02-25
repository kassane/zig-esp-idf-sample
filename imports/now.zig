const sys = @import("sys");
const errors = @import("error");

// ---------------------------------------------------------------------------
// Re-exported types from sys
// ---------------------------------------------------------------------------

pub const WifiInterface = sys.wifi_interface_t;
pub const WifiPktRxCtrl = sys.wifi_pkt_rx_ctrl_t;
pub const WifiTxInfo = sys.wifi_tx_info_t;
pub const WifiTxRateConfig = sys.wifi_tx_rate_config_t;
pub const WifiActionTx = sys.wifi_action_tx_t;
pub const WifiSecondChan = sys.wifi_second_chan_t;
pub const WifiRoc = sys.wifi_roc_t;

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

pub const MAC_LEN = 6;
pub const LMK_LEN = 16;
pub const PMK_LEN = 16;
pub const OUI_LEN = 3;

// ---------------------------------------------------------------------------
// Send status
// ---------------------------------------------------------------------------

pub const SendStatus = enum(c_uint) {
    success = 0,
    fail = 1,
};

// ---------------------------------------------------------------------------
// Peer info
// ---------------------------------------------------------------------------

pub const PeerInfo = extern struct {
    peer_addr: [MAC_LEN]u8 = .{0} ** MAC_LEN,
    lmk: [LMK_LEN]u8 = .{0} ** LMK_LEN,
    channel: u8 = 0,
    ifidx: WifiInterface = undefined,
    encrypt: bool = false,
    priv: ?*anyopaque = null,
};

pub const PeerNum = extern struct {
    total_num: c_int = 0,
    encrypt_num: c_int = 0,
};

// ---------------------------------------------------------------------------
// Receive info (passed to the recv callback)
// ---------------------------------------------------------------------------

pub const RecvInfo = extern struct {
    src_addr: [*c]u8 = null,
    des_addr: [*c]u8 = null,
    rx_ctrl: ?*WifiPktRxCtrl = null,
};

// ---------------------------------------------------------------------------
// Switch-channel / remain-on-channel action structs
// ---------------------------------------------------------------------------

pub const SwitchChannel = extern struct {
    type: WifiActionTx = undefined,
    channel: u8 = 0,
    sec_channel: WifiSecondChan = undefined,
    wait_time_ms: u32 = 0,
    op_id: u8 = 0,
    dest_mac: [MAC_LEN]u8 = .{0} ** MAC_LEN,
    data_len: u16 = 0,
    _data: [0]u8 = .{},
};

pub const RemainOnChannel = extern struct {
    type: WifiRoc = undefined,
    channel: u8 = 0,
    sec_channel: WifiSecondChan = undefined,
    wait_time_ms: u32 = 0,
    op_id: u8 = 0,
};

// ---------------------------------------------------------------------------
// Callback types — use these in your application; cast to/from the C type
// at registration time via the EspNow.registerRecvCb / registerSendCb wrappers.
// ---------------------------------------------------------------------------

pub const RecvCb = *const fn (
    info: *const RecvInfo,
    data: [*]const u8,
    data_len: usize,
) void;

pub const SendCb = *const fn (
    tx_info: *const WifiTxInfo,
    status: SendStatus,
) void;

// Internal C-ABI adapters stored when a Zig callback is registered.
var recv_cb_zig: ?RecvCb = null;
var send_cb_zig: ?SendCb = null;

fn recvCbAdapter(
    info: [*c]const sys.esp_now_recv_info_t,
    data: [*c]const u8,
    data_len: c_int,
) callconv(.c) void {
    if (recv_cb_zig) |cb|
        cb(@ptrCast(info), data, @intCast(data_len));
}

fn sendCbAdapter(
    tx_info: [*c]const sys.esp_now_send_info_t,
    status: sys.esp_now_send_status_t,
) callconv(.c) void {
    if (send_cb_zig) |cb|
        cb(@ptrCast(tx_info), @enumFromInt(status));
}

// ---------------------------------------------------------------------------
// EspNow namespace
// ---------------------------------------------------------------------------

pub const EspNow = struct {

    // -- Lifecycle -----------------------------------------------------------

    pub fn init() !void {
        try errors.espCheckError(sys.esp_now_init());
    }

    pub fn deinit() !void {
        try errors.espCheckError(sys.esp_now_deinit());
    }

    pub fn getVersion() !u32 {
        var ver: u32 = 0;
        try errors.espCheckError(sys.esp_now_get_version(&ver));
        return ver;
    }

    // -- Callbacks -----------------------------------------------------------

    /// Register a Zig-typed receive callback.
    pub fn registerRecvCb(cb: RecvCb) !void {
        recv_cb_zig = cb;
        try errors.espCheckError(sys.esp_now_register_recv_cb(recvCbAdapter));
    }

    pub fn unregisterRecvCb() !void {
        recv_cb_zig = null;
        try errors.espCheckError(sys.esp_now_unregister_recv_cb());
    }

    /// Register a Zig-typed send callback.
    pub fn registerSendCb(cb: SendCb) !void {
        send_cb_zig = cb;
        try errors.espCheckError(sys.esp_now_register_send_cb(sendCbAdapter));
    }

    pub fn unregisterSendCb() !void {
        send_cb_zig = null;
        try errors.espCheckError(sys.esp_now_unregister_send_cb());
    }

    // -- Sending -------------------------------------------------------------

    /// Send data to a peer.
    /// `peer_addr` — 6-byte MAC or null for broadcast.
    /// `data`      — payload slice (max 250 bytes).
    pub fn send(peer_addr: ?*const [MAC_LEN]u8, data: []const u8) !void {
        const addr_ptr: [*c]const u8 = if (peer_addr) |a| a else null;
        try errors.espCheckError(sys.esp_now_send(addr_ptr, data.ptr, data.len));
    }

    // -- Peer management -----------------------------------------------------

    pub fn addPeer(peer: *const PeerInfo) !void {
        try errors.espCheckError(sys.esp_now_add_peer(@ptrCast(peer)));
    }

    pub fn delPeer(peer_addr: *const [MAC_LEN]u8) !void {
        try errors.espCheckError(sys.esp_now_del_peer(peer_addr));
    }

    pub fn modPeer(peer: *const PeerInfo) !void {
        try errors.espCheckError(sys.esp_now_mod_peer(@ptrCast(peer)));
    }

    pub fn setPeerRateConfig(
        peer_addr: *const [MAC_LEN]u8,
        config: *WifiTxRateConfig,
    ) !void {
        try errors.espCheckError(sys.esp_now_set_peer_rate_config(peer_addr, config));
    }

    pub fn getPeer(peer_addr: *const [MAC_LEN]u8) !PeerInfo {
        var info: PeerInfo = undefined;
        try errors.espCheckError(sys.esp_now_get_peer(peer_addr, @ptrCast(&info)));
        return info;
    }

    /// Iterate over the peer list.
    /// Pass `from_head = true` on the first call, then `false` to continue.
    pub fn fetchPeer(from_head: bool) !PeerInfo {
        var info: PeerInfo = undefined;
        try errors.espCheckError(sys.esp_now_fetch_peer(from_head, @ptrCast(&info)));
        return info;
    }

    pub fn isPeerExist(peer_addr: *const [MAC_LEN]u8) bool {
        return sys.esp_now_is_peer_exist(peer_addr);
    }

    pub fn getPeerNum() !PeerNum {
        var num: PeerNum = undefined;
        try errors.espCheckError(sys.esp_now_get_peer_num(@ptrCast(&num)));
        return num;
    }

    // -- Security ------------------------------------------------------------

    /// Set the Primary Master Key (16 bytes).
    pub fn setPmk(pmk: *const [PMK_LEN]u8) !void {
        try errors.espCheckError(sys.esp_now_set_pmk(pmk));
    }

    // -- Power saving --------------------------------------------------------

    pub fn setWakeWindow(window: u16) !void {
        try errors.espCheckError(sys.esp_now_set_wake_window(window));
    }

    // -- OUI -----------------------------------------------------------------

    /// Set user OUI (3 bytes).
    pub fn setUserOui(oui: *[OUI_LEN]u8) !void {
        try errors.espCheckError(sys.esp_now_set_user_oui(oui));
    }

    /// Get user OUI (3 bytes).
    pub fn getUserOui(oui: *[OUI_LEN]u8) !void {
        try errors.espCheckError(sys.esp_now_get_user_oui(oui));
    }

    // -- Channel actions -----------------------------------------------------

    pub fn switchChannel(config: *SwitchChannel) !void {
        try errors.espCheckError(sys.esp_now_switch_channel_tx(@ptrCast(config)));
    }

    pub fn remainOnChannel(config: *RemainOnChannel) !void {
        try errors.espCheckError(sys.esp_now_remain_on_channel(@ptrCast(config)));
    }
};

// ---------------------------------------------------------------------------
// SmartConfig — bundled here because the raw bindings file included it.
// ---------------------------------------------------------------------------

pub const SmartconfigType = enum(c_uint) {
    esptouch = 0,
    airkiss = 1,
    esptouch_airkiss = 2,
    esptouch_v2 = 3,
};

pub const SmartconfigEvent = enum(c_uint) {
    scan_done = 0,
    found_channel = 1,
    got_ssid_pswd = 2,
    send_ack_done = 3,
};

pub const SmartconfigGotSsidPswd = extern struct {
    ssid: [32]u8 = .{0} ** 32,
    password: [64]u8 = .{0} ** 64,
    bssid_set: bool = false,
    bssid: [MAC_LEN]u8 = .{0} ** MAC_LEN,
    type: SmartconfigType = .esptouch,
    token: u8 = 0,
    cellphone_ip: [4]u8 = .{0} ** 4,
};

pub const SmartConfig = struct {
    pub fn getVersion() [*:0]const u8 {
        return sys.esp_smartconfig_get_version();
    }

    pub fn start(config: *const sys.smartconfig_start_config_t) !void {
        try errors.espCheckError(sys.esp_smartconfig_start(config));
    }

    pub fn stop() !void {
        try errors.espCheckError(sys.esp_smartconfig_stop());
    }

    pub fn setTimeout(time_s: u8) !void {
        try errors.espCheckError(sys.esp_esptouch_set_timeout(time_s));
    }

    pub fn setType(kind: SmartconfigType) !void {
        try errors.espCheckError(sys.esp_smartconfig_set_type(@intFromEnum(kind)));
    }

    pub fn setFastMode(enable: bool) !void {
        try errors.espCheckError(sys.esp_smartconfig_fast_mode(enable));
    }

    pub fn getRvdData(buf: []u8) !void {
        try errors.espCheckError(sys.esp_smartconfig_get_rvd_data(buf.ptr, @intCast(buf.len)));
    }
};
