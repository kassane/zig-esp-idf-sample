const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{
        .whitelist = espressif_targets,
        .default_target = espressif_targets[0],
    });
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "zig",
        // comment or remove .root_source_file, make null value for module detection
        .root_source_file = .{ .path = "main/lib.zig" },
        .target = target,
        .optimize = optimize,
    });

    // https://github.com/kassane/zig-esp-idf-sample/issues/3
    // led_strip_component(lib);

    // if detect zig root_source_file, enable zig modules (or use c/c++ files)
    if (lib.root_module.root_source_file != null) {
        lib.root_module.addImport("esp_idf", idf_wrapped_modules(b));
        lib.linkLibC(); // stubs for libc
    } else {
        // For C and/or C++ files (using clang/clang++)
        lib.addCSourceFiles(.{
            .files = &.{
                "main/lib.cc",
            },
            .flags = &.{
                "-Wall",
                "-Wextra",
                "-Wpedantic",
                "-fno-threadsafe-statics",
                "-std=c++23",
                "-ffreestanding",
                "-fexperimental-library",
            },
        });
        lib.defineCMacro("_LIBCPP_HAS_NO_THREADS", null);
        lib.defineCMacro("_LIBCPP_HAS_NO_LOCALIZATION", null);
        // lib.defineCMacro("_LIBCPP_HAS_NO_WIDE_CHARACTERS", null);
        // lib.defineCMacro("_LIBCPP_HAS_NO_FILESYSTEM", null);
        // lib.defineCMacro("_LIBCPP_HAS_NO_RANDOM_DEVICE", null);
        lib.defineCMacro("_LIBCPP_FREESTANDING", null);

        // static linking (libc++ + libunwind + libc++abi) + libc
        lib.linkLibCpp();
    }

    try includeDeps(b, lib);
    b.installArtifact(lib);
}

