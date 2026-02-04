const sys = @import("sys");
const std = @import("std");

pub const Caps = enum(c_int) {
    MALLOC_CAP_EXEC = if (@hasDecl(sys, "MALLOC_CAP_EXEC")) sys.MALLOC_CAP_EXEC else 0, //< Memory must be able to run executable code
    MALLOC_CAP_32BIT = if (@hasDecl(sys, "MALLOC_CAP_32BIT")) sys.MALLOC_CAP_32BIT else 0, //< Memory must allow for aligned 32-bit data accesses
    MALLOC_CAP_8BIT = if (@hasDecl(sys, "MALLOC_CAP_8BIT")) sys.MALLOC_CAP_8BIT else 0, //< Memory must allow for 8/16/...-bit data accesses
    MALLOC_CAP_DMA = if (@hasDecl(sys, "MALLOC_CAP_DMA")) sys.MALLOC_CAP_DMA else 0, //< Memory must be able to accessed by DMA
    MALLOC_CAP_PID2 = if (@hasDecl(sys, "MALLOC_CAP_PID2")) sys.MALLOC_CAP_PID2 else 0, //< Memory must be mapped to PID2 memory space (PIDs are not currently used)
    MALLOC_CAP_PID3 = if (@hasDecl(sys, "MALLOC_CAP_PID3")) sys.MALLOC_CAP_PID3 else 0, //< Memory must be mapped to PID3 memory space (PIDs are not currently used)
    MALLOC_CAP_PID4 = if (@hasDecl(sys, "MALLOC_CAP_PID4")) sys.MALLOC_CAP_PID4 else 0, //< Memory must be mapped to PID4 memory space (PIDs are not currently used)
    MALLOC_CAP_PID5 = if (@hasDecl(sys, "MALLOC_CAP_PID5")) sys.MALLOC_CAP_PID5 else 0, //< Memory must be mapped to PID5 memory space (PIDs are not currently used)
    MALLOC_CAP_PID6 = if (@hasDecl(sys, "MALLOC_CAP_PID6")) sys.MALLOC_CAP_PID6 else 0, //< Memory must be mapped to PID6 memory space (PIDs are not currently used)
    MALLOC_CAP_PID7 = if (@hasDecl(sys, "MALLOC_CAP_PID7")) sys.MALLOC_CAP_PID7 else 0, //< Memory must be mapped to PID7 memory space (PIDs are not currently used)
    MALLOC_CAP_SPIRAM = if (@hasDecl(sys, "MALLOC_CAP_SPIRAM")) sys.MALLOC_CAP_SPIRAM else 0, //< Memory must be in SPI RAM
    MALLOC_CAP_INTERNAL = if (@hasDecl(sys, "MALLOC_CAP_INTERNAL")) sys.MALLOC_CAP_INTERNAL else 0, //< Memory must be internal; specifically it should not disappear when flash/spiram cache is switched off
    MALLOC_CAP_DEFAULT = if (@hasDecl(sys, "MALLOC_CAP_DEFAULT")) sys.MALLOC_CAP_DEFAULT else 0, //< Memory can be returned in a non-capability-specific memory allocation (e.g. malloc(), calloc()) call
    MALLOC_CAP_IRAM_8BIT = if (@hasDecl(sys, "MALLOC_CAP_IRAM_8BIT")) sys.MALLOC_CAP_IRAM_8BIT else 0, //< Memory must be in IRAM and allow unaligned access
    MALLOC_CAP_RETENTION = if (@hasDecl(sys, "MALLOC_CAP_RETENTION")) sys.MALLOC_CAP_RETENTION else 0, //< Memory must be able to accessed by retention DMA
    MALLOC_CAP_RTCRAM = if (@hasDecl(sys, "MALLOC_CAP_RTCRAM")) sys.MALLOC_CAP_RTCRAM else 0, //< Memory must be in RTC fast memory
    MALLOC_CAP_TCM = if (@hasDecl(sys, "MALLOC_CAP_TCM")) sys.MALLOC_CAP_TCM else 0, //< Memory must be in TCM memory
    MALLOC_CAP_DMA_DESC_AHB = if (@hasDecl(sys, "MALLOC_CAP_DMA_DESC_AHB")) sys.MALLOC_CAP_DMA_DESC_AHB else (@as(c_int, 1) << 17), //< Memory must be in AHB DMA descriptor
    MALLOC_CAP_DMA_DESC_AXI = if (@hasDecl(sys, "MALLOC_CAP_DMA_DESC_AXI")) sys.MALLOC_CAP_DMA_DESC_AXI else (@as(c_int, 1) << 18), //< Memory must be in AXI DMA descriptor
    MALLOC_CAP_CACHE_ALIGNED = if (@hasDecl(sys, "MALLOC_CAP_CACHE_ALIGNED")) sys.MALLOC_CAP_CACHE_ALIGNED else (@as(c_int, 1) << 19), //< Memory must be cache aligned
    MALLOC_CAP_SIMD = if (@hasDecl(sys, "MALLOC_CAP_SIMD")) sys.MALLOC_CAP_SIMD else (@as(c_int, 1) << 20), //< Memory must support SIMD operations
    MALLOC_CAP_INVALID = if (@hasDecl(sys, "MALLOC_CAP_INVALID")) sys.MALLOC_CAP_INVALID else 0, //< Memory can't be used / list end marker
};

