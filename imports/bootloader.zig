const sys = @import("sys");
const std = @import("std");

pub const efuse_dev_t = extern struct {
    pgm_data0: efuse_pgm_data0_reg_t = std.mem.zeroes(sys.efuse_pgm_data0_reg_t),
    pgm_data1: efuse_pgm_data1_reg_t = std.mem.zeroes(sys.efuse_pgm_data1_reg_t),
    pgm_data2: efuse_pgm_data2_reg_t = std.mem.zeroes(sys.efuse_pgm_data2_reg_t),
    pgm_data3: efuse_pgm_data3_reg_t = std.mem.zeroes(sys.efuse_pgm_data3_reg_t),
    pgm_data4: efuse_pgm_data4_reg_t = std.mem.zeroes(sys.efuse_pgm_data4_reg_t),
    pgm_data5: efuse_pgm_data5_reg_t = std.mem.zeroes(sys.efuse_pgm_data5_reg_t),
    pgm_data6: efuse_pgm_data6_reg_t = std.mem.zeroes(sys.efuse_pgm_data6_reg_t),
    pgm_data7: efuse_pgm_data7_reg_t = std.mem.zeroes(sys.efuse_pgm_data7_reg_t),
    pgm_check_value0: efuse_pgm_check_value0_reg_t = std.mem.zeroes(sys.efuse_pgm_check_value0_reg_t),
    pgm_check_value1: efuse_pgm_check_value1_reg_t = std.mem.zeroes(sys.efuse_pgm_check_value1_reg_t),
    pgm_check_value2: efuse_pgm_check_value2_reg_t = std.mem.zeroes(sys.efuse_pgm_check_value2_reg_t),
    rd_wr_dis: efuse_rd_wr_dis_reg_t = std.mem.zeroes(sys.efuse_rd_wr_dis_reg_t),
    rd_repeat_data0: efuse_rd_repeat_data0_reg_t = std.mem.zeroes(sys.efuse_rd_repeat_data0_reg_t),
    rd_repeat_data1: efuse_rd_repeat_data1_reg_t = std.mem.zeroes(sys.efuse_rd_repeat_data1_reg_t),
    rd_repeat_data2: efuse_rd_repeat_data2_reg_t = std.mem.zeroes(sys.efuse_rd_repeat_data2_reg_t),
    rd_repeat_data3: efuse_rd_repeat_data3_reg_t = std.mem.zeroes(sys.efuse_rd_repeat_data3_reg_t),
    rd_repeat_data4: efuse_rd_repeat_data4_reg_t = std.mem.zeroes(sys.efuse_rd_repeat_data4_reg_t),
    rd_mac_spi_sys_0: efuse_rd_mac_spi_sys_0_reg_t = std.mem.zeroes(sys.efuse_rd_mac_spi_sys_0_reg_t),
    rd_mac_spi_sys_1: efuse_rd_mac_spi_sys_1_reg_t = std.mem.zeroes(sys.efuse_rd_mac_spi_sys_1_reg_t),
    rd_mac_spi_sys_2: efuse_rd_mac_spi_sys_2_reg_t = std.mem.zeroes(sys.efuse_rd_mac_spi_sys_2_reg_t),
    rd_mac_spi_sys_3: efuse_rd_mac_spi_sys_3_reg_t = std.mem.zeroes(sys.efuse_rd_mac_spi_sys_3_reg_t),
    rd_mac_spi_sys_4: efuse_rd_mac_spi_sys_4_reg_t = std.mem.zeroes(sys.efuse_rd_mac_spi_sys_4_reg_t),
    rd_mac_spi_sys_5: efuse_rd_mac_spi_sys_5_reg_t = std.mem.zeroes(sys.efuse_rd_mac_spi_sys_5_reg_t),
    rd_sys_part1_data0: efuse_rd_sys_part1_data0_reg_t = std.mem.zeroes(sys.efuse_rd_sys_part1_data0_reg_t),
    rd_sys_part1_data1: efuse_rd_sys_part1_data1_reg_t = std.mem.zeroes(sys.efuse_rd_sys_part1_data1_reg_t),
    rd_sys_part1_data2: efuse_rd_sys_part1_data2_reg_t = std.mem.zeroes(sys.efuse_rd_sys_part1_data2_reg_t),
    rd_sys_part1_data3: efuse_rd_sys_part1_data3_reg_t = std.mem.zeroes(sys.efuse_rd_sys_part1_data3_reg_t),
    rd_sys_part1_data4: efuse_rd_sys_part1_data4_reg_t = std.mem.zeroes(sys.efuse_rd_sys_part1_data4_reg_t),
    rd_sys_part1_data5: efuse_rd_sys_part1_data5_reg_t = std.mem.zeroes(sys.efuse_rd_sys_part1_data5_reg_t),
    rd_sys_part1_data6: efuse_rd_sys_part1_data6_reg_t = std.mem.zeroes(sys.efuse_rd_sys_part1_data6_reg_t),
    rd_sys_part1_data7: efuse_rd_sys_part1_data7_reg_t = std.mem.zeroes(sys.efuse_rd_sys_part1_data7_reg_t),
    rd_usr_data0: efuse_rd_usr_data0_reg_t = std.mem.zeroes(sys.efuse_rd_usr_data0_reg_t),
    rd_usr_data1: efuse_rd_usr_data1_reg_t = std.mem.zeroes(sys.efuse_rd_usr_data1_reg_t),
    rd_usr_data2: efuse_rd_usr_data2_reg_t = std.mem.zeroes(sys.efuse_rd_usr_data2_reg_t),
    rd_usr_data3: efuse_rd_usr_data3_reg_t = std.mem.zeroes(sys.efuse_rd_usr_data3_reg_t),
    rd_usr_data4: efuse_rd_usr_data4_reg_t = std.mem.zeroes(sys.efuse_rd_usr_data4_reg_t),
    rd_usr_data5: efuse_rd_usr_data5_reg_t = std.mem.zeroes(sys.efuse_rd_usr_data5_reg_t),
    rd_usr_data6: efuse_rd_usr_data6_reg_t = std.mem.zeroes(sys.efuse_rd_usr_data6_reg_t),
    rd_usr_data7: efuse_rd_usr_data7_reg_t = std.mem.zeroes(sys.efuse_rd_usr_data7_reg_t),
    rd_key0_data0: efuse_rd_key0_data0_reg_t = std.mem.zeroes(sys.efuse_rd_key0_data0_reg_t),
    rd_key0_data1: efuse_rd_key0_data1_reg_t = std.mem.zeroes(sys.efuse_rd_key0_data1_reg_t),
    rd_key0_data2: efuse_rd_key0_data2_reg_t = std.mem.zeroes(sys.efuse_rd_key0_data2_reg_t),
    rd_key0_data3: efuse_rd_key0_data3_reg_t = std.mem.zeroes(sys.efuse_rd_key0_data3_reg_t),
    rd_key0_data4: efuse_rd_key0_data4_reg_t = std.mem.zeroes(sys.efuse_rd_key0_data4_reg_t),
    rd_key0_data5: efuse_rd_key0_data5_reg_t = std.mem.zeroes(sys.efuse_rd_key0_data5_reg_t),
    rd_key0_data6: efuse_rd_key0_data6_reg_t = std.mem.zeroes(sys.efuse_rd_key0_data6_reg_t),
    rd_key0_data7: efuse_rd_key0_data7_reg_t = std.mem.zeroes(sys.efuse_rd_key0_data7_reg_t),
    rd_key1_data0: efuse_rd_key1_data0_reg_t = std.mem.zeroes(sys.efuse_rd_key1_data0_reg_t),
    rd_key1_data1: efuse_rd_key1_data1_reg_t = std.mem.zeroes(sys.efuse_rd_key1_data1_reg_t),
    rd_key1_data2: efuse_rd_key1_data2_reg_t = std.mem.zeroes(sys.efuse_rd_key1_data2_reg_t),
    rd_key1_data3: efuse_rd_key1_data3_reg_t = std.mem.zeroes(sys.efuse_rd_key1_data3_reg_t),
    rd_key1_data4: efuse_rd_key1_data4_reg_t = std.mem.zeroes(sys.efuse_rd_key1_data4_reg_t),
    rd_key1_data5: efuse_rd_key1_data5_reg_t = std.mem.zeroes(sys.efuse_rd_key1_data5_reg_t),
    rd_key1_data6: efuse_rd_key1_data6_reg_t = std.mem.zeroes(sys.efuse_rd_key1_data6_reg_t),
    rd_key1_data7: efuse_rd_key1_data7_reg_t = std.mem.zeroes(sys.efuse_rd_key1_data7_reg_t),
    rd_key2_data0: efuse_rd_key2_data0_reg_t = std.mem.zeroes(sys.efuse_rd_key2_data0_reg_t),
    rd_key2_data1: efuse_rd_key2_data1_reg_t = std.mem.zeroes(sys.efuse_rd_key2_data1_reg_t),
    rd_key2_data2: efuse_rd_key2_data2_reg_t = std.mem.zeroes(sys.efuse_rd_key2_data2_reg_t),
    rd_key2_data3: efuse_rd_key2_data3_reg_t = std.mem.zeroes(sys.efuse_rd_key2_data3_reg_t),
    rd_key2_data4: efuse_rd_key2_data4_reg_t = std.mem.zeroes(sys.efuse_rd_key2_data4_reg_t),
    rd_key2_data5: efuse_rd_key2_data5_reg_t = std.mem.zeroes(sys.efuse_rd_key2_data5_reg_t),
    rd_key2_data6: efuse_rd_key2_data6_reg_t = std.mem.zeroes(sys.efuse_rd_key2_data6_reg_t),
    rd_key2_data7: efuse_rd_key2_data7_reg_t = std.mem.zeroes(sys.efuse_rd_key2_data7_reg_t),
    rd_key3_data0: efuse_rd_key3_data0_reg_t = std.mem.zeroes(sys.efuse_rd_key3_data0_reg_t),
    rd_key3_data1: efuse_rd_key3_data1_reg_t = std.mem.zeroes(sys.efuse_rd_key3_data1_reg_t),
    rd_key3_data2: efuse_rd_key3_data2_reg_t = std.mem.zeroes(sys.efuse_rd_key3_data2_reg_t),
    rd_key3_data3: efuse_rd_key3_data3_reg_t = std.mem.zeroes(sys.efuse_rd_key3_data3_reg_t),
    rd_key3_data4: efuse_rd_key3_data4_reg_t = std.mem.zeroes(sys.efuse_rd_key3_data4_reg_t),
    rd_key3_data5: efuse_rd_key3_data5_reg_t = std.mem.zeroes(sys.efuse_rd_key3_data5_reg_t),
    rd_key3_data6: efuse_rd_key3_data6_reg_t = std.mem.zeroes(sys.efuse_rd_key3_data6_reg_t),
    rd_key3_data7: efuse_rd_key3_data7_reg_t = std.mem.zeroes(sys.efuse_rd_key3_data7_reg_t),
    rd_key4_data0: efuse_rd_key4_data0_reg_t = std.mem.zeroes(sys.efuse_rd_key4_data0_reg_t),
    rd_key4_data1: efuse_rd_key4_data1_reg_t = std.mem.zeroes(sys.efuse_rd_key4_data1_reg_t),
    rd_key4_data2: efuse_rd_key4_data2_reg_t = std.mem.zeroes(sys.efuse_rd_key4_data2_reg_t),
    rd_key4_data3: efuse_rd_key4_data3_reg_t = std.mem.zeroes(sys.efuse_rd_key4_data3_reg_t),
    rd_key4_data4: efuse_rd_key4_data4_reg_t = std.mem.zeroes(sys.efuse_rd_key4_data4_reg_t),
    rd_key4_data5: efuse_rd_key4_data5_reg_t = std.mem.zeroes(sys.efuse_rd_key4_data5_reg_t),
    rd_key4_data6: efuse_rd_key4_data6_reg_t = std.mem.zeroes(sys.efuse_rd_key4_data6_reg_t),
    rd_key4_data7: efuse_rd_key4_data7_reg_t = std.mem.zeroes(sys.efuse_rd_key4_data7_reg_t),
    rd_key5_data0: efuse_rd_key5_data0_reg_t = std.mem.zeroes(sys.efuse_rd_key5_data0_reg_t),
    rd_key5_data1: efuse_rd_key5_data1_reg_t = std.mem.zeroes(sys.efuse_rd_key5_data1_reg_t),
    rd_key5_data2: efuse_rd_key5_data2_reg_t = std.mem.zeroes(sys.efuse_rd_key5_data2_reg_t),
    rd_key5_data3: efuse_rd_key5_data3_reg_t = std.mem.zeroes(sys.efuse_rd_key5_data3_reg_t),
    rd_key5_data4: efuse_rd_key5_data4_reg_t = std.mem.zeroes(sys.efuse_rd_key5_data4_reg_t),
    rd_key5_data5: efuse_rd_key5_data5_reg_t = std.mem.zeroes(sys.efuse_rd_key5_data5_reg_t),
    rd_key5_data6: efuse_rd_key5_data6_reg_t = std.mem.zeroes(sys.efuse_rd_key5_data6_reg_t),
    rd_key5_data7: efuse_rd_key5_data7_reg_t = std.mem.zeroes(sys.efuse_rd_key5_data7_reg_t),
    rd_sys_part2_data0: efuse_rd_sys_part2_data0_reg_t = std.mem.zeroes(sys.efuse_rd_sys_part2_data0_reg_t),
    rd_sys_part2_data1: efuse_rd_sys_part2_data1_reg_t = std.mem.zeroes(sys.efuse_rd_sys_part2_data1_reg_t),
    rd_sys_part2_data2: efuse_rd_sys_part2_data2_reg_t = std.mem.zeroes(sys.efuse_rd_sys_part2_data2_reg_t),
    rd_sys_part2_data3: efuse_rd_sys_part2_data3_reg_t = std.mem.zeroes(sys.efuse_rd_sys_part2_data3_reg_t),
    rd_sys_part2_data4: efuse_rd_sys_part2_data4_reg_t = std.mem.zeroes(sys.efuse_rd_sys_part2_data4_reg_t),
    rd_sys_part2_data5: efuse_rd_sys_part2_data5_reg_t = std.mem.zeroes(sys.efuse_rd_sys_part2_data5_reg_t),
    rd_sys_part2_data6: efuse_rd_sys_part2_data6_reg_t = std.mem.zeroes(sys.efuse_rd_sys_part2_data6_reg_t),
    rd_sys_part2_data7: efuse_rd_sys_part2_data7_reg_t = std.mem.zeroes(sys.efuse_rd_sys_part2_data7_reg_t),
    rd_repeat_err0: efuse_rd_repeat_err0_reg_t = std.mem.zeroes(sys.efuse_rd_repeat_err0_reg_t),
    rd_repeat_err1: efuse_rd_repeat_err1_reg_t = std.mem.zeroes(sys.efuse_rd_repeat_err1_reg_t),
    rd_repeat_err2: efuse_rd_repeat_err2_reg_t = std.mem.zeroes(sys.efuse_rd_repeat_err2_reg_t),
    rd_repeat_err3: efuse_rd_repeat_err3_reg_t = std.mem.zeroes(sys.efuse_rd_repeat_err3_reg_t),
    reserved_18c: u32 = std.mem.zeroes(u32),
    rd_repeat_err4: efuse_rd_repeat_err4_reg_t = std.mem.zeroes(sys.efuse_rd_repeat_err4_reg_t),
    reserved_194: [11]u32 = std.mem.zeroes([11]u32),
    rd_rs_err0: efuse_rd_rs_err0_reg_t = std.mem.zeroes(sys.efuse_rd_rs_err0_reg_t),
    rd_rs_err1: efuse_rd_rs_err1_reg_t = std.mem.zeroes(sys.efuse_rd_rs_err1_reg_t),
    clk: efuse_clk_reg_t = std.mem.zeroes(sys.efuse_clk_reg_t),
    conf: efuse_conf_reg_t = std.mem.zeroes(sys.efuse_conf_reg_t),
    status: efuse_status_reg_t = std.mem.zeroes(sys.efuse_status_reg_t),
    cmd: efuse_cmd_reg_t = std.mem.zeroes(sys.efuse_cmd_reg_t),
    int_raw: efuse_int_raw_reg_t = std.mem.zeroes(sys.efuse_int_raw_reg_t),
    int_st: efuse_int_st_reg_t = std.mem.zeroes(sys.efuse_int_st_reg_t),
    int_ena: efuse_int_ena_reg_t = std.mem.zeroes(sys.efuse_int_ena_reg_t),
    int_clr: efuse_int_clr_reg_t = std.mem.zeroes(sys.efuse_int_clr_reg_t),
    dac_conf: efuse_dac_conf_reg_t = std.mem.zeroes(sys.efuse_dac_conf_reg_t),
    rd_tim_conf: efuse_rd_tim_conf_reg_t = std.mem.zeroes(sys.efuse_rd_tim_conf_reg_t),
    wr_tim_conf1: efuse_wr_tim_conf1_reg_t = std.mem.zeroes(sys.efuse_wr_tim_conf1_reg_t),
    wr_tim_conf2: efuse_wr_tim_conf2_reg_t = std.mem.zeroes(sys.efuse_wr_tim_conf2_reg_t),
    reserved_1f8: u32 = std.mem.zeroes(sys.reserved_1f8),
    date: efuse_date_reg_t = std.mem.zeroes(sys.efuse_date_reg_t),
};
pub extern var EFUSE: efuse_dev_t;

