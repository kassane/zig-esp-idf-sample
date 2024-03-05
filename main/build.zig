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
    lib.root_module.addAnonymousImport("esp_idf", .{
        .root_source_file = .{ .path = "idf-sys.zig" },
    });

    const include_dirs = try std.process.getEnvVarOwned(b.allocator, "INCLUDE_DIRS");
    var it_inc = std.mem.tokenize(u8, include_dirs, ";");
    while (it_inc.next()) |dir| {
        lib.addSystemIncludePath(.{ .path = dir });
    }

    // inline for (esp_libs) |libname| {
    //     lib.addObjectFile(.{ .path = libname });
    // }

    const home_dir = try std.process.getEnvVarOwned(b.allocator, "HOME");
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
    lib.linkLibC();
    b.installArtifact(lib);
}

// Targets config
const espressif_targets: []const std.Target.Query = if (isEsp())
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

fn isEsp() bool {
    var result = false;
    for (std.Target.Cpu.Arch.xtensa.allCpuModels()) |model| {
        result = std.mem.startsWith(u8, model.name, "esp");
        if (result) break;
    }
    return result;
}

const esp_libs = &.{
    "../build/bootloader/esp-idf/soc/libsoc.a",
    "../build/bootloader/esp-idf/micro-ecc/libmicro-ecc.a",
    "../build/bootloader/esp-idf/hal/libhal.a",
    "../build/bootloader/esp-idf/spi_flash/libspi_flash.a",
    "../build/bootloader/esp-idf/esp_bootloader_format/libesp_bootloader_format.a",
    "../build/bootloader/esp-idf/bootloader_support/libbootloader_support.a",
    "../build/bootloader/esp-idf/efuse/libefuse.a",
    "../build/bootloader/esp-idf/esp_system/libesp_system.a",
    "../build/bootloader/esp-idf/esp_hw_support/libesp_hw_support.a",
    "../build/bootloader/esp-idf/esp_common/libesp_common.a",
    "../build/bootloader/esp-idf/esp_rom/libesp_rom.a",
    "../build/bootloader/esp-idf/log/liblog.a",
    "../build/bootloader/esp-idf/main/libmain.a",
    if (isEsp())
        "../build/esp-idf/riscv/libxtensa.a"
    else
        "../build/esp-idf/riscv/libriscv.a",
    "../build/esp-idf/esp_driver_gpio/libesp_driver_gpio.a",
    "../build/esp-idf/esp_pm/libesp_pm.a",
    "../build/esp-idf/mbedtls/mbedtls/3rdparty/everest/libeverest.a",
    "../build/esp-idf/mbedtls/mbedtls/3rdparty/p256-m/libp256m.a",
    "../build/esp-idf/mbedtls/mbedtls/library/libmbedtls.a",
    "../build/esp-idf/mbedtls/mbedtls/library/libmbedx509.a",
    "../build/esp-idf/mbedtls/mbedtls/library/libmbedcrypto.a",
    "../build/esp-idf/mbedtls/libmbedtls.a",
    "../build/esp-idf/efuse/libefuse.a",
    "../build/esp-idf/esp_bootloader_format/libesp_bootloader_format.a",
    "../build/esp-idf/esp_app_format/libesp_app_format.a",
    "../build/esp-idf/bootloader_support/libbootloader_support.a",
    "../build/esp-idf/esp_partition/libesp_partition.a",
    "../build/esp-idf/app_update/libapp_update.a",
    "../build/esp-idf/esp_mm/libesp_mm.a",
    "../build/esp-idf/spi_flash/libspi_flash.a",
    "../build/esp-idf/esp_system/libesp_system.a",
    "../build/esp-idf/esp_common/libesp_common.a",
    "../build/esp-idf/esp_rom/libesp_rom.a",
    "../build/esp-idf/hal/libhal.a",
    "../build/esp-idf/log/liblog.a",
    "../build/esp-idf/heap/libheap.a",
    "../build/esp-idf/soc/libsoc.a",
    "../build/esp-idf/esp_hw_support/libesp_hw_support.a",
    "../build/esp-idf/freertos/libfreertos.a",
    "../build/esp-idf/newlib/libnewlib.a",
    "../build/esp-idf/pthread/libpthread.a",
    "../build/esp-idf/cxx/libcxx.a",
    "../build/esp-idf/esp_timer/libesp_timer.a",
    "../build/esp-idf/esp_driver_gptimer/libesp_driver_gptimer.a",
    "../build/esp-idf/esp_ringbuf/libesp_ringbuf.a",
    "../build/esp-idf/esp_driver_uart/libesp_driver_uart.a",
    "../build/esp-idf/app_trace/libapp_trace.a",
    "../build/esp-idf/esp_event/libesp_event.a",
    "../build/esp-idf/nvs_flash/libnvs_flash.a",
    "../build/esp-idf/esp_driver_spi/libesp_driver_spi.a",
    "../build/esp-idf/esp_driver_i2s/libesp_driver_i2s.a",
    "../build/esp-idf/sdmmc/libsdmmc.a",
    "../build/esp-idf/esp_driver_sdspi/libesp_driver_sdspi.a",
    "../build/esp-idf/esp_driver_rmt/libesp_driver_rmt.a",
    "../build/esp-idf/esp_driver_tsens/libesp_driver_tsens.a",
    "../build/esp-idf/esp_driver_sdm/libesp_driver_sdm.a",
    "../build/esp-idf/esp_driver_i2c/libesp_driver_i2c.a",
    "../build/esp-idf/esp_driver_ledc/libesp_driver_ledc.a",
    "../build/esp-idf/esp_driver_usb_serial_jtag/libesp_driver_usb_serial_jtag.a",
    "../build/esp-idf/driver/libdriver.a",
    "../build/esp-idf/esp_phy/libesp_phy.a",
    "../build/esp-idf/vfs/libvfs.a",
    "../build/esp-idf/lwip/liblwip.a",
    "../build/esp-idf/esp_netif/libesp_netif.a",
    "../build/esp-idf/wpa_supplicant/libwpa_supplicant.a",
    "../build/esp-idf/esp_coex/libesp_coex.a",
    "../build/esp-idf/esp_wifi/libesp_wifi.a",
    "../build/esp-idf/unity/libunity.a",
    "../build/esp-idf/cmock/libcmock.a",
    "../build/esp-idf/console/libconsole.a",
    "../build/esp-idf/http_parser/libhttp_parser.a",
    "../build/esp-idf/esp-tls/libesp-tls.a",
    "../build/esp-idf/esp_adc/libesp_adc.a",
    "../build/esp-idf/esp_driver_cam/libesp_driver_cam.a",
    "../build/esp-idf/esp_eth/libesp_eth.a",
    "../build/esp-idf/esp_gdbstub/libesp_gdbstub.a",
    "../build/esp-idf/esp_hid/libesp_hid.a",
    "../build/esp-idf/tcp_transport/libtcp_transport.a",
    "../build/esp-idf/esp_http_client/libesp_http_client.a",
    "../build/esp-idf/esp_http_server/libesp_http_server.a",
    "../build/esp-idf/esp_https_ota/libesp_https_ota.a",
    "../build/esp-idf/esp_https_server/libesp_https_server.a",
    "../build/esp-idf/esp_lcd/libesp_lcd.a",
    "../build/esp-idf/protobuf-c/libprotobuf-c.a",
    "../build/esp-idf/protocomm/libprotocomm.a",
    "../build/esp-idf/esp_local_ctrl/libesp_local_ctrl.a",
    "../build/esp-idf/espcoredump/libespcoredump.a",
    "../build/esp-idf/wear_levelling/libwear_levelling.a",
    "../build/esp-idf/fatfs/libfatfs.a",
    "../build/esp-idf/json/libjson.a",
    "../build/esp-idf/mqtt/libmqtt.a",
    "../build/esp-idf/nvs_sec_provider/libnvs_sec_provider.a",
    "../build/esp-idf/spiffs/libspiffs.a",
    "../build/esp-idf/wifi_provisioning/libwifi_provisioning.a",
    "../build/esp-idf/main/libmain.a",
};
