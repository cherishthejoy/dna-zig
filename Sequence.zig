const std = @import("std");
const Base = @import("Base.zig").Base;

pub const Sequence = struct {
    const Self = @This();

    data: std.ArrayList(u8),
    length: usize,

    pub fn init(allocator: std.mem.Allocator) Sequence {
        return .{
            .data = std.ArrayList(u8).init(allocator),
            .length = 0,
        };
    }

    pub fn deinit(self: *Self) void {
        self.data.deinit();
    }

    pub fn append(self: Self, base: Base) !void {
        const byte_pos = self.length / 4;
        const bit_pos = (self.length % 4) * 2;
    }
};