pub const esp_ota_select_entry_t = extern struct {
    ota_seq: u32 = std.mem.zeroes(u32),
    seq_label: [20]u8 = std.mem.zeroes([20]u8),
    ota_state: u32 = std.mem.zeroes(u32),
    crc: u32 = std.mem.zeroes(u32),
};
pub const esp_partition_pos_t = extern struct {
    offset: u32 = std.mem.zeroes(u32),
    size: u32 = std.mem.zeroes(u32),
};
pub const esp_partition_info_t = extern struct {
    magic: u16 = std.mem.zeroes(u16),
    type: u8 = std.mem.zeroes(u8),
    subtype: u8 = std.mem.zeroes(u8),
    pos: esp_partition_pos_t = std.mem.zeroes(sys.esp_partition_pos_t),
    label: [16]u8 = std.mem.zeroes([16]u8),
    flags: u32 = std.mem.zeroes(u32),
};
pub extern fn esp_partition_table_verify(partition_table: [*c]const esp_partition_info_t, log_errors: bool, num_partitions: [*c]c_int) sys.esp_err_t;
pub extern fn esp_partition_is_flash_region_writable(addr: usize, size: usize) bool;
pub extern fn esp_partition_main_flash_region_safe(addr: usize, size: usize) bool;

pub const esp_chip_id_t = enum(c_ushort) {
    ESP_CHIP_ID_ESP32 = 0,
    ESP_CHIP_ID_ESP32S2 = 2,
    ESP_CHIP_ID_ESP32C3 = 5,
    ESP_CHIP_ID_ESP32S3 = 9,
    ESP_CHIP_ID_ESP32C2 = 12,
    ESP_CHIP_ID_ESP32C6 = 13,
    ESP_CHIP_ID_ESP32H2 = 16,
    ESP_CHIP_ID_ESP32P4 = 18,
    ESP_CHIP_ID_INVALID = 65535,
};
pub const esp_image_spi_mode_t = enum(c_uint) {
    ESP_IMAGE_SPI_MODE_QIO = 0,
    ESP_IMAGE_SPI_MODE_QOUT = 1,
    ESP_IMAGE_SPI_MODE_DIO = 2,
    ESP_IMAGE_SPI_MODE_DOUT = 3,
    ESP_IMAGE_SPI_MODE_FAST_READ = 4,
    ESP_IMAGE_SPI_MODE_SLOW_READ = 5,
};
pub const esp_image_spi_freq_t = enum(c_uint) {
    ESP_IMAGE_SPI_SPEED_DIV_2 = 0,
    ESP_IMAGE_SPI_SPEED_DIV_3 = 1,
    ESP_IMAGE_SPI_SPEED_DIV_4 = 2,
    ESP_IMAGE_SPI_SPEED_DIV_1 = 15,
};
pub const esp_image_flash_size_t = enum(c_uint) {
    ESP_IMAGE_FLASH_SIZE_1MB = 0,
    ESP_IMAGE_FLASH_SIZE_2MB = 1,
    ESP_IMAGE_FLASH_SIZE_4MB = 2,
    ESP_IMAGE_FLASH_SIZE_8MB = 3,
    ESP_IMAGE_FLASH_SIZE_16MB = 4,
    ESP_IMAGE_FLASH_SIZE_32MB = 5,
    ESP_IMAGE_FLASH_SIZE_64MB = 6,
    ESP_IMAGE_FLASH_SIZE_128MB = 7,
    ESP_IMAGE_FLASH_SIZE_MAX = 8,
};

