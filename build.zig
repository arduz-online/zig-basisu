const std = @import("std");
const Build = std.Build;

pub fn build(b: *Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const module = b.addModule("zig-basisu", .{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addLibrary(.{
        .name = "zig-basisu",
        .root_module = module,
    });

    lib.linkLibCpp();
    module.addCSourceFiles(.{ .files = &.{
        "src/encoder/wrapper.cpp",
        "src/transcoder/wrapper.cpp",
    }, .flags = &.{} });
    lib.linkLibrary(
        b.dependency("basisu", .{
            .target = target,
            .optimize = optimize,
        }).artifact("basisu"),
    );
    b.installArtifact(lib);

    //module.linkLibrary(lib);

    const test_exe = b.addTest(.{
        .root_module = module,
    });

    //test_exe.linkLibrary(lib);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&b.addRunArtifact(test_exe).step);
}
