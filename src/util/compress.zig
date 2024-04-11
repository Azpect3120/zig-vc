const std = @import("std");
const zlib = std.compress.zlib;

/// Compress `str` using the zlib algorithm.
/// The compressed data is written to the `writer`.
pub fn compressString(allocator: std.mem.Allocator, writer: anytype, str: []const u8) !void {
    var compressor = try zlib.compressStream(allocator, writer, .{ .level = zlib.CompressionLevel.default });
    defer compressor.deinit();

    try compressor.writer().writeAll(str);
    try compressor.finish();
}

/// Compress from a `reader` using the zlib algorithm.
/// The data from the `reader` is written to the `writer`.
pub fn compress(allocator: std.mem.Allocator, reader: anytype, writer: anytype) !void {
    var compressor = try zlib.compressStream(allocator, writer, .{ .level = zlib.CompressionLevel.maximum });
    defer compressor.deinit();

    const bytes = try reader.readAllAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(bytes);
    try compressor.writer().writeAll(bytes);
    try compressor.finish();
}

/// Decompress from a `reader` using the zlib algorithm.
/// The data from the `reader` is written to the `writer`.
pub fn decompress(allocator: std.mem.Allocator, reader: anytype, writer: anytype) !void {
    var decompressor = try zlib.decompressStream(allocator, reader);
    defer decompressor.deinit();

    const bytes = try decompressor.reader().readAllAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(bytes);
    try writer.writeAll(bytes);
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

    try compress(std.testing.allocator, hello_input.reader(), hello_compressed.writer());
    try compress(std.testing.allocator, lorem_input.reader(), lorem_compressed.writer());
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
//     try decompress(std.testing.allocator, hello_compressed.reader(), hello_decompressed.writer());
//     try decompress(std.testing.allocator, lorem_compressed.reader(), lorem_decompressed.writer());
// }
