const sys = @import("sys");
const std = @import("std");
const errors = @import("error");
const builtin = @import("builtin");

// read: https://github.com/espressif/esp-idf/blob/97d95853572ab74f4769597496af9d5fe8b6bdea/components/heap/include/esp_heap_caps.h#L29-L53
// ---------------------------------------------------------------------------
// Caps — packed struct matching esp_heap_caps.h bit positions exactly.
//
// Bit layout (matches MALLOC_CAP_* defines):
//   0        exec          (only when CONFIG_HEAP_HAS_EXEC_HEAP)
//   1        32bit
//   2        8bit
//   3        dma
//   4- 9     pid2..pid7
//   10       spiram
//   11       internal
//   12       default
//   13       iram_8bit
//   14       retention
//   15       rtcram
//   16       tcm
//   17       dma_desc_ahb
//   18       dma_desc_axi
//   19       cache_aligned
//   20       simd
//   21-30    (reserved)
//   31       invalid
// ---------------------------------------------------------------------------
pub const Caps = packed struct(u32) {
    exec: bool = false, // bit  0  — requires CONFIG_HEAP_HAS_EXEC_HEAP
    @"32bit": bool = false, // bit  1
    @"8bit": bool = false, // bit  2
    dma: bool = false, // bit  3
    pid2: bool = false, // bit  4
    pid3: bool = false, // bit  5
    pid4: bool = false, // bit  6
    pid5: bool = false, // bit  7
    pid6: bool = false, // bit  8
    pid7: bool = false, // bit  9
    spiram: bool = false, // bit 10
    internal: bool = false, // bit 11
    default: bool = false, // bit 12
    iram_8bit: bool = false, // bit 13
    retention: bool = false, // bit 14
    rtcram: bool = false, // bit 15
    tcm: bool = false, // bit 16
    dma_desc_ahb: bool = false, // bit 17
    dma_desc_axi: bool = false, // bit 18
    cache_aligned: bool = false, // bit 19
    simd: bool = false, // bit 20
    _reserved: u10 = 0, // bits 21-30
    invalid: bool = false, // bit 31

    /// Cast to the raw u32 value the heap_caps_* C functions expect.
    pub fn toRaw(self: Caps) u32 {
        return @bitCast(self);
    }

    /// Re-hydrate from a raw C bitmask (e.g. value returned by a C API).
    pub fn fromRaw(raw: u32) Caps {
        return @bitCast(raw);
    }

    // -- Named presets matching common ESP-IDF usage patterns ---------------

    /// General-purpose heap (equivalent to malloc/calloc).
    pub const default_caps: Caps = .{ .default = true };
    /// Internal RAM, byte-addressable.
    pub const internal_caps: Caps = .{ .internal = true, .@"8bit" = true };
    /// DMA-capable internal RAM.
    pub const dma_caps: Caps = .{ .dma = true, .@"8bit" = true, .internal = true };
    /// External SPI RAM, byte-addressable.
    pub const spiram_caps: Caps = .{ .spiram = true, .@"8bit" = true };
    /// RTC fast memory (survives deep sleep).
    pub const rtcram_caps: Caps = .{ .rtcram = true };
    /// Tightly-coupled memory.
    pub const tcm_caps: Caps = .{ .tcm = true };
    /// Executable memory (requires CONFIG_HEAP_HAS_EXEC_HEAP).
    pub const exec_caps: Caps = .{ .exec = true };
    /// Cache-line aligned memory.
    pub const cache_aligned_caps: Caps = .{ .cache_aligned = true, .default = true };
};

// Verify the bit layout matches the C header at compile time.
comptime {
    std.debug.assert(@as(u32, @bitCast(Caps{ .exec = true })) == (1 << 0));
    std.debug.assert(@as(u32, @bitCast(Caps{ .@"32bit" = true })) == (1 << 1));
    std.debug.assert(@as(u32, @bitCast(Caps{ .@"8bit" = true })) == (1 << 2));
    std.debug.assert(@as(u32, @bitCast(Caps{ .dma = true })) == (1 << 3));
    std.debug.assert(@as(u32, @bitCast(Caps{ .spiram = true })) == (1 << 10));
    std.debug.assert(@as(u32, @bitCast(Caps{ .internal = true })) == (1 << 11));
    std.debug.assert(@as(u32, @bitCast(Caps{ .default = true })) == (1 << 12));
    std.debug.assert(@as(u32, @bitCast(Caps{ .simd = true })) == (1 << 20));
    std.debug.assert(@as(u32, @bitCast(Caps{ .invalid = true })) == (1 << 31));
}

