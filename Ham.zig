const std = @import("std");
const Graph = @import("Graph.zig").Graph;
const Path = @import("Path.zig").Path;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

const Sequence = @import("Sequence.zig").Sequence;

pub fn findAllPathsFromVertex(current: usize, graph: *const Graph, current_path: *Path, all_paths: *ArrayList(Path), visited: []bool, table: []Sequence) !void {
    visited[current] = true;
    try current_path.vertices.append(table[current]);

    const path_copy = try current_path.clone();
    try all_paths.append(path_copy);

    for (0..graph.size) |next| {
        if (graph.adj_matrix[current * graph.size + next] and !visited[next]) {
            try findAllPathsFromVertex(next, graph, current_path, all_paths, visited, table);
        }
    }

    _ = current_path.vertices.pop();
    visited[current] = false;
}

pub fn findAllPaths(allocator: Allocator, graph: *const Graph, table: []Sequence) !ArrayList(Path) {
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

        try findAllPathsFromVertex(start, graph, &current_path, &all_paths, visited, table);
    }
    return all_paths;
}

pub fn toString(self: *const Sequence) []const u8 {
    return self.data.items; // Assuming `data.items` holds the DNA bases
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

    var seq1 = Sequence.init(allocator);
    var seq2 = Sequence.init(allocator);
    var seq3 = Sequence.init(allocator);
    var seq4 = Sequence.init(allocator);
    var seq5 = Sequence.init(allocator);
    var seq6 = Sequence.init(allocator);
    var seq7 = Sequence.init(allocator);

    try seq1.appendSequence("ATCG");
    try seq2.appendSequence("TTCC");
    try seq3.appendSequence("GCGC");
    try seq4.appendSequence("TTGG");
    try seq5.appendSequence("ATTC");
    try seq6.appendSequence("CTGA");
    try seq7.appendSequence("TTCT");

    defer seq1.deinit();
    defer seq2.deinit();
    defer seq3.deinit();
    defer seq4.deinit();
    defer seq5.deinit();
    defer seq6.deinit();
    defer seq7.deinit();

    const seq_table = try allocator.alloc(Sequence, 7);
    seq_table[0] = seq1;
    seq_table[1] = seq2;
    seq_table[2] = seq3;
    seq_table[3] = seq4;
    seq_table[4] = seq5;
    seq_table[5] = seq6;
    seq_table[6] = seq7;

    defer allocator.free(seq_table); // Free memory after use

    var all_paths = try findAllPaths(allocator, &graph, seq_table);

    //var all_paths = try findAllPaths(allocator, &graph);

    // Clean up paths when done
    defer {
        for (all_paths.items) |*path| {
            path.deinit();
        }
        all_paths.deinit();
    }

    //const seq: [7][]const u8 = .{ "ATCG", "CTGA", "GCTT", "TTCG", "AATT", "TAAG", "GTGA" };

    const stdout = std.io.getStdOut().writer();
    try stdout.print("Found {} paths:\n", .{all_paths.items.len});
    for (all_paths.items, 0..) |path, i| {
        try stdout.print("Path {}: ", .{i + 1});
        for (path.vertices.items) |vertex| {
            const please: Sequence = vertex;
            //try stdout.print("{} ", .{vertex});
            try please.printSequenceString();
        }
        try stdout.print("\n", .{});
    }
}
