package console

import (
	_ "embed" // Embed kics CLI img and scan-flags
	"os"
	"path/filepath"

	"github.com/Checkmarx/kics/assets"
	"github.com/Checkmarx/kics/internal/console/flags"
	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/internal/storage"
	"github.com/Checkmarx/kics/internal/tracker"
	"github.com/Checkmarx/kics/pkg/engine"
	"github.com/Checkmarx/kics/pkg/engine/provider"
	"github.com/Checkmarx/kics/pkg/engine/secrets"
	"github.com/Checkmarx/kics/pkg/engine/source"
	"github.com/Checkmarx/kics/pkg/kics"
	"github.com/Checkmarx/kics/pkg/parser"
	dockerParser "github.com/Checkmarx/kics/pkg/parser/docker"
	jsonParser "github.com/Checkmarx/kics/pkg/parser/json"
	terraformParser "github.com/Checkmarx/kics/pkg/parser/terraform"
	yamlParser "github.com/Checkmarx/kics/pkg/parser/yaml"
	"github.com/Checkmarx/kics/pkg/progress"
	"github.com/Checkmarx/kics/pkg/resolver"
	"github.com/Checkmarx/kics/pkg/resolver/helm"
	"github.com/Checkmarx/kics/pkg/scanner"
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
	return scan(changedDefaultQueryPath, changedDefaultLibrariesPath)
}

func updateReportFormats() {
	for _, format := range flags.GetMultiStrFlag(flags.ReportFormatsFlag) {
		if format == "all" {
			flags.SetMultiStrFlag(flags.ReportFormatsFlag, consoleHelpers.ListReportFormats())
			break
		}
	}
}

func getFileSystemSourceProvider(paths []string) (*provider.FileSystemSourceProvider, error) {
	var excludePaths []string
	if flags.GetStrFlag(flags.PayloadPathFlag) != "" {
		excludePaths = append(excludePaths, flags.GetStrFlag(flags.PayloadPathFlag))
	}

	if len(flags.GetMultiStrFlag(flags.ExcludePathsFlag)) > 0 {
		excludePaths = append(excludePaths, flags.GetMultiStrFlag(flags.ExcludePathsFlag)...)
	}

	filesSource, err := provider.NewFileSystemSourceProvider(paths, excludePaths)
	if err != nil {
		return nil, err
	}
	return filesSource, nil
}

func getExcludeResultsMap(excludeResults []string) map[string]bool {
	excludeResultsMap := make(map[string]bool)
	for _, er := range excludeResults {
		excludeResultsMap[er] = true
	}
	return excludeResultsMap
}

func createService(
	inspector *engine.Inspector,
	secretsInspector *secrets.Inspector,
	paths []string,
	t kics.Tracker,
	store kics.Storage,
	querySource *source.FilesystemSource) ([]*kics.Service, error) {
	filesSource, err := getFileSystemSourceProvider(paths)
	if err != nil {
		return nil, err
	}

	combinedParser, err := parser.NewBuilder().
		Add(&jsonParser.Parser{}).
		Add(&yamlParser.Parser{}).
		Add(terraformParser.NewDefault()).
		Add(&dockerParser.Parser{}).
		Build(querySource.Types, querySource.CloudProviders)
	if err != nil {
		return nil, err
	}

	// combinedResolver to be used to resolve files and templates
	combinedResolver, err := resolver.NewBuilder().
		Add(&helm.Resolver{}).
		Build()
	if err != nil {
		return nil, err
	}

	services := make([]*kics.Service, 0, len(combinedParser))

	for _, parser := range combinedParser {
		services = append(
			services,
			&kics.Service{
				SourceProvider:   filesSource,
				Storage:          store,
				Parser:           parser,
				Inspector:        inspector,
				SecretsInspector: secretsInspector,
				Tracker:          t,
				Resolver:         combinedResolver,
			},
		)
	}
	return services, nil
}

type startServiceParameters struct {
	t              *tracker.CITracker
	store          kics.Storage
	extractedPaths []string
	progressBar    progress.PBar
	pbBuilder      *progress.PbBuilder
	excludeResults map[string]bool
}

