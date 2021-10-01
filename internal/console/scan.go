package console

import (
	_ "embed" // Embed kics CLI img and scan-flags
	"os"
	"os/signal"
	"path/filepath"
	"syscall"

	"github.com/Checkmarx/kics/internal/console/flags"
	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/internal/constants"
	"github.com/Checkmarx/kics/pkg/scan"
	"github.com/getsentry/sentry-go"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
)

var (
	//go:embed assets/kics-console
	banner string

	//go:embed assets/scan-flags.json
	scanFlagsListContent string
)

const (
	scanCommandStr = "scan"
	initError      = "initialization error - "
)

// NewScanCmd creates a new instance of the scan Command
func NewScanCmd() *cobra.Command {
	return &cobra.Command{
		Use:   scanCommandStr,
		Short: "Executes a scan analysis",
		PersistentPreRunE: func(cmd *cobra.Command, args []string) error {
			return preRun(cmd)
		},
		RunE: func(cmd *cobra.Command, args []string) error {
			return run(cmd)
		},
	}
}

func initScanCmd(scanCmd *cobra.Command) error {
	if err := flags.InitJSONFlags(scanCmd, scanFlagsListContent, false); err != nil {
		return err
	}

	if err := scanCmd.MarkFlagRequired(flags.PathFlag); err != nil {
		sentry.CaptureException(err)
		log.Err(err).Msg("Failed to add command required flags")
	}
	return nil
}

func run(cmd *cobra.Command) error {
	changedDefaultQueryPath := cmd.Flags().Lookup(flags.QueriesPath).Changed
	changedDefaultLibrariesPath := cmd.Flags().Lookup(flags.LibrariesPath).Changed
	if err := consoleHelpers.InitShouldIgnoreArg(flags.GetStrFlag(flags.IgnoreOnExitFlag)); err != nil {
		return err
	}
	if err := consoleHelpers.InitShouldFailArg(flags.GetMultiStrFlag(flags.FailOnFlag)); err != nil {
		return err
	}
	if flags.GetStrFlag(flags.OutputPathFlag) != "" {
		updateReportFormats()
		flags.SetStrFlag(flags.OutputNameFlag, filepath.Base(flags.GetStrFlag(flags.OutputNameFlag)))
		if filepath.Ext(flags.GetStrFlag(flags.OutputPathFlag)) != "" {
			flags.SetStrFlag(flags.OutputPathFlag, filepath.Join(flags.GetStrFlag(flags.OutputPathFlag), string(os.PathSeparator)))
		}
		if err := os.MkdirAll(flags.GetStrFlag(flags.OutputPathFlag), os.ModePerm); err != nil {
			return err
		}
	}
	if flags.GetStrFlag(flags.PayloadPathFlag) != "" && filepath.Dir(flags.GetStrFlag(flags.PayloadPathFlag)) != "." {
		if err := os.MkdirAll(filepath.Dir(flags.GetStrFlag(flags.PayloadPathFlag)), os.ModePerm); err != nil {
			return err
		}
	}
	gracefulShutdown()

	scan.ScanParams.ChangedDefaultQueryPath = changedDefaultQueryPath
	scan.ScanParams.ChangedDefaultLibrariesPath = changedDefaultLibrariesPath

	return executeScan()
}

func updateReportFormats() {
	for _, format := range flags.GetMultiStrFlag(flags.ReportFormatsFlag) {
		if format == "all" {
			flags.SetMultiStrFlag(flags.ReportFormatsFlag, consoleHelpers.ListReportFormats())
			break
		}
	}
}

