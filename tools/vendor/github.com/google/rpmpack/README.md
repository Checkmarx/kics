# rpmpack (tar2rpm) - package rpms the easy way

## Disclaimer

This is not an official Google product, it is just code that happens to be owned
by Google.

## Overview

`tar2rpm` is a tool that takes a tar and outputs an rpm. `rpmpack` is a golang library to create rpms. Both are written in pure go, without using rpmbuild or spec files. API documentation for `rpmpack` can be found in [![GoDoc](https://godoc.org/github.com/google/rpmpack?status.svg)](https://godoc.org/github.com/google/rpmpack).

## Installation

```bash
$ go get -u github.com/google/rpmpack/...
```

This will make the `tar2rpm` tool available in `${GOPATH}/bin`, which by default means `~/go/bin`.

## Usage of the binary (tar2rpm)

`tar2rpm` takes a `tar` file (from `stdin` or a specified filename), and outputs an `rpm`.

```
Usage:
  tar2rpm [OPTION] [FILE]
Options:
  -file FILE
        write rpm to FILE instead of stdout
  -name string
        the package name
  -release string
        the rpm release
  -version string
        the package version
```

## Usage of the library (rpmpack)

API documentation for `rpmpack` can be found in [![GoDoc](https://godoc.org/github.com/google/rpmpack?status.svg)](https://godoc.org/github.com/google/rpmpack).

```go
import "github.com/google/rpmpack"
...
r, err := rpmpack.NewRPM(rpmpack.RPMMetaData{Name: "example", Version: "3"})
if err != nil {
  ...
}
r.AddFile(rpmpack.RPMFile{
    Name: "/usr/local/hello",
    Body: []byte("content of the file"),
})
if err := r.Write(w); err != nil {
  ...
}
```

## Usage in the bazel build system (pkg_tar2rpm)

There is a working example inside [example_bazel](example_bazel/)

In `WORKSPACE`
```
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
git_repository(
    name = "rpmpack",
    remote = "https://github.com/google/rpmpack.git",
   branch = "master",
)

# The following will load the requirements to build rpmpack
http_archive(
    name = "io_bazel_rules_go",
    sha256 = "69de5c704a05ff37862f7e0f5534d4f479418afc21806c887db544a316f3cb6b",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.27.0/rules_go-v0.27.0.tar.gz",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.27.0/rules_go-v0.27.0.tar.gz",
    ],
)

http_archive(
    name = "bazel_gazelle",
    sha256 = "62ca106be173579c0a167deb23358fdfe71ffa1e4cfdddf5582af26520f1c66f",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.23.0/bazel-gazelle-v0.23.0.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.23.0/bazel-gazelle-v0.23.0.tar.gz",
    ],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

go_rules_dependencies()

go_register_toolchains(version = "1.16")

gazelle_dependencies()

load("@com_github_google_rpmpack//:deps.bzl", "rpmpack_dependencies")

rpmpack_dependencies()
```

In `BUILD` or `BUILD.bazel`
```
load("@bazel_tools//tools/build_defs/pkg:pkg.bzl", "pkg_tar")
load("@com_github_google_rpmpack//:def.bzl", "pkg_tar2rpm")

pkg_tar(
    name = "rpmtest-tar",
    srcs = [":content1.txt"],
    mode = "0644",
    ownername = "root.root",
    package_dir = "var/lib/rpmpack",
)

pkg_tar2rpm(
    name = "rpmtest",
    data = ":rpmtest-tar",
    pkg_name = "rpmtest",
    release = "3.4",
    version = "1.2",
    prein = "echo \"This is preinst\" > /tmp/preinst.txt",
)
```


## Features

 - You put files into the rpm, so that rpm/yum will install them on a host.
 - Simple.
 - No `spec` files.
 - Does not build anything.
 - Does not try to auto-detect dependencies.
 - Does not try to magically deduce on which computer architecture you run.
 - Does not require any rpm database or other state, and does not use the
   filesystem.

## Downsides

 - Is not related to the team the builds rpmlib.
 - May easily wreak havoc on rpm based systems. It is surprisingly easy to cause
   rpm to segfault on corrupt rpm files.
 - Many features are missing.
 - All of the artifacts are stored in memory, sometimes more than once.
 - Less backwards compatible than `rpmbuild`.

## Philosophy

Sometimes you just want files to make it to hosts, and be managed by the package
manager. `rpmbuild` can use a `spec` file, together with a specific directory
layout and local database, to build/install/package your files. But you don't
need all that. You want something similar to tar.

As the project progresses, we must maintain the complexity/value ratio. This
includes both code complexity and interface complexity.

## Disclaimer

This is not an official Google product, it is just code that happens to be owned
by Google.