// /esp-idf/components/bootloader_support/include/esp_app_format.h:85:13: warning: struct demoted to opaque type - has bitfield
pub const esp_image_header_t = opaque {};
// /.espressif/tools/riscv32-esp-elf/esp-13.2.0_20230928/riscv32-esp-elf/riscv32-esp-elf/sys-include/assert.h:45:24: warning: ignoring StaticAssert declaration
pub const esp_image_segment_header_t = extern struct {
    load_addr: u32 = std.mem.zeroes(u32),
    data_len: u32 = std.mem.zeroes(u32),
};
pub const esp_image_metadata_t = extern struct {
    start_addr: u32 = std.mem.zeroes(u32),
    image: esp_image_header_t = std.mem.zeroes(sys.esp_image_header_t),
    segments: [16]esp_image_segment_header_t = std.mem.zeroes([16]esp_image_segment_header_t),
    segment_data: [16]u32 = std.mem.zeroes([16]u32),
    image_len: u32 = std.mem.zeroes(u32),
    image_digest: [32]u8 = std.mem.zeroes([32]u8),
    secure_version: u32 = std.mem.zeroes(u32),
};
pub const esp_image_load_mode_t = enum(c_uint) {
    ESP_IMAGE_VERIFY = 0,
    ESP_IMAGE_VERIFY_SILENT = 1,
};
// /esp-idf/components/bootloader_support/include/esp_image_format.h:53:21: warning: struct demoted to opaque type - has bitfield
const unnamed_3 = opaque {};
const union_unnamed_2 = extern union {
    unnamed_0: unnamed_3,
    val: u8,
};
pub const rtc_retain_mem_t = extern struct {
    partition: esp_partition_pos_t = std.mem.zeroes(sys.esp_partition_pos_t),
    reboot_counter: u16 = std.mem.zeroes(u16),
    flags: union_unnamed_2 = std.mem.zeroes(union_unnamed_2),
    reserve: u8 = std.mem.zeroes(u8),
    crc: u32 = std.mem.zeroes(u32),
};
// /.espressif/tools/riscv32-esp-elf/esp-13.2.0_20230928/riscv32-esp-elf/riscv32-esp-elf/sys-include/assert.h:45:24: warning: ignoring StaticAssert declaration
pub extern fn esp_image_verify(mode: esp_image_load_mode_t, part: [*c]const esp_partition_pos_t, data: ?*esp_image_metadata_t) sys.esp_err_t;
pub extern fn esp_image_get_metadata(part: [*c]const esp_partition_pos_t, metadata: ?*esp_image_metadata_t) sys.esp_err_t;
pub extern fn bootloader_load_image(part: [*c]const esp_partition_pos_t, data: ?*esp_image_metadata_t) sys.esp_err_t;
pub extern fn bootloader_load_image_no_verify(part: [*c]const esp_partition_pos_t, data: ?*esp_image_metadata_t) sys.esp_err_t;
pub extern fn esp_image_verify_bootloader(length: [*c]u32) sys.esp_err_t;
pub extern fn esp_image_verify_bootloader_data(data: ?*esp_image_metadata_t) sys.esp_err_t;
pub extern fn esp_image_get_flash_size(app_flash_size: esp_image_flash_size_t) c_int;
pub const esp_image_flash_mapping_t = extern struct {
    drom_addr: u32 = std.mem.zeroes(u32),
    drom_load_addr: u32 = std.mem.zeroes(u32),
    drom_size: u32 = std.mem.zeroes(u32),
    irom_addr: u32 = std.mem.zeroes(u32),
    irom_load_addr: u32 = std.mem.zeroes(u32),
    irom_size: u32 = std.mem.zeroes(u32),
};
pub const esp_comm_gpio_hold_t = enum(c_int) {
    GPIO_LONG_HOLD = 1,
    GPIO_SHORT_HOLD = -1,
    GPIO_NOT_HOLD = 0,
};
pub const esp_image_type = enum(c_uint) {
    ESP_IMAGE_BOOTLOADER = 0,
    ESP_IMAGE_APPLICATION = 1,
};
pub extern fn bootloader_common_read_otadata(ota_info: [*c]const esp_partition_pos_t, two_otadata: [*c]esp_ota_select_entry_t) sys.esp_err_t;
pub extern fn bootloader_common_ota_select_crc(s: [*c]const esp_ota_select_entry_t) u32;
pub extern fn bootloader_common_ota_select_valid(s: [*c]const esp_ota_select_entry_t) bool;
pub extern fn bootloader_common_ota_select_invalid(s: [*c]const esp_ota_select_entry_t) bool;
pub extern fn bootloader_common_check_long_hold_gpio(num_pin: u32, delay_sec: u32) esp_comm_gpio_hold_t;
pub extern fn bootloader_common_check_long_hold_gpio_level(num_pin: u32, delay_sec: u32, level: bool) esp_comm_gpio_hold_t;
pub extern fn bootloader_common_erase_part_type_data(list_erase: [*:0]const u8, ota_data_erase: bool) bool;
pub extern fn bootloader_common_label_search(list: [*:0]const u8, label: [*c]u8) bool;
pub extern fn bootloader_configure_spi_pins(drv: c_int) void;
pub extern fn bootloader_common_get_sha256_of_partition(address: u32, size: u32, @"type": c_int, out_sha_256: [*c]u8) sys.esp_err_t;
pub extern fn bootloader_common_get_active_otadata(two_otadata: [*c]esp_ota_select_entry_t) c_int;
pub extern fn bootloader_common_select_otadata(two_otadata: [*c]const esp_ota_select_entry_t, valid_two_otadata: [*c]bool, max: bool) c_int;
pub extern fn bootloader_common_get_chip_ver_pkg() u32;
pub extern fn bootloader_common_check_chip_validity(img_hdr: ?*const esp_image_header_t, @"type": esp_image_type) sys.esp_err_t;
pub extern fn bootloader_common_vddsdio_configure() void;
pub fn bootloader_util_regions_overlap(start1: isize, end1: isize, start2: isize, end2: isize) callconv(.C) bool {
    return (end1 > start2) and (end2 > start1);
}
pub extern fn bootloader_random_enable() void;
pub extern fn bootloader_random_disable() void;
pub extern fn bootloader_fill_random(buffer: ?*anyopaque, length: usize) void;
pub extern fn esp_rom_efuse_mac_address_crc8(data: [*:0]const u8, len: u32) u8;
pub extern fn esp_rom_efuse_get_flash_gpio_info() u32;
pub extern fn esp_rom_efuse_get_flash_wp_gpio() u32;
pub extern fn esp_rom_efuse_is_secure_boot_enabled() bool;
pub const ets_efuse_purpose_t = enum(c_uint) {
    ETS_EFUSE_KEY_PURPOSE_USER = 0,
    ETS_EFUSE_KEY_PURPOSE_RESERVED = 1,
    ETS_EFUSE_KEY_PURPOSE_XTS_AES_128_KEY = 4,
    ETS_EFUSE_KEY_PURPOSE_HMAC_DOWN_ALL = 5,
    ETS_EFUSE_KEY_PURPOSE_HMAC_DOWN_JTAG = 6,
    ETS_EFUSE_KEY_PURPOSE_HMAC_DOWN_DIGITAL_SIGNATURE = 7,
    ETS_EFUSE_KEY_PURPOSE_HMAC_UP = 8,
    ETS_EFUSE_KEY_PURPOSE_SECURE_BOOT_DIGEST0 = 9,
    ETS_EFUSE_KEY_PURPOSE_SECURE_BOOT_DIGEST1 = 10,
    ETS_EFUSE_KEY_PURPOSE_SECURE_BOOT_DIGEST2 = 11,
    ETS_EFUSE_KEY_PURPOSE_MAX = 12,
};
pub const ets_efuse_block_t = enum(c_uint) {
    ETS_EFUSE_BLOCK0 = 0,
    ETS_EFUSE_MAC_SPI_SYS_0 = 1,
    ETS_EFUSE_BLOCK_SYS_DATA = 2,
    ETS_EFUSE_BLOCK_USR_DATA = 3,
    ETS_EFUSE_BLOCK_KEY0 = 4,
    ETS_EFUSE_BLOCK_KEY1 = 5,
    ETS_EFUSE_BLOCK_KEY2 = 6,
    ETS_EFUSE_BLOCK_KEY3 = 7,
    ETS_EFUSE_BLOCK_KEY4 = 8,
    ETS_EFUSE_BLOCK_KEY5 = 9,
    ETS_EFUSE_BLOCK_KEY6 = 10,
    ETS_EFUSE_BLOCK_MAX = 11,
};
pub extern fn ets_efuse_set_timing(clock: u32) c_int;
pub extern fn ets_efuse_read() c_int;
pub extern fn ets_efuse_program(block: ets_efuse_block_t) c_int;
pub extern fn ets_efuse_clear_program_registers() void;
pub extern fn ets_efuse_write_key(key_block: ets_efuse_block_t, purpose: ets_efuse_purpose_t, data: ?*const anyopaque, data_len: usize) c_int;
pub extern fn ets_efuse_get_read_register_address(block: ets_efuse_block_t) u32;
pub extern fn ets_efuse_get_key_purpose(key_block: ets_efuse_block_t) ets_efuse_purpose_t;
pub extern fn ets_efuse_find_purpose(purpose: ets_efuse_purpose_t, key_block: [*c]ets_efuse_block_t) bool;
pub extern fn ets_efuse_key_block_unused(key_block: ets_efuse_block_t) bool;
pub extern fn ets_efuse_find_unused_key_block() ets_efuse_block_t;
pub extern fn ets_efuse_count_unused_key_blocks() c_uint;
pub extern fn ets_efuse_rs_calculate(data: ?*const anyopaque, rs_values: ?*anyopaque) void;
pub extern fn ets_efuse_get_spiconfig() u32;
pub extern fn ets_efuse_get_wp_pad() u32;
pub extern fn ets_efuse_download_modes_disabled() bool;
pub extern fn ets_efuse_legacy_spi_boot_mode_disabled() bool;
pub extern fn ets_efuse_get_uart_print_control() u32;
pub extern fn ets_efuse_usb_serial_jtag_print_is_disabled() u32;
pub extern fn ets_efuse_usb_download_mode_disabled() bool;
pub extern fn ets_efuse_usb_module_disabled() bool;
pub extern fn ets_efuse_security_download_modes_enabled() bool;
pub extern fn ets_efuse_secure_boot_enabled() bool;
pub extern fn ets_efuse_secure_boot_aggressive_revoke_enabled() bool;
pub extern fn ets_efuse_cache_encryption_enabled() bool;
pub extern fn ets_efuse_flash_opi_5pads_power_sel_vddspi() bool;
pub extern fn ets_efuse_force_send_resume() bool;
pub extern fn ets_efuse_get_flash_delay_us() u32;
pub extern fn ets_jtag_enable_temporarily(jtag_hmac_key: [*:0]const u8, key_block: ets_efuse_block_t) c_int;
pub extern fn esp_crc8(p: [*:0]const u8, len: c_uint) u8;
pub inline fn efuse_ll_get_flash_crypt_cnt() u32 {
    return EFUSE.rd_repeat_data1.unnamed_0.spi_boot_crypt_cnt;
}
pub inline fn efuse_ll_get_wdt_delay_sel() u32 {
    return EFUSE.rd_repeat_data1.unnamed_0.wdt_delay_sel;
}
pub inline fn efuse_ll_get_mac0() u32 {
    return EFUSE.rd_mac_spi_sys_0.unnamed_0.mac_0;
}
pub inline fn efuse_ll_get_mac1() u32 {
    return EFUSE.rd_mac_spi_sys_1.unnamed_0.mac_1;
}
pub inline fn efuse_ll_get_secure_boot_v2_en() bool {
    return EFUSE.rd_repeat_data2.unnamed_0.secure_boot_en != 0;
}
pub inline fn efuse_ll_get_err_rst_enable() bool {
    return EFUSE.rd_repeat_data3.unnamed_0.err_rst_enable != 0;
}
pub inline fn efuse_ll_get_chip_wafer_version_major() u32 {
    return EFUSE.rd_mac_spi_sys_5.unnamed_0.wafer_version_major;
}
pub inline fn efuse_ll_get_chip_wafer_version_minor() u32 {
    return @as(u32, @bitCast((@as(c_int, @bitCast(EFUSE.rd_mac_spi_sys_5.unnamed_0.wafer_version_minor_hi)) << @intCast(3)) + @as(c_int, @bitCast(EFUSE.rd_mac_spi_sys_3.unnamed_0.wafer_version_minor_lo))));
}
pub inline fn efuse_ll_get_disable_wafer_version_major() bool {
    return EFUSE.rd_repeat_data4.unnamed_0.disable_wafer_version_major != 0;
}
pub inline fn efuse_ll_get_blk_version_major() u32 {
    return EFUSE.rd_sys_part1_data4.unnamed_0.blk_version_major;
}
pub inline fn efuse_ll_get_blk_version_minor() u32 {
    return EFUSE.rd_mac_spi_sys_3.unnamed_0.blk_version_minor;
}
pub inline fn efuse_ll_get_disable_blk_version_major() bool {
    return EFUSE.rd_repeat_data4.unnamed_0.disable_blk_version_major != 0;
}
pub inline fn efuse_ll_get_chip_ver_pkg() u32 {
    return EFUSE.rd_mac_spi_sys_3.unnamed_0.pkg_version;
}
pub inline fn efuse_ll_get_ocode() u32 {
    return EFUSE.rd_sys_part1_data4.unnamed_0.ocode;
}
pub inline fn efuse_ll_get_k_rtc_ldo() u32 {
    return EFUSE.rd_mac_spi_sys_4.unnamed_0.k_rtc_ldo;
}
pub inline fn efuse_ll_get_k_dig_ldo() u32 {
    return EFUSE.rd_mac_spi_sys_4.unnamed_0.k_dig_ldo;
}
pub inline fn efuse_ll_get_v_rtc_dbias20() u32 {
    return EFUSE.rd_mac_spi_sys_4.unnamed_0.v_rtc_dbias20;
}
pub inline fn efuse_ll_get_v_dig_dbias20() u32 {
    return @as(u32, @bitCast((@as(c_int, @bitCast(EFUSE.rd_mac_spi_sys_5.unnamed_0.v_dig_dbias20_1)) << @intCast(3)) + @as(c_int, @bitCast(EFUSE.rd_mac_spi_sys_4.unnamed_0.v_dig_dbias20))));
}
pub inline fn efuse_ll_get_dig_dbias_hvt() u32 {
    return EFUSE.rd_mac_spi_sys_5.unnamed_0.dig_dbias_hvt;
}
pub inline fn efuse_ll_get_read_cmd() bool {
    return EFUSE.cmd.unnamed_0.read_cmd != 0;
}
pub inline fn efuse_ll_get_pgm_cmd() bool {
    return EFUSE.cmd.unnamed_0.pgm_cmd != 0;
}
pub inline fn efuse_ll_set_read_cmd() void {
    EFUSE.cmd.unnamed_0.read_cmd = 1;
}
pub inline fn efuse_ll_set_pgm_cmd(block: u32) void {
    EFUSE.cmd.val = @as(u32, @bitCast(@as(c_uint, @truncate(@as(c_ulong, @bitCast(@as(c_ulong, (block << @intCast(2)) & (@as(c_uint, 15) << @intCast(2))))) | (@as(c_ulong, 1) << @intCast(@as(c_int, 1)))))));
}
pub inline fn efuse_ll_set_conf_read_op_code() void {
    EFUSE.conf.unnamed_0.op_code = @as(u32, @bitCast(@as(c_int, 23205)));
}
pub inline fn efuse_ll_set_conf_write_op_code() void {
    EFUSE.conf.unnamed_0.op_code = @as(u32, @bitCast(@as(c_int, 23130)));
}
pub inline fn efuse_ll_set_dac_num(val: u8) void {
    EFUSE.dac_conf.unnamed_0.dac_num = @as(u32, @bitCast(@as(c_uint, val)));
}
pub inline fn efuse_ll_set_dac_clk_div(val: u8) void {
    EFUSE.dac_conf.unnamed_0.dac_clk_div = @as(u32, @bitCast(@as(c_uint, val)));
}
pub inline fn efuse_ll_set_pwr_on_num(val: u16) void {
    EFUSE.wr_tim_conf1.unnamed_0.pwr_on_num = @as(u32, @bitCast(@as(c_uint, val)));
}
pub inline fn efuse_ll_set_pwr_off_num(value: u16) void {
    EFUSE.wr_tim_conf2.unnamed_0.pwr_off_num = @as(u32, @bitCast(@as(c_uint, value)));
}
pub const ETS_STATUS = enum(c_uint) {
    ETS_OK = 0,
    ETS_FAILED = 1,
    ETS_PENDING = 2,
    ETS_BUSY = 3,
    ETS_CANCEL = 4,
};
pub const ets_status_t = ETS_STATUS;
pub const ETSSignal = u32;
pub const ETSParam = u32;
pub const ETSEventTag = extern struct {
    sig: ETSSignal = std.mem.zeroes(sys.ETSSignal),
    par: ETSParam = std.mem.zeroes(sys.ETSParam),
};
pub const ETSEvent = ETSEventTag;
pub const ETSTask = ?*const fn ([*c]ETSEvent) callconv(.C) void;
pub const ets_idle_cb_t = ?*const fn (?*anyopaque) callconv(.C) void;
pub extern const exc_cause_table: [40][*:0]const u8;
pub extern fn ets_set_user_start(start: u32) void;
pub extern fn ets_printf(fmt: [*:0]const u8, ...) c_int;
pub extern fn ets_get_printf_channel() u8;
pub extern fn ets_install_putc1(p: ?*const fn (u8) callconv(.C) void) void;
pub extern fn ets_install_putc2(p: ?*const fn (u8) callconv(.C) void) void;
pub extern fn ets_install_uart_printf() void;
pub const ETSTimerFunc = fn (?*anyopaque) callconv(.C) void;
pub const _ETSTIMER_ = extern struct {
    timer_next: [*c]_ETSTIMER_ = std.mem.zeroes([*c]_ETSTIMER_),
    timer_expire: u32 = std.mem.zeroes(u32),
    timer_period: u32 = std.mem.zeroes(u32),
    timer_func: ?*const ETSTimerFunc = std.mem.zeroes(?*const ETSTimerFunc),
    timer_arg: ?*anyopaque = null,
};
pub const ETSTimer = _ETSTIMER_;
pub extern fn ets_timer_init() void;
pub extern fn ets_timer_deinit() void;
pub extern fn ets_timer_arm(timer: [*c]ETSTimer, tmout: u32, repeat: bool) void;
pub extern fn ets_timer_arm_us(ptimer: [*c]ETSTimer, us: u32, repeat: bool) void;
pub extern fn ets_timer_disarm(timer: [*c]ETSTimer) void;
pub extern fn ets_timer_setfn(ptimer: [*c]ETSTimer, pfunction: ?*const ETSTimerFunc, parg: ?*anyopaque) void;
pub extern fn ets_timer_done(ptimer: [*c]ETSTimer) void;
pub extern fn ets_delay_us(us: u32) void;
pub extern fn ets_update_cpu_frequency(ticks_per_us: u32) void;
pub extern fn ets_get_cpu_frequency() u32;
pub extern fn ets_get_xtal_freq() u32;
pub extern fn ets_get_xtal_div() u32;
pub extern fn ets_get_apb_freq() u32;
pub const ets_isr_t = ?*const fn (?*anyopaque) callconv(.C) void;
pub extern fn ets_isr_attach(i: c_int, func: ets_isr_t, arg: ?*anyopaque) void;
pub extern fn ets_isr_mask(mask: u32) void;
pub extern fn ets_isr_unmask(unmask: u32) void;
pub extern fn ets_intr_lock() void;
pub extern fn ets_intr_unlock() void;
pub extern fn intr_matrix_set(cpu_no: c_int, model_num: u32, intr_num: u32) void;
pub const ets_rsa_pubkey_t = extern struct {
    n: [384]u8 = std.mem.zeroes([384]u8),
    e: u32 = std.mem.zeroes(u32),
    rinv: [384]u8 = std.mem.zeroes([384]u8),
    mdash: u32 = std.mem.zeroes(u32),
};
pub extern fn ets_rsa_pss_verify(key: [*c]const ets_rsa_pubkey_t, sig: [*:0]const u8, digest: [*:0]const u8, verified_digest: [*c]u8) bool;
pub extern fn ets_mgf1_sha256(mgfSeed: [*:0]const u8, seedLen: usize, maskLen: usize, mask: [*c]u8) void;
pub extern fn ets_emsa_pss_verify(encoded_message: [*:0]const u8, mhash: [*:0]const u8) bool;
pub const ets_secure_boot_sig_block = extern struct {
    magic_byte: u8 = std.mem.zeroes(u8),
    version: u8 = std.mem.zeroes(u8),
    _reserved1: u8 = std.mem.zeroes(u8),
    _reserved2: u8 = std.mem.zeroes(u8),
    image_digest: [32]u8 = std.mem.zeroes([32]u8),
    key: ets_rsa_pubkey_t = std.mem.zeroes(sys.ets_rsa_pubkey_t),
    signature: [384]u8 = std.mem.zeroes([384]u8),
    block_crc: u32 = std.mem.zeroes(u32),
    _padding: [16]u8 = std.mem.zeroes([16]u8),
};
pub const ets_secure_boot_sig_block_t = ets_secure_boot_sig_block;
pub const ets_secure_boot_signature = extern struct {
    block: [3]ets_secure_boot_sig_block_t = std.mem.zeroes([3]ets_secure_boot_sig_block_t),
    _padding: [448]u8 = std.mem.zeroes([448]u8),
};
pub const ets_secure_boot_signature_t = ets_secure_boot_signature;
pub const ets_secure_boot_key_digests = extern struct {
    key_digests: [3]?*const anyopaque = std.mem.zeroes([3]?*const anyopaque),
    allow_key_revoke: bool = std.mem.zeroes(bool),
};
pub const ets_secure_boot_key_digests_t = ets_secure_boot_key_digests;
pub const ets_secure_boot_status_t = enum(c_uint) {
    SB_SUCCESS = 978999973,
    SB_FAILED = 1966311518,
};
pub extern fn ets_secure_boot_verify_bootloader_with_keys(verified_hash: [*c]u8, trusted_keys: [*c]const ets_secure_boot_key_digests_t, stage_load: bool) ets_secure_boot_status_t;
pub extern fn ets_secure_boot_read_key_digests(trusted_keys: [*c]ets_secure_boot_key_digests_t) ETS_STATUS;
pub extern fn ets_secure_boot_verify_signature(sig: [*c]const ets_secure_boot_signature_t, image_digest: [*:0]const u8, trusted_keys: [*c]const ets_secure_boot_key_digests_t, verified_digest: [*c]u8) ets_secure_boot_status_t;
pub extern fn ets_secure_boot_revoke_public_key_digest(index: c_int) void;
// /.espressif/tools/riscv32-esp-elf/esp-13.2.0_20230928/riscv32-esp-elf/riscv32-esp-elf/sys-include/assert.h:45:24: warning: ignoring StaticAssert declaration
// /.espressif/tools/riscv32-esp-elf/esp-13.2.0_20230928/riscv32-esp-elf/riscv32-esp-elf/sys-include/assert.h:45:24: warning: ignoring StaticAssert declaration
pub fn esp_secure_boot_enabled() callconv(.C) bool {
    return efuse_ll_get_secure_boot_v2_en();
}
pub extern fn esp_secure_boot_generate_digest() sys.esp_err_t;
pub extern fn esp_secure_boot_permanently_enable() sys.esp_err_t;
pub extern fn esp_secure_boot_v2_permanently_enable(image_data: ?*const esp_image_metadata_t) sys.esp_err_t;
pub extern fn esp_secure_boot_verify_signature(src_addr: u32, length: u32) sys.esp_err_t;
pub const esp_secure_boot_sig_block_t = extern struct {
    version: u32 = std.mem.zeroes(u32),
    signature: [64]u8 = std.mem.zeroes([64]u8),
};
pub extern fn esp_secure_boot_verify_ecdsa_signature_block(sig_block: [*c]const esp_secure_boot_sig_block_t, image_digest: [*:0]const u8, verified_digest: [*c]u8) sys.esp_err_t;
pub const esp_image_sig_public_key_digests_t = extern struct {
    key_digests: [3][32]u8 = std.mem.zeroes([3][32]u8),
    num_digests: c_uint = std.mem.zeroes(c_uint),
};
pub extern fn esp_secure_boot_verify_signature_block(sig_block: [*c]const esp_secure_boot_sig_block_t, image_digest: [*:0]const u8) sys.esp_err_t;
pub const esp_secure_boot_iv_digest_t = extern struct {
    iv: [128]u8 = std.mem.zeroes([128]u8),
    digest: [64]u8 = std.mem.zeroes([64]u8),
};
pub extern fn esp_secure_boot_init_checks() void;
pub extern fn esp_secure_boot_enable_secure_features() sys.esp_err_t;
pub extern fn esp_secure_boot_cfg_verify_release_mode() bool;
pub const bootloader_state_t = extern struct {
    ota_info: esp_partition_pos_t = std.mem.zeroes(sys.esp_partition_pos_t),
    factory: esp_partition_pos_t = std.mem.zeroes(sys.esp_partition_pos_t),
    @"test": esp_partition_pos_t = std.mem.zeroes(sys.esp_partition_pos_t),
    ota: [16]esp_partition_pos_t = std.mem.zeroes([16]esp_partition_pos_t),
    app_count: u32 = std.mem.zeroes(u32),
    selected_subtype: u32 = std.mem.zeroes(u32),
};
pub extern fn flash_encrypt(bs: [*c]bootloader_state_t) bool;
pub extern var bootloader_image_hdr: esp_image_header_t;
pub extern fn bootloader_read_bootloader_header() sys.esp_err_t;
pub extern fn bootloader_check_bootloader_validity() sys.esp_err_t;
pub extern fn bootloader_clear_bss_section() void;
pub extern fn bootloader_config_wdt() void;
pub extern fn bootloader_enable_random() void;
pub extern fn bootloader_print_banner() void;
pub extern fn bootloader_init() sys.esp_err_t;

