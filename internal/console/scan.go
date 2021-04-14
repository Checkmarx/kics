package console

import (
	_ "embed" // Embed kics CLI img
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"time"

	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	internalPrinter "github.com/Checkmarx/kics/internal/console/printer"
	"github.com/Checkmarx/kics/internal/constants"
	"github.com/Checkmarx/kics/internal/storage"
	"github.com/Checkmarx/kics/internal/tracker"
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
	"github.com/getsentry/sentry-go"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
	"github.com/spf13/pflag"
	"github.com/spf13/viper"
)

var (
	path              string
	queryPath         string
	outputPath        string
	payloadPath       string
	excludeCategories []string
	excludePath       []string
	excludeIDs        []string
	excludeResults    []string
	reportFormats     []string
	cfgFile           string

	noProgress   bool
	types        []string
	min          bool
	previewLines int
	//go:embed img/kics-console
	banner string
)

const (
	scanCommandStr          = "scan"
	pathFlag                = "path"
	pathFlagShorthand       = "p"
	configFlag              = "config"
	queriesPathShorthand    = "q"
	outputPathFlag          = "output-path"
	outputPathShorthand     = "o"
	reportFormatsFlag       = "report-formats"
	previewLinesFlag        = "preview-lines"
	excludePathsFlag        = "exclude-paths"
	excludePathsShorthand   = "e"
	minimalUIFlag           = "minimal-ui"
	payloadPathFlag         = "payload-path"
	payloadPathShorthand    = "d"
	typeFlag                = "type"
	typeShorthand           = "t"
	noProgressFlag          = "no-progress"
	excludeQueriesFlag      = "exclude-queries"
	excludeResultsFlag      = "exclude-results"
	excludeResutlsShorthand = "x"
	excludeCategoriesFlag   = "exclude-categories"
	queriesPathCmdName      = "queries-path"
)

var scanCmd = &cobra.Command{
	Use:   scanCommandStr,
	Short: "Executes a scan analysis",
	PersistentPreRunE: func(cmd *cobra.Command, args []string) error {
		err := initializeConfig(cmd)
		if err != nil {
			return err
		}
		err = internalPrinter.SetupPrinter(cmd.InheritedFlags())
		if err != nil {
			return err
		}
		return nil
	},
	RunE: func(cmd *cobra.Command, args []string) error {
		changedDefaultQueryPath := cmd.Flags().Lookup(queriesPathCmdName).Changed
		return scan(changedDefaultQueryPath)
	},
}

func initializeConfig(cmd *cobra.Command) error {
	log.Debug().Msg("console.initializeConfig()")

	v := viper.New()
	v.SetEnvPrefix("KICS")
	v.AutomaticEnv()
	bindFlags(cmd, v)

	if cfgFile == "" {
		configpath := path
		info, err := os.Stat(path)
		if err != nil {
			return nil
		}
		if !info.IsDir() {
			configpath = filepath.Dir(path)
		}
		_, err = os.Stat(filepath.ToSlash(filepath.Join(configpath, constants.DefaultConfigFilename)))
		if err != nil {
			if os.IsNotExist(err) {
				return nil
			}
			return err
		}
		cfgFile = filepath.ToSlash(filepath.Join(path, constants.DefaultConfigFilename))
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

	bindFlags(cmd, v)
	return nil
}

func bindFlags(cmd *cobra.Command, v *viper.Viper) {
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
			fmt.Printf("Unknown configuration key: '%s'\nShowing help for '%s' command:\n\n", key, cmd.Name())
			err := cmd.Help()
			if err != nil {
				log.Err(err).Msg("Unable to show help message")
			}
			os.Exit(1)
		}
	}
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

