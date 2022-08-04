const print = std.debug.print;
const std = @import("std");
const io = std.io;
const mem = std.mem;

pub const BitmapFileHeader = packed struct {
    magic_header: [2]u8,
    size: u32,
    reserved: u32,
    pixel_offset: u32,
};

pub fn main() anyerror!void {
    

    buffer_slice_read_write();
}

pub fn buffer_slice_read_write() void {    
    print("buffer_slice_read_write - START\n", .{});


    var arr1: [16]u8 = undefined;
    print( "{}, {}, {}, {}\n", .{arr1[0], arr1[1], arr1[2], arr1[3]} );


    //쓰기
    var value1: i32 = 15;
    @memcpy(&arr1, @ptrCast([*]const u8, &value1), 4);  
    print( "{}, {}, {}, {}\n", .{arr1[0], arr1[1], arr1[2], arr1[3]} );

    value1 = 20;
    @memcpy(arr1[4..8], @ptrCast([*]const u8, &value1), 4);  
    print( "{}, {}, {}, {}\n", .{arr1[4], arr1[5], arr1[6], arr1[7]} );
 

    //읽기
    var value2 : i32 = 0;
    var pos : u32 = 0;

    value2 = std.mem.readIntSliceLittle(i32, arr1[pos..4]);
    //value2 = @ptrToInt(&arr1[pos..4]);
    print("arr1[0-4] - {}\n", .{value2});

    print("buffer_slice_read_write - END\n", .{});
}

//https://github.com/fengb/zig-protobuf/blob/master/src/coder.zig
//https://github.com/ziglang/zig/blob/master/lib/std/unicode.zig
//mem.writeIntSliceLittle(u16, utf16le_as_bytes[0..], 'A');

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
