const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const Sequence = @import("Sequence.zig").Sequence;

pub const Path = struct {
    vertices: ArrayList(Sequence),
    // vertices: ArrayList(usize),

    pub fn init(allocator: Allocator) Path {
        return Path{
            .vertices = ArrayList(Sequence).init(allocator),
            // .vertices = ArrayList(usize).init(allocator),
        };
    }

    pub fn deinit(self: *Path) void {
        self.vertices.deinit();
    }

    pub fn clone(self: *const Path) !Path {
        var new_path = Path.init(self.vertices.allocator);
        try new_path.vertices.appendSlice(self.vertices.items);
        return new_path;
    }
};
