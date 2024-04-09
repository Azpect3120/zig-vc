const std = @import("std");
const cmp = @import("../util/compress.zig");
const crypto = @import("../util/crypto.zig");

const print = std.debug.print;

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
}
