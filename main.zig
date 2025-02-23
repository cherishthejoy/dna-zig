const std = @import("std");

const Base = @import("Base.zig").Base;
const Sequence = @import("Sequence.zig").Sequence;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var seq1 = Sequence.init(allocator);
    defer seq1.deinit();

    try seq1.appendSequence("ATCG");
    try seq1.printSequenceString();

    std.debug.print("Size of Sequence struct: {} bytes\n", .{@sizeOf(Sequence)});

    var seq2 = Sequence.init(allocator);

    try seq2.appendSequence("TTCC");
    defer seq2.deinit();
    try seq2.printSequenceString();

    var edge1 = try seq1.ligation(seq2, allocator);
    try edge1.printSequenceString();

    defer edge1.deinit();

    std.debug.print("Used size: {} bytes\n", .{seq1.data.items.len});
    std.debug.print("Base Length: {d}\n", .{edge1.length});
}
