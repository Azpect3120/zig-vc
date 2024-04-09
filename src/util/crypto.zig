const std = @import("std");

/// Returns the hashed sum of a file name.
/// Use `std.fmt.fmtSliceHexLower(&fileSum(path));` to use value
pub fn fileSum(path: []const u8) [20]u8 {
    var vec: [20]u8 = undefined;
    std.crypto.hash.Sha1.hash(path, &vec, .{});
    return vec;
}
