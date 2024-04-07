const std = @import("std");
const compression = @import("compress.zig");

const print = std.debug.print;

// Global allocator
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
var allocator = gpa.allocator();

pub fn main() !void {
    const input_data = @embedFile("input.txt");

    const compressed_data = try compression.compress(allocator, input_data);

    print("Compressed from {d} bytes to {d} bytes!\n", .{ input_data.len, compressed_data.len });
}
