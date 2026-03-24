const std = @import("std");
const board = @import("board.zig");
const driver = board.canDriver;
const RingQueue = @import("ring_queue.zig").RingQueue;
const config = @import("user_config.zig").CanConfig;

const Port = enum {
    CAN1,
    CAN2,
    CAN3,
};

fn driverInitFn(comptime port: Port) (fn (comptime []const u32) void) {
    const addFilter_base: (fn (u32) callconv(.c) void) = switch (port) {
        .CAN1 => driver.addFilter_1,
        .CAN2 => driver.addFilter_2,
        .CAN3 => driver.addFilter_3,
    };
    const start_base: (fn () callconv(.c) void) = switch (port) {
        .CAN1 => driver.start_1,
        .CAN2 => driver.start_2,
        .CAN3 => driver.start_3,
    };
    return struct {
        pub fn f(comptime id: []const u32) void {
            inline for (id) |v| {
                addFilter_base(v);
            }
            start_base();
        }
    }.f;
}

fn driverSendFn(comptime port: Port) (fn (u32, []const u8) void) {
    const f_base: (fn (u32, [*c]const u8, u32) callconv(.c) void) = switch (port) {
        .CAN1 => driver.send_1,
        .CAN2 => driver.send_2,
        .CAN3 => driver.send_3,
    };
    return struct {
        pub fn f(id: u32, data: []const u8) void {
            const n: usize = @min(data.len, 8);
            f_base(id, data.ptr, n);
        }
    }.f;
}

fn CanInstance(
    comptime port: Port,
    comptime txBufNum: usize,
    comptime rxBufNum: usize,
    comptime rx_ids: []const u32,
) type {
    return struct {
        const Self = @This();

        const driverInit = driverInitFn(port);
        const driverSend = driverSendFn(port);

        const TxMail = struct {
            id: u32 = 0,
            buf: [8]u8 = undefined,
            len: u32 = 0,
            pub fn slice(self: *const @This()) []const u8 {
                const n: usize = @intCast(@min(self.len, 8));
                return self.buf[0..n];
            }
        };
        const TxMailBox = RingQueue(TxMail, txBufNum);

        const RxMail = struct {
            buf: [8]u8 = undefined,
            len: u32 = 0,
        };
        const RxMailBox = RingQueue(RxMail, rxBufNum);

        fn RxMailBoxes(comptime cfg_ids: []const u32) type {
            return struct {
                boxes: [cfg_ids.len]RxMailBox = [_]RxMailBox{.{}} ** cfg_ids.len,

                pub fn at(self: *@This(), id: u32) ?*RxMailBox {
                    inline for (cfg_ids, 0..) |cfg_id, i| {
                        if (id == cfg_id) {
                            return &self.boxes[i];
                        }
                    }
                    return null;
                }
            };
        }

        _tx: TxMailBox = .{},
        _tx_mail: TxMail = .{},
        _rx: RxMailBoxes(rx_ids) = .{},

        pub fn init(self: *const Self) void {
            _ = self;
            driverInit(rx_ids);
        }

        pub fn write(self: *Self, id: u32, data: []const u8) void {
            const n: u32 = @intCast(@min(data.len, 8));
            var t: TxMail = .{
                .id = id,
                .len = n,
                .buf = undefined,
            };
            @memcpy(t.buf[0..n], data[0..n]);
            self._tx.pushForce(t);
        }

        pub fn read(self: *Self, id: u32) ?RxMail {
            if (self._rx.at(id)) |r| {
                return r.pop();
            } else {
                return null;
            }
        }

        pub fn sendLoop(self: *Self) void {
            self._tx_mail = self._tx.pop() orelse return;
            driverSend(self._tx_mail.id, self._tx_mail.slice());
        }

        fn callbackHandler(self: *Self, id: u32, len: u32, data: [*c]u8) void {
            const rx = self._rx.at(id) orelse return;
            const n: u32 = @min(len, 8);
            var r = RxMail{
                .len = n,
                .buf = undefined,
            };
            const n_u: usize = @intCast(n);
            @memcpy(r.buf[0..n_u], data[0..n_u]);
            rx.*.pushForce(r);
        }
    };
}

pub var can1 = CanInstance(
    .CAN1,
    config.CAN1.txBufNum,
    config.CAN1.rxBufNum,
    config.CAN1.rx_ids[0..],
){};
pub var can2 = CanInstance(
    .CAN2,
    config.CAN2.txBufNum,
    config.CAN2.rxBufNum,
    config.CAN2.rx_ids[0..],
){};
pub var can3 = CanInstance(
    .CAN3,
    config.CAN3.txBufNum,
    config.CAN3.rxBufNum,
    config.CAN3.rx_ids[0..],
){};

export fn userCanCallback_1(id: u32, len: u32, data: [*c]u8) void {
    can1.callbackHandler(id, len, data);
}

export fn userCanCallback_2(id: u32, len: u32, data: [*c]u8) void {
    can2.callbackHandler(id, len, data);
}

export fn userCanCallback_3(id: u32, len: u32, data: [*c]u8) void {
    can3.callbackHandler(id, len, data);
}
