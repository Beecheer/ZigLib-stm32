const std = @import("std");
const board = @import("board.zig");
const driver = board.uartDriver;
const RingQueue = @import("ring_queue.zig").RingQueue;

const config = @import("user_config.zig").UartConfig;

const Port = enum {
    UART1,
    UART2,
    UART3,
    UART5,
    UART7,
    UART10,
};

const Mode = enum {
    CPLT,
    IDLE,
};

fn driverSendFn(comptime port: Port) (fn ([]const u8) void) {
    const f_base: (fn ([*c]const u8, u16) callconv(.c) void) = switch (port) {
        .UART1 => driver.send_1,
        .UART2 => driver.send_2,
        .UART3 => driver.send_3,
        .UART5 => driver.send_5,
        .UART7 => driver.send_7,
        .UART10 => driver.send_10,
    };
    return struct {
        pub fn f(data: []const u8) void {
            const len: u16 = @intCast(data.len);
            f_base(data.ptr, len);
        }
    }.f;
}

fn driverReceiveFn(comptime port: Port, comptime mode: Mode) (fn ([]u8) void) {
    const f_base: (fn ([*c]u8, u16) callconv(.c) void) = switch (mode) {
        .CPLT => switch (port) {
            .UART1 => driver.receive_1,
            .UART2 => driver.receive_2,
            .UART3 => driver.receive_3,
            .UART5 => driver.receive_5,
            .UART7 => driver.receive_7,
            .UART10 => driver.receive_10,
        },
        .IDLE => switch (port) {
            .UART1 => driver.receiveToIdle_1,
            .UART2 => driver.receiveToIdle_2,
            .UART3 => driver.receiveToIdle_3,
            .UART5 => driver.receiveToIdle_5,
            .UART7 => driver.receiveToIdle_7,
            .UART10 => driver.receiveToIdle_10,
        },
    };
    return struct {
        pub fn f(buf: []u8) void {
            const len: u16 = @intCast(buf.len);
            f_base(buf.ptr, len);
        }
    }.f;
}

fn UartInstance(
    comptime port: Port,
    comptime mode: Mode,
    comptime bufSize: usize,
    comptime txBufNum: usize,
    comptime rxBufNum: usize,
) type {
    return struct {
        const Self = @This();

        const driverSend = driverSendFn(port);
        const driverReceive = driverReceiveFn(port, mode);

        pub const Mail = struct {
            len: u16,
            buf: [bufSize]u8,
            pub fn slice(self: *const @This()) []const u8 {
                return self.buf[0..self.len];
            }
            pub fn sliceMut(self: *@This()) []u8 {
                return self.buf[0..self.len];
            }
            pub fn fullSlice(self: *const @This()) []const u8 {
                return self.buf[0..];
            }
            pub fn fullSliceMut(self: *@This()) []u8 {
                return self.buf[0..];
            }
        };

        const TxMailBox = RingQueue(Mail, txBufNum);
        const RxMailBox = RingQueue(Mail, rxBufNum);

        _tx: TxMailBox = .{},
        _tx_mail: Mail = undefined,

        _rx: RxMailBox = .{},
        _rx_mail: Mail = undefined,

        pub fn init(self: *Self) void {
            driverReceive(self._rx_mail.fullSliceMut());
        }

        pub fn write(self: *Self, data: []const u8) void {
            var t: Mail = undefined;
            const n: u16 = @intCast(@min(data.len, bufSize));
            t.len = n;
            @memcpy(t.buf[0..n], data[0..n]);
            if (n < bufSize) {
                @memset(t.buf[n..], 0);
            }
            self._tx.pushForce(t);
        }

        pub fn read(self: *Self) ?Mail {
            return self._rx.pop();
        }

        pub fn sendLoop(self: *Self) void {
            self._tx_mail = self._tx.pop() orelse return;
            driverSend(self._tx_mail.slice());
        }

        fn idleCallbackHandler(self: *Self, size: u16) void {
            comptime {
                if (mode != .IDLE) {
                    @compileError("uart mode error");
                }
            }
            self._rx_mail.len = @min(size, bufSize);
            self._rx.pushForce(self._rx_mail);
            self.init();
        }

        fn cpltCallbackHandler(self: *Self) void {
            comptime {
                if (mode != .CPLT) {
                    @compileError("uart mode error");
                }
            }
            self._rx_mail.len = @intCast(bufSize);
            self._rx.pushForce(self._rx_mail);
            self.init();
        }
    };
}

