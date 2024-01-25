package logger

import (
	consoleFlags "github.com/Checkmarx/kics/internal/console/flags"
	log "github.com/rs/zerolog"
	arroz "github.com/rs/zerolog/log"
	"io"
	"os"
)

type LogSink struct {
	logs []string
}

func NewLogger(logs *LogSink) log.Logger {
	if logs == nil {
		if !consoleFlags.GetBoolFlag(consoleFlags.VerboseFlag) {
			arroz.Debug().Msgf("aqui joao")
			return log.New(io.Discard).With().Timestamp().Logger()
		}
		arroz.Debug().Msgf("aqui joao 1234")
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
