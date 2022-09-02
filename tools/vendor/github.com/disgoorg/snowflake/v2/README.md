[![Go Reference](https://pkg.go.dev/badge/github.com/disgoorg/snowflake.svg)](https://pkg.go.dev/github.com/disgoorg/disgo)
[![Go Version](https://img.shields.io/github/go-mod/go-version/disgoorg/snowflake)](https://golang.org/doc/devel/release.html)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/disgoorg/disgo/blob/master/LICENSE)
[![Disgo Version](https://img.shields.io/github/v/tag/disgoorg/snowflake?label=release)](https://github.com/disgoorg/snowflake/releases/latest)
[![Disgo Discord](https://discord.com/api/guilds/817327181659111454/widget.png)](https://discord.gg/TewhTfDpvW)

# snowflake

snowflake is a golang library for parsing [snowflake IDs](https://docs.snowflake.com) from discord.
This package provides a custom `snowflake.ID` type which has various utility methods for parsing discord snowflakes.

### Installing

```sh
go get github.com/disgoorg/snowflake/v2
```

## Usage

```go

id := snowflake.ID(123456789012345678)

// deconstructs the snowflake ID into its components timestamp, worker ID, process ID, and increment
id.Deconstruct()

// the time.Time when the snowflake ID was generated
id.Time()

// the worker ID which the snowflake ID was generated
id.WorkerID()

// the process ID which the snowflake ID was generated
id.ProcessID()

// tje sequence when the snowflake ID was generated
id.Sequence()

// returns the string representation of the snowflake ID
id.String()

// returns a new snowflake ID with worker ID, process ID, and sequence set to 0
// this can be used for various pagination requests to the discord api
id := New(time.Now())

// returns a snowflake ID from an environment variable
id := GetEnv("guild_id")

// returns a snowflake ID from an environment variable and a bool indicating if the key was found
id, found := LookupEnv("guild_id")

// returns the string as a snowflake ID or an error
id, err := Parse("123456789012345678")

// returns the string as a snowflake ID or panics if an error occurs
id := MustParse("123456789012345678")
```

## License

Distributed under the [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/disgoorg/snowflake/blob/master/LICENSE). See LICENSE for more information.
