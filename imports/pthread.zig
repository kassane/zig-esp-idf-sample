pub const sched_param = extern struct {
    sched_priority: c_int = std.mem.zeroes(c_int),
};
pub extern fn sched_yield() c_int;
pub const pthread_t = c_uint;
pub const pthread_attr_t = extern struct {
    is_initialized: c_int = std.mem.zeroes(c_int),
    stackaddr: ?*anyopaque = null,
    stacksize: c_int = std.mem.zeroes(c_int),
    contentionscope: c_int = std.mem.zeroes(c_int),
    inheritsched: c_int = std.mem.zeroes(c_int),
    schedpolicy: c_int = std.mem.zeroes(c_int),
    schedparam: sched_param = std.mem.zeroes(sched_param),
    detachstate: c_int = std.mem.zeroes(c_int),
};
pub const pthread_mutex_t = c_uint;
pub const pthread_mutexattr_t = extern struct {
    is_initialized: c_int = std.mem.zeroes(c_int),
    type: c_int = std.mem.zeroes(c_int),
    recursive: c_int = std.mem.zeroes(c_int),
};
pub const pthread_cond_t = c_uint;
pub const pthread_condattr_t = extern struct {
    is_initialized: c_int = std.mem.zeroes(c_int),
    clock: c_ulong = std.mem.zeroes(c_ulong),
};
pub const pthread_key_t = c_uint;
pub const pthread_once_t = extern struct {
    is_initialized: c_int = std.mem.zeroes(c_int),
    init_executed: c_int = std.mem.zeroes(c_int),
};
pub const bintime = extern struct {
    sec: i64 = std.mem.zeroes(i64),
    frac: u64 = std.mem.zeroes(u64),
};
pub const pthread_cleanup_context = extern struct {
    _routine: ?*const fn (?*anyopaque) callconv(.C) void = std.mem.zeroes(?*const fn (?*anyopaque) callconv(.C) void),
    _arg: ?*anyopaque = null,
    _canceltype: c_int = std.mem.zeroes(c_int),
    _previous: [*c]pthread_cleanup_context = std.mem.zeroes([*c]pthread_cleanup_context),
};
pub extern fn pthread_mutexattr_init(__attr: [*c]pthread_mutexattr_t) c_int;
pub extern fn pthread_mutexattr_destroy(__attr: [*c]pthread_mutexattr_t) c_int;
pub extern fn pthread_mutexattr_getpshared(__attr: [*c]const pthread_mutexattr_t, __pshared: [*c]c_int) c_int;
pub extern fn pthread_mutexattr_setpshared(__attr: [*c]pthread_mutexattr_t, __pshared: c_int) c_int;
pub extern fn pthread_mutexattr_gettype(__attr: [*c]const pthread_mutexattr_t, __kind: [*c]c_int) c_int;
pub extern fn pthread_mutexattr_settype(__attr: [*c]pthread_mutexattr_t, __kind: c_int) c_int;
pub extern fn pthread_mutex_init(__mutex: [*c]pthread_mutex_t, __attr: [*c]const pthread_mutexattr_t) c_int;
pub extern fn pthread_mutex_destroy(__mutex: [*c]pthread_mutex_t) c_int;
pub extern fn pthread_mutex_lock(__mutex: [*c]pthread_mutex_t) c_int;
pub extern fn pthread_mutex_trylock(__mutex: [*c]pthread_mutex_t) c_int;
pub extern fn pthread_mutex_unlock(__mutex: [*c]pthread_mutex_t) c_int;
pub extern fn pthread_mutex_timedlock(__mutex: [*c]pthread_mutex_t, __timeout: [*c]const timespec) c_int;
pub extern fn pthread_condattr_init(__attr: [*c]pthread_condattr_t) c_int;
pub extern fn pthread_condattr_destroy(__attr: [*c]pthread_condattr_t) c_int;
pub extern fn pthread_condattr_getclock(noalias __attr: [*c]const pthread_condattr_t, noalias __clock_id: [*c]c_ulong) c_int;
pub extern fn pthread_condattr_setclock(__attr: [*c]pthread_condattr_t, __clock_id: c_ulong) c_int;
pub extern fn pthread_condattr_getpshared(__attr: [*c]const pthread_condattr_t, __pshared: [*c]c_int) c_int;
pub extern fn pthread_condattr_setpshared(__attr: [*c]pthread_condattr_t, __pshared: c_int) c_int;
pub extern fn pthread_cond_init(__cond: [*c]pthread_cond_t, __attr: [*c]const pthread_condattr_t) c_int;
pub extern fn pthread_cond_destroy(__mutex: [*c]pthread_cond_t) c_int;
pub extern fn pthread_cond_signal(__cond: [*c]pthread_cond_t) c_int;
pub extern fn pthread_cond_broadcast(__cond: [*c]pthread_cond_t) c_int;
pub extern fn pthread_cond_wait(__cond: [*c]pthread_cond_t, __mutex: [*c]pthread_mutex_t) c_int;
pub extern fn pthread_cond_timedwait(__cond: [*c]pthread_cond_t, __mutex: [*c]pthread_mutex_t, __abstime: [*c]const timespec) c_int;
pub extern fn pthread_attr_setschedparam(__attr: [*c]pthread_attr_t, __param: [*c]const sched_param) c_int;
pub extern fn pthread_attr_getschedparam(__attr: [*c]const pthread_attr_t, __param: [*c]sched_param) c_int;
pub extern fn pthread_attr_init(__attr: [*c]pthread_attr_t) c_int;
pub extern fn pthread_attr_destroy(__attr: [*c]pthread_attr_t) c_int;
pub extern fn pthread_attr_setstack(attr: [*c]pthread_attr_t, __stackaddr: ?*anyopaque, __stacksize: usize) c_int;
pub extern fn pthread_attr_getstack(attr: [*c]const pthread_attr_t, __stackaddr: [*c]?*anyopaque, __stacksize: [*c]usize) c_int;
pub extern fn pthread_attr_getstacksize(__attr: [*c]const pthread_attr_t, __stacksize: [*c]usize) c_int;
pub extern fn pthread_attr_setstacksize(__attr: [*c]pthread_attr_t, __stacksize: usize) c_int;
pub extern fn pthread_attr_getstackaddr(__attr: [*c]const pthread_attr_t, __stackaddr: [*c]?*anyopaque) c_int;
pub extern fn pthread_attr_setstackaddr(__attr: [*c]pthread_attr_t, __stackaddr: ?*anyopaque) c_int;
pub extern fn pthread_attr_getdetachstate(__attr: [*c]const pthread_attr_t, __detachstate: [*c]c_int) c_int;
pub extern fn pthread_attr_setdetachstate(__attr: [*c]pthread_attr_t, __detachstate: c_int) c_int;
pub extern fn pthread_attr_getguardsize(__attr: [*c]const pthread_attr_t, __guardsize: [*c]usize) c_int;
pub extern fn pthread_attr_setguardsize(__attr: [*c]pthread_attr_t, __guardsize: usize) c_int;
pub extern fn pthread_create(__pthread: [*c]pthread_t, __attr: [*c]const pthread_attr_t, __start_routine: ?*const fn (?*anyopaque) callconv(.C) ?*anyopaque, __arg: ?*anyopaque) c_int;
pub extern fn pthread_join(__pthread: pthread_t, __value_ptr: [*c]?*anyopaque) c_int;
pub extern fn pthread_detach(__pthread: pthread_t) c_int;
pub extern fn pthread_exit(__value_ptr: ?*anyopaque) noreturn;
pub extern fn pthread_self() pthread_t;
pub extern fn pthread_equal(__t1: pthread_t, __t2: pthread_t) c_int;
pub extern fn pthread_getcpuclockid(thread: pthread_t, clock_id: [*c]c_ulong) c_int;
pub extern fn pthread_setconcurrency(new_level: c_int) c_int;
pub extern fn pthread_getconcurrency() c_int;
pub extern fn pthread_yield() void;
pub extern fn pthread_once(__once_control: [*c]pthread_once_t, __init_routine: ?*const fn () callconv(.C) void) c_int;
pub extern fn pthread_key_create(__key: [*c]pthread_key_t, __destructor: ?*const fn (?*anyopaque) callconv(.C) void) c_int;
pub extern fn pthread_setspecific(__key: pthread_key_t, __value: ?*const anyopaque) c_int;
pub extern fn pthread_getspecific(__key: pthread_key_t) ?*anyopaque;
pub extern fn pthread_key_delete(__key: pthread_key_t) c_int;
pub extern fn pthread_cancel(__pthread: pthread_t) c_int;
pub extern fn pthread_setcancelstate(__state: c_int, __oldstate: [*c]c_int) c_int;
pub extern fn pthread_setcanceltype(__type: c_int, __oldtype: [*c]c_int) c_int;
pub extern fn pthread_testcancel() void;
pub extern fn _pthread_cleanup_push(_context: [*c]pthread_cleanup_context, _routine: ?*const fn (?*anyopaque) callconv(.C) void, _arg: ?*anyopaque) void;
pub extern fn _pthread_cleanup_pop(_context: [*c]pthread_cleanup_context, _execute: c_int) void;
pub const timespec = extern struct {
    tv_sec: i64 = std.mem.zeroes(i64),
    tv_nsec: c_long = std.mem.zeroes(c_long),
};
pub const itimerspec = extern struct {
    it_interval: timespec = std.mem.zeroes(timespec),
    it_value: timespec = std.mem.zeroes(timespec),
};
const std = @import("std");
// TODO: port zig (std.Thread) to FreeRTOS
