package console

import (
	"context"
	_ "embed" // Embed kics flags
	"os"
	"time"

	"github.com/Checkmarx/kics/v2/internal/console/flags"
	"github.com/Checkmarx/kics/v2/internal/constants"
	sentryReport "github.com/Checkmarx/kics/v2/internal/sentry"
	"github.com/Checkmarx/kics/v2/pkg/engine/source"
	"github.com/Checkmarx/kics/v2/pkg/printer"
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
	//go:embed assets/kics-flags.json
	kicsFlagsListContent string

	// warnings - a buffer to accumulate warnings before the printer gets initialized
	warnings = make([]string, 0)

	ctx = context.Background()
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
	remediateCmd := NewRemediateCmd()
	analyzeCmd := NewAnalyzeCmd()
	rootCmd.AddCommand(NewVersionCmd())
	rootCmd.AddCommand(NewGenerateIDCmd())
	rootCmd.AddCommand(scanCmd)
	rootCmd.AddCommand(NewListPlatformsCmd())
	rootCmd.AddCommand(remediateCmd)
	rootCmd.AddCommand(analyzeCmd)
	rootCmd.CompletionOptions.DisableDefaultCmd = true

	if err := flags.InitJSONFlags(
		rootCmd,
		kicsFlagsListContent,
		true,
		source.ListSupportedPlatforms(),
		source.ListSupportedCloudProviders()); err != nil {
		return err
	}

	if err := viper.BindPFlags(rootCmd.PersistentFlags()); err != nil {
		return err
	}

	if err := initRemediateCmd(remediateCmd); err != nil {
		return err
	}

	if err := initAnalyzeCmd(analyzeCmd); err != nil {
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
		sentryReport.ReportSentry(&sentryReport.Report{
			Message:  "Failed to initialize CLI",
			Err:      err,
			Location: "func Execute()",
		}, true)
		return err
	}

	if err := rootCmd.ExecuteContext(ctx); err != nil {
		sentryReport.ReportSentry(&sentryReport.Report{
			Message:  "Failed to run application",
			Err:      err,
			Location: "func Execute()",
		}, printer.IsInitialized())
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
