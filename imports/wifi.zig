const sys = @import("sys");
const errors = @import("error");
const sdkconfig = @cImport({
    @cInclude("sdkconfig.h");
});

pub const WIFI_ENABLE_ENTERPRISE = 1 << 7;

pub const CONFIG_FEATURE_WPA3_SAE_BIT = 1 << 0;
pub const CONFIG_FEATURE_CACHE_TX_BUF_BIT = 1 << 1;
pub const CONFIG_FEATURE_FTM_INITIATOR_BIT = 1 << 2;
pub const CONFIG_FEATURE_FTM_RESPONDER_BIT = 1 << 3;
pub const CONFIG_FEATURE_GCMP_BIT = 1 << 4;
pub const CONFIG_FEATURE_GMAC_BIT = 1 << 5;
pub const CONFIG_FEATURE_11R_BIT = 1 << 6;
pub const CONFIG_FEATURE_WIFI_ENT_BIT = 1 << 7;

pub const WIFI_FEATURE_CAPS =
    CONFIG_FEATURE_WPA3_SAE_BIT |
    CONFIG_FEATURE_CACHE_TX_BUF_BIT |
    CONFIG_FEATURE_FTM_INITIATOR_BIT |
    CONFIG_FEATURE_FTM_RESPONDER_BIT |
    CONFIG_FEATURE_GCMP_BIT |
    CONFIG_FEATURE_GMAC_BIT |
    CONFIG_FEATURE_11R_BIT |
    WIFI_ENABLE_ENTERPRISE;

pub const wifi_mode_t = enum(sys.wifi_mode_t) {
    WIFI_MODE_NULL = sys.WIFI_MODE_NULL,
    WIFI_MODE_STA = sys.WIFI_MODE_STA,
    WIFI_MODE_AP = sys.WIFI_MODE_AP,
    WIFI_MODE_APSTA = sys.WIFI_MODE_APSTA,
    WIFI_MODE_NAN = sys.WIFI_MODE_NAN,
    WIFI_MODE_MAX = sys.WIFI_MODE_MAX,
};
pub const wifi_interface_t = enum(sys.wifi_interface_t) {
    WIFI_IF_STA = sys.WIFI_IF_STA,
    WIFI_IF_AP = sys.WIFI_IF_AP,
    WIFI_IF_NAN = sys.WIFI_IF_NAN,
    WIFI_IF_MAX = sys.WIFI_IF_MAX,
};
pub const wifi_country_policy_t = enum(sys.wifi_country_policy_t) {
    WIFI_COUNTRY_POLICY_AUTO = sys.WIFI_COUNTRY_POLICY_AUTO,
    WIFI_COUNTRY_POLICY_MANUAL = sys.WIFI_COUNTRY_POLICY_MANUAL,
};