fn includeDeps(b: *std.Build, lib: *std.Build.Step.Compile) !void {
    const include_dirs = std.process.getEnvVarOwned(b.allocator, "INCLUDE_DIRS") catch "";
    if (!std.mem.eql(u8, include_dirs, "")) {
        var it_inc = std.mem.tokenize(u8, include_dirs, ";");
        while (it_inc.next()) |dir| {
            lib.addIncludePath(.{ .path = dir });
        }
    }

    const idf_path = std.process.getEnvVarOwned(b.allocator, "IDF_PATH") catch "";
    if (!std.mem.eql(u8, idf_path, "")) {
        try searched_idf_include(b, lib, idf_path);
        try searched_idf_libs(b, lib);
    }

    const home_dir = std.process.getEnvVarOwned(b.allocator, "HOME") catch "";
    if (!std.mem.eql(u8, home_dir, "")) {
        const archtools = b.fmt("{s}-esp-elf", .{
            @tagName(lib.rootModuleTarget().cpu.arch),
        });

        lib.addIncludePath(.{ .path = b.pathJoin(&.{
            home_dir,
            ".espressif",
            "tools",
            archtools,
            "esp-13.2.0_20230928",
            archtools,
            "include",
        }) });
        lib.addIncludePath(.{ .path = b.pathJoin(&.{
            home_dir,
            ".espressif",
            "tools",
            archtools,
            "esp-13.2.0_20230928",
            archtools,
            archtools,
            "sys-include",
        }) });
        lib.addIncludePath(.{
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
    }
    lib.addIncludePath(.{ .path = "include" });
}

fn led_strip_component(lib: *std.Build.Step.Compile) void {
    lib.addIncludePath(.{
        .cwd_relative = "../managed_components/espressif__led_strip/include",
    });
    lib.addIncludePath(.{
        .cwd_relative = "../managed_components/espressif__led_strip/interface",
    });
    lib.addCSourceFiles(.{
        .root = .{ .cwd_relative = "../managed_components/espressif__led_strip/src" },
        .files = &.{
            "led_strip_api.c",
            "led_strip_rmt_encoder.c",
            "led_strip_rmt_dev.c",
            "led_strip_spi_dev.c",
        },
        .flags = &.{},
    });
}

pub fn searched_idf_libs(b: *std.Build, lib: *std.Build.Step.Compile) !void {
    var dir = try std.fs.cwd().openDir("../build", .{
        .iterate = true,
    });
    defer dir.close();
    var walker = try dir.walk(b.allocator);
    defer walker.deinit();

    while (try walker.next()) |entry| {
        const ext = std.fs.path.extension(entry.basename);
        const lib_ext = inline for (&.{".obj"}) |e| {
            if (std.mem.eql(u8, ext, e))
                break true;
        } else false;
        if (lib_ext) {
            const src_path = std.fs.path.dirname(@src().file).?;
            const cwd_path = b.pathJoin(&.{ src_path, "build", b.dupe(entry.path) });
            const lib_file: std.Build.LazyPath = .{ .path = cwd_path };
            lib.addObjectFile(lib_file);
        }
    }
}

pub fn searched_idf_include(b: *std.Build, lib: *std.Build.Step.Compile, idf_path: []const u8) !void {
    const comp = b.pathJoin(&.{ idf_path, "components" });
    var dir = try std.fs.cwd().openDir(comp, .{
        .iterate = true,
    });
    defer dir.close();
    var walker = try dir.walk(b.allocator);
    defer walker.deinit();

    while (try walker.next()) |entry| {
        const ext = std.fs.path.extension(entry.basename);
        const include_file = inline for (&.{".h"}) |e| {
            if (std.mem.eql(u8, ext, e))
                break true;
        } else false;
        if (include_file) {
            const include_dir = b.pathJoin(&.{ comp, std.fs.path.dirname(b.dupe(entry.path)).? });
            lib.addIncludePath(.{ .path = include_dir });
        }
    }
}

pub fn idf_wrapped_modules(b: *std.Build) *std.Build.Module {
    const sys = b.addModule("sys", .{
        .root_source_file = .{
            .path = "imports/idf-sys.zig",
        },
    });
    const rtos = b.addModule("rtos", .{
        .root_source_file = .{
            .path = "imports/rtos.zig",
        },
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const version = b.addModule("ver", .{
        .root_source_file = .{
            .path = "imports/version.zig",
        },
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const log = b.addModule("log", .{
        .root_source_file = .{
            .path = "imports/logger.zig",
        },
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const panic = b.addModule("panic", .{
        .root_source_file = .{
            .path = "imports/panic.zig",
        },
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
            .{
                .name = "log",
                .module = log,
            },
        },
    });
    const led = b.addModule("led", .{
        .root_source_file = .{
            .path = "imports/led-strip.zig",
        },
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const bootloader = b.addModule("bootloader", .{
        .root_source_file = .{
            .path = "imports/bootloader.zig",
        },
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const lwip = b.addModule("lwip", .{
        .root_source_file = .{
            .path = "imports/lwip.zig",
        },
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const mqtt = b.addModule("mqtt", .{
        .root_source_file = .{
            .path = "imports/mqtt.zig",
        },
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const heap = b.addModule("heap", .{
        .root_source_file = .{
            .path = "imports/heap.zig",
        },
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const bt = b.addModule("bluetooth", .{
        .root_source_file = .{
            .path = "imports/bluetooth.zig",
        },
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const wifi = b.addModule("wifi", .{
        .root_source_file = .{
            .path = "imports/wifi.zig",
        },
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const errors = b.addModule("error", .{
        .root_source_file = .{
            .path = "imports/error.zig",
        },
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const gpio = b.addModule("gpio", .{
        .root_source_file = .{
            .path = "imports/gpio.zig",
        },
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
            .{
                .name = "error",
                .module = errors,
            },
        },
    });
    return b.addModule("esp_idf", .{
        .root_source_file = .{
            .path = "imports/idf.zig",
        },
        .imports = &.{
            .{
                .name = "led",
                .module = led,
            },
            .{
                .name = "bootloader",
                .module = bootloader,
            },
            .{
                .name = "rtos",
                .module = rtos,
            },
            .{
                .name = "ver",
                .module = version,
            },
            .{
                .name = "lwip",
                .module = lwip,
            },
            .{
                .name = "mqtt",
                .module = mqtt,
            },
            .{
                .name = "panic",
                .module = panic,
            },
            .{
                .name = "log",
                .module = log,
            },
            .{
                .name = "heap",
                .module = heap,
            },
            .{
                .name = "gpio",
                .module = gpio,
            },
            .{
                .name = "error",
                .module = errors,
            },
            .{
                .name = "wifi",
                .module = wifi,
            },
            .{
                .name = "bluetooth",
                .module = bt,
            },
        },
    });
}

// Targets config
const espressif_targets: []const std.Target.Query = if (isEspXtensa())
    xtensa_targets ++ riscv_targets
else
    riscv_targets;

const riscv_targets = &[_]std.Target.Query{
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
        .abi = .eabihf,
        .cpu_features_add = std.Target.riscv.featureSet(&.{ .m, .a, .c, .f }),
    },
};
const xtensa_targets = &[_]std.Target.Query{
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
};

fn isEspXtensa() bool {
    var result = false;
    for (std.Target.Cpu.Arch.xtensa.allCpuModels()) |model| {
        result = std.mem.startsWith(u8, model.name, "esp");
        if (result) break;
    }
    return result;
}
