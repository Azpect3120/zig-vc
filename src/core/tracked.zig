const std = @import("std");

/// Open the tracked file. Caller-owned memory is returned.
fn getTrackedFile() !std.fs.File {
    const file = try std.fs.cwd().openFile("ziggit/refs/TRACKED", .{ .mode = .read_write });
    return file;
}

/// Add a new entry to the TRACKED file
pub fn add(allocator: std.mem.Allocator, name: []u8) !void {
    const file = try getTrackedFile();
    defer file.close();

    const exists = try entryExists(file, name);
    if (!exists) {
        try file.seekFromEnd(0);

        // Write new entry
        const entry = try std.fmt.allocPrint(allocator, "{s}\n", .{name});
        try file.writeAll(entry);
    }
}

/// Check if an entry exists in the TRACKED file
fn entryExists(file: std.fs.File, entry: []u8) !bool {
    var buf_reader = std.io.bufferedReader(file.reader());
    var buf: [1024]u8 = undefined;

    while (try buf_reader.reader().readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (std.mem.eql(u8, entry, line)) {
            return true;
        }
    }

    return false;
}
