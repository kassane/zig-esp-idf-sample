const sys = @import("sys");

pub const PowerDomain = struct {
    pub fn On() void {
        sys.esp_wifi_bt_power_domain_on();
    }
    pub fn Off() void {
        sys.esp_wifi_bt_power_domain_off();
    }
};

// TODO: implement
