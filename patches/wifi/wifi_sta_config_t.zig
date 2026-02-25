pub const wifi_sta_config_t = extern struct {
    ssid: [32]u8 = @import("std").mem.zeroes([32]u8),
    password: [64]u8 = @import("std").mem.zeroes([64]u8),
    scan_method: wifi_scan_method_t = @import("std").mem.zeroes(wifi_scan_method_t),
    bssid_set: bool = false,
    bssid: [6]u8 = @import("std").mem.zeroes([6]u8),
    channel: u8 = 0,
    listen_interval: u16 = 3,
    sort_method: wifi_sort_method_t = @import("std").mem.zeroes(wifi_sort_method_t),
    threshold: wifi_scan_threshold_t = @import("std").mem.zeroes(wifi_scan_threshold_t),
    pmf_cfg: wifi_pmf_config_t = @import("std").mem.zeroes(wifi_pmf_config_t),

    // Connection Feature
    // 0     rm_enabled
    // 1     btm_enabled
    // 2     mbo_enabled
    // 3     ft_enabled
    // 4     owe_enabled
    // 5     transition_disable
    // 6-31  reserved
    connection_features: u32 = 0, // Stores BTM, RM, MBO, FT, OWE, etc.

    sae_pwe_h2e: wifi_sae_pwe_method_t = @import("std").mem.zeroes(wifi_sae_pwe_method_t),
    sae_pk_mode: wifi_sae_pk_mode_t = @import("std").mem.zeroes(wifi_sae_pk_mode_t),
    failure_retry_cnt: u8 = 0,

    // HE Capabilities
    // 0      he_dcm_set
    // 1-2    he_dcm_max_constellation_tx (2-bit)
    // 3-4    he_dcm_max_constellation_rx (2-bit)
    // 5      he_mcs9_enabled
    // 6      he_su_beamformee_disabled
    // 7      he_trig_su_bmforming_feedback_disabled
    // 8      he_trig_mu_bmforming_partial_feedback_disabled
    // 9      he_trig_cqi_feedback_disabled
    // 10-31  he_reserved
    he_capabilities: u32 = 0, // Stores HE-related flags (DCM, MCS9, beamforming, CQI, etc.)

    sae_h2e_identifier: [32]u8 = @import("std").mem.zeroes([32]u8),
};
