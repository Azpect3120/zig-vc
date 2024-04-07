const std = @import("std");

// Global allocator
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
var allocator = gpa.allocator();

pub fn compress(str: []const u8) !usize {
    var list = std.ArrayList(u8).init(allocator);
    defer list.deinit();

    var writer = list.writer();

    const cmp = std.compress.deflate.Compressor(@TypeOf(writer));
    defer cmp.deinit();
    // cmp.writer

    const bytes_written = try cmp.write(&cmp, str);
    return bytes_written;
}
