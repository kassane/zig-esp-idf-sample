const std = @import("std");

pub const Version = struct {
    major: ?u32 = 0,
    minor: ?u32 = 0,
    patch: ?u32 = 0,
    pub fn get() Version {
        var final_version: Version = .{};
        const idf_version = std.mem.span(@import("sys").esp_get_idf_version());

        if (!std.mem.startsWith(u8, idf_version, "v"))
            return final_version;

        var strip = std.mem.splitScalar(u8, idf_version, '-');
        var it = std.mem.tokenizeScalar(u8, strip.first(), '.');

        while (it.next()) |token| {
            // skip [0] == 'v'
            const digit = if (std.mem.startsWith(u8, token, "v"))
                std.fmt.parseUnsigned(u32, token[1..], 10) catch |err|
                    @panic(@errorName(err))
            else
                std.fmt.parseUnsigned(u32, token, 10) catch |err|
                    @panic(@errorName(err));

            if (final_version.major == 0) {
                final_version.major = digit;
            } else if (final_version.minor == 0) {
                final_version.minor = digit;
            } else if (final_version.patch == 0) {
                final_version.patch = digit;
            }
        }

        return final_version;
    }
    pub fn toString(self: Version, allocator: std.mem.Allocator) []const u8 {
        const idf_version = std.mem.span(@import("sys").esp_get_idf_version());

        // e.g.: v4.0.0 or commit-hash: g5d5f5c3
        if (!std.mem.startsWith(u8, idf_version, "v"))
            return idf_version
        else
            return std.fmt.allocPrint(allocator, "v{d}.{d}.{d}", .{
                self.major.?,
                self.minor.?,
                self.patch.?,
            }) catch |err|
                @panic(@errorName(err));
    }
};