pub fn init(config: *const sys.wifi_init_config_t) !void {
    return try errors.espCheckError(sys.esp_wifi_init(config));
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
pub fn setMode(mode: wifi_mode_t) !void {
    return try errors.espCheckError(sys.esp_wifi_set_mode(@intFromEnum(mode)));
}
pub fn getMode(mode: [*]wifi_mode_t) !void {
    return try errors.espCheckError(sys.esp_wifi_get_mode(mode));
}
pub fn start() !void {
    return try errors.espCheckError(sys.esp_wifi_start());
}
pub fn stop() !void {
    return try errors.espCheckError(sys.esp_wifi_stop());
}
pub fn restore() !void {
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
pub const PowerSave = struct {
    pub fn set(@"type": sys.wifi_ps_type_t) !void {
        return try errors.espCheckError(sys.esp_wifi_set_ps(@"type"));
    }
    pub fn get(@"type": [*c]sys.wifi_ps_type_t) !void {
        return try errors.espCheckError(sys.esp_wifi_get_ps(@"type"));
    }
};
pub const Protocol = struct {
    pub fn set(ifx: wifi_interface_t, protocol_bitmap: u8) !void {
        return try errors.espCheckError(sys.esp_wifi_set_protocol(ifx, protocol_bitmap));
    }
    pub fn get(ifx: wifi_interface_t, protocol_bitmap: [*:0]u8) !void {
        return try errors.espCheckError(sys.esp_wifi_get_protocol(ifx, protocol_bitmap));
    }
};
pub const Bandwidth = struct {
    pub fn set(ifx: wifi_interface_t, bw: sys.wifi_bandwidth_t) !void {
        return try errors.espCheckError(sys.esp_wifi_set_bandwidth(ifx, bw));
    }
    pub fn get(ifx: wifi_interface_t, bw: [*c]sys.wifi_bandwidth_t) !void {
        return try errors.espCheckError(sys.esp_wifi_get_bandwidth(ifx, bw));
    }
};
pub const Channel = struct {
    pub fn set(primary: u8, second: sys.wifi_second_chan_t) !void {
        return try errors.espCheckError(sys.esp_wifi_set_channel(primary, second));
    }
    pub fn get(primary: [*c]u8, second: [*c]sys.wifi_second_chan_t) !void {
        return try errors.espCheckError(sys.esp_wifi_get_channel(primary, second));
    }
};
pub const Country = struct {
    pub fn set(country: [*c]const sys.wifi_country_t) !void {
        return try errors.espCheckError(sys.esp_wifi_set_country(country));
    }
    pub fn get(country: [*c]sys.wifi_country_t) !void {
        return try errors.espCheckError(sys.esp_wifi_get_country(country));
    }
    pub fn setCode(country: [*:0]const u8, ieee80211d_enabled: bool) !void {
        return try errors.espCheckError(sys.esp_wifi_set_country_code(country, ieee80211d_enabled));
    }
    pub fn getCode(country: [*:0]u8) !void {
        return try errors.espCheckError(sys.esp_wifi_get_country_code(country));
    }
};
pub const MAC = struct {
    pub fn set(ifx: wifi_interface_t, mac: [*:0]const u8) !void {
        return try errors.espCheckError(sys.esp_wifi_set_mac(ifx, mac));
    }
    pub fn get(ifx: wifi_interface_t, mac: [*:0]u8) !void {
        return try errors.espCheckError(sys.esp_wifi_get_mac(ifx, mac));
    }
};
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
pub const wifiConfig = sys.wifi_config_t;
pub fn setConfig(interface: wifi_interface_t, conf: ?*sys.wifi_config_t) !void {
    return try errors.espCheckError(sys.esp_wifi_set_config(@intFromEnum(interface), conf));
}
pub fn getConfig(interface: wifi_interface_t, conf: ?*sys.wifi_config_t) !void {
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
        return try errors.espCheckError(sys.esp_wifi_set_vendor_ie_cb(callback, ctx));
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
pub fn p80211TX(ifx: wifi_interface_t, buffer: ?*const anyopaque, len: c_int, en_sys_seq: bool) !void {
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
pub fn getTsfTime(interface: wifi_interface_t) i64 {
    return sys.esp_wifi_get_tsf_time(interface);
}
pub fn setInactiveTime(ifx: wifi_interface_t, sec: u16) !void {
    return try errors.espCheckError(sys.esp_wifi_set_inactive_time(ifx, sec));
}
pub fn getInactiveTime(ifx: wifi_interface_t, sec: [*c]u16) !void {
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
pub fn config11bRate(ifx: wifi_interface_t, disable: bool) !void {
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
pub fn config80211TXRate(ifx: wifi_interface_t, rate: sys.wifi_phy_rate_t) !void {
    return try errors.espCheckError(sys.esp_wifi_config_80211_tx_rate(ifx, rate));
}
pub fn disablePMFConfig(ifx: wifi_interface_t) !void {
    return try errors.espCheckError(sys.esp_wifi_disable_pmf_config(ifx));
}
pub fn setDynCS(enabled: bool) !void {
    return try errors.espCheckError(sys.esp_wifi_set_dynamic_cs(enabled));
}
pub const Station = struct {
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
    pub fn deauth(aid: u16) !void {
        return try errors.espCheckError(sys.esp_wifi_deauth_sta(aid));
    }
    pub const AP = struct {
        pub fn getList(sta: ?*sys.wifi_sta_list_t) !void {
            return try errors.espCheckError(sys.esp_wifi_ap_get_sta_list(sta));
        }
        pub fn getAid(mac: [*:0]const u8, aid: [*c]u16) !void {
            return try errors.espCheckError(sys.esp_wifi_ap_get_sta_aid(mac, aid));
        }
        pub fn clearList() !void {
            return try errors.espCheckError(sys.esp_wifi_clear_ap_list());
        }
    };
};

pub const PowerDomain = struct {
    pub fn On() void {
        sys.esp_wifi_power_domain_on();
    }
    pub fn Off() void {
        sys.esp_wifi_power_domain_off();
    }
};

pub const EspNow = struct {
    pub fn init() !void {
        return try errors.espCheckError(sys.esp_now_init());
    }
    pub fn deinit() !void {
        return try errors.espCheckError(sys.esp_now_deinit());
    }
    pub fn getVersion(version: [*c]u32) !void {
        return try errors.espCheckError(sys.esp_now_get_version(version));
    }
    pub fn registerReceiveCallback(cb: sys.esp_now_recv_cb_t) !void {
        return try errors.espCheckError(sys.esp_now_register_recv_cb(cb));
    }
    pub fn unregisterReceiveCallback() !void {
        return try errors.espCheckError(sys.esp_now_unregister_recv_cb());
    }
    pub fn registerSendCallback(cb: sys.esp_now_send_cb_t) !void {
        return try errors.espCheckError(sys.esp_now_register_send_cb(cb));
    }
    pub fn unregisterSendCallback() !void {
        return try errors.espCheckError(sys.esp_now_unregister_send_cb());
    }
    pub fn send(peer_addr: [*:0]const u8, data: [*:0]const u8, len: usize) !void {
        return try errors.espCheckError(sys.esp_now_send(peer_addr, data, len));
    }
    pub fn addPeer(peer: [*c]const sys.esp_now_peer_info_t) !void {
        return try errors.espCheckError(sys.esp_now_add_peer(peer));
    }
    pub fn delPeer(peer_addr: [*:0]const u8) !void {
        return try errors.espCheckError(sys.esp_now_del_peer(peer_addr));
    }
    pub fn modPeer(peer: [*c]const sys.esp_now_peer_info_t) !void {
        return try errors.espCheckError(sys.esp_now_mod_peer(peer));
    }
    pub fn wifiConfigRate(ifx: wifi_interface_t, rate: sys.wifi_phy_rate_t) !void {
        return try errors.espCheckError(sys.esp_wifi_config_espnow_rate(ifx, rate));
    }
    pub fn setPeerRateConfig(peer_addr: [*:0]const u8, config: [*c]sys.esp_now_rate_config_t) !void {
        return try errors.espCheckError(sys.esp_now_set_peer_rate_config(peer_addr, config));
    }
    pub fn getPeer(peer_addr: [*:0]const u8, peer: [*c]sys.esp_now_peer_info_t) !void {
        return try errors.espCheckError(sys.esp_now_get_peer(peer_addr, peer));
    }
    pub fn fetchPeer(from_head: bool, peer: [*c]sys.esp_now_peer_info_t) !void {
        return try errors.espCheckError(sys.esp_now_fetch_peer(from_head, peer));
    }
    pub const isPeerExist = sys.esp_now_is_peer_exist;
    pub fn getPeerNum(num: [*c]sys.esp_now_peer_num_t) !void {
        return try errors.espCheckError(sys.esp_now_get_peer_num(num));
    }
    pub fn setPMK(pmk: [*:0]const u8) !void {
        return try errors.espCheckError(sys.esp_now_set_pmk(pmk));
    }
    pub fn setWakeWindow(window: u16) !void {
        return try errors.espCheckError(sys.esp_now_set_wake_window(window));
    }
};

pub const Enterprise = struct {
    pub const Station = struct {
        pub fn enable() !void {
            return try errors.espCheckError(sys.esp_wifi_sta_enterprise_enable());
        }
        pub fn disable() !void {
            return try errors.espCheckError(sys.esp_wifi_sta_enterprise_disable());
        }
    };
    pub const Client = struct {
        pub fn setIdentity(identity: [*:0]const u8, len: c_int) !void {
            return try errors.espCheckError(sys.esp_eap_client_set_identity(identity, len));
        }
        pub const clearIdentity = sys.esp_eap_client_clear_identity;
        pub fn setUsername(username: [*:0]const u8, len: c_int) !void {
            return try errors.espCheckError(sys.esp_eap_client_set_username(username, len));
        }
        pub const clearUsername = sys.esp_eap_client_clear_username;
        pub fn setPassword(password: [*:0]const u8, len: c_int) !void {
            return try errors.espCheckError(sys.esp_eap_client_set_password(password, len));
        }
        pub const clearPassword = sys.esp_eap_client_clear_new_password;
        pub fn setNewPassword(new_password: [*:0]const u8, len: c_int) !void {
            return try errors.espCheckError(sys.esp_eap_client_set_new_password(new_password, len));
        }
        pub const clearNewPassword = sys.esp_eap_client_clear_new_password;
        pub fn setCACertificate(ca_cert: [*:0]const u8, ca_cert_len: c_int) !void {
            return try errors.espCheckError(sys.esp_eap_client_set_ca_cert(ca_cert, ca_cert_len));
        }
        pub const clearCACertificate = sys.esp_eap_client_clear_ca_cert;
        pub fn setCertificateKey(client_cert: [*:0]const u8, client_cert_len: c_int, private_key: [*:0]const u8, private_key_len: c_int, private_key_password: [*:0]const u8, private_key_passwd_len: c_int) !void {
            return try errors.espCheckError(sys.esp_eap_client_set_certificate_and_key(client_cert, client_cert_len, private_key, private_key_len, private_key_password, private_key_passwd_len));
        }
        pub const clearCertificateKey = sys.esp_eap_client_clear_certificate_and_key;
        pub fn setDisableTimeCheck(disable: bool) !void {
            return try errors.espCheckError(sys.esp_eap_client_set_disable_time_check(disable));
        }
        pub fn getDisableTimeCheck(disable: [*c]bool) !void {
            return try errors.espCheckError(sys.esp_eap_client_get_disable_time_check(disable));
        }
        pub fn setTTLSPhase2Method(@"type": sys.esp_eap_ttls_phase2_types) !void {
            return try errors.espCheckError(sys.esp_eap_client_set_ttls_phase2_method(@"type"));
        }
        pub fn setSuiteb192bitCertification(enable: bool) !void {
            return try errors.espCheckError(sys.esp_eap_client_set_suiteb_192bit_certification(enable));
        }
        pub fn setPACFile(pac_file: [*:0]const u8, pac_file_len: c_int) !void {
            return try errors.espCheckError(sys.esp_eap_client_set_pac_file(pac_file, pac_file_len));
        }
        pub fn setFastParams(config: sys.esp_eap_fast_config) !void {
            return try errors.espCheckError(sys.esp_eap_client_set_fast_params(config));
        }
        pub fn useDefaultCertificateBundle(use_default_bundle: bool) !void {
            return try errors.espCheckError(sys.esp_eap_client_use_default_cert_bundle(use_default_bundle));
        }
    };
};

pub const Internal = struct {
    // STUBS
    pub fn setStationIp() !void {
        return try errors.espCheckError(sys.esp_wifi_internal_set_sta_ip());
    }
    pub fn registryNetstackBufCallback(ref: sys.wifi_netstack_buf_ref_cb_t, free: sys.wifi_netstack_buf_free_cb_t) !void {
        return try errors.espCheckError(sys.esp_wifi_internal_reg_netstack_buf_cb(ref, free));
    }
    pub fn freeRXBuffer(buffer: ?*anyopaque) !void {
        if (buffer) |b|
            return try errors.espCheckError(sys.esp_wifi_internal_free_rx_buffer(b));
    }
    pub fn txBuffer(ifx: wifi_interface_t, buffer: ?*anyopaque, len: u16) !void {
        return try errors.espCheckError(sys.esp_wifi_internal_tx(ifx, buffer, len));
    }
    pub fn registryTXCallBack(ifx: wifi_interface_t, @"fn": sys.wifi_rxcb_t) !void {
        return try errors.espCheckError(sys.esp_wifi_internal_reg_rxcb(ifx, @"fn"));
    }
};

pub fn init_config_default() sys.wifi_init_config_t {
    return sys.wifi_init_config_t{
        .osi_funcs = &sys.g_wifi_osi_funcs,
        .wpa_crypto_funcs = sys.g_wifi_default_wpa_crypto_funcs,
        .static_rx_buf_num = sdkconfig.CONFIG_ESP_WIFI_STATIC_RX_BUFFER_NUM,
        .dynamic_rx_buf_num = sdkconfig.CONFIG_ESP_WIFI_DYNAMIC_RX_BUFFER_NUM,
        .tx_buf_type = sdkconfig.CONFIG_ESP_WIFI_TX_BUFFER_TYPE,
        .static_tx_buf_num = sys.WIFI_STATIC_TX_BUFFER_NUM,
        .dynamic_tx_buf_num = sys.WIFI_DYNAMIC_TX_BUFFER_NUM,
        .rx_mgmt_buf_type = sdkconfig.CONFIG_ESP_WIFI_DYNAMIC_RX_MGMT_BUF,
        .rx_mgmt_buf_num = sys.WIFI_RX_MGMT_BUF_NUM_DEF,
        .cache_tx_buf_num = sys.WIFI_CACHE_TX_BUFFER_NUM,
        .csi_enable = sys.WIFI_CSI_ENABLED,
        .ampdu_rx_enable = sys.WIFI_AMPDU_RX_ENABLED,
        .ampdu_tx_enable = sys.WIFI_AMPDU_TX_ENABLED,
        .amsdu_tx_enable = sys.WIFI_AMSDU_TX_ENABLED,
        .nvs_enable = sys.WIFI_NVS_ENABLED,
        .nano_enable = sys.WIFI_NANO_FORMAT_ENABLED,
        .rx_ba_win = sys.WIFI_DEFAULT_RX_BA_WIN,
        .wifi_task_core_id = sys.WIFI_TASK_CORE_ID,
        .beacon_max_len = sys.WIFI_SOFTAP_BEACON_MAX_LEN,
        .mgmt_sbuf_num = sys.WIFI_MGMT_SBUF_NUM,
        .feature_caps = sys.WIFI_FEATURE_CAPS,
        .sta_disconnected_pm = sys.WIFI_STA_DISCONNECTED_PM_ENABLED != 0,
        .espnow_max_encrypt_num = sdkconfig.CONFIG_ESP_WIFI_ESPNOW_MAX_ENCRYPT_NUM,
        .tx_hetb_queue_num = sys.WIFI_TX_HETB_QUEUE_NUM,
        .dump_hesigb_enable = sys.WIFI_DUMP_HESIGB_ENABLED != 0,
        .magic = sys.WIFI_INIT_CONFIG_MAGIC,
    };
}