func createQueryFilter() *source.QueryInspectorParameters {
	excludeQueries := source.ExcludeQueries{
		ByIDs:        flags.GetMultiStrFlag(flags.ExcludeQueriesFlag),
		ByCategories: flags.GetMultiStrFlag(flags.ExcludeCategoriesFlag),
		BySeverities: flags.GetMultiStrFlag(flags.ExcludeSeveritiesFlag),
	}

	includeQueries := source.IncludeQueries{
		ByIDs: flags.GetMultiStrFlag(flags.IncludeQueriesFlag),
	}

	queryFilter := source.QueryInspectorParameters{
		IncludeQueries: includeQueries,
		ExcludeQueries: excludeQueries,
		InputDataPath:  flags.GetStrFlag(flags.InputDataFlag),
	}

	return &queryFilter
}

func getSecretsRegexRules(regexRulesPath string) (regexRulesContent string, err error) {
	if len(regexRulesPath) > 0 {
		b, err := os.ReadFile(regexRulesPath)
		if err != nil {
			return regexRulesContent, err
		}
		regexRulesContent = string(b)
	} else {
		regexRulesContent = assets.SecretsQueryRegexRulesJSON
	}

	return regexRulesContent, nil
}

func createServiceAndStartScan(params *startServiceParameters) (failedQueries map[string]error, err error) {
	querySource := source.NewFilesystemSource(
		flags.GetStrFlag(flags.QueriesPath),
		flags.GetMultiStrFlag(flags.TypeFlag),
		flags.GetMultiStrFlag(flags.CloudProviderFlag),
		flags.GetStrFlag(flags.LibrariesPath))

	queryFilter := createQueryFilter()
	inspector, err := engine.NewInspector(ctx,
		querySource,
		engine.DefaultVulnerabilityBuilder,
		params.t,
		queryFilter,
		params.excludeResults,
		flags.GetIntFlag(flags.QueryExecTimeoutFlag),
	)
	if err != nil {
		return failedQueries, err
	}

	secretsRegexRulesContent, err := getSecretsRegexRules(flags.GetStrFlag(flags.SecretsRegexesPathFlag))
	if err != nil {
		return failedQueries, err
	}

	secretsInspector, err := secrets.NewInspector(
		ctx,
		params.excludeResults,
		params.t,
		queryFilter,
		flags.GetBoolFlag(flags.DisableSecretsFlag),
		flags.GetIntFlag(flags.QueryExecTimeoutFlag),
		secretsRegexRulesContent,
	)
	if err != nil {
		log.Err(err)
		return failedQueries, err
	}

	services, err := createService(
		inspector,
		secretsInspector,
		params.extractedPaths,
		params.t,
		params.store,
		querySource,
	)
	if err != nil {
		log.Err(err)
		return failedQueries, err
	}
	params.progressBar.Close()

	if err = scanner.PrepareAndScan(ctx, scanID, *params.pbBuilder, services); err != nil {
		log.Err(err)
		return failedQueries, err
	}
	failedQueries = inspector.GetFailedQueries()
	return failedQueries, nil
}

func scan(changedDefaultQueryPath, changedDefaultLibrariesPath bool) error {
	printer, proBarBuilder, progressBar, scanStartTime := preScan()

	t, err := tracker.NewTracker(flags.GetIntFlag(flags.PreviewLinesFlag))
	if err != nil {
		log.Err(err)
		return err
	}

	store := storage.NewMemoryStorage()
	extractedPaths, err := prepareAndAnalyzePaths(changedDefaultQueryPath, changedDefaultLibrariesPath)
	if err != nil {
		log.Err(err)
		return err
	}

	excludeResultsMap := getExcludeResultsMap(flags.GetMultiStrFlag(flags.ExcludeResultsFlag))

	failedQueries, err := createServiceAndStartScan(&startServiceParameters{
		t:              t,
		store:          store,
		progressBar:    progressBar,
		extractedPaths: extractedPaths.Path,
		pbBuilder:      proBarBuilder,
		excludeResults: excludeResultsMap,
	})
	if err != nil {
		return err
	}

	results, err := store.GetVulnerabilities(ctx, scanID)
	if err != nil {
		log.Err(err)
		return err
	}

	files, err := store.GetFiles(ctx, scanID)
	if err != nil {
		log.Err(err)
		return err
	}

	posScanError := posScan(t, results, scanStartTime, extractedPaths, files, failedQueries, printer, proBarBuilder)
	if posScanError != nil {
		log.Err(posScanError)
		return posScanError
	}

	return nil
}
