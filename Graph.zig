const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

pub const Graph = struct {
    adj_matrix: [][]bool,
    size: usize,

    pub fn init(allocator: *const Allocator, size: usize) !Graph {
        const matrix = try allocator.alloc([]bool, size);
        for (matrix) |*row| {
            row.* = try allocator.alloc(bool, size);
            @memset(row.*, false);
        }

        return Graph{
            .adj_matrix = matrix,
            .size = size,
        };
    }

    pub fn deinit(self: *Graph, allocator: *const Allocator) void {
        for (self.adj_matrix) |row| {
            allocator.free(row);
        }
        allocator.free(self.adj_matrix);
    }

    pub fn addEdge(self: *Graph, from: usize, to: usize) void {
        if (from >= self.size or to >= self.size) return;
        self.adj_matrix[from][to] = true;
        //self.adj_matrix[to][from] = true;
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
