const sys = @import("sys");
const std = @import("std");

/// Alocator for use heap_caps_allocator
pub const HeapCapsAllocator = struct {
    caps: sys.Caps = .MALLOC_CAP_DEFAULT,

    const Self = @This();
    pub fn init(cap: ?sys.Caps) Self {
        if (cap) |user_cap| {
            return .{ .caps = user_cap };
        } else return .{}; // keep .MALLOC_CAP_DEFAULT
    }
    pub fn allocator(self: *Self) std.mem.Allocator {
        return .{
            .ptr = self,
            .vtable = &.{
                .alloc = alloc,
                .resize = resize,
                .free = free,
            },
        };
    }
    pub fn dump(self: Self) void {
        sys.heap_caps_dump(self.caps);
    }
    pub fn allocatedSize(_: Self, ptr: ?*anyopaque) usize {
        return sys.heap_caps_get_allocated_size(ptr);
    }
    pub fn largestFreeBlock(self: Self) usize {
        return sys.heap_caps_get_largest_free_block(self.caps);
    }
    pub fn totalSize(self: Self) usize {
        return sys.heap_caps_get_total_size(@intFromEnum(self.caps));
    }
    pub fn freeSize(self: Self) usize {
        return sys.heap_caps_get_free_size(@intFromEnum(self.caps));
    }
    pub fn minimumFreeSize(self: Self) usize {
        return sys.heap_caps_get_minimum_free_size(@intFromEnum(self.caps));
    }
    pub fn internalFreeSize(_: Self) usize {
        return sys.esp_get_free_internal_heap_size();
    }

    fn alloc(ctx: *anyopaque, len: usize, log2_ptr_align: u8, _: usize) ?[*]u8 {
        const self: *Self = @ptrCast(@alignCast(ctx));
        std.debug.assert(log2_ptr_align <= comptime std.math.log2_int(
            usize,
            @alignOf(std.c.max_align_t),
        ));
        return @as(?[*]u8, @ptrCast(
            sys.heap_caps_malloc(
                len,
                @intFromEnum(self.caps),
            ),
        ));
    }

    fn resize(_: *anyopaque, buf: []u8, _: u8, new_len: usize, _: usize) bool {
        if (new_len <= buf.len)
            return true;

        const full_len = if (@TypeOf(sys.heap_caps_get_allocated_size) != void)
            sys.heap_caps_get_allocated_size(buf.ptr);
        if (new_len <= full_len) return true;

        return false;
    }

    fn free(_: *anyopaque, buf: []u8, _: u8, _: usize) void {
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
            .vtable = &.{
                .alloc = alloc,
                .resize = resize,
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

    fn alloc(ctx: *anyopaque, len: usize, log2_ptr_align: u8, _: usize) ?[*]u8 {
        const self: *Self = @ptrCast(@alignCast(ctx));
        std.debug.assert(log2_ptr_align <= comptime std.math.log2_int(
            usize,
            @alignOf(std.c.max_align_t),
        ));
        return @as(?[*]u8, @ptrCast(
            sys.multi_heap_malloc(self.multi_heap_alloc, sys.multi_heap_free_size(self.multi_heap_alloc) * len),
        ));
    }

    fn resize(ctx: *anyopaque, buf: []u8, _: u8, new_len: usize, _: usize) bool {
        const self: *Self = @ptrCast(@alignCast(ctx));

        if (new_len <= buf.len)
            return true;

        if (@TypeOf(sys.multi_heap_get_allocated_size) != void)
            if (new_len <= sys.multi_heap_get_allocated_size(self.multi_heap_alloc, buf.ptr))
                return true;

        return false;
    }

    fn free(ctx: *anyopaque, buf: []u8, _: u8, _: usize) void {
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
            .vtable = &.{
                .alloc = alloc,
                .resize = resize,
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

    fn alloc(_: *anyopaque, len: usize, log2_ptr_align: u8, _: usize) ?[*]u8 {
        std.debug.assert(log2_ptr_align <= comptime std.math.log2_int(usize, @alignOf(std.c.max_align_t)));
        return @as(?[*]u8, @ptrCast(sys.pvPortMalloc(len)));
    }

    fn resize(_: *anyopaque, buf: []u8, _: u8, new_len: usize, _: usize) bool {
        return new_len <= buf.len;
    }

    fn free(_: *anyopaque, buf: []u8, _: u8, _: usize) void {
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
