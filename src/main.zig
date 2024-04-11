const std = @import("std");
const cmp = @import("util/compress.zig");
const blob = @import("core/blob.zig");
const status = @import("core/status.zig");

const print = std.debug.print;

// Global allocator
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
var allocator = gpa.allocator();

pub fn main() !void {
    try status.print(allocator);
    // try blob.new(allocator, "./build.zig");
    // try blob.new(allocator, "./src/main.zig");
    // try blob.new(allocator, "./src/core/blob.zig");
    // try status.print(allocator);
    // try blob.new(allocator, "./src/util/compress.zig");
    // try blob.new(allocator, "./src/util/crypto.zig");
}
