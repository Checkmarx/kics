package console

import (
	_ "embed" // Embed kics CLI img and scan-flags
	"fmt"
	"os"
	"os/signal"
	"path/filepath"
	"strings"
	"syscall"
	"time"

	"github.com/Checkmarx/kics/assets"
	"github.com/Checkmarx/kics/internal/console/flags"
	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	internalPrinter "github.com/Checkmarx/kics/internal/console/printer"
	"github.com/Checkmarx/kics/internal/constants"
	"github.com/Checkmarx/kics/internal/metrics"
	"github.com/Checkmarx/kics/internal/storage"
	"github.com/Checkmarx/kics/internal/tracker"
	"github.com/Checkmarx/kics/pkg/analyzer"
	"github.com/Checkmarx/kics/pkg/descriptions"
	"github.com/Checkmarx/kics/pkg/engine"
	"github.com/Checkmarx/kics/pkg/engine/provider"
	"github.com/Checkmarx/kics/pkg/engine/secrets"
	"github.com/Checkmarx/kics/pkg/engine/source"
	"github.com/Checkmarx/kics/pkg/kics"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/parser"
	dockerParser "github.com/Checkmarx/kics/pkg/parser/docker"
	jsonParser "github.com/Checkmarx/kics/pkg/parser/json"
	terraformParser "github.com/Checkmarx/kics/pkg/parser/terraform"
	yamlParser "github.com/Checkmarx/kics/pkg/parser/yaml"
	"github.com/Checkmarx/kics/pkg/progress"
	"github.com/Checkmarx/kics/pkg/report"
	"github.com/Checkmarx/kics/pkg/resolver"
	"github.com/Checkmarx/kics/pkg/resolver/helm"
	"github.com/Checkmarx/kics/pkg/scanner"
	"github.com/Checkmarx/kics/pkg/utils"
	"github.com/getsentry/sentry-go"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
	"github.com/spf13/pflag"
	"github.com/spf13/viper"
	"golang.org/x/term"
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
			defer utils.PanicHandler()
			return preRun(cmd)
		},
		RunE: func(cmd *cobra.Command, args []string) error {
			defer utils.PanicHandler()
			return run(cmd)
		},
	}
}

