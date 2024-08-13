/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package printer

import (
	"io"
	"os"
	"path/filepath"
	"strings"

	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/internal/constants"
	"github.com/gookit/color"
	"github.com/pkg/errors"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

// NoColor - disables ASCII color codes
func NoColor(opt interface{}, changed bool) error {
	noColor := opt.(bool)
	if noColor {
		color.Disable()
		consoleLogger.NoColor = true
	}
	return nil
}

// Verbose - redirects log entries to stdout
func Verbose(opt interface{}, changed bool) error {
	verbose := opt.(bool)
	if verbose {
		consoleLogger = zerolog.ConsoleWriter{Out: os.Stdout}
		outConsoleLogger = os.Stdout
	}
	return nil
}

// Silent - disables stdout output
func Silent(opt interface{}) error {
	silent := opt.(bool)
	if silent {
		color.SetOutput(io.Discard)
		os.Stdout = nil
		log.Logger = log.Output(zerolog.MultiLevelWriter(io.Discard, outFileLogger.(io.Writer)))
	}
	return nil
}

// CI - enable only log messages to CLI output
func CI(opt interface{}) error {
	ci := opt.(bool)
	if ci {
		color.SetOutput(io.Discard)
		log.Logger = log.Output(zerolog.MultiLevelWriter(outConsoleLogger, outFileLogger.(io.Writer)))
		os.Stdout = nil
	}
	return nil
}

// LogFormat - configures the logs format (JSON,pretty).
func LogFormat(logFormat string) error {
	if logFormat == constants.LogFormatJSON {
		log.Logger = log.Output(zerolog.MultiLevelWriter(outConsoleLogger, loggerFile.(io.Writer)))
		outFileLogger = loggerFile
		outConsoleLogger = os.Stdout
	} else if logFormat == constants.LogFormatPretty {
		fileLogger = consoleHelpers.CustomConsoleWriter(&zerolog.ConsoleWriter{Out: loggerFile.(io.Writer), NoColor: true})
		log.Logger = log.Output(zerolog.MultiLevelWriter(consoleLogger, fileLogger))
		outFileLogger = fileLogger
		outConsoleLogger = zerolog.ConsoleWriter{Out: os.Stdout, NoColor: true}
	} else {
		return errors.New("invalid log format")
	}
	return nil
}

// LogPath - sets the log files location
func LogPath(opt interface{}, changed bool) error {
	logPath := opt.(string)
	var err error
	if !changed {
		if loggerFile == nil {
			loggerFile = io.Discard
			return nil
		}
		return nil
	}
	if logPath == "" {
		logPath, err = constants.GetDefaultLogPath()
		if err != nil {
			return err
		}
	} else if filepath.Dir(logPath) != "." {
		if createErr := os.MkdirAll(filepath.Dir(logPath), os.ModePerm); createErr != nil {
			return createErr
		}
	}

	loggerFile, err = os.OpenFile(logPath, os.O_CREATE|os.O_WRONLY, os.ModePerm)
	if err != nil {
		return err
	}
	return nil
}

// LogFile - enables write to log file
func LogFile(opt interface{}, changed bool) error {
	logFile := opt.(bool)
	if logFile {
		logPath, err := constants.GetDefaultLogPath()
		if err != nil {
			return err
		}
		loggerFile, err = os.OpenFile(filepath.Clean(logPath), os.O_CREATE|os.O_WRONLY, os.ModePerm)
		if err != nil {
			return err
		}
		fileLogger = consoleHelpers.CustomConsoleWriter(&zerolog.ConsoleWriter{Out: loggerFile.(io.Writer), NoColor: true})
	}
	return nil
}

// LogLevel - sets log level
func LogLevel(opt interface{}, changed bool) error {
	logLevel := opt.(string)
	switch strings.ToUpper(logLevel) {
	case "TRACE":
		zerolog.SetGlobalLevel(zerolog.TraceLevel)
	case "DEBUG":
		zerolog.SetGlobalLevel(zerolog.DebugLevel)
	case "INFO":
		zerolog.SetGlobalLevel(zerolog.InfoLevel)
	case "WARN":
		zerolog.SetGlobalLevel(zerolog.WarnLevel)
	case "ERROR":
		zerolog.SetGlobalLevel(zerolog.ErrorLevel)
	case "FATAL":
		zerolog.SetGlobalLevel(zerolog.FatalLevel)
	}
	return nil
}

type LogSink struct {
	logs []string
}

func NewLogger(logs *LogSink) zerolog.Logger {
	if logs == nil {
		return log.Logger
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
