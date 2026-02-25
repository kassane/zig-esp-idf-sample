const std = @import("std");
const sys = @import("sys");

// ---------------------------------------------------------------------------
// lwIP error type — maps err_t (i8) to Zig errors.
// ---------------------------------------------------------------------------

pub const LwipError = error{
    OutOfMemory,
    BufferError,
    Timeout,
    RoutingError,
    InProgress,
    IllegalValue,
    WouldBlock,
    AddressInUse,
    AlreadyConnecting,
    AlreadyConnected,
    NotConnected,
    InterfaceError,
    Aborted,
    Reset,
    Closed,
    IllegalArgument,
};

pub fn errFromC(e: sys.err_t) LwipError!void {
    return switch (@as(sys.err_enum_t, @enumFromInt(e))) {
        .ERR_OK => {},
        .ERR_MEM => LwipError.OutOfMemory,
        .ERR_BUF => LwipError.BufferError,
        .ERR_TIMEOUT => LwipError.Timeout,
        .ERR_RTE => LwipError.RoutingError,
        .ERR_INPROGRESS => LwipError.InProgress,
        .ERR_VAL => LwipError.IllegalValue,
        .ERR_WOULDBLOCK => LwipError.WouldBlock,
        .ERR_USE => LwipError.AddressInUse,
        .ERR_ALREADY => LwipError.AlreadyConnecting,
        .ERR_ISCONN => LwipError.AlreadyConnected,
        .ERR_CONN => LwipError.NotConnected,
        .ERR_IF => LwipError.InterfaceError,
        .ERR_ABRT => LwipError.Aborted,
        .ERR_RST => LwipError.Reset,
        .ERR_CLSD => LwipError.Closed,
        .ERR_ARG => LwipError.IllegalArgument,
    };
}

// ---------------------------------------------------------------------------
// Re-export raw types callers may need.
// ---------------------------------------------------------------------------

pub const RawNetif = sys.netif;
pub const RawPbuf = sys.pbuf;
pub const RawIp4Addr = sys.ip4_addr_t;
pub const RawIp6Addr = sys.ip6_addr_t;
pub const RawIpAddr = sys.ip_addr_t;
pub const RawSockAddr = sys.sockaddr;
pub const SockLen = sys.socklen_t;
pub const AddrFamily = sys.sa_family_t;
pub const MsgHdr = sys.msghdr;
pub const AddrInfo = sys.addrinfo;
pub const HostEnt = sys.hostent;
pub const PollFd = sys.pollfd;
pub const NFds = sys.nfds_t;
pub const IoVec = sys.iovec;
pub const InAddr = sys.in_addr;
pub const In6Addr = sys.in6_addr;
pub const SockAddrIn = sys.sockaddr_in;
pub const SockAddrIn6 = sys.sockaddr_in6;
pub const SockAddrStore = sys.sockaddr_storage;
pub const IpMreq = sys.ip_mreq;
pub const Ipv6Mreq = sys.ipv6_mreq;
pub const Linger = sys.linger;
pub const InPktInfo = sys.in_pktinfo;
pub const IpAddrType = sys.enum_lwip_ip_addr_type;
pub const NetifMacFilterAction = sys.enum_netif_mac_filter_action;
pub const PbufLayer = sys.pbuf_layer;
pub const PbufType = sys.pbuf_type;
pub const MempType = sys.memp_t;
pub const DnsCb = sys.dns_found_callback;
pub const NetifExtCbFn = sys.netif_ext_callback_fn;
pub const NetifNscReason = sys.netif_nsc_reason_t;
pub const SysThreadCoreLock = sys.sys_thread_core_lock_t;
pub const LwipSock = sys.lwip_sock;

// ---------------------------------------------------------------------------
// IP address helpers
// ---------------------------------------------------------------------------

