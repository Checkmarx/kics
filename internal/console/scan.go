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

	return executeScan(scanParams)
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

	scanParams.CloudProvider = flags.GetMultiStrFlag(flags.CloudProviderFlag)
	scanParams.DisableCISDesc = flags.GetBoolFlag(flags.DisableCISDescFlag)
	scanParams.DisableFullDesc = flags.GetBoolFlag(flags.DisableFullDescFlag)
	scanParams.ExcludeCategories = flags.GetMultiStrFlag(flags.ExcludeCategoriesFlag)
	scanParams.ExcludePaths = flags.GetMultiStrFlag(flags.ExcludePathsFlag)
	scanParams.ExcludeQueries = flags.GetMultiStrFlag(flags.ExcludeQueriesFlag)
	scanParams.ExcludeResults = flags.GetMultiStrFlag(flags.ExcludeResultsFlag)
	scanParams.ExcludeSeverities = flags.GetMultiStrFlag(flags.ExcludeSeveritiesFlag)
	scanParams.IncludeQueries = flags.GetMultiStrFlag(flags.IncludeQueriesFlag)
	scanParams.InputData = flags.GetStrFlag(flags.InputDataFlag)
	scanParams.OutputName = flags.GetStrFlag(flags.OutputNameFlag)
	scanParams.OutputPath = flags.GetStrFlag(flags.OutputPathFlag)
	scanParams.Path = flags.GetMultiStrFlag(flags.PathFlag)
	scanParams.PayloadPath = flags.GetStrFlag(flags.PayloadPathFlag)
	scanParams.PreviewLines = flags.GetIntFlag(flags.PreviewLinesFlag)
	scanParams.QueriesPath = flags.GetStrFlag(flags.QueriesPath)
	scanParams.LibrariesPath = flags.GetStrFlag(flags.LibrariesPath)
	scanParams.ReportFormats = flags.GetMultiStrFlag(flags.ReportFormatsFlag)
	scanParams.Platform = flags.GetMultiStrFlag(flags.TypeFlag)
	scanParams.QueryExecTimeout = flags.GetIntFlag(flags.QueryExecTimeoutFlag)
	scanParams.LineInfoPayload = flags.GetBoolFlag(flags.LineInfoPayloadFlag)
	scanParams.DisableSecrets = flags.GetBoolFlag(flags.DisableSecretsFlag)
	scanParams.SecretsRegexesPath = flags.GetStrFlag(flags.SecretsRegexesPathFlag)
	scanParams.ScanID = scanID
	scanParams.ChangedDefaultLibrariesPath = changedDefaultLibrariesPath
	scanParams.ChangedDefaultQueryPath = changedDefaultQueryPath

	return &scanParams
}

func executeScan(scanParams *scan.Parameters) error {
	log.Debug().Msg("console.scan()")
	for _, warn := range warnings {
		log.Warn().Msgf(warn)
	}

	console := newConsole()

	console.preScan()

	client, err := scan.NewClient(scanParams, console.ProBarBuilder, console.Printer)

	if err != nil {
		log.Err(err)
		return err
	}

	err = client.PerformScan(ctx)

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
