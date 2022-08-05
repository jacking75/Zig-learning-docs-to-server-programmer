# zig 사용 예

## 리틀/빅 엔디언 타입
`std.builtin.Endian.Little`, `std.builtin.Endian.Big`
    
  
## 배열
  
### 특정 값으로 초기화
```
var arr1: [16]u8 = undefined;
mem.set(u8, &arr1, 0);
```

### 배열 선언 시 초기화
```
var buffer: [1000]u8 = undefined;

const twelve = [_]u8{ 12, 0, 0, 0 };
```  
  
  
  
## 구조체 
  
### 멤버를 특정 값으로 초기화 하기
```
const Color = struct {
        r: u8,
        g: u8,
        b: u8,
        a: u8,
    };

const c = zeroInit(Color, .{ 255, 255 });
try testing.expectEqual(Color{
    .r = 255,
    .g = 255,
    .b = 0,
    .a = 0,
}, c);
```
  
### packed 구조체  
```
pub const BitmapFileHeader = packed struct {
    magic_header: [2]u8,
    size: u32,
    reserved: u32,
    pixel_offset: u32,
};
```  
     
### 멤버 함수가 있는 구조체 
```
pub const FieldMeta = struct {
    wire_type: WireType,
    number: u61,

    pub fn init(value: u64) FieldMeta {
        return FieldMeta{
            .wire_type = @intToEnum(WireType, @truncate(u3, value)),
            .number = @intCast(u61, value >> 3),
        };
    }

    pub fn encodeInto(self: FieldMeta, buffer: []u8) []u8 {
        const uint = (@intCast(u64, self.number) << 3) + @enumToInt(self.wire_type);
        return coder.Uint64Coder.encode(buffer, uint);
    }

    pub fn decode(buffer: []const u8, len: *usize) ParseError!FieldMeta {
        const raw = try coder.Uint64Coder.decode(buffer, len);
        return init(raw);
    }
};
```

### 이름 없는 구조체
```
fn FromVarintCast(comptime TargetPrimitive: type, comptime Coder: type, comptime info: FieldMeta) type {
    return struct {
        const Self = @This();

        data: TargetPrimitive = 0,

        pub const field_meta = info;

        pub fn encodeSize(self: Self) usize {
            return Coder.encodeSize(self.data);
        }

        pub fn encodeInto(self: Self, buffer: []u8) []u8 {
            return Coder.encode(buffer, self.data);
        }

        pub fn decodeFrom(self: *Self, buffer: []const u8) ParseError!usize {
            var len: usize = undefined;
            const raw = try Coder.decode(buffer, &len);
            self.data = @intCast(TargetPrimitive, raw);
            return len;
        }
    };
}
```    
  

## 함수 반환 값이 에러 혹은 타입일 때 
에러 혹은  `[]u8`를 반환한다  
```
pub fn decode(buffer: []const u8, len: *usize, allocator: *std.mem.Allocator) ![]u8 {
        var header_len: usize = undefined;
        const header = try Uint64Coder.decode(buffer, &header_len);
        
        std.mem.copy(u8, data, buffer[header_len .. header_len + data.len]);
        len.* = header_len + data.len;

        return data;
    }
}
```
  
## 초기화 없이 변수 선언
```
var header_len: usize = undefined;
```  
  
  
## range for  
```
for (bytes) |byte, i| {
            if (i >= 10) {
                return error.Overflow;
            }
            
            if (byte & 0x80 == 0) {
                return value;
            }
        }
}       
``` 
  
## memcpy
```
pub fn encode(buffer: []u8, data: []const u8) []u8 {
    const header = Uint64Coder.encode(buffer, data.len);    
    std.mem.copy(u8, buffer[header.len..], data);
    return buffer[0 .. header.len + data.len];
}
```  
  
## error
```
pub const ParseError = error{
    Overflow,
    EndOfStream,
    OutOfMemory,
};
```  
  
## 컴파일 타임에 함수 선택 하기
```
pub const readStructLittle = switch (native_endian) {
    builtin.Endian.Little => readStructNative,
    builtin.Endian.Big => readStructForeign,
};

pub fn readStructNative(reader: io.StreamSource.Reader, comptime T: type) StructReadError!T {
    var result: T = try reader.readStruct(T);
    try checkEnumFields(&result);
    return result;
}

pub fn readStructForeign(reader: io.StreamSource.Reader, comptime T: type) StructReadError!T {
    var result: T = try reader.readStruct(T);
    try swapFieldBytes(&result);
    return result;
}
```








