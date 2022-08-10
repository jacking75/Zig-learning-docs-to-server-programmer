const std = @import("std");
const net = std.net;
const os = std.os;


pub fn main() anyerror!void {
    std.log.info("echo server", .{});

    var server = net.StreamServer.init(.{});
    defer server.deinit();

    try server.listen(net.Address.parseIp("127.0.0.1", 11021) catch unreachable);

    while(true) {
        var conn = server.accept() catch |err| { std.log.err("Fail accept: {}", .{err}); break; };
        std.log.info("new conn: {}", .{conn.address});

        var buf: [2000]u8 = undefined;
        var len = conn.stream.read(&buf) catch |err| { 
            std.log.err("Fail read: {}", .{err}); 
            conn.stream.close();
            break; 
        };
        std.log.info("read: {}", .{len});

        _ = conn.stream.write(buf[0..len]) catch |err| {
            std.log.err("Fail write: {}", .{err}); 
            conn.stream.close();
        };
    }
    
}