// ---------------------------------------------------------------------------
// HeapCapsAllocator
// ---------------------------------------------------------------------------

pub const HeapCapsAllocator = struct {
    caps: Caps = Caps.default_caps,

    const Self = @This();

    pub fn init(caps: ?Caps) Self {
        return .{ .caps = caps orelse Caps.default_caps };
    }

    pub fn allocator(self: *Self) std.mem.Allocator {
        return .{
            .ptr = self,
            .vtable = &.{
                .alloc = alloc,
                .resize = resize,
                .remap = remap,
                .free = free,
            },
        };
    }

    pub fn dump(self: Self) void {
        sys.heap_caps_dump(self.caps.toRaw());
    }
    pub fn allocatedSize(_: Self, ptr: ?*anyopaque) usize {
        return sys.heap_caps_get_allocated_size(ptr);
    }
    pub fn largestFreeBlock(self: Self) usize {
        return sys.heap_caps_get_largest_free_block(self.caps.toRaw());
    }
    pub fn totalSize(self: Self) usize {
        return sys.heap_caps_get_total_size(self.caps.toRaw());
    }
    pub fn freeSize(self: Self) usize {
        return sys.heap_caps_get_free_size(self.caps.toRaw());
    }
    pub fn minimumFreeSize(self: Self) usize {
        return sys.heap_caps_get_minimum_free_size(self.caps.toRaw());
    }
    pub fn internalFreeSize(_: Self) usize {
        return sys.esp_get_free_internal_heap_size();
    }

    fn alloc(ctx: *anyopaque, len: usize, alignment: std.mem.Alignment, _: usize) ?[*]u8 {
        const self: *Self = @ptrCast(@alignCast(ctx));
        return @ptrCast(sys.heap_caps_aligned_alloc(
            alignment.toByteUnits(),
            len,
            self.caps.toRaw(),
        ));
    }

    fn resize(_: *anyopaque, buf: []u8, _: std.mem.Alignment, new_len: usize, _: usize) bool {
        if (new_len <= buf.len) return true;
        if (@TypeOf(sys.heap_caps_get_allocated_size) != void) {
            if (new_len <= sys.heap_caps_get_allocated_size(buf.ptr)) return true;
        }
        return false;
    }

    fn remap(ctx: *anyopaque, memory: []u8, _: std.mem.Alignment, new_len: usize, _: usize) ?[*]u8 {
        const self: *Self = @ptrCast(@alignCast(ctx));
        return @ptrCast(sys.heap_caps_realloc(memory.ptr, new_len, self.caps.toRaw()));
    }

    fn free(_: *anyopaque, buf: []u8, _: std.mem.Alignment, _: usize) void {
        sys.heap_caps_free(buf.ptr);
        if (builtin.mode == .Debug) {
            if (!sys.heap_caps_check_integrity_all(true))
                @panic("heap_caps: integrity check failed after free");
        }
    }
};

// ---------------------------------------------------------------------------
// MultiHeapAllocator
// ---------------------------------------------------------------------------

