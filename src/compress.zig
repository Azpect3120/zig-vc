const std = @import("std");
const zlib = std.compress.zlib;

/// Compress a string using the zlib algorithm.
/// The compressed data is written to the `writer`.
pub fn compress(allocator: std.mem.Allocator, writer: anytype, str: []const u8) !void {
    var compressor = try zlib.compressStream(allocator, writer, .{ .level = zlib.CompressionLevel.default });
    defer compressor.deinit();

    try compressor.writer().writeAll(str);
    try compressor.finish();
}

pub fn decompress(allocator: std.mem.Allocator, reader: anytype, writer: anytype) !void {
    var decompressor = try zlib.decompressStream(allocator, reader);
    defer decompressor.deinit();

    const buf = try decompressor.reader().readAllAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(buf);

    try writer.writeAll(buf);
}
