const std = @import("std");

const Base = @import("Base.zig").Base;
const Sequence = @import("Sequence.zig").Sequence;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var seq1 = Sequence.init(allocator);
    defer seq1.deinit();
    // try seq1.append(.A);
    // try seq1.append(.G);
    // try seq1.append(.C);
    // try seq1.append(.T);
    // TCGA

    try seq1.append(.G);
    try seq1.append(.C);
    try seq1.append(.A);
    try seq1.append(.T);
    // TACG

    // try seq1.append(.T);
    // try seq1.append(.A);
    // try seq1.append(.C);
    // try seq1.append(.G);
    // GCAT

    // try seq1.append(.C);
    // try seq1.append(.C);
    // try seq1.append(.C);
    // try seq1.append(.C);
    // try seq1.append(.T);
    // try seq1.append(.T);
    // try seq1.append(.T);
    // try seq1.append(.C);
    // CCCC CTTT

    std.debug.print("Sequence: {b}\n", .{seq1.data.items});

    var i: u8 = 0;
    while (i < seq1.data.items.len) : (i += 1) {
        // b:0>8 filling the missing zero if the sequnce starts with 0 (C, A)
        std.debug.print("Byte {}: {b:0>8}\n", .{ i, seq1.data.items[i] });
        std.debug.print("{any}\n", .{seq1.getBase(0)});
        std.debug.print("{any}\n", .{seq1.getBase(1)});
        std.debug.print("{any}\n", .{seq1.getBase(2)});
        std.debug.print("{any}\n", .{seq1.getBase(3)});
    }

    // TODO: Fix the reverse base printing order
}
