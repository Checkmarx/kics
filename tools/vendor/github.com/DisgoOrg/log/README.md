# log

[![Go Reference](https://pkg.go.dev/badge/github.com/DisgoOrg/log.svg)](https://pkg.go.dev/github.com/DisgoOrg/log)
[![Go Report](https://goreportcard.com/badge/github.com/DisgoOrg/log)](https://goreportcard.com/report/github.com/DisgoOrg/log)
[![Go Version](https://img.shields.io/github/go-mod/go-version/DisgoOrg/log)](https://golang.org/doc/devel/release.html)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/DisgoOrg/log/blob/master/LICENSE)
[![Disgo Version](https://img.shields.io/github/v/release/DisgoOrg/log)](https://github.com/DisgoOrg/disgologhook/releases/latest)
[![Disgo Discord](https://img.shields.io/badge/Disgo%20Discord-blue.svg)](https://discord.gg/zQ4u3CdU3J)

The `Logger` interface can be used instead to give the user choice over which logger they want use

This lib ships with a default implementation of the `Logger` interface

[SimpleLogger](https://github.com/DisgoOrg/log/blob/master/simple_logger.go) is a wrapped
standard [Logger](https://pkg.go.dev/log) to fit the `Logger` interface

You can use your own implementation or a library like [logrus](https://github.com/sirupsen/logrus)

### Installing

```sh
go get github.com/DisgoOrg/log
```

