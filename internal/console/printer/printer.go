package printer

import (
	"io"
	"os"
	"path/filepath"
	"sort"
	"strconv"
	"strings"

	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/internal/constants"
	"github.com/gookit/color"
	"github.com/pkg/errors"
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
	optionsMap = map[string]func(opt interface{}, changed bool) error{
		CIFlag: func(opt interface{}, changed bool) error {
			return nil
		},
		LogFileFlag:  LogFile,
		LogLevelFlag: LogLevel,
		LogPathFlag:  LogPath,
		SilentFlag: func(opt interface{}, changed bool) error {
			return nil
		},
		VerboseFlag: Verbose,
		LogFormatFlag: func(opt interface{}, changed bool) error {
			return nil
		},
		NoColorFlag: NoColor,
	}

	optionsOrderMap = map[int]string{
		1: CIFlag,
		2: LogFileFlag,
		3: LogLevelFlag,
		4: LogPathFlag,
		5: SilentFlag,
		6: VerboseFlag,
		7: LogFormatFlag,
		8: NoColorFlag,
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
	err := validateFlags(flags)
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
			value, errBool := strconv.ParseBool(f.Value.String())
			if errBool != nil {
				return err
			}
			err = optionsMap[optionsOrderMap[key]](value, f.Changed)
			if err != nil {
				return err
			}
		}
	}

	// LogFormat needs to be the last option
	logFormat := strings.ToLower(flags.Lookup(LogFormatFlag).Value.String())
	err = LogFormat(logFormat, flags.Lookup(LogFormatFlag).Changed)
	if err != nil {
		return err
	}

	err = Silent(getFlagValue(SilentFlag, flags), flags.Lookup(SilentFlag).Changed)
	if err != nil {
		return err
	}

	err = CI(getFlagValue(CIFlag, flags), flags.Lookup(CIFlag).Changed)
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

func getFlagValue(flagName string, flags *pflag.FlagSet) bool {
	v, err := strconv.ParseBool(flags.Lookup(flagName).Value.String())
	if err != nil {
		log.Error().Msgf("failed to parse boolean flag")
	}
	return v
}

func validateFlags(flags *pflag.FlagSet) error {
	if getFlagValue(VerboseFlag, flags) && getFlagValue(SilentFlag, flags) {
		return errors.New("can't provide 'silent' and 'verbose' flags simultaneously")
	}

	if getFlagValue(VerboseFlag, flags) && getFlagValue(CIFlag, flags) {
		return errors.New("can't provide 'verbose' and 'ci' flags simultaneously")
	}

	if getFlagValue(CIFlag, flags) && getFlagValue(SilentFlag, flags) {
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
func Silent(opt interface{}, changed bool) error {
	silent := opt.(bool)
	if silent {
		color.SetOutput(io.Discard)
		os.Stdout = nil
		log.Logger = log.Output(zerolog.MultiLevelWriter(io.Discard, outFileLogger.(io.Writer)))
	}
	return nil
}

// CI - enable only log messages to CLI output
func CI(opt interface{}, changed bool) error {
	ci := opt.(bool)
	if ci {
		color.SetOutput(io.Discard)
		log.Logger = log.Output(zerolog.MultiLevelWriter(outConsoleLogger, outFileLogger.(io.Writer)))
		os.Stdout = nil
	}
	return nil
}

// LogFormat - configures the logs format (JSON,pretty).
func LogFormat(opt interface{}, changed bool) error {
	logFormat := opt.(string)
	if logFormat == LogFormatJSON {
		log.Logger = log.Output(zerolog.MultiLevelWriter(outConsoleLogger, loggerFile.(io.Writer)))
		outFileLogger = loggerFile
		outConsoleLogger = os.Stdout
	} else if logFormat == LogFormatPretty {
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
