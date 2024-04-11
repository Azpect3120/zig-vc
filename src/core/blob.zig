const std = @import("std");
const cmp = @import("../util/compress.zig");
const crypto = @import("../util/crypto.zig");
const tracked = @import("../core/tracked.zig");

const print = std.debug.print;

/// Create a new blob file in the `/ziggit/objects` directory.
/// The `path` provided should be the path to the file to be compressed,
/// relative to the ziggit root directory.
pub fn new(allocator: std.mem.Allocator, path: []const u8) !void {
    // Open inputted file
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    // Open ziggit directory
    var base = try std.fs.cwd().openDir("ziggit", .{});
    defer base.close();

    // Open ziggit objects directory
    var objects = try base.openDir("objects", .{});
    defer objects.close();

    // Generate filename hash
    const hash = std.fmt.fmtSliceHexLower(&crypto.fileSum(path));
    const name = try std.fmt.allocPrint(allocator, "{s}", .{hash});

    // Open object file or truncate it if exists
    const blob = try objects.createFile(name, .{});
    defer blob.close();

    // Write compressed input to output
    try cmp.compress(allocator, file.reader(), blob.writer());

    // Write blob info to info file
    try writeBlobToInfo(path, name);

    // Write entry to tracked file
    try tracked.add(allocator, name);
}

/// Add an entry to the blob info file
fn writeBlobToInfo(path: []const u8, name: []const u8) !void {
    // Open the info directory
    var info = try std.fs.cwd().openDir("ziggit/info", .{});
    defer info.close();

    // Open or create BLOB file
    const blob = try info.createFile(name, .{ .truncate = false, .read = true });
    defer blob.close();

    // Write blob info to file
    try blob.writer().writeAll(path);
}
