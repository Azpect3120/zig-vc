const std = @import("std");
const zlib = std.compress.zlib;

pub fn compress(allocator: std.mem.Allocator, str: []const u8) ![]u8 {
    var comp_data = std.ArrayList(u8).init(allocator);
    defer comp_data.deinit();

    var compressor = try zlib.compressStream(allocator, comp_data.writer(), .{ .level = zlib.CompressionLevel.default });
    defer compressor.deinit();

    try compressor.writer().writeAll(str);
    try compressor.finish();

    return comp_data.items;
}
