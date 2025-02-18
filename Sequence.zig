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

    // Example : AG + C
    pub fn append(self: *Self, base: Base) !void {
        const byte_pos = self.length / 4; // 0
        const bit_pos = (self.length % 4) * 2; // 4

        if (byte_pos >= self.data.items.len) {
            try self.data.append(0);
        }

        const mask = ~(@as(u8, 0b11) << @intCast(bit_pos));
        self.data.items[byte_pos] &= mask;

        const encoded_base = @as(u8, @intFromEnum(base)) & 0b11; // Ensure 2-bit value
        self.data.items[byte_pos] |= encoded_base << @intCast(bit_pos);

        self.length += 1;
    }

    pub fn getBase(self: Sequence, pos: usize) !Base {
        if (pos >= self.length) return error.OutOfBounds;

        const byte_pos = pos / 4;
        const bit_pos = (pos % 4) * 2;

        const value = (self.data.items[byte_pos] >> @intCast(bit_pos)) & 0b11;

        return @enumFromInt(value);
    }

    //00 00 10 00
    //11 00 11 00
    //00 00 10 00 //

    //00 00 00 01
    //00 00 00 11
    //00 00 00 01
    //00 01 00 00 //

    //00 00 10 00
    //00 01 00 00
    //00 01 10 00
};
