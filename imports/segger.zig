const sys = @import("sys");

pub const RTT = struct {
    pub fn allocDownBuffer(sName: [*:0]const u8, pBuffer: ?*anyopaque, BufferSize: c_uint, Flags: c_uint) c_int {
        return sys.SEGGER_RTT_AllocDownBuffer(sName, pBuffer, BufferSize, Flags);
    }
    pub fn allocUpBuffer(sName: [*:0]const u8, pBuffer: ?*anyopaque, BufferSize: c_uint, Flags: c_uint) c_int {
        return sys.SEGGER_RTT_AllocUpBuffer(sName, pBuffer, BufferSize, Flags);
    }
    pub fn configUpBuffer(BufferIndex: c_uint, sName: [*:0]const u8, pBuffer: ?*anyopaque, BufferSize: c_uint, Flags: c_uint) c_int {
        return sys.SEGGER_RTT_ConfigUpBuffer(BufferIndex, sName, pBuffer, BufferSize, Flags);
    }
    pub fn configDownBuffer(BufferIndex: c_uint, sName: [*:0]const u8, pBuffer: ?*anyopaque, BufferSize: c_uint, Flags: c_uint) c_int {
        return sys.SEGGER_RTT_ConfigDownBuffer(BufferIndex, sName, pBuffer, BufferSize, Flags);
    }
    pub fn getKey() c_int {
        return sys.SEGGER_RTT_GetKey();
    }
    pub fn hasData(BufferIndex: c_uint) c_uint {
        return sys.SEGGER_RTT_HasData(BufferIndex);
    }
    pub fn hasKey() c_int {
        return sys.SEGGER_RTT_HasKey();
    }
    pub fn hasDataUp(BufferIndex: c_uint) c_uint {
        return sys.SEGGER_RTT_HasDataUp(BufferIndex);
    }
    pub fn init() void {
        sys.SEGGER_RTT_Init();
    }
    pub fn read(BufferIndex: c_uint, pBuffer: ?*anyopaque, BufferSize: c_uint) c_uint {
        return sys.SEGGER_RTT_Read(BufferIndex, pBuffer, BufferSize);
    }
    pub fn readNoLock(BufferIndex: c_uint, pData: ?*anyopaque, BufferSize: c_uint) c_uint {
        return sys.SEGGER_RTT_ReadNoLock(BufferIndex, pData, BufferSize);
    }
    pub fn setNameDownBuffer(BufferIndex: c_uint, sName: [*:0]const u8) c_int {
        return sys.SEGGER_RTT_SetNameDownBuffer(BufferIndex, sName);
    }
    pub fn setNameUpBuffer(BufferIndex: c_uint, sName: [*:0]const u8) c_int {
        return sys.SEGGER_RTT_SetNameUpBuffer(BufferIndex, sName);
    }
    pub fn setFlagsDownBuffer(BufferIndex: c_uint, Flags: c_uint) c_int {
        return sys.SEGGER_RTT_SetFlagsDownBuffer(BufferIndex, Flags);
    }
    pub fn setFlagsUpBuffer(BufferIndex: c_uint, Flags: c_uint) c_int {
        return sys.SEGGER_RTT_SetFlagsUpBuffer(BufferIndex, Flags);
    }
    pub fn waitKey() c_int {
        return sys.SEGGER_RTT_WaitKey();
    }
    pub fn write(BufferIndex: c_uint, pBuffer: ?*const anyopaque, NumBytes: c_uint) c_uint {
        return sys.SEGGER_RTT_Write(BufferIndex, pBuffer, NumBytes);
    }
    // pub fn WriteNoLock(BufferIndex: c_uint, pBuffer: ?*const anyopaque, NumBytes: c_uint) c_uint;
    // pub fn WriteSkipNoLock(BufferIndex: c_uint, pBuffer: ?*const anyopaque, NumBytes: c_uint) c_uint;
    // pub fn ASM_WriteSkipNoLock(BufferIndex: c_uint, pBuffer: ?*const anyopaque, NumBytes: c_uint) c_uint;
    // pub fn WriteString(BufferIndex: c_uint, s: [*:0]const u8) c_uint;
    // pub fn WriteWithOverwriteNoLock(BufferIndex: c_uint, pBuffer: ?*const anyopaque, NumBytes: c_uint) void;
    // pub fn PutChar(BufferIndex: c_uint, c: u8) c_uint;
    // pub fn PutCharSkip(BufferIndex: c_uint, c: u8) c_uint;
    // pub fn PutCharSkipNoLock(BufferIndex: c_uint, c: u8) c_uint;
    // pub fn GetAvailWriteSpace(BufferIndex: c_uint) c_uint;
    // pub fn GetBytesInBuffer(BufferIndex: c_uint) c_uint;
    // pub fn ESP_FlushNoLock(min_sz: c_ulong, tmo: c_ulong) void;
    // pub fn ESP_Flush(min_sz: c_ulong, tmo: c_ulong) void;
    // pub fn ReadUpBuffer(BufferIndex: c_uint, pBuffer: ?*anyopaque, BufferSize: c_uint) c_uint;
    // pub fn ReadUpBufferNoLock(BufferIndex: c_uint, pData: ?*anyopaque, BufferSize: c_uint) c_uint;
    // pub fn WriteDownBuffer(BufferIndex: c_uint, pBuffer: ?*const anyopaque, NumBytes: c_uint) c_uint;
    // pub fn WriteDownBufferNoLock(BufferIndex: c_uint, pBuffer: ?*const anyopaque, NumBytes: c_uint) c_uint;
    pub fn setTerminal(TerminalId: u8) c_int {
        return sys.SEGGER_RTT_SetTerminal(TerminalId);
    }
    pub fn terminalOut(TerminalId: u8, s: [*:0]const u8) c_int {
        return sys.SEGGER_RTT_TerminalOut(TerminalId, s);
    }
    pub const printf = sys.SEGGER_RTT_printf;
    pub fn vprintf(BufferIndex: c_uint, sFormat: [*:0]const u8, pParamList: [*c]sys.va_list) c_int {
        return sys.SEGGER_RTT_vprintf(BufferIndex, sFormat, pParamList);
    }
};
