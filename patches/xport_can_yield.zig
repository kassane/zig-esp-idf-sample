pub fn xPortCanYield() callconv(.c) bool {
    var threshold: u32 = blk: {
        break :blk @as([*c]volatile u32, @ptrFromInt(@as(c_int, 545259520) + @as(c_int, 8))).*;
    };
    _ = &threshold;
    threshold = threshold >> @intCast(@as(c_int, 24) + (@as(c_int, 8) - @as(c_int, 3)));
    return threshold == @as(u32, @bitCast(@as(c_int, 0)));
}