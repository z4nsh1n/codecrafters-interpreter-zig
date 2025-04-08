const std = @import("std");

const TokenType = enum {
    LEFT_PAREN,
    RIGHT_PAREN,
    EOF,
};

var stdout = std.io.getStdOut().writer();

const Token = struct {
    ttype: TokenType,
    lexeme: []const u8,
    object: ?struct {},
    line: i32,

    pub fn to_string(self: Token) !void {
        try stdout.print("{s} {s} {any}\n", .{ @tagName(self.ttype), self.lexeme, self.object });
        // std.debug.print("{s} {s} {any}\n", .{ @tagName(self.ttype), self.lexeme, self.object });
    }
};

pub fn main() !void {
    // const t1 = Token{ .ttype = .LEFT_PAREN, .lexeme = "(", .object = null, .line = 0 };
    // t1.to_string();

    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.process.argsFree(std.heap.page_allocator, args);

    if (args.len < 3) {
        std.debug.print("Usage: ./your_program.sh tokenize <filename>\n", .{});
        std.process.exit(1);
    }

    const command = args[1];
    const filename = args[2];

    if (!std.mem.eql(u8, command, "tokenize")) {
        std.debug.print("Unknown command: {s}\n", .{command});
        std.process.exit(1);
    }

    const file_contents = try std.fs.cwd().readFileAlloc(std.heap.page_allocator, filename, std.math.maxInt(usize));
    defer std.heap.page_allocator.free(file_contents);

    if (file_contents.len > 0) {
        // @panic("Scanner not implemented");

        for (0..file_contents.len) |idx| {
            const token = file_contents[idx .. idx + 1];
            if (std.mem.eql(u8, token, "(")) {
                const t = Token{ .ttype = .LEFT_PAREN, .lexeme = token, .line = 0, .object = null };
                try t.to_string();
            } else if (std.mem.eql(u8, token, ")")) {
                const t = Token{ .ttype = .RIGHT_PAREN, .lexeme = token, .line = 0, .object = null };
                try t.to_string();
            } else if (std.mem.eql(u8, token, "\n")) {
                const t = Token{ .ttype = .EOF, .lexeme = "", .line = 0, .object = null };
                try t.to_string();
            }
        }
    } else {
        try std.io.getStdOut().writer().print("EOF  null\n", .{}); // Placeholder, remove this line when implementing the scanner
    }
}