/// Alocator for use heap_caps_allocator
pub const HeapCapsAllocator = struct {
    caps: Caps = Caps.MALLOC_CAP_DEFAULT,

    const Self = @This();
    pub fn init(cap: ?Caps) Self {
        if (cap) |user_cap| {
            return .{ .caps = user_cap };
        } else return .{}; // keep .MALLOC_CAP_DEFAULT
    }
    pub fn allocator(self: *Self) std.mem.Allocator {
        return .{
            .ptr = self,
            .vtable = &std.mem.Allocator.VTable{
                .alloc = alloc,
                .resize = resize,
                .remap = remap,
                .free = free,
            },
        };
    }
    pub fn dump(self: Self) void {
        sys.heap_caps_dump(@intCast(@intFromEnum(self.caps)));
    }
    pub fn allocatedSize(_: Self, ptr: ?*anyopaque) usize {
        return sys.heap_caps_get_allocated_size(ptr);
    }
    pub fn largestFreeBlock(self: Self) usize {
        return sys.heap_caps_get_largest_free_block(self.caps);
    }
    pub fn totalSize(self: Self) usize {
        return sys.heap_caps_get_total_size(@intCast(@intFromEnum(self.caps)));
    }
    pub fn freeSize(self: Self) usize {
        return sys.heap_caps_get_free_size(@intCast(@intFromEnum(self.caps)));
    }
    pub fn minimumFreeSize(self: Self) usize {
        return sys.heap_caps_get_minimum_free_size(@intCast(@intFromEnum(self.caps)));
    }
    pub fn internalFreeSize(_: Self) usize {
        return sys.esp_get_free_internal_heap_size();
    }

    fn alloc(ctx: *anyopaque, len: usize, alignment: std.mem.Alignment, _: usize) ?[*]u8 {
        const self: *Self = @ptrCast(@alignCast(ctx));
        std.debug.assert(alignment.compare(.lte, comptime .fromByteUnits(@alignOf(std.c.max_align_t))));
        return @as(?[*]u8, @ptrCast(
            sys.heap_caps_malloc(
                len,
                @intCast(@intFromEnum(self.caps)),
            ),
        ));
    }

    fn resize(_: *anyopaque, buf: []u8, _: std.mem.Alignment, new_len: usize, _: usize) bool {
        if (new_len <= buf.len)
            return true;

        const full_len = if (@TypeOf(sys.heap_caps_get_allocated_size) != void)
            sys.heap_caps_get_allocated_size(buf.ptr);
        if (new_len <= full_len) return true;

        return false;
    }

    fn remap(_: *anyopaque, memory: []u8, _: std.mem.Alignment, new_len: usize, _: usize) ?[*]u8 {
        return @ptrCast(std.c.realloc(memory.ptr, new_len));
    }

    fn free(_: *anyopaque, buf: []u8, _: std.mem.Alignment, _: usize) void {
        std.debug.assert(sys.heap_caps_check_integrity_all(true));
        sys.heap_caps_free(buf.ptr);
    }
};

