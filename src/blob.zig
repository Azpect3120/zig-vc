const std = @import("std");
const util = @import("util.zig");

pub fn new(allocator: std.mem.Allocator, path: []u8, data: []u8) !void {
    var objects = try std.fs.cwd().openDir(".ziggit/objects", .{});
    defer objects.close();

    const name = std.fmt.fmtSliceHexLower(&util.fileSum(path));

    const blob = try objects.createFile(try std.fmt.allocPrint(allocator, "{s}", .{name}), .{});
    defer blob.close();

    // The top line of the file stores the ABS path of the file
    const blob_data = try std.fmt.allocPrint(allocator, "{s}\n{s}", .{ path, data });

    try blob.writeAll(blob_data);
}
