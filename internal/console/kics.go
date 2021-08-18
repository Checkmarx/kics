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
	scanID = "console"
)

var (
	// warnings - a buffer to accumulate warnings before the printer gets initialized
	warnings = make([]string, 0)

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
	rootCmd.PersistentFlags().StringVar(&logPath,
		printer.LogPathFlag,
		"",
		fmt.Sprintf("path to generate log file (%s)", constants.DefaultLogFile))
	rootCmd.PersistentFlags().StringVar(&logLevel,
		printer.LogLevelFlag,
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
	rootCmd.PersistentFlags().BoolVar(&noColor,
		printer.NoColorFlag,
		false,
		"disable CLI color output")
	rootCmd.PersistentFlags().BoolVar(&ci,
		printer.CIFlag,
		false,
		"display only log messages to CLI output (mutually exclusive with silent)")
	rootCmd.PersistentFlags().StringVar(&profiling,
		"profiling",
		"",
		"enables performance profiler that prints resource consumption metrics in the logs during the execution (CPU, MEM)")

	if err := rootCmd.PersistentFlags().MarkDeprecated(printer.LogFileFlag, "please use --log-path instead"); err != nil {
		return err
	}

	if err := viper.BindPFlags(rootCmd.PersistentFlags()); err != nil {
		return err
	}

	return initScanCmd(scanCmd)
}

// Execute starts kics execution
func Execute() error {
	zerolog.SetGlobalLevel(zerolog.InfoLevel)

	enableCrashReport()

	rootCmd := NewKICSCmd()

	if err := initialize(rootCmd); err != nil {
		sentry.CaptureException(err)
		log.Err(err).Msg("Failed to initialize CLI")
		return err
	}

	if err := rootCmd.ExecuteContext(ctx); err != nil {
		sentry.CaptureException(err)
		if printer.IsInitialized() {
			log.Err(err).Msg("Failed to run application")
		}
		return err
	}

	return nil
}

func enableCrashReport() {
	enableCrashReport, found := os.LookupEnv("DISABLE_CRASH_REPORT")
	if found && (enableCrashReport == "0" || enableCrashReport == "false") {
		initSentry("")
	} else {
		initSentry(constants.SentryDSN)
	}
}

func initSentry(dsn string) {
	var err error
	if dsn == "" {
		warnings = append(warnings, "KICS crash report disabled")
		err = sentry.Init(sentry.ClientOptions{
			Release: constants.GetRelease(),
		})
	} else {
		err = sentry.Init(sentry.ClientOptions{
			Dsn:     dsn,
			Release: constants.GetRelease(),
		})
	}
	if err != nil {
		log.Err(err).Msg("Failed to initialize sentry")
	}
	sentry.Flush(constants.SentryRefreshRate * time.Second)
}
