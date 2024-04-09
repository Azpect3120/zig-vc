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
