package logger

import (
	"context"
	stdlog "log"
	"os"
	"strings"
	"time"

	"github.com/Checkmarx/kics/internal/correlation"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/rs/zerolog/pkgerrors"
)

const (
	correlationIDLogField = "correlationId"

	AppNameFieldName   = "appName"
	levelFieldName     = "level"
	messageFieldName   = "msg"
	timestampFieldName = "time"
	timeFieldFormat    = time.RFC3339
	takeoverStd        = true
)

var (
	outputStream = os.Stdout // if you are using CLI please change this value to stderr
)

func InitLogger(logLevel, appName string) error {
	zeroLevel, err := zerolog.ParseLevel(strings.ToLower(logLevel))
	if err != nil {
		return err
	}
	zerolog.TimeFieldFormat = timeFieldFormat
	zerolog.LevelFieldName = levelFieldName
	zerolog.MessageFieldName = messageFieldName
	zerolog.TimestampFieldName = timestampFieldName
	zerolog.SetGlobalLevel(zeroLevel)

	zerolog.ErrorStackMarshaler = pkgerrors.MarshalStack

	log.Logger = zerolog.New(outputStream).With().
		Timestamp().                    // always add time
		Str(AppNameFieldName, appName). // always print app name
		Logger()

	// take over the default logger in case of use by 3rd-party libs
	if takeoverStd {
		stdlog.SetOutput(log.Logger)
	}

	return nil
}

func GetLoggerWithFieldsFromContext(ctx context.Context) *zerolog.Logger {
	corID := correlation.FromContext(ctx)
	return GetLoggerWithCorrelationID(corID)
}

func GetLoggerWithCorrelationID(correlationID string) *zerolog.Logger {
	l := log.With().
		Str(correlationIDLogField, correlationID).
		Logger()

	return &l
}
