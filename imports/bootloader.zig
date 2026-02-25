const sys = @import("sys");
const std = @import("std");
const errors = @import("error");

// ---------------------------------------------------------------------------
// Re-export register/device types directly from sys — they are opaque bitfield
// unions that zig translate-c demoted; there is no benefit in redeclaring them.
// ---------------------------------------------------------------------------

pub const EfuseDev = sys.efuse_dev_t;
pub const EfuseBlock = sys.ets_efuse_block_t;
pub const EfusePurpose = sys.ets_efuse_purpose_t;
pub const EtsStatus = sys.ets_status_t;
pub const SecureBootStatus = sys.ets_secure_boot_status_t;
pub const SecureBootSigBlock = sys.ets_secure_boot_sig_block_t;
pub const SecureBootSignature = sys.ets_secure_boot_signature_t;
pub const SecureBootKeyDigests = sys.ets_secure_boot_key_digests_t;
pub const SecureBootSigBlockV1 = sys.esp_secure_boot_sig_block_t;
pub const SecureBootIvDigest = sys.esp_secure_boot_iv_digest_t;
pub const ImageSigPubKeyDigests = sys.esp_image_sig_public_key_digests_t;
pub const RsaPubkey = sys.ets_rsa_pubkey_t;

pub const OtaSelectEntry = sys.esp_ota_select_entry_t;
pub const PartitionPos = sys.esp_partition_pos_t;
pub const PartitionInfo = sys.esp_partition_info_t;
pub const BootloaderState = sys.bootloader_state_t;

pub const ImageHeader = sys.esp_image_header_t; // opaque
pub const ImageSegmentHeader = sys.esp_image_segment_header_t;
pub const ImageMetadata = sys.esp_image_metadata_t;
pub const ImageFlashMapping = sys.esp_image_flash_mapping_t;
pub const RtcRetainMem = sys.rtc_retain_mem_t;

pub const ChipId = sys.esp_chip_id_t;
pub const SpiMode = sys.esp_image_spi_mode_t;
pub const SpiFreq = sys.esp_image_spi_freq_t;
pub const FlashSize = sys.esp_image_flash_size_t;
pub const ImageLoadMode = sys.esp_image_load_mode_t;
pub const ImageType = sys.esp_image_type;
pub const GpioHold = sys.esp_comm_gpio_hold_t;

pub const EtsEvent = sys.ETSEvent;
pub const EtsTask = sys.ETSTask;
pub const EtsTimer = sys.ETSTimer;
pub const EtsTimerFunc = sys.ETSTimerFunc;
pub const EtsIsrFn = sys.ets_isr_t;
pub const EtsIdleCb = sys.ets_idle_cb_t;

// The EFUSE peripheral register bank — memory-mapped, volatile.
pub extern var EFUSE: EfuseDev;

// ---------------------------------------------------------------------------
// Efuse — high-level ESP-IDF API
// ---------------------------------------------------------------------------