pub const Ip4Addr = struct {
    raw: RawIp4Addr,

    pub fn fromString(s: [*:0]const u8) ?Ip4Addr {
        var a: RawIp4Addr = undefined;
        if (sys.ip4addr_aton(s, &a) == 0) return null;
        return .{ .raw = a };
    }

    pub fn toString(self: *const Ip4Addr, buf: []u8) ?[]const u8 {
        const p = sys.ip4addr_ntoa_r(&self.raw, buf.ptr, @intCast(buf.len));
        if (p == null) return null;
        return std.mem.sliceTo(p, 0);
    }

    pub fn isbroadcast(self: Ip4Addr, netif: *const RawNetif) bool {
        return sys.ip4_addr_isbroadcast_u32(self.raw.addr, netif) != 0;
    }

    pub fn netmaskValid(self: Ip4Addr) bool {
        return sys.ip4_addr_netmask_valid(self.raw.addr) != 0;
    }
};

pub const Ip6Addr = struct {
    raw: RawIp6Addr,

    pub fn fromString(s: [*:0]const u8) ?Ip6Addr {
        var a: RawIp6Addr = undefined;
        if (sys.ip6addr_aton(s, &a) == 0) return null;
        return .{ .raw = a };
    }

    pub fn toString(self: *const Ip6Addr, buf: []u8) ?[]const u8 {
        const p = sys.ip6addr_ntoa_r(&self.raw, buf.ptr, @intCast(buf.len));
        if (p == null) return null;
        return std.mem.sliceTo(p, 0);
    }
};

pub const IpAddr = struct {
    raw: RawIpAddr,

    pub fn fromString(s: [*:0]const u8) ?IpAddr {
        var a: RawIpAddr = undefined;
        if (sys.ipaddr_aton(s, &a) == 0) return null;
        return .{ .raw = a };
    }

    pub fn toString(self: *const IpAddr, buf: []u8) ?[]const u8 {
        const p = sys.ipaddr_ntoa_r(&self.raw, buf.ptr, @intCast(buf.len));
        if (p == null) return null;
        return std.mem.sliceTo(p, 0);
    }
};

// ---------------------------------------------------------------------------
// Socket API
// ---------------------------------------------------------------------------

/// A file descriptor returned by socket(). Negative values are invalid.
pub const Socket = struct {
    fd: c_int,

    pub fn isValid(self: Socket) bool {
        return self.fd >= 0;
    }

    // -- Lifecycle ----------------------------------------------------------

    pub fn create(domain: c_int, kind: c_int, protocol: c_int) !Socket {
        const fd = sys.lwip_socket(domain, kind, protocol);
        if (fd < 0) return LwipError.InterfaceError;
        return .{ .fd = fd };
    }

    pub fn close(self: Socket) !void {
        if (sys.lwip_close(self.fd) != 0) return LwipError.InterfaceError;
    }

    pub fn shutdown(self: Socket, how: c_int) !void {
        if (sys.lwip_shutdown(self.fd, how) != 0) return LwipError.InterfaceError;
    }

    // -- Address binding / connection ---------------------------------------

    pub fn bind(self: Socket, addr: *const RawSockAddr, len: SockLen) !void {
        if (sys.lwip_bind(self.fd, addr, len) != 0) return LwipError.AddressInUse;
    }

    pub fn listen(self: Socket, backlog: c_int) !void {
        if (sys.lwip_listen(self.fd, backlog) != 0) return LwipError.InterfaceError;
    }

    pub fn accept(self: Socket, addr: ?*RawSockAddr, len: ?*SockLen) !Socket {
        const fd = sys.lwip_accept(self.fd, addr, len);
        if (fd < 0) return LwipError.NotConnected;
        return .{ .fd = fd };
    }

    pub fn connect(self: Socket, addr: *const RawSockAddr, len: SockLen) !void {
        if (sys.lwip_connect(self.fd, addr, len) != 0) return LwipError.NotConnected;
    }

    // -- Send / Receive -----------------------------------------------------

    pub fn send(self: Socket, data: []const u8, flags: c_int) !usize {
        const n = sys.lwip_send(self.fd, data.ptr, data.len, flags);
        if (n < 0) return LwipError.InterfaceError;
        return @intCast(n);
    }

    pub fn sendTo(
        self: Socket,
        data: []const u8,
        flags: c_int,
        to: *const RawSockAddr,
        tolen: SockLen,
    ) !usize {
        const n = sys.lwip_sendto(self.fd, data.ptr, data.len, flags, to, tolen);
        if (n < 0) return LwipError.InterfaceError;
        return @intCast(n);
    }

    pub fn sendMsg(self: Socket, msg: *const MsgHdr, flags: c_int) !usize {
        const n = sys.lwip_sendmsg(self.fd, msg, flags);
        if (n < 0) return LwipError.InterfaceError;
        return @intCast(n);
    }

    pub fn recv(self: Socket, buf: []u8, flags: c_int) !usize {
        const n = sys.lwip_recv(self.fd, buf.ptr, buf.len, flags);
        if (n < 0) return LwipError.InterfaceError;
        return @intCast(n);
    }

    pub fn recvFrom(
        self: Socket,
        buf: []u8,
        flags: c_int,
        from: ?*RawSockAddr,
        fromlen: ?*SockLen,
    ) !usize {
        const n = sys.lwip_recvfrom(self.fd, buf.ptr, buf.len, flags, from, fromlen);
        if (n < 0) return LwipError.InterfaceError;
        return @intCast(n);
    }

    pub fn recvMsg(self: Socket, msg: *MsgHdr, flags: c_int) !usize {
        const n = sys.lwip_recvmsg(self.fd, msg, flags);
        if (n < 0) return LwipError.InterfaceError;
        return @intCast(n);
    }

    pub fn read(self: Socket, buf: []u8) !usize {
        const n = sys.lwip_read(self.fd, buf.ptr, buf.len);
        if (n < 0) return LwipError.InterfaceError;
        return @intCast(n);
    }

    pub fn write(self: Socket, data: []const u8) !usize {
        const n = sys.lwip_write(self.fd, data.ptr, data.len);
        if (n < 0) return LwipError.InterfaceError;
        return @intCast(n);
    }

    pub fn readv(self: Socket, iov: []const IoVec) !usize {
        const n = sys.lwip_readv(self.fd, iov.ptr, @intCast(iov.len));
        if (n < 0) return LwipError.InterfaceError;
        return @intCast(n);
    }

    pub fn writev(self: Socket, iov: []const IoVec) !usize {
        const n = sys.lwip_writev(self.fd, iov.ptr, @intCast(iov.len));
        if (n < 0) return LwipError.InterfaceError;
        return @intCast(n);
    }

    // -- Socket options -----------------------------------------------------

    pub fn setOpt(
        self: Socket,
        level: c_int,
        optname: c_int,
        optval: *const anyopaque,
        optlen: SockLen,
    ) !void {
        if (sys.lwip_setsockopt(self.fd, level, optname, optval, optlen) != 0)
            return LwipError.IllegalArgument;
    }

    pub fn getOpt(
        self: Socket,
        level: c_int,
        optname: c_int,
        optval: *anyopaque,
        optlen: *SockLen,
    ) !void {
        if (sys.lwip_getsockopt(self.fd, level, optname, optval, optlen) != 0)
            return LwipError.IllegalArgument;
    }

    pub fn setOptExt(
        self: *LwipSock,
        level: c_int,
        optname: c_int,
        optval: *const anyopaque,
        optlen: u32,
    ) !void {
        var err_code: c_int = 0;
        if (!sys.lwip_setsockopt_impl_ext(self, level, optname, optval, optlen, &err_code))
            return LwipError.IllegalArgument;
    }

    pub fn getOptExt(
        self: *LwipSock,
        level: c_int,
        optname: c_int,
        optval: *anyopaque,
        optlen: *u32,
    ) !void {
        var err_code: c_int = 0;
        if (!sys.lwip_getsockopt_impl_ext(self, level, optname, optval, optlen, &err_code))
            return LwipError.IllegalArgument;
    }

    // -- Name queries -------------------------------------------------------

    pub fn getPeerName(self: Socket, addr: *RawSockAddr, len: *SockLen) !void {
        if (sys.lwip_getpeername(self.fd, addr, len) != 0) return LwipError.NotConnected;
    }

    pub fn getSockName(self: Socket, addr: *RawSockAddr, len: *SockLen) !void {
        if (sys.lwip_getsockname(self.fd, addr, len) != 0) return LwipError.InterfaceError;
    }

    // -- Misc ---------------------------------------------------------------

    pub fn ioctl(self: Socket, cmd: c_long, argp: ?*anyopaque) !void {
        if (sys.lwip_ioctl(self.fd, cmd, argp) != 0) return LwipError.IllegalArgument;
    }

    pub fn fcntl(self: Socket, cmd: c_int, val: c_int) !c_int {
        const r = sys.lwip_fcntl(self.fd, cmd, val);
        if (r < 0) return LwipError.IllegalArgument;
        return r;
    }
};

