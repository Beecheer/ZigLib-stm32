pub const UartConfig = struct {
    pub const Mode = enum {
        CPLT,
        IDLE,
    };

    pub const UART1 = struct {
        pub const mode: Mode = .IDLE;
        pub const bufSize: usize = 64;
        pub const txBufNum: usize = 4;
        pub const rxBufNum: usize = 4;
    };
    pub const UART2 = struct {
        pub const mode: Mode = .IDLE;
        pub const bufSize: usize = 1;
        pub const txBufNum: usize = 1;
        pub const rxBufNum: usize = 1;
    };
    pub const UART3 = struct {
        pub const mode: Mode = .IDLE;
        pub const bufSize: usize = 1;
        pub const txBufNum: usize = 1;
        pub const rxBufNum: usize = 1;
    };
    pub const UART5 = struct {
        pub const mode: Mode = .IDLE;
        pub const bufSize: usize = 1;
        pub const txBufNum: usize = 1;
        pub const rxBufNum: usize = 1;
    };
    pub const UART7 = struct {
        pub const mode: Mode = .IDLE;
        pub const bufSize: usize = 1;
        pub const txBufNum: usize = 1;
        pub const rxBufNum: usize = 1;
    };
    pub const UART10 = struct {
        pub const mode: Mode = .IDLE;
        pub const bufSize: usize = 1;
        pub const txBufNum: usize = 1;
        pub const rxBufNum: usize = 1;
    };
};

pub const CanConfig = struct {
    pub const CAN1 = struct {
        pub const txBufNum: usize = 16;
        pub const rxBufNum: usize = 4;
        pub const rx_ids = [_]u32{ 0x001, 0x002, 0x003, 0x004,0x05,0x006,0x007 };
    };
    pub const CAN2 = struct {
        pub const txBufNum: usize = 16;
        pub const rxBufNum: usize = 4;
        pub const rx_ids = [_]u32{ 0x001, 0x002, 0x003, 0x004 };
    };
    pub const CAN3 = struct {
        pub const txBufNum: usize = 16;
        pub const rxBufNum: usize = 4;
        pub const rx_ids = [_]u32{ 0x001, 0x002, 0x003, 0x004 };
    };
};
