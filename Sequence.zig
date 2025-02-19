const std = @import("std");
const Base = @import("Base.zig").Base;

pub const Sequence = struct {
    const Self = @This();

    data: std.ArrayList(u8),
    length: usize,
    base_length: usize,
    // TODO: Keep track of used bits in a byte

    pub fn init(allocator: std.mem.Allocator) Sequence {
        return .{
            .data = std.ArrayList(u8).init(allocator),
            .length = 0,
            .base_length = 0,
        };
    }

    pub fn deinit(self: *Self) void {
        self.data.deinit();
    }

    pub fn appendBase(self: *Self, base: Base) !void {
        const byte_pos = self.length / 4;
        const bit_pos = (self.length % 4) * 2;

        if (byte_pos >= self.data.items.len) {
            try self.data.append(0);
        }

        const mask = ~(@as(u8, 0b11) << @intCast(bit_pos));
        self.data.items[byte_pos] &= mask;

        const encoded_base = @as(u8, @intFromEnum(base)) & 0b11;
        self.data.items[byte_pos] |= encoded_base << @intCast(bit_pos);

        self.length += 1;
    }

    pub fn appendSequence(self: *Self, sequence: []const u8) !void {
        for (sequence) |char| {
            const base = switch (char) {
                'A' => Base.A,
                'T' => Base.T,
                'C' => Base.C,
                'G' => Base.G,
                else => return error.InvalidBase,
            };
            self.base_length += 1;
            try self.appendBase(base);
        }
    }
    // This function doesn't really provide much but helps to read
    pub fn printSequence(self: Self) !void {
        if (self.length == 0) return error.EmptyArray;

        const bases = [_]u8{ 'A', 'C', 'G', 'T' };

        for (self.data.items, 0..) |byte, i| {
            // b:0>8 filling the missing zero if the sequnce starts with 0 (A, C)
            std.debug.print("Byte {}: {b:0>8}\n", .{ i, byte });

            var j: usize = 6;
            while (true) {
                const bit_index: u3 = @intCast(j);
                const bit = (byte >> (6 - bit_index)) & 0b11;

                const base = bases[bit];

                std.debug.print(" Bit {}-{}: {b:0>2} ({c})\n", .{ bit_index, bit_index + 1, bit, base });

                if (j == 0) break;
                j -= 2;
            }
        }
    }

    pub fn printSequenceString(self: Self) !void {
        if (self.length == 0) return error.EmptyArray;

        const bases = [_]u8{ 'A', 'C', 'G', 'T' };

        const gpa = std.heap.page_allocator;
        var buffer = std.ArrayList(u8).init(gpa);
        defer buffer.deinit(); // Free memory after use

        for (self.data.items) |byte| {
            var j: usize = 6;
            while (true) {
                const bit_index: u3 = @intCast(j);
                const bit = (byte >> (6 - bit_index)) & 0b11;
                const base = bases[bit];

                try buffer.append(base);

                if (j == 0) break;
                j -= 2;
            }
        }
        std.debug.print("{s}\n", .{buffer.items});
    }

    pub fn sequenceComplement(self: Self, allocator: std.mem.Allocator) !Sequence {
        var result = Sequence.init(allocator);
        try result.data.ensureTotalCapacity(self.data.items.len);

        for (self.data.items) |byte| {
            try result.data.append(~byte); // Flip all bits
        }

        result.length = self.length;
        return result;
    }
};