pub const Efuse = struct {
    pub fn setTiming(clock: u32) !void {
        if (sys.ets_efuse_set_timing(clock) != 0) return error.EfuseTimingFailed;
    }

    pub fn read() !void {
        if (sys.ets_efuse_read() != 0) return error.EfuseReadFailed;
    }

    pub fn program(block: EfuseBlock) !void {
        if (sys.ets_efuse_program(block) != 0) return error.EfuseProgramFailed;
    }

    pub fn clearProgramRegisters() void {
        sys.ets_efuse_clear_program_registers();
    }

    pub fn writeKey(
        key_block: EfuseBlock,
        purpose: EfusePurpose,
        data: []const u8,
    ) !void {
        if (sys.ets_efuse_write_key(key_block, purpose, data.ptr, data.len) != 0)
            return error.EfuseWriteKeyFailed;
    }

    pub fn getReadRegisterAddress(block: EfuseBlock) u32 {
        return sys.ets_efuse_get_read_register_address(block);
    }

    pub fn getKeyPurpose(block: EfuseBlock) EfusePurpose {
        return sys.ets_efuse_get_key_purpose(block);
    }

    pub fn findPurpose(purpose: EfusePurpose, out_block: *EfuseBlock) bool {
        return sys.ets_efuse_find_purpose(purpose, out_block);
    }

    pub fn keyBlockUnused(block: EfuseBlock) bool {
        return sys.ets_efuse_key_block_unused(block);
    }

    pub fn findUnusedKeyBlock() EfuseBlock {
        return sys.ets_efuse_find_unused_key_block();
    }

    pub fn countUnusedKeyBlocks() c_uint {
        return sys.ets_efuse_count_unused_key_blocks();
    }

    pub fn rsCalculate(data: []const u8, rs_values: []u8) void {
        sys.ets_efuse_rs_calculate(data.ptr, rs_values.ptr);
    }

    pub fn getSpiConfig() u32 {
        return sys.ets_efuse_get_spiconfig();
    }
    pub fn getWpPad() u32 {
        return sys.ets_efuse_get_wp_pad();
    }

    pub fn downloadModesDisabled() bool {
        return sys.ets_efuse_download_modes_disabled();
    }
    pub fn legacySpiBootModeDisabled() bool {
        return sys.ets_efuse_legacy_spi_boot_mode_disabled();
    }
    pub fn getUartPrintControl() u32 {
        return sys.ets_efuse_get_uart_print_control();
    }
    pub fn usbSerialJtagPrintDisabled() u32 {
        return sys.ets_efuse_usb_serial_jtag_print_is_disabled();
    }
    pub fn usbDownloadModeDisabled() bool {
        return sys.ets_efuse_usb_download_mode_disabled();
    }
    pub fn usbModuleDisabled() bool {
        return sys.ets_efuse_usb_module_disabled();
    }
    pub fn securityDownloadModesEnabled() bool {
        return sys.ets_efuse_security_download_modes_enabled();
    }
    pub fn secureBootEnabled() bool {
        return sys.ets_efuse_secure_boot_enabled();
    }
    pub fn secureBootAggressiveRevokeEnabled() bool {
        return sys.ets_efuse_secure_boot_aggressive_revoke_enabled();
    }
    pub fn cacheEncryptionEnabled() bool {
        return sys.ets_efuse_cache_encryption_enabled();
    }
    pub fn flashOpi5padsPowerSelVddspi() bool {
        return sys.ets_efuse_flash_opi_5pads_power_sel_vddspi();
    }
    pub fn forceSendResume() bool {
        return sys.ets_efuse_force_send_resume();
    }
    pub fn getFlashDelayUs() u32 {
        return sys.ets_efuse_get_flash_delay_us();
    }

    pub fn enableJtagTemporarily(hmac_key: []const u8, block: EfuseBlock) !void {
        if (sys.ets_jtag_enable_temporarily(hmac_key.ptr, block) != 0)
            return error.JtagEnableFailed;
    }

    pub fn romMacAddressCrc8(data: []const u8) u8 {
        return sys.esp_rom_efuse_mac_address_crc8(data.ptr, @intCast(data.len));
    }
    pub fn romGetFlashGpioInfo() u32 {
        return sys.esp_rom_efuse_get_flash_gpio_info();
    }
    pub fn romGetFlashWpGpio() u32 {
        return sys.esp_rom_efuse_get_flash_wp_gpio();
    }
    pub fn romIsSecureBootEnabled() bool {
        return sys.esp_rom_efuse_is_secure_boot_enabled();
    }

    /// CRC-8 over arbitrary data (ESP ROM implementation).
    pub fn crc8(data: []const u8) u8 {
        return sys.esp_crc8(data.ptr, @intCast(data.len));
    }
};

// ---------------------------------------------------------------------------
// EFUSE register-level inline accessors (mirror efuse_ll_* from esp-idf).
// These read directly from the memory-mapped EFUSE peripheral.
// ---------------------------------------------------------------------------

