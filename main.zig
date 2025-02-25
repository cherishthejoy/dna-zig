const std = @import("std");

const Base = @import("Base.zig").Base;
const Sequence = @import("Sequence.zig").Sequence;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var seq1 = Sequence.init(allocator);
    var seq2 = Sequence.init(allocator);

    try seq1.appendSequence("ATCG");
    try seq2.appendSequence("TTCC");

    var edge1 = try seq1.ligation(seq2, allocator);

    try seq1.printSequenceString();
    try seq2.printSequenceString();
    try edge1.printSequenceString();

    var edge1_complement = try edge1.sequenceComplement(allocator);
    try edge1_complement.printSequenceString();

    defer seq1.deinit();
    defer edge1.deinit();
    defer seq2.deinit();
    defer edge1_complement.deinit();

    std.debug.print("\nSize of Sequence struct: {} bytes\n", .{@sizeOf(Sequence)});
    std.debug.print("Used size: {} bytes\n", .{seq1.data.items.len});
    std.debug.print("Base Length: {d}\n", .{edge1.length});
}
