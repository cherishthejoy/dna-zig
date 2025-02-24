const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

pub const Graph = struct {
    adj_matrix: []bool,
    size: usize,

    pub fn init(allocator: Allocator, size: usize) !Graph {
        // Allocate a single block of memory for the adjacency matrix
        const matrix = try allocator.alloc(bool, size * size);
        // Initialize all elements as false
        @memset(matrix, false);
        return Graph{
            .adj_matrix = matrix,
            .size = size,
        };
    }

    pub fn addEdge(self: *Graph, from: usize, to: usize) void {
        // This pretty much creates a flat array with true and false.
        // We interpret it as 7x7 array starting from 0 and ending with 6
        if (from < self.size and to < self.size) {
            self.adj_matrix[from * self.size + to] = true;
        }
    }

    pub fn deinit(self: *Graph, allocator: Allocator) void {
        allocator.free(self.adj_matrix);
    }
};