pub const MultiHeapAllocator = struct {
    handle: sys.multi_heap_handle_t = null,

    const Self = @This();

    pub fn init(handle: sys.multi_heap_handle_t) Self {
        return .{ .handle = handle };
    }

    pub fn allocator(self: *Self) std.mem.Allocator {
        return .{
            .ptr = self,
            .vtable = &.{
                .alloc = alloc,
                .resize = resize,
                .remap = remap,
                .free = free,
            },
        };
    }

    pub fn allocatedSize(self: Self, p: ?*anyopaque) usize {
        return sys.multi_heap_get_allocated_size(self.handle, p);
    }
    pub fn freeSize(self: Self) usize {
        return sys.multi_heap_free_size(self.handle);
    }
    pub fn minimumFreeSize(self: Self) usize {
        return sys.multi_heap_minimum_free_size(self.handle);
    }

    fn alloc(ctx: *anyopaque, len: usize, _: std.mem.Alignment, _: usize) ?[*]u8 {
        const self: *Self = @ptrCast(@alignCast(ctx));
        return @ptrCast(sys.multi_heap_malloc(self.handle, len));
    }

    fn resize(ctx: *anyopaque, buf: []u8, _: std.mem.Alignment, new_len: usize, _: usize) bool {
        const self: *Self = @ptrCast(@alignCast(ctx));
        if (new_len <= buf.len) return true;
        if (@TypeOf(sys.multi_heap_get_allocated_size) != void) {
            if (new_len <= sys.multi_heap_get_allocated_size(self.handle, buf.ptr))
                return true;
        }
        return false;
    }

    fn remap(ctx: *anyopaque, memory: []u8, _: std.mem.Alignment, new_len: usize, _: usize) ?[*]u8 {
        const self: *Self = @ptrCast(@alignCast(ctx));
        return @ptrCast(sys.multi_heap_realloc(self.handle, memory.ptr, new_len));
    }

    fn free(ctx: *anyopaque, buf: []u8, _: std.mem.Alignment, _: usize) void {
        const self: *Self = @ptrCast(@alignCast(ctx));
        sys.multi_heap_free(self.handle, buf.ptr);
        if (builtin.mode == .Debug) {
            if (!sys.multi_heap_check(self.handle, true))
                @panic("multi_heap: integrity check failed after free");
        }
    }
};

// ---------------------------------------------------------------------------
// VPortAllocator
// ---------------------------------------------------------------------------

pub const VPortAllocator = struct {
    const Self = @This();

    pub fn init() Self {
        return .{};
    }

    pub fn allocator(self: *Self) std.mem.Allocator {
        return .{
            .ptr = self,
            .vtable = &.{
                .alloc = alloc,
                .resize = resize,
                .remap = remap,
                .free = free,
            },
        };
    }

    pub fn freeSize(_: Self) usize {
        return sys.xPortGetFreeHeapSize();
    }
    pub fn minimumFreeSize(_: Self) usize {
        return sys.xPortGetMinimumEverFreeHeapSize();
    }

    fn alloc(_: *anyopaque, len: usize, _: std.mem.Alignment, _: usize) ?[*]u8 {
        return @ptrCast(sys.pvPortMalloc(len));
    }

    fn resize(_: *anyopaque, buf: []u8, _: std.mem.Alignment, new_len: usize, _: usize) bool {
        return new_len <= buf.len;
    }

    fn remap(_: *anyopaque, memory: []u8, _: std.mem.Alignment, new_len: usize, _: usize) ?[*]u8 {
        const new_ptr = sys.pvPortMalloc(new_len) orelse return null;
        @memcpy(@as([*]u8, @ptrCast(new_ptr))[0..@min(memory.len, new_len)], memory[0..@min(memory.len, new_len)]);
        sys.vPortFree(memory.ptr);
        return @ptrCast(new_ptr);
    }

    fn free(_: *anyopaque, buf: []u8, _: std.mem.Alignment, _: usize) void {
        sys.vPortFree(buf.ptr);
    }
};

// ---------------------------------------------------------------------------
// TRACE
// ---------------------------------------------------------------------------

pub const TRACE = struct {
    pub fn initStandalone(record_buffer: [*c]sys.heap_trace_record_t, num_records: usize) !void {
        try errors.espCheckError(sys.heap_trace_init_standalone(record_buffer, num_records));
    }
    pub fn initTohost() !void {
        try errors.espCheckError(sys.heap_trace_init_tohost());
    }
    pub fn start(mode: sys.heap_trace_mode_t) !void {
        try errors.espCheckError(sys.heap_trace_start(mode));
    }
    pub fn stop() !void {
        try errors.espCheckError(sys.heap_trace_stop());
    }
    pub fn @"resume"() !void {
        try errors.espCheckError(sys.heap_trace_resume());
    }
    pub fn getCount() usize {
        return sys.heap_trace_get_count();
    }
    pub fn get(index: usize, record: [*c]sys.heap_trace_record_t) !void {
        try errors.espCheckError(sys.heap_trace_get(index, record));
    }
    pub fn dump() void {
        sys.heap_trace_dump();
    }
    pub fn dumpCaps(caps: Caps) void {
        sys.heap_trace_dump_caps(caps.toRaw());
    }
    pub fn summary(sum: [*c]sys.heap_trace_summary_t) !void {
        try errors.espCheckError(sys.heap_trace_summary(sum));
    }
};
