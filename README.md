# Using Zig language & toolchain with ESP-IDF

| Supported Targets | ESP32 | ESP32-C2 | ESP32-C3 | ESP32-C6 | ESP32-H2 | ESP32-P4 | ESP32-S2 | ESP32-S3 |
| ----------------- | ----- | -------- | -------- | -------- | -------- | -------- | -------- | -------- |

Running zig std allocator (as  static-lib) on [esp-idf FreeRTOS](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/api-reference/system/freertos.html).

> :information_source:
>
> Asserts allocations are within `@alignOf(std.c.max_align_t)` and directly calls
> `malloc`/`free`. Does not attempt to utilize `malloc_usable_size`.
>
> - `std.heap.raw_c_allocator` allocator is safe to use as the backing allocator with
> `std.heap.ArenaAllocator` for example and is more optimal in such a case
> than `std.heap.c_allocator`. - ref.: [std-doc](https://ziglang.org/documentation/master/std/#std.heap.raw_c_allocator)
>
> Custom Allocators (based on `std.heap.raw_c_allocator`)
>
> - `esp_idf.HeapCapsAllocator.init(caps: u32)`
> - `esp_idf.MultiHeapAllocator.init()` - ref.: [espressif-doc](https://docs.espressif.com/projects/esp-idf/en/v5.2.1/esp32c3/api-reference/system/mem_alloc.html)
>
> - `std.heap.ArenaAllocator` takes an existing allocator, wraps it, and provides an interface where you can allocate without freeing, and then free it all together. - ref.: [std-doc](https://ziglang.org/documentation/master/std/#std.heap.ArenaAllocator)

## Required

- [Zig](https://ziglang.org/download) toolchain - v0.12.0 or master
- [ESP-IDF](https://github.com/espressif/esp-idf) - v4.4 or v5.2


> :warning:: Zig upstream (LLVM-Codegen) does not have xtensa support. Similar to [esp-rs](https://github.com/esp-rs), it is necessary to use the [zig-xtensa](https://github.com/kassane/zig-espressif-bootstrap/releases) - toolchain forked.
