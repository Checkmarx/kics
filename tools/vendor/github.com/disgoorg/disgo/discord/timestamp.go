package discord

import (
	"errors"
	"fmt"
	"strconv"
	"time"
)

// ErrNoTimestampMatch is returned when no valid Timestamp is found in the Message
var ErrNoTimestampMatch = errors.New("no matching timestamp found in string")

// TimestampStyle is used to determine how to display the Timestamp for the User in the client
type TimestampStyle string

const (
	// TimestampStyleNone formats as default
	TimestampStyleNone TimestampStyle = ""

	// TimestampStyleShortTime formats time as 16:20
	TimestampStyleShortTime TimestampStyle = "t"

	// TimestampStyleLongTime formats time as 16:20:30
	TimestampStyleLongTime TimestampStyle = "T"

	// TimestampStyleShortDate formats time as 20/04/2021
	TimestampStyleShortDate TimestampStyle = "d"

	// TimestampStyleLongDate formats time as 20 April 2021
	TimestampStyleLongDate TimestampStyle = "D"

	// TimestampStyleShortDateTime formats time as 20 April 2021 16:20
	TimestampStyleShortDateTime TimestampStyle = "f"

	// TimestampStyleLongDateTime formats time as Tuesday, 20 April 2021 16:20
	TimestampStyleLongDateTime TimestampStyle = "F"

	// TimestampStyleRelative formats time as 2 months ago
	TimestampStyleRelative TimestampStyle = "R"
)

// FormatTime returns the time.Time formatted as markdown string
func (f TimestampStyle) FormatTime(time time.Time) string {
	return f.Format(time.Unix())
}

// Format returns the seconds formatted as markdown string
func (f TimestampStyle) Format(seconds int64) string {
	if f == TimestampStyleNone {
		return TimestampMention(seconds)
	}
	return FormattedTimestampMention(seconds, f)
}

// ParseTimestamps parses all Timestamp(s) found in the provided string
func ParseTimestamps(str string, n int) ([]Timestamp, error) {
	matches := MentionTypeTimestamp.FindAllStringSubmatch(str, n)
	if matches == nil {
		return nil, ErrNoTimestampMatch
	}

	timestamps := make([]Timestamp, len(matches))
	for i, match := range matches {
		unix, _ := strconv.Atoi(match[1])

		style := TimestampStyleShortDateTime
		if len(match) > 2 {
			style = TimestampStyle(match[2])
		}

		timestamps[i] = NewTimestamp(style, time.Unix(int64(unix), 0))
	}

	return timestamps, nil
}

// ParseTimestamp parses the first Timestamp found in the provided string
func ParseTimestamp(str string) (*Timestamp, error) {
	timestamps, err := ParseTimestamps(str, 1)
	if err != nil {
		return nil, err
	}

	return &timestamps[0], nil
}

// NewTimestamp returns a new Timestamp with the given TimestampStyle & time.Time
func NewTimestamp(style TimestampStyle, time time.Time) Timestamp {
	return Timestamp{
		TimestampStyle: style,
		Time:           time,
	}
}

var _ fmt.Stringer = (*Timestamp)(nil)

// Timestamp represents a timestamp markdown object https://discord.com/developers/docs/reference#message-formatting
type Timestamp struct {
	time.Time
	TimestampStyle TimestampStyle
}

// String returns the Timestamp as markdown
func (t Timestamp) String() string {
	return t.Format()
}

// Format returns the Timestamp as markdown
func (t Timestamp) Format() string {
	return t.TimestampStyle.Format(t.Unix())
}

// FormatWith returns the Timestamp as markdown with the given TimestampStyle
func (t Timestamp) FormatWith(style TimestampStyle) string {
	return style.Format(t.Unix())
}
