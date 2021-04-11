package printer

import (
	"io"
	"os"
	"path/filepath"
	"strconv"
	"strings"

	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/internal/constants"
	"github.com/gookit/color"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/spf13/pflag"
)

const (
	CIFlag             = "ci"
	LogFileFlag        = "log-file"
	LogFileShorthand   = "l"
	LogFormatFlag      = "log-format"
	LogFormatShorthand = "f"
	LogLevelFlag       = "log-level"
	LogPathFlag        = "log-path"
	NoColorFlag        = "no-color"
	SilentFlag         = "silent"
	SilentShorthand    = "s"
	VerboseFlag        = "verbose"
	VerboseShorthand   = "v"
	LogFormatJSON      = "json"
	LogFormatPretty    = "pretty"
)

var (
	optionsMap = map[string]func(opt interface{}) error{
		CIFlag:        CI,
		LogFileFlag:   LogFile,
		LogLevelFlag:  LogLevel,
		LogPathFlag:   LogPath,
		NoColorFlag:   NoColor,
		SilentFlag:    Silent,
		VerboseFlag:   Verbose,
		LogFormatFlag: LogFormat,
	}

	consoleLogger = zerolog.ConsoleWriter{Out: io.Discard}
	fileLogger    = zerolog.ConsoleWriter{Out: io.Discard}

	loggerFile *os.File
)

// ConfigurePrinterOutput - configures stdout and log options with given FlagSet
func ConfigurePrinterOutput(flags *pflag.FlagSet) error {
	flagsMap := make(map[string]interface{})

	logFormat := strings.ToLower(flags.Lookup(LogFormatFlag).Value.String())

	flags.VisitAll(func(f *pflag.Flag) {
		switch f.Value.Type() {
		case "string":
			flagsMap[f.Name] = f.Value.String()
		case "bool":
			flagValue, _ := strconv.ParseBool(f.Value.String())
			flagsMap[f.Name] = flagValue
		}
	})

	for flagName, flagValue := range flagsMap {
		err := optionsMap[flagName](flagValue)
		if err != nil {
			return err
		}
	}

	if logFormat == LogFormatPretty {
		log.Logger = log.Output(zerolog.MultiLevelWriter(consoleLogger, fileLogger))
	}

	return nil
}

// NoColor - disables ASCII color codes
func NoColor(opt interface{}) error {
	noColor := opt.(bool)
	if noColor {
		color.Disable()
		consoleLogger.NoColor = true
	}
	return nil
}

// Verbose - redirects log entries to stdout
func Verbose(opt interface{}) error {
	verbose := opt.(bool)
	if verbose {
		consoleLogger = zerolog.ConsoleWriter{Out: os.Stdout}
	}
	return nil
}

// Silent - disables stdout output
func Silent(opt interface{}) error {
	silent := opt.(bool)
	if silent {
		color.SetOutput(io.Discard)
		os.Stdout = nil
	}
	return nil
}

// CI - enable only log messages to CLI output
func CI(opt interface{}) error {
	ci := opt.(bool)
	if ci {
		color.SetOutput(io.Discard)
		consoleLogger = zerolog.ConsoleWriter{Out: os.Stdout, NoColor: true}
		os.Stdout = nil
	}
	return nil
}

// LogFormat - configures the logs format (JSON,pretty)
func LogFormat(opt interface{}) error {
	logFormat := opt.(string)
	if logFormat == LogFormatJSON {
		os.Stdout = nil
	}
	return nil
}

// LogPath - sets the log files location
func LogPath(opt interface{}) error {
	logPath := opt.(string)
	var err error
	if logPath == "" {
		logPath, err = getDefaultLogPath()
		if err != nil {
			return err
		}
	}
	loggerFile, err = os.OpenFile(filepath.Clean(logPath), os.O_APPEND|os.O_CREATE|os.O_WRONLY, os.ModePerm)
	fileLogger = consoleHelpers.CustomConsoleWriter(&zerolog.ConsoleWriter{Out: loggerFile, NoColor: true})
	if err != nil {
		return err
	}
	return nil
}

// LogFile - enables write to log file
func LogFile(opt interface{}) error {
	logFile := opt.(bool)
	if logFile {
		fileLogger = consoleHelpers.CustomConsoleWriter(&zerolog.ConsoleWriter{Out: loggerFile, NoColor: true})
	}
	return nil
}

// LogLevel - sets log level
func LogLevel(opt interface{}) error {
	logLevel := opt.(string)
	switch logLevel {
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
	default:
		zerolog.SetGlobalLevel(zerolog.InfoLevel)
	}
	return nil
}

func getDefaultLogPath() (string, error) {
	currentWorkDir, err := os.Getwd()
	if err != nil {
		return "", err
	}
	return filepath.Join(currentWorkDir, constants.DefaultLogFile), nil
}
