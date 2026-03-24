const std = @import("std");
const driver = @import("board.zig").ws2812;

fn clamp01(x: f32) f32 {
    return if (x < 0.0) 0.0 else if (x > 1.0) 1.0 else x;
}

fn clampU8FromFloat01(x: f32) u8 {
    // x in [0,1] -> [0,255]
    const v = x * 255.0;
    const r = if (v < 0.0) 0.0 else if (v > 255.0) 255.0 else v;
    return @intFromFloat(@round(r));
}

const ColorRGB = struct {
    const Self = @This();

    r: u8,
    g: u8,
    b: u8,

    pub fn castToHSV(self: *const Self) ColorHSV {
        const rf: f32 = @as(f32, self.r) / 255.0;
        const gf: f32 = @as(f32, self.g) / 255.0;
        const bf: f32 = @as(f32, self.b) / 255.0;

        const maxv = @max(rf, @max(gf, bf));
        const minv = @min(rf, @min(gf, bf));
        const delta = maxv - minv;

        var h: f32 = 0.0;
        const v: f32 = maxv;

        const s: f32 = if (maxv == 0.0) 0.0 else (delta / maxv);

        if (delta == 0.0) {
            // 无色相（灰度）
            h = 0.0;
        } else if (maxv == rf) {
            h = 60.0 * (@mod(((gf - bf) / delta), 6.0));
        } else if (maxv == gf) {
            h = 60.0 * (((bf - rf) / delta) + 2.0);
        } else { // maxv == bf
            h = 60.0 * (((rf - gf) / delta) + 4.0);
        }

        if (h < 0.0) h += 360.0;
        if (h >= 360.0) h = @mod(h, 360.0);

        return .{ .h = h, .s = clamp01(s), .v = clamp01(v) };
    }
};

const ColorHSV = struct {
    const Self = @This();

    h: f32,
    s: f32,
    v: f32,

    pub fn castToRGB(self: *const Self) ColorRGB {
        var h = self.h;
        // 规范化 h 到 [0, 360)
        while (h < 0.0) h += 360.0;
        while (h >= 360.0) h -= 360.0;

        const s = clamp01(self.s);
        const v = clamp01(self.v);

        // 灰度：s=0
        if (s == 0.0) {
            const g = clampU8FromFloat01(v);
            return .{ .r = g, .g = g, .b = g };
        }

        h /= 60.0;
        const f = h - @floor(h);
        const p = v * (1.0 - s);
        const q = v * (1.0 - s * f);
        const t = v * (1.0 - s * (1.0 - f));

        var rp: f32 = 0.0;
        var gp: f32 = 0.0;
        var bp: f32 = 0.0;

        // 分扇区
        if (h < 1.0) {
            rp = v;
            gp = t;
            bp = p;
        } else if (h < 2.0) {
            rp = q;
            gp = v;
            bp = p;
        } else if (h < 3.0) {
            rp = p;
            gp = v;
            bp = t;
        } else if (h < 4.0) {
            rp = p;
            gp = q;
            bp = v;
        } else if (h < 5.0) {
            rp = t;
            gp = p;
            bp = v;
        } else {
            rp = v;
            gp = p;
            bp = q;
        }

        const r = clampU8FromFloat01(rp);
        const g = clampU8FromFloat01(gp);
        const b = clampU8FromFloat01(bp);

        return .{ .r = r, .g = g, .b = b };
    }
};

const WS2812_HIGH_LEVEL = 0xF0;
const WS2812_LOW_LEVEL = 0xC0;
const WS2812_VALUE = 0.1;
var rgb: ColorRGB = .{
    .r = 0,
    .g = 0,
    .b = 0,
};
var hsv: ColorHSV = .{
    .h = 0,
    .s = 1.0,
    .v = WS2812_VALUE,
};
const rst = [_]u8{0};
var buf: [24]u8 = .{0} ** 24;
const end = [_]u8{0} ** 100;

fn sendFrame(frame: []const u8) void {
    for (frame) |data| {
        driver.writeByte(data);
    }
}

fn control() void {
    for (0..8) |i| {
        buf[7 - i] = if (((rgb.g >> @intCast(i)) & 0x01) != 0) WS2812_HIGH_LEVEL else WS2812_LOW_LEVEL;
        buf[15 - i] = if (((rgb.r >> @intCast(i)) & 0x01) != 0) WS2812_HIGH_LEVEL else WS2812_LOW_LEVEL;
        buf[23 - i] = if (((rgb.b >> @intCast(i)) & 0x01) != 0) WS2812_HIGH_LEVEL else WS2812_LOW_LEVEL;
    }
    sendFrame(rst[0..]);
    sendFrame(buf[0..]);
    sendFrame(end[0..]);
}

pub fn init() void {
    driver.init();
}

pub fn loop() void {
    rgb = hsv.castToRGB();
    control();
    hsv.h += 2.0;
    if (hsv.h >= 360.0) hsv.h = 0.0;
}
