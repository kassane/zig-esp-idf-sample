const wifi_nan_cfg = extern struct {
    op_channel: u8,
    master_pref: u8,
    scan_time: u8,
    warm_up_sec: u16,
};

pub const wifi_config_t = extern union {
    ap: wifi_ap_config_t,
    sta: wifi_sta_config_t,
    nan: wifi_nan_cfg,
};
