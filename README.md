# Using Zig Language & Toolchain with ESP-IDF

| Supported Targets | ESP32 | ESP32-C2 | ESP32-C3 | ESP32-C6 | ESP32-H2 | ESP32-P4 | ESP32-S2 | ESP32-S3 |
| ----------------- | ----- | -------- | -------- | -------- | -------- | -------- | -------- | -------- |

## STATUS: Experimental

## Description

This project aims to integrate Zig language and toolchain with the [Espressif IoT Development Framework](https://github.com/espressif/esp-idf) for enhanced development capabilities on ESP32 and its variants.

## Prerequisites

- [Zig](https://ziglang.org/download) toolchain - v0.12.0 or master
- [ESP-IDF](https://github.com/espressif/esp-idf) - v4.4 or v5.2 or master

### Targets Allowed

| target | commands |
| ------ | -------- |
| esp32 | `-Dtarget=xtensa-freestanding-none -Dcpu=esp32` |
| esp32-s2 | `-Dtarget=xtensa-freestanding-none -Dcpu=esp32s2` |
| esp32-s3 | `-Dtarget=xtensa-freestanding-none -Dcpu=esp32s3` |
| esp32-c2/c3 | `-Dtarget=riscv32-freestanding-none -Dcpu=generic_rv32+c+m` |
| esp32-h2/c5/c6 | `-Dtarget=riscv32-freestanding-none -Dcpu=generic_rv32+a+c+m` |
| esp32-p4 | `-Dtarget=riscv32-freestanding-eabihf -Dcpu=generic_rv32+a+c+f+m` |

<br>
<sub>
  
> [!WARNING]
> [Zig](https://ziglang.org/download) upstream (LLVM-Codegen) does not have xtensa support. Similar to [esp-rs](https://github.com/esp-rs), it is necessary to use the [zig-xtensa](https://github.com/kassane/zig-espressif-bootstrap/releases) - **toolchain forked**.

</sub>
</br>


### Key Features:

- **Zig Language Integration**: Utilize the Zig programming language to write firmware code, offering modern language features such as comptime, meta-programming, and error handling.

- **Zig Toolchain Integration**: Zig toolchain uses `build.zig`, can be used to build Zig libraries and executables, and can be integrated with the ESP-IDF build system. Also,
replace clang and clang++ with Zig compiler and linker.
  - **Note:** For C++ support, zig toolchain uses `llvm-libc++` ABI by default.

- **ESP-IDF Compatibility**: Seamlessly integrate Zig with the ESP-IDF framework, allowing developers to leverage the rich set of APIs and functionalities provided by ESP-IDF for IoT development.

- **Build System Configuration**: Employ CMake to build Zig libraries, enabling easy integration with existing ESP-IDF projects while ensuring efficient dependency management and build configuration.

- **Cross-Platform Development**: Facilitate development across various ESP32 variants including ESP32-C2, ESP32-C3, ESP32-C5, ESP32-C6, ESP32-H2, ESP32-P4, ESP32-S2, and ESP32-S3, ensuring broad compatibility and versatility.


### About Allocators

> [!NOTE]
>
> Asserts allocations are within `@alignOf(std.c.max_align_t)` and directly calls
> `malloc`/`free`. Does not attempt to utilize `malloc_usable_size`.
>
> - `std.heap.raw_c_allocator` allocator is safe to use as the backing allocator with `std.heap.ArenaAllocator` for example and is more optimal in such a case than `std.heap.c_allocator`. - ref.: [std-doc](https://ziglang.org/documentation/master/std/#std.heap.raw_c_allocator)
>
> - `std.heap.ArenaAllocator` takes an existing allocator, wraps it, and provides an interface where you can allocate without freeing, and then free it all together. - ref.: [std-doc](https://ziglang.org/documentation/master/std/#std.heap.ArenaAllocator)
>
> **Custom Allocators** (based on `std.heap.raw_c_allocator`)
>
> - `idf.heap.HeapCapsAllocator` - ref.: [espressif-doc](https://docs.espressif.com/projects/esp-idf/en/v5.2.1/esp32c3/api-reference/system/mem_alloc.html)
> - `idf.heap.MultiHeapAllocator` - ref.: [espressif-doc](https://docs.espressif.com/projects/esp-idf/en/v5.2.1/esp32c3/api-reference/system/mem_alloc.html)
> - `idf.heap.vPortAllocator` - ref.: [FreeRTOS-doc](https://www.freertos.org/a00111.html)
