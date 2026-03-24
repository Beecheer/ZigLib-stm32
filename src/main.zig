const std = @import("std");
const board = @import("board.zig");
const ws2812 = @import("ws2812.zig");
const uart = @import("comm_uart.zig");
const can = @import("comm_can.zig");

export fn main() callconv(.c) void {
    board.init();
    board.dwt.init();
    ws2812.init();
    can.can1.init();

    // board.buzzer.start(4000);
    // board.delay(500);
    // board.buzzer.stop();

    uart.uart1.init();
    uart.uart1.write("hello world!\r\n");
    uart.uart1.write("hello world!\r\n");
    uart.uart1.write("hello world!\r\n");
    uart.uart1.write("hello world!\r\n");
    uart.uart1.write("hello world!\r\n");
    uart.uart1.write("hello world!\r\n");

    can.can1.write(0x01, &.{ 0x01, 0x01, 0x04 });
    can.can1.write(0x02, &.{ 0x01, 0x01, 0x04, 0x05 });
    can.can1.write(0x03, &.{ 0x01, 0x01, 0x04, 0x05, 0x01 });
    can.can1.write(0x04, &.{ 0x01, 0x01, 0x04, 0x05, 0x01, 0x04 });
    board.delay(300);

    while (true) {
        if (uart.uart1.read()) |data| {
            uart.uart1.write(data.slice());
        }

        if (can.can1.read(0x02)) |m| {
            can.can1.write(0x12, m.buf[0..@intCast(m.len)]);
        }

        uart.uart1.sendLoop();
        can.can1.sendLoop();
        ws2812.loop();

        board.dwt.delayms(10);
    }

    unreachable;
}
