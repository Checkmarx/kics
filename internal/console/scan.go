package console

import (
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
	"time"

	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/internal/storage"
	"github.com/Checkmarx/kics/internal/tracker"
	"github.com/Checkmarx/kics/pkg/engine"
	"github.com/Checkmarx/kics/pkg/engine/query"
	"github.com/Checkmarx/kics/pkg/kics"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/parser"
	dockerParser "github.com/Checkmarx/kics/pkg/parser/docker"
	terraformParser "github.com/Checkmarx/kics/pkg/parser/terraform"
	yamlParser "github.com/Checkmarx/kics/pkg/parser/yaml"
	"github.com/Checkmarx/kics/pkg/source"
	"github.com/getsentry/sentry-go"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
	"github.com/spf13/pflag"
	"github.com/spf13/viper"
)

var (
	path        string
	queryPath   string
	outputPath  string
	payloadPath string
	excludePath []string
	cfgFile     string
	sarifPath   string
	verbose     bool
	logFile     bool
	noProgress  bool
	types       []string
)

var scanCmd = &cobra.Command{
	Use:   "scan",
	Short: "Executes a scan analysis",
	PersistentPreRunE: func(cmd *cobra.Command, args []string) error {
		if cfgFile != "" {
			return initializeConfig(cmd)
		}
		return nil
	},
	RunE: func(cmd *cobra.Command, args []string) error {
		return scan()
	},
}

func initializeConfig(cmd *cobra.Command) error {
	v := viper.New()
	base := filepath.Base(cfgFile)
	if strings.LastIndex(base, ".") > -1 {
		base = base[:strings.LastIndex(base, ".")]
	}
	v.SetConfigName(base)
	v.AddConfigPath(filepath.Dir(cfgFile))
	if err := v.ReadInConfig(); err != nil {
		return err
	}
	v.SetEnvPrefix("VIPER_")
	v.AutomaticEnv()
	bindFlags(cmd, v)
	return nil
}

func bindFlags(cmd *cobra.Command, v *viper.Viper) {
	cmd.Flags().VisitAll(func(f *pflag.Flag) {
		if strings.Contains(f.Name, "-") {
			envVarSuffix := strings.ToUpper(strings.ReplaceAll(f.Name, "-", "_"))
			if err := v.BindEnv(f.Name, fmt.Sprintf("%s_%s", "VIPER_", envVarSuffix)); err != nil {
				log.Err(err).Msg("Failed to bind Viper flags")
			}
		}
		if !f.Changed && v.IsSet(f.Name) {
			val := v.Get(f.Name)
			if err := cmd.Flags().Set(f.Name, fmt.Sprintf("%v", val)); err != nil {
				log.Err(err).Msg("Failed to get Viper flags")
			}
		}
	})
}

func initScanCmd() {
	scanCmd.Flags().StringVarP(&path, "path", "p", "", "path to file or directory to scan")
	scanCmd.Flags().StringVarP(&cfgFile, "config", "", "", "path to configuration file")
	scanCmd.Flags().StringVarP(
		&queryPath,
		"queries-path",
		"q",
		"./assets/queries",
		"path to directory with queries (default ./assets/queries)",
	)
	scanCmd.Flags().StringVarP(&outputPath, "output-path", "o", "", "file path to store result in json format")
	scanCmd.Flags().StringVarP(&payloadPath, "payload-path", "d", "", "file path to store source internal representation in JSON format")
	scanCmd.Flags().StringVarP(&sarifPath, "sarif", "", "", "file path to save SARIF output")
	scanCmd.Flags().StringSliceVarP(
		&excludePath,
		"exclude-paths",
		"e",
		[]string{},
		"exclude paths or files from scan\nThe arg should be quoted and uses comma as separator\nexample: './shouldNotScan/*,somefile.txt'",
	)
	scanCmd.Flags().BoolVarP(&verbose, "verbose", "v", false, "verbose scan")
	scanCmd.Flags().BoolVarP(&logFile, "log-file", "l", false, "log to file info.log")
	scanCmd.Flags().StringSliceVarP(&types, "type", "t", []string{""}, "type of queries to use in the scan")
	scanCmd.Flags().BoolVarP(&noProgress, "no-progress", "", false, "hides scan's progress bar")

	if err := scanCmd.MarkFlagRequired("path"); err != nil {
		sentry.CaptureException(err)
		log.Err(err).Msg("failed to add command required flags")
	}
}

