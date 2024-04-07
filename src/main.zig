const std = @import("std");
const compression = @import("compress.zig");

const print = std.debug.print;

// Global allocator
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
var allocator = gpa.allocator();

pub fn main() !void {
    const input_data = @embedFile("./test_files/hello.txt");

    const output = try std.fs.cwd().createFile("output.txt", .{ .truncate = true, .read = true });
    // defer output.close();

    try compression.compress(allocator, output.writer(), input_data);
    output.close();

    const opened_read = try std.fs.cwd().openFile("output.txt", .{});
    const opened_write = try std.fs.cwd().createFile("output2.txt", .{});

    try compression.decompress(allocator, opened_read.reader(), opened_write.writer());
}
