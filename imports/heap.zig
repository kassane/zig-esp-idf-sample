const idf = @import("sys");
const std = @import("std");

/// Alocator for use heap_caps_allocator
pub const HeapCapsAllocator = struct {
    caps: idf.Caps = .MALLOC_CAP_DEFAULT,

    const Self = @This();
    pub fn init(cap: idf.Caps) Self {
        return .{
            .caps = cap,
        };
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
        idf.heap_caps_dump(self.caps);
    }
    pub fn allocated_size(_: Self, ptr: ?*anyopaque) usize {
        return idf.heap_caps_get_allocated_size(ptr);
    }
    pub fn largest_free_block(self: Self) usize {
        return idf.heap_caps_get_largest_free_block(self.caps);
    }
    pub fn total_size(self: Self) usize {
        return idf.heap_caps_get_total_size(@intFromEnum(self.caps));
    }
    pub fn free_size(self: Self) usize {
        return idf.heap_caps_get_free_size(@intFromEnum(self.caps));
    }
    pub fn minimum_free_size(self: Self) usize {
        return idf.heap_caps_get_minimum_free_size(@intFromEnum(self.caps));
    }
    pub fn internal_free_size(_: Self) usize {
        return idf.esp_get_free_internal_heap_size();
    }

    fn alloc(ctx: *anyopaque, len: usize, log2_ptr_align: u8, _: usize) ?[*]u8 {
        const self: *Self = @ptrCast(@alignCast(ctx));
        std.debug.assert(log2_ptr_align <= comptime std.math.log2_int(
            usize,
            @alignOf(std.c.max_align_t),
        ));
        return @as(?[*]u8, @ptrCast(
            idf.heap_caps_malloc(
                len,
                @intFromEnum(self.caps),
            ),
        ));
    }

    fn resize(_: *anyopaque, buf: []u8, _: u8, new_len: usize, _: usize) bool {
        if (new_len <= buf.len)
            return true;

        const full_len = if (@TypeOf(idf.heap_caps_get_allocated_size) != void)
            idf.heap_caps_get_allocated_size(buf.ptr);
        if (new_len <= full_len) return true;

        return false;
    }

    fn free(_: *anyopaque, buf: []u8, _: u8, _: usize) void {
        std.debug.assert(idf.heap_caps_check_integrity_all(true));
        idf.heap_caps_free(buf.ptr);
    }
};

/// Alocator for use multi_heap_allocator
pub const MultiHeapAllocator = struct {
    multi_heap_alloc: idf.multi_heap_handle_t = null,

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

    pub fn allocated_size(self: Self, p: ?*anyopaque) usize {
        return idf.multi_heap_get_allocated_size(self.multi_heap_alloc, p);
    }
    pub fn free_size(self: Self) usize {
        return idf.multi_heap_free_size(self.multi_heap_alloc);
    }
    pub fn minimum_free_size(self: Self) usize {
        return idf.multi_heap_minimum_free_size(self.multi_heap_alloc);
    }

    fn alloc(ctx: *anyopaque, len: usize, log2_ptr_align: u8, _: usize) ?[*]u8 {
        const self: *Self = @ptrCast(@alignCast(ctx));
        std.debug.assert(log2_ptr_align <= comptime std.math.log2_int(
            usize,
            @alignOf(std.c.max_align_t),
        ));
        return @as(?[*]u8, @ptrCast(
            idf.multi_heap_malloc(self.multi_heap_alloc, idf.multi_heap_free_size(self.multi_heap_alloc) * len),
        ));
    }

    fn resize(ctx: *anyopaque, buf: []u8, _: u8, new_len: usize, _: usize) bool {
        const self: *Self = @ptrCast(@alignCast(ctx));

        if (new_len <= buf.len)
            return true;

        if (@TypeOf(idf.multi_heap_get_allocated_size) != void)
            if (new_len <= idf.multi_heap_get_allocated_size(self.multi_heap_alloc, buf.ptr))
                return true;

        return false;
    }

    fn free(ctx: *anyopaque, buf: []u8, _: u8, _: usize) void {
        const self: *Self = @ptrCast(@alignCast(ctx));
        defer std.debug.assert(idf.multi_heap_check(self.multi_heap_alloc, true));
        idf.multi_heap_free(self.multi_heap_alloc, buf.ptr);
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

    pub fn free_size(_: Self) usize {
        return idf.xPortGetFreeHeapSize();
    }
    pub fn minimum_free_size(_: Self) usize {
        return idf.xPortGetMinimumEverFreeHeapSize();
    }

    fn alloc(_: *anyopaque, len: usize, log2_ptr_align: u8, _: usize) ?[*]u8 {
        std.debug.assert(log2_ptr_align <= comptime std.math.log2_int(usize, @alignOf(std.c.max_align_t)));
        return @as(?[*]u8, @ptrCast(idf.pvPortMalloc(len)));
    }

    fn resize(_: *anyopaque, buf: []u8, _: u8, new_len: usize, _: usize) bool {
        return new_len <= buf.len;
    }

    fn free(_: *anyopaque, buf: []u8, _: u8, _: usize) void {
        idf.vPortFree(buf.ptr);
    }
};
