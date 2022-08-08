# 소켓 프로그래밍
  
- [std.net](https://ziglang.org/documentation/master/std/#root;net )
    - [StreamServer](https://ziglang.org/documentation/master/std/#root;net.StreamServer ) 
    - [Stream](https://ziglang.org/documentation/master/std/#root;net.Stream )
       

# StreamServer
  
## Functions
```
fn accept(self: *StreamServer) AcceptError!Connection
If this function succeeds, the returned Connection is a caller-managed resource.

fn close(self: *StreamServer) void
Stop listening.

fn deinit(self: *StreamServer) void
Release all resources.

fn init(options: Options) StreamServer
After this call succeeds, resources have been acquired and must be released with deinit.

fn listen(self: *StreamServer, address: Address) !void  
```  
  
## Types
- Connection
    - stream: Stream,
    - address: Address,
- Options
    - kernel_backlog: u31,
    - reuse_address: bool,
      



# Stream
  
## Functions
```
fn close(self: Stream) void
fn read(self: Stream, buffer: []u8) ReadError!usize
fn reader(self: Stream) Reader
fn write(self: Stream, buffer: []const u8) WriteError!usize
TODO in evented I/O mode, this implementation incorrectly uses the event loop's file system thread instead of non-blocking.

fn writer(self: Stream) Writer
fn writev(self: Stream, iovecs: []const os.iovec_const) WriteError!usize
See https://github.

fn writevAll(self: Stream, iovecs: []os.iovec_const) WriteError!void
The iovecs parameter is mutable because this function needs to mutate the fields in order to handle partial writes from the underlying OS layer.
```  

## Fields
- handle: os.socket_t, 
  
## Values
- ReadError	   type	
- Reader	   anyopaque	
- WriteError   type	
- Writer	   anyopaque	




