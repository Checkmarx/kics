package logger_test

import (
	"bytes"
	"context"
	"testing"

	"github.com/checkmarxDev/ice/internal/correlation"
	"github.com/checkmarxDev/ice/internal/logger"
	"github.com/stretchr/testify/assert"
)

const (
	loggerCorIDField = "correlationId"
)

func TestGetLoggerWithCorrelationID(t *testing.T) {
	buf := &bytes.Buffer{}

	corIDValue := "corID"
	logWithCorrID := logger.GetLoggerWithCorrelationID(corIDValue)

	lt := logWithCorrID.Output(buf)
	lt.Log().Msg("Test")
	logOut := buf.String()
	assert.Contains(t, logOut, loggerCorIDField)
	assert.Contains(t, logOut, corIDValue)
}

func TestGetLoggerWithFieldsFromContext(t *testing.T) {
	buf := &bytes.Buffer{}

	corIDValue := "contextCorIDValue"
	ctxWithCorrID := context.WithValue(context.Background(), correlation.ContextField, corIDValue)
	logWithCorrID := logger.GetLoggerWithFieldsFromContext(ctxWithCorrID)

	lt := logWithCorrID.Output(buf)
	lt.Log().Msg("Test")
	logOut := buf.String()
	assert.Contains(t, logOut, loggerCorIDField)
	assert.Contains(t, logOut, corIDValue)

	buf.Reset()

	logWithoutCorrID := logger.GetLoggerWithFieldsFromContext(context.Background())
	lt = logWithCorrID.Output(logWithoutCorrID)
	lt.Log().Msg("Test")
	logOut = buf.String()
	assert.NotContains(t, logOut, loggerCorIDField)
}

func TestInitLogger(t *testing.T) {
	type args struct {
		logLevel string
		appName  string
	}
	tests := []struct {
		name    string
		args    args
		wantErr bool
	}{
		{"All capital log level", args{logLevel: "DEBUG", appName: "test"}, false},
		{"All lover case log level", args{logLevel: "trace", appName: "test"}, false},
		{"Non supported loge level", args{logLevel: "kuku", appName: "test"}, true},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if err := logger.InitLogger(tt.args.logLevel, tt.args.appName); (err != nil) != tt.wantErr {
				t.Errorf("InitLogger() error = %v, wantErr %v", err, tt.wantErr)
			}
		})
	}
}
