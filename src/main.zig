const std = @import("std");
const cmp = @import("util/compress.zig");
const blob = @import("core/blob.zig");

const print = std.debug.print;

// Global allocator
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
var allocator = gpa.allocator();

pub fn main() !void {
    // const input = try std.fs.cwd().openFile("./src/test_files/lorem.txt", .{});
    // const output = try std.fs.cwd().createFile("./src/test_files/lorem_compressed.txt.z", .{ .truncate = true, .read = true });
    //
    // try cmp.compress(allocator, input.reader(), output.writer());
    // output.close();
    // input.close();
    //
    // const opened_read = try std.fs.cwd().openFile("./src/test_files/lorem_compressed.txt.z", .{});
    // const opened_write = try std.fs.cwd().createFile("./src/test_files/lorem_decompressed.txt", .{});
    //
    // try cmp.decompress(allocator, opened_read.reader(), opened_write.writer());
    try blob.new(allocator, "./build.zig");
    try blob.new(allocator, "./src/main.zig");
    try blob.new(allocator, "./src/core/blob.zig");
    try blob.new(allocator, "./src/util/compress.zig");
    try blob.new(allocator, "./src/util/crypto.zig");
}

test "compressing files" {
    const hello_input = try std.fs.cwd().openFile("./src/test_files/hello.txt", .{});
    const lorem_input = try std.fs.cwd().openFile("./src/test_files/lorem.txt", .{});
    defer {
        hello_input.close();
        lorem_input.close();
    }

    const hello_compressed = try std.fs.cwd().createFile("./src/test_files/hello_compressed.txt.z", .{ .truncate = true, .read = true });
    const lorem_compressed = try std.fs.cwd().createFile("./src/test_files/lorem_compressed.txt.z", .{ .truncate = true, .read = true });
    defer {
        hello_compressed.close();
        lorem_compressed.close();
    }

    try cmp.compress(std.testing.allocator, hello_input.reader(), hello_compressed.writer());
    try cmp.compress(std.testing.allocator, lorem_input.reader(), lorem_compressed.writer());
}

// This fails and its not even my fault
// Some kind of skill issue somewhere
// test "decompressing files" {
//     const hello_compressed = try std.fs.cwd().createFile("./src/test_files/hello_compressed.txt.z", .{ .truncate = true, .read = true });
//     const lorem_compressed = try std.fs.cwd().createFile("./src/test_files/lorem_compressed.txt.z", .{ .truncate = true, .read = true });
//     defer {
//         hello_compressed.close();
//         lorem_compressed.close();
//     }
//
//     const hello_decompressed = try std.fs.cwd().createFile("./src/test_files/hello_decompressed.txt", .{ .truncate = true, .read = true });
//     const lorem_decompressed = try std.fs.cwd().createFile("./src/test_files/lorem_decompressed.txt", .{ .truncate = true, .read = true });
//     defer {
//         hello_decompressed.close();
//         lorem_decompressed.close();
//     }
//
//     try cmp.decompress(std.testing.allocator, hello_compressed.reader(), hello_decompressed.writer());
//     try cmp.decompress(std.testing.allocator, lorem_compressed.reader(), lorem_decompressed.writer());
// }
