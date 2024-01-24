package logger

import (
	"github.com/rs/zerolog"
	"os"
)

type LogSink struct {
	logs []string
}

func NewLogger(logs *LogSink) zerolog.Logger {
	if logs == nil {
		return zerolog.New(os.Stdout).With().Timestamp().Logger().Output(zerolog.ConsoleWriter{Out: os.Stderr})
	}
	return zerolog.New(logs)
}

func (l *LogSink) Write(p []byte) (n int, err error) {
	l.logs = append(l.logs, string(p))
	return len(p), nil
}

func (l *LogSink) Index(i int) string {
	return l.logs[i]
}