const unnamed_4 = opaque {};
pub const efuse_pgm_data0_reg_t = extern union {
    unnamed_0: unnamed_4,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:35:18: warning: struct demoted to opaque type - has bitfield
const unnamed_5 = opaque {};
pub const efuse_pgm_data1_reg_t = extern union {
    unnamed_0: unnamed_5,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:48:18: warning: struct demoted to opaque type - has bitfield
const unnamed_6 = opaque {};
pub const efuse_pgm_data2_reg_t = extern union {
    unnamed_0: unnamed_6,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:61:18: warning: struct demoted to opaque type - has bitfield
const unnamed_7 = opaque {};
pub const efuse_pgm_data3_reg_t = extern union {
    unnamed_0: unnamed_7,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:74:18: warning: struct demoted to opaque type - has bitfield
const unnamed_8 = opaque {};
pub const efuse_pgm_data4_reg_t = extern union {
    unnamed_0: unnamed_8,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:87:18: warning: struct demoted to opaque type - has bitfield
const unnamed_9 = opaque {};
pub const efuse_pgm_data5_reg_t = extern union {
    unnamed_0: unnamed_9,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:100:18: warning: struct demoted to opaque type - has bitfield
const unnamed_10 = opaque {};
pub const efuse_pgm_data6_reg_t = extern union {
    unnamed_0: unnamed_10,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:113:18: warning: struct demoted to opaque type - has bitfield
const unnamed_11 = opaque {};
pub const efuse_pgm_data7_reg_t = extern union {
    unnamed_0: unnamed_11,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:126:18: warning: struct demoted to opaque type - has bitfield
const unnamed_12 = opaque {};
pub const efuse_pgm_check_value0_reg_t = extern union {
    unnamed_0: unnamed_12,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:139:18: warning: struct demoted to opaque type - has bitfield
const unnamed_13 = opaque {};
pub const efuse_pgm_check_value1_reg_t = extern union {
    unnamed_0: unnamed_13,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:152:18: warning: struct demoted to opaque type - has bitfield
const unnamed_14 = opaque {};
pub const efuse_pgm_check_value2_reg_t = extern union {
    unnamed_0: unnamed_14,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:167:18: warning: struct demoted to opaque type - has bitfield
const unnamed_15 = opaque {};
pub const efuse_rd_wr_dis_reg_t = extern union {
    unnamed_0: unnamed_15,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:180:18: warning: struct demoted to opaque type - has bitfield
const unnamed_16 = opaque {};
pub const efuse_rd_repeat_data0_reg_t = extern union {
    unnamed_0: unnamed_16,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:274:18: warning: struct demoted to opaque type - has bitfield
const unnamed_17 = opaque {};
pub const efuse_rd_repeat_data1_reg_t = extern union {
    unnamed_0: unnamed_17,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:317:18: warning: struct demoted to opaque type - has bitfield
const unnamed_18 = opaque {};
pub const efuse_rd_repeat_data2_reg_t = extern union {
    unnamed_0: unnamed_18,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:364:18: warning: struct demoted to opaque type - has bitfield
const unnamed_19 = opaque {};
pub const efuse_rd_repeat_data3_reg_t = extern union {
    unnamed_0: unnamed_19,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:435:18: warning: struct demoted to opaque type - has bitfield
const unnamed_20 = opaque {};
pub const efuse_rd_repeat_data4_reg_t = extern union {
    unnamed_0: unnamed_20,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:457:18: warning: struct demoted to opaque type - has bitfield
const unnamed_21 = opaque {};
pub const efuse_rd_mac_spi_sys_0_reg_t = extern union {
    unnamed_0: unnamed_21,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:470:18: warning: struct demoted to opaque type - has bitfield
const unnamed_22 = opaque {};
pub const efuse_rd_mac_spi_sys_1_reg_t = extern union {
    unnamed_0: unnamed_22,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:495:18: warning: struct demoted to opaque type - has bitfield
const unnamed_23 = opaque {};
pub const efuse_rd_mac_spi_sys_2_reg_t = extern union {
    unnamed_0: unnamed_23,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:528:18: warning: struct demoted to opaque type - has bitfield
const unnamed_24 = opaque {};
pub const efuse_rd_mac_spi_sys_3_reg_t = extern union {
    unnamed_0: unnamed_24,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:569:18: warning: struct demoted to opaque type - has bitfield
const unnamed_25 = opaque {};
pub const efuse_rd_mac_spi_sys_4_reg_t = extern union {
    unnamed_0: unnamed_25,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:602:18: warning: struct demoted to opaque type - has bitfield
const unnamed_26 = opaque {};
pub const efuse_rd_mac_spi_sys_5_reg_t = extern union {
    unnamed_0: unnamed_26,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:639:18: warning: struct demoted to opaque type - has bitfield
const unnamed_27 = opaque {};
pub const efuse_rd_sys_part1_data0_reg_t = extern union {
    unnamed_0: unnamed_27,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:652:18: warning: struct demoted to opaque type - has bitfield
const unnamed_28 = opaque {};
pub const efuse_rd_sys_part1_data1_reg_t = extern union {
    unnamed_0: unnamed_28,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:665:18: warning: struct demoted to opaque type - has bitfield
const unnamed_29 = opaque {};
pub const efuse_rd_sys_part1_data2_reg_t = extern union {
    unnamed_0: unnamed_29,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:678:18: warning: struct demoted to opaque type - has bitfield
const unnamed_30 = opaque {};
pub const efuse_rd_sys_part1_data3_reg_t = extern union {
    unnamed_0: unnamed_30,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:691:18: warning: struct demoted to opaque type - has bitfield
const unnamed_31 = opaque {};
pub const efuse_rd_sys_part1_data4_reg_t = extern union {
    unnamed_0: unnamed_31,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:724:18: warning: struct demoted to opaque type - has bitfield
const unnamed_32 = opaque {};
pub const efuse_rd_sys_part1_data5_reg_t = extern union {
    unnamed_0: unnamed_32,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:749:18: warning: struct demoted to opaque type - has bitfield
const unnamed_33 = opaque {};
pub const efuse_rd_sys_part1_data6_reg_t = extern union {
    unnamed_0: unnamed_33,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:774:18: warning: struct demoted to opaque type - has bitfield
const unnamed_34 = opaque {};
pub const efuse_rd_sys_part1_data7_reg_t = extern union {
    unnamed_0: unnamed_34,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:791:18: warning: struct demoted to opaque type - has bitfield
const unnamed_35 = opaque {};
pub const efuse_rd_usr_data0_reg_t = extern union {
    unnamed_0: unnamed_35,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:804:18: warning: struct demoted to opaque type - has bitfield
const unnamed_36 = opaque {};
pub const efuse_rd_usr_data1_reg_t = extern union {
    unnamed_0: unnamed_36,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:817:18: warning: struct demoted to opaque type - has bitfield
const unnamed_37 = opaque {};
pub const efuse_rd_usr_data2_reg_t = extern union {
    unnamed_0: unnamed_37,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:830:18: warning: struct demoted to opaque type - has bitfield
const unnamed_38 = opaque {};
pub const efuse_rd_usr_data3_reg_t = extern union {
    unnamed_0: unnamed_38,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:843:18: warning: struct demoted to opaque type - has bitfield
const unnamed_39 = opaque {};
pub const efuse_rd_usr_data4_reg_t = extern union {
    unnamed_0: unnamed_39,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:856:18: warning: struct demoted to opaque type - has bitfield
const unnamed_40 = opaque {};
pub const efuse_rd_usr_data5_reg_t = extern union {
    unnamed_0: unnamed_40,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:869:18: warning: struct demoted to opaque type - has bitfield
const unnamed_41 = opaque {};
pub const efuse_rd_usr_data6_reg_t = extern union {
    unnamed_0: unnamed_41,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:886:18: warning: struct demoted to opaque type - has bitfield
const unnamed_42 = opaque {};
pub const efuse_rd_usr_data7_reg_t = extern union {
    unnamed_0: unnamed_42,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:903:18: warning: struct demoted to opaque type - has bitfield
const unnamed_43 = opaque {};
pub const efuse_rd_key0_data0_reg_t = extern union {
    unnamed_0: unnamed_43,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:916:18: warning: struct demoted to opaque type - has bitfield
const unnamed_44 = opaque {};
pub const efuse_rd_key0_data1_reg_t = extern union {
    unnamed_0: unnamed_44,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:929:18: warning: struct demoted to opaque type - has bitfield
const unnamed_45 = opaque {};
pub const efuse_rd_key0_data2_reg_t = extern union {
    unnamed_0: unnamed_45,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:942:18: warning: struct demoted to opaque type - has bitfield
const unnamed_46 = opaque {};
pub const efuse_rd_key0_data3_reg_t = extern union {
    unnamed_0: unnamed_46,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:955:18: warning: struct demoted to opaque type - has bitfield
const unnamed_47 = opaque {};
pub const efuse_rd_key0_data4_reg_t = extern union {
    unnamed_0: unnamed_47,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:968:18: warning: struct demoted to opaque type - has bitfield
const unnamed_48 = opaque {};
pub const efuse_rd_key0_data5_reg_t = extern union {
    unnamed_0: unnamed_48,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:981:18: warning: struct demoted to opaque type - has bitfield
const unnamed_49 = opaque {};
pub const efuse_rd_key0_data6_reg_t = extern union {
    unnamed_0: unnamed_49,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:994:18: warning: struct demoted to opaque type - has bitfield
const unnamed_50 = opaque {};
pub const efuse_rd_key0_data7_reg_t = extern union {
    unnamed_0: unnamed_50,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1007:18: warning: struct demoted to opaque type - has bitfield
const unnamed_51 = opaque {};
pub const efuse_rd_key1_data0_reg_t = extern union {
    unnamed_0: unnamed_51,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1020:18: warning: struct demoted to opaque type - has bitfield
const unnamed_52 = opaque {};
pub const efuse_rd_key1_data1_reg_t = extern union {
    unnamed_0: unnamed_52,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1033:18: warning: struct demoted to opaque type - has bitfield
const unnamed_53 = opaque {};
pub const efuse_rd_key1_data2_reg_t = extern union {
    unnamed_0: unnamed_53,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1046:18: warning: struct demoted to opaque type - has bitfield
const unnamed_54 = opaque {};
pub const efuse_rd_key1_data3_reg_t = extern union {
    unnamed_0: unnamed_54,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1059:18: warning: struct demoted to opaque type - has bitfield
const unnamed_55 = opaque {};
pub const efuse_rd_key1_data4_reg_t = extern union {
    unnamed_0: unnamed_55,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1072:18: warning: struct demoted to opaque type - has bitfield
const unnamed_56 = opaque {};
pub const efuse_rd_key1_data5_reg_t = extern union {
    unnamed_0: unnamed_56,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1085:18: warning: struct demoted to opaque type - has bitfield
const unnamed_57 = opaque {};
pub const efuse_rd_key1_data6_reg_t = extern union {
    unnamed_0: unnamed_57,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1098:18: warning: struct demoted to opaque type - has bitfield
const unnamed_58 = opaque {};
pub const efuse_rd_key1_data7_reg_t = extern union {
    unnamed_0: unnamed_58,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1111:18: warning: struct demoted to opaque type - has bitfield
const unnamed_59 = opaque {};
pub const efuse_rd_key2_data0_reg_t = extern union {
    unnamed_0: unnamed_59,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1124:18: warning: struct demoted to opaque type - has bitfield
const unnamed_60 = opaque {};
pub const efuse_rd_key2_data1_reg_t = extern union {
    unnamed_0: unnamed_60,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1137:18: warning: struct demoted to opaque type - has bitfield
const unnamed_61 = opaque {};
pub const efuse_rd_key2_data2_reg_t = extern union {
    unnamed_0: unnamed_61,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1150:18: warning: struct demoted to opaque type - has bitfield
const unnamed_62 = opaque {};
pub const efuse_rd_key2_data3_reg_t = extern union {
    unnamed_0: unnamed_62,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1163:18: warning: struct demoted to opaque type - has bitfield
const unnamed_63 = opaque {};
pub const efuse_rd_key2_data4_reg_t = extern union {
    unnamed_0: unnamed_63,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1176:18: warning: struct demoted to opaque type - has bitfield
const unnamed_64 = opaque {};
pub const efuse_rd_key2_data5_reg_t = extern union {
    unnamed_0: unnamed_64,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1189:18: warning: struct demoted to opaque type - has bitfield
const unnamed_65 = opaque {};
pub const efuse_rd_key2_data6_reg_t = extern union {
    unnamed_0: unnamed_65,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1202:18: warning: struct demoted to opaque type - has bitfield
const unnamed_66 = opaque {};
pub const efuse_rd_key2_data7_reg_t = extern union {
    unnamed_0: unnamed_66,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1215:18: warning: struct demoted to opaque type - has bitfield
const unnamed_67 = opaque {};
pub const efuse_rd_key3_data0_reg_t = extern union {
    unnamed_0: unnamed_67,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1228:18: warning: struct demoted to opaque type - has bitfield
const unnamed_68 = opaque {};
pub const efuse_rd_key3_data1_reg_t = extern union {
    unnamed_0: unnamed_68,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1241:18: warning: struct demoted to opaque type - has bitfield
const unnamed_69 = opaque {};
pub const efuse_rd_key3_data2_reg_t = extern union {
    unnamed_0: unnamed_69,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1254:18: warning: struct demoted to opaque type - has bitfield
const unnamed_70 = opaque {};
pub const efuse_rd_key3_data3_reg_t = extern union {
    unnamed_0: unnamed_70,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1267:18: warning: struct demoted to opaque type - has bitfield
const unnamed_71 = opaque {};
pub const efuse_rd_key3_data4_reg_t = extern union {
    unnamed_0: unnamed_71,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1280:18: warning: struct demoted to opaque type - has bitfield
const unnamed_72 = opaque {};
pub const efuse_rd_key3_data5_reg_t = extern union {
    unnamed_0: unnamed_72,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1293:18: warning: struct demoted to opaque type - has bitfield
const unnamed_73 = opaque {};
pub const efuse_rd_key3_data6_reg_t = extern union {
    unnamed_0: unnamed_73,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1306:18: warning: struct demoted to opaque type - has bitfield
const unnamed_74 = opaque {};
pub const efuse_rd_key3_data7_reg_t = extern union {
    unnamed_0: unnamed_74,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1319:18: warning: struct demoted to opaque type - has bitfield
const unnamed_75 = opaque {};
pub const efuse_rd_key4_data0_reg_t = extern union {
    unnamed_0: unnamed_75,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1332:18: warning: struct demoted to opaque type - has bitfield
const unnamed_76 = opaque {};
pub const efuse_rd_key4_data1_reg_t = extern union {
    unnamed_0: unnamed_76,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1345:18: warning: struct demoted to opaque type - has bitfield
const unnamed_77 = opaque {};
pub const efuse_rd_key4_data2_reg_t = extern union {
    unnamed_0: unnamed_77,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1358:18: warning: struct demoted to opaque type - has bitfield
const unnamed_78 = opaque {};
pub const efuse_rd_key4_data3_reg_t = extern union {
    unnamed_0: unnamed_78,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1371:18: warning: struct demoted to opaque type - has bitfield
const unnamed_79 = opaque {};
pub const efuse_rd_key4_data4_reg_t = extern union {
    unnamed_0: unnamed_79,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1384:18: warning: struct demoted to opaque type - has bitfield
const unnamed_80 = opaque {};
pub const efuse_rd_key4_data5_reg_t = extern union {
    unnamed_0: unnamed_80,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1397:18: warning: struct demoted to opaque type - has bitfield
const unnamed_81 = opaque {};
pub const efuse_rd_key4_data6_reg_t = extern union {
    unnamed_0: unnamed_81,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1410:18: warning: struct demoted to opaque type - has bitfield
const unnamed_82 = opaque {};
pub const efuse_rd_key4_data7_reg_t = extern union {
    unnamed_0: unnamed_82,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1423:18: warning: struct demoted to opaque type - has bitfield
const unnamed_83 = opaque {};
pub const efuse_rd_key5_data0_reg_t = extern union {
    unnamed_0: unnamed_83,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1436:18: warning: struct demoted to opaque type - has bitfield
const unnamed_84 = opaque {};
pub const efuse_rd_key5_data1_reg_t = extern union {
    unnamed_0: unnamed_84,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1449:18: warning: struct demoted to opaque type - has bitfield
const unnamed_85 = opaque {};
pub const efuse_rd_key5_data2_reg_t = extern union {
    unnamed_0: unnamed_85,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1462:18: warning: struct demoted to opaque type - has bitfield
const unnamed_86 = opaque {};
pub const efuse_rd_key5_data3_reg_t = extern union {
    unnamed_0: unnamed_86,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1475:18: warning: struct demoted to opaque type - has bitfield
const unnamed_87 = opaque {};
pub const efuse_rd_key5_data4_reg_t = extern union {
    unnamed_0: unnamed_87,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1488:18: warning: struct demoted to opaque type - has bitfield
const unnamed_88 = opaque {};
pub const efuse_rd_key5_data5_reg_t = extern union {
    unnamed_0: unnamed_88,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1501:18: warning: struct demoted to opaque type - has bitfield
const unnamed_89 = opaque {};
pub const efuse_rd_key5_data6_reg_t = extern union {
    unnamed_0: unnamed_89,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1514:18: warning: struct demoted to opaque type - has bitfield
const unnamed_90 = opaque {};
pub const efuse_rd_key5_data7_reg_t = extern union {
    unnamed_0: unnamed_90,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1527:18: warning: struct demoted to opaque type - has bitfield
const unnamed_91 = opaque {};
pub const efuse_rd_sys_part2_data0_reg_t = extern union {
    unnamed_0: unnamed_91,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1540:18: warning: struct demoted to opaque type - has bitfield
const unnamed_92 = opaque {};
pub const efuse_rd_sys_part2_data1_reg_t = extern union {
    unnamed_0: unnamed_92,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1553:18: warning: struct demoted to opaque type - has bitfield
const unnamed_93 = opaque {};
pub const efuse_rd_sys_part2_data2_reg_t = extern union {
    unnamed_0: unnamed_93,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1566:18: warning: struct demoted to opaque type - has bitfield
const unnamed_94 = opaque {};
pub const efuse_rd_sys_part2_data3_reg_t = extern union {
    unnamed_0: unnamed_94,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1579:18: warning: struct demoted to opaque type - has bitfield
const unnamed_95 = opaque {};
pub const efuse_rd_sys_part2_data4_reg_t = extern union {
    unnamed_0: unnamed_95,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1592:18: warning: struct demoted to opaque type - has bitfield
const unnamed_96 = opaque {};
pub const efuse_rd_sys_part2_data5_reg_t = extern union {
    unnamed_0: unnamed_96,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1605:18: warning: struct demoted to opaque type - has bitfield
const unnamed_97 = opaque {};
pub const efuse_rd_sys_part2_data6_reg_t = extern union {
    unnamed_0: unnamed_97,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1618:18: warning: struct demoted to opaque type - has bitfield
const unnamed_98 = opaque {};
pub const efuse_rd_sys_part2_data7_reg_t = extern union {
    unnamed_0: unnamed_98,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1633:18: warning: struct demoted to opaque type - has bitfield
const unnamed_99 = opaque {};
pub const efuse_rd_repeat_err0_reg_t = extern union {
    unnamed_0: unnamed_99,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1722:18: warning: struct demoted to opaque type - has bitfield
const unnamed_100 = opaque {};
pub const efuse_rd_repeat_err1_reg_t = extern union {
    unnamed_0: unnamed_100,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1763:18: warning: struct demoted to opaque type - has bitfield
const unnamed_101 = opaque {};
pub const efuse_rd_repeat_err2_reg_t = extern union {
    unnamed_0: unnamed_101,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1808:18: warning: struct demoted to opaque type - has bitfield
const unnamed_102 = opaque {};
pub const efuse_rd_repeat_err3_reg_t = extern union {
    unnamed_0: unnamed_102,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1873:18: warning: struct demoted to opaque type - has bitfield
const unnamed_103 = opaque {};
pub const efuse_rd_repeat_err4_reg_t = extern union {
    unnamed_0: unnamed_103,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1887:18: warning: struct demoted to opaque type - has bitfield
const unnamed_104 = opaque {};
pub const efuse_rd_rs_err0_reg_t = extern union {
    unnamed_0: unnamed_104,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1968:18: warning: struct demoted to opaque type - has bitfield
const unnamed_105 = opaque {};
pub const efuse_rd_rs_err1_reg_t = extern union {
    unnamed_0: unnamed_105,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:1998:18: warning: struct demoted to opaque type - has bitfield
const unnamed_106 = opaque {};
pub const efuse_clk_reg_t = extern union {
    unnamed_0: unnamed_106,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:2025:18: warning: struct demoted to opaque type - has bitfield
const unnamed_107 = opaque {};
pub const efuse_conf_reg_t = extern union {
    unnamed_0: unnamed_107,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:2039:18: warning: struct demoted to opaque type - has bitfield
const unnamed_108 = opaque {};
pub const efuse_cmd_reg_t = extern union {
    unnamed_0: unnamed_108,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:2062:18: warning: struct demoted to opaque type - has bitfield
const unnamed_109 = opaque {};
pub const efuse_dac_conf_reg_t = extern union {
    unnamed_0: unnamed_109,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:2085:18: warning: struct demoted to opaque type - has bitfield
const unnamed_110 = opaque {};
pub const efuse_rd_tim_conf_reg_t = extern union {
    unnamed_0: unnamed_110,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:2099:18: warning: struct demoted to opaque type - has bitfield
const unnamed_111 = opaque {};
pub const efuse_wr_tim_conf1_reg_t = extern union {
    unnamed_0: unnamed_111,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:2117:18: warning: struct demoted to opaque type - has bitfield
const unnamed_112 = opaque {};
pub const efuse_wr_tim_conf2_reg_t = extern union {
    unnamed_0: unnamed_112,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:2133:18: warning: struct demoted to opaque type - has bitfield
const unnamed_113 = opaque {};
pub const efuse_status_reg_t = extern union {
    unnamed_0: unnamed_113,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:2177:18: warning: struct demoted to opaque type - has bitfield
const unnamed_114 = opaque {};
pub const efuse_int_raw_reg_t = extern union {
    unnamed_0: unnamed_114,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:2195:18: warning: struct demoted to opaque type - has bitfield
const unnamed_115 = opaque {};
pub const efuse_int_st_reg_t = extern union {
    unnamed_0: unnamed_115,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:2213:18: warning: struct demoted to opaque type - has bitfield
const unnamed_116 = opaque {};
pub const efuse_int_ena_reg_t = extern union {
    unnamed_0: unnamed_116,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:2231:18: warning: struct demoted to opaque type - has bitfield
const unnamed_117 = opaque {};
pub const efuse_int_clr_reg_t = extern union {
    unnamed_0: unnamed_117,
    val: u32,
};
// /esp-idf/components/soc/esp32c3/include/soc/efuse_struct.h:2251:18: warning: struct demoted to opaque type - has bitfield
const unnamed_118 = opaque {};
pub const efuse_date_reg_t = extern union {
    unnamed_0: unnamed_118,
    val: u32,
};
