const sys = @import("sys");
const errors = @import("error");

// ---------------------------------------------------------------------------
// Type aliases
// ---------------------------------------------------------------------------

pub const Partition = sys.esp_partition_t;
pub const Iterator = sys.esp_partition_iterator_t;
pub const MmapHandle = sys.esp_partition_mmap_handle_t;

pub const Type = enum(sys.esp_partition_type_t) {
    app = sys.ESP_PARTITION_TYPE_APP,
    data = sys.ESP_PARTITION_TYPE_DATA,
    bootloader = sys.ESP_PARTITION_TYPE_BOOTLOADER,
    partition_table = sys.ESP_PARTITION_TYPE_PARTITION_TABLE,
    any = sys.ESP_PARTITION_TYPE_ANY,
};

pub const Subtype = enum(sys.esp_partition_subtype_t) {
    // APP subtypes
    app_factory = sys.ESP_PARTITION_SUBTYPE_APP_FACTORY,
    app_ota_0 = sys.ESP_PARTITION_SUBTYPE_APP_OTA_0,
    app_ota_1 = sys.ESP_PARTITION_SUBTYPE_APP_OTA_1,
    app_ota_2 = sys.ESP_PARTITION_SUBTYPE_APP_OTA_2,
    app_ota_3 = sys.ESP_PARTITION_SUBTYPE_APP_OTA_3,
    app_test = sys.ESP_PARTITION_SUBTYPE_APP_TEST,
    // DATA subtypes
    data_ota = sys.ESP_PARTITION_SUBTYPE_DATA_OTA,
    data_phy = sys.ESP_PARTITION_SUBTYPE_DATA_PHY,
    data_nvs = sys.ESP_PARTITION_SUBTYPE_DATA_NVS,
    data_coredump = sys.ESP_PARTITION_SUBTYPE_DATA_COREDUMP,
    data_nvs_keys = sys.ESP_PARTITION_SUBTYPE_DATA_NVS_KEYS,
    data_fat = sys.ESP_PARTITION_SUBTYPE_DATA_FAT,
    data_spiffs = sys.ESP_PARTITION_SUBTYPE_DATA_SPIFFS,
    // Catch-all
    any = sys.ESP_PARTITION_SUBTYPE_ANY,
};

pub const MmapMemory = enum(sys.esp_partition_mmap_memory_t) {
    data = sys.ESP_PARTITION_MMAP_DATA,
    inst = sys.ESP_PARTITION_MMAP_INST,
};

// ---------------------------------------------------------------------------
// Find
// ---------------------------------------------------------------------------

/// Return an iterator over all partitions that match `type`, `subtype`, and
/// optional `label`.  Release with `iteratorRelease` when done.
pub fn find(part_type: Type, subtype: Subtype, label: ?[*:0]const u8) Iterator {
    return sys.esp_partition_find(
        @intFromEnum(part_type),
        @intFromEnum(subtype),
        label,
    );
}

/// Return a pointer to the first matching partition, or null if none found.
pub fn findFirst(part_type: Type, subtype: Subtype, label: ?[*:0]const u8) ?*const Partition {
    return sys.esp_partition_find_first(
        @intFromEnum(part_type),
        @intFromEnum(subtype),
        label,
    );
}

// ---------------------------------------------------------------------------
// Iterator
// ---------------------------------------------------------------------------

/// Return the partition pointed to by the iterator, or null at end.
pub fn iteratorGet(it: Iterator) ?*const Partition {
    return sys.esp_partition_get(it);
}

/// Advance the iterator by one step. Returns null when exhausted.
pub fn iteratorNext(it: Iterator) Iterator {
    return sys.esp_partition_next(it);
}

/// Release an iterator obtained via `find`.
pub fn iteratorRelease(it: Iterator) void {
    sys.esp_partition_iterator_release(it);
}

// ---------------------------------------------------------------------------
// Read / Write / Erase
// ---------------------------------------------------------------------------

/// Read `size` bytes from `partition` at `src_offset` into `dst`.
pub fn read(partition: *const Partition, src_offset: usize, dst: []u8) !void {
    try errors.espCheckError(sys.esp_partition_read(partition, src_offset, dst.ptr, dst.len));
}

/// Write `src` bytes to `partition` at `dst_offset`.
/// The region must have been erased first.
pub fn write(partition: *const Partition, dst_offset: usize, src: []const u8) !void {
    try errors.espCheckError(sys.esp_partition_write(partition, dst_offset, src.ptr, src.len));
}

/// Read without decryption (raw flash content).
pub fn readRaw(partition: *const Partition, src_offset: usize, dst: []u8) !void {
    try errors.espCheckError(sys.esp_partition_read_raw(partition, src_offset, dst.ptr, dst.len));
}

/// Write without encryption (raw flash write).
pub fn writeRaw(partition: *const Partition, dst_offset: usize, src: []const u8) !void {
    try errors.espCheckError(sys.esp_partition_write_raw(partition, dst_offset, src.ptr, src.len));
}

/// Erase `size` bytes starting at `offset`.
/// Both `offset` and `size` must be aligned to 4096 bytes (the sector size).
pub fn eraseRange(partition: *const Partition, offset: usize, size: usize) !void {
    try errors.espCheckError(sys.esp_partition_erase_range(partition, offset, size));
}

// ---------------------------------------------------------------------------
// Memory-map
// ---------------------------------------------------------------------------

/// Memory-map a region of a partition into the CPU's address space.
/// Returns `(ptr, handle)` — call `munmap(handle)` when done.
pub fn mmap(
    partition: *const Partition,
    offset: usize,
    size: usize,
    memory: MmapMemory,
) !struct { ptr: *const anyopaque, handle: MmapHandle } {
    var out_ptr: ?*const anyopaque = null;
    var out_handle: MmapHandle = 0;
    try errors.espCheckError(sys.esp_partition_mmap(
        partition,
        offset,
        size,
        @intFromEnum(memory),
        &out_ptr,
        &out_handle,
    ));
    return .{ .ptr = out_ptr.?, .handle = out_handle };
}

/// Unmap a previously mapped partition region.
pub fn munmap(handle: MmapHandle) void {
    sys.esp_partition_munmap(handle);
}

// ---------------------------------------------------------------------------
// Utilities
// ---------------------------------------------------------------------------

/// Fill `sha_256` (must be 32 bytes) with the SHA-256 of the partition contents.
pub fn getSha256(partition: *const Partition, sha_256: *[32]u8) !void {
    try errors.espCheckError(sys.esp_partition_get_sha256(partition, sha_256));
}

/// Returns true if two partitions have identical content.
pub fn checkIdentity(p1: *const Partition, p2: *const Partition) bool {
    return sys.esp_partition_check_identity(p1, p2);
}

/// Copy `size` bytes from `src_part` (at `src_offset`) to `dest_part` (at `dest_offset`).
pub fn copy(
    dest_part: *const Partition,
    dest_offset: u32,
    src_part: *const Partition,
    src_offset: u32,
    size: usize,
) !void {
    try errors.espCheckError(sys.esp_partition_copy(dest_part, dest_offset, src_part, src_offset, size));
}
