const std = @import("std");
const sys = @import("sys");

pub const default_log_scope = .espressif;

pub fn espLogFn(
    comptime level: std.log.Level,
    comptime scope: @TypeOf(.EnumLiteral),
    comptime format: []const u8,
    args: anytype,
) void {
    const esp_level = comptime levelToEsp(level);
    const color = comptime levelColor(level);
    const prefix = color ++ "[" ++ comptime level.asText() ++ "] (" ++ @tagName(scope) ++ "): ";

    var heap = std.heap.ArenaAllocator.init(std.heap.c_allocator);
    defer heap.deinit();

    ESP_LOG(heap.allocator(), esp_level, "logging", prefix ++ format ++ LOG_RESET_COLOR ++ "\n", args);
}

// ---------------------------------------------------------------------------
// Level mapping
// ---------------------------------------------------------------------------

pub const default_level: sys.esp_log_level_t = switch (@import("builtin").mode) {
    .Debug => sys.ESP_LOG_DEBUG,
    .ReleaseSafe => sys.ESP_LOG_INFO,
    .ReleaseFast, .ReleaseSmall => sys.ESP_LOG_ERROR,
};

/// Converts a Zig log level to its ESP-IDF equivalent.
pub fn levelToEsp(comptime level: std.log.Level) sys.esp_log_level_t {
    return switch (level) {
        .err => sys.ESP_LOG_ERROR,
        .warn => sys.ESP_LOG_WARN,
        .info => sys.ESP_LOG_INFO,
        .debug => sys.ESP_LOG_DEBUG,
    };
}

/// Returns the ANSI color escape for a given Zig log level.
pub fn levelColor(comptime level: std.log.Level) []const u8 {
    return switch (level) {
        .err => LOG_COLOR_E,
        .warn => LOG_COLOR_W,
        .info => LOG_COLOR_I,
        .debug => LOG_COLOR(LOG_COLOR_BLUE),
    };
}

// ---------------------------------------------------------------------------
// Core log primitive
// ---------------------------------------------------------------------------

pub fn ESP_LOG(
    allocator: std.mem.Allocator,
    level: sys.esp_log_level_t,
    comptime tag: [*:0]const u8,
    comptime fmt: []const u8,
    args: anytype,
) void {
    const buffer: []const u8 = if (isComptime(args))
        std.fmt.comptimePrint(fmt, args)
    else
        std.fmt.allocPrint(allocator, fmt, args) catch return;

    sys.esp_log_write(level, tag, "%s", buffer.ptr);
}

// ---------------------------------------------------------------------------
// ANSI color helpers
// ---------------------------------------------------------------------------

pub const LOG_COLOR_BLACK = "30";
pub const LOG_COLOR_RED = "31";
pub const LOG_COLOR_GREEN = "32";
pub const LOG_COLOR_BROWN = "33";
pub const LOG_COLOR_BLUE = "34";
pub const LOG_COLOR_PURPLE = "35";
pub const LOG_COLOR_CYAN = "36";

pub inline fn LOG_COLOR(comptime COLOR: []const u8) []const u8 {
    return "\x1b[0;" ++ COLOR ++ "m";
}
pub inline fn LOG_BOLD(comptime COLOR: []const u8) []const u8 {
    return "\x1b[1;" ++ COLOR ++ "m";
}

pub const LOG_RESET_COLOR = "\x1b[0m";
pub const LOG_COLOR_E = LOG_COLOR(LOG_COLOR_RED);
pub const LOG_COLOR_W = LOG_COLOR(LOG_COLOR_BROWN);
pub const LOG_COLOR_I = LOG_COLOR(LOG_COLOR_GREEN);

// ---------------------------------------------------------------------------
// Internal helpers
// ---------------------------------------------------------------------------

inline fn isComptime(val: anytype) bool {
    return @typeInfo(@TypeOf(.{val})).@"struct".fields[0].is_comptime;
}
