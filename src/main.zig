const std = @import("std");
const commands = @import("commands.zig");
const print = std.debug.print;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();
    try parseArgs(allocator);
}

/// Parse the arguments passed into the program.
fn parseArgs(allocator: std.mem.Allocator) !void {
    var args = std.process.args();
    _ = args.skip();

    var command = args.next() orelse "";
    var arguments = std.ArrayList([:0]const u8).init(allocator);
    while (args.next()) |arg| try arguments.append(arg);

    const cmd = validateCommand(command);
    try executeCommand(allocator, cmd, arguments);
}

/// Validate the command passed into the program.
fn validateCommand(cmd: [:0]const u8) commands.COMMAND {
    if (std.mem.eql(u8, cmd, "init")) {
        return commands.COMMAND.INIT;
    } else if (std.mem.eql(u8, cmd, "destroy")) {
        return commands.COMMAND.DESTROY;
    } else if (std.mem.eql(u8, cmd, "status")) {
        return commands.COMMAND.STATUS;
    } else if (std.mem.eql(u8, cmd, "track")) {
        return commands.COMMAND.TRACK;
    } else if (std.mem.eql(u8, cmd, "commit")) {
        return commands.COMMAND.COMMIT;
    } else {
        return commands.COMMAND.INVALID;
    }
}

/// After parsing the command and arguments, execute the command.
fn executeCommand(allocator: std.mem.Allocator, cmd: commands.COMMAND, args: std.ArrayList([:0]const u8)) !void {
    switch (cmd) {
        commands.COMMAND.INIT => {
            try commands.init(allocator);
        },
        commands.COMMAND.DESTROY => {
            try commands.destory(allocator);
        },
        commands.COMMAND.STATUS => {
            try commands.status(allocator);
        },
        commands.COMMAND.TRACK => {
            try commands.track(allocator, args);
        },
        commands.COMMAND.COMMIT => {
            try commands.commit(allocator);
        },
        commands.COMMAND.INVALID => {
            print("Invalid command\n", .{});
        },
        else => {
            print("Unknown command\n", .{});
        },
    }
}
