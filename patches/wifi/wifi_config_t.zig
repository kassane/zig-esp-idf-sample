pub const wifi_config_t = extern union {
    ap: wifi_ap_config_t,
    sta: wifi_sta_config_t,
    nan: wifi_nan_sync_config_t,
};