func run(cmd *cobra.Command) error {
	defer utils.PanicHandler()
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

func preRun(cmd *cobra.Command) error {
	defer utils.PanicHandler()
	err := initializeConfig(cmd)
	if err != nil {
		return errors.New(initError + err.Error())
	}

	err = flags.Validate()
	if err != nil {
		return err
	}

	err = validateQuerySelectionFlags()
	if err != nil {
		return err
	}
	err = internalPrinter.SetupPrinter(cmd.InheritedFlags())
	if err != nil {
		return errors.New(initError + err.Error())
	}
	err = metrics.InitializeMetrics(flags.GetStrFlag(flags.ProfilingFlag), flags.GetStrFlag(flags.CIFlag))
	if err != nil {
		return errors.New(initError + err.Error())
	}
	return nil
}

func formatNewError(flag1, flag2 string) error {
	defer utils.PanicHandler()
	return errors.Errorf("can't provide '%s' and '%s' flags simultaneously",
		flag1,
		flag2)
}

func updateReportFormats() {
	for _, format := range flags.GetMultiStrFlag(flags.ReportFormatsFlag) {
		if format == "all" {
			flags.SetMultiStrFlag(flags.ReportFormatsFlag, consoleHelpers.ListReportFormats())
			break
		}
	}
}

func validateQuerySelectionFlags() error {
	defer utils.PanicHandler()
	if len(flags.GetMultiStrFlag(flags.IncludeQueriesFlag)) > 0 && len(flags.GetMultiStrFlag(flags.ExcludeQueriesFlag)) > 0 {
		return formatNewError(flags.IncludeQueriesFlag, flags.ExcludeQueriesFlag)
	}
	if len(flags.GetMultiStrFlag(flags.IncludeQueriesFlag)) > 0 && len(flags.GetMultiStrFlag(flags.ExcludeCategoriesFlag)) > 0 {
		return formatNewError(flags.IncludeQueriesFlag, flags.ExcludeCategoriesFlag)
	}
	return nil
}

func initializeConfig(cmd *cobra.Command) error {
	defer utils.PanicHandler()
	log.Debug().Msg("console.initializeConfig()")

	v := viper.New()
	v.SetEnvPrefix("KICS")
	v.AutomaticEnv()
	errBind := bindFlags(cmd, v)
	if errBind != nil {
		return errBind
	}

	exit, err := setupCfgFile()
	if err != nil {
		return err
	}
	if exit {
		return nil
	}

	base := filepath.Base(flags.GetStrFlag(flags.ConfigFlag))
	v.SetConfigName(base)
	v.AddConfigPath(filepath.Dir(flags.GetStrFlag(flags.ConfigFlag)))
	ext, err := consoleHelpers.FileAnalyzer(flags.GetStrFlag(flags.ConfigFlag))
	if err != nil {
		return err
	}
	v.SetConfigType(ext)
	if err := v.ReadInConfig(); err != nil {
		return err
	}

	errBind = bindFlags(cmd, v)
	if errBind != nil {
		return errBind
	}
	return nil
}

func setupCfgFile() (bool, error) {
	if flags.GetStrFlag(flags.ConfigFlag) == "" {
		path := flags.GetMultiStrFlag(flags.PathFlag)
		if len(path) == 0 {
			return true, nil
		}
		if len(path) > 1 {
			warnings = append(warnings, "Any kics.config file will be ignored, please use --config if kics.config is wanted")
			return true, nil
		}
		configPath := path[0]
		info, err := os.Stat(configPath)
		if err != nil {
			return true, nil
		}
		if !info.IsDir() {
			configPath = filepath.Dir(configPath)
		}
		_, err = os.Stat(filepath.ToSlash(filepath.Join(configPath, constants.DefaultConfigFilename)))
		if err != nil {
			if os.IsNotExist(err) {
				return true, nil
			}
			return true, err
		}
		flags.SetStrFlag(flags.ConfigFlag, filepath.ToSlash(filepath.Join(configPath, constants.DefaultConfigFilename)))
	}
	return false, nil
}

func bindFlags(cmd *cobra.Command, v *viper.Viper) error {
	defer utils.PanicHandler()
	log.Debug().Msg("console.bindFlags()")
	settingsMap := v.AllSettings()
	cmd.Flags().VisitAll(func(f *pflag.Flag) {
		settingsMap[f.Name] = true
		if strings.Contains(f.Name, "-") {
			envVarSuffix := strings.ToUpper(strings.ReplaceAll(f.Name, "-", "_"))
			variableName := fmt.Sprintf("%s_%s", "KICS", envVarSuffix)
			if err := v.BindEnv(f.Name, variableName); err != nil {
				log.Err(err).Msg("Failed to bind Viper flags")
			}
		}
		if !f.Changed && v.IsSet(f.Name) {
			val := v.Get(f.Name)
			setBoundFlags(f.Name, val, cmd)
		}
	})
	for key, val := range settingsMap {
		if val == true {
			continue
		} else {
			return fmt.Errorf("unknown configuration key: '%s'\nShowing help for '%s' command", key, cmd.Name())
		}
	}
	return nil
}

func setBoundFlags(flagName string, val interface{}, cmd *cobra.Command) {
	switch t := val.(type) {
	case []interface{}:
		var paramSlice []string
		for _, param := range t {
			paramSlice = append(paramSlice, param.(string))
		}
		valStr := strings.Join(paramSlice, ",")
		if err := cmd.Flags().Set(flagName, fmt.Sprintf("%v", valStr)); err != nil {
			log.Err(err).Msg("Failed to get Viper flags")
		}
	default:
		if err := cmd.Flags().Set(flagName, fmt.Sprintf("%v", val)); err != nil {
			log.Err(err).Msg("Failed to get Viper flags")
		}
	}
}

func initScanCmd(scanCmd *cobra.Command) error {
	defer utils.PanicHandler()
	if err := flags.InitJSONFlags(scanCmd, scanFlagsListContent, false); err != nil {
		return err
	}

	if err := scanCmd.MarkFlagRequired(flags.PathFlag); err != nil {
		sentry.CaptureException(err)
		log.Err(err).Msg("Failed to add command required flags")
	}
	return nil
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

// analyzePaths will analyze the paths to scan to determine which type of queries to load
// and which files should be ignored, it then updates the types and exclude flags variables
// with the results found
func analyzePaths(paths, types, exclude []string) (typesRes, excludeRes []string, errRes error) {
	var err error
	exc := make([]string, 0)
	if types[0] == "" { // if '--type' flag was given skip file analyzing
		types, exc, err = analyzer.Analyze(paths)
		if err != nil {
			log.Err(err)
			return []string{}, []string{}, err
		}
		log.Info().Msgf("Loading queries of type: %s", strings.Join(types, ", "))
	}
	exclude = append(exclude, exc...)
	return types, exclude, nil
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

func resolvePath(flagName string) (string, error) {
	extractedPath, errExtractPath := provider.GetSources([]string{flags.GetStrFlag(flagName)})
	if errExtractPath != nil {
		return "", errExtractPath
	}
	if len(extractedPath.Path) != 1 {
		return "", fmt.Errorf("could not find a valid path (--%s) on %s", flagName, flags.GetStrFlag(flagName))
	}
	log.Debug().Msgf("Trying to load path (--%s) from %s", flagName, flags.GetStrFlag(flagName))
	return extractedPath.Path[0], nil
}

func getQueryPath(changedDefaultQueryPath bool) error {
	defer utils.PanicHandler()
	if changedDefaultQueryPath {
		extractedQueriesPath, errExtractQueries := resolvePath(flags.QueriesPath)
		if errExtractQueries != nil {
			return errExtractQueries
		}
		flags.SetStrFlag(flags.QueriesPath, extractedQueriesPath)
	} else {
		log.Debug().Msgf("Looking for queries in executable path and in current work directory")
		defaultQueryPath, errDefaultQueryPath := consoleHelpers.GetDefaultQueryPath(flags.GetStrFlag(flags.QueriesPath))
		if errDefaultQueryPath != nil {
			return errors.Wrap(errDefaultQueryPath, "unable to find queries")
		}
		flags.SetStrFlag(flags.QueriesPath, defaultQueryPath)
	}
	return nil
}

func getLibraryPath(changedDefaultLibrariesPath bool) error {
	defer utils.PanicHandler()
	if changedDefaultLibrariesPath {
		extractedLibrariesPath, errExtractLibraries := resolvePath(flags.LibrariesPath)
		if errExtractLibraries != nil {
			return errExtractLibraries
		}
		flags.SetStrFlag(flags.LibrariesPath, extractedLibrariesPath)
	}
	return nil
}

func preparePaths(changedDefaultQueryPath, changedDefaultLibrariesPath bool) error {
	defer utils.PanicHandler()
	var err error
	err = getQueryPath(changedDefaultQueryPath)
	if err != nil {
		return err
	}
	err = getLibraryPath(changedDefaultLibrariesPath)
	if err != nil {
		return err
	}
	return nil
}

func prepareAndAnalyzePaths(changedDefaultQueryPath, changedDefaultLibrariesPath bool) (extractedPaths provider.ExtractedPath, err error) {
	err = preparePaths(changedDefaultQueryPath, changedDefaultLibrariesPath)
	if err != nil {
		return extractedPaths, err
	}

	extractedPaths, err = provider.GetSources(flags.GetMultiStrFlag(flags.PathFlag))
	if err != nil {
		return extractedPaths, err
	}

	newTypeFlagValue, newExcludePathsFlagValue, errAnalyze :=
		analyzePaths(
			extractedPaths.Path,
			flags.GetMultiStrFlag(flags.TypeFlag),
			flags.GetMultiStrFlag(flags.ExcludePathsFlag),
		)
	if errAnalyze != nil {
		return extractedPaths, errAnalyze
	}
	flags.SetMultiStrFlag(flags.TypeFlag, newTypeFlagValue)
	flags.SetMultiStrFlag(flags.ExcludePathsFlag, newExcludePathsFlagValue)
	return extractedPaths, nil
}

func scan(changedDefaultQueryPath, changedDefaultLibrariesPath bool) error {
	log.Debug().Msg("console.scan()")
	for _, warn := range warnings {
		log.Warn().Msgf(warn)
	}

	printer := consoleHelpers.NewPrinter(flags.GetBoolFlag(flags.MinimalUIFlag))
	printer.Success.Printf("\n%s\n", banner)

	versionMsg := fmt.Sprintf("\nScanning with %s\n\n", constants.GetVersion())
	fmt.Println(versionMsg)
	log.Info().Msgf(strings.ReplaceAll(versionMsg, "\n", ""))

	noProgress := flags.GetBoolFlag(flags.NoProgressFlag)
	if !term.IsTerminal(int(os.Stdin.Fd())) {
		noProgress = true
	}

	proBarBuilder := progress.InitializePbBuilder(
		noProgress,
		flags.GetBoolFlag(flags.CIFlag),
		flags.GetBoolFlag(flags.SilentFlag))

	scanStartTime := time.Now()
	progressBar := proBarBuilder.BuildCircle("Preparing Scan Assets: ")
	progressBar.Start()

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

	summary := getSummary(t, results, scanStartTime, time.Now(), model.PathParameters{
		ScannedPaths:      flags.GetMultiStrFlag(flags.PathFlag),
		PathExtractionMap: extractedPaths.ExtractionMap,
	})

	if err := resolveOutputs(
		&summary,
		files.Combine(flags.GetBoolFlag(flags.LineInfoPayloadFlag)),
		failedQueries,
		printer,
		*proBarBuilder); err != nil {
		log.Err(err)
		return err
	}

	printScanDuration(time.Since(scanStartTime))

	exitCode := consoleHelpers.ResultsExitCode(&summary)
	if consoleHelpers.ShowError("results") && exitCode != 0 {
		os.Exit(exitCode)
	}
	defer utils.PanicHandler()
	return nil
}

func printScanDuration(elapsed time.Duration) {
	if flags.GetBoolFlag(flags.CIFlag) {
		elapsedStrFormat := "Scan duration: %vms\n"
		fmt.Printf(elapsedStrFormat, elapsed.Milliseconds())
		log.Info().Msgf(elapsedStrFormat, elapsed.Milliseconds())
	} else {
		elapsedStrFormat := "Scan duration: %v\n"
		fmt.Printf(elapsedStrFormat, elapsed)
		log.Info().Msgf(elapsedStrFormat, elapsed)
	}
}

func getSummary(t *tracker.CITracker, results []model.Vulnerability, start, end time.Time,
	pathParameters model.PathParameters) model.Summary {
	counters := model.Counters{
		ScannedFiles:           t.FoundFiles,
		ParsedFiles:            t.ParsedFiles,
		TotalQueries:           t.LoadedQueries,
		FailedToExecuteQueries: t.ExecutingQueries - t.ExecutedQueries,
		FailedSimilarityID:     t.FailedSimilarityID,
	}

	summary := model.CreateSummary(counters, results, scanID, pathParameters.PathExtractionMap)
	summary.Times = model.Times{
		Start: start,
		End:   end,
	}

	if flags.GetBoolFlag(flags.DisableCISDescFlag) || flags.GetBoolFlag(flags.DisableFullDescFlag) {
		log.Warn().Msg("Skipping CIS descriptions because provided disable flag is set")
	} else {
		err := descriptions.RequestAndOverrideDescriptions(&summary)
		if err != nil {
			log.Warn().Msgf("Unable to get descriptions: %s", err)
			log.Warn().Msgf("Using default descriptions")
		}
	}

	return summary
}

func resolveOutputs(
	summary *model.Summary,
	documents model.Documents,
	failedQueries map[string]error,
	printer *consoleHelpers.Printer,
	proBarBuilder progress.PbBuilder,
) error {
	defer utils.PanicHandler()
	log.Debug().Msg("console.resolveOutputs()")

	if err := consoleHelpers.PrintResult(summary, failedQueries, printer); err != nil {
		return err
	}
	if flags.GetStrFlag(flags.PayloadPathFlag) != "" {
		if err := report.ExportJSONReport(
			filepath.Dir(flags.GetStrFlag(flags.PayloadPathFlag)),
			filepath.Base(flags.GetStrFlag(flags.PayloadPathFlag)),
			documents,
		); err != nil {
			return err
		}
	}

	return printOutput(
		flags.GetStrFlag(flags.OutputPathFlag),
		flags.GetStrFlag(flags.OutputNameFlag),
		summary, flags.GetMultiStrFlag(flags.ReportFormatsFlag),
		proBarBuilder,
	)
}

func printOutput(outputPath, filename string, body interface{}, formats []string, proBarBuilder progress.PbBuilder) error {
	defer utils.PanicHandler()
	log.Debug().Msg("console.printOutput()")
	if outputPath == "" {
		return nil
	}
	if len(formats) == 0 {
		formats = []string{"json"}
	}

	log.Debug().Msgf("Output formats provided [%v]", strings.Join(formats, ","))
	err := consoleHelpers.GenerateReport(outputPath, filename, body, formats, proBarBuilder)

	return err
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