func getScanParameters() {
	scan.ScanParams.CloudProviderFlag = flags.GetMultiStrFlag(flags.CloudProviderFlag)
	scan.ScanParams.ConfigFlag = flags.GetStrFlag(flags.ConfigFlag)
	scan.ScanParams.DisableCISDescFlag = flags.GetBoolFlag(flags.DisableCISDescFlag)
	scan.ScanParams.DisableFullDescFlag = flags.GetBoolFlag(flags.DisableFullDescFlag)
	scan.ScanParams.ExcludeCategoriesFlag = flags.GetMultiStrFlag(flags.ExcludeCategoriesFlag)
	scan.ScanParams.ExcludePathsFlag = flags.GetMultiStrFlag(flags.ExcludePathsFlag)
	scan.ScanParams.ExcludeQueriesFlag = flags.GetMultiStrFlag(flags.ExcludeQueriesFlag)
	scan.ScanParams.ExcludeResultsFlag = flags.GetMultiStrFlag(flags.ExcludeResultsFlag)
	scan.ScanParams.ExcludeSeveritiesFlag = flags.GetMultiStrFlag(flags.ExcludeSeveritiesFlag)
	scan.ScanParams.IncludeQueriesFlag = flags.GetMultiStrFlag(flags.IncludeQueriesFlag)
	scan.ScanParams.InputDataFlag = flags.GetStrFlag(flags.InputDataFlag)
	scan.ScanParams.FailOnFlag = flags.GetMultiStrFlag(flags.FailOnFlag)
	scan.ScanParams.IgnoreOnExitFlag = flags.GetStrFlag(flags.IgnoreOnExitFlag)
	scan.ScanParams.MinimalUIFlag = flags.GetBoolFlag(flags.MinimalUIFlag)
	scan.ScanParams.NoProgressFlag = flags.GetBoolFlag(flags.NoProgressFlag)
	scan.ScanParams.InputDataFlag = flags.GetStrFlag(flags.InputDataFlag)
	scan.ScanParams.OutputNameFlag = flags.GetStrFlag(flags.OutputNameFlag)
	scan.ScanParams.OutputPathFlag = flags.GetStrFlag(flags.OutputPathFlag)
	scan.ScanParams.PathFlag = flags.GetMultiStrFlag(flags.PathFlag)
	scan.ScanParams.PayloadPathFlag = flags.GetStrFlag(flags.PayloadPathFlag)
	scan.ScanParams.PreviewLinesFlag = flags.GetIntFlag(flags.PreviewLinesFlag)
	scan.ScanParams.QueriesPath = flags.GetStrFlag(flags.QueriesPath)
	scan.ScanParams.LibrariesPath = flags.GetStrFlag(flags.LibrariesPath)
	scan.ScanParams.ReportFormatsFlag = flags.GetMultiStrFlag(flags.ReportFormatsFlag)
	scan.ScanParams.TypeFlag = flags.GetMultiStrFlag(flags.TypeFlag)
	scan.ScanParams.QueryExecTimeoutFlag = flags.GetIntFlag(flags.QueryExecTimeoutFlag)
	scan.ScanParams.LineInfoPayloadFlag = flags.GetBoolFlag(flags.LineInfoPayloadFlag)
	scan.ScanParams.DisableSecretsFlag = flags.GetBoolFlag(flags.DisableSecretsFlag)
	scan.ScanParams.SecretsRegexesPathFlag = flags.GetStrFlag(flags.SecretsRegexesPathFlag)
	scan.ScanParams.CIFlag = flags.GetBoolFlag(flags.CIFlag)
	scan.ScanParams.LogFormatFlag = flags.GetStrFlag(flags.LogFormatFlag)
	scan.ScanParams.LogLevelFlag = flags.GetStrFlag(flags.LogLevelFlag)
	scan.ScanParams.LogPathFlag = flags.GetStrFlag(flags.LogPathFlag)
	scan.ScanParams.NoColorFlag = flags.GetBoolFlag(flags.NoColorFlag)
	scan.ScanParams.ProfilingFlag = flags.GetStrFlag(flags.ProfilingFlag)
	scan.ScanParams.SilentFlag = flags.GetBoolFlag(flags.SilentFlag)
	scan.ScanParams.VerboseFlag = flags.GetBoolFlag(flags.VerboseFlag)
	scan.ScanParams.ScanID = scanID
}

func executeScan() error {
	log.Debug().Msg("console.scan()")
	for _, warn := range warnings {
		log.Warn().Msgf(warn)
	}

	// save the scan parameters into the ScanParameters struct
	getScanParameters()

	// perform pre_scan, scan and pos_scan
	err := scan.PerformScan(ctx, banner)

	if err != nil {
		log.Err(err)
		return err
	}

	return nil
}

// gracefulShutdown catches signal interrupt and returns the appropriate exit code
func gracefulShutdown() {
	c := make(chan os.Signal)
	// This line should not be lint, since golangci-lint has an issue about it (https://github.com/golang/go/issues/45043)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM) // nolint
	showErrors := consoleHelpers.ShowError("errors")
	interruptCode := constants.SignalInterruptCode
	go func(showErrors bool, interruptCode int) {
		<-c
		if showErrors {
			os.Exit(interruptCode)
		}
	}(showErrors, interruptCode)
}
