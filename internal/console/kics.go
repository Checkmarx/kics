package console

import (
	"context"
	"fmt"
	"os"
	"time"

	"github.com/Checkmarx/kics/internal/console/printer"
	"github.com/Checkmarx/kics/internal/constants"
	"github.com/getsentry/sentry-go"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

const (
	scanID   = "console"
	timeMult = 2
)

var (
	ctx = context.Background()

	verbose   bool
	logFile   bool
	logPath   string
	logLevel  string
	logFormat string
	noColor   bool
	silent    bool
	ci        bool

	warning []string

	rootCmd = &cobra.Command{
		Use:   "kics",
		Short: constants.Fullname,
	}
)

func initialize() error {
	rootCmd.AddCommand(versionCmd)
	rootCmd.AddCommand(generateIDCmd)
	rootCmd.AddCommand(scanCmd)
	rootCmd.AddCommand(listPlatformsCmd)
	rootCmd.PersistentFlags().BoolVarP(&logFile,
		printer.LogFileFlag,
		printer.LogFileShorthand,
		false,
		"writes log messages to log file")
	rootCmd.PersistentFlags().StringVarP(&logPath,
		printer.LogPathFlag,
		"",
		"skip-KICS-log-path",
		fmt.Sprintf("path to log files, (defaults to ${PWD}/%s)", constants.DefaultLogFile))
	rootCmd.PersistentFlags().StringVarP(&logLevel,
		printer.LogLevelFlag,
		"",
		"INFO",
		"determines log level (TRACE,DEBUG,INFO,WARN,ERROR,FATAL)")
	rootCmd.PersistentFlags().StringVarP(&logFormat,
		printer.LogFormatFlag,
		printer.LogFormatShorthand,
		printer.LogFormatPretty,
		fmt.Sprintf("determines log format (%s,%s)", printer.LogFormatPretty, printer.LogFormatJSON))
	rootCmd.PersistentFlags().BoolVarP(&verbose,
		printer.VerboseFlag,
		printer.VerboseShorthand,
		false,
		"write logs to stdout too (mutually exclusive with silent)")
	rootCmd.PersistentFlags().BoolVarP(&silent,
		printer.SilentFlag,
		printer.SilentShorthand,
		false,
		"silence stdout messages (mutually exclusive with verbose and ci)")
	rootCmd.PersistentFlags().BoolVarP(&noColor,
		printer.NoColorFlag,
		"",
		false,
		"disable CLI color output")
	rootCmd.PersistentFlags().BoolVarP(&ci,
		printer.CIFlag,
		"",
		false,
		"display only log messages to CLI output (mutually exclusive with silent)")

	err := rootCmd.PersistentFlags().MarkDeprecated(printer.LogFileFlag, "please use --log-path instead")
	if err != nil {
		return err
	}

	if err := viper.BindPFlags(rootCmd.PersistentFlags()); err != nil {
		return err
	}

	initScanCmd()
	if insertScanCmd() {
		warning = append(warning, "WARNING: for future versions use 'kics scan'")
		os.Args = append([]string{os.Args[0], "scan"}, os.Args[1:]...)
	}

	return nil
}

func insertScanCmd() bool {
	if len(os.Args) > 1 && os.Args[1][0] == '-' {
		if os.Args[1][1] != '-' {
			flag := os.Args[1][1:]
			return scanCmd.Flags().ShorthandLookup(flag) != nil
		}
		flag := os.Args[1][2:]
		return scanCmd.Flag(flag) != nil
	}
	return false
}

// Execute starts kics execution
func Execute() error {
	zerolog.SetGlobalLevel(zerolog.InfoLevel)

	err := sentry.Init(sentry.ClientOptions{})
	if err != nil {
		log.Err(err).Msg("Failed to initialize sentry")
	}
	defer sentry.Flush(timeMult * time.Second)

	if err := initialize(); err != nil {
		sentry.CaptureException(err)
		log.Err(err).Msg("Failed to initialize CLI")
		return err
	}

	if err := rootCmd.ExecuteContext(ctx); err != nil {
		sentry.CaptureException(err)
		log.Err(err).Msg("Failed to run application")
		return err
	}

	return nil
}
