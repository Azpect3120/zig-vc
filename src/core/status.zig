const std = @import("std");
const blob = @import("../core/blob.zig");
const tracked = @import("../core/tracked.zig");

const stdout = std.io.getStdOut().writer();

pub fn print(allocator: std.mem.Allocator) !void {
    // Get the tracked file
    const file = try tracked.getTrackedFile();
    defer file.close();

    // Create buffered reader and buffer
    var buf_reader = std.io.bufferedReader(file.reader());
    var buf: [1024]u8 = undefined;

    // Print header
    try stdout.writeAll("Tracked files:\n");

    // Number of files tracked
    var i: usize = 0;

    // Read the file line by line
    while (try buf_reader.reader().readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const path = try blob.getDataPath(allocator, line);
        const entry = try std.fmt.allocPrint(allocator, "->  {s}\n", .{path});
        try stdout.writeAll(entry);
        i += 1;
    }

    if (i == 0) {
        try stdout.writeAll("\n  No files tracked!\n");
    }
}
