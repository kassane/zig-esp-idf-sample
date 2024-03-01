const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{
        .whitelist = espressif_targets,
        .default_target = espressif_targets[0],
    });
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "zig",
        .root_source_file = .{ .path = "lib.zig" },
        .target = target,
        .optimize = optimize,
    });
    lib.root_module.addAnonymousImport("esp_idf", .{
        .root_source_file = .{ .path = "idf-sys.zig" },
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

// Targets config
const espressif_targets: []const std.Target.Query = if (std.mem.startsWith(
    u8,
    @import("builtin").cpu.model.name,
    "esp32",
))
    &[_]std.Target.Query{
        // need zig-fork (using espressif-llvm backend) to support this
        .{
            .cpu_arch = .xtensa,
            .cpu_model = .{ .explicit = &std.Target.xtensa.cpu.esp32 },
            .os_tag = .freestanding,
            .abi = .none,
        },
        .{
            .cpu_arch = .xtensa,
            .cpu_model = .{ .explicit = &std.Target.xtensa.cpu.esp32s2 },
            .os_tag = .freestanding,
            .abi = .none,
        },
        .{
            .cpu_arch = .xtensa,
            .cpu_model = .{ .explicit = &std.Target.xtensa.cpu.esp32s3 },
            .os_tag = .freestanding,
            .abi = .none,
        },
    }
else
    &.{
        // esp32-c3/c2
        .{
            .cpu_arch = .riscv32,
            .cpu_model = .{ .explicit = &std.Target.riscv.cpu.generic_rv32 },
            .os_tag = .freestanding,
            .abi = .none,
            .cpu_features_add = std.Target.riscv.featureSet(&.{ .m, .c }),
        },
        // esp32-c6/61/h2
        .{
            .cpu_arch = .riscv32,
            .cpu_model = .{ .explicit = &std.Target.riscv.cpu.generic_rv32 },
            .os_tag = .freestanding,
            .abi = .none,
            .cpu_features_add = std.Target.riscv.featureSet(&.{ .m, .a, .c }),
        },
        // esp32-p4
        .{
            .cpu_arch = .riscv32,
            .cpu_model = .{ .explicit = &std.Target.riscv.cpu.generic_rv32 },
            .os_tag = .freestanding,
            .abi = .none,
            .cpu_features_add = std.Target.riscv.featureSet(&.{ .m, .a, .c, .f }),
        },
    };
