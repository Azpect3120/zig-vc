const std = @import("std");
const compression = @import("compress.zig");

const print = std.debug.print;

// Global allocator
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
var allocator = gpa.allocator();

pub fn main() !void {
    const input_data = @embedFile("./");

    // var compression_list = std.ArrayList(u8).init(allocator);
    // defer compression_list.deinit();
    // try compression.compress(allocator, compression_list.writer(), input_data);

    const output = try std.fs.cwd().createFile("output.txt", .{ .truncate = false, .read = true });
    defer output.close();

    try compression.compress(allocator, output.writer(), input_data);

    // print("Compressed from {d} bytes to {d} bytes!\n", .{ input_data.len,  });
}
