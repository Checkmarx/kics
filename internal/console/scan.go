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

	// save the scan parameters into the ScanParameters struct
	scanParams := getScanParameters(changedDefaultQueryPath, changedDefaultLibrariesPath)

	return executeScan(*scanParams)
}

func updateReportFormats() {
	for _, format := range flags.GetMultiStrFlag(flags.ReportFormatsFlag) {
		if format == "all" {
			flags.SetMultiStrFlag(flags.ReportFormatsFlag, consoleHelpers.ListReportFormats())
			break
		}
	}
}

func getScanParameters(changedDefaultQueryPath, changedDefaultLibrariesPath bool) *scan.Parameters {
	var scanParams scan.Parameters

	scanParams.CloudProviderFlag = flags.GetMultiStrFlag(flags.CloudProviderFlag)
	scanParams.ConfigFlag = flags.GetStrFlag(flags.ConfigFlag)
	scanParams.DisableCISDescFlag = flags.GetBoolFlag(flags.DisableCISDescFlag)
	scanParams.DisableFullDescFlag = flags.GetBoolFlag(flags.DisableFullDescFlag)
	scanParams.ExcludeCategoriesFlag = flags.GetMultiStrFlag(flags.ExcludeCategoriesFlag)
	scanParams.ExcludePathsFlag = flags.GetMultiStrFlag(flags.ExcludePathsFlag)
	scanParams.ExcludeQueriesFlag = flags.GetMultiStrFlag(flags.ExcludeQueriesFlag)
	scanParams.ExcludeResultsFlag = flags.GetMultiStrFlag(flags.ExcludeResultsFlag)
	scanParams.ExcludeSeveritiesFlag = flags.GetMultiStrFlag(flags.ExcludeSeveritiesFlag)
	scanParams.IncludeQueriesFlag = flags.GetMultiStrFlag(flags.IncludeQueriesFlag)
	scanParams.InputDataFlag = flags.GetStrFlag(flags.InputDataFlag)
	scanParams.FailOnFlag = flags.GetMultiStrFlag(flags.FailOnFlag)
	scanParams.IgnoreOnExitFlag = flags.GetStrFlag(flags.IgnoreOnExitFlag)
	scanParams.MinimalUIFlag = flags.GetBoolFlag(flags.MinimalUIFlag)
	scanParams.NoProgressFlag = flags.GetBoolFlag(flags.NoProgressFlag)
	scanParams.InputDataFlag = flags.GetStrFlag(flags.InputDataFlag)
	scanParams.OutputNameFlag = flags.GetStrFlag(flags.OutputNameFlag)
	scanParams.OutputPathFlag = flags.GetStrFlag(flags.OutputPathFlag)
	scanParams.PathFlag = flags.GetMultiStrFlag(flags.PathFlag)
	scanParams.PayloadPathFlag = flags.GetStrFlag(flags.PayloadPathFlag)
	scanParams.PreviewLinesFlag = flags.GetIntFlag(flags.PreviewLinesFlag)
	scanParams.QueriesPath = flags.GetStrFlag(flags.QueriesPath)
	scanParams.LibrariesPath = flags.GetStrFlag(flags.LibrariesPath)
	scanParams.ReportFormatsFlag = flags.GetMultiStrFlag(flags.ReportFormatsFlag)
	scanParams.TypeFlag = flags.GetMultiStrFlag(flags.TypeFlag)
	scanParams.QueryExecTimeoutFlag = flags.GetIntFlag(flags.QueryExecTimeoutFlag)
	scanParams.LineInfoPayloadFlag = flags.GetBoolFlag(flags.LineInfoPayloadFlag)
	scanParams.DisableSecretsFlag = flags.GetBoolFlag(flags.DisableSecretsFlag)
	scanParams.SecretsRegexesPathFlag = flags.GetStrFlag(flags.SecretsRegexesPathFlag)
	scanParams.CIFlag = flags.GetBoolFlag(flags.CIFlag)
	scanParams.LogFormatFlag = flags.GetStrFlag(flags.LogFormatFlag)
	scanParams.LogLevelFlag = flags.GetStrFlag(flags.LogLevelFlag)
	scanParams.LogPathFlag = flags.GetStrFlag(flags.LogPathFlag)
	scanParams.NoColorFlag = flags.GetBoolFlag(flags.NoColorFlag)
	scanParams.ProfilingFlag = flags.GetStrFlag(flags.ProfilingFlag)
	scanParams.SilentFlag = flags.GetBoolFlag(flags.SilentFlag)
	scanParams.VerboseFlag = flags.GetBoolFlag(flags.VerboseFlag)
	scanParams.ScanID = scanID
	scanParams.ChangedDefaultLibrariesPath = changedDefaultLibrariesPath
	scanParams.ChangedDefaultQueryPath = changedDefaultQueryPath

	return &scanParams
}

func executeScan(scanParams scan.Parameters) error {
	log.Debug().Msg("console.scan()")
	for _, warn := range warnings {
		log.Warn().Msgf(warn)
	}

	c := scan.NewClient(&scanParams)

	printer, proBarBuilder, progressBar := preScan()

	c.Printer = printer
	c.ProBarBuilder = proBarBuilder
	c.ProgressBar = progressBar

	// perform pre_scan, scan and pos_scan
	err := c.PerformScan(ctx)

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
