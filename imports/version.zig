pub const Version = struct {
    major: ?u32 = null,
    minor: ?u32 = null,
    patch: ?u32 = null,
    pub fn get() Version {
        var final_version: Version = .{
            .major = 0,
            .minor = 0,
            .patch = 0,
        };
        const idf_version = std.mem.span(@import("sys").esp_get_idf_version());

        if (!std.mem.startsWith(u8, idf_version, "v"))
            return final_version;

        // skip [0] == 'v' and remove [idf_version.len - 4] == "-dev"
        var it = if (std.mem.endsWith(u8, idf_version, "-dev"))
            std.mem.split(u8, idf_version[1 .. idf_version.len - 4], ".")
        else
            std.mem.split(u8, idf_version[1..], ".");

        final_version.major = std.fmt.parseUnsigned(u32, it.first(), 10) catch |err|
            @panic(@errorName(err));

        while (it.next()) |token| {
            if (!std.ascii.isDigit(token[0]))
                continue;
            const digit = std.fmt.parseUnsigned(u32, token, 10) catch |err|
                @panic(@errorName(err));
            final_version.minor = digit;
            if (digit != final_version.minor)
                final_version.patch = digit;
        }

        return final_version;
    }
    pub fn toString(self: Version, allocator: std.mem.Allocator) []const u8 {
        const idf_version = std.mem.span(@import("sys").esp_get_idf_version());

        // e.g.: v4.0.0 or commit-hash: g5d5f5c3
        if (!std.mem.startsWith(u8, idf_version, "v"))
            return idf_version
        else
            return std.fmt.allocPrint(allocator, "{d}.{d}.{d}", .{
                self.major.?,
                self.minor.?,
                self.patch.?,
            }) catch |err|
                @panic(@errorName(err));
    }
    const std = @import("std");
};
