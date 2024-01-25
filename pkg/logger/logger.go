package logger

import (
	"io"
	"os"

	consoleFlags "github.com/Checkmarx/kics/internal/console/flags"
	log "github.com/rs/zerolog"
)

type LogSink struct {
	logs []string
}

func NewLogger(logs *LogSink) log.Logger {
	if logs == nil {
		if !consoleFlags.GetBoolFlag(consoleFlags.VerboseFlag) {
			return log.New(io.Discard).With().Timestamp().Logger()
		}
		return log.New(os.Stderr).With().Timestamp().Logger().Output(log.ConsoleWriter{Out: os.Stderr})
	}
	return log.New(logs)
}

func (l *LogSink) Write(p []byte) (n int, err error) {
	l.logs = append(l.logs, string(p))
	return len(p), nil
}

func (l *LogSink) Index(i int) string {
	return l.logs[i]
}