pub const EfuseLl = struct {
    pub fn getFlashCryptCnt() u32 {
        return sys.efuse_ll_get_flash_crypt_cnt();
    }
    pub fn getWdtDelaySel() u32 {
        return sys.efuse_ll_get_wdt_delay_sel();
    }
    pub fn getMac0() u32 {
        return sys.efuse_ll_get_mac0();
    }
    pub fn getMac1() u32 {
        return sys.efuse_ll_get_mac1();
    }
    pub fn getSecureBootV2En() bool {
        return sys.efuse_ll_get_secure_boot_v2_en();
    }
    pub fn getErrRstEnable() bool {
        return sys.efuse_ll_get_err_rst_enable();
    }
    pub fn getWaferVersionMajor() u32 {
        return sys.efuse_ll_get_chip_wafer_version_major();
    }
    pub fn getWaferVersionMinor() u32 {
        return sys.efuse_ll_get_chip_wafer_version_minor();
    }
    pub fn getDisableWaferVersionMajor() bool {
        return sys.efuse_ll_get_disable_wafer_version_major();
    }
    pub fn getBlkVersionMajor() u32 {
        return sys.efuse_ll_get_blk_version_major();
    }
    pub fn getBlkVersionMinor() u32 {
        return sys.efuse_ll_get_blk_version_minor();
    }
    pub fn getDisableBlkVersionMajor() bool {
        return sys.efuse_ll_get_disable_blk_version_major();
    }
    pub fn getChipVerPkg() u32 {
        return sys.efuse_ll_get_chip_ver_pkg();
    }
    pub fn getOcode() u32 {
        return sys.efuse_ll_get_ocode();
    }
    pub fn getKRtcLdo() u32 {
        return sys.efuse_ll_get_k_rtc_ldo();
    }
    pub fn getKDigLdo() u32 {
        return sys.efuse_ll_get_k_dig_ldo();
    }
    pub fn getVRtcDbias20() u32 {
        return sys.efuse_ll_get_v_rtc_dbias20();
    }
    pub fn getVDigDbias20() u32 {
        return sys.efuse_ll_get_v_dig_dbias20();
    }
    pub fn getDigDbias_hvt() u32 {
        return sys.efuse_ll_get_dig_dbias_hvt();
    }

    pub fn isReadCmdPending() bool {
        return sys.efuse_ll_get_read_cmd();
    }
    pub fn isPgmCmdPending() bool {
        return sys.efuse_ll_get_pgm_cmd();
    }
    pub fn triggerReadCmd() void {
        sys.efuse_ll_set_read_cmd();
    }
    pub fn triggerPgmCmd(block: u32) void {
        sys.efuse_ll_set_pgm_cmd(block);
    }
    pub fn setConfReadOpCode() void {
        sys.efuse_ll_set_conf_read_op_code();
    }
    pub fn setConfWriteOpCode() void {
        sys.efuse_ll_set_conf_write_op_code();
    }
    pub fn setDacNum(val: u8) void {
        sys.efuse_ll_set_dac_num(val);
    }
    pub fn setDacClkDiv(val: u8) void {
        sys.efuse_ll_set_dac_clk_div(val);
    }
    pub fn setPwrOnNum(val: u16) void {
        sys.efuse_ll_set_pwr_on_num(val);
    }
    pub fn setPwrOffNum(val: u16) void {
        sys.efuse_ll_set_pwr_off_num(val);
    }
};

// ---------------------------------------------------------------------------
// Partition table
// ---------------------------------------------------------------------------

pub const Partition = struct {
    pub fn tableVerify(
        table: [*]const PartitionInfo,
        log_errors: bool,
        num_partitions: *c_int,
    ) !void {
        try errors.espCheckError(sys.esp_partition_table_verify(table, log_errors, num_partitions));
    }

    pub fn isFlashRegionWritable(addr: usize, size: usize) bool {
        return sys.esp_partition_is_flash_region_writable(addr, size);
    }

    pub fn mainFlashRegionSafe(addr: usize, size: usize) bool {
        return sys.esp_partition_main_flash_region_safe(addr, size);
    }
};

