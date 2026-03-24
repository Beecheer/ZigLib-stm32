const std = @import("std");

const board = @import("Generated/board_bindings.zig");
pub const init = board.boardInit;
pub const delay = board.boardDelay;

pub const dwt = struct {
    pub const init = board.boardDWTInit;
    pub const delayus = board.boardDWTDelayUs;
    pub const delayms = board.boardDWTDelayMs;
};

pub const led = struct {};

pub const ws2812 = struct {
    pub const init = board.boardWS2812Init;
    pub const writeByte = board.boardWS2812WriteByte;
};

pub const buzzer = struct {
    pub const start = board.boardBuzzerStart;
    pub const stop = board.boardBuzzerStop;
};

pub const uartDriver = struct {
    pub const send_1 = board.boardUartSend_1;
    pub const send_2 = board.boardUartSend_2;
    pub const send_3 = board.boardUartSend_3;
    pub const send_5 = board.boardUartSend_5;
    pub const send_7 = board.boardUartSend_7;
    pub const send_10 = board.boardUartSend_10;

    pub const receive_1 = board.boardUartReceiveDMA_1;
    pub const receive_2 = board.boardUartReceiveDMA_2;
    pub const receive_3 = board.boardUartReceiveDMA_3;
    pub const receive_5 = board.boardUartReceiveDMA_5;
    pub const receive_7 = board.boardUartReceiveDMA_7;
    pub const receive_10 = board.boardUartReceiveDMA_10;

    pub const receiveToIdle_1 = board.boardUartReceiveDMAtoIdle_1;
    pub const receiveToIdle_2 = board.boardUartReceiveDMAtoIdle_2;
    pub const receiveToIdle_3 = board.boardUartReceiveDMAtoIdle_3;
    pub const receiveToIdle_5 = board.boardUartReceiveDMAtoIdle_5;
    pub const receiveToIdle_7 = board.boardUartReceiveDMAtoIdle_7;
    pub const receiveToIdle_10 = board.boardUartReceiveDMAtoIdle_10;
};

pub const canDriver = struct {
    pub const addFilter_1 = board.boardCanAddFilter_1;
    pub const addFilter_2 = board.boardCanAddFilter_2;
    pub const addFilter_3 = board.boardCanAddFilter_3;

    pub const start_1 = board.boardCanStart_1;
    pub const start_2 = board.boardCanStart_2;
    pub const start_3 = board.boardCanStart_3;

    pub const send_1 = board.boardCanSend_1;
    pub const send_2 = board.boardCanSend_2;
    pub const send_3 = board.boardCanSend_3;
};