/// Alocator for use multi_heap_allocator
pub const MultiHeapAllocator = struct {
    multi_heap_alloc: sys.multi_heap_handle_t = null,

    const Self = @This();
    pub fn init() Self {
        return .{};
    }
    pub fn allocator(self: *Self) std.mem.Allocator {
        return .{
            .ptr = self,
            .vtable = &std.mem.Allocator.VTable{
                .alloc = alloc,
                .resize = resize,
                .remap = remap,
                .free = free,
            },
        };
    }

    pub fn allocatedSize(self: Self, p: ?*anyopaque) usize {
        return sys.multi_heap_get_allocated_size(self.multi_heap_alloc, p);
    }
    pub fn freeSize(self: Self) usize {
        return sys.multi_heap_free_size(self.multi_heap_alloc);
    }
    pub fn minimumFreeSize(self: Self) usize {
        return sys.multi_heap_minimum_free_size(self.multi_heap_alloc);
    }

    fn alloc(ctx: *anyopaque, len: usize, alignment: std.mem.Alignment, _: usize) ?[*]u8 {
        const self: *Self = @ptrCast(@alignCast(ctx));
        std.debug.assert(alignment.compare(.lte, comptime .fromByteUnits(@alignOf(std.c.max_align_t))));
        return @as(?[*]u8, @ptrCast(
            sys.multi_heap_malloc(self.multi_heap_alloc, sys.multi_heap_free_size(self.multi_heap_alloc) * len),
        ));
    }

    fn resize(ctx: *anyopaque, buf: []u8, _: std.mem.Alignment, new_len: usize, _: usize) bool {
        const self: *Self = @ptrCast(@alignCast(ctx));

        if (new_len <= buf.len)
            return true;

        if (@TypeOf(sys.multi_heap_get_allocated_size) != void)
            if (new_len <= sys.multi_heap_get_allocated_size(self.multi_heap_alloc, buf.ptr))
                return true;

        return false;
    }

    fn remap(_: *anyopaque, memory: []u8, _: std.mem.Alignment, new_len: usize, _: usize) ?[*]u8 {
        return @ptrCast(std.c.realloc(memory.ptr, new_len));
    }

    fn free(ctx: *anyopaque, buf: []u8, _: std.mem.Alignment, _: usize) void {
        const self: *Self = @ptrCast(@alignCast(ctx));
        defer std.debug.assert(sys.multi_heap_check(self.multi_heap_alloc, true));
        sys.multi_heap_free(self.multi_heap_alloc, buf.ptr);
    }
};

/// Alocator for use pvPortMalloc/vPortFree
pub const vPortAllocator = struct {
    const Self = @This();
    pub fn init() Self {
        return .{};
    }
    pub fn allocator(self: *Self) std.mem.Allocator {
        return .{
            .ptr = self,
            .vtable = &std.mem.Allocator.VTable{
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

    fn alloc(_: *anyopaque, len: usize, alignment: std.mem.Alignment, _: usize) ?[*]u8 {
        std.debug.assert(alignment.compare(.lte, comptime .fromByteUnits(@alignOf(std.c.max_align_t))));
        return @as(?[*]u8, @ptrCast(sys.pvPortMalloc(len)));
    }

    fn resize(_: *anyopaque, buf: []u8, _: std.mem.Alignment, new_len: usize, _: usize) bool {
        return new_len <= buf.len;
    }

    fn remap(_: *anyopaque, memory: []u8, _: std.mem.Alignment, new_len: usize, _: usize) ?[*]u8 {
        return @ptrCast(std.c.realloc(memory.ptr, new_len));
    }

    fn free(_: *anyopaque, buf: []u8, _: std.mem.Alignment, _: usize) void {
        sys.vPortFree(buf.ptr);
    }
};

const errors = @import("error");
pub const TRACE = struct {
    pub fn initStandalone(record_buffer: [*c]sys.heap_trace_record_t, num_records: usize) !void {
        return try errors.espCheckError(sys.heap_trace_init_standalone(record_buffer, num_records));
    }
    pub fn initTohost() !void {
        return try errors.espCheckError(sys.heap_trace_init_tohost());
    }
    pub fn start(mode: sys.heap_trace_mode_t) !void {
        return try errors.espCheckError(sys.heap_trace_start(mode));
    }
    pub fn stop() !void {
        return try errors.espCheckError(sys.heap_trace_stop());
    }
    pub fn @"resume"() !void {
        return try errors.espCheckError(sys.heap_trace_resume());
    }
    pub fn getCount() usize {
        return sys.heap_trace_get_count();
    }
    pub fn get(index: usize, record: [*c]sys.heap_trace_record_t) !void {
        return try errors.espCheckError(sys.heap_trace_get(index, record));
    }
    pub fn dump() void {
        sys.heap_trace_dump();
    }
    pub fn dumpCaps(caps: u32) void {
        sys.heap_trace_dump_caps(caps);
    }
    pub fn summary(sum: [*c]sys.heap_trace_summary_t) !void {
        return try errors.espCheckError(sys.heap_trace_summary(sum));
    }
};
