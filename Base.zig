const std = @import("std");

pub const Base = enum(u2) {
    const Self = @This();
    A = 0b00,
    T = 0b11,
    C = 0b01,
    G = 0b10,

    pub fn complement(self: Self) Self {
        return @enumFromInt(~@intFromEnum(self));
    }

    pub fn toChar(self: Self) u8 {
        return switch (self) {
            .A => 'A',
            .T => 'T',
            .C => 'C',
            .G => 'G',
        };
    }
};
