const std = @import("std");
const sys = @import("sys");

pub const pollfd = extern struct {
    fd: c_int = std.mem.zeroes(c_int),
    events: c_short = std.mem.zeroes(c_short),
    revents: c_short = std.mem.zeroes(c_short),
};
pub const nfds_t = c_uint;
pub extern fn poll(fds: [*c]pollfd, nfds: nfds_t, timeout: c_int) c_int;
pub extern fn sntp_get_sync_interval() u32;
pub extern fn sntp_set_system_time(sec: u32, us: u32) void;
pub extern fn sntp_get_system_time(sec: [*c]u32, us: [*c]u32) void;
pub const lwip_sock = opaque {};
pub extern fn lwip_setsockopt_impl_ext(sock: ?*lwip_sock, level: c_int, optname: c_int, optval: ?*const anyopaque, optlen: u32, err: [*c]c_int) bool;
pub extern fn lwip_getsockopt_impl_ext(sock: ?*lwip_sock, level: c_int, optname: c_int, optval: ?*anyopaque, optlen: [*c]u32, err: [*c]c_int) bool;
pub const sys_sem_t = sys.SemaphoreHandle_t;
pub const sys_mutex_t = sys.SemaphoreHandle_t;
pub const sys_thread_t = sys.TaskHandle_t;
pub const sys_mbox_s = extern struct {
    os_mbox: sys.QueueHandle_t = std.mem.zeroes(sys.QueueHandle_t),
    owner: ?*anyopaque = null,
};
pub const sys_mbox_t = [*c]sys_mbox_s;
pub extern fn sys_delay_ms(ms: u32) void;
pub extern fn sys_thread_sem_init() [*c]sys_sem_t;
pub extern fn sys_thread_sem_deinit() void;
pub extern fn sys_thread_sem_get() [*c]sys_sem_t;
pub const sys_thread_core_lock_t = enum(c_uint) {
    LWIP_CORE_LOCK_QUERY_HOLDER = 0,
    LWIP_CORE_LOCK_MARK_HOLDER = 1,
    LWIP_CORE_LOCK_UNMARK_HOLDER = 2,
    LWIP_CORE_MARK_TCPIP_TASK = 3,
    LWIP_CORE_IS_TCPIP_INITIALIZED = 4,
};
pub extern fn sys_thread_tcpip(@"type": sys_thread_core_lock_t) bool;
pub fn timeout_from_offered(lease: u32, min: u32) callconv(.C) u32 {
    var timeout: u32 = lease;
    if (timeout == @as(u32, @bitCast(@as(c_int, 0)))) {
        timeout = min;
    }
    timeout = ((timeout +% @as(u32, @bitCast(@as(c_int, 1)))) -% @as(u32, @bitCast(@as(c_int, 1)))) / @as(u32, @bitCast(@as(c_int, 1)));
    return timeout;
}
pub const err_enum_t = enum(c_int) {
    ERR_OK = 0,
    ERR_MEM = -1,
    ERR_BUF = -2,
    ERR_TIMEOUT = -3,
    ERR_RTE = -4,
    ERR_INPROGRESS = -5,
    ERR_VAL = -6,
    ERR_WOULDBLOCK = -7,
    ERR_USE = -8,
    ERR_ALREADY = -9,
    ERR_ISCONN = -10,
    ERR_CONN = -11,
    ERR_IF = -12,
    ERR_ABRT = -13,
    ERR_RST = -14,
    ERR_CLSD = -15,
    ERR_ARG = -16,
};
pub const err_t = i8;
pub extern fn err_to_errno(err: err_t) c_int;
pub extern fn lwip_htons(x: u16) u16;
pub extern fn lwip_htonl(x: u32) u32;
pub extern fn lwip_itoa(result: [*c]u8, bufsize: usize, number: c_int) void;
pub extern fn lwip_strnicmp(str1: [*:0]const u8, str2: [*:0]const u8, len: usize) c_int;
pub extern fn lwip_stricmp(str1: [*:0]const u8, str2: [*:0]const u8) c_int;
pub extern fn lwip_strnstr(buffer: [*:0]const u8, token: [*:0]const u8, n: usize) [*c]u8;
pub const ip4_addr = extern struct {
    addr: u32 = std.mem.zeroes(u32),
};
pub const ip4_addr_t = ip4_addr;
pub const ip6_addr = extern struct {
    addr: [4]u32 = std.mem.zeroes([4]u32),
    zone: u8 = std.mem.zeroes(u8),
};
pub const ip6_addr_t = ip6_addr;
const union_unnamed_5 = extern union {
    ip6: ip6_addr_t,
    ip4: ip4_addr_t,
};
pub const ip_addr = extern struct {
    u_addr: union_unnamed_5 = std.mem.zeroes(union_unnamed_5),
    type: u8 = std.mem.zeroes(u8),
};
pub const ip_addr_t = ip_addr;
pub const pbuf = extern struct {
    next: [*c]pbuf = std.mem.zeroes([*c]pbuf),
    payload: ?*anyopaque = null,
    tot_len: u16 = std.mem.zeroes(u16),
    len: u16 = std.mem.zeroes(u16),
    type_internal: u8 = std.mem.zeroes(u8),
    flags: u8 = std.mem.zeroes(u8),
    ref: u8 = std.mem.zeroes(u8),
    if_idx: u8 = std.mem.zeroes(u8),
};
pub const netif_input_fn = ?*const fn ([*c]pbuf, [*c]netif) callconv(.C) err_t;
pub const netif_output_fn = ?*const fn ([*c]netif, [*c]pbuf, [*c]const ip4_addr_t) callconv(.C) err_t;
pub const netif_linkoutput_fn = ?*const fn ([*c]netif, [*c]pbuf) callconv(.C) err_t;
pub const netif_output_ip6_fn = ?*const fn ([*c]netif, [*c]pbuf, [*c]const ip6_addr_t) callconv(.C) err_t;
pub const enum_netif_mac_filter_action = enum(c_uint) {
    NETIF_DEL_MAC_FILTER = 0,
    NETIF_ADD_MAC_FILTER = 1,
};
pub const netif_igmp_mac_filter_fn = ?*const fn ([*c]netif, [*c]const ip4_addr_t, enum_netif_mac_filter_action) callconv(.C) err_t;
pub const netif_mld_mac_filter_fn = ?*const fn ([*c]netif, [*c]const ip6_addr_t, enum_netif_mac_filter_action) callconv(.C) err_t;
pub const netif = extern struct {
    next: [*c]netif = std.mem.zeroes([*c]netif),
    ip_addr: ip_addr_t = std.mem.zeroes(ip_addr_t),
    netmask: ip_addr_t = std.mem.zeroes(ip_addr_t),
    gw: ip_addr_t = std.mem.zeroes(ip_addr_t),
    ip6_addr: [3]ip_addr_t = std.mem.zeroes([3]ip_addr_t),
    ip6_addr_state: [3]u8 = std.mem.zeroes([3]u8),
    ip6_addr_valid_life: [3]u32 = std.mem.zeroes([3]u32),
    ip6_addr_pref_life: [3]u32 = std.mem.zeroes([3]u32),
    input: netif_input_fn = std.mem.zeroes(netif_input_fn),
    output: netif_output_fn = std.mem.zeroes(netif_output_fn),
    linkoutput: netif_linkoutput_fn = std.mem.zeroes(netif_linkoutput_fn),
    output_ip6: netif_output_ip6_fn = std.mem.zeroes(netif_output_ip6_fn),
    state: ?*anyopaque = null,
    client_data: [3]?*anyopaque = std.mem.zeroes([3]?*anyopaque),
    hostname: [*:0]const u8 = std.mem.zeroes([*:0]const u8),
    mtu: u16 = std.mem.zeroes(u16),
    mtu6: u16 = std.mem.zeroes(u16),
    hwaddr: [6]u8 = std.mem.zeroes([6]u8),
    hwaddr_len: u8 = std.mem.zeroes(u8),
    flags: u8 = std.mem.zeroes(u8),
    name: [2]u8 = std.mem.zeroes([2]u8),
    num: u8 = std.mem.zeroes(u8),
    ip6_autoconfig_enabled: u8 = std.mem.zeroes(u8),
    rs_count: u8 = std.mem.zeroes(u8),
    igmp_mac_filter: netif_igmp_mac_filter_fn = std.mem.zeroes(netif_igmp_mac_filter_fn),
    mld_mac_filter: netif_mld_mac_filter_fn = std.mem.zeroes(netif_mld_mac_filter_fn),
    loop_first: [*c]pbuf = std.mem.zeroes([*c]pbuf),
    loop_last: [*c]pbuf = std.mem.zeroes([*c]pbuf),
    loop_cnt_current: u16 = std.mem.zeroes(u16),
    reschedule_poll: u8 = std.mem.zeroes(u8),
};
pub extern fn ip4_addr_isbroadcast_u32(addr: u32, netif: [*c]const netif) u8;
pub extern fn ip4_addr_netmask_valid(netmask: u32) u8;
pub extern fn ipaddr_addr(cp: [*:0]const u8) u32;
pub extern fn ip4addr_aton(cp: [*:0]const u8, addr: [*c]ip4_addr_t) c_int;
pub extern fn ip4addr_ntoa(addr: [*c]const ip4_addr_t) [*c]u8;
pub extern fn ip4addr_ntoa_r(addr: [*c]const ip4_addr_t, buf: [*c]u8, buflen: c_int) [*c]u8;
pub const enum_lwip_ipv6_scope_type = enum(c_uint) {
    IP6_UNKNOWN = 0,
    IP6_UNICAST = 1,
    IP6_MULTICAST = 2,
};
pub extern fn ip6addr_aton(cp: [*:0]const u8, addr: [*c]ip6_addr_t) c_int;
pub extern fn ip6addr_ntoa(addr: [*c]const ip6_addr_t) [*c]u8;
pub extern fn ip6addr_ntoa_r(addr: [*c]const ip6_addr_t, buf: [*c]u8, buflen: c_int) [*c]u8;
pub const enum_lwip_ip_addr_type = enum(c_uint) {
    IPADDR_TYPE_V4 = 0,
    IPADDR_TYPE_V6 = 6,
    IPADDR_TYPE_ANY = 46,
};
pub extern const ip_addr_any_type: ip_addr_t;
pub extern fn ipaddr_ntoa(addr: [*c]const ip_addr_t) [*c]u8;
pub extern fn ipaddr_ntoa_r(addr: [*c]const ip_addr_t, buf: [*c]u8, buflen: c_int) [*c]u8;
pub extern fn ipaddr_aton(cp: [*:0]const u8, addr: [*c]ip_addr_t) c_int;
pub extern const ip_addr_any: ip_addr_t;
pub extern const ip_addr_broadcast: ip_addr_t;
pub extern const ip6_addr_any: ip_addr_t;
pub const pbuf_layer = enum(c_uint) {
    PBUF_TRANSPORT = 74,
    PBUF_IP = 54,
    PBUF_LINK = 14,
    PBUF_RAW_TX = 0,
    PBUF_RAW = 0,
};
pub const pbuf_type = enum(c_uint) {
    PBUF_RAM = 640,
    PBUF_ROM = 1,
    PBUF_REF = 65,
    PBUF_POOL = 386,
};
pub const pbuf_rom = extern struct {
    next: [*c]pbuf = std.mem.zeroes([*c]pbuf),
    payload: ?*const anyopaque = std.mem.zeroes(?*const anyopaque),
};
pub const pbuf_free_custom_fn = ?*const fn ([*c]pbuf) callconv(.C) void;
pub const pbuf_custom = extern struct {
    pbuf: pbuf = std.mem.zeroes(pbuf),
    custom_free_function: pbuf_free_custom_fn = std.mem.zeroes(pbuf_free_custom_fn),
};
pub extern fn pbuf_alloc(l: pbuf_layer, length: u16, @"type": pbuf_type) [*c]pbuf;
pub extern fn pbuf_alloc_reference(payload: ?*anyopaque, length: u16, @"type": pbuf_type) [*c]pbuf;
pub extern fn pbuf_alloced_custom(l: pbuf_layer, length: u16, @"type": pbuf_type, p: [*c]pbuf_custom, payload_mem: ?*anyopaque, payload_mem_len: u16) [*c]pbuf;
pub extern fn pbuf_realloc(p: [*c]pbuf, size: u16) void;
pub extern fn pbuf_header(p: [*c]pbuf, header_size: i16) u8;
pub extern fn pbuf_header_force(p: [*c]pbuf, header_size: i16) u8;
pub extern fn pbuf_add_header(p: [*c]pbuf, header_size_increment: usize) u8;
pub extern fn pbuf_add_header_force(p: [*c]pbuf, header_size_increment: usize) u8;
pub extern fn pbuf_remove_header(p: [*c]pbuf, header_size: usize) u8;
pub extern fn pbuf_free_header(q: [*c]pbuf, size: u16) [*c]pbuf;
pub extern fn pbuf_ref(p: [*c]pbuf) void;
pub extern fn pbuf_free(p: [*c]pbuf) u8;
pub extern fn pbuf_clen(p: [*c]const pbuf) u16;
pub extern fn pbuf_cat(head: [*c]pbuf, tail: [*c]pbuf) void;
pub extern fn pbuf_chain(head: [*c]pbuf, tail: [*c]pbuf) void;
pub extern fn pbuf_dechain(p: [*c]pbuf) [*c]pbuf;
pub extern fn pbuf_copy(p_to: [*c]pbuf, p_from: [*c]const pbuf) err_t;
pub extern fn pbuf_copy_partial_pbuf(p_to: [*c]pbuf, p_from: [*c]const pbuf, copy_len: u16, offset: u16) err_t;
pub extern fn pbuf_copy_partial(p: [*c]const pbuf, dataptr: ?*anyopaque, len: u16, offset: u16) u16;
pub extern fn pbuf_get_contiguous(p: [*c]const pbuf, buffer: ?*anyopaque, bufsize: usize, len: u16, offset: u16) ?*anyopaque;
pub extern fn pbuf_take(buf: [*c]pbuf, dataptr: ?*const anyopaque, len: u16) err_t;
pub extern fn pbuf_take_at(buf: [*c]pbuf, dataptr: ?*const anyopaque, len: u16, offset: u16) err_t;
pub extern fn pbuf_skip(in: [*c]pbuf, in_offset: u16, out_offset: [*c]u16) [*c]pbuf;
pub extern fn pbuf_coalesce(p: [*c]pbuf, layer: pbuf_layer) [*c]pbuf;
pub extern fn pbuf_clone(l: pbuf_layer, @"type": pbuf_type, p: [*c]pbuf) [*c]pbuf;
pub extern fn pbuf_get_at(p: [*c]const pbuf, offset: u16) u8;
pub extern fn pbuf_try_get_at(p: [*c]const pbuf, offset: u16) c_int;
pub extern fn pbuf_put_at(p: [*c]pbuf, offset: u16, data: u8) void;
pub extern fn pbuf_memcmp(p: [*c]const pbuf, offset: u16, s2: ?*const anyopaque, n: u16) u16;
pub extern fn pbuf_memfind(p: [*c]const pbuf, mem: ?*const anyopaque, mem_len: u16, start_offset: u16) u16;
pub extern fn pbuf_strstr(p: [*c]const pbuf, substr: [*:0]const u8) u16;
pub const mem_size_t = usize;
pub extern fn mem_init() void;
pub extern fn mem_trim(mem: ?*anyopaque, size: mem_size_t) ?*anyopaque;
pub extern fn mem_malloc(size: mem_size_t) ?*anyopaque;
pub extern fn mem_calloc(count: mem_size_t, size: mem_size_t) ?*anyopaque;
pub extern fn mem_free(mem: ?*anyopaque) void;
pub const memp_t = enum(c_uint) {
    MEMP_RAW_PCB = 0,
    MEMP_UDP_PCB = 1,
    MEMP_TCP_PCB = 2,
    MEMP_TCP_PCB_LISTEN = 3,
    MEMP_TCP_SEG = 4,
    MEMP_FRAG_PBUF = 5,
    MEMP_NETBUF = 6,
    MEMP_NETCONN = 7,
    MEMP_TCPIP_MSG_API = 8,
    MEMP_TCPIP_MSG_INPKT = 9,
    MEMP_ARP_QUEUE = 10,
    MEMP_IGMP_GROUP = 11,
    MEMP_SYS_TIMEOUT = 12,
    MEMP_NETDB = 13,
    MEMP_ND6_QUEUE = 14,
    MEMP_MLD6_GROUP = 15,
    MEMP_PBUF = 16,
    MEMP_PBUF_POOL = 17,
    MEMP_MAX = 18,
};
pub const memp_desc = extern struct {
    size: u16 = std.mem.zeroes(u16),
};
pub extern fn memp_init_pool(desc: [*c]const memp_desc) void;
pub extern fn memp_malloc_pool(desc: [*c]const memp_desc) ?*anyopaque;
pub extern fn memp_free_pool(desc: [*c]const memp_desc, mem: ?*anyopaque) void;
pub extern const memp_pools: [18][*c]const memp_desc;
pub extern fn memp_init() void;
pub extern fn memp_malloc(@"type": memp_t) ?*anyopaque;
pub extern fn memp_free(@"type": memp_t, mem: ?*anyopaque) void;
pub const enum_lwip_internal_netif_client_data_index = enum(c_uint) {
    LWIP_NETIF_CLIENT_DATA_INDEX_DHCP = 0,
    LWIP_NETIF_CLIENT_DATA_INDEX_IGMP = 1,
    LWIP_NETIF_CLIENT_DATA_INDEX_MLD6 = 2,
    LWIP_NETIF_CLIENT_DATA_INDEX_MAX = 3,
};
pub const netif_init_fn = ?*const fn ([*c]netif) callconv(.C) err_t;
pub const netif_status_callback_fn = ?*const fn ([*c]netif) callconv(.C) void;
pub const netif_addr_idx_t = u8;
pub extern var netif_list: [*c]netif;
pub extern var netif_default: [*c]netif;
pub extern fn netif_init() void;
pub extern fn netif_add_noaddr(netif: [*c]netif, state: ?*anyopaque, init: netif_init_fn, input: netif_input_fn) [*c]netif;
pub extern fn netif_add(netif: [*c]netif, ipaddr: [*c]const ip4_addr_t, netmask: [*c]const ip4_addr_t, gw: [*c]const ip4_addr_t, state: ?*anyopaque, init: netif_init_fn, input: netif_input_fn) [*c]netif;
pub extern fn netif_set_addr(netif: [*c]netif, ipaddr: [*c]const ip4_addr_t, netmask: [*c]const ip4_addr_t, gw: [*c]const ip4_addr_t) void;
pub extern fn netif_remove(netif: [*c]netif) void;
pub extern fn netif_find(name: [*:0]const u8) [*c]netif;
pub extern fn netif_set_default(netif: [*c]netif) void;
pub extern fn netif_set_ipaddr(netif: [*c]netif, ipaddr: [*c]const ip4_addr_t) void;
pub extern fn netif_set_netmask(netif: [*c]netif, netmask: [*c]const ip4_addr_t) void;
pub extern fn netif_set_gw(netif: [*c]netif, gw: [*c]const ip4_addr_t) void;
pub extern fn netif_set_up(netif: [*c]netif) void;
pub extern fn netif_set_down(netif: [*c]netif) void;
pub extern fn netif_set_link_up(netif: [*c]netif) void;
pub extern fn netif_set_link_down(netif: [*c]netif) void;
pub extern fn netif_loop_output(netif: [*c]netif, p: [*c]pbuf) err_t;
pub extern fn netif_poll(netif: [*c]netif) void;
pub extern fn netif_input(p: [*c]pbuf, inp: [*c]netif) err_t;
pub extern fn netif_ip6_addr_set(netif: [*c]netif, addr_idx: i8, addr6: [*c]const ip6_addr_t) void;
pub extern fn netif_ip6_addr_set_parts(netif: [*c]netif, addr_idx: i8, @"i0": u32, @"i1": u32, @"i2": u32, @"i3": u32) void;
pub extern fn netif_ip6_addr_set_state(netif: [*c]netif, addr_idx: i8, state: u8) void;
pub extern fn netif_get_ip6_addr_match(netif: [*c]netif, ip6addr: [*c]const ip6_addr_t) i8;
pub extern fn netif_create_ip6_linklocal_address(netif: [*c]netif, from_mac_48bit: u8) void;
pub extern fn netif_add_ip6_address(netif: [*c]netif, ip6addr: [*c]const ip6_addr_t, chosen_idx: [*c]i8) err_t;
pub extern fn netif_name_to_index(name: [*:0]const u8) u8;
pub extern fn netif_index_to_name(idx: u8, name: [*c]u8) [*c]u8;
pub extern fn netif_get_by_index(idx: u8) [*c]netif;
pub const netif_nsc_reason_t = u16;
pub const link_changed_s_6 = extern struct {
    state: u8 = std.mem.zeroes(u8),
};
pub const status_changed_s_7 = extern struct {
    state: u8 = std.mem.zeroes(u8),
};
pub const ipv4_changed_s_8 = extern struct {
    old_address: [*c]const ip_addr_t = std.mem.zeroes([*c]const ip_addr_t),
    old_netmask: [*c]const ip_addr_t = std.mem.zeroes([*c]const ip_addr_t),
    old_gw: [*c]const ip_addr_t = std.mem.zeroes([*c]const ip_addr_t),
};
pub const ipv6_set_s_9 = extern struct {
    addr_index: i8 = std.mem.zeroes(i8),
    old_address: [*c]const ip_addr_t = std.mem.zeroes([*c]const ip_addr_t),
};
pub const ipv6_addr_state_changed_s_10 = extern struct {
    addr_index: i8 = std.mem.zeroes(i8),
    old_state: u8 = std.mem.zeroes(u8),
    address: [*c]const ip_addr_t = std.mem.zeroes([*c]const ip_addr_t),
};
pub const netif_ext_callback_args_t = extern union {
    link_changed: link_changed_s_6,
    status_changed: status_changed_s_7,
    ipv4_changed: ipv4_changed_s_8,
    ipv6_set: ipv6_set_s_9,
    ipv6_addr_state_changed: ipv6_addr_state_changed_s_10,
};
pub const netif_ext_callback_fn = ?*const fn ([*c]netif, netif_nsc_reason_t, [*c]const netif_ext_callback_args_t) callconv(.C) void;
pub const netif_ext_callback = extern struct {
    callback_fn: netif_ext_callback_fn = std.mem.zeroes(netif_ext_callback_fn),
    next: [*c]netif_ext_callback = std.mem.zeroes([*c]netif_ext_callback),
};
pub const netif_ext_callback_t = netif_ext_callback;
pub extern fn netif_add_ext_callback(callback: [*c]netif_ext_callback_t, @"fn": netif_ext_callback_fn) void;
pub extern fn netif_remove_ext_callback(callback: [*c]netif_ext_callback_t) void;
pub extern fn netif_invoke_ext_callback(netif: [*c]netif, reason: netif_nsc_reason_t, args: [*c]const netif_ext_callback_args_t) void;
pub const in_addr = extern struct {
    s_addr: u32 = std.mem.zeroes(u32),
};
const union_unnamed_11 = extern union {
    u32_addr: [4]u32,
    u8_addr: [16]u8,
};
pub const in6_addr = extern struct {
    un: union_unnamed_11 = std.mem.zeroes(union_unnamed_11),
};
pub extern const in6addr_any: in6_addr;
pub const sa_family_t = u8;
pub const sockaddr_in = extern struct {
    sin_len: u8 = std.mem.zeroes(u8),
    sin_family: sa_family_t = std.mem.zeroes(sa_family_t),
    sin_port: u16 = std.mem.zeroes(u16),
    sin_addr: in_addr = std.mem.zeroes(in_addr),
    sin_zero: [8]u8 = std.mem.zeroes([8]u8),
};
pub const sockaddr_in6 = extern struct {
    sin6_len: u8 = std.mem.zeroes(u8),
    sin6_family: sa_family_t = std.mem.zeroes(sa_family_t),
    sin6_port: u16 = std.mem.zeroes(u16),
    sin6_flowinfo: u32 = std.mem.zeroes(u32),
    sin6_addr: in6_addr = std.mem.zeroes(in6_addr),
    sin6_scope_id: u32 = std.mem.zeroes(u32),
};
pub const sockaddr = extern struct {
    sa_len: u8 = std.mem.zeroes(u8),
    sa_family: sa_family_t = std.mem.zeroes(sa_family_t),
    sa_data: [14]u8 = std.mem.zeroes([14]u8),
};
pub const sockaddr_storage = extern struct {
    s2_len: u8 = std.mem.zeroes(u8),
    ss_family: sa_family_t = std.mem.zeroes(sa_family_t),
    s2_data1: [2]u8 = std.mem.zeroes([2]u8),
    s2_data2: [3]u32 = std.mem.zeroes([3]u32),
    s2_data3: [3]u32 = std.mem.zeroes([3]u32),
};
pub const socklen_t = u32;
pub const iovec = extern struct {
    iov_base: ?*anyopaque = null,
    iov_len: usize = std.mem.zeroes(usize),
};
pub const msghdr = extern struct {
    msg_name: ?*anyopaque = null,
    msg_namelen: socklen_t = std.mem.zeroes(socklen_t),
    msg_iov: [*c]iovec = std.mem.zeroes([*c]iovec),
    msg_iovlen: c_int = std.mem.zeroes(c_int),
    msg_control: ?*anyopaque = null,
    msg_controllen: socklen_t = std.mem.zeroes(socklen_t),
    msg_flags: c_int = std.mem.zeroes(c_int),
};
pub const cmsghdr = extern struct {
    cmsg_len: socklen_t = std.mem.zeroes(socklen_t),
    cmsg_level: c_int = std.mem.zeroes(c_int),
    cmsg_type: c_int = std.mem.zeroes(c_int),
};
pub const ifreq = extern struct {
    ifr_name: [6]u8 = std.mem.zeroes([6]u8),
};
pub const linger = extern struct {
    l_onoff: c_int = std.mem.zeroes(c_int),
    l_linger: c_int = std.mem.zeroes(c_int),
};
pub const ip_mreq = extern struct {
    imr_multiaddr: in_addr = std.mem.zeroes(in_addr),
    imr_interface: in_addr = std.mem.zeroes(in_addr),
};
pub const in_pktinfo = extern struct {
    ipi_ifindex: c_uint = std.mem.zeroes(c_uint),
    ipi_addr: in_addr = std.mem.zeroes(in_addr),
};
pub const ipv6_mreq = extern struct {
    ipv6mr_multiaddr: in6_addr = std.mem.zeroes(in6_addr),
    ipv6mr_interface: c_uint = std.mem.zeroes(c_uint),
};
pub extern fn lwip_socket_thread_init() void;
pub extern fn lwip_socket_thread_cleanup() void;
pub extern fn lwip_accept(s: c_int, addr: [*c]sockaddr, addrlen: [*c]socklen_t) c_int;
pub extern fn lwip_bind(s: c_int, name: [*c]const sockaddr, namelen: socklen_t) c_int;
pub extern fn lwip_shutdown(s: c_int, how: c_int) c_int;
pub extern fn lwip_getpeername(s: c_int, name: [*c]sockaddr, namelen: [*c]socklen_t) c_int;
pub extern fn lwip_getsockname(s: c_int, name: [*c]sockaddr, namelen: [*c]socklen_t) c_int;
pub extern fn lwip_getsockopt(s: c_int, level: c_int, optname: c_int, optval: ?*anyopaque, optlen: [*c]socklen_t) c_int;
pub extern fn lwip_setsockopt(s: c_int, level: c_int, optname: c_int, optval: ?*const anyopaque, optlen: socklen_t) c_int;
pub extern fn lwip_close(s: c_int) c_int;
pub extern fn lwip_connect(s: c_int, name: [*c]const sockaddr, namelen: socklen_t) c_int;
pub extern fn lwip_listen(s: c_int, backlog: c_int) c_int;
pub extern fn lwip_recv(s: c_int, mem: ?*anyopaque, len: usize, flags: c_int) isize;
pub extern fn lwip_read(s: c_int, mem: ?*anyopaque, len: usize) isize;
pub extern fn lwip_readv(s: c_int, iov: [*c]const iovec, iovcnt: c_int) isize;
pub extern fn lwip_recvfrom(s: c_int, mem: ?*anyopaque, len: usize, flags: c_int, from: [*c]sockaddr, fromlen: [*c]socklen_t) isize;
pub extern fn lwip_recvmsg(s: c_int, message: [*c]msghdr, flags: c_int) isize;
pub extern fn lwip_send(s: c_int, dataptr: ?*const anyopaque, size: usize, flags: c_int) isize;
pub extern fn lwip_sendmsg(s: c_int, message: [*c]const msghdr, flags: c_int) isize;
pub extern fn lwip_sendto(s: c_int, dataptr: ?*const anyopaque, size: usize, flags: c_int, to: [*c]const sockaddr, tolen: socklen_t) isize;
pub extern fn lwip_socket(domain: c_int, @"type": c_int, protocol: c_int) c_int;
pub extern fn lwip_write(s: c_int, dataptr: ?*const anyopaque, size: usize) isize;
pub extern fn lwip_writev(s: c_int, iov: [*c]const iovec, iovcnt: c_int) isize;
pub extern fn lwip_select(maxfdp1: c_int, readset: [*c]fd_set, writeset: [*c]fd_set, exceptset: [*c]fd_set, timeout: [*c]std.os.timeval) c_int;
pub extern fn lwip_poll(fds: [*c]pollfd, nfds: nfds_t, timeout: c_int) c_int;
pub extern fn lwip_ioctl(s: c_int, cmd: c_long, argp: ?*anyopaque) c_int;
pub extern fn lwip_fcntl(s: c_int, cmd: c_int, val: c_int) c_int;
pub extern fn lwip_inet_ntop(af: c_int, src: ?*const anyopaque, dst: [*c]u8, size: socklen_t) [*:0]const u8;
pub extern fn lwip_inet_pton(af: c_int, src: [*:0]const u8, dst: ?*anyopaque) c_int;
pub fn accept(s: c_int, addr: [*c]sockaddr, addrlen: [*c]socklen_t) callconv(.C) c_int {
    return lwip_accept(s, addr, addrlen);
}
pub fn bind(s: c_int, name: [*c]const sockaddr, namelen: socklen_t) callconv(.C) c_int {
    return lwip_bind(s, name, namelen);
}
pub fn shutdown(s: c_int, how: c_int) callconv(.C) c_int {
    return lwip_shutdown(s, how);
}
pub fn getpeername(s: c_int, name: [*c]sockaddr, namelen: [*c]socklen_t) callconv(.C) c_int {
    return lwip_getpeername(s, name, namelen);
}
pub fn getsockname(s: c_int, name: [*c]sockaddr, namelen: [*c]socklen_t) callconv(.C) c_int {
    return lwip_getsockname(s, name, namelen);
}
pub fn setsockopt(s: c_int, level: c_int, optname: c_int, opval: ?*const anyopaque, optlen: socklen_t) callconv(.C) c_int {
    return lwip_setsockopt(s, level, optname, opval, optlen);
}
pub fn getsockopt(s: c_int, level: c_int, optname: c_int, opval: ?*anyopaque, optlen: [*c]socklen_t) callconv(.C) c_int {
    return lwip_getsockopt(s, level, optname, opval, optlen);
}
pub fn closesocket(s: c_int) callconv(.C) c_int {
    return lwip_close(s);
}
pub fn connect(s: c_int, name: [*c]const sockaddr, namelen: socklen_t) callconv(.C) c_int {
    return lwip_connect(s, name, namelen);
}
pub fn listen(s: c_int, backlog: c_int) callconv(.C) c_int {
    return lwip_listen(s, backlog);
}
pub fn recvmsg(sockfd: c_int, msg: [*c]msghdr, flags: c_int) callconv(.C) isize {
    return lwip_recvmsg(sockfd, msg, flags);
}
pub fn recv(s: c_int, mem: ?*anyopaque, len: usize, flags: c_int) callconv(.C) isize {
    return lwip_recv(s, mem, len, flags);
}
pub fn recvfrom(s: c_int, mem: ?*anyopaque, len: usize, flags: c_int, from: [*c]sockaddr, fromlen: [*c]socklen_t) callconv(.C) isize {
    return lwip_recvfrom(s, mem, len, flags, from, fromlen);
}
pub fn send(s: c_int, dataptr: ?*const anyopaque, size: usize, flags: c_int) callconv(.C) isize {
    return lwip_send(s, dataptr, size, flags);
}
pub fn sendmsg(s: c_int, message: [*c]const msghdr, flags: c_int) callconv(.C) isize {
    return lwip_sendmsg(s, message, flags);
}
pub fn sendto(s: c_int, dataptr: ?*const anyopaque, size: usize, flags: c_int, to: [*c]const sockaddr, tolen: socklen_t) callconv(.C) isize {
    return lwip_sendto(s, dataptr, size, flags, to, tolen);
}
pub fn socket(domain: c_int, @"type": c_int, protocol: c_int) callconv(.C) c_int {
    return lwip_socket(domain, @"type", protocol);
}
pub fn inet_ntop(af: c_int, src: ?*const anyopaque, dst: [*c]u8, size: socklen_t) callconv(.C) [*:0]const u8 {
    return lwip_inet_ntop(af, src, dst, size);
}
pub fn inet_pton(af: c_int, src: [*:0]const u8, dst: ?*anyopaque) callconv(.C) c_int {
    return lwip_inet_pton(af, src, dst);
}
pub const lwip_thread_fn = ?*const fn (?*anyopaque) callconv(.C) void;
pub extern fn sys_mutex_new(mutex: [*c]sys_mutex_t) err_t;
pub extern fn sys_mutex_lock(mutex: [*c]sys_mutex_t) void;
pub extern fn sys_mutex_unlock(mutex: [*c]sys_mutex_t) void;
pub extern fn sys_mutex_free(mutex: [*c]sys_mutex_t) void;
pub extern fn sys_sem_new(sem: [*c]sys_sem_t, count: u8) err_t;
pub extern fn sys_sem_signal(sem: [*c]sys_sem_t) void;
pub extern fn sys_arch_sem_wait(sem: [*c]sys_sem_t, timeout: u32) u32;
pub extern fn sys_sem_free(sem: [*c]sys_sem_t) void;
pub extern fn sys_mbox_new(mbox: [*c]sys_mbox_t, size: c_int) err_t;
pub extern fn sys_mbox_post(mbox: [*c]sys_mbox_t, msg: ?*anyopaque) void;
pub extern fn sys_mbox_trypost(mbox: [*c]sys_mbox_t, msg: ?*anyopaque) err_t;
pub extern fn sys_mbox_trypost_fromisr(mbox: [*c]sys_mbox_t, msg: ?*anyopaque) err_t;
pub extern fn sys_arch_mbox_fetch(mbox: [*c]sys_mbox_t, msg: [*c]?*anyopaque, timeout: u32) u32;
pub extern fn sys_arch_mbox_tryfetch(mbox: [*c]sys_mbox_t, msg: [*c]?*anyopaque) u32;
pub extern fn sys_mbox_free(mbox: [*c]sys_mbox_t) void;
pub extern fn sys_thread_new(name: [*:0]const u8, thread: lwip_thread_fn, arg: ?*anyopaque, stacksize: c_int, prio: c_int) sys_thread_t;
pub extern fn sys_init() void;
pub extern fn sys_jiffies() u32;
pub extern fn sys_now() u32;
pub extern fn sys_arch_protect() c_int;
pub extern fn sys_arch_unprotect(pval: c_int) void;
pub const hostent = extern struct {
    h_name: [*c]u8 = std.mem.zeroes([*c]u8),
    h_aliases: [*c][*c]u8 = std.mem.zeroes([*c][*c]u8),
    h_addrtype: c_int = std.mem.zeroes(c_int),
    h_length: c_int = std.mem.zeroes(c_int),
    h_addr_list: [*c][*c]u8 = std.mem.zeroes([*c][*c]u8),
};
pub const addrinfo = extern struct {
    ai_flags: c_int = std.mem.zeroes(c_int),
    ai_family: c_int = std.mem.zeroes(c_int),
    ai_socktype: c_int = std.mem.zeroes(c_int),
    ai_protocol: c_int = std.mem.zeroes(c_int),
    ai_addrlen: socklen_t = std.mem.zeroes(socklen_t),
    ai_addr: [*c]sockaddr = std.mem.zeroes([*c]sockaddr),
    ai_canonname: [*c]u8 = std.mem.zeroes([*c]u8),
    ai_next: [*c]addrinfo = std.mem.zeroes([*c]addrinfo),
};
pub extern var h_errno: c_int;
pub extern fn lwip_gethostbyname(name: [*:0]const u8) [*c]hostent;
pub extern fn lwip_gethostbyname_r(name: [*:0]const u8, ret: [*c]hostent, buf: [*c]u8, buflen: usize, result: [*c][*c]hostent, h_errnop: [*c]c_int) c_int;
pub extern fn lwip_freeaddrinfo(ai: [*c]addrinfo) void;
pub extern fn lwip_getaddrinfo(nodename: [*:0]const u8, servname: [*:0]const u8, hints: [*c]const addrinfo, res: [*c][*c]addrinfo) c_int;
pub fn gethostbyname_r(name: [*:0]const u8, ret: [*c]hostent, buf: [*c]u8, buflen: usize, result: [*c][*c]hostent, h_errnop: [*c]c_int) callconv(.C) c_int {
    return lwip_gethostbyname_r(name, ret, buf, buflen, result, h_errnop);
}
pub fn gethostbyname(name: [*:0]const u8) callconv(.C) [*c]hostent {
    return lwip_gethostbyname(name);
}
pub fn freeaddrinfo(ai: [*c]addrinfo) callconv(.C) void {
    lwip_freeaddrinfo(ai);
}
pub fn getaddrinfo(nodename: [*:0]const u8, servname: [*:0]const u8, hints: [*c]const addrinfo, res: [*c][*c]addrinfo) callconv(.C) c_int {
    return lwip_getaddrinfo(nodename, servname, hints, res);
}
pub extern const dns_mquery_v4group: ip_addr_t;
pub extern const dns_mquery_v6group: ip_addr_t;
pub const dns_found_callback = ?*const fn ([*:0]const u8, [*c]const ip_addr_t, ?*anyopaque) callconv(.C) void;
pub extern fn dns_init() void;
pub extern fn dns_tmr() void;
pub extern fn dns_setserver(numdns: u8, dnsserver: [*c]const ip_addr_t) void;
pub extern fn dns_getserver(numdns: u8) [*c]const ip_addr_t;
pub extern fn dns_gethostbyname(hostname: [*:0]const u8, addr: [*c]ip_addr_t, found: dns_found_callback, callback_arg: ?*anyopaque) err_t;
pub extern fn dns_gethostbyname_addrtype(hostname: [*:0]const u8, addr: [*c]ip_addr_t, found: dns_found_callback, callback_arg: ?*anyopaque, dns_addrtype: u8) err_t;
pub extern fn dns_clear_cache() void;
pub const fd_set = extern struct {
    __fds_bits: [2]__fd_mask = std.mem.zeroes([2]__fd_mask),
};
pub const __fd_mask = c_ulong;
