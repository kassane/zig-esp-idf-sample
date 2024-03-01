const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "zig",
        .root_source_file = .{ .path = "lib.zig" },
        .target = target,
        .optimize = optimize,
    });
    var env = std.process.EnvMap.init(b.allocator);
    defer env.deinit();
    if (env.get("INCLUDE_DIRS")) |include_dirs| {
        var it = std.mem.tokenize(u8, include_dirs, ";");
        while (it.next()) |dir| {
            lib.addIncludePath(.{ .path = dir });
        }
    }
    lib.linkLibC();
    b.installArtifact(lib);
}