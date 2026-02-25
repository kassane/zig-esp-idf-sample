const sys = @import("sys");
const errors = @import("error");

// ---------------------------------------------------------------------------
// Type aliases
// ---------------------------------------------------------------------------

pub const Handle = sys.nvs_handle_t;
pub const Iterator = sys.nvs_iterator_t;
pub const EntryInfo = sys.nvs_entry_info_t;
pub const Stats = sys.nvs_stats_t;

pub const OpenMode = enum(sys.nvs_open_mode_t) {
    read_only = sys.NVS_READONLY,
    read_write = sys.NVS_READWRITE,
};

pub const Type = enum(sys.nvs_type_t) {
    u8 = sys.NVS_TYPE_U8,
    i8 = sys.NVS_TYPE_I8,
    u16 = sys.NVS_TYPE_U16,
    i16 = sys.NVS_TYPE_I16,
    u32 = sys.NVS_TYPE_U32,
    i32 = sys.NVS_TYPE_I32,
    u64 = sys.NVS_TYPE_U64,
    i64 = sys.NVS_TYPE_I64,
    str = sys.NVS_TYPE_STR,
    blob = sys.NVS_TYPE_BLOB,
    any = sys.NVS_TYPE_ANY,
};

// ---------------------------------------------------------------------------
// Flash initialisation
// ---------------------------------------------------------------------------

/// Initialise NVS flash with the default "nvs" partition.
/// Call once at boot before opening any handles.
pub fn flashInit() !void {
    try errors.espCheckError(sys.nvs_flash_init());
}

/// Initialise NVS flash on an explicitly named partition.
pub fn flashInitPartition(partition_label: [*:0]const u8) !void {
    try errors.espCheckError(sys.nvs_flash_init_partition(partition_label));
}

/// Initialise NVS flash, erasing the default partition if it has no free pages
/// or if an incompatible version was found. This is the pattern recommended by
/// Espressif for robust boot-time NVS initialisation.
pub fn flashInitOrErase() !void {
    const rc = sys.nvs_flash_init();
    if (rc == sys.ESP_ERR_NVS_NO_FREE_PAGES or rc == sys.ESP_ERR_NVS_NEW_VERSION_FOUND) {
        try errors.espCheckError(sys.nvs_flash_erase());
        try errors.espCheckError(sys.nvs_flash_init());
    } else {
        try errors.espCheckError(rc);
    }
}

/// De-initialise the default NVS partition.
pub fn flashDeinit() !void {
    try errors.espCheckError(sys.nvs_flash_deinit());
}

/// De-initialise a named NVS partition.
pub fn flashDeinitPartition(partition_label: [*:0]const u8) !void {
    try errors.espCheckError(sys.nvs_flash_deinit_partition(partition_label));
}

/// Erase all data in the default NVS partition (loses all stored values).
pub fn flashErase() !void {
    try errors.espCheckError(sys.nvs_flash_erase());
}

/// Erase all data in a named NVS partition.
pub fn flashErasePartition(part_name: [*:0]const u8) !void {
    try errors.espCheckError(sys.nvs_flash_erase_partition(part_name));
}

// ---------------------------------------------------------------------------
// Handle open / close
// ---------------------------------------------------------------------------

/// Open an NVS namespace in the default "nvs" partition.
pub fn open(namespace: [*:0]const u8, mode: OpenMode) !Handle {
    var handle: Handle = 0;
    try errors.espCheckError(sys.nvs_open(namespace, @intFromEnum(mode), &handle));
    return handle;
}

/// Open an NVS namespace on a specific partition.
pub fn openFromPartition(part_name: [*:0]const u8, namespace: [*:0]const u8, mode: OpenMode) !Handle {
    var handle: Handle = 0;
    try errors.espCheckError(sys.nvs_open_from_partition(part_name, namespace, @intFromEnum(mode), &handle));
    return handle;
}

/// Close an NVS handle. Must be called to release resources.
pub fn close(handle: Handle) void {
    sys.nvs_close(handle);
}

/// Commit pending writes. Must be called after set operations to persist data.
pub fn commit(handle: Handle) !void {
    try errors.espCheckError(sys.nvs_commit(handle));
}

// ---------------------------------------------------------------------------
// Write (set) operations
// ---------------------------------------------------------------------------

pub fn setI8(handle: Handle, key: [*:0]const u8, value: i8) !void {
    try errors.espCheckError(sys.nvs_set_i8(handle, key, value));
}

pub fn setU8(handle: Handle, key: [*:0]const u8, value: u8) !void {
    try errors.espCheckError(sys.nvs_set_u8(handle, key, value));
}

pub fn setI16(handle: Handle, key: [*:0]const u8, value: i16) !void {
    try errors.espCheckError(sys.nvs_set_i16(handle, key, value));
}

pub fn setU16(handle: Handle, key: [*:0]const u8, value: u16) !void {
    try errors.espCheckError(sys.nvs_set_u16(handle, key, value));
}

pub fn setI32(handle: Handle, key: [*:0]const u8, value: i32) !void {
    try errors.espCheckError(sys.nvs_set_i32(handle, key, value));
}

pub fn setU32(handle: Handle, key: [*:0]const u8, value: u32) !void {
    try errors.espCheckError(sys.nvs_set_u32(handle, key, value));
}

pub fn setI64(handle: Handle, key: [*:0]const u8, value: i64) !void {
    try errors.espCheckError(sys.nvs_set_i64(handle, key, value));
}

pub fn setU64(handle: Handle, key: [*:0]const u8, value: u64) !void {
    try errors.espCheckError(sys.nvs_set_u64(handle, key, value));
}

/// Store a null-terminated string. The key limit is 15 characters.
pub fn setStr(handle: Handle, key: [*:0]const u8, value: [*:0]const u8) !void {
    try errors.espCheckError(sys.nvs_set_str(handle, key, value));
}

/// Store a binary blob of arbitrary length.
pub fn setBlob(handle: Handle, key: [*:0]const u8, value: []const u8) !void {
    try errors.espCheckError(sys.nvs_set_blob(handle, key, value.ptr, value.len));
}

// ---------------------------------------------------------------------------
// Read (get) operations
// ---------------------------------------------------------------------------

pub fn getI8(handle: Handle, key: [*:0]const u8) !i8 {
    var v: i8 = 0;
    try errors.espCheckError(sys.nvs_get_i8(handle, key, &v));
    return v;
}

pub fn getU8(handle: Handle, key: [*:0]const u8) !u8 {
    var v: u8 = 0;
    try errors.espCheckError(sys.nvs_get_u8(handle, key, &v));
    return v;
}

pub fn getI16(handle: Handle, key: [*:0]const u8) !i16 {
    var v: i16 = 0;
    try errors.espCheckError(sys.nvs_get_i16(handle, key, &v));
    return v;
}

pub fn getU16(handle: Handle, key: [*:0]const u8) !u16 {
    var v: u16 = 0;
    try errors.espCheckError(sys.nvs_get_u16(handle, key, &v));
    return v;
}

pub fn getI32(handle: Handle, key: [*:0]const u8) !i32 {
    var v: i32 = 0;
    try errors.espCheckError(sys.nvs_get_i32(handle, key, &v));
    return v;
}

pub fn getU32(handle: Handle, key: [*:0]const u8) !u32 {
    var v: u32 = 0;
    try errors.espCheckError(sys.nvs_get_u32(handle, key, &v));
    return v;
}

pub fn getI64(handle: Handle, key: [*:0]const u8) !i64 {
    var v: i64 = 0;
    try errors.espCheckError(sys.nvs_get_i64(handle, key, &v));
    return v;
}

pub fn getU64(handle: Handle, key: [*:0]const u8) !u64 {
    var v: u64 = 0;
    try errors.espCheckError(sys.nvs_get_u64(handle, key, &v));
    return v;
}

/// Read a string value.
/// Pass `buf = null` with `buf_len` pointing to 0 first to query the required size.
/// Then allocate `buf_len` bytes and call again.
pub fn getStr(handle: Handle, key: [*:0]const u8, buf: ?[*]u8, buf_len: *usize) !void {
    try errors.espCheckError(sys.nvs_get_str(handle, key, buf, buf_len));
}

/// Read a blob value.
/// Pass `buf = null` with `buf_len` pointing to 0 first to query the required size.
pub fn getBlob(handle: Handle, key: [*:0]const u8, buf: ?*anyopaque, buf_len: *usize) !void {
    try errors.espCheckError(sys.nvs_get_blob(handle, key, buf, buf_len));
}

// ---------------------------------------------------------------------------
// Key management
// ---------------------------------------------------------------------------

/// Returns the type stored for `key`, or an error if the key does not exist.
pub fn findKey(handle: Handle, key: [*:0]const u8) !Type {
    var t: sys.nvs_type_t = 0;
    try errors.espCheckError(sys.nvs_find_key(handle, key, &t));
    return @enumFromInt(t);
}

/// Erase a single key from the namespace.
pub fn eraseKey(handle: Handle, key: [*:0]const u8) !void {
    try errors.espCheckError(sys.nvs_erase_key(handle, key));
}

/// Erase all keys in the namespace.
pub fn eraseAll(handle: Handle) !void {
    try errors.espCheckError(sys.nvs_erase_all(handle));
}

// ---------------------------------------------------------------------------
// Statistics
// ---------------------------------------------------------------------------

/// Get storage statistics for a partition (pass `null` for the default "nvs" partition).
pub fn getStats(part_name: ?[*:0]const u8, stats: *Stats) !void {
    try errors.espCheckError(sys.nvs_get_stats(part_name, stats));
}

/// Get the number of used entries for an open handle's namespace.
pub fn getUsedEntryCount(handle: Handle) !usize {
    var count: usize = 0;
    try errors.espCheckError(sys.nvs_get_used_entry_count(handle, &count));
    return count;
}

// ---------------------------------------------------------------------------
// Iteration
// ---------------------------------------------------------------------------

/// Find an iterator over entries matching the given partition, namespace, and type.
/// Release with `releaseIterator` when done.
pub fn entryFind(
    part_name: ?[*:0]const u8,
    namespace: ?[*:0]const u8,
    nvs_type: Type,
) !Iterator {
    var it: Iterator = null;
    try errors.espCheckError(sys.nvs_entry_find(part_name, namespace, @intFromEnum(nvs_type), &it));
    return it;
}

/// Find an iterator over entries in an open handle matching the given type.
pub fn entryFindInHandle(handle: Handle, nvs_type: Type) !Iterator {
    var it: Iterator = null;
    try errors.espCheckError(sys.nvs_entry_find_in_handle(handle, @intFromEnum(nvs_type), &it));
    return it;
}

/// Advance the iterator to the next entry. Returns error when no more entries.
pub fn entryNext(it: *Iterator) !void {
    try errors.espCheckError(sys.nvs_entry_next(it));
}

/// Fill `info` with details about the current iterator position.
pub fn entryInfo(it: Iterator, info: *EntryInfo) !void {
    try errors.espCheckError(sys.nvs_entry_info(it, info));
}

/// Release an iterator obtained with `entryFind`.
pub fn releaseIterator(it: Iterator) void {
    sys.nvs_release_iterator(it);
}