func initScanCmd() {
	scanCmd.Flags().StringVarP(&path,
		pathFlag,
		pathFlagShorthand,
		"",
		"path or directory path to scan")
	scanCmd.Flags().StringVarP(&cfgFile,
		configFlag,
		"",
		"",
		"path to configuration file")
	scanCmd.Flags().StringVarP(
		&queryPath,
		queriesPathCmdName,
		queriesPathShorthand,
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
		payloadPathFlag,
		payloadPathShorthand,
		"",
		"path to store internal representation JSON file")
	scanCmd.Flags().StringSliceVarP(&excludePath,
		excludePathsFlag,
		excludePathsShorthand,
		[]string{},
		"exclude paths from scan\nsupports glob and can be provided multiple times or as a quoted comma separated string"+
			"\nexample: './shouldNotScan/*,somefile.txt'",
	)
	scanCmd.Flags().BoolVarP(&min,
		minimalUIFlag,
		"",
		false,
		"simplified version of CLI output")
	scanCmd.Flags().StringSliceVarP(&types,
		typeFlag,
		typeShorthand,
		[]string{""},
		"case insensitive list of platform types to scan\n"+
			fmt.Sprintf("(%s)", strings.Join(source.ListSupportedPlatforms(), ", ")))
	scanCmd.Flags().BoolVarP(&noProgress,
		noProgressFlag,
		"",
		false,
		"hides the progress bar")
	scanCmd.Flags().StringSliceVarP(&excludeIDs,
		excludeQueriesFlag,
		"",
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
		excludeCategoriesFlag,
		"",
		[]string{},
		"exclude categories by providing its name\n"+
			"can be provided multiple times or as a comma separated string\n"+
			"example: 'Access control,Best practices'",
	)

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

	absPath, err := filepath.Abs(path)
	if err != nil {
		return nil, err
	}

	filesSource, err := provider.NewFileSystemSourceProvider(absPath, excludePaths)
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

	inspector, err := engine.NewInspector(ctx, querySource, engine.DefaultVulnerabilityBuilder, t, excludeQueries, excludeResultsMap)
	if err != nil {
		return nil, err
	}
	return inspector, nil
}

func createService(inspector *engine.Inspector,
	t kics.Tracker,
	store kics.Storage,
	querySource source.FilesystemSource) (*kics.Service, error) {
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

	return &kics.Service{
		SourceProvider: filesSource,
		Storage:        store,
		Parser:         combinedParser,
		Inspector:      inspector,
		Tracker:        t,
		Resolver:       combinedResolver,
	}, nil
}

func scan(changedDefaultQueryPath bool) error {
	log.Debug().Msg("console.scan()")

	for _, warn := range warning {
		log.Warn().Msgf(warn)
	}

	printer := consoleHelpers.NewPrinter(min)
	printer.Success.Printf("\n%s\n", banner)

	versionMsg := fmt.Sprintf("\nScanning with %s\n\n", getVersion())
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

	querySource := source.NewFilesystemSource(queryPath, types)
	store := storage.NewMemoryStorage()

	inspector, err := createInspector(t, querySource)
	if err != nil {
		log.Err(err)
		return err
	}

	service, err := createService(inspector, t, store, *querySource)
	if err != nil {
		log.Err(err)
		return err
	}

	if scanErr := service.StartScan(ctx, scanID, noProgress); scanErr != nil {
		log.Err(scanErr)
		return scanErr
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

	if summary.FailedToExecuteQueries > 0 {
		os.Exit(1)
	}

	return nil
}

func getSummary(t *tracker.CITracker, results []model.Vulnerability) model.Summary {
	counters := model.Counters{
		ScannedFiles:           t.FoundFiles,
		ParsedFiles:            t.ParsedFiles,
		TotalQueries:           t.LoadedQueries,
		FailedToExecuteQueries: t.LoadedQueries - t.ExecutedQueries,
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

func printOutput(outputPath, filename string, body interface{}, formats []string) error {
	log.Debug().Msg("console.printOutput()")
	if outputPath == "" {
		return nil
	}

	if strings.Contains(outputPath, ".") {
		if len(formats) == 0 && filepath.Ext(outputPath) != "" {
			formats = []string{filepath.Ext(outputPath)[1:]}
		}
		if len(formats) == 1 && strings.HasSuffix(outputPath, formats[0]) {
			filename = filepath.Base(outputPath)
			outputPath = filepath.Dir(outputPath)
		}
	}

	log.Debug().Msgf("Output formats provided [%v]", strings.Join(formats, ","))

	err := consoleHelpers.ValidateReportFormats(formats)
	if err == nil {
		err = consoleHelpers.GenerateReport(outputPath, filename, body, formats)
	}
	return err
}
