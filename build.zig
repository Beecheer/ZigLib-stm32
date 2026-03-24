const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});

    const target = b.resolveTargetQuery(.{
        .cpu_arch = .thumb,
        .os_tag = .freestanding,
        .abi = .eabihf,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m7 },
        .cpu_features_add = std.Target.arm.featureSet(&.{.fp_armv8d16sp}),
    });

    const name = "zig_lib";
    const root = "stm32_hal";
    const c_flags = &.{
        "-std=c11",
        "-ffunction-sections",
        "-fdata-sections",
        "-mcpu=cortex-m7",
        "-mthumb",
        "-mfloat-abi=hard",
        "-mfpu=fpv5-sp-d16",
    };
    const arm_gcc_path = "D:/MinGW/arm-gnu-toolchain-14.2.rel1-mingw-w64-i686-arm-none-eabi/bin";

    const module = b.addModule(name, .{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = false,
        .single_threaded = true,
        .sanitize_c = .off,
    });

    addNewlibNanoFromArmGcc(b, module, arm_gcc_path);

    addAllIncludeDirsFromDir(b, module, root ++ "/Core");
    addAllIncludeDirsFromDir(b, module, root ++ "/Drivers");
    addAllIncludeDirsFromDir(b, module, root ++ "/Middlewares");
    addAllIncludeDirsFromDir(b, module, root ++ "/USB_DEVICE");

    module.addCMacro("USE_FULL_LL_DRIVER", "");
    module.addCMacro("USE_PWR_LDO_SUPPLY", "");
    module.addCMacro("USE_HAL_DRIVER", "");
    module.addCMacro("STM32H723xx", "");
    module.addAssemblyFile(b.path("stm32_hal/Core/Startup/startup_stm32h723vgtx.s"));

    addAllCSourceFilesFromDir(b, module, root ++ "/Core", c_flags);
    addAllCSourceFilesFromDir(b, module, root ++ "/Drivers", c_flags);
    addAllCSourceFilesFromDir(b, module, root ++ "/Middlewares", c_flags);
    addAllCSourceFilesFromDir(b, module, root ++ "/USB_DEVICE", c_flags);

    addAllIncludeDirsFromDir(b, module, "wrappers");
    addAllCSourceFilesFromDir(b, module, "wrappers", c_flags);
    module.addObjectFile(b.path("stm32_hal/Middlewares/ST/ARM/DSP/Lib/libarm_cortexM7lfsp_math.a"));

    const exe = b.addExecutable(.{
        .name = b.fmt("{s}.elf", .{name}),
        .root_module = module,
        .linkage = .static,
    });

    exe.setLinkerScript(b.path("stm32_hal/STM32H723VGTX_FLASH.ld"));
    exe.link_gc_sections = true;
    exe.link_function_sections = true;
    exe.link_data_sections = true;

    b.installArtifact(exe);

    // ------------------------------ generate c bindings ------------------------------------
    const board_trans = b.addTranslateC(.{
        .root_source_file = b.path("wrappers/board.h"),
        .target = target,
        .optimize = optimize,
        .link_libc = false,
    });
    board_trans.addIncludePath(.{ .cwd_relative = "wrappers" });
    const install_board_bindings = b.addInstallFile(
        board_trans.getOutput(),
        "../src/Generated/board_bindings.zig",
    );
    const board_bindings_step = b.step("bindings", "Generate Zig bindings for wrappers/board.h");
    board_bindings_step.dependOn(&install_board_bindings.step);

    // ------------------------------ generate bin and hex --------------------
    const bin = b.addObjCopy(exe.getEmittedBin(), .{
        .format = .bin,
    });
    const install_bin = b.addInstallFile(bin.getOutput(), b.fmt("{s}.bin", .{name}));

    const bin_step = b.step("bin", "Generate .bin");
    bin_step.dependOn(&install_bin.step);

    const hex = b.addObjCopy(exe.getEmittedBin(), .{
        .format = .hex,
    });
    const install_hex = b.addInstallFile(hex.getOutput(), b.fmt("{s}.hex", .{name}));

    const hex_step = b.step("hex", "Generate .hex");
    hex_step.dependOn(&install_hex.step);

    // ------------------------------ show size --------------------------------
    const arm_size = b.findProgram(&.{"arm-none-eabi-size"}, &.{arm_gcc_path}) catch
        b.findProgram(&.{"arm-none-eabi-size"}, &.{}) catch
        @panic("arm-none-eabi-size not found");

    const size_cmd = b.addSystemCommand(&.{
        arm_size,
        "--format=berkeley",
        "-A",
    });
    size_cmd.addArtifactArg(exe);
    const size_step = b.step("size", "Show firmware size");
    size_step.dependOn(&size_cmd.step);

    // ------------------------------- openocd flash --------------------------------------
    const openocd = b.findProgram(&.{"openocd"}, &.{}) catch
        @panic("openocd not found");

    const flash_cmd = b.addSystemCommand(&.{
        openocd,
        "-s",
        "D:/OpenOCD/OpenOCD-20240916-0.12.0/share/openocd/scripts",
        "-f",
        "daplink.cfg",
        "-c",
        "tcl_port disabled",
        "-c",
        "gdb_port disabled",
        "-c",
        "tcl_port disabled",
        "-c",
        b.fmt("program zig-out/bin/{s}.elf", .{name}),
        "-c",
        "reset",
        "-c",
        "shutdown",
    });
    flash_cmd.step.dependOn(&exe.step);

    const flash_step = b.step("flash", "Flash firmware with OpenOCD");
    flash_step.dependOn(&flash_cmd.step);
}