// ---------------------------------------------------------------------------
// Image verification / loading
// ---------------------------------------------------------------------------

pub const Image = struct {
    pub fn verify(
        mode: ImageLoadMode,
        part: *const PartitionPos,
        data: ?*ImageMetadata,
    ) !void {
        try errors.espCheckError(sys.esp_image_verify(mode, part, data));
    }

    pub fn getMetadata(part: *const PartitionPos, metadata: *ImageMetadata) !void {
        try errors.espCheckError(sys.esp_image_get_metadata(part, metadata));
    }

    pub fn getFlashSize(app_flash_size: FlashSize) c_int {
        return sys.esp_image_get_flash_size(app_flash_size);
    }

    pub fn verifyBootloader(out_length: *u32) !void {
        try errors.espCheckError(sys.esp_image_verify_bootloader(out_length));
    }

    pub fn verifyBootloaderData(data: *ImageMetadata) !void {
        try errors.espCheckError(sys.esp_image_verify_bootloader_data(data));
    }
};

// ---------------------------------------------------------------------------
// Bootloader
// ---------------------------------------------------------------------------

pub const Bootloader = struct {
    pub fn loadImage(part: *const PartitionPos, data: *ImageMetadata) !void {
        try errors.espCheckError(sys.bootloader_load_image(part, data));
    }

    pub fn loadImageNoVerify(part: *const PartitionPos, data: *ImageMetadata) !void {
        try errors.espCheckError(sys.bootloader_load_image_no_verify(part, data));
    }

    pub fn readOtadata(
        ota_info: *const PartitionPos,
        two_otadata: *[2]OtaSelectEntry,
    ) !void {
        try errors.espCheckError(sys.bootloader_common_read_otadata(ota_info, two_otadata));
    }

    pub fn otaSelectCrc(s: *const OtaSelectEntry) u32 {
        return sys.bootloader_common_ota_select_crc(s);
    }

    pub fn otaSelectValid(s: *const OtaSelectEntry) bool {
        return sys.bootloader_common_ota_select_valid(s);
    }

    pub fn otaSelectInvalid(s: *const OtaSelectEntry) bool {
        return sys.bootloader_common_ota_select_invalid(s);
    }

    pub fn checkLongHoldGpio(pin: u32, delay_sec: u32) GpioHold {
        return sys.bootloader_common_check_long_hold_gpio(pin, delay_sec);
    }

    pub fn checkLongHoldGpioLevel(pin: u32, delay_sec: u32, level: bool) GpioHold {
        return sys.bootloader_common_check_long_hold_gpio_level(pin, delay_sec, level);
    }

    pub fn erasePartTypeData(list_erase: [*:0]const u8, ota_data_erase: bool) bool {
        return sys.bootloader_common_erase_part_type_data(list_erase, ota_data_erase);
    }

    pub fn labelSearch(list: [*:0]const u8, label: [*:0]u8) bool {
        return sys.bootloader_common_label_search(list, label);
    }

    pub fn configureSpiPins(drv: c_int) void {
        sys.bootloader_configure_spi_pins(drv);
    }

    pub fn getSha256OfPartition(
        address: u32,
        size: u32,
        part_type: c_int,
        out_sha_256: *[32]u8,
    ) !void {
        try errors.espCheckError(sys.bootloader_common_get_sha256_of_partition(address, size, part_type, out_sha_256));
    }

    pub fn getActiveOtadata(two_otadata: *[2]OtaSelectEntry) c_int {
        return sys.bootloader_common_get_active_otadata(two_otadata);
    }

    pub fn selectOtadata(
        two_otadata: *const [2]OtaSelectEntry,
        valid_two_otadata: *[2]bool,
        max: bool,
    ) c_int {
        return sys.bootloader_common_select_otadata(two_otadata, valid_two_otadata, max);
    }

    pub fn getChipVerPkg() u32 {
        return sys.bootloader_common_get_chip_ver_pkg();
    }

    pub fn checkChipValidity(img_hdr: *const ImageHeader, kind: ImageType) !void {
        try errors.espCheckError(sys.bootloader_common_check_chip_validity(img_hdr, kind));
    }

    pub fn vddsdioConf() void {
        sys.bootloader_common_vddsdio_configure();
    }

    pub fn randomEnable() void {
        sys.bootloader_random_enable();
    }
    pub fn randomDisable() void {
        sys.bootloader_random_disable();
    }
    pub fn fillRandom(buf: []u8) void {
        sys.bootloader_fill_random(buf.ptr, buf.len);
    }

    pub fn readBootloaderHeader() !void {
        try errors.espCheckError(sys.bootloader_read_bootloader_header());
    }

    pub fn checkBootloaderValidity() !void {
        try errors.espCheckError(sys.bootloader_check_bootloader_validity());
    }

    pub fn clearBssSection() void {
        sys.bootloader_clear_bss_section();
    }
    pub fn configWdt() void {
        sys.bootloader_config_wdt();
    }
    pub fn enableRandom() void {
        sys.bootloader_enable_random();
    }
    pub fn printBanner() void {
        sys.bootloader_print_banner();
    }

    pub fn init() !void {
        try errors.espCheckError(sys.bootloader_init());
    }

    pub fn flashEncrypt(bs: *BootloaderState) bool {
        return sys.flash_encrypt(bs);
    }

    /// True if two flash regions [start1,end1) and [start2,end2) overlap.
    pub fn regionsOverlap(start1: isize, end1: isize, start2: isize, end2: isize) bool {
        return (end1 > start2) and (end2 > start1);
    }
};

