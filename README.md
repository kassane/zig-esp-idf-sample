[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/kassane/zig-esp-idf-sample)

# Using Zig Language & Toolchain with ESP-IDF

| Supported Targets | ESP32 | ESP32-C2 | ESP32-C3 | ESP32-C6 | ESP32-H2 | ESP32-P4 | ESP32-H4 | ESP32-S2 | ESP32-S3 |
| ----------------- | ----- | -------- | -------- | -------- | -------- | -------- | -------- | -------- | -------- |

## STATUS: Experimental

## Description

This project aims to integrate Zig language and toolchain with the [Espressif IoT Development Framework](https://github.com/espressif/esp-idf) for enhanced development capabilities on ESP32 and its variants.

More information about building and using Zig with ESP-IDF can be found in the [documentation](docs/getting-started.md).

## Prerequisites

- [Zig](https://ziglang.org/download) toolchain - v0.16.0 or master
- [ESP-IDF](https://github.com/espressif/esp-idf) - v5.x or v6.x or master

### Targets Allowed

<table>
<thead>
  <tr>
    <th>Target</th>
    <th>Architecture</th>
    <th>Features</th>
    <th>Zig Build Configuration</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td><strong>ESP32</strong></td>
    <td>Xtensa LX6</td>
    <td>Dual-core, WiFi, BT Classic, BLE</td>
    <td><code>-Dtarget=xtensa-freestanding-none -Dcpu=esp32</code></td>
  </tr>
  <tr>
    <td><strong>ESP32-S2</strong></td>
    <td>Xtensa LX7</td>
    <td>Single-core, WiFi, USB OTG</td>
    <td><code>-Dtarget=xtensa-freestanding-none -Dcpu=esp32s2</code></td>
  </tr>
  <tr>
    <td><strong>ESP32-S3</strong></td>
    <td>Xtensa LX7</td>
    <td>Dual-core, WiFi, BLE 5.0, USB OTG, AI</td>
    <td><code>-Dtarget=xtensa-freestanding-none -Dcpu=esp32s3</code></td>
  </tr>
  <tr>
    <td><strong>ESP32-C2</strong></td>
    <td>RISC-V</td>
    <td>Single-core, WiFi, BLE 5.0, Low-cost</td>
    <td rowspan="2"><code>-Dtarget=riscv32-freestanding-none -Dcpu=generic_rv32+m+c+zicsr+zifencei</code></td>
  </tr>
  <tr>
    <td><strong>ESP32-C3</strong></td>
    <td>RISC-V</td>
    <td>Single-core, WiFi, BLE 5.0, Low-power</td>
  </tr>
  <tr>
    <td><strong>ESP32-C5</strong></td>
    <td>RISC-V</td>
    <td>Single-core, WiFi 6, BLE 5.0</td>
    <td rowspan="5"><code>-Dtarget=riscv32-freestanding-none -Dcpu=generic_rv32+m+a+c+zicsr+zifencei</code></td>
  </tr>
  <tr>
    <td><strong>ESP32-C6</strong></td>
    <td>RISC-V</td>
    <td>Single-core, WiFi 6, BLE 5.0, Zigbee, Thread</td>
  </tr>
  <tr>
    <td><strong>ESP32-C61</strong></td>
    <td>RISC-V</td>
    <td>Single-core, WiFi 6, BLE 5.0, Low-cost</td>
  </tr>
  <tr>
    <td><strong>ESP32-H2</strong></td>
    <td>RISC-V</td>
    <td>BLE 5.0, Zigbee 3.0, Thread, No WiFi</td>
  </tr>
  <tr>
    <td><strong>ESP32-H21</strong></td>
    <td>RISC-V</td>
    <td>BLE 5.0, Zigbee 3.0, Thread, No WiFi</td>
  </tr>
  <tr>
    <td><strong>ESP32-H4</strong></td>
    <td>RISC-V</td>
    <td>BLE 5.2, Zigbee, Thread, FPU, No WiFi</td>
    <td><code>-Dtarget=riscv32-freestanding-eabihf -Dcpu=esp32h4</code></td>
  </tr>
  <tr>
    <td><strong>ESP32-P4</strong></td>
    <td>RISC-V</td>
    <td>Dual-core, AI, DSP, FPU, No WiFi/BT</td>
    <td><code>-Dtarget=riscv32-freestanding-eabihf -Dcpu=esp32p4</code></td>
  </tr>
</tbody>
</table>

> [!WARNING]
> **Xtensa Architecture Support**
> 
> The upstream [Zig compiler](https://ziglang.org/download) (LLVM backend) does not support Xtensa architecture. For ESP32, ESP32-S2, and ESP32-S3 targets, you must use the [Espressif Zig fork](https://github.com/kassane/zig-espressif-bootstrap/releases).
> 
> - **RISC-V targets (C2/C3/C5/C6/H2/etc):** Works with upstream Zig ✅
> - **Xtensa targets (ESP32/S2/S3) & RISC-V with FPU (H4/P4):** Requires [zig-xtensa](https://github.com/kassane/zig-espressif-bootstrap/releases) (auto-downloaded)
> 
> The build system automatically downloads the correct toolchain for your target.


### Key Features:

- **Zig Language Integration**: Use the Zig programming language to write firmware code. It provides modern language features such as comptime, meta-programming, and error handling.

- **Zig Toolchain Integration**: The Zig toolchain can be used to build zig libraries and executables, and can also be integrated with the ESP-IDF build system. Also, system compiler and linker can be replaced to `zig cc`/`zig c++`.
  - **Note:** For C++ support, zig toolchain uses `llvm-libc++` ABI by default.

- **ESP-IDF Compatibility**: Seamlessly integrate Zig with the ESP-IDF framework, allowing developers to leverage the rich set of APIs and functionalities provided by ESP-IDF for IoT development.

- **Build System Configuration**: Using CMake to build Zig libraries allows easy integration with existing ESP-IDF projects while providing efficient dependency management and build configuration.

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


### License

This project is licensed twice:
- [Apache](LICENSE-APACHE)
- [MIT-0](LICENSE-MIT)