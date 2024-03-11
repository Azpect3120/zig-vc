const std = @import("std");
const commands = @import("commands.zig");

const print = std.debug.print;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();
    try parseArgs(allocator);

    print("{d}\n", .{commands.init()});
}

/// Parse the arguments passed into the program.
fn parseArgs(allocator: std.mem.Allocator) !void {
    var args = std.process.args();
    _ = args.skip();

    var command = args.next() orelse "";
    var arguments = std.ArrayList([:0]const u8).init(allocator);
    while (args.next()) |arg| try arguments.append(arg);

    const cmd = validateCommand(command);
    print("Command: {any}\n", .{cmd});
    print("Arguments: {s}\n", .{arguments.items});
}

/// Validate the command passed into the program.
fn validateCommand(cmd: [:0]const u8) commands.COMMAND {
    if (std.mem.eql(u8, cmd, "init")) {
        return commands.COMMAND.INIT;
    } else {
        return commands.COMMAND.INVALID;
    }
}