/// poll() over a set of sockets.
pub fn poll(fds: []PollFd, timeout_ms: c_int) !c_int {
    const r = sys.lwip_poll(fds.ptr, @intCast(fds.len), timeout_ms);
    if (r < 0) return LwipError.InterfaceError;
    return r;
}

// ---------------------------------------------------------------------------
// Address conversion
// ---------------------------------------------------------------------------

pub fn inetNtop(af: c_int, src: *const anyopaque, dst: []u8) ?[*:0]const u8 {
    return sys.lwip_inet_ntop(af, src, dst.ptr, @intCast(dst.len));
}

pub fn inetPton(af: c_int, src: [*:0]const u8, dst: *anyopaque) bool {
    return sys.lwip_inet_pton(af, src, dst) == 1;
}

// ---------------------------------------------------------------------------
// DNS
// ---------------------------------------------------------------------------

pub const Dns = struct {
    pub fn init() void {
        sys.dns_init();
    }

    pub fn setServer(index: u8, server: *const RawIpAddr) void {
        sys.dns_setserver(index, server);
    }

    pub fn getServer(index: u8) *const RawIpAddr {
        return sys.dns_getserver(index);
    }

    pub fn getHostByName(
        hostname: [*:0]const u8,
        addr: *RawIpAddr,
        callback: DnsCb,
        callback_arg: ?*anyopaque,
    ) !void {
        try errFromC(sys.dns_gethostbyname(hostname, addr, callback, callback_arg));
    }

    pub fn getHostByNameAddrType(
        hostname: [*:0]const u8,
        addr: *RawIpAddr,
        callback: DnsCb,
        callback_arg: ?*anyopaque,
        addr_type: u8,
    ) !void {
        try errFromC(sys.dns_gethostbyname_addrtype(hostname, addr, callback, callback_arg, addr_type));
    }

    pub fn clearCache() void {
        sys.dns_clear_cache();
    }

    /// Blocking getaddrinfo (uses lwip_getaddrinfo).
    pub fn getAddrInfo(
        nodename: [*:0]const u8,
        servname: [*:0]const u8,
        hints: ?*const AddrInfo,
        res: *[*c]AddrInfo,
    ) !void {
        if (sys.lwip_getaddrinfo(nodename, servname, hints, res) != 0)
            return LwipError.NotConnected;
    }

    pub fn freeAddrInfo(ai: *AddrInfo) void {
        sys.lwip_freeaddrinfo(ai);
    }

    pub fn getHostByNameR(
        name: [*:0]const u8,
        ret: *HostEnt,
        buf: []u8,
        result: *[*c]HostEnt,
        h_errnop: *c_int,
    ) !void {
        if (sys.lwip_gethostbyname_r(name, ret, buf.ptr, buf.len, result, h_errnop) != 0)
            return LwipError.NotConnected;
    }
};

// ---------------------------------------------------------------------------
// Network interface (netif)
// ---------------------------------------------------------------------------

