const std = @import("std");
const sys = @import("sys");

pub fn espLogFn(
    comptime level: std.log.Level,
    comptime scope: @TypeOf(.EnumLiteral),
    comptime format: []const u8,
    args: anytype,
) void {
    var heap = std.heap.ArenaAllocator.init(std.heap.raw_c_allocator);
    defer heap.deinit();
    const allocator = heap.allocator();

    const scope_prefix = "(" ++ switch (scope) {
        .@"esp-idf", default_log_scope => @tagName(scope),
        else => if (@intFromEnum(level) <= @intFromEnum(std.log.Level.err))
            @tagName(scope)
        else
            @tagName(scope),
    } ++ "): ";

    const prefix = default_color ++ "[" ++ comptime level.asText() ++ "] " ++ scope_prefix;
    ESP_LOG(allocator, "logging", prefix ++ format ++ "\n", args);
}
pub const default_level: sys.esp_log_level_t = switch (@import("builtin").mode) {
    .Debug => .ESP_LOG_DEBUG,
    .ReleaseSafe => .ESP_LOG_INFO,
    .ReleaseFast, .ReleaseSmall => .ESP_LOG_ERROR,
};
pub fn ESP_LOG(allocator: std.mem.Allocator, comptime tag: [*:0]const u8, comptime fmt: []const u8, args: anytype) void {
    const buffer = if (isComptime(args))
        std.fmt.comptimePrint(fmt, args)
    else
        std.fmt.allocPrintZ(allocator, fmt, args) catch |err| @panic(@errorName(err));
    sys.esp_log_write(default_level, tag, buffer, sys.esp_log_timestamp(), tag);
}
pub const default_color = switch (default_level) {
    .ESP_LOG_DEBUG => LOG_COLOR(LOG_COLOR_BLUE),
    .ESP_LOG_INFO => LOG_COLOR_I,
    .ESP_LOG_ERROR => LOG_COLOR_E,
    .ESP_LOG_NONE => LOG_COLOR(LOG_COLOR_BLACK),
    .ESP_LOG_WARN => LOG_COLOR_W,
    .ESP_LOG_VERBOSE => LOG_COLOR_I,
};
pub const LOG_COLOR_BLACK = "30";
pub const LOG_COLOR_RED = "31";
pub const LOG_COLOR_GREEN = "32";
pub const LOG_COLOR_BROWN = "33";
pub const LOG_COLOR_BLUE = "34";
pub const LOG_COLOR_PURPLE = "35";
pub const LOG_COLOR_CYAN = "36";
pub inline fn LOG_COLOR(COLOR: anytype) @TypeOf("\x1b[0;" ++ COLOR ++ "m") {
    return "\x1b[0;" ++ COLOR ++ "m";
}
pub inline fn LOG_BOLD(COLOR: anytype) @TypeOf("\x1b[1;" ++ COLOR ++ "m") {
    return "\x1b[1;" ++ COLOR ++ "m";
}
pub const LOG_RESET_COLOR = "\x1b[0m";
pub const LOG_COLOR_E = LOG_COLOR(LOG_COLOR_RED);
pub const LOG_COLOR_W = LOG_COLOR(LOG_COLOR_BROWN);
pub const LOG_COLOR_I = LOG_COLOR(LOG_COLOR_GREEN);
pub const default_log_scope = .espressif;

inline fn isComptime(val: anytype) bool {
    return @typeInfo(@TypeOf(.{val})).@"struct".fields[0].is_comptime;
}
