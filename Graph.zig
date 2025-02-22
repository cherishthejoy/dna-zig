const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const Graph = struct {
    adj_matrix: [][]bool,
    size: usize,

    pub fn init(allocator: *Allocator, size: usize) !Graph {
        const matrix = try allocator.alloc([]bool, size);
        _ = matrix;
    }
};
