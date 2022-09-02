# ctrlc

CTRL-C is a Go library that provides an easy way of having a task that
is context-aware and deals with SIGINT and SIGTERM signals.

## Usage

Check the [_examples](/_examples) folder.

You can run it like this:

```sh
$ go run _examples/main.go
# will fail because the last task returns an error

$ go run _examples/main.go -timeout 1s
# will fail due to context timeout

$ go run _examples/main.go
# press ctrl-c
# will cancel the context due to interrupt and error
```