// ---------------------------------------------------------------------------
// Secure boot
// ---------------------------------------------------------------------------

pub const SecureBoot = struct {
    pub fn enabled() bool {
        // Reads directly from the efuse secure_boot_v2 bit — no ESP-IDF call needed.
        return EfuseLl.getSecureBootV2En();
    }

    pub fn generateDigest() !void {
        try errors.espCheckError(sys.esp_secure_boot_generate_digest());
    }

    pub fn permanentlyEnable() !void {
        try errors.espCheckError(sys.esp_secure_boot_permanently_enable());
    }

    pub fn v2PermanentlyEnable(image_data: *const ImageMetadata) !void {
        try errors.espCheckError(sys.esp_secure_boot_v2_permanently_enable(image_data));
    }

    pub fn verifySignature(src_addr: u32, length: u32) !void {
        try errors.espCheckError(sys.esp_secure_boot_verify_signature(src_addr, length));
    }

    pub fn verifyEcdsaSignatureBlock(
        sig_block: *const SecureBootSigBlockV1,
        image_digest: [*:0]const u8,
        verified_digest: *u8,
    ) !void {
        try errors.espCheckError(sys.esp_secure_boot_verify_ecdsa_signature_block(sig_block, image_digest, verified_digest));
    }

    pub fn initChecks() void {
        sys.esp_secure_boot_init_checks();
    }

    pub fn enableSecureFeatures() !void {
        try errors.espCheckError(sys.esp_secure_boot_enable_secure_features());
    }

    pub fn cfgVerifyReleaseMode() bool {
        return sys.esp_secure_boot_cfg_verify_release_mode();
    }

    // ROM-level secure boot ---------------------------------------------------

    pub fn romVerifyBootloaderWithKeys(
        verified_hash: *u8,
        trusted_keys: *const SecureBootKeyDigests,
        stage_load: bool,
    ) SecureBootStatus {
        return sys.ets_secure_boot_verify_bootloader_with_keys(verified_hash, trusted_keys, stage_load);
    }

    pub fn romReadKeyDigests(trusted_keys: *SecureBootKeyDigests) EtsStatus {
        return sys.ets_secure_boot_read_key_digests(trusted_keys);
    }

    pub fn romVerifySignature(
        sig: *const SecureBootSignature,
        image_digest: [*:0]const u8,
        trusted_keys: *const SecureBootKeyDigests,
        verified_digest: *u8,
    ) SecureBootStatus {
        return sys.ets_secure_boot_verify_signature(sig, image_digest, trusted_keys, verified_digest);
    }

    pub fn romRevokePublicKeyDigest(index: c_int) void {
        sys.ets_secure_boot_revoke_public_key_digest(index);
    }

    pub fn romRsaPssVerify(
        key: *const RsaPubkey,
        sig: [*:0]const u8,
        digest: [*:0]const u8,
        verified_digest: *u8,
    ) bool {
        return sys.ets_rsa_pss_verify(key, sig, digest, verified_digest);
    }
};

