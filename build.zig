const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{
        .whitelist = espressif_targets,
        .default_target = espressif_targets[0],
    });
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addLibrary(.{
        .name = "app_zig",
        .root_module = b.createModule(.{
            .root_source_file = b.path("main/app.zig"),
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
    });
    lib.root_module.addImport("esp_idf", idf_wrapped_modules(b));

    b.installArtifact(lib);
}

pub fn idf_wrapped_modules(b: *std.Build) *std.Build.Module {
    const src_path = std.fs.path.dirname(@src().file) orelse b.pathResolve(&.{"."});
    const sys = b.addModule("sys", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "idf-sys.zig",
        })),
    });
    const rtos = b.addModule("rtos", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "rtos.zig",
        })),
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const version = b.addModule("ver", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "version.zig",
        })),
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const log = b.addModule("log", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "logger.zig",
        })),
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const panic = b.addModule("panic", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "panic.zig",
        })),
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
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "led-strip.zig",
        })),
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const bootloader = b.addModule("bootloader", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "bootloader.zig",
        })),
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const errors = b.addModule("error", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "error.zig",
        })),
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const lwip = b.addModule("lwip", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "lwip.zig",
        })),
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const mqtt = b.addModule("mqtt", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "mqtt.zig",
        })),
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const heap = b.addModule("heap", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "heap.zig",
        })),
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const http = b.addModule("http", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "http.zig",
        })),
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
    const pcnt = b.addModule("pulse", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "pcnt.zig",
        })),
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
    const bt = b.addModule("bluetooth", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "bluetooth.zig",
        })),
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const wifi = b.addModule("wifi", .{ .root_source_file = b.path(b.pathJoin(&.{
        src_path,
        "imports",
        "wifi.zig",
    })), .imports = &.{
        .{
            .name = "sys",
            .module = sys,
        },
        .{
            .name = "error",
            .module = errors,
        },
    } });
    //-- To pull in sdkconfig.h
    wifi.addIncludePath(.{
        .cwd_relative = b.pathJoin(&.{ src_path, "build", "config" }),
    });
    // If building via cmake for sdkconfig
    wifi.addIncludePath(.{
        .cwd_relative = b.pathJoin(&.{ "..", "build", "config" }),
    });
    const gpio = b.addModule("gpio", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "gpio.zig",
        })),
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
    const uart = b.addModule("uart", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "uart.zig",
        })),
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
    const i2c = b.addModule("i2c", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "i2c.zig",
        })),
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
    const i2s = b.addModule("i2s", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "i2s.zig",
        })),
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
    const spi = b.addModule("spi", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "spi.zig",
        })),
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
    const phy = b.addModule("phy", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "phy.zig",
        })),
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const segger = b.addModule("segger", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "segger.zig",
        })),
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const dsp = b.addModule("dsp", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "dsp.zig",
        })),
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    const crc = b.addModule("crc", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "crc.zig",
        })),
        .imports = &.{
            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
    return b.addModule("esp_idf", .{
        .root_source_file = b.path(b.pathJoin(&.{
            src_path,
            "imports",
            "idf.zig",
        })),
        .imports = &.{
            .{
                .name = "led",
                .module = led,
            },
            .{
                .name = "crc",
                .module = crc,
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
                .name = "uart",
                .module = uart,
            },
            .{
                .name = "i2c",
                .module = i2c,
            },
            .{
                .name = "i2s",
                .module = i2s,
            },
            .{
                .name = "phy",
                .module = phy,
            },
            .{
                .name = "spi",
                .module = spi,
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
            .{
                .name = "dsp",
                .module = dsp,
            },
            .{
                .name = "segger",
                .module = segger,
            },
            .{
                .name = "http",
                .module = http,
            },
            .{
                .name = "pulse",
                .module = pcnt,
            },

            .{
                .name = "sys",
                .module = sys,
            },
        },
    });
}

// Targets config
pub const espressif_targets: []const std.Target.Query = if (isEspXtensa())
    xtensa_targets ++ riscv_targets
else
    riscv_targets;

const riscv_targets = blk: {
    const targets: []const std.Target.Query = &[_]std.Target.Query{
        // esp32-c3/c2
        .{
            .cpu_arch = .riscv32,
            .cpu_model = .{ .explicit = &std.Target.riscv.cpu.generic_rv32 },
            .os_tag = .freestanding,
            .abi = .none,
            .cpu_features_add = std.Target.riscv.featureSet(&.{ .m, .c, .zifencei, .zicsr }),
        },
        // esp32-c6/61/h2
        .{
            .cpu_arch = .riscv32,
            .cpu_model = .{ .explicit = &std.Target.riscv.cpu.generic_rv32 },
            .os_tag = .freestanding,
            .abi = .none,
            .cpu_features_add = std.Target.riscv.featureSet(&.{ .m, .a, .c, .zifencei, .zicsr }),
        },
        // .{
        //     .cpu_arch = .riscv32,
        //     .cpu_model = .{ .explicit = &std.Target.riscv.cpu.esp32p4 },
        //     .os_tag = .freestanding,
        //     .abi = .eabihf,
        //     .cpu_features_sub = std.Target.riscv.featureSet(&.{ .zca, .zcb, .zcmt, .zcmp }),
        // },
    };

    if (@hasDecl(std.Target.riscv.cpu, "esp32p4")) {
        break :blk targets ++ &[_]std.Target.Query{
            .{
                .cpu_arch = .riscv32,
                .cpu_model = .{ .explicit = &std.Target.riscv.cpu.esp32p4 },
                .os_tag = .freestanding,
                .abi = .eabihf,
                .cpu_features_sub = std.Target.riscv.featureSet(&.{ .zca, .zcb, .zcmt, .zcmp }),
            },
        };
    }

    break :blk targets;
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
