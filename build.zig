const Builder = @import("std").build.Builder;
const std = @import("std");

fn createTest() void {}

pub fn build(b: *Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("init-exe", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    //exe.setLibCFile("libc");
    exe.linkLibC();
    exe.linkSystemLibraryName("DOtherSide");
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    var variantTests = b.addTest("src/QVariant.zig");
    variantTests.setTarget(target);
    variantTests.setBuildMode(mode);
    variantTests.linkLibC();
    variantTests.linkSystemLibraryName("DOtherSide");

    var urlTests = b.addTest("src/QUrl.zig");
    urlTests.setTarget(target);
    urlTests.setBuildMode(mode);
    urlTests.linkLibC();
    urlTests.linkSystemLibraryName("DOtherSide");

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&variantTests.step);
    test_step.dependOn(&urlTests.step);
}
