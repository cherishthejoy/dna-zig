const std = @import("std");

const Base = @import("Base.zig").Base;
const Sequence = @import("Sequence.zig").Sequence;

pub fn main() void {
    std.debug.print("Base: {c}\n", .{Base.A.toChar()});
    std.debug.print("Complement: {c}\n", .{Base.A.complement().toChar()});
    //std.debug.print("Complement: {b:0>2}\n", .{@intFromEnum(Base.A.complement())});
}