pub const Netif = struct {
    pub fn init() void {
        sys.netif_init();
    }

    pub fn add(
        netif_ptr: *RawNetif,
        ipaddr: ?*const RawIp4Addr,
        netmask: ?*const RawIp4Addr,
        gw: ?*const RawIp4Addr,
        state: ?*anyopaque,
        init_fn: sys.netif_init_fn,
        input_fn: sys.netif_input_fn,
    ) ?*RawNetif {
        return sys.netif_add(netif_ptr, ipaddr, netmask, gw, state, init_fn, input_fn);
    }

    pub fn addNoAddr(
        netif_ptr: *RawNetif,
        state: ?*anyopaque,
        init_fn: sys.netif_init_fn,
        input_fn: sys.netif_input_fn,
    ) ?*RawNetif {
        return sys.netif_add_noaddr(netif_ptr, state, init_fn, input_fn);
    }

    pub fn remove(netif_ptr: *RawNetif) void {
        sys.netif_remove(netif_ptr);
    }

    pub fn find(name: [*:0]const u8) ?*RawNetif {
        return sys.netif_find(name);
    }

    pub fn setDefault(netif_ptr: *RawNetif) void {
        sys.netif_set_default(netif_ptr);
    }

    pub fn setAddr(
        netif_ptr: *RawNetif,
        ipaddr: *const RawIp4Addr,
        netmask: *const RawIp4Addr,
        gw: *const RawIp4Addr,
    ) void {
        sys.netif_set_addr(netif_ptr, ipaddr, netmask, gw);
    }

    pub fn setUp(netif_ptr: *RawNetif) void {
        sys.netif_set_up(netif_ptr);
    }
    pub fn setDown(netif_ptr: *RawNetif) void {
        sys.netif_set_down(netif_ptr);
    }
    pub fn setLinkUp(netif_ptr: *RawNetif) void {
        sys.netif_set_link_up(netif_ptr);
    }
    pub fn setLinkDown(netif_ptr: *RawNetif) void {
        sys.netif_set_link_down(netif_ptr);
    }

    pub fn ip6AddrSet(netif_ptr: *RawNetif, idx: i8, addr: *const RawIp6Addr) void {
        sys.netif_ip6_addr_set(netif_ptr, idx, addr);
    }

    pub fn ip6AddrSetState(netif_ptr: *RawNetif, idx: i8, state: u8) void {
        sys.netif_ip6_addr_set_state(netif_ptr, idx, state);
    }

    pub fn createIp6Linklocal(netif_ptr: *RawNetif, from_mac_48bit: bool) void {
        sys.netif_create_ip6_linklocal_address(netif_ptr, @intFromBool(from_mac_48bit));
    }

    pub fn addIp6Address(netif_ptr: *RawNetif, addr: *const RawIp6Addr, chosen_idx: *i8) !void {
        try errFromC(sys.netif_add_ip6_address(netif_ptr, addr, chosen_idx));
    }

    pub fn nameToIndex(name: [*:0]const u8) u8 {
        return sys.netif_name_to_index(name);
    }

    pub fn getByIndex(idx: u8) ?*RawNetif {
        return sys.netif_get_by_index(idx);
    }

    pub fn addExtCallback(cb: *sys.netif_ext_callback_t, func: NetifExtCbFn) void {
        sys.netif_add_ext_callback(cb, func);
    }

    pub fn removeExtCallback(cb: *sys.netif_ext_callback_t) void {
        sys.netif_remove_ext_callback(cb);
    }

    pub fn input(p: *RawPbuf, inp: *RawNetif) !void {
        try errFromC(sys.netif_input(p, inp));
    }

    pub fn loopOutput(netif_ptr: *RawNetif, p: *RawPbuf) !void {
        try errFromC(sys.netif_loop_output(netif_ptr, p));
    }

    pub fn poll(netif_ptr: *RawNetif) void {
        sys.netif_poll(netif_ptr);
    }
};

// ---------------------------------------------------------------------------
// Packet buffer (pbuf)
// ---------------------------------------------------------------------------

pub const Pbuf = struct {
    pub fn alloc(layer: PbufLayer, length: u16, kind: PbufType) ?*RawPbuf {
        return sys.pbuf_alloc(layer, length, kind);
    }

    pub fn free(p: *RawPbuf) u8 {
        return sys.pbuf_free(p);
    }

    pub fn ref(p: *RawPbuf) void {
        sys.pbuf_ref(p);
    }

    pub fn chain(head: *RawPbuf, tail: *RawPbuf) void {
        sys.pbuf_chain(head, tail);
    }

    pub fn cat(head: *RawPbuf, tail: *RawPbuf) void {
        sys.pbuf_cat(head, tail);
    }

    pub fn dechain(p: *RawPbuf) ?*RawPbuf {
        return sys.pbuf_dechain(p);
    }

    pub fn copy(dst: *RawPbuf, src: *const RawPbuf) !void {
        try errFromC(sys.pbuf_copy(dst, src));
    }

    pub fn copyPartial(p: *const RawPbuf, dst: []u8, offset: u16) u16 {
        return sys.pbuf_copy_partial(p, dst.ptr, @intCast(dst.len), offset);
    }

    pub fn take(buf: *RawPbuf, data: []const u8) !void {
        try errFromC(sys.pbuf_take(buf, data.ptr, @intCast(data.len)));
    }

    pub fn coalesce(p: *RawPbuf, layer: PbufLayer) ?*RawPbuf {
        return sys.pbuf_coalesce(p, layer);
    }

    pub fn getAt(p: *const RawPbuf, offset: u16) u8 {
        return sys.pbuf_get_at(p, offset);
    }

    pub fn putAt(p: *RawPbuf, offset: u16, data: u8) void {
        sys.pbuf_put_at(p, offset, data);
    }

    pub fn chainLength(p: *const RawPbuf) u16 {
        return sys.pbuf_clen(p);
    }

    pub fn realloc(p: *RawPbuf, size: u16) void {
        sys.pbuf_realloc(p, size);
    }

    pub fn addHeader(p: *RawPbuf, increment: usize) bool {
        return sys.pbuf_add_header(p, increment) == 0;
    }

    pub fn removeHeader(p: *RawPbuf, size: usize) bool {
        return sys.pbuf_remove_header(p, size) == 0;
    }
};

// ---------------------------------------------------------------------------
// SNTP helpers
// ---------------------------------------------------------------------------

pub const SNTP = struct {
    pub fn getSyncInterval() u32 {
        return sys.sntp_get_sync_interval();
    }
    pub fn setSystemTime(sec: u32, us: u32) void {
        sys.sntp_set_system_time(sec, us);
    }
    pub fn getSystemTime(sec: *u32, us: *u32) void {
        sys.sntp_get_system_time(sec, us);
    }
};

// ---------------------------------------------------------------------------
// lwIP OS abstraction (sys_arch_*)
// ---------------------------------------------------------------------------