func setupLogs() error {
	// TODO ioutil will be deprecated on go v1.16, so ioutil.Discard should be changed to io.Discard
	consoleLogger := zerolog.ConsoleWriter{Out: ioutil.Discard}
	fileLogger := zerolog.ConsoleWriter{Out: ioutil.Discard}

	if verbose {
		consoleLogger = zerolog.ConsoleWriter{Out: os.Stdout}
	}

	if logFile {
		file, err := os.OpenFile("info.log", os.O_APPEND|os.O_CREATE|os.O_WRONLY, os.ModePerm)
		if err != nil {
			return err
		}
		fileLogger = consoleHelpers.CustomConsoleWriter(&zerolog.ConsoleWriter{Out: file, NoColor: true})
	}

	mw := io.MultiWriter(consoleLogger, fileLogger)
	log.Logger = log.Output(mw)
	return nil
}

func getFileSystemSourceProvider() (*source.FileSystemSourceProvider, error) {
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

	filesSource, err := source.NewFileSystemSourceProvider(absPath, excludePaths)
	if err != nil {
		return nil, err
	}
	return filesSource, nil
}

func scan() error {
	fmt.Printf("Scanning with %s\n\n", getVersion())

	if err := setupLogs(); err != nil {
		return err
	}

	scanStartTime := time.Now()

	querySource := query.NewFilesystemSource(queryPath, types)

	t := &tracker.CITracker{}

	inspector, err := engine.NewInspector(ctx, querySource, engine.DefaultVulnerabilityBuilder, t)
	if err != nil {
		return err
	}

	filesSource, err := getFileSystemSourceProvider()
	if err != nil {
		return err
	}

	combinedParser, err := parser.NewBuilder().
		Add(&yamlParser.Parser{}).
		Add(terraformParser.NewDefault()).
		Add(&dockerParser.Parser{}).
		Build(types)
	if err != nil {
		return err
	}

	store := storage.NewMemoryStorage()

	service := &kics.Service{
		SourceProvider: filesSource,
		Storage:        store,
		Parser:         combinedParser,
		Inspector:      inspector,
		Tracker:        t,
	}

	if scanErr := service.StartScan(ctx, scanID, noProgress); scanErr != nil {
		return scanErr
	}

	result, err := store.GetVulnerabilities(ctx, scanID)
	if err != nil {
		return err
	}

	files, err := store.GetFiles(ctx, scanID)
	if err != nil {
		return err
	}

	elapsed := time.Since(scanStartTime)

	counters := model.Counters{
		ScannedFiles:           t.FoundFiles,
		ParsedFiles:            t.ParsedFiles,
		TotalQueries:           t.LoadedQueries,
		FailedToExecuteQueries: t.LoadedQueries - t.ExecutedQueries,
		FailedSimilarityID:     t.FailedSimilarityID,
	}

	summary := model.CreateSummary(counters, result, scanID)

	if err := printJSON(payloadPath, files.Combine()); err != nil {
		return err
	}

	if err := printJSON(outputPath, summary); err != nil {
		return err
	}

	if sarifPath != "" {
		if err := printToSarifFile(sarifPath, &summary); err != nil {
			return err
		}
	}

	if err := consoleHelpers.PrintResult(&summary, inspector.GetFailedQueries()); err != nil {
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

func printToSarifFile(path string, summary *model.Summary) error {
	sarifReport := model.NewSarifReport()
	for idx := range summary.Queries {
		sarifReport.BuildIssue(&summary.Queries[idx])
	}

	return printJSON(path, sarifReport)
}

func printJSON(path string, body interface{}) error {
	if path != "" {
		return consoleHelpers.PrintToJSONFile(path, body)
	}
	return nil
}
