const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

pub const Graph = struct {
    adj_matrix: []bool,
    size: usize,

    pub fn init(allocator: Allocator, size: usize) !Graph {
        // Allocate a single block of memory for the adjacency matrix
        const matrix = try allocator.alloc(bool, size * size);
        // Initialize all connections to false
        @memset(matrix, false);
        return Graph{
            .adj_matrix = matrix,
            .size = size,
        };
    }

    pub fn addEdge(self: *Graph, from: usize, to: usize) void {
        if (from >= self.size or to >= self.size) return;
        // Set connection in adjacency matrix to true
        self.adj_matrix[from * self.size + to] = true;
    }

    pub fn deinit(self: *Graph, allocator: Allocator) void {
        allocator.free(self.adj_matrix);
    }

    // Debug
    pub fn printGraph(self: *Graph) void {
        std.debug.print("Graph: {any}\n", .{self.adj_matrix[0]});
        std.debug.print("Graph: {any}\n", .{self.adj_matrix[1]});
        std.debug.print("Graph: {any}\n", .{self.adj_matrix[2]});
        std.debug.print("Graph: {any}\n", .{self.adj_matrix[3]});
        std.debug.print("Graph: {any}\n", .{self.adj_matrix[4]});
        std.debug.print("Graph: {any}\n", .{self.adj_matrix[5]});
        std.debug.print("Graph: {any}\n", .{self.adj_matrix[6]});
    }
};
