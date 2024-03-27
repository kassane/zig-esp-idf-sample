const sys = @import("sys");

pub const RF = struct {
    pub fn config(conf: u8) void {
        sys.esp_phy_rftest_config(conf);
    }
    pub fn init() void {
        sys.esp_phy_rftest_init();
    }
};
pub fn txContinEn(contin_en: bool) void {
    sys.esp_phy_tx_contin_en(contin_en);
}
pub fn cbw40mEn(en: bool) void {
    sys.esp_phy_cbw40m_en(en);
}
pub fn testStartStop(value: u8) void {
    sys.esp_phy_test_start_stop(value);
}
pub const WIFI = struct {
    pub fn tx(chan: u32, rate: sys.esp_phy_wifi_rate_t, backoff: i8, length_byte: u32, packet_delay: u32, packet_num: u32) void {
        sys.esp_phy_wifi_tx(chan, rate, backoff, length_byte, packet_delay, packet_num);
    }
    pub fn rx(chan: u32, rate: sys.esp_phy_wifi_rate_t) void {
        sys.esp_phy_wifi_rx(chan, rate);
    }
    pub fn txTone(start: u32, chan: u32, backoff: u32) void {
        sys.esp_phy_wifi_tx_tone(start, chan, backoff);
    }
};
pub const BLE = struct {
    pub fn tx(txpwr: u32, chan: u32, len: u32, data_type: sys.esp_phy_ble_type_t, syncw: u32, rate: sys.esp_phy_ble_rate_t, tx_num_in: u32) void {
        sys.esp_phy_ble_tx(txpwr, chan, len, data_type, syncw, rate, tx_num_in);
    }
    pub fn rx(chan: u32, syncw: u32, rate: sys.esp_phy_ble_rate_t) void {
        sys.esp_phy_ble_rx(chan, syncw, rate);
    }
};
pub const BT = struct {
    pub fn txTone(start: u32, chan: u32, power: u32) void {
        sys.esp_phy_bt_tx_tone(start, chan, power);
    }
};
pub fn getRXResult(rx_result: [*c]sys.esp_phy_rx_result_t) void {
    sys.esp_phy_get_rx_result(rx_result);
}
