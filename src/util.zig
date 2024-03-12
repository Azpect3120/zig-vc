const std = @import("std");
const fs = std.fs;

pub fn isDir(path: []u8) bool {
    _ = fs.openDirAbsolute(path, .{}) catch return false;
    return true;
}

/// Returns the SHA1 hash of the file at the given path.
/// Use the std.fmt.fmtSliceHexLower function to format the hash as a string.
pub fn fileSum(path: []u8) [20]u8 {
    var hash: [20]u8 = undefined;
    std.crypto.hash.Sha1.hash(path, &hash, .{});
    return hash;
}

// BROKEN
pub fn compress(allocator: std.mem.Allocator, stream: []u8) ![]u8 {
    var list = std.ArrayList(u8).init(allocator);
    defer {
        list.clearAndFree();
        list.deinit();
    }

    var compressor = try std.compress.zlib.compressStream(allocator, list.writer(), .{ .level = .no_compression });
    defer compressor.deinit();

    _ = try compressor.write(stream);

    return list.toOwnedSlice();
}

pub fn decompress(allocator: std.mem.Allocator, stream: []u8) ![]u8 {
    _ = allocator;
    return stream;
}
