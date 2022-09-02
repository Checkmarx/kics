# Contributing

By participating to this project, you agree to abide our [code of conduct](https://github.com/goreleaser/nfpm/blob/main/CODE_OF_CONDUCT.md).

## Setup your machine

`nfpm` is written in [Go](https://golang.org/).

Prerequisites:

- [Task](https://taskfile.dev/#/installation)
- [Go 1.18+](https://golang.org/doc/install)
- [Docker](https://www.docker.com/)
- `gpg` (probably already installed on your system)

Clone `nfpm` from source:

```sh
git clone git@github.com:goreleaser/nfpm.git
cd nfpm
```

Install the build and lint dependencies:

```console
task setup
```

A good way of making sure everything is all right is running the test suite:

```console
task test
```

If on the ARM tests you are seeing `standard_init_linux.go:211: exec user process caused "exec format error"`:

```console
sudo docker run --rm --privileged hypriot/qemu-register
```

## Test your change

You can create a branch for your changes and try to build from the source as you go:

```console
task build
```

When you are satisfied with the changes, we suggest you run:

```console
task ci
```

Which runs all the linters and tests.

## Create a commit

Commit messages should be well formatted.
Start your commit message with the type. Choose one of the following:
`feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `revert`, `add`, `remove`, `move`, `bump`, `update`, `release`

After a colon, you should give the message a title, starting with uppercase and ending without a dot.
Keep the width of the text at 72 chars.
The title must be followed with a newline, then a more detailed description.

Please reference any GitHub issues on the last line of the commit message (e.g. `See #123`, `Closes #123`, `Fixes #123`).

An example:

```
docs: Add example for --release-notes flag

I added an example to the docs of the `--release-notes` flag to make
the usage more clear.  The example is a realistic use case and might
help others to generate their own changelog.

See #284
```

## Submit a pull request

Push your branch to your `nfpm` fork and open a pull request against the main branch.

## Financial contributions

We also welcome financial contributions in full transparency on our [open collective](https://opencollective.com/goreleaser).
Anyone can file an expense. If the expense makes sense for the development of the community, it will be "merged" in the ledger of our open collective by the core contributors and the person who filed the expense will be reimbursed.
