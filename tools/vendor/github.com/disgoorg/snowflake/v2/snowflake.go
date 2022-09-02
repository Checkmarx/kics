package snowflake

import (
	"bytes"
	"os"
	"strconv"
	"time"
)

// Epoch is the discord epoch in milliseconds.
const Epoch = 1420070400000

// Parse parses a string into a snowflake ID.
// returns ID(0) if the string is "null"
func Parse(str string) (ID, error) {
	if str == "null" {
		return 0, nil
	}
	id, err := strconv.ParseUint(str, 10, 64)
	if err != nil {
		return 0, err
	}
	return ID(id), nil
}

// MustParse parses a string into a snowflake ID and panics on error.
// returns ID(0) if the string is "null"
func MustParse(str string) ID {
	id, err := Parse(str)
	if err != nil {
		panic(err)
	}
	return id
}

// GetEnv returns the value of the environment variable named by the key and parses it as a snowflake.
// returns ID(0) if the environment variable is not set.
func GetEnv(key string) ID {
	snowflake, _ := LookupEnv(key)
	return snowflake
}

// LookupEnv returns the value of the environment variable named by the key and parses it as a snowflake.
// returns false if the environment variable is not set.
func LookupEnv(key string) (ID, bool) {
	env, found := os.LookupEnv(key)
	if !found {
		return 0, false
	}
	snowflake, _ := Parse(env)
	return snowflake, true
}

// New creates a new snowflake ID from the provided timestamp with worker id and sequence 0.
func New(timestamp time.Time) ID {
	return ID((timestamp.UnixMilli() - Epoch) << 22)
}

// ID represents a unique snowflake ID.
type ID uint64

// MarshalJSON marshals the snowflake ID into a JSON string.
func (id ID) MarshalJSON() ([]byte, error) {
	return []byte(strconv.Quote(strconv.FormatUint(uint64(id), 10))), nil
}

// UnmarshalJSON unmarshals the snowflake ID from a JSON string.
func (id *ID) UnmarshalJSON(data []byte) error {
	if bytes.Equal(data, []byte("null")) {
		return nil
	}
	snowflake, err := strconv.Unquote(string(data))
	if err != nil {
		return err
	}
	i, err := strconv.ParseUint(snowflake, 10, 64)
	if err != nil {
		return err
	}
	*id = ID(i)
	return nil
}

// String returns a string representation of the snowflake ID.
func (id ID) String() string {
	return strconv.FormatUint(uint64(id), 10)
}

// Time returns the time.Time the snowflake was created.
func (id ID) Time() time.Time {
	return time.UnixMilli(int64(id>>22 + Epoch))
}

// WorkerID returns the id of the worker the snowflake was created on.
func (id ID) WorkerID() uint8 {
	return uint8(id & 0x3E0000 >> 17)
}

func (id ID) ProcessID() uint8 {
	return uint8(id & 0x3E0000 >> 12)
}

// Sequence returns the sequence of the snowflake.
func (id ID) Sequence() uint16 {
	return uint16(id & 0xFFF)
}

// Deconstruct returns DeconstructedID (https://discord.com/developers/docs/reference#snowflakes-snowflake-id-format-structure-left-to-right).
func (id ID) Deconstruct() DeconstructedSnowflake {
	return DeconstructedSnowflake{
		Time:      id.Time(),
		WorkerID:  id.WorkerID(),
		ProcessID: id.ProcessID(),
		Sequence:  id.Sequence(),
	}
}

// DeconstructedSnowflake contains the properties used by Discord for each snowflake ID.
type DeconstructedSnowflake struct {
	Time      time.Time
	WorkerID  uint8
	ProcessID uint8
	Sequence  uint16
}
