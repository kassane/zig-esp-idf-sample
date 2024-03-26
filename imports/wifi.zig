const sys = @import("sys");
const std = @import("std");
const errors = @import("error");

pub fn init(config: ?*const sys.wifi_init_config_t) !?*const sys.wifi_init_config_t {
    try errors.espCheckError(sys.esp_wifi_init(config));
    return config;
}

pub fn setDefaultWifiStationHandlers() !void {
    return try errors.espCheckError(sys.esp_wifi_set_default_wifi_sta_handlers());
}
pub fn setDefaultWifiAPHandlers() !void {
    return try errors.espCheckError(sys.esp_wifi_set_default_wifi_ap_handlers());
}
pub fn setDefaultWifiNANHandlers() !void {
    return try errors.espCheckError(sys.esp_wifi_set_default_wifi_nan_handlers());
}
pub fn clearDefaultWifiDriverHandlers(esp_netif: ?*anyopaque) !void {
    return try errors.espCheckError(sys.esp_wifi_clear_default_wifi_driver_and_handlers(esp_netif));
}
pub fn deinit() !void {
    return try errors.espCheckError(sys.esp_wifi_deinit());
}
pub fn setMode(mode: sys.wifi_mode_t) !void {
    return try errors.espCheckError(sys.esp_wifi_set_mode(mode));
}
pub fn getMode(mode: [*c]sys.wifi_mode_t) !void {
    return try errors.espCheckError(sys.esp_wifi_get_mode(mode));
}
pub fn stop() !void {
    return try errors.espCheckError(sys.esp_wifi_stop());
}
pub fn sestore() !void {
    return try errors.espCheckError(sys.esp_wifi_restore());
}
pub fn connect() !void {
    return try errors.espCheckError(sys.esp_wifi_connect());
}
pub fn disconnect() !void {
    return try errors.espCheckError(sys.esp_wifi_disconnect());
}
pub fn clearFastConnect() !void {
    return try errors.espCheckError(sys.esp_wifi_clear_fast_connect());
}
pub fn deauthStation(aid: u16) !void {
    return try errors.espCheckError(sys.esp_wifi_deauth_sta(aid));
}
pub const Scan = struct {
    pub fn start(config: [*c]const sys.wifi_scan_config_t, block: bool) !void {
        return try errors.espCheckError(sys.esp_wifi_scan_start(config, block));
    }
    pub fn stop() !void {
        return try errors.espCheckError(sys.esp_wifi_scan_stop());
    }
    pub fn getAPNum(number: [*c]u16) !void {
        return try errors.espCheckError(sys.esp_wifi_scan_get_ap_num(number));
    }
    pub fn getAPRecords(number: [*c]u16, ap_records: ?*sys.wifi_ap_record_t) !void {
        return try errors.espCheckError(sys.esp_wifi_scan_get_ap_records(number, ap_records));
    }
    pub fn getAPRecord(ap_record: ?*sys.wifi_ap_record_t) !void {
        return try errors.espCheckError(sys.esp_wifi_scan_get_ap_record(ap_record));
    }
};
pub fn wifiSet_ps(@"type": sys.wifi_ps_type_t) !void {
    return try errors.espCheckError(sys.esp_wifi_set_ps(@"type"));
}
pub fn wifiGet_ps(@"type": [*c]sys.wifi_ps_type_t) !void {
    return try errors.espCheckError(sys.esp_wifi_get_ps(@"type"));
}
pub fn wifiSet_protocol(ifx: sys.wifi_interface_t, protocol_bitmap: u8) !void {
    return try errors.espCheckError(sys.esp_wifi_set_protocol(ifx, protocol_bitmap));
}
pub fn wifiGet_protocol(ifx: sys.wifi_interface_t, protocol_bitmap: [*:0]u8) !void {
    return try errors.espCheckError(sys.esp_wifi_get_protocol(ifx, protocol_bitmap));
}
pub fn wifiSet_bandwidth(ifx: sys.wifi_interface_t, bw: sys.wifi_bandwidth_t) !void {
    return try errors.espCheckError(sys.esp_wifi_set_bandwidth(ifx, bw));
}
pub fn wifiGet_bandwidth(ifx: sys.wifi_interface_t, bw: [*c]sys.wifi_bandwidth_t) !void {
    return try errors.espCheckError(sys.esp_wifi_get_bandwidth(ifx, bw));
}
pub fn wifiSet_channel(primary: u8, second: sys.wifi_second_chan_t) !void {
    return try errors.espCheckError(sys.esp_wifi_set_channel(primary, second));
}
pub fn wifiGet_channel(primary: [*c]u8, second: [*c]sys.wifi_second_chan_t) !void {
    return try errors.espCheckError(sys.esp_wifi_get_channel(primary, second));
}
pub fn wifiSet_country(country: [*c]const sys.wifi_country_t) !void {
    return try errors.espCheckError(sys.esp_wifi_set_country(country));
}
pub fn wifiGet_country(country: [*c]sys.wifi_country_t) !void {
    return try errors.espCheckError(sys.esp_wifi_get_country(country));
}
pub fn wifiSet_mac(ifx: sys.wifi_interface_t, mac: [*:0]const u8) !void {
    return try errors.espCheckError(sys.esp_wifi_set_mac(ifx, mac));
}
pub fn wifiGet_mac(ifx: sys.wifi_interface_t, mac: [*:0]u8) !void {
    return try errors.espCheckError(sys.esp_wifi_get_mac(ifx, mac));
}
pub const Promiscuous = struct {
    pub const promiscuous_callback_type = sys.wifi_promiscuous_cb_t;
    pub fn setRXCallback(cb: sys.wifi_promiscuous_cb_t) !void {
        return try errors.espCheckError(sys.esp_wifi_set_promiscuous_rx_cb(cb));
    }
    pub fn set(en: bool) !void {
        return try errors.espCheckError(sys.esp_wifi_set_promiscuous(en));
    }
    pub fn get(en: [*c]bool) !void {
        return try errors.espCheckError(sys.esp_wifi_get_promiscuous(en));
    }
    pub fn setFilter(filter: [*c]const sys.wifi_promiscuous_filter_t) !void {
        return try errors.espCheckError(sys.esp_wifi_set_promiscuous_filter(filter));
    }
    pub fn getFilter(filter: [*c]sys.wifi_promiscuous_filter_t) !void {
        return try errors.espCheckError(sys.esp_wifi_get_promiscuous_filter(filter));
    }
    pub fn setCtrlFilter(filter: [*c]const sys.wifi_promiscuous_filter_t) !void {
        return try errors.espCheckError(sys.esp_wifi_set_promiscuous_ctrl_filter(filter));
    }
    pub fn getCtrlFilter(filter: [*c]sys.wifi_promiscuous_filter_t) !void {
        return try errors.espCheckError(sys.esp_wifi_get_promiscuous_ctrl_filter(filter));
    }
};
pub fn setConfig(interface: sys.wifi_interface_t, conf: ?*sys.wifi_config_t) !void {
    return try errors.espCheckError(sys.esp_wifi_set_config(interface, conf));
}
pub fn getConfig(interface: sys.wifi_interface_t, conf: ?*sys.wifi_config_t) !void {
    return try errors.espCheckError(sys.esp_wifi_get_config(interface, conf));
}
pub fn setStorage(storage: sys.wifi_storage_t) !void {
    return try errors.espCheckError(sys.esp_wifi_set_storage(storage));
}
pub const Vendor = struct {
    pub const vendor_ie_callback_id_type = sys.wifi_vendor_ie_id_t;
    pub fn setIE(enable: bool, @"type": sys.wifi_vendor_ie_type_t, idx: sys.wifi_vendor_ie_id_t, vnd_ie: ?*const anyopaque) !void {
        return try errors.espCheckError(sys.esp_wifi_set_vendor_ie(enable, @"type", idx, vnd_ie));
    }
    pub fn setIECallback(callback: sys.esp_vendor_ie_cb_t, ctx: ?*anyopaque) !void {
        return try errors.espCheckError(sys.esp_ifi_set_vendor_ie_cb(callback, ctx));
    }
};
pub fn setMaxTXPower(power: i8) !void {
    return try errors.espCheckError(sys.esp_wifi_set_max_tx_power(power));
}
pub fn getMaxTXPower(power: [*c]i8) !void {
    return try errors.espCheckError(sys.esp_wifi_get_max_tx_power(power));
}
pub fn setEventMask(mask: u32) !void {
    return try errors.espCheckError(sys.esp_wifi_set_event_mask(mask));
}
pub fn getEventMask(mask: [*c]u32) !void {
    return try errors.espCheckError(sys.esp_wifi_get_event_mask(mask));
}
pub fn p80211TX(ifx: sys.wifi_interface_t, buffer: ?*const anyopaque, len: c_int, en_sys_seq: bool) !void {
    return try errors.espCheckError(sys.esp_wifi_80211_tx(ifx, buffer, len, en_sys_seq));
}
pub const csi_callback_type = sys.wifi_csi_cb_t;
pub fn setCsiRXCallback(callback: csi_callback_type, ctx: ?*anyopaque) !void {
    return try errors.espCheckError(sys.esp_wifi_set_csi_rx_cb(callback, ctx));
}
pub fn setCsiConfig(config: ?*const csi_callback_type) !void {
    return try errors.espCheckError(sys.esp_wifi_set_csi_config(config));
}
pub fn setCsi(en: bool) !void {
    return try errors.espCheckError(sys.esp_wifi_set_csi(en));
}
pub fn setAntGPIO(config: [*c]const sys.wifi_ant_gpio_config_t) !void {
    return try errors.espCheckError(sys.esp_wifi_set_ant_gpio(config));
}
pub fn getAntGPIO(config: [*c]sys.wifi_ant_gpio_config_t) !void {
    return try errors.espCheckError(sys.esp_wifi_get_ant_gpio(config));
}
pub fn setAnt(config: ?*const sys.wifi_ant_config_t) !void {
    return try errors.espCheckError(sys.esp_wifi_set_ant(config));
}
pub fn getAnt(config: ?*sys.wifi_ant_config_t) !void {
    return try errors.espCheckError(sys.esp_wifi_get_ant(config));
}
pub fn getTsfTime(interface: sys.wifi_interface_t) i64 {
    return sys.esp_wifi_get_tsf_time(interface);
}
pub fn setInactiveTime(ifx: sys.wifi_interface_t, sec: u16) !void {
    return try errors.espCheckError(sys.esp_wifi_set_inactive_time(ifx, sec));
}
pub fn getInactiveTime(ifx: sys.wifi_interface_t, sec: [*c]u16) !void {
    return try errors.espCheckError(sys.esp_wifi_get_inactive_time(ifx, sec));
}
pub fn statisDump(modules: u32) !void {
    return try errors.espCheckError(sys.esp_wifi_statis_dump(modules));
}
pub fn setRssiThreshold(rssi: i32) !void {
    return try errors.espCheckError(sys.esp_wifi_set_rssi_threshold(rssi));
}
pub const FTM = struct {
    pub fn initiateSession(cfg: [*c]sys.wifi_ftm_initiator_cfg_t) !void {
        return try errors.espCheckError(sys.esp_wifi_ftm_initiate_session(cfg));
    }
    pub fn endSession() !void {
        return try errors.espCheckError(sys.esp_wifi_ftm_end_session());
    }
    pub fn respSetOffset(offset_cm: i16) !void {
        return try errors.espCheckError(sys.esp_wifi_ftm_resp_set_offset(offset_cm));
    }
};
pub fn config11bRate(ifx: sys.wifi_interface_t, disable: bool) !void {
    return try errors.espCheckError(sys.esp_wifi_config_11b_rate(ifx, disable));
}
pub fn connectionlessModuleSetWakeInterval(wake_interval: u16) !void {
    return try errors.espCheckError(sys.esp_wifi_connectionless_module_set_wake_interval(wake_interval));
}
pub fn forceWakeupAcquire() !void {
    return try errors.espCheckError(sys.esp_wifi_force_wakeup_acquire());
}
pub fn forceWakeupRelease() !void {
    return try errors.espCheckError(sys.esp_wifi_force_wakeup_release());
}
pub fn setCountryCode(country: [*:0]const u8, ieee80211d_enabled: bool) !void {
    return try errors.espCheckError(sys.esp_wifi_set_country_code(country, ieee80211d_enabled));
}
pub fn getCountryCode(country: [*c]u8) !void {
    return try errors.espCheckError(sys.esp_wifi_get_country_code(country));
}
pub fn config80211TXRate(ifx: sys.wifi_interface_t, rate: sys.wifi_phy_rate_t) !void {
    return try errors.espCheckError(sys.esp_wifi_config_80211_tx_rate(ifx, rate));
}
pub fn disablePMFConfig(ifx: sys.wifi_interface_t) !void {
    return try errors.espCheckError(sys.esp_wifi_disable_pmf_config(ifx));
}
pub fn setDynCS(enabled: bool) !void {
    return try errors.espCheckError(sys.esp_wifi_set_dynamic_cs(enabled));
}
pub const Station = struct {
    pub fn rt() !void {
        return try errors.espCheckError(sys.esp_wifi_start());
    }
    pub fn getAPInfo(ap_info: ?*sys.wifi_ap_record_t) !void {
        return try errors.espCheckError(sys.esp_wifi_sta_get_ap_info(ap_info));
    }
    pub fn getRssi(rssi: [*c]c_int) !void {
        return try errors.espCheckError(sys.esp_wifi_sta_get_rssi(rssi));
    }
    pub fn getAid(aid: [*c]u16) !void {
        return try errors.espCheckError(sys.esp_wifi_sta_get_aid(aid));
    }
    pub fn getNegotiatedPHYMode(phymode: [*c]sys.wifi_phy_mode_t) !void {
        return try errors.espCheckError(sys.esp_wifi_sta_get_negotiated_phymode(phymode));
    }
    pub const AP = struct {
        pub fn getStationList(sta: ?*sys.wifi_sta_list_t) !void {
            return try errors.espCheckError(sys.esp_wifi_ap_get_sta_list(sta));
        }
        pub fn getStationAid(mac: [*:0]const u8, aid: [*c]u16) !void {
            return try errors.espCheckError(sys.esp_wifi_ap_get_sta_aid(mac, aid));
        }
        pub fn clearList() !void {
            return try errors.espCheckError(sys.esp_wifi_clear_ap_list());
        }
    };
};
