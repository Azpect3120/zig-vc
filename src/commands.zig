const std = @import("std");
const stdout = std.io.getStdOut().writer();

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
        try std.fs.cwd().makePath(".ziggit/logs");
        _ = try std.fs.cwd().createFile(".ziggit/HEAD", .{ .read = true });

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

pub fn track() void {}

pub fn commit() void {}

pub fn status() void {}

pub fn history() void {}
