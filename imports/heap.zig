const idf = @import("sys");
const std = @import("std");

// Alocator for use with raw_heap_caps_allocator
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
                .alloc = rawHeapCapsAlloc,
                .resize = rawHeapCapsResize,
                .free = rawHeapCapsFree,
            },
        };
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

    fn rawHeapCapsAlloc(
        ctx: *anyopaque,
        len: usize,
        log2_ptr_align: u8,
        ret_addr: usize,
    ) ?[*]u8 {
        _ = ret_addr;
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

    fn rawHeapCapsResize(
        _: *anyopaque,
        buf: []u8,
        log2_old_align: u8,
        new_len: usize,
        ret_addr: usize,
    ) bool {
        _ = log2_old_align;
        _ = ret_addr;

        if (new_len <= buf.len)
            return true;

        const full_len = if (@TypeOf(idf.heap_caps_get_allocated_size) != void)
            idf.heap_caps_get_allocated_size(buf.ptr);
        if (new_len <= full_len) return true;

        return false;
    }

    fn rawHeapCapsFree(
        _: *anyopaque,
        buf: []u8,
        log2_old_align: u8,
        ret_addr: usize,
    ) void {
        _ = log2_old_align;
        _ = ret_addr;
        std.debug.assert(idf.heap_caps_check_integrity_all(true));
        idf.heap_caps_free(buf.ptr);
    }
};

// Alocator for use with raw_multi_heap_allocator
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
                .alloc = rawMultiHeapAlloc,
                .resize = rawMultiHeapResize,
                .free = rawMultiHeapFree,
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

    fn rawMultiHeapAlloc(
        ctx: *anyopaque,
        len: usize,
        log2_ptr_align: u8,
        ret_addr: usize,
    ) ?[*]u8 {
        _ = ret_addr;
        const self: *Self = @ptrCast(@alignCast(ctx));
        std.debug.assert(log2_ptr_align <= comptime std.math.log2_int(
            usize,
            @alignOf(std.c.max_align_t),
        ));
        return @as(?[*]u8, @ptrCast(
            idf.multi_heap_malloc(self.multi_heap_alloc, idf.multi_heap_free_size(self.multi_heap_alloc) * len),
        ));
    }

    fn rawMultiHeapResize(
        _: *anyopaque,
        buf: []u8,
        log2_old_align: u8,
        new_len: usize,
        ret_addr: usize,
    ) bool {
        _ = log2_old_align;
        _ = ret_addr;
        const self: Self = .{};

        if (new_len <= buf.len)
            return true;

        if (@TypeOf(idf.multi_heap_get_allocated_size) != void)
            if (new_len <= idf.multi_heap_get_allocated_size(self.multi_heap_alloc, buf.ptr))
                return true;

        return false;
    }

    fn rawMultiHeapFree(
        _: *anyopaque,
        buf: []u8,
        log2_old_align: u8,
        ret_addr: usize,
    ) void {
        _ = log2_old_align;
        _ = ret_addr;
        const self: Self = .{};
        defer std.debug.assert(idf.multi_heap_check(self.multi_heap_alloc, true));
        idf.multi_heap_free(self.multi_heap_alloc, buf.ptr);
    }
};
