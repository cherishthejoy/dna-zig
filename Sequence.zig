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

    pub fn appendBase(self: *Self, base: Base) !void {
        const byte_pos = self.length / 4;
        const bit_pos = (3 - (self.length % 4)) * 2;

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
            try self.appendBase(base);
        }
    }

    pub fn printSequenceString(self: Self) !void {
        if (self.length == 0) return error.EmptyArray;

        const bases = [_]u8{ 'A', 'C', 'G', 'T' };

        const gpa = std.heap.page_allocator;
        var buffer = std.ArrayList(u8).init(gpa);
        defer buffer.deinit(); // Free memory after use

        for (self.data.items) |byte| {
            var j: usize = 0;
            while (true) {
                const bit_index: u3 = @intCast(j);
                const bit = (byte >> (6 - bit_index)) & 0b11;
                const base = bases[bit];

                try buffer.append(base);

                if (j == 6) break;
                j += 2;
            }
        }
        std.debug.print("{s}\n", .{buffer.items[0..self.length]});
    }

    pub fn sequenceComplement(self: Self, allocator: std.mem.Allocator) !Sequence {
        var result = Sequence.init(allocator);

        for (self.data.items) |byte| {
            try result.data.append(~byte); // Flip all bits
        }

        result.length = self.length;
        return result;
    }

    // Maybe make it as it can only take 4 or 8 base sequence at a time
    pub fn ligation(self: Self, other: Sequence, allocator: std.mem.Allocator) !Sequence {
        // v1 = ATCG (00110110) << 4 0110|0000
        // v2 = TTCC (11110101) >> 4 0000|1111
        // edge = CGTT (01101111)

        if (self.length != 4 or other.length != 4) return error.AlignError;

        var result = Sequence.init(allocator);
        errdefer result.deinit(); // This only runs if an error occurs during the function

        const shift_amount = self.length;

        const first_half = @as(u8, self.data.items[0] << @intCast(shift_amount));
        const second_half = @as(u8, other.data.items[0] >> @intCast(shift_amount));

        const edge: u8 = first_half + second_half;
        try result.data.append(edge);

        result.length = self.length;

        return result;
    }

    pub fn concat(self: Self, other: Sequence, allocator: std.mem.Allocator) !Sequence {
        _ = self;
        _ = other;
        _ = allocator;
    }

    // TODO: Implement basic DNA computing operations
    // TODO: Concatenating strings
    // TODO: Make ligation() possible to input n-length sequence
};