// ---------------------------------------------------------------------------
// ETS (ROM system services)
// ---------------------------------------------------------------------------

pub const Ets = struct {
    pub fn printf(fmt: [*:0]const u8, args: anytype) c_int {
        return @call(.auto, sys.ets_printf, .{fmt} ++ args);
    }

    pub fn delayUs(us: u32) void {
        sys.ets_delay_us(us);
    }
    pub fn getCpuFrequency() u32 {
        return sys.ets_get_cpu_frequency();
    }
    pub fn updateCpuFrequency(ticks_per_us: u32) void {
        sys.ets_update_cpu_frequency(ticks_per_us);
    }
    pub fn getXtalFreq() u32 {
        return sys.ets_get_xtal_freq();
    }
    pub fn getXtalDiv() u32 {
        return sys.ets_get_xtal_div();
    }
    pub fn getApbFreq() u32 {
        return sys.ets_get_apb_freq();
    }

    pub fn isrAttach(irq: c_int, func: EtsIsrFn, arg: ?*anyopaque) void {
        sys.ets_isr_attach(irq, func, arg);
    }
    pub fn isrMask(mask: u32) void {
        sys.ets_isr_mask(mask);
    }
    pub fn isrUnmask(mask: u32) void {
        sys.ets_isr_unmask(mask);
    }
    pub fn intrLock() void {
        sys.ets_intr_lock();
    }
    pub fn intrUnlock() void {
        sys.ets_intr_unlock();
    }

    pub fn setUserStart(start: u32) void {
        sys.ets_set_user_start(start);
    }
    pub fn installPutc1(p: ?*const fn (u8) callconv(.c) void) void {
        sys.ets_install_putc1(p);
    }
    pub fn installPutc2(p: ?*const fn (u8) callconv(.c) void) void {
        sys.ets_install_putc2(p);
    }
    pub fn installUartPrintf() void {
        sys.ets_install_uart_printf();
    }

    pub fn intr_matrix_set(cpu_no: c_int, model_num: u32, intr_num: u32) void {
        sys.intr_matrix_set(cpu_no, model_num, intr_num);
    }
};

// ---------------------------------------------------------------------------
// ETS Timer
// ---------------------------------------------------------------------------

pub const EtsTimerApi = struct {
    pub fn init() void {
        sys.ets_timer_init();
    }
    pub fn deinit() void {
        sys.ets_timer_deinit();
    }

    pub fn arm(timer: *EtsTimer, timeout_ms: u32, repeat: bool) void {
        sys.ets_timer_arm(timer, timeout_ms, repeat);
    }
    pub fn armUs(timer: *EtsTimer, us: u32, repeat: bool) void {
        sys.ets_timer_arm_us(timer, us, repeat);
    }
    pub fn disarm(timer: *EtsTimer) void {
        sys.ets_timer_disarm(timer);
    }
    pub fn setFn(timer: *EtsTimer, func: ?*const EtsTimerFunc, arg: ?*anyopaque) void {
        sys.ets_timer_setfn(timer, func, arg);
    }
    pub fn done(timer: *EtsTimer) void {
        sys.ets_timer_done(timer);
    }
};
