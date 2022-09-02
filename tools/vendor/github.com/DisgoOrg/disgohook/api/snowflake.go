package api

import (
	"fmt"
	"strconv"
	"time"
)

var discordEpoch int64 = 1420070400000

// Snowflake is a general utility class around discord's IDs
type Snowflake string

// DeconstructedSnowflake contains the properties used by Discord for each ID
type DeconstructedSnowflake struct {
	Timestamp int64
	WorkerID  int64
	ProcessID int64
	Increment int64
	Binary    string
}

func (s Snowflake) String() string {
	return string(s)
}

// Binary converts the snowflake to binary
func (s Snowflake) Binary() string {
	i, err := strconv.ParseInt(s.String(), 10, 64)
	if err != nil {
		panic(err)
	}
	b := strconv.FormatInt(i, 2)
	return fmt.Sprintf("%064s", b)
}

// Deconstruct returns DeconstructedSnowflake
func (s Snowflake) Deconstruct() DeconstructedSnowflake {
	binary := s.Binary()
	t, _ := strconv.ParseInt(binary[0:42], 2, 64)
	w, _ := strconv.ParseInt(binary[42:47], 2, 64)
	p, _ := strconv.ParseInt(binary[47:52], 2, 64)
	i, _ := strconv.ParseInt(binary[52:64], 2, 64)
	return DeconstructedSnowflake{
		Timestamp: t + discordEpoch,
		WorkerID:  w,
		ProcessID: p,
		Increment: i,
		Binary:    binary,
	}
}

// Timestamp returns a Time value of the snowflake
func (s Snowflake) Timestamp() time.Time {
	t := s.Deconstruct().Timestamp
	return time.Unix(0, t*1000000)
}
