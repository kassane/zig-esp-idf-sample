const idf = @import("sys");
const std = @import("std");

pub const gpio_etm_event_edge_t = enum(c_uint) {
    GPIO_ETM_EVENT_EDGE_POS = 0,
    GPIO_ETM_EVENT_EDGE_NEG = 1,
    GPIO_ETM_EVENT_EDGE_ANY = 2,
};
pub const gpio_etm_event_config_t = extern struct {
    edge: gpio_etm_event_edge_t = std.mem.zeroes(gpio_etm_event_edge_t),
};
pub extern fn gpio_new_etm_event(config: [*c]const gpio_etm_event_config_t, ret_event: [*c]esp_etm_event_handle_t) idf.esp_err_t;
pub extern fn gpio_etm_event_bind_gpio(event: esp_etm_event_handle_t, gpio_num: c_int) idf.esp_err_t;
pub const gpio_etm_task_action_t = enum(c_uint) {
    GPIO_ETM_TASK_ACTION_SET = 0,
    GPIO_ETM_TASK_ACTION_CLR = 1,
    GPIO_ETM_TASK_ACTION_TOG = 2,
};
pub const gpio_etm_task_config_t = extern struct {
    action: gpio_etm_task_action_t = std.mem.zeroes(gpio_etm_task_action_t),
};
pub extern fn gpio_new_etm_task(config: [*c]const gpio_etm_task_config_t, ret_task: [*c]esp_etm_task_handle_t) idf.esp_err_t;
pub extern fn gpio_etm_task_add_gpio(task: esp_etm_task_handle_t, gpio_num: c_int) idf.esp_err_t;
pub extern fn gpio_etm_task_rm_gpio(task: esp_etm_task_handle_t, gpio_num: c_int) idf.esp_err_t;
pub const gpio_isr_handle_t = idf.intr_handle_t;
pub const gpio_isr_t = ?*const fn (?*anyopaque) callconv(.C) void;
pub const gpio_config_t = extern struct {
    pin_bit_mask: u64 = std.mem.zeroes(u64),
    mode: idf.gpio_mode_t = std.mem.zeroes(idf.gpio_mode_t),
    pull_up_en: idf.gpio_pullup_t = std.mem.zeroes(idf.gpio_pullup_t),
    pull_down_en: idf.gpio_pulldown_t = std.mem.zeroes(idf.gpio_pulldown_t),
    intr_type: idf.gpio_int_type_t = std.mem.zeroes(idf.gpio_int_type_t),
};
pub extern fn gpio_config(pGPIOConfig: [*c]const gpio_config_t) idf.esp_err_t;
pub extern fn gpio_reset_pin(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_set_intr_type(gpio_num: idf.gpio_num_t, intr_type: idf.gpio_int_type_t) idf.esp_err_t;
pub extern fn gpio_intr_enable(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_intr_disable(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_set_level(gpio_num: idf.gpio_num_t, level: u32) idf.esp_err_t;
pub extern fn gpio_get_level(gpio_num: idf.gpio_num_t) c_int;
pub extern fn gpio_set_direction(gpio_num: idf.gpio_num_t, mode: idf.gpio_mode_t) idf.esp_err_t;
pub extern fn gpio_set_pull_mode(gpio_num: idf.gpio_num_t, pull: idf.gpio_pull_mode_t) idf.esp_err_t;
pub extern fn gpio_wakeup_enable(gpio_num: idf.gpio_num_t, intr_type: idf.gpio_int_type_t) idf.esp_err_t;
pub extern fn gpio_wakeup_disable(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_isr_register(@"fn": ?*const fn (?*anyopaque) callconv(.C) void, arg: ?*anyopaque, intr_alloc_flags: c_int, handle: [*c]gpio_isr_handle_t) idf.esp_err_t;
pub extern fn gpio_pullup_en(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_pullup_dis(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_pulldown_en(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_pulldown_dis(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_install_isr_service(intr_alloc_flags: c_int) idf.esp_err_t;
pub extern fn gpio_uninstall_isr_service() void;
pub extern fn gpio_isr_handler_add(gpio_num: idf.gpio_num_t, isr_handler: gpio_isr_t, args: ?*anyopaque) idf.esp_err_t;
pub extern fn gpio_isr_handler_remove(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_set_drive_capability(gpio_num: idf.gpio_num_t, strength: idf.gpio_drive_cap_t) idf.esp_err_t;
pub extern fn gpio_get_drive_capability(gpio_num: idf.gpio_num_t, strength: [*c]idf.gpio_drive_cap_t) idf.esp_err_t;
pub extern fn gpio_hold_en(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_hold_dis(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_deep_sleep_hold_en() void;
pub extern fn gpio_deep_sleep_hold_dis() void;
pub extern fn gpio_iomux_in(gpio_num: u32, signal_idx: u32) void;
pub extern fn gpio_iomux_out(gpio_num: u8, func: c_int, oen_inv: bool) void;
pub extern fn gpio_force_hold_all() idf.esp_err_t;
pub extern fn gpio_force_unhold_all() idf.esp_err_t;
pub extern fn gpio_sleep_sel_en(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_sleep_sel_dis(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_sleep_set_direction(gpio_num: idf.gpio_num_t, mode: idf.gpio_mode_t) idf.esp_err_t;
pub extern fn gpio_sleep_set_pull_mode(gpio_num: idf.gpio_num_t, pull: idf.gpio_pull_mode_t) idf.esp_err_t;
pub extern fn gpio_deep_sleep_wakeup_enable(gpio_num: idf.gpio_num_t, intr_type: idf.gpio_int_type_t) idf.esp_err_t;
pub extern fn gpio_deep_sleep_wakeup_disable(gpio_num: idf.gpio_num_t) idf.esp_err_t;
pub extern fn gpio_dump_io_configuration(out_stream: std.c.FILE, io_bit_mask: u64) idf.esp_err_t;
pub extern fn esp_rom_gpio_pad_select_gpio(iopad_num: u32) void;
pub extern fn esp_rom_gpio_pad_pullup_only(iopad_num: u32) void;
pub extern fn esp_rom_gpio_pad_unhold(gpio_num: u32) void;
pub extern fn esp_rom_gpio_pad_set_drv(iopad_num: u32, drv: u32) void;
pub extern fn esp_rom_gpio_connect_in_signal(gpio_num: u32, signal_idx: u32, inv: bool) void;
pub extern fn esp_rom_gpio_connect_out_signal(gpio_num: u32, signal_idx: u32, out_inv: bool, oen_inv: bool) void;
pub const esp_etm_channel_t = opaque {};
pub const esp_etm_channel_handle_t = ?*esp_etm_channel_t;
pub const esp_etm_event_t = opaque {};
pub const esp_etm_event_handle_t = ?*esp_etm_event_t;
pub const esp_etm_task_t = opaque {};
pub const esp_etm_task_handle_t = ?*esp_etm_task_t;
pub const esp_etm_channel_config_t = extern struct {};
pub extern fn esp_etm_new_channel(config: [*c]const esp_etm_channel_config_t, ret_chan: [*c]esp_etm_channel_handle_t) idf.esp_err_t;
pub extern fn esp_etm_del_channel(chan: esp_etm_channel_handle_t) idf.esp_err_t;
pub extern fn esp_etm_channel_enable(chan: esp_etm_channel_handle_t) idf.esp_err_t;
pub extern fn esp_etm_channel_disable(chan: esp_etm_channel_handle_t) idf.esp_err_t;
pub extern fn esp_etm_channel_connect(chan: esp_etm_channel_handle_t, event: esp_etm_event_handle_t, task: esp_etm_task_handle_t) idf.esp_err_t;
pub extern fn esp_etm_del_event(event: esp_etm_event_handle_t) idf.esp_err_t;
pub extern fn esp_etm_del_task(task: esp_etm_task_handle_t) idf.esp_err_t;
pub extern fn esp_etm_dump(out_stream: std.c.FILE) idf.esp_err_t;
pub extern fn esp_timer_new_etm_alarm_event(out_event: [*c]esp_etm_event_handle_t) idf.esp_err_t;
