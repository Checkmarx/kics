package console

import (
	_ "embed" // Embed kics CLI img and scan-flags
	"os"
	"os/signal"
	"path/filepath"
	"strings"
	"syscall"

	"github.com/Checkmarx/kics/v2/internal/console/flags"
	consoleHelpers "github.com/Checkmarx/kics/v2/internal/console/helpers"
	"github.com/Checkmarx/kics/v2/internal/constants"
	sentryReport "github.com/Checkmarx/kics/v2/internal/sentry"
	"github.com/Checkmarx/kics/v2/pkg/engine/source"
	"github.com/Checkmarx/kics/v2/pkg/scan"
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
	dirPerms       = 0777
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
	if err := flags.InitJSONFlags(
		scanCmd,
		scanFlagsListContent,
		false,
		source.ListSupportedPlatforms(),
		source.ListSupportedCloudProviders()); err != nil {
		return err
	}

	if err := scanCmd.MarkFlagRequired(flags.PathFlag); err != nil {
		sentryReport.ReportSentry(&sentryReport.Report{
			Message:  "Failed to add command required flags",
			Err:      err,
			Location: "func initScanCmd()",
		}, true)
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
		if err := os.MkdirAll(flags.GetStrFlag(flags.OutputPathFlag), dirPerms); err != nil { //nolint:gosec
			return err
		}
	}
	if flags.GetStrFlag(flags.PayloadPathFlag) != "" && filepath.Dir(flags.GetStrFlag(flags.PayloadPathFlag)) != "." {
		if err := os.MkdirAll(filepath.Dir(flags.GetStrFlag(flags.PayloadPathFlag)), dirPerms); err != nil {
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
		if strings.EqualFold(format, "all") {
			flags.SetMultiStrFlag(flags.ReportFormatsFlag, consoleHelpers.ListReportFormats())
			break
		}
	}
}

func getScanParameters(changedDefaultQueryPath, changedDefaultLibrariesPath bool) *scan.Parameters {
	scanParams := scan.Parameters{
		CloudProvider:               flags.GetMultiStrFlag(flags.CloudProviderFlag),
		DisableFullDesc:             flags.GetBoolFlag(flags.DisableFullDescFlag),
		ExcludeCategories:           flags.GetMultiStrFlag(flags.ExcludeCategoriesFlag),
		ExcludePaths:                flags.GetMultiStrFlag(flags.ExcludePathsFlag),
		ExcludeQueries:              flags.GetMultiStrFlag(flags.ExcludeQueriesFlag),
		ExcludeResults:              flags.GetMultiStrFlag(flags.ExcludeResultsFlag),
		ExcludeSeverities:           flags.GetMultiStrFlag(flags.ExcludeSeveritiesFlag),
		ExperimentalQueries:         flags.GetBoolFlag(flags.ExperimentalQueriesFlag),
		IncludeQueries:              flags.GetMultiStrFlag(flags.IncludeQueriesFlag),
		InputData:                   flags.GetStrFlag(flags.InputDataFlag),
		OutputName:                  flags.GetStrFlag(flags.OutputNameFlag),
		OutputPath:                  flags.GetStrFlag(flags.OutputPathFlag),
		Path:                        flags.GetMultiStrFlag(flags.PathFlag),
		PayloadPath:                 flags.GetStrFlag(flags.PayloadPathFlag),
		PreviewLines:                flags.GetIntFlag(flags.PreviewLinesFlag),
		QueriesPath:                 flags.GetMultiStrFlag(flags.QueriesPath),
		LibrariesPath:               flags.GetStrFlag(flags.LibrariesPath),
		ReportFormats:               flags.GetMultiStrFlag(flags.ReportFormatsFlag),
		Platform:                    flags.GetMultiStrFlag(flags.TypeFlag),
		ExcludePlatform:             flags.GetMultiStrFlag(flags.ExcludeTypeFlag),
		TerraformVarsPath:           flags.GetStrFlag(flags.TerraformVarsPathFlag),
		QueryExecTimeout:            flags.GetIntFlag(flags.QueryExecTimeoutFlag),
		LineInfoPayload:             flags.GetBoolFlag(flags.LineInfoPayloadFlag),
		DisableSecrets:              flags.GetBoolFlag(flags.DisableSecretsFlag),
		SecretsRegexesPath:          flags.GetStrFlag(flags.SecretsRegexesPathFlag),
		ScanID:                      scanID,
		ChangedDefaultLibrariesPath: changedDefaultLibrariesPath,
		ChangedDefaultQueryPath:     changedDefaultQueryPath,
		BillOfMaterials:             flags.GetBoolFlag(flags.BomFlag),
		ExcludeGitIgnore:            flags.GetBoolFlag(flags.ExcludeGitIgnore),
		OpenAPIResolveReferences:    flags.GetBoolFlag(flags.OpenAPIReferencesFlag),
		ParallelScanFlag:            flags.GetIntFlag(flags.ParallelScanFile),
		MaxFileSizeFlag:             flags.GetIntFlag(flags.MaxFileSizeFlag),
		UseOldSeverities:            flags.GetBoolFlag(flags.UseOldSeveritiesFlag),
		MaxResolverDepth:            flags.GetIntFlag(flags.MaxResolverDepth),
		KicsComputeNewSimID:         flags.GetBoolFlag(flags.KicsComputeNewSimIDFlag),
	}

	return &scanParams
}

func executeScan(scanParams *scan.Parameters) error {
	log.Debug().Msg("console.scan()")

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
	signal.Notify(c, os.Interrupt, syscall.SIGTERM) //nolint
	showErrors := consoleHelpers.ShowError("errors")
	interruptCode := constants.SignalInterruptCode
	go func(showErrors bool, interruptCode int) {
		<-c
		if showErrors {
			os.Exit(interruptCode)
		}
	}(showErrors, interruptCode)
}