pub const Sys = struct {
    pub const Sem = sys.sys_sem_t;
    pub const Mutex = sys.sys_mutex_t;
    pub const Thread = sys.sys_thread_t;
    pub const Mbox = sys.sys_mbox_t;

    pub fn init() void {
        sys.sys_init();
    }
    pub fn now() u32 {
        return sys.sys_now();
    }
    pub fn jiffies() u32 {
        return sys.sys_jiffies();
    }
    pub fn delayMs(ms: u32) void {
        sys.sys_delay_ms(ms);
    }

    pub fn semNew(sem: *Sem, count: u8) !void {
        try errFromC(sys.sys_sem_new(sem, count));
    }
    pub fn semSignal(sem: *Sem) void {
        sys.sys_sem_signal(sem);
    }
    pub fn semWait(sem: *Sem, timeout_ms: u32) u32 {
        return sys.sys_arch_sem_wait(sem, timeout_ms);
    }
    pub fn semFree(sem: *Sem) void {
        sys.sys_sem_free(sem);
    }

    pub fn mutexNew(m: *Mutex) !void {
        try errFromC(sys.sys_mutex_new(m));
    }
    pub fn mutexLock(m: *Mutex) void {
        sys.sys_mutex_lock(m);
    }
    pub fn mutexUnlock(m: *Mutex) void {
        sys.sys_mutex_unlock(m);
    }
    pub fn mutexFree(m: *Mutex) void {
        sys.sys_mutex_free(m);
    }

    pub fn mboxNew(mbox: *Mbox, size: c_int) !void {
        try errFromC(sys.sys_mbox_new(mbox, size));
    }
    pub fn mboxPost(mbox: *Mbox, msg: ?*anyopaque) void {
        sys.sys_mbox_post(mbox, msg);
    }
    pub fn mboxTryPost(mbox: *Mbox, msg: ?*anyopaque) !void {
        try errFromC(sys.sys_mbox_trypost(mbox, msg));
    }
    pub fn mboxTryPostFromISR(mbox: *Mbox, msg: ?*anyopaque) !void {
        try errFromC(sys.sys_mbox_trypost_fromisr(mbox, msg));
    }
    pub fn mboxFetch(mbox: *Mbox, msg: *?*anyopaque, timeout_ms: u32) u32 {
        return sys.sys_arch_mbox_fetch(mbox, msg, timeout_ms);
    }
    pub fn mboxTryFetch(mbox: *Mbox, msg: *?*anyopaque) u32 {
        return sys.sys_arch_mbox_tryfetch(mbox, msg);
    }
    pub fn mboxFree(mbox: *Mbox) void {
        sys.sys_mbox_free(mbox);
    }

    pub fn threadNew(
        name: [*:0]const u8,
        thread_fn: sys.lwip_thread_fn,
        arg: ?*anyopaque,
        stacksize: c_int,
        prio: c_int,
    ) Thread {
        return sys.sys_thread_new(name, thread_fn, arg, stacksize, prio);
    }

    pub fn threadSemInit() [*c]Sem {
        return sys.sys_thread_sem_init();
    }
    pub fn threadSemDeinit() void {
        sys.sys_thread_sem_deinit();
    }
    pub fn threadSemGet() [*c]Sem {
        return sys.sys_thread_sem_get();
    }
    pub fn threadTcpip(kind: SysThreadCoreLock) bool {
        return sys.sys_thread_tcpip(kind);
    }

    pub fn archProtect() c_int {
        return sys.sys_arch_protect();
    }
    pub fn archUnprotect(pval: c_int) void {
        sys.sys_arch_unprotect(pval);
    }
};

// ---------------------------------------------------------------------------
// lwIP memory pool helpers (low-level, rarely used directly)
// ---------------------------------------------------------------------------

pub const Memp = struct {
    pub fn init() void {
        sys.memp_init();
    }
    pub fn malloc(kind: MempType) ?*anyopaque {
        return sys.memp_malloc(kind);
    }
    pub fn free(kind: MempType, mem: ?*anyopaque) void {
        sys.memp_free(kind, mem);
    }
};

// ---------------------------------------------------------------------------
// Byte order helpers (htons/htonl)
// ---------------------------------------------------------------------------

pub inline fn htons(x: u16) u16 {
    return sys.lwip_htons(x);
}
pub inline fn htonl(x: u32) u32 {
    return sys.lwip_htonl(x);
}
pub inline fn ntohs(x: u16) u16 {
    return sys.lwip_htons(x);
} // symmetric on all archs
pub inline fn ntohl(x: u32) u32 {
    return sys.lwip_htonl(x);
}

// ---------------------------------------------------------------------------
// String helpers (lwip_str*)
// ---------------------------------------------------------------------------

pub fn strnicmp(a: [*:0]const u8, b: [*:0]const u8, n: usize) c_int {
    return sys.lwip_strnicmp(a, b, n);
}
pub fn stricmp(a: [*:0]const u8, b: [*:0]const u8) c_int {
    return sys.lwip_stricmp(a, b);
}
pub fn strnstr(haystack: [*:0]const u8, needle: [*:0]const u8, n: usize) ?[*:0]u8 {
    return sys.lwip_strnstr(haystack, needle, n);
}
pub fn itoa(buf: []u8, number: c_int) void {
    sys.lwip_itoa(buf.ptr, buf.len, number);
}