fn addAllIncludeDirsFromDir(
    b: *std.Build,
    m: *std.Build.Module,
    dir_path: []const u8,
) void {
    const io = b.graph.io;

    var dir = std.Io.Dir.cwd().openDir(io, dir_path, .{ .iterate = true }) catch @panic("cannot open include root");
    defer dir.close(io);

    var walker = dir.walk(b.allocator) catch @panic("walk include dirs OOM");
    defer walker.deinit();

    m.addIncludePath(.{ .cwd_relative = dir_path });

    while (walker.next(io) catch @panic("walk include dirs failed")) |entry| {
        if (entry.kind != .directory) continue;

        const full = b.fmt("{s}/{s}", .{ dir_path, entry.path });
        m.addIncludePath(.{ .cwd_relative = full });
    }
}

fn addAllCSourceFilesFromDir(
    b: *std.Build,
    m: *std.Build.Module,
    dir_path: []const u8,
    flags: []const []const u8,
) void {
    const io = b.graph.io;

    var dir = std.Io.Dir.cwd().openDir(io, dir_path, .{ .iterate = true }) catch
        @panic("open source dir failed");
    defer dir.close(io);

    var walker = dir.walk(b.allocator) catch
        @panic("walk source dirs OOM");
    defer walker.deinit();

    var files = std.ArrayList([]const u8).initCapacity(b.allocator, 256) catch @panic("init source files array failed");
    defer files.deinit(b.allocator);

    while (walker.next(io) catch @panic("walk source dirs failed")) |entry| {
        if (entry.kind != .file) continue;
        if (!std.mem.endsWith(u8, entry.basename, ".c")) continue;

        const full = b.fmt("{s}/{s}", .{ dir_path, entry.path });
        files.append(b.allocator, full) catch @panic("append source file failed");
    }

    if (files.items.len > 0) {
        m.addCSourceFiles(.{
            .files = files.items,
            .flags = flags,
        });
    }
}

fn addNewlibNanoFromArmGcc(b: *std.Build, m: *std.Build.Module, arm_gcc_hint: []const u8) void {
    const arm_gcc = b.findProgram(&.{"arm-none-eabi-gcc"}, &.{arm_gcc_hint}) catch
        b.findProgram(&.{"arm-none-eabi-gcc"}, &.{}) catch
        @panic("arm-none-eabi-gcc not found");

    const sysroot = std.mem.trim(u8, b.run(&.{ arm_gcc, "-print-sysroot" }), "\r\n");
    const multidir = std.mem.trim(u8, b.run(&.{
        arm_gcc,
        "-mcpu=cortex-m7",
        "-mfpu=fpv5-sp-d16",
        "-mfloat-abi=hard",
        "-print-multi-directory",
    }), "\r\n");

    const ver = std.mem.trim(u8, b.run(&.{ arm_gcc, "-dumpversion" }), "\r\n");

    const libgcc_path = b.fmt("{s}/../lib/gcc/arm-none-eabi/{s}/{s}", .{ sysroot, ver, multidir });
    const newlib_path = b.fmt("{s}/lib/{s}", .{ sysroot, multidir });

    m.addLibraryPath(.{ .cwd_relative = libgcc_path });
    m.addLibraryPath(.{ .cwd_relative = newlib_path });
    m.addSystemIncludePath(.{ .cwd_relative = b.fmt("{s}/include", .{sysroot}) });

    m.linkSystemLibrary("c_nano", .{
        .needed = true,
        .preferred_link_mode = .static,
        .use_pkg_config = .no,
    });
    m.linkSystemLibrary("m", .{
        .needed = true,
        .preferred_link_mode = .static,
        .use_pkg_config = .no,
    });
}
