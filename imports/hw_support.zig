const sys = @import("sys");

/// Rewrite of C-code in: esp-idf/components/esp_hw_support/include
///
/// In particular, functions with FORCE_INLINE_ATTR and inlined assembly
/// that cannot be translated or linked-to by translate-C.
pub const cpu = struct {
    /// Get the current core's ID
    ///
    /// This function will return the ID of the current CPU (i.e., the CPU that calls this function).
    /// Port of esp-idf `esp_cpu_get_core_id()`
    pub inline fn getCoreId() u1 {
        if (sys.CONFIG_SOC_CPU_CORES_NUM == 1) {
            return 0;
        }

        if (@hasDecl(sys, "CONFIG_IDF_TARGET_ARCH_XTENSA")) {
            return @intCast(xt_utils_get_core_id());
        } else if (@hasDecl(sys, "CONFIG_IDF_TARGET_ARCH_RISCV")) {
            return @intCast(rv_utils_get_core_id());
        } else {
            @compileError("Unexpected target architecture: " ++ sys.CONFIG_IDF_TARGET_ARCH);
        }
    }

    // XTENSA targets
    inline fn xt_utils_get_core_id() u32 {
        comptime if (sys.CONFIG_SOC_CPU_CORES_NUM == 1) unreachable;
        return asm volatile (
            \\rsr.prid %[ret]
            \\extui %[ret],%[ret],13,1
            : [ret] "=r" (-> u32),
            :
            : .{});
    }

    // RISCV targets
    inline fn rv_utils_get_core_id() u32 {
        comptime if (sys.CONFIG_SOC_CPU_CORES_NUM == 1) unreachable;
        return asm volatile (
            \\csrr %[ret], mhartid
            : [ret] "=r" (-> u32),
            :
            : .{});
    }

    /// Convert a program counter (PC) value to address
    ///
    /// If the architecture does not store the true virtual address in the CPU's PC
    /// or return addresses, this function will convert the PC value to a virtual
    /// address. Otherwise, the PC is just returned
    pub inline fn pcToAddr(pc: u32) u32 {
        if (@hasDecl(sys, "CONFIG_IDF_TARGET_ARCH_XTENSA")) {
            // Xtensa stores window rotation in PC[31:30]
            return ((pc & 0x3fffffff) | 0x40000000);
        } else {
            return pc;
        }
    }
};
