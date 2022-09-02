def _pkg_tar2rpm_impl(ctx):
    files = [ctx.file.data]
    args = ctx.actions.args()
    args.add("--name", ctx.attr.pkg_name)
    args.add("--version", ctx.attr.version)
    args.add("--release", ctx.attr.release)
    args.add("--arch", ctx.attr.arch)
    args.add("--packager", ctx.attr.packager)
    args.add("--epoch", ctx.attr.epoch)
    args.add("--prein", ctx.attr.prein)
    args.add("--postin", ctx.attr.postin)
    args.add("--preun", ctx.attr.preun)
    args.add("--postun", ctx.attr.postun)
    args.add_all("--requires", ctx.attr.requires)
    if ctx.attr.build_time != "":
        args.add("--build_time", ctx.attr.build_time)
    if ctx.attr.use_dir_allowlist:
        args.add("--use_dir_allowlist")
    if ctx.file.dir_allowlist_file:
        args.add("--dir_allowlist_file", ctx.file.dir_allowlist_file)
        files.append(ctx.file.dir_allowlist_file)
    args.add("--file", ctx.outputs.out)
    args.add(ctx.file.data)
    ctx.actions.run(
        executable = ctx.executable.tar2rpm,
        arguments = [args],
        inputs = files,
        outputs = [ctx.outputs.out],
        mnemonic = "tar2rpm",
    )

# A rule for generating rpm files
pkg_tar2rpm = rule(
    implementation = _pkg_tar2rpm_impl,
    attrs = {
        "data": attr.label(mandatory = True, allow_single_file = [".tar"]),
        "pkg_name": attr.string(mandatory = True),
        "version": attr.string(mandatory = True),
        "release": attr.string(),
        "arch": attr.string(),
        "packager": attr.string(),
        "epoch": attr.int(),
        "prein": attr.string(),
        "postin": attr.string(),
        "preun": attr.string(),
        "postun": attr.string(),
        "requires": attr.string_list(),
        "build_time": attr.string(),
        "use_dir_allowlist": attr.bool(default = False, doc = """Only include
directories themselves if they are in the allowlist file. Using this without an allowlist means do not include directories at all, only files."""),
        "dir_allowlist_file": attr.label(allow_single_file = True, doc = "A file with a list of directories to include in the rpm. The files contained in the directories are always added."),
        "tar2rpm": attr.label(
            default = Label("//cmd/tar2rpm"),
            cfg = "host",
            executable = True,
        ),
    },
    outputs = {
        "out": "%{name}.rpm",
    },
)
