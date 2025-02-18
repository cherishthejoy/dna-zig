const std = @import("std");

const Base = @import("Base.zig").Base;
const Sequence = @import("Sequence.zig").Sequence;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var seq1 = Sequence.init(allocator);
    defer seq1.deinit();
    //try seq1.appendBase(.A);
    //try seq1.appendBase(.G);
    //try seq1.appendBase(.C);
    //try seq1.appendBase(.T);
    // TCGA

    try seq1.appendSequence("ATCGTTTC");
    try seq1.appendBase(.T);
    try seq1.printSequence();

    std.debug.print("Used size: {} bytes\n", .{seq1.data.items.len});

    // TODO: Fix the reverse base printing order

    //std.debug.print("Size of Sequence struct: {} bytes\n", .{@sizeOf(Sequence)});
}
