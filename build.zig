const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{
        .whitelist = espressif_targets,
        .default_target = espressif_targets[0],
    });
    const optimize = b.standardOptimizeOption(.{});

    const obj = b.addObject(.{
        .name = "app_zig",
        .root_module = b.createModule(.{
            .root_source_file = b.path("main/app.zig"),
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
    });
    obj.root_module.addImport("esp_idf", idf_wrapped_modules(b));

    const obj_install = b.addInstallArtifact(obj, .{
        .dest_dir = .{
            .override = .{
                .custom = "obj",
            },
        },
    });
    b.getInstallStep().dependOn(&obj_install.step);
}

// ---------------------------------------------------------------------------
// Module descriptor table
//
// To add a new module:
//   1. Add a row here with the .zig source file and any deps by name.
//   2. Add the name to the `esp_idf` entry's deps list if it should be
//      re-exported through the top-level "esp_idf" namespace module.
//
// To add a new dependency inside an existing .zig source file:
//   1. Add the dep name to the matching row's `deps` field here.
//   That is the *only* place you need to edit — no other blocks to touch.
// ---------------------------------------------------------------------------
const ModuleSpec = struct {
    /// Name used for @import("…") and as the key in the resolver map.
    name: []const u8,
    /// Path relative to the `imports/` directory.
    file: []const u8,
    /// Names of other modules (must appear earlier in this table).
    deps: []const []const u8 = &.{},
};

/// Ordered list — a module may only reference deps that appear before it.
const module_specs = [_]ModuleSpec{
    // ── leaf (no deps) ──────────────────────────────────────────────────
    .{ .name = "sys", .file = "idf-sys.zig" },
    // ── depend on sys only ──────────────────────────────────────────────
    .{ .name = "error", .file = "error.zig", .deps = &.{"sys"} },
    .{ .name = "log", .file = "logger.zig", .deps = &.{"sys"} },
    .{ .name = "ver", .file = "version.zig", .deps = &.{"sys"} },
    .{ .name = "heap", .file = "heap.zig", .deps = &.{"sys"} },
    .{ .name = "bootloader", .file = "bootloader.zig", .deps = &.{"sys"} },
    .{ .name = "lwip", .file = "lwip.zig", .deps = &.{"sys"} },
    .{ .name = "mqtt", .file = "mqtt.zig", .deps = &.{"sys"} },
    .{ .name = "phy", .file = "phy.zig", .deps = &.{"sys"} },
    .{ .name = "segger", .file = "segger.zig", .deps = &.{"sys"} },
    .{ .name = "crc", .file = "crc.zig", .deps = &.{"sys"} },
    .{ .name = "bluetooth", .file = "bluetooth.zig", .deps = &.{"sys"} },
    // ── depend on sys + error ───────────────────────────────────────────
    .{ .name = "led", .file = "led-strip.zig", .deps = &.{ "sys", "error" } },
    .{ .name = "wifi", .file = "wifi.zig", .deps = &.{ "sys", "error" } },
    .{ .name = "gpio", .file = "gpio.zig", .deps = &.{ "sys", "error" } },
    .{ .name = "uart", .file = "uart.zig", .deps = &.{ "sys", "error" } },
    .{ .name = "i2c", .file = "i2c.zig", .deps = &.{ "sys", "error" } },
    .{ .name = "i2s", .file = "i2s.zig", .deps = &.{ "sys", "error" } },
    .{ .name = "spi", .file = "spi.zig", .deps = &.{ "sys", "error" } },
    .{ .name = "now", .file = "now.zig", .deps = &.{ "sys", "error" } },
    .{ .name = "pulse", .file = "pcnt.zig", .deps = &.{ "sys", "error" } },
    .{ .name = "http", .file = "http.zig", .deps = &.{ "sys", "error" } },
    .{ .name = "dsp", .file = "dsp.zig", .deps = &.{ "sys", "error" } },
    // ── depend on sys + log (+ optionally error) ────────────────────────
    .{ .name = "panic", .file = "panic.zig", .deps = &.{ "sys", "log" } },
    // ── depend on sys + error (rtos now also uses error — just add it) ──
    .{ .name = "rtos", .file = "rtos.zig", .deps = &.{ "sys", "error" } },
};

/// Names re-exported by the top-level "esp_idf" umbrella module (idf.zig).
const esp_idf_exports = [_][]const u8{
    "sys",  "error",  "log", "ver",       "heap",  "bootloader", "lwip", "mqtt",
    "phy",  "segger", "crc", "bluetooth", "led",   "wifi",       "gpio", "uart",
    "i2c",  "i2s",    "spi", "now",       "pulse", "http",       "dsp",  "panic",
    "rtos",
};

pub fn idf_wrapped_modules(b: *std.Build) *std.Build.Module {
    const src_path = std.fs.path.dirname(@src().file) orelse b.pathResolve(&.{"."});
    const imports_dir = b.pathJoin(&.{ src_path, "imports" });

    // Build a name → *Module map so deps can be looked up by name.
    var map = std.StringHashMap(*std.Build.Module).init(b.allocator);
    defer map.deinit();

    inline for (module_specs) |spec| {
        // Collect this module's imports from the already-resolved map.
        var imports: std.ArrayList(std.Build.Module.Import) = .empty;
        defer imports.deinit(b.allocator);

        inline for (spec.deps) |dep_name| {
            const dep_mod = map.get(dep_name) orelse
                @panic("dep '" ++ dep_name ++ "' not yet resolved — check ordering in module_specs");
            imports.append(b.allocator, .{ .name = dep_name, .module = dep_mod }) catch @panic("OOM");
        }

        const mod = b.addModule(spec.name, .{
            .root_source_file = b.path(b.pathJoin(&.{ imports_dir, spec.file })),
            .imports = imports.items,
        });
        map.put(spec.name, mod) catch @panic("OOM");
    }

    // Build the esp_idf umbrella module's import list.
    var top_imports: std.ArrayList(std.Build.Module.Import) = .empty;
    defer top_imports.deinit(b.allocator);

    inline for (esp_idf_exports) |name| {
        const mod = map.get(name) orelse
            @panic("export '" ++ name ++ "' not found in module_specs");
        top_imports.append(b.allocator, .{ .name = name, .module = mod }) catch @panic("OOM");
    }

    return b.addModule("esp_idf", .{
        .root_source_file = b.path(b.pathJoin(&.{ imports_dir, "idf.zig" })),
        .imports = top_imports.items,
    });
}

pub const espressif_targets: []const std.Target.Query =
    if (hasEspXtensaSupport()) riscv_targets ++ xtensa_targets else riscv_targets;

const riscv_targets: []const std.Target.Query = blk: {
    const base_targets = &[_]std.Target.Query{
        .{
            .cpu_arch = .riscv32,
            .cpu_model = .{ .explicit = &std.Target.riscv.cpu.generic_rv32 },
            .os_tag = .freestanding,
            .abi = .none,
            .cpu_features_add = std.Target.riscv.featureSet(&.{ .m, .c, .zifencei, .zicsr }),
        },
        .{
            .cpu_arch = .riscv32,
            .cpu_model = .{ .explicit = &std.Target.riscv.cpu.generic_rv32 },
            .os_tag = .freestanding,
            .abi = .none,
            .cpu_features_add = std.Target.riscv.featureSet(&.{ .m, .a, .c, .zifencei, .zicsr }),
        },
    };

    const has_h4 = @hasDecl(std.Target.riscv.cpu, "esp32h4");
    const has_p4 = @hasDecl(std.Target.riscv.cpu, "esp32p4");

    var result: []const std.Target.Query = base_targets;

    if (has_h4) {
        // ESP32-H4: Requires Espressif LLVM fork
        const esp32h4_target = &[_]std.Target.Query{.{
            .cpu_arch = .riscv32,
            .cpu_model = .{ .explicit = &std.Target.riscv.cpu.esp32h4 },
            .os_tag = .freestanding,
            .abi = .eabihf,
        }};
        result = result ++ esp32h4_target;
    }

    if (has_p4) {
        // ESP32-P4: Requires Espressif LLVM fork
        const esp32p4_target = &[_]std.Target.Query{.{
            .cpu_arch = .riscv32,
            .cpu_model = .{ .explicit = &std.Target.riscv.cpu.esp32p4 },
            .os_tag = .freestanding,
            .abi = .eabihf,
            .cpu_features_sub = std.Target.riscv.featureSet(&.{ .zca, .zcb, .zcmt, .zcmp }),
        }};
        result = result ++ esp32p4_target;
    }

    break :blk result;
};

const xtensa_targets: []const std.Target.Query = &.{
    // ESP32: Requires Espressif LLVM fork
    .{
        .cpu_arch = .xtensa,
        .cpu_model = .{ .explicit = &std.Target.xtensa.cpu.esp32 },
        .os_tag = .freestanding,
        .abi = .none,
    },
    // ESP32-S2: Requires Espressif LLVM fork
    .{
        .cpu_arch = .xtensa,
        .cpu_model = .{ .explicit = &std.Target.xtensa.cpu.esp32s2 },
        .os_tag = .freestanding,
        .abi = .none,
    },
    // ESP32-S3: Requires Espressif LLVM fork
    .{
        .cpu_arch = .xtensa,
        .cpu_model = .{ .explicit = &std.Target.xtensa.cpu.esp32s3 },
        .os_tag = .freestanding,
        .abi = .none,
    },
};

/// Checks if the Zig compiler has Espressif Xtensa support enabled
fn hasEspXtensaSupport() bool {
    for (std.Target.Cpu.Arch.xtensa.allCpuModels()) |model| {
        if (std.mem.startsWith(u8, model.name, "esp")) return true;
    }
    return false;
}
