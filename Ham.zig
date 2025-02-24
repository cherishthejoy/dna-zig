const std = @import("std");
const Graph = @import("Graph.zig").Graph;
const Path = @import("Path.zig").Path;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub fn findAllPathsFromVertex(current: usize, graph: *const Graph, current_path: *Path, all_paths: *ArrayList(Path), visited: []bool) !void {
    //const table = [_]u8{ 'A', 'C', 'G', 'T', 'X', 'Y', 'Z' };
    visited[current] = true;
    try current_path.vertices.append(current);

    const path_copy = try current_path.clone();
    try all_paths.append(path_copy);

    for (0..graph.size) |next| {
        if (graph.adj_matrix[current * graph.size + next] and !visited[next]) {
            try findAllPathsFromVertex(next, graph, current_path, all_paths, visited);
        }
    }

    _ = current_path.vertices.pop();
    visited[current] = false;
}

pub fn findAllPaths(allocator: Allocator, graph: *const Graph) !ArrayList(Path) {
    var all_paths = ArrayList(Path).init(allocator);

    errdefer {
        for (all_paths.items) |*path| {
            path.deinit();
        }
        all_paths.deinit();
    }

    const visited = try allocator.alloc(bool, graph.size);
    defer allocator.free(visited);
    @memset(visited, false);

    for (0..graph.size) |start| {
        var current_path = Path.init(allocator);
        defer current_path.deinit();

        try findAllPathsFromVertex(start, graph, &current_path, &all_paths, visited);
    }
    return all_paths;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

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

    var all_paths = try findAllPaths(allocator, &graph);
    // Clean up paths when done
    defer {
        for (all_paths.items) |*path| {
            path.deinit();
        }
        all_paths.deinit();
    }

    const table = [_]u8{ 'A', 'C', 'G', 'T', 'X', 'Y', 'Z' };

    const stdout = std.io.getStdOut().writer();
    try stdout.print("Found {} paths:\n", .{all_paths.items.len});
    for (all_paths.items, 0..) |path, i| {
        try stdout.print("Path {}: ", .{i + 1});
        for (path.vertices.items) |vertex| {
            try stdout.print("{c} ", .{table[vertex]});
        }
        try stdout.print("\n", .{});
    }
}
