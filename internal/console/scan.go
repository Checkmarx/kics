package console

import (
	_ "embed" // Embed kics CLI img
	"fmt"
	"os"
	"os/signal"
	"path/filepath"
	"strings"
	"syscall"
	"time"

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
	"github.com/getsentry/sentry-go"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
	"github.com/spf13/pflag"
	"github.com/spf13/viper"
)

var (
	//go:embed assets/kics-console
	banner string
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

func run(cmd *cobra.Command) error {
	changedDefaultQueryPath := cmd.Flags().Lookup(queriesPath).Changed
	if err := consoleHelpers.InitShouldIgnoreArg(getStrFlag(ignoreOnExitFlag)); err != nil {
		return err
	}
	if err := consoleHelpers.InitShouldFailArg(getMultiStrFlag(failOnFlag)); err != nil {
		return err
	}
	if getStrFlag(outputPathFlag) != "" {
		updateReportFormats()
		setStrFlag(outputNameFlag, filepath.Base(getStrFlag(outputNameFlag)))
		if filepath.Ext(getStrFlag(outputPathFlag)) != "" {
			setStrFlag(outputPathFlag, filepath.Join(getStrFlag(outputPathFlag), string(os.PathSeparator)))
		}
		if err := os.MkdirAll(getStrFlag(outputPathFlag), os.ModePerm); err != nil {
			return err
		}
	}
	if getStrFlag(payloadPathFlag) != "" && filepath.Dir(getStrFlag(payloadPathFlag)) != "." {
		if err := os.MkdirAll(filepath.Dir(getStrFlag(payloadPathFlag)), os.ModePerm); err != nil {
			return err
		}
	}
	gracefulShutdown()
	return scan(changedDefaultQueryPath)
}

func preRun(cmd *cobra.Command) error {
	err := initializeConfig(cmd)
	if err != nil {
		return errors.New(initError + err.Error())
	}
	err = validateQuerySelectionFlags()
	if err != nil {
		return err
	}
	err = internalPrinter.SetupPrinter(cmd.InheritedFlags())
	if err != nil {
		return errors.New(initError + err.Error())
	}
	err = metrics.InitializeMetrics(cmd.InheritedFlags().Lookup("profiling"), cmd.InheritedFlags().Lookup("ci"))
	if err != nil {
		return errors.New(initError + err.Error())
	}
	return nil
}

func formatNewError(flag1, flag2 string) error {
	return errors.Errorf("can't provide '%s' and '%s' flags simultaneously",
		flag1,
		flag2)
}

func updateReportFormats() {
	for _, format := range getMultiStrFlag(reportFormatsFlag) {
		if format == "all" {
			setMultiStrFlag(reportFormatsFlag, consoleHelpers.ListReportFormats())
			break
		}
	}
}

func validateQuerySelectionFlags() error {
	if len(getMultiStrFlag(includeQueriesFlag)) > 0 && len(getMultiStrFlag(excludeQueriesFlag)) > 0 {
		return formatNewError(includeQueriesFlag, excludeQueriesFlag)
	}
	if len(getMultiStrFlag(includeQueriesFlag)) > 0 && len(getMultiStrFlag(excludeCategoriesFlag)) > 0 {
		return formatNewError(includeQueriesFlag, excludeCategoriesFlag)
	}
	return nil
}

func initializeConfig(cmd *cobra.Command) error {
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

	base := filepath.Base(getStrFlag(configFlag))
	v.SetConfigName(base)
	v.AddConfigPath(filepath.Dir(getStrFlag(configFlag)))
	ext, err := consoleHelpers.FileAnalyzer(getStrFlag(configFlag))
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
	if getStrFlag(configFlag) == "" {
		path := getMultiStrFlag(pathFlag)
		if len(path) == 0 {
			return true, nil
		}
		if len(path) > 1 {
			warnings = append(warnings, "Any kics.config file will be ignored, please use --config if kics.config is wanted")
			return true, nil
		}
		configpath := path[0]
		info, err := os.Stat(configpath)
		if err != nil {
			return true, nil
		}
		if !info.IsDir() {
			configpath = filepath.Dir(configpath)
		}
		_, err = os.Stat(filepath.ToSlash(filepath.Join(configpath, constants.DefaultConfigFilename)))
		if err != nil {
			if os.IsNotExist(err) {
				return true, nil
			}
			return true, err
		}
		setStrFlag(configFlag, filepath.ToSlash(filepath.Join(configpath, constants.DefaultConfigFilename)))
	}
	return false, nil
}

func bindFlags(cmd *cobra.Command, v *viper.Viper) error {
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
	if err := initJSONFlags(scanCmd); err != nil {
		return err
	}

	if err := scanCmd.MarkFlagRequired(pathFlag); err != nil {
		sentry.CaptureException(err)
		log.Err(err).Msg("Failed to add command required flags")
	}
	return nil
}

func getFileSystemSourceProvider(paths []string) (*provider.FileSystemSourceProvider, error) {
	var excludePaths []string
	if getStrFlag(payloadPathFlag) != "" {
		excludePaths = append(excludePaths, getStrFlag(payloadPathFlag))
	}

	if len(getMultiStrFlag(excludePathsFlag)) > 0 {
		excludePaths = append(excludePaths, getMultiStrFlag(excludePathsFlag)...)
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

func createInspector(t engine.Tracker, querySource source.QueriesSource) (*engine.Inspector, error) {
	excludeResultsMap := getExcludeResultsMap(getMultiStrFlag(excludeResultsFlag))

	excludeQueries := source.ExcludeQueries{
		ByIDs:        getMultiStrFlag(excludeQueriesFlag),
		ByCategories: getMultiStrFlag(excludeCategoriesFlag),
	}

	includeQueries := source.IncludeQueries{
		ByIDs: getMultiStrFlag(includeQueriesFlag),
	}

	queryFilter := source.QueryInspectorParameters{
		IncludeQueries: includeQueries,
		ExcludeQueries: excludeQueries,
		InputDataPath:  getStrFlag(inputDataFlag),
	}

	inspector, err := engine.NewInspector(ctx,
		querySource,
		engine.DefaultVulnerabilityBuilder,
		t,
		&queryFilter,
		excludeResultsMap,
		getIntFlag(queryExecTimeoutFlag),
	)
	if err != nil {
		return nil, err
	}
	return inspector, nil
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

func createService(inspector *engine.Inspector,
	paths []string,
	t kics.Tracker,
	store kics.Storage,
	querySource source.FilesystemSource) ([]*kics.Service, error) {
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
		services = append(services, &kics.Service{
			SourceProvider: filesSource,
			Storage:        store,
			Parser:         parser,
			Inspector:      inspector,
			Tracker:        t,
			Resolver:       combinedResolver,
		})
	}
	return services, nil
}

type startServiceParameters struct {
	t              *tracker.CITracker
	store          kics.Storage
	querySource    *source.FilesystemSource
	extractedPaths []string
	progressBar    progress.PBar
	pbBuilder      *progress.PbBuilder
}

func createServiceAndStartScan(params *startServiceParameters) (*engine.Inspector, error) {
	inspector, err := createInspector(params.t, params.querySource)
	if err != nil {
		log.Err(err)
		return &engine.Inspector{}, err
	}

	services, err := createService(inspector, params.extractedPaths, params.t, params.store, *params.querySource)
	if err != nil {
		log.Err(err)
		return &engine.Inspector{}, err
	}
	params.progressBar.Close()

	if err = scanner.StartScan(ctx, scanID, *params.pbBuilder, services); err != nil {
		log.Err(err)
		return &engine.Inspector{}, err
	}
	return inspector, nil
}

func scan(changedDefaultQueryPath bool) error {
	log.Debug().Msg("console.scan()")
	for _, warn := range warnings {
		log.Warn().Msgf(warn)
	}

	printer := consoleHelpers.NewPrinter(getBoolFlag(minimalUIFlag))
	printer.Success.Printf("\n%s\n", banner)

	versionMsg := fmt.Sprintf("\nScanning with %s\n\n", constants.GetVersion())
	fmt.Println(versionMsg)
	log.Info().Msgf(strings.ReplaceAll(versionMsg, "\n", ""))

	proBarBuilder := progress.InitializePbBuilder(getBoolFlag(noProgressFlag), ci, silent)

	scanStartTime := time.Now()
	progressBar := proBarBuilder.BuildCircle("Preparing Scan Assets: ")
	progressBar.Start()

	t, err := tracker.NewTracker(getIntFlag(previewLinesFlag))
	if err != nil {
		log.Err(err)
		return err
	}

	if changedDefaultQueryPath {
		log.Debug().Msgf("Trying to load queries from %s", getStrFlag(queriesPath))
	} else {
		log.Debug().Msgf("Looking for queries in executable path and in current work directory")
		newQueryPath, errDefaultQueryPath := consoleHelpers.GetDefaultQueryPath(getStrFlag(queriesPath))
		if errDefaultQueryPath != nil {
			return errors.Wrap(errDefaultQueryPath, "unable to find queries")
		}
		setStrFlag(queriesPath, newQueryPath)
	}

	extractedPaths, err := provider.GetSources(getMultiStrFlag(pathFlag))
	if err != nil {
		return err
	}

	newTypeFlagValue, newExcludePathsFlagValue, errAnalyze :=
		analyzePaths(extractedPaths.Path, getMultiStrFlag(typeFlag), getMultiStrFlag(excludePathsFlag))
	if errAnalyze != nil {
		return errAnalyze
	}
	setMultiStrFlag(typeFlag, newTypeFlagValue)
	setMultiStrFlag(excludePathsFlag, newExcludePathsFlagValue)

	querySource := source.NewFilesystemSource(
		getStrFlag(queriesPath),
		getMultiStrFlag(typeFlag),
		getMultiStrFlag(cloudProviderFlag),
	)
	store := storage.NewMemoryStorage()

	inspector, err := createServiceAndStartScan(&startServiceParameters{
		t:              t,
		store:          store,
		querySource:    querySource,
		progressBar:    progressBar,
		extractedPaths: extractedPaths.Path,
		pbBuilder:      proBarBuilder,
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
		ScannedPaths:      getMultiStrFlag(pathFlag),
		PathExtractionMap: extractedPaths.ExtractionMap,
	})

	if err := resolveOutputs(&summary, files.Combine(), inspector.GetFailedQueries(), printer, *proBarBuilder); err != nil {
		log.Err(err)
		return err
	}

	printScanDuration(time.Since(scanStartTime))

	exitCode := consoleHelpers.ResultsExitCode(&summary)
	if consoleHelpers.ShowError("results") && exitCode != 0 {
		os.Exit(exitCode)
	}
	return nil
}

func printScanDuration(elapsed time.Duration) {
	if ci {
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
	summary.ScannedPaths = pathParameters.ScannedPaths

	if getBoolFlag(disableCISDescFlag) {
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
	log.Debug().Msg("console.resolveOutputs()")

	if err := consoleHelpers.PrintResult(summary, failedQueries, printer); err != nil {
		return err
	}
	if getStrFlag(payloadPathFlag) != "" {
		if err := report.ExportJSONReport(
			filepath.Dir(getStrFlag(payloadPathFlag)),
			filepath.Base(getStrFlag(payloadPathFlag)),
			documents,
		); err != nil {
			return err
		}
	}

	return printOutput(getStrFlag(outputPathFlag), getStrFlag(outputNameFlag), summary, getMultiStrFlag(reportFormatsFlag), proBarBuilder)
}

func printOutput(outputPath, filename string, body interface{}, formats []string, proBarBuilder progress.PbBuilder) error {
	log.Debug().Msg("console.printOutput()")
	if outputPath == "" {
		return nil
	}
	if len(formats) == 0 {
		formats = []string{"json"}
	}

	log.Debug().Msgf("Output formats provided [%v]", strings.Join(formats, ","))

	err := consoleHelpers.ValidateReportFormats(formats)
	if err == nil {
		err = consoleHelpers.GenerateReport(outputPath, filename, body, formats, proBarBuilder)
	}
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
