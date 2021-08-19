package printer

import (
	"io"
	"os"
	"path/filepath"
	"sort"
	"strconv"
	"strings"

	consoleFlags "github.com/Checkmarx/kics/internal/console/flags"
	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/internal/constants"
	"github.com/gookit/color"
	"github.com/pkg/errors"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/spf13/pflag"
)

var (
	optionsMap = map[string]func(opt interface{}, changed bool) error{
		consoleFlags.CIFlag: func(opt interface{}, changed bool) error {
			return nil
		},
		consoleFlags.LogFileFlag:  LogFile,
		consoleFlags.LogLevelFlag: LogLevel,
		consoleFlags.LogPathFlag:  LogPath,
		consoleFlags.SilentFlag: func(opt interface{}, changed bool) error {
			return nil
		},
		consoleFlags.VerboseFlag: Verbose,
		consoleFlags.LogFormatFlag: func(opt interface{}, changed bool) error {
			return nil
		},
		consoleFlags.NoColorFlag: NoColor,
	}

	optionsOrderMap = map[int]string{
		1: consoleFlags.CIFlag,
		2: consoleFlags.LogFileFlag,
		3: consoleFlags.LogLevelFlag,
		4: consoleFlags.LogPathFlag,
		5: consoleFlags.SilentFlag,
		6: consoleFlags.VerboseFlag,
		7: consoleFlags.LogFormatFlag,
		8: consoleFlags.NoColorFlag,
	}

	consoleLogger = zerolog.ConsoleWriter{Out: io.Discard}
	fileLogger    = zerolog.ConsoleWriter{Out: io.Discard}

	outFileLogger    interface{}
	outConsoleLogger = io.Discard

	loggerFile  interface{}
	initialized bool
)

// SetupPrinter - configures stdout and log options with given FlagSet
func SetupPrinter(flags *pflag.FlagSet) error {
	err := validateFlags()
	if err != nil {
		return err
	}

	keys := make([]int, 0, len(optionsOrderMap))
	for k := range optionsOrderMap {
		keys = append(keys, k)
	}

	sort.Ints(keys)

	for _, key := range keys {
		f := flags.Lookup(optionsOrderMap[key])
		switch f.Value.Type() {
		case "string":
			value := f.Value.String()
			err = optionsMap[optionsOrderMap[key]](value, f.Changed)
			if err != nil {
				return err
			}
		case "bool":
			value, _ := strconv.ParseBool(f.Value.String())
			err = optionsMap[optionsOrderMap[key]](value, f.Changed)
			if err != nil {
				return err
			}
		}
	}

	// LogFormat needs to be the last option
	logFormat := strings.ToLower(consoleFlags.GetStrFlag(consoleFlags.LogFormatFlag))
	err = LogFormat(logFormat)
	if err != nil {
		return err
	}

	err = Silent(consoleFlags.GetBoolFlag(consoleFlags.SilentFlag))
	if err != nil {
		return err
	}

	err = CI(consoleFlags.GetBoolFlag(consoleFlags.CIFlag))
	if err != nil {
		return err
	}
	initialized = true
	return nil
}

// IsInitialized returns true if printer is ready, false otherwise
func IsInitialized() bool {
	return initialized
}

func validateFlags() error {
	if consoleFlags.GetBoolFlag(consoleFlags.VerboseFlag) && consoleFlags.GetBoolFlag(consoleFlags.SilentFlag) {
		return errors.New("can't provide 'silent' and 'verbose' flags simultaneously")
	}

	if consoleFlags.GetBoolFlag(consoleFlags.VerboseFlag) && consoleFlags.GetBoolFlag(consoleFlags.CIFlag) {
		return errors.New("can't provide 'verbose' and 'ci' flags simultaneously")
	}

	if consoleFlags.GetBoolFlag(consoleFlags.CIFlag) && consoleFlags.GetBoolFlag(consoleFlags.SilentFlag) {
		return errors.New("can't provide 'silent' and 'ci' flags simultaneously")
	}
	return nil
}

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
		logPath, err = getDefaultLogPath()
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
		logPath, err := getDefaultLogPath()
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
	default:
		return errors.New("invalid log level")
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
