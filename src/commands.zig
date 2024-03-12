const std = @import("std");
const util = @import("util.zig");
const blob = @import("blob.zig");

const stdout = std.io.getStdOut().writer();
const format = std.fmt.allocPrint;

pub const COMMAND = enum { INIT, DESTROY, TRACK, COMMIT, STATUS, HISTORY, INVALID };

/// Initialize the version control repository
pub fn init(allocator: std.mem.Allocator) !void {
    // Get the current working directory
    const cwd = try std.fs.cwd().realpathAlloc(allocator, ".");
    const path = try std.fmt.allocPrint(allocator, "{s}/.ziggit", .{cwd});

    // Check if the repository already exists
    _ = std.fs.openDirAbsolute(path, .{}) catch {
        // Create the repository
        try std.fs.cwd().makePath(".ziggit/branches");
        try std.fs.cwd().makePath(".ziggit/info");
        try std.fs.cwd().makePath(".ziggit/objects");
        try std.fs.cwd().makePath(".ziggit/refs/heads");
        try std.fs.cwd().makePath(".ziggit/refs/remotes");
        try std.fs.cwd().makePath(".ziggit/refs/commits");
        try std.fs.cwd().makePath(".ziggit/logs");
        _ = try std.fs.cwd().createFile(".ziggit/HEAD", .{ .read = true });
        _ = try std.fs.cwd().createFile(".ziggit/refs/TRACKED", .{ .read = true });

        return try stdout.print("Initializing repository in {s}\n", .{try std.fs.cwd().realpathAlloc(allocator, "./.ziggit")});
    };

    return try stdout.print("Repository already exists in {s}\n", .{try std.fs.cwd().realpathAlloc(allocator, "./.ziggit")});
}

/// De-initialize the version control repository
pub fn destory(allocator: std.mem.Allocator) !void {
    // Get the current working directory
    const cwd = try std.fs.cwd().realpathAlloc(allocator, ".");
    const path = try std.fmt.allocPrint(allocator, "{s}/.ziggit", .{cwd});

    // Check if the repository already exists
    _ = std.fs.openDirAbsolute(path, .{}) catch {
        return try stdout.print("You cannot destroy what does not exist.\n", .{});
    };

    // Remove the repository
    try std.fs.deleteTreeAbsolute(path);
    return try stdout.print("Repository destroyed in {s}.ziggit\n", .{try std.fs.cwd().realpathAlloc(allocator, ".")});
}

/// Adds a file or directory to the version control repository
pub fn track(allocator: std.mem.Allocator, args: std.ArrayList([:0]const u8)) !void {
    const tracked = try std.fs.cwd().openFile(".ziggit/refs/TRACKED", .{ .mode = .read_write });
    defer tracked.close();

    // Track files found in the arguments
    for (args.items) |arg| {
        // Get path to file or directory
        const path = std.fs.cwd().realpathAlloc(allocator, arg) catch {
            try stdout.print("Could not find file or directory: {s}\n", .{arg});
            continue;
        };

        try trackDir(allocator, tracked, path);
    }
}

/// Recursively track a directory
fn trackDir(allocator: std.mem.Allocator, tracked: std.fs.File, path: []u8) !void {
    // Create hash to the file
    const hash = std.fmt.fmtSliceHexLower(&util.fileSum(path));

    // Prevent tracking the .ziggit and .git directory
    if (std.mem.indexOf(u8, path, ".ziggit") != null or std.mem.indexOf(u8, path, ".git") != null) return;

    // Path a directory
    if (util.isDir(path)) {
        // Open directory
        var itter_dir = try std.fs.openIterableDirAbsolute(path, .{});
        defer itter_dir.close();

        // Create walker on the directory
        var walker = try itter_dir.walk(allocator);
        defer walker.deinit();

        // Walk the directory
        while (try walker.next()) |entry| {
            // Create the path to the file
            const entry_path = try format(allocator, "{s}/{s}", .{ path, entry.path });

            // Recursively track the directory
            // Multi-thread this
            // try trackDir(allocator, tracked, entry_path);
            _ = try std.Thread.spawn(.{ .allocator = allocator }, trackDir, .{ allocator, tracked, entry_path });

            // Output the tracking
            // WAY TOO MUCH! Should only print the first level of directories
            // try stdout.print("Tracking: {s}\n", .{entry_path});
        }
        return;
    }

    // Open file
    const file = try std.fs.openFileAbsolute(path, .{ .mode = .read_only });
    defer file.close();

    // Read file to buffer of ... big ... size
    const buf = try file.readToEndAlloc(allocator, 1024 << 50);

    // Create a new blob
    try blob.new(allocator, path, buf);

    // Add the blob to the TRACKED file
    // This is needs to be fixed to NOT override the file, instead append
    try tracked.writeAll(try format(allocator, "{s}\n", .{hash}));

    // Output the tracking
    // WAY TOO MUCH! Should only print the first level of directories
    // try stdout.print("Tracking: {s}\n", .{path});
}

pub fn commit(allocator: std.mem.Allocator) !void {
    _ = allocator;
}

/// View the status of the repository and its files
pub fn status(allocator: std.mem.Allocator) !void {
    _ = allocator;
}

pub fn history() !void {}
