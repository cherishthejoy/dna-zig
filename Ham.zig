const std = @import("std");
const Graph = @import("Graph.zig").Graph;
const Path = @import("Path.zig").Path;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = &gpa.allocator();

    var graph = try Graph.init(allocator, 7);
    defer graph.deinit(allocator);

    graph.addEdge(0, 1);
    graph.addEdge(0, 3);
    graph.addEdge(0, 6);

    graph.addEdge(1, 2);
    graph.addEdge(1, 3);

    graph.addEdge(2, 1);
    graph.addEdge(2, 3);

    graph.addEdge(3, 2);
    graph.addEdge(3, 4);

    graph.addEdge(4, 5);
    graph.addEdge(4, 1);

    graph.addEdge(5, 2);
    graph.addEdge(5, 6);

    graph.printGraph();
}
