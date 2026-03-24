const std = @import("std");

pub fn RingQueue(comptime T: type, comptime N: usize) type {
    comptime {
        if (N == 0) @compileError("RingQueue capacity N must be > 0");
    }

    return struct {
        const Self = @This();

        _buf: [N]T = undefined,
        _head: usize = 0,
        _tail: usize = 0,
        _size: usize = 0,

        pub fn isEmpty(self: *const Self) bool {
            return self._size == 0;
        }

        pub fn isFull(self: *const Self) bool {
            return self._size == N;
        }

        pub fn size(self: *const Self) usize {
            return self._size;
        }

        pub fn push(self: *Self, item: T) bool {
            if (self.isFull()) {
                return false;
            }

            self._buf[self._tail] = item;
            self._tail = (self._tail + 1) % N;
            self._size += 1;
            return true;
        }

        pub fn pushForce(self: *Self, item: T) void {
            if (self.isFull()) {
                self._buf[self._tail] = item;
                self._tail = (self._tail + 1) % N;
                self._head = (self._head + 1) % N;
                return;
            }

            self._buf[self._tail] = item;
            self._tail = (self._tail + 1) % N;
            self._size += 1;
        }

        pub fn pop(self: *Self) ?T {
            if (self.isEmpty()) {
                return null;
            }
            const v = self._buf[self._head];
            self._head = (self._head + 1) % N;
            self._size -= 1;
            return v;
        }

        pub fn back(self: *const Self) ?*const T {
            if (self.isEmpty()) {
                return null;
            }
            return &self._buf[(self._tail + N - 1) % N];
        }

        pub fn front(self: *const Self) ?*const T {
            if (self.isEmpty()) {
                return null;
            }
            return &self._buf[self._head];
        }

        pub fn backMut(self: *Self) ?*T {
            if (self.isEmpty()) {
                return null;
            }
            return &self._buf[(self._tail + N - 1) % N];
        }

        pub fn frontMut(self: *Self) ?*T {
            if (self.isEmpty()) {
                return null;
            }
            return &self._buf[self._head];
        }

        pub fn clear(self: *Self) void {
            self._size = 0;
            self._head = 0;
            self._tail = 0;
        }
    };
}
