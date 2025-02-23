const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const Graph = struct {
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
        self.adj_matrix[to][from] = true;
    }

    // Debug
    pub fn printGraph(self: *Graph) void {
        std.debug.print("Graph: {any}\n", .{self.adj_matrix[0]});
        std.debug.print("Graph: {any}\n", .{self.adj_matrix[1]});
        std.debug.print("Graph: {any}\n", .{self.adj_matrix[2]});
        std.debug.print("Graph: {any}\n", .{self.adj_matrix[3]});
        std.debug.print("Graph: {any}\n", .{self.adj_matrix[4]});
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = &gpa.allocator();

    var graph = try Graph.init(allocator, 5);
    defer graph.deinit(allocator);

    graph.addEdge(0, 1);
    graph.addEdge(1, 2);
    graph.addEdge(2, 3);
    graph.addEdge(3, 4);
    graph.addEdge(4, 0);

    graph.printGraph();
}
