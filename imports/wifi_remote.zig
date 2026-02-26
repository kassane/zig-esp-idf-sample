const sys = @import("sys");
const errors = @import("error");

// ─────────────────────────────────────────────────────────────────────────────
// Re-exported types
// ─────────────────────────────────────────────────────────────────────────────

pub const WifiInterface = sys.wifi_interface_t;
pub const WifiMode = sys.wifi_mode_t;
pub const WifiPsType = sys.wifi_ps_type_t;
pub const WifiBandwidth = sys.wifi_bandwidth_t;
pub const WifiSecondChan = sys.wifi_second_chan_t;
pub const WifiCountry = sys.wifi_country_t;
pub const WifiStorage = sys.wifi_storage_t;
pub const WifiPhyRate = sys.wifi_phy_rate_t;
pub const WifiBand = sys.wifi_band_t;
pub const WifiPhyMode = sys.wifi_phy_mode_t;

// ─────────────────────────────────────────────────────────────────────────────
// Remote Wi-Fi API
// ─────────────────────────────────────────────────────────────────────────────

pub const WifiRemote = struct {

    // ─── Lifecycle ──────────────────────────────────────────────────────────────

    pub fn init(config: *const sys.wifi_init_config_t) !void {
        try errors.espCheckError(sys.esp_wifi_remote_init(config));
    }

    pub fn deinit() !void {
        try errors.espCheckError(sys.esp_wifi_remote_deinit());
    }

    pub fn start() !void {
        try errors.espCheckError(sys.esp_wifi_remote_start());
    }

    pub fn stop() !void {
        try errors.espCheckError(sys.esp_wifi_remote_stop());
    }

    pub fn restore() !void {
        try errors.espCheckError(sys.esp_wifi_remote_restore());
    }

    // ─── Mode ───────────────────────────────────────────────────────────────────

    pub fn setMode(mode: WifiMode) !void {
        try errors.espCheckError(sys.esp_wifi_remote_set_mode(mode));
    }

    pub fn getMode() !WifiMode {
        var m: WifiMode = undefined;
        try errors.espCheckError(sys.esp_wifi_remote_get_mode(&m));
        return m;
    }

    // ─── Connect / Disconnect ──────────────────────────────────────────────────

    pub fn connect() !void {
        try errors.espCheckError(sys.esp_wifi_remote_connect());
    }

    pub fn disconnect() !void {
        try errors.espCheckError(sys.esp_wifi_remote_disconnect());
    }

    // ─── Scan ───────────────────────────────────────────────────────────────────

    pub fn scanStart(config: ?*const sys.wifi_scan_config_t, block: bool) !void {
        try errors.espCheckError(sys.esp_wifi_remote_scan_start(config, block));
    }

    pub fn scanStop() !void {
        try errors.espCheckError(sys.esp_wifi_remote_scan_stop());
    }

    pub fn getApNum() !u16 {
        var n: u16 = 0;
        try errors.espCheckError(sys.esp_wifi_remote_scan_get_ap_num(&n));
        return n;
    }

    pub fn getApRecords(records: []sys.wifi_ap_record_t) !u16 {
        var num = @as(u16, @intCast(records.len));
        try errors.espCheckError(sys.esp_wifi_remote_scan_get_ap_records(&num, records.ptr));
        return num;
    }

    // ─── Station info ───────────────────────────────────────────────────────────

    pub fn staGetApInfo() !sys.wifi_ap_record_t {
        var info: sys.wifi_ap_record_t = undefined;
        try errors.espCheckError(sys.esp_wifi_remote_sta_get_ap_info(&info));
        return info;
    }

    pub fn staGetRssi() !i32 {
        var rssi: c_int = 0;
        try errors.espCheckError(sys.esp_wifi_remote_sta_get_rssi(&rssi));
        return @intCast(rssi);
    }

    // ─── Configuration ──────────────────────────────────────────────────────────

    pub fn setConfig(iface: WifiInterface, conf: *const sys.wifi_config_t) !void {
        try errors.espCheckError(sys.esp_wifi_remote_set_config(iface, @constCast(conf)));
    }

    pub fn getConfig(iface: WifiInterface) !sys.wifi_config_t {
        var conf: sys.wifi_config_t = undefined;
        try errors.espCheckError(sys.esp_wifi_remote_get_config(iface, &conf));
        return conf;
    }

    pub fn setCountry(country: *const WifiCountry) !void {
        try errors.espCheckError(sys.esp_wifi_remote_set_country(country));
    }

    pub fn setMac(iface: WifiInterface, mac: []const u8) !void {
        if (mac.len != 6) return error.InvalidMacLength;
        try errors.espCheckError(sys.esp_wifi_remote_set_mac(iface, mac.ptr));
    }

    pub fn getMac(iface: WifiInterface) ![6]u8 {
        var mac: [6]u8 = undefined;
        try errors.espCheckError(sys.esp_wifi_remote_get_mac(iface, &mac));
        return mac;
    }

    // ─── Promiscuous ────────────────────────────────────────────────────────────

    pub fn setPromiscuous(enable: bool) !void {
        try errors.espCheckError(sys.esp_wifi_remote_set_promiscuous(enable));
    }

    pub fn setPromiscuousRxCb(cb: sys.wifi_promiscuous_cb_t) !void {
        try errors.espCheckError(sys.esp_wifi_remote_set_promiscuous_rx_cb(cb));
    }

    pub fn createDefaultStaNetif() !*sys.esp_netif_t {
        return sys.esp_wifi_remote_create_default_sta() orelse error.FailedToCreateNetif;
    }

    pub fn createDefaultApNetif() !*sys.esp_netif_t {
        return sys.esp_wifi_remote_create_default_ap() orelse error.FailedToCreateNetif;
    }
};
