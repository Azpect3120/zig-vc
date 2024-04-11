const std = @import("std");
const blob = @import("../core/blob.zig");
const tracked = @import("../core/tracked.zig");
const cmp = @import("../util/compress.zig");

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
        // Get data path of the blob
        const path = try blob.getDataPath(allocator, line);

        // Get the blob file
        const blob_file = try blob.get(line);
        defer blob_file.close();

        // NOTE!: It might be faster to compress the new file instead...

        // Open the path and compare if the decompressed blob is same as the file
        const cur_file = try std.fs.cwd().openFile(path, .{ .mode = .read_only });
        defer cur_file.close();

        // Create writer and the decompressed blob
        var list = std.ArrayList(u8).init(allocator);
        try cmp.decompress(allocator, blob_file.reader(), list.writer());

        const file_buf = try file.reader().readAllAlloc(allocator, 1024 * 1024);
        const blob_buf = try list.toOwnedSlice();

        // Compare the two buffers
        if (std.mem.eql(u8, file_buf, blob_buf)) {
            const entry = try std.fmt.allocPrint(allocator, "->  {s}\n", .{path});
            try stdout.writeAll(entry);

            // File has vbeen
        } else {
            const entry = try std.fmt.allocPrint(allocator, "MODIFIED!  {s}\n", .{path});
            try stdout.writeAll(entry);
        }

        // Increment the number of files tracked
        i += 1;
    }

    if (i == 0) {
        try stdout.writeAll("\n  No files tracked!\n");
    }
}
