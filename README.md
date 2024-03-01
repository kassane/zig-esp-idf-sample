# zig-esp-idf-sample

Running zig std allocator (static-lib) on esp-idf freertos

## Required

- [Zig](https://ziglang.org/download) toolchain - v0.12.0 or master
- [ESP-IDF](https://github.com/espressif/esp-idf) - v4.4 or master


:warning: Zig upstream (LLVM-Codegen) not have xtensa support. Similar to [esp-rs](https://github.com/esp-rs) need to use [zig-xtensa](https://github.com/kassane/zig-espressif-bootstrap/releases) - toolchain forked.