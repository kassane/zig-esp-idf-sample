const std = @import("std");

pub const Version = struct {
    major: u32 = 0,
    minor: u32 = 0,
    patch: u32 = 0,

    pub fn get() Version {
        var final_version: Version = .{};
        const idf_version = std.mem.span(@import("sys").esp_get_idf_version());

        if (!std.mem.startsWith(u8, idf_version, "v"))
            return final_version;

        // Strip any pre-release suffix (e.g. "v5.3.0-beta1" → "v5.3.0").
        var strip = std.mem.splitScalar(u8, idf_version, '-');
        var it = std.mem.tokenizeScalar(u8, strip.first(), '.');

        // Use a positional index (0=major, 1=minor, 2=patch) so that
        // version components with value 0 are parsed correctly.
        var field: u32 = 0;
        while (it.next()) |token| {
            const raw = if (std.mem.startsWith(u8, token, "v")) token[1..] else token;
            const digit = std.fmt.parseUnsigned(u32, raw, 10) catch break;
            switch (field) {
                0 => final_version.major = digit,
                1 => final_version.minor = digit,
                2 => final_version.patch = digit,
                else => break,
            }
            field += 1;
        }

        return final_version;
    }

    pub fn toString(self: Version, allocator: std.mem.Allocator) []const u8 {
        const idf_version = std.mem.span(@import("sys").esp_get_idf_version());

        // Return the raw string for non-release builds (e.g. commit hashes).
        if (!std.mem.startsWith(u8, idf_version, "v"))
            return idf_version;

        return std.fmt.allocPrint(allocator, "v{d}.{d}.{d}", .{
            self.major,
            self.minor,
            self.patch,
        }) catch |err| @panic(@errorName(err));
    }
};
