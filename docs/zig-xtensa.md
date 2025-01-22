# Zig on Xtensa (Esp32, Esp8266 and Esp32-S series)

Like [esp-rs](https://github.com/espressif/rust-esp32-example/blob/main/docs/rust-on-xtensa.md), forked zig toolchain uses **LLVM codegen** for xtensa target.

**Current version:**

- **Zig**: v0.14.0 ([bootstrap fork](https://github.com/kassane/zig-espressif-bootstrap))
- **LLVM**: v19.0.2 ([espressif-fork](https://github.com/espressif/llvm-project))


### Commands

**Zig command line interface:**

- `build-lib`: build static-lib or shared-lib (add `-dynamic` flag);
- `build-obj`: build object file, like `clang/gcc -c`.
- `build-exe`: build executable
- `build`: build-system mode, need `build.zig`.

**Clang command line interface:**

- `zig cc`: clang CLI
- `zig c++`: clang++ CLI (uses `llvm-libc++` + `llvm-libunwind` by default)

**Note:** Zig toolchain does not change `libclang` codegen. However, the default config uses `-fsanitize=undefined`.

### Targets available

```bash
$> zig build-lib --show-builtin -target xtensa-freestanding-none -mcpu=(empty or any text)

info: available CPUs for architecture 'xtensa':
 cnl
 esp32
 esp32s2
 esp32s3
 esp8266
 generic

error: unknown CPU: ''
```

**Note:** Freestanding targets are not listed on `zig targets | jq .libc` (triple-targets)

#### CPU Features

Similar to [Targets available](#targets-available) command, add `-mcpu` or `-Dcpu=` (need `build.zig`).

- `+` add feature
- `-` remove feature

**Note:** For show feature list add `+`/`-` without feature name

**e.g.:**
```bash
$> zig build-lib --show-builtin -target xtensa-freestanding-none -mcpu=esp32+

info: available CPU features for architecture 'xtensa':
 atomctl: Enable Xtensa ATOMCTL option
 bool: Enable Xtensa Boolean extension
 clamps: Enable Xtensa CLAMPS option
 coprocessor: Enable Xtensa Coprocessor option
 debug: Enable Xtensa Debug option
 density: Enable Density instructions
 dfpaccel: Enable Xtensa Double Precision FP acceleration
 div32: Enable Xtensa Div32 option
 esp32s2: Support Xtensa esp32-s2 ISA extension
 esp32s3: Support Xtensa esp32-s3 ISA extension
 exception: Enable Xtensa Exception option
 extendedl32r: Enable Xtensa Extended L32R option
 fp: Enable Xtensa Single FP instructions
 hifi3: Enable Xtensa HIFI3 instructions
 highpriinterrupts: Enable Xtensa HighPriInterrupts option
 interrupt: Enable Xtensa Interrupt option
 loop: Enable Xtensa Loop extension
 mac16: Enable Xtensa MAC16 instructions
 memctl: Enable Xtensa MEMCTL option
 minmax: Enable Xtensa MINMAX option
 miscsr: Enable Xtensa Miscellaneous SR option
 mul16: Enable Xtensa Mul16 option
 mul32: Enable Xtensa Mul32 option
 mul32high: Enable Xtensa Mul32High option
 nsa: Enable Xtensa NSA option
 prid: Enable Xtensa Processor ID option
 regprotect: Enable Xtensa Region Protection option
 rvector: Enable Xtensa Relocatable Vector option
 s32c1i: Enable Xtensa S32C1I option
 sext: Enable Xtensa Sign Extend option
 threadptr: Enable Xtensa THREADPTR option
 timerint: Enable Xtensa Timer Interrupt option
 windowed: Enable Xtensa Windowed Register option

error: unknown CPU feature: ''
```


#### Target info (builtin)

**Note:** If like syntax-highlighting use `| bat -p -l zig` pipeline command or save this output as `builtin.zig` and open on your code editor.

```bash
$> zig build-lib --show-builtin -target xtensa-freestanding-none -mcpu=esp32s3
```
```zig
const std = @import("std");
/// Zig version. When writing code that supports multiple versions of Zig, prefer
/// feature detection (i.e. with `@hasDecl` or `@hasField`) over version checks.
pub const zig_version = std.SemanticVersion.parse(zig_version_string) catch unreachable;
pub const zig_version_string = "0.14.0";
pub const zig_backend = std.builtin.CompilerBackend.stage2_llvm;

pub const output_mode = std.builtin.OutputMode.Lib;
pub const link_mode = std.builtin.LinkMode.static;
pub const is_test = false;
pub const single_threaded = false;
pub const abi = std.Target.Abi.none;
pub const cpu: std.Target.Cpu = .{
    .arch = .xtensa,
    .model = &std.Target.xtensa.cpu.esp32s3,
    .features = std.Target.xtensa.featureSet(&[_]std.Target.xtensa.Feature{
        .atomctl,
        .bool,
        .clamps,
        .coprocessor,
        .debug,
        .density,
        .dfpaccel,
        .div32,
        .esp32s3,
        .exception,
        .fp,
        .highpriinterrupts,
        .interrupt,
        .loop,
        .mac16,
        .memctl,
        .minmax,
        .miscsr,
        .mul16,
        .mul32,
        .mul32high,
        .nsa,
        .prid,
        .regprotect,
        .rvector,
        .s32c1i,
        .sext,
        .threadptr,
        .timerint,
        .windowed,
    }),
};
pub const os = std.Target.Os{
    .tag = .freestanding,
    .version_range = .{ .none = {} },
};
pub const target: std.Target = .{
    .cpu = cpu,
    .os = os,
    .abi = abi,
    .ofmt = object_format,
    .dynamic_linker = std.Target.DynamicLinker.none,
};
pub const object_format = std.Target.ObjectFormat.elf;
pub const mode = std.builtin.OptimizeMode.Debug;
pub const link_libc = false;
pub const link_libcpp = false;
pub const have_error_return_tracing = true;
pub const valgrind_support = false;
pub const sanitize_thread = false;
pub const position_independent_code = false;
pub const position_independent_executable = false;
pub const strip_debug_info = false;
pub const code_model = std.builtin.CodeModel.default;
pub const omit_frame_pointer = false;
```
