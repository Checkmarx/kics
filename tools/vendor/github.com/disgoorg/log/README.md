[![Go Reference](https://pkg.go.dev/badge/github.com/disgoorg/log.svg)](https://pkg.go.dev/github.com/disgoorg/log)
[![Go Report](https://goreportcard.com/badge/github.com/disgoorg/log)](https://goreportcard.com/report/github.com/disgoorg/log)
[![Go Version](https://img.shields.io/github/go-mod/go-version/disgoorg/log)](https://golang.org/doc/devel/release.html)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/disgoorg/log/blob/master/LICENSE)
[![Disgo Version](https://img.shields.io/github/v/release/disgoorg/log)](https://github.com/disgoorg/disgologhook/releases/latest)
[![Disgo Discord](https://discord.com/api/guilds/817327181659111454/widget.png)](https://discord.gg/TewhTfDpvW)

# log

The `Logger` interface can be used instead to give the user choice over which logger they want use

This lib ships with a default implementation of the `Logger` interface

[SimpleLogger](https://github.com/disgoorg/log/blob/master/simple_logger.go) is a wrapped
standard [Logger](https://pkg.go.dev/log) to fit the `Logger` interface

You can use your own implementation or a library like [logrus](https://github.com/sirupsen/logrus)

### Installing

```sh
go get github.com/disgoorg/log
```

