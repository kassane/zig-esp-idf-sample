const sys = @import("sys");
const errors = @import("error");

pub const PulseCounter = struct {
    pub const watchEventData_t = sys.pcnt_watch_event_data_t;
    pub const eventCallbacks_t = sys.pcnt_event_callbacks_t;
    pub const glitchFilterConfig_t = sys.pcnt_glitch_filter_config_t;

    pub const Unit = struct {
        pub const config_t = sys.pcnt_unit_config_t;
        pub const handle_t = sys.pcnt_unit_handle_t;

        pub fn init(config: ?*const sys.pcnt_unit_config_t, unit: ?*sys.pcnt_unit_handle_t) !void {
            return try errors.espCheckError(sys.pcnt_new_unit(config, unit));
        }
        pub fn del(unit: sys.pcnt_unit_handle_t) !void {
            return try errors.espCheckError(sys.pcnt_del_unit(unit));
        }
        pub fn enable(unit: sys.pcnt_unit_handle_t) !void {
            return try errors.espCheckError(sys.pcnt_unit_enable(unit));
        }
        pub fn disable(unit: sys.pcnt_unit_handle_t) !void {
            return try errors.espCheckError(sys.pcnt_unit_disable(unit));
        }
        pub fn start(unit: sys.pcnt_unit_handle_t) !void {
            return try errors.espCheckError(sys.pcnt_unit_start(unit));
        }
        pub fn stop(unit: sys.pcnt_unit_handle_t) !void {
            return try errors.espCheckError(sys.pcnt_unit_stop(unit));
        }
        pub fn clear(unit: sys.pcnt_unit_handle_t) !void {
            return try errors.espCheckError(sys.pcnt_unit_clear_count(unit));
        }
        pub fn setGlitchFilter(unit: sys.pcnt_unit_handle_t, config: ?*const sys.pcnt_glitch_filter_config_t) !void {
            return try errors.espCheckError(sys.pcnt_unit_set_glitch_filter(unit, config));
        }
        pub fn getCount(unit: sys.pcnt_unit_handle_t, value: ?*c_int) !void {
            return try errors.espCheckError(sys.pcnt_unit_get_count(unit, value));
        }
        pub fn registerEventCallbacks(unit: sys.pcnt_unit_handle_t, cbs: ?*const sys.pcnt_event_callbacks_t, user_data: ?*anyopaque) !void {
            return try errors.espCheckError(sys.pcnt_unit_register_event_callbacks(unit, cbs, user_data));
        }
        pub fn addWatchPoint(unit: sys.pcnt_unit_handle_t, watch_point: c_int) !void {
            return try errors.espCheckError(sys.pcnt_unit_add_watch_point(unit, watch_point));
        }
        pub fn removeWatchPoint(unit: sys.pcnt_unit_handle_t, watch_point: c_int) !void {
            return try errors.espCheckError(sys.pcnt_unit_remove_watch_point(unit, watch_point));
        }
    };
    pub const Channel = struct {
        pub const handle_t = sys.pcnt_channel_handle_t;
        pub const config_t = sys.pcnt_chan_config_t;
        pub const edgeAction_t = sys.pcnt_channel_edge_action_t;
        pub const level_t = sys.pcnt_channel_level_t;

        pub fn init(unit: sys.pcnt_unit_handle_t, config: ?*const sys.pcnt_chan_config_t, chan: ?*sys.pcnt_channel_handle_t) !void {
            return try errors.espCheckError(sys.pcnt_new_channel(unit, config, chan));
        }
        pub fn del(chan: sys.pcnt_channel_handle_t) !void {
            return try errors.espCheckError(sys.pcnt_del_channel(chan));
        }
        const set = struct {
            pub fn edgeAction(chan: sys.pcnt_channel_handle_t, pos_act: sys.pcnt_channel_edge_action_t, neg_act: sys.pcnt_channel_edge_action_t) !void {
                return try errors.espCheckError(sys.pcnt_channel_set_edge_action(chan, pos_act, neg_act));
            }
            pub fn levelAction(chan: sys.pcnt_channel_handle_t, high_act: sys.pcnt_channel_level_action_t, low_act: sys.pcnt_channel_level_action_t) !void {
                return try errors.espCheckError(sys.pcnt_channel_set_edge_action(chan, high_act, low_act));
            }
        };
    };
};