fn chooseMode(mode: config.Mode) Mode {
    return switch (mode) {
        .CPLT => Mode.CPLT,
        .IDLE => Mode.IDLE,
    };
}

pub var uart1 = UartInstance(
    .UART1,
    chooseMode(config.UART1.mode),
    config.UART1.bufSize,
    config.UART1.txBufNum,
    config.UART1.rxBufNum,
){};
pub var uart2 = UartInstance(
    .UART2,
    chooseMode(config.UART2.mode),
    config.UART2.bufSize,
    config.UART2.txBufNum,
    config.UART2.rxBufNum,
){};
pub var uart3 = UartInstance(
    .UART3,
    chooseMode(config.UART3.mode),
    config.UART3.bufSize,
    config.UART3.txBufNum,
    config.UART3.rxBufNum,
){};
pub var uart5 = UartInstance(
    .UART5,
    chooseMode(config.UART5.mode),
    config.UART5.bufSize,
    config.UART5.txBufNum,
    config.UART5.rxBufNum,
){};
pub var uart7 = UartInstance(
    .UART7,
    chooseMode(config.UART7.mode),
    config.UART7.bufSize,
    config.UART7.txBufNum,
    config.UART7.rxBufNum,
){};
pub var uart10 = UartInstance(
    .UART10,
    chooseMode(config.UART10.mode),
    config.UART10.bufSize,
    config.UART10.txBufNum,
    config.UART10.rxBufNum,
){};

export fn userUartRxIdleCallback_1(Size: u16) void {
    if (config.UART1.mode == .IDLE) {
        uart1.idleCallbackHandler(Size);
    }
}
export fn userUartRxIdleCallback_2(Size: u16) void {
    if (config.UART2.mode == .IDLE) {
        uart2.idleCallbackHandler(Size);
    }
}
export fn userUartRxIdleCallback_3(Size: u16) void {
    if (config.UART3.mode == .IDLE) {
        uart3.idleCallbackHandler(Size);
    }
}
export fn userUartRxIdleCallback_5(Size: u16) void {
    if (config.UART5.mode == .IDLE) {
        uart5.idleCallbackHandler(Size);
    }
}
export fn userUartRxIdleCallback_7(Size: u16) void {
    if (config.UART7.mode == .IDLE) {
        uart7.idleCallbackHandler(Size);
    }
}
export fn userUartRxIdleCallback_10(Size: u16) void {
    if (config.UART10.mode == .IDLE) {
        uart10.idleCallbackHandler(Size);
    }
}

export fn userUartRxCpltCallback_1() void {
    if (config.UART1.mode == .CPLT) {
        uart1.cpltCallbackHandler();
    }
}
export fn userUartRxCpltCallback_2() void {
    if (config.UART2.mode == .CPLT) {
        uart2.cpltCallbackHandler();
    }
}
export fn userUartRxCpltCallback_3() void {
    if (config.UART3.mode == .CPLT) {
        uart3.cpltCallbackHandler();
    }
}
export fn userUartRxCpltCallback_5() void {
    if (config.UART5.mode == .CPLT) {
        uart5.cpltCallbackHandler();
    }
}
export fn userUartRxCpltCallback_7() void {
    if (config.UART7.mode == .CPLT) {
        uart7.cpltCallbackHandler();
    }
}
export fn userUartRxCpltCallback_10() void {
    if (config.UART10.mode == .CPLT) {
        uart10.cpltCallbackHandler();
    }
}
