const std = @import("std");
const zlib = std.compress.zlib;

pub fn compress(allocator: std.mem.Allocator, writer: anytype, str: []const u8) !void {
    var compressor = try zlib.compressStream(allocator, writer, .{ .level = zlib.CompressionLevel.default });
    defer compressor.deinit();

    try compressor.writer().writeAll(str);
    try compressor.finish();
}
