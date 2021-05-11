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

	cfgFile           string
	excludeCategories []string
	excludeIDs        []string
	excludePath       []string
	excludeResults    []string
	failOn            []string
	ignoreOnExit      string
	min               bool
	noProgress        bool
	outputPath        string
	path              []string
	payloadPath       string
	previewLines      int
	queryPath         string
	reportFormats     []string
	types             []string
	queryExecTimeout  int
)

const (
	configFlag              = "config"
	excludeCategoriesFlag   = "exclude-categories"
	excludePathsFlag        = "exclude-paths"
	excludePathsShorthand   = "e"
	excludeQueriesFlag      = "exclude-queries"
	excludeResultsFlag      = "exclude-results"
	excludeResutlsShorthand = "x"
	failOnFlag              = "fail-on"
	ignoreOnExitFlag        = "ignore-on-exit"
	minimalUIFlag           = "minimal-ui"
	noProgressFlag          = "no-progress"
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
	typeFlag                = "type"
	typeShorthand           = "t"
	queryExecTimeoutFlag    = "timeout"
)

// NewScanCmd creates a new instance of the scan Command
func NewScanCmd() *cobra.Command {
	return &cobra.Command{
		Use:   scanCommandStr,
		Short: "Executes a scan analysis",
		PersistentPreRunE: func(cmd *cobra.Command, args []string) error {
			err := initializeConfig(cmd)
			if err != nil {
				return errors.New("initialization error - " + err.Error())
			}
			err = internalPrinter.SetupPrinter(cmd.InheritedFlags())
			if err != nil {
				return errors.New("initialization error - " + err.Error())
			}
			err = metrics.InitializeMetrics(cmd.InheritedFlags().Lookup("profiling"))
			if err != nil {
				return errors.New("initialization error - " + err.Error())
			}
			return nil
		},
		RunE: func(cmd *cobra.Command, args []string) error {
			changedDefaultQueryPath := cmd.Flags().Lookup(queriesPathCmdName).Changed
			if err := consoleHelpers.InitShouldIgnoreArg(ignoreOnExit); err != nil {
				return err
			}
			if err := consoleHelpers.InitShouldFailArg(failOn); err != nil {
				return err
			}
			if outputPath != "" {
				directoryToCreate, _, _ := createReportDir(outputPath, "result", reportFormats)
				if err := os.MkdirAll(directoryToCreate, os.ModePerm); err != nil {
					return err
				}
			}
			if payloadPath != "" {
				directoryToCreate, _, _ := createReportDir(payloadPath, "payload", []string{"json"})
				if err := os.MkdirAll(directoryToCreate, os.ModePerm); err != nil {
					return err
				}
			}
			gracefulShutdown()
			return scan(changedDefaultQueryPath)
		},
	}
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

	if cfgFile == "" {
		if len(path) == 0 {
			return nil
		}
		if len(path) > 1 {
			warnings = append(warnings, "Any kics.config file will be ignored, please use --config if kics.config is wanted")
			return nil
		}
		configpath := path[0]
		info, err := os.Stat(configpath)
		if err != nil {
			return nil
		}
		if !info.IsDir() {
			configpath = filepath.Dir(configpath)
		}
		_, err = os.Stat(filepath.ToSlash(filepath.Join(configpath, constants.DefaultConfigFilename)))
		if err != nil {
			if os.IsNotExist(err) {
				return nil
			}
			return err
		}
		cfgFile = filepath.ToSlash(filepath.Join(configpath, constants.DefaultConfigFilename))
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
	scanCmd.Flags().StringSliceVarP(&path,
		pathFlag, pathFlagShorthand,
		[]string{},
		"paths or directories to scan\nexample: \"./somepath,somefile.txt\"")
	scanCmd.Flags().StringVarP(&cfgFile,
		configFlag,
		"", "",
		"path to configuration file")
	scanCmd.Flags().StringVarP(&queryPath,
		queriesPathCmdName, queriesPathShorthand,
		"./assets/queries",
		"path to directory with queries",
	)
	scanCmd.Flags().StringVarP(&outputPath,
		outputPathFlag,
		outputPathShorthand,
		"",
		"directory path to store reports")
	scanCmd.Flags().StringSliceVarP(&reportFormats,
		reportFormatsFlag,
		"",
		[]string{},
		"formats in which the results will be exported (json, sarif, html)",
	)
	scanCmd.Flags().IntVarP(&previewLines,
		previewLinesFlag,
		"",
		3,
		"number of lines to be display in CLI results (min: 1, max: 30)")
	scanCmd.Flags().StringVarP(&payloadPath,
		payloadPathFlag, payloadPathShorthand,
		"",
		"path to store internal representation JSON file")
	scanCmd.Flags().StringSliceVarP(&excludePath,
		excludePathsFlag, excludePathsShorthand,
		[]string{},
		"exclude paths from scan\nsupports glob and can be provided multiple times or as a quoted comma separated string"+
			"\nexample: './shouldNotScan/*,somefile.txt'",
	)
	scanCmd.Flags().BoolVarP(&min,
		minimalUIFlag, "",
		false,
		"simplified version of CLI output")
	scanCmd.Flags().StringSliceVarP(&types,
		typeFlag, typeShorthand,
		[]string{""},
		"case insensitive list of platform types to scan\n"+
			fmt.Sprintf("(%s)", strings.Join(source.ListSupportedPlatforms(), ", ")))
	scanCmd.Flags().BoolVarP(&noProgress,
		noProgressFlag, "",
		false,
		"hides the progress bar")
	scanCmd.Flags().StringSliceVarP(&excludeIDs,
		excludeQueriesFlag, "",
		[]string{},
		"exclude queries by providing the query ID\n"+
			"can be provided multiple times or as a comma separated string\n"+
			"example: 'e69890e6-fce5-461d-98ad-cb98318dfc96,4728cd65-a20c-49da-8b31-9c08b423e4db'",
	)
	scanCmd.Flags().StringSliceVarP(&excludeResults,
		excludeResultsFlag,
		excludeResutlsShorthand,
		[]string{},
		"exclude results by providing the similarity ID of a result\n"+
			"can be provided multiple times or as a comma separated string\n"+
			"example: 'fec62a97d569662093dbb9739360942f...,31263s5696620s93dbb973d9360942fc2a...'",
	)
	scanCmd.Flags().StringSliceVarP(&excludeCategories,
		excludeCategoriesFlag, "",
		[]string{},
		"exclude categories by providing its name\n"+
			"can be provided multiple times or as a comma separated string\n"+
			"example: 'Access control,Best practices'",
	)
	scanCmd.Flags().StringSliceVarP(&failOn,
		failOnFlag, "",
		[]string{"high", "medium", "low", "info"},
		"which kind of results should return an exit code different from 0\n"+
			"accetps: high, medium, low and info\n"+
			"example: \"high,low\"",
	)
	scanCmd.Flags().StringVarP(&ignoreOnExit,
		ignoreOnExitFlag, "",
		"none",
		"defines which kind of non-zero exits code should be ignored\n"+"accepts: all, results, errors, none\n"+
			"example: if 'results' is set, only engine errors will make KICS exit code different from 0",
	)
	scanCmd.Flags().IntVarP(&queryExecTimeout,
		queryExecTimeoutFlag, "",
		60,
		"number of seconds the query has to execute before being canceled")
}

func initScanCmd(scanCmd *cobra.Command) {
	initScanFlags(scanCmd)

	if err := scanCmd.MarkFlagRequired("path"); err != nil {
		sentry.CaptureException(err)
		log.Err(err).Msg("Failed to add command required flags")
	}
}

func getFileSystemSourceProvider() (*provider.FileSystemSourceProvider, error) {
	var excludePaths []string
	if payloadPath != "" {
		excludePaths = append(excludePaths, payloadPath)
	}

	if len(excludePath) > 0 {
		excludePaths = append(excludePaths, excludePath...)
	}
	absPaths := make([]string, len(path))
	for idx, scanPath := range path {
		absPath, err := filepath.Abs(scanPath)
		if err != nil {
			return nil, err
		}
		absPaths[idx] = absPath
	}

	filesSource, err := provider.NewFileSystemSourceProvider(absPaths, excludePaths)
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

	inspector, err := engine.NewInspector(ctx,
		querySource, engine.DefaultVulnerabilityBuilder,
		t, excludeQueries, excludeResultsMap, queryExecTimeout)
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
	t kics.Tracker,
	store kics.Storage,
	querySource source.FilesystemSource) ([]*kics.Service, error) {
	filesSource, err := getFileSystemSourceProvider()
	if err != nil {
		return nil, err
	}

	combinedParser, err := parser.NewBuilder().
		Add(&jsonParser.Parser{}).
		Add(&yamlParser.Parser{}).
		Add(terraformParser.NewDefault()).
		Add(&dockerParser.Parser{}).
		Build(querySource.Types)
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

	scanStartTime := time.Now()

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

	if types, excludePath, err = analyzePaths(path, types, excludePath); err != nil {
		return err
	}

	querySource := source.NewFilesystemSource(queryPath, types)
	store := storage.NewMemoryStorage()

	inspector, err := createInspector(t, querySource)
	if err != nil {
		log.Err(err)
		return err
	}

	services, err := createService(inspector, t, store, *querySource)
	if err != nil {
		log.Err(err)
		return err
	}

	if err = scanner.StartScan(ctx, scanID, noProgress, services); err != nil {
		log.Err(err)
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

	elapsed := time.Since(scanStartTime)

	summary := getSummary(t, results)

	if err := resolveOutputs(&summary, files.Combine(), inspector.GetFailedQueries(), printer); err != nil {
		log.Err(err)
		return err
	}

	elapsedStrFormat := "Scan duration: %v\n"
	fmt.Printf(elapsedStrFormat, elapsed)
	log.Info().Msgf(elapsedStrFormat, elapsed)

	exitCode := consoleHelpers.ResultsExitCode(&summary)
	if consoleHelpers.ShowError("results") && exitCode != 0 {
		os.Exit(exitCode)
	}
	return nil
}

func getSummary(t *tracker.CITracker, results []model.Vulnerability) model.Summary {
	counters := model.Counters{
		ScannedFiles:           t.FoundFiles,
		ParsedFiles:            t.ParsedFiles,
		TotalQueries:           t.LoadedQueries,
		FailedToExecuteQueries: t.ExecutingQueries - t.ExecutedQueries,
		FailedSimilarityID:     t.FailedSimilarityID,
	}

	return model.CreateSummary(counters, results, scanID)
}

func resolveOutputs(
	summary *model.Summary,
	documents model.Documents,
	failedQueries map[string]error,
	printer *consoleHelpers.Printer,
) error {
	log.Debug().Msg("console.resolveOutputs()")

	if err := printOutput(payloadPath, "payload", documents, []string{"json"}); err != nil {
		return err
	}

	if err := printOutput(outputPath, "results", summary, reportFormats); err != nil {
		return err
	}

	return consoleHelpers.PrintResult(summary, failedQueries, printer)
}

func createReportDir(outputPath, filename string, formats []string) (outDir, outFile string, outFormats []string) {
	if strings.Contains(outputPath, ".") {
		if len(formats) == 0 && filepath.Ext(outputPath) != "" {
			err := consoleHelpers.ValidateReportFormats([]string{filepath.Ext(outputPath)[1:]})
			if err != nil {
				log.Trace().Msgf("Extension not supported %s, will create directory instead", filepath.Ext(outputPath)[1:])
			} else {
				formats = []string{filepath.Ext(outputPath)[1:]}
			}
		}
		if len(formats) == 1 && strings.HasSuffix(outputPath, formats[0]) {
			filename = filepath.Base(outputPath)
			outputPath = filepath.Dir(outputPath)
		}
	}
	return outputPath, filename, formats
}

func printOutput(outputPath, filename string, body interface{}, formats []string) error {
	log.Debug().Msg("console.printOutput()")
	if outputPath == "" {
		return nil
	}
	outputPath, filename, formats = createReportDir(outputPath, filename, formats)
	if len(formats) == 0 {
		formats = consoleHelpers.ListReportFormats()
	}

	log.Debug().Msgf("Output formats provided [%v]", strings.Join(formats, ","))

	err := consoleHelpers.ValidateReportFormats(formats)
	if err == nil {
		err = consoleHelpers.GenerateReport(outputPath, filename, body, formats)
	}
	return err
}

// gracefulShutdown catches signal interrupt and returns the appropriate exit code
func gracefulShutdown() {
	c := make(chan os.Signal)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM)
	showErrors := consoleHelpers.ShowError("errors")
	interruptCode := constants.SignalInterruptCode
	go func(showErrors bool, interruptCode int) {
		<-c
		if showErrors {
			os.Exit(interruptCode)
		}
	}(showErrors, interruptCode)
}
