const std = @import("std");

const Base = @import("Base.zig").Base;
const Sequence = @import("Sequence.zig").Sequence;

pub fn main() !void {
    std.debug.print("Base: {c}\n", .{Base.A.toChar()});
    std.debug.print("Complement: {c}\n", .{Base.A.complement().toChar()});
    //std.debug.print("Complement: {b:0>2}\n", .{@intFromEnum(Base.A.complement())});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var seq1 = Sequence.init(allocator);
    defer seq1.deinit();
    try seq1.append(.A);
    try seq1.append(.G);
    try seq1.append(.C);
    try seq1.append(.T);
    // TCGA

    try seq1.append(.G);
    try seq1.append(.C);
    try seq1.append(.A);
    try seq1.append(.T);
    // TACG

    try seq1.append(.T);
    try seq1.append(.A);
    try seq1.append(.C);
    try seq1.append(.G);
    // GCAT

    try seq1.append(.C);
    try seq1.append(.C);
    try seq1.append(.C);
    try seq1.append(.C);
    try seq1.append(.T);
    try seq1.append(.T);
    try seq1.append(.T);
    try seq1.append(.C);
    // CCCC CTTT

    std.debug.print("Sequence: {b}\n", .{seq1.data.items});

    var i: u8 = 0;
    while (i < seq1.data.items.len) : (i += 1) {
        // b:0>8 filling the missing zero if the sequnce starts with 0 (C, A)
        std.debug.print("Byte {}: {b:0>8}\n", .{ i, seq1.data.items[i] });
    }

    // TODO: Fix the reverse base printing order
}
