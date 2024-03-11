const std = @import("std");

pub fn build(b: *std.Build) !void {
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
    lib.root_module.addImport("esp_idf", modules(b));

    const include_dirs = std.process.getEnvVarOwned(b.allocator, "INCLUDE_DIRS") catch "";
    if (!std.mem.eql(u8, include_dirs, "")) {
        var it_inc = std.mem.tokenize(u8, include_dirs, ";");
        while (it_inc.next()) |dir| {
            lib.addSystemIncludePath(.{ .path = dir });
        }
    }

    const home_dir = std.process.getEnvVarOwned(b.allocator, "HOME") catch "";
    if (!std.mem.eql(u8, home_dir, "")) {
        const archtools = b.fmt("{s}-esp-elf", .{
            @tagName(lib.rootModuleTarget().cpu.arch),
        });

        lib.addSystemIncludePath(.{ .path = b.pathJoin(&.{
            home_dir,
            ".espressif",
            "tools",
            archtools,
            "esp-13.2.0_20230928",
            archtools,
            "include",
        }) });
        lib.addSystemIncludePath(.{ .path = b.pathJoin(&.{
            home_dir,
            ".espressif",
            "tools",
            archtools,
            "esp-13.2.0_20230928",
            archtools,
            archtools,
            "sys-include",
        }) });
        lib.addSystemIncludePath(.{
            .path = b.pathJoin(&.{
                home_dir,
                ".espressif",
                "tools",
                archtools,
                "esp-13.2.0_20230928",
                archtools,
                archtools,
                "include",
            }),
        });
        lib.addLibraryPath(.{
            .path = b.pathJoin(&.{
                home_dir,
                ".espressif",
                "tools",
                archtools,
                "esp-13.2.0_20230928",
                archtools,
                archtools,
                "lib",
            }),
        });
        lib.addLibraryPath(.{
            .path = b.pathJoin(&.{
                home_dir,
                ".espressif",
                "tools",
                archtools,
                "esp-13.2.0_20230928",
                archtools,
                "lib",
            }),
        });
    }
    lib.linkLibC();
    b.installArtifact(lib);
}

fn modules(b: *std.Build) *std.Build.Module {
    const led = b.addModule("led", .{
        .root_source_file = .{
            .path = "led-strip.zig",
        },
    });
    const idf = b.addModule("esp_idf", .{
        .root_source_file = .{
            .path = "idf-sys.zig",
        },
        .imports = &.{
            .{
                .name = "led",
                .module = led,
            },
        },
    });
    return idf;
}

// Targets config
const espressif_targets: []const std.Target.Query = if (isEspXtensa())
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

fn isEspXtensa() bool {
    var result = false;
    for (std.Target.Cpu.Arch.xtensa.allCpuModels()) |model| {
        result = std.mem.startsWith(u8, model.name, "esp");
        if (result) break;
    }
    return result;
}
