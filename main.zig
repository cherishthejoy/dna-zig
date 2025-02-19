const std = @import("std");

const Base = @import("Base.zig").Base;
const Sequence = @import("Sequence.zig").Sequence;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var seq1 = Sequence.init(allocator);
    defer seq1.deinit();

    try seq1.appendSequence("ATCGA");
    try seq1.printSequenceString();

    var complement = try seq1.sequenceComplement(allocator);
    defer complement.deinit();

    try complement.printSequenceString();

    std.debug.print("Used size: {} bytes\n", .{seq1.data.items.len});
    std.debug.print("Base length: {d}\n", .{seq1.base_length});

    std.debug.print("Size of Sequence struct: {} bytes\n", .{@sizeOf(Sequence)});
}
