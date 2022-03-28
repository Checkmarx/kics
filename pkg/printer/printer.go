package printer

import (
	"io"
	"sort"
	"strconv"
	"strings"

	consoleFlags "github.com/Checkmarx/kics/internal/console/flags"
	"github.com/rs/zerolog"
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
