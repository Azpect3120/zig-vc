const std = @import("std");
const compression = @import("compress.zig");

const print = std.debug.print;

pub fn main() !void {
    const bytes_written = try compression.compress("Hello world! Your mom is my cardio!");
    std.debug.print("Bytes written: {}\n", .{bytes_written});
}
