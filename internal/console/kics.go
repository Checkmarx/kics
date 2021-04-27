package console

import (
	"context"
	"fmt"
	"os"
	"strings"
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

	ci        bool
	logFile   bool
	logFormat string
	logLevel  string
	logPath   string
	noColor   bool
	silent    bool
	profiling string
	verbose   bool

	warning []string
)

// NewKICSCmd creates a new instance of the kics Command
func NewKICSCmd() *cobra.Command {
	return &cobra.Command{
		Use:   "kics",
		Short: constants.Fullname,
	}
}

func initialize(rootCmd *cobra.Command) error {
	scanCmd := NewScanCmd()
	rootCmd.AddCommand(NewVersionCmd())
	rootCmd.AddCommand(NewGenerateIDCmd())
	rootCmd.AddCommand(scanCmd)
	rootCmd.AddCommand(NewListPlatformsCmd())
	rootCmd.PersistentFlags().BoolVarP(&logFile,
		printer.LogFileFlag,
		printer.LogFileShorthand,
		false,
		"writes log messages to log file")
	rootCmd.PersistentFlags().StringVarP(&logPath,
		printer.LogPathFlag,
		"",
		"",
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
	rootCmd.PersistentFlags().StringVarP(&profiling,
		"profiling",
		"",
		"",
		"enables performance profiler that prints resource consumption metrics in the logs during the execution (CPU, MEM)")

	if err := rootCmd.PersistentFlags().MarkDeprecated(printer.LogFileFlag, "please use --log-path instead"); err != nil {
		return err
	}

	if err := viper.BindPFlags(rootCmd.PersistentFlags()); err != nil {
		return err
	}

	initScanCmd(scanCmd)
	if insertScanCmd(scanCmd) {
		warning = append(warning, "WARNING: for future versions use 'kics scan'")
		os.Args = append([]string{os.Args[0], "scan"}, os.Args[1:]...)
	}

	return nil
}

func insertScanCmd(scanCmd *cobra.Command) bool {
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

	rootCmd := NewKICSCmd()

	err := sentry.Init(sentry.ClientOptions{})
	if err != nil {
		log.Err(err).Msg("Failed to initialize sentry")
	}
	defer sentry.Flush(timeMult * time.Second)

	if err = initialize(rootCmd); err != nil {
		sentry.CaptureException(err)
		log.Err(err).Msg("Failed to initialize CLI")
		return err
	}

	if err := rootCmd.ExecuteContext(ctx); err != nil {
		sentry.CaptureException(err)
		if !(strings.HasPrefix(err.Error(), "unknown shorthand flag") ||
			strings.HasPrefix(err.Error(), "unknown flag") ||
			strings.HasPrefix(err.Error(), "unknown command") ||
			strings.HasPrefix(err.Error(), "initialization error -")) {
			log.Err(err).Msg("Failed to run application")
		}
		return err
	}

	return nil
}
