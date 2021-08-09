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
	//go:embed img/kics-console
	banner string

	cloudProviders         []string
	cfgFile                string
	excludeCategories      []string
	excludeIDs             []string
	excludePath            []string
	excludeResults         []string
	includeIDs             []string
	failOn                 []string
	ignoreOnExit           string
	min                    bool
	noProgress             bool
	outputName             string
	outputPath             string
	path                   []string
	payloadPath            string
	previewLines           int
	queryPath              string
	reportFormats          []string
	types                  []string
	queryExecTimeout       int
	inputData              string
	disableCISDescriptions bool
)

const (
	configFlag              = "config"
	excludeCategoriesFlag   = "exclude-categories"
	excludePathsFlag        = "exclude-paths"
	excludePathsShorthand   = "e"
	excludeQueriesFlag      = "exclude-queries"
	excludeResultsFlag      = "exclude-results"
	excludeResutlsShorthand = "x"
	includeQueriesFlag      = "include-queries"
	includeQueriesShorthand = "i"
	inputDataFlag           = "input-data"
	failOnFlag              = "fail-on"
	ignoreOnExitFlag        = "ignore-on-exit"
	minimalUIFlag           = "minimal-ui"
	noProgressFlag          = "no-progress"
	outputNameFlag          = "output-name"
	outputPathFlag          = "output-path"
	outputPathShorthand     = "o"
	pathFlag                = "path"
	pathFlagShorthand       = "p"
	payloadPathFlag         = "payload-path"
	payloadPathShorthand    = "d"
	previewLinesFlag        = "preview-lines"
	queriesPathCmdName      = "queries-path"
	queriesPathShorthand    = "q"
	reportFormatsFlag       = "report-formats"
	scanCommandStr          = "scan"
	typeShorthand           = "t"
	queryExecTimeoutFlag    = "timeout"
	disableCISDescFlag      = "disable-cis-descriptions"
	initError               = "initialization error - "
	msg                     = "can be provided multiple times or as a comma separated string\n"

	defaultPreviewLines     = 3
	defaultQueryExecTimeout = 60
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
	changedDefaultQueryPath := cmd.Flags().Lookup(queriesPathCmdName).Changed
	if err := consoleHelpers.InitShouldIgnoreArg(ignoreOnExit); err != nil {
		return err
	}
	if err := consoleHelpers.InitShouldFailArg(failOn); err != nil {
		return err
	}
	if outputPath != "" {
		updateReportFormats()
		outputName = filepath.Base(outputName)
		if filepath.Ext(outputPath) != "" {
			outputPath = filepath.Join(outputPath, string(os.PathSeparator))
		}
		if err := os.MkdirAll(outputPath, os.ModePerm); err != nil {
			return err
		}
	}
	if payloadPath != "" && filepath.Dir(payloadPath) != "." {
		if err := os.MkdirAll(filepath.Dir(payloadPath), os.ModePerm); err != nil {
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
	for _, format := range reportFormats {
		if format == "all" {
			reportFormats = consoleHelpers.ListReportFormats()
			break
		}
	}
}

func validateQuerySelectionFlags() error {
	if len(includeIDs) > 0 && len(excludeIDs) > 0 {
		return formatNewError(includeQueriesFlag, excludeQueriesFlag)
	}
	if len(includeIDs) > 0 && len(excludeCategories) > 0 {
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

	base := filepath.Base(cfgFile)
	v.SetConfigName(base)
	v.AddConfigPath(filepath.Dir(cfgFile))
	ext, err := consoleHelpers.FileAnalyzer(cfgFile)
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
	if cfgFile == "" {
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
		cfgFile = filepath.ToSlash(filepath.Join(configpath, constants.DefaultConfigFilename))
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

func initScanFlags(scanCmd *cobra.Command) {
	types = []string{"openapi"}

	scanCmd.Flags().StringVar(&cfgFile,
		configFlag, "",
		"path to configuration file")
	scanCmd.Flags().IntVar(&queryExecTimeout,
		queryExecTimeoutFlag,
		defaultQueryExecTimeout,
		"number of seconds the query has to execute before being canceled")
	scanCmd.Flags().StringVar(&inputData,
		inputDataFlag,
		"",
		"path to query input data files")
	scanCmd.Flags().BoolVar(&disableCISDescriptions,
		disableCISDescFlag,
		false,
		"disable request for CIS descriptions and use default vulnerability descriptions")
	initPathsFlags(scanCmd)
	initStdoutFlags(scanCmd)
	initOutputFlags(scanCmd)
	initInclusionFlags(scanCmd)
	initExitStatusFlags(scanCmd)
}

func initOutputFlags(scanCmd *cobra.Command) {
	scanCmd.Flags().StringVar(&outputName,
		outputNameFlag,
		"results",
		"name used on report creations")
	scanCmd.Flags().StringVarP(&outputPath,
		outputPathFlag,
		outputPathShorthand,
		"",
		"directory path to store reports")
	scanCmd.Flags().StringSliceVar(&reportFormats, reportFormatsFlag, []string{"json"},
		"formats in which the results will be exported (all, json, sarif, html, glsast, pdf)",
	)
}

func initStdoutFlags(scanCmd *cobra.Command) {
	scanCmd.Flags().IntVar(&previewLines,
		previewLinesFlag,
		defaultPreviewLines,
		"number of lines to be display in CLI results (min: 1, max: 30)")
	scanCmd.Flags().StringVarP(&payloadPath,
		payloadPathFlag, payloadPathShorthand,
		"",
		"path to store internal representation JSON file")
	scanCmd.Flags().BoolVar(&min,
		minimalUIFlag,
		false,
		"simplified version of CLI output")
	scanCmd.Flags().BoolVar(&noProgress,
		noProgressFlag,
		false,
		"hides the progress bar")
}

func initPathsFlags(scanCmd *cobra.Command) {
	scanCmd.Flags().StringSliceVarP(&path,
		pathFlag, pathFlagShorthand,
		[]string{},
		"paths or directories to scan\nexample: \"./somepath,somefile.txt\"")
	scanCmd.Flags().StringSliceVarP(&excludePath,
		excludePathsFlag, excludePathsShorthand,
		[]string{},
		"exclude paths from scan\nsupports glob and can be provided multiple times or as a quoted comma separated string"+
			"\nexample: './shouldNotScan/*,somefile.txt'",
	)
	scanCmd.Flags().StringVarP(&queryPath,
		queriesPathCmdName, queriesPathShorthand,
		"./assets/queries",
		"path to directory with queries",
	)
}

func initInclusionFlags(scanCmd *cobra.Command) {
	scanCmd.Flags().StringSliceVar(&excludeIDs,
		excludeQueriesFlag,
		[]string{},
		"exclude queries by providing the query ID\n"+"cannot be provided with query inclusion flags\n"+
			msg+
			"example: 'e69890e6-fce5-461d-98ad-cb98318dfc96,4728cd65-a20c-49da-8b31-9c08b423e4db'",
	)
	scanCmd.Flags().StringSliceVarP(&includeIDs,
		includeQueriesFlag,
		includeQueriesShorthand,
		[]string{},
		"include queries by providing the query ID\n"+"cannot be provided with query exclusion flags\n"+
			msg+
			"example: 'e69890e6-fce5-461d-98ad-cb98318dfc96,4728cd65-a20c-49da-8b31-9c08b423e4db'",
	)
	scanCmd.Flags().StringSliceVarP(&excludeResults,
		excludeResultsFlag,
		excludeResutlsShorthand,
		[]string{},
		"exclude results by providing the similarity ID of a result\n"+
			msg+
			"example: 'fec62a97d569662093dbb9739360942f...,31263s5696620s93dbb973d9360942fc2a...'",
	)
	scanCmd.Flags().StringSliceVar(&excludeCategories,
		excludeCategoriesFlag,
		[]string{},
		"exclude categories by providing its name\n"+
			"cannot be provided with query inclusion flags\n"+
			msg+
			"example: 'Access control,Best practices'",
	)
}

func initExitStatusFlags(scanCmd *cobra.Command) {
	scanCmd.Flags().StringSliceVar(&failOn,
		failOnFlag,
		[]string{"high", "medium", "low", "info"},
		"which kind of results should return an exit code different from 0\n"+
			"accetps: high, medium, low and info\n"+
			"example: \"high,low\"",
	)
	scanCmd.Flags().StringVar(&ignoreOnExit,
		ignoreOnExitFlag,
		"none",
		"defines which kind of non-zero exits code should be ignored\n"+"accepts: all, results, errors, none\n"+
			"example: if 'results' is set, only engine errors will make KICS exit code different from 0",
	)
}

func initScanCmd(scanCmd *cobra.Command) {
	initScanFlags(scanCmd)

	if err := scanCmd.MarkFlagRequired("path"); err != nil {
		sentry.CaptureException(err)
		log.Err(err).Msg("Failed to add command required flags")
	}
}

func getFileSystemSourceProvider(paths []string) (*provider.FileSystemSourceProvider, error) {
	var excludePaths []string
	if payloadPath != "" {
		excludePaths = append(excludePaths, payloadPath)
	}

	if len(excludePath) > 0 {
		excludePaths = append(excludePaths, excludePath...)
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
	excludeResultsMap := getExcludeResultsMap(excludeResults)

	excludeQueries := source.ExcludeQueries{
		ByIDs:        excludeIDs,
		ByCategories: excludeCategories,
	}

	includeQueries := source.IncludeQueries{
		ByIDs: includeIDs,
	}

	queryFilter := source.QueryInspectorParameters{
		IncludeQueries: includeQueries,
		ExcludeQueries: excludeQueries,
		InputDataPath:  inputData,
	}

	inspector, err := engine.NewInspector(ctx,
		querySource,
		engine.DefaultVulnerabilityBuilder,
		t,
		&queryFilter,
		excludeResultsMap,
		queryExecTimeout)
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

	printer := consoleHelpers.NewPrinter(min)
	printer.Success.Printf("\n%s\n", banner)

	versionMsg := fmt.Sprintf("\nScanning with %s\n\n", constants.GetVersion())
	fmt.Println(versionMsg)
	log.Info().Msgf(strings.ReplaceAll(versionMsg, "\n", ""))

	proBarBuilder := progress.InitializePbBuilder(noProgress, ci, silent)

	scanStartTime := time.Now()
	progressBar := proBarBuilder.BuildCircle("Preparing Scan Assets: ")
	progressBar.Start()

	t, err := tracker.NewTracker(previewLines)
	if err != nil {
		log.Err(err)
		return err
	}

	if changedDefaultQueryPath {
		log.Debug().Msgf("Trying to load queries from %s", queryPath)
	} else {
		log.Debug().Msgf("Looking for queries in executable path and in current work directory")
		queryPath, err = consoleHelpers.GetDefaultQueryPath(queryPath)
		if err != nil {
			return errors.Wrap(err, "unable to find queries")
		}
	}

	extractedPaths, err := provider.GetSources(path)
	if err != nil {
		return err
	}

	if types, excludePath, err = analyzePaths(extractedPaths.Path, types, excludePath); err != nil {
		return err
	}

	cloudProviders = make([]string, 0)
	querySource := source.NewFilesystemSource(queryPath, types, cloudProviders)
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
		ScannedPaths:      path,
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

	if disableCISDescriptions {
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
	if payloadPath != "" {
		if err := report.ExportJSONReport(filepath.Dir(payloadPath), filepath.Base(payloadPath), documents); err != nil {
			return err
		}
	}

	return printOutput(outputPath, outputName, summary, reportFormats, proBarBuilder)
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
