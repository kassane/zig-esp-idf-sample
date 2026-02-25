const sys = @import("sys");

/// SEGGER RTT channel flags
pub const Flags = enum(c_uint) {
    no_block_skip = 0,
    no_block_trim = 1,
    block_if_fifo_full = 2,
    _,
};

/// Errors returned by RTT operations
pub const Error = error{
    /// Buffer index out of range or channel not configured
    InvalidBuffer,
    /// Write was skipped (no-block mode, FIFO full)
    WriteSkipped,
};

fn rttResult(rc: c_int) Error!void {
    if (rc < 0) return error.InvalidBuffer;
}

pub const RTT = struct {
    // -------------------------------------------------------------------------
    // Init
    // -------------------------------------------------------------------------

    pub fn init() void {
        sys.SEGGER_RTT_Init();
    }

    // -------------------------------------------------------------------------
    // Buffer allocation / configuration
    // -------------------------------------------------------------------------

    /// Allocate an additional up-buffer (target → host).
    /// Returns the buffer index or `error.InvalidBuffer`.
    pub fn allocUpBuffer(name: [:0]const u8, buf: []u8, flags: Flags) Error!c_uint {
        const rc = sys.SEGGER_RTT_AllocUpBuffer(name.ptr, buf.ptr, @intCast(buf.len), @intFromEnum(flags));
        if (rc < 0) return error.InvalidBuffer;
        return @intCast(rc);
    }

    /// Allocate an additional down-buffer (host → target).
    pub fn allocDownBuffer(name: [:0]const u8, buf: []u8, flags: Flags) Error!c_uint {
        const rc = sys.SEGGER_RTT_AllocDownBuffer(name.ptr, buf.ptr, @intCast(buf.len), @intFromEnum(flags));
        if (rc < 0) return error.InvalidBuffer;
        return @intCast(rc);
    }

    /// Reconfigure an existing up-buffer.
    pub fn configUpBuffer(idx: c_uint, name: [:0]const u8, buf: []u8, flags: Flags) Error!void {
        return rttResult(sys.SEGGER_RTT_ConfigUpBuffer(idx, name.ptr, buf.ptr, @intCast(buf.len), @intFromEnum(flags)));
    }

    /// Reconfigure an existing down-buffer.
    pub fn configDownBuffer(idx: c_uint, name: [:0]const u8, buf: []u8, flags: Flags) Error!void {
        return rttResult(sys.SEGGER_RTT_ConfigDownBuffer(idx, name.ptr, buf.ptr, @intCast(buf.len), @intFromEnum(flags)));
    }

    // -------------------------------------------------------------------------
    // Rename / re-flag existing channels
    // -------------------------------------------------------------------------

    pub fn setNameUpBuffer(idx: c_uint, name: [:0]const u8) Error!void {
        return rttResult(sys.SEGGER_RTT_SetNameUpBuffer(idx, name.ptr));
    }

    pub fn setNameDownBuffer(idx: c_uint, name: [:0]const u8) Error!void {
        return rttResult(sys.SEGGER_RTT_SetNameDownBuffer(idx, name.ptr));
    }

    pub fn setFlagsUpBuffer(idx: c_uint, flags: Flags) Error!void {
        return rttResult(sys.SEGGER_RTT_SetFlagsUpBuffer(idx, @intFromEnum(flags)));
    }

    pub fn setFlagsDownBuffer(idx: c_uint, flags: Flags) Error!void {
        return rttResult(sys.SEGGER_RTT_SetFlagsDownBuffer(idx, @intFromEnum(flags)));
    }

    // -------------------------------------------------------------------------
    // Write (target → host)
    // -------------------------------------------------------------------------

    /// Write bytes to an up-buffer.  Returns the number of bytes actually written.
    pub fn write(idx: c_uint, data: []const u8) c_uint {
        return sys.SEGGER_RTT_Write(idx, data.ptr, @intCast(data.len));
    }

    /// Write bytes without locking (call only from within a lock / ISR context).
    pub fn writeNoLock(idx: c_uint, data: []const u8) c_uint {
        return sys.SEGGER_RTT_WriteNoLock(idx, data.ptr, @intCast(data.len));
    }

    /// Write bytes, overwriting old data if the FIFO is full (no-lock variant).
    pub fn writeWithOverwriteNoLock(idx: c_uint, data: []const u8) void {
        sys.SEGGER_RTT_WriteWithOverwriteNoLock(idx, data.ptr, @intCast(data.len));
    }

    /// Write a single character to an up-buffer.  Returns 1 on success, 0 if skipped.
    pub fn putChar(idx: c_uint, c: u8) bool {
        return sys.SEGGER_RTT_PutChar(idx, c) != 0;
    }

    /// Write a single character; skip (don't wait) if full.
    pub fn putCharSkip(idx: c_uint, c: u8) bool {
        return sys.SEGGER_RTT_PutCharSkip(idx, c) != 0;
    }

    /// Write a null-terminated string to an up-buffer.
    pub fn writeString(idx: c_uint, s: [:0]const u8) c_uint {
        return sys.SEGGER_RTT_WriteString(idx, s.ptr);
    }

    /// Formatted print to an up-buffer (wraps `SEGGER_RTT_printf`).
    pub const printf = sys.SEGGER_RTT_printf;

    /// Formatted print using a `va_list`.
    pub fn vprintf(idx: c_uint, fmt: [:0]const u8, args: [*c]sys.va_list) Error!void {
        return rttResult(sys.SEGGER_RTT_vprintf(idx, fmt.ptr, args));
    }

    // -------------------------------------------------------------------------
    // Read (host → target)
    // -------------------------------------------------------------------------

    /// Read bytes from a down-buffer into `out`.
    /// Returns the number of bytes actually read.
    pub fn read(idx: c_uint, out: []u8) c_uint {
        return sys.SEGGER_RTT_Read(idx, out.ptr, @intCast(out.len));
    }

    /// Read without locking — use only from a locked / ISR context.
    pub fn readNoLock(idx: c_uint, out: []u8) c_uint {
        return sys.SEGGER_RTT_ReadNoLock(idx, out.ptr, @intCast(out.len));
    }

    /// Read from an up-buffer (host-side mirror; rarely needed on target).
    pub fn readUpBuffer(idx: c_uint, out: []u8) c_uint {
        return sys.SEGGER_RTT_ReadUpBuffer(idx, out.ptr, @intCast(out.len));
    }

    pub fn readUpBufferNoLock(idx: c_uint, out: []u8) c_uint {
        return sys.SEGGER_RTT_ReadUpBufferNoLock(idx, out.ptr, @intCast(out.len));
    }

    // -------------------------------------------------------------------------
    // Keyboard / single-char helpers
    // -------------------------------------------------------------------------

    /// Read one byte from down-buffer 0.  Returns -1 if no data available.
    pub fn getKey() ?u8 {
        const rc = sys.SEGGER_RTT_GetKey();
        return if (rc < 0) null else @intCast(rc);
    }

    /// Block until a byte is available on down-buffer 0.
    pub fn waitKey() u8 {
        return @intCast(sys.SEGGER_RTT_WaitKey());
    }

    /// Returns `true` if at least one byte is available in the given down-buffer.
    pub fn hasData(idx: c_uint) bool {
        return sys.SEGGER_RTT_HasData(idx) != 0;
    }

    /// Returns `true` if at least one byte is available in down-buffer 0.
    pub fn hasKey() bool {
        return sys.SEGGER_RTT_HasKey() != 0;
    }

    /// Returns `true` if the given up-buffer has unread data (host hasn't read it yet).
    pub fn hasDataUp(idx: c_uint) bool {
        return sys.SEGGER_RTT_HasDataUp(idx) != 0;
    }

    // -------------------------------------------------------------------------
    // Space / occupancy queries
    // -------------------------------------------------------------------------

    /// Free space available for writing in an up-buffer (bytes).
    pub fn getAvailWriteSpace(idx: c_uint) c_uint {
        return sys.SEGGER_RTT_GetAvailWriteSpace(idx);
    }

    /// Bytes currently pending in an up-buffer (not yet consumed by host).
    pub fn getBytesInBuffer(idx: c_uint) c_uint {
        return sys.SEGGER_RTT_GetBytesInBuffer(idx);
    }

    // -------------------------------------------------------------------------
    // Multi-terminal helpers (virtual terminals over a single up-buffer)
    // -------------------------------------------------------------------------

    /// Select the active virtual terminal for subsequent writes on up-buffer 0.
    pub fn setTerminal(id: u8) Error!void {
        return rttResult(sys.SEGGER_RTT_SetTerminal(id));
    }

    /// Write a null-terminated string directly to a specific virtual terminal.
    pub fn terminalOut(id: u8, s: [:0]const u8) Error!void {
        return rttResult(sys.SEGGER_RTT_TerminalOut(id, s.ptr));
    }

    // -------------------------------------------------------------------------
    // ESP-IDF specific flush helpers
    // -------------------------------------------------------------------------

    /// Flush the RTT up-buffer without locking.
    /// `min_sz`: minimum bytes to flush; `tmo`: timeout in ms.
    pub fn espFlushNoLock(min_sz: usize, tmo_ms: usize) void {
        sys.SEGGER_RTT_ESP_FlushNoLock(@intCast(min_sz), @intCast(tmo_ms));
    }

    /// Flush the RTT up-buffer (with locking).
    pub fn espFlush(min_sz: usize, tmo_ms: usize) void {
        sys.SEGGER_RTT_ESP_Flush(@intCast(min_sz), @intCast(tmo_ms));
    }
};
