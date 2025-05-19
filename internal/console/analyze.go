package console

import (
	_ "embed" // Embed kics CLI img and analyze-flags
	"encoding/json"
	"os"
	"path/filepath"

	"github.com/Checkmarx/kics/v2/internal/console/flags"
	sentryReport "github.com/Checkmarx/kics/v2/internal/sentry"
	"github.com/Checkmarx/kics/v2/pkg/analyzer"
	"github.com/Checkmarx/kics/v2/pkg/engine/source"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
)

var (
	//go:embed assets/analyze-flags.json
	analyzeFlagsListContent string
)

const (
	perms = 0640
)

// NewAnalyzeCmd creates a new instance of the analyze Command
func NewAnalyzeCmd() *cobra.Command {
	return &cobra.Command{
		Use:   "analyze",
		Short: "Determines the detected platforms of a certain project",
		RunE: func(cmd *cobra.Command, args []string) error {
			return analyze()
		},
	}
}

func initAnalyzeCmd(analyzeCmd *cobra.Command) error {
	if err := flags.InitJSONFlags(
		analyzeCmd,
		analyzeFlagsListContent,
		false,
		source.ListSupportedPlatforms(),
		source.ListSupportedCloudProviders()); err != nil {
		return err
	}

	if err := analyzeCmd.MarkFlagRequired(flags.AnalyzePath); err != nil {
		sentryReport.ReportSentry(&sentryReport.Report{
			Message:  "Failed to add command required flags",
			Err:      err,
			Location: "func initAnalyzeCmd()",
		}, true)
		log.Err(err).Msg("Failed to add command required flags")
	}
	return nil
}

func analyze() error {
	// save the analyze parameters into the AnalyzeParameters struct
	analyzeParams := getAnalyzeParameters()

	return executeAnalyze(analyzeParams)
}

func getAnalyzeParameters() *analyzer.Parameters {
	analyzeParams := analyzer.Parameters{
		Path:        flags.GetMultiStrFlag(flags.AnalyzePath),
		Results:     flags.GetStrFlag(flags.AnalyzeResults),
		MaxFileSize: flags.GetIntFlag(flags.MaxFileSizeFlag),
	}

	return &analyzeParams
}

func executeAnalyze(analyzeParams *analyzer.Parameters) error {
	log.Debug().Msg("console.scan()")

	for _, warn := range warnings {
		log.Warn().Msgf("%s", warn)
	}

	console := newConsole()

	console.preScan()

	analyzerStruct := &analyzer.Analyzer{
		Paths:             analyzeParams.Path,
		Types:             []string{""},
		ExcludeTypes:      []string{""},
		Exc:               []string{""},
		ExcludeGitIgnore:  false,
		GitIgnoreFileName: "",
		MaxFileSize:       analyzeParams.MaxFileSize,
	}

	analyzedPaths, err := analyzer.Analyze(analyzerStruct)

	if err != nil {
		log.Err(err)
		return err
	}

	err = writeToFile(analyzeParams.Results, analyzedPaths)

	if err != nil {
		log.Err(err)
		return err
	}

	return nil
}

func writeToFile(resultsPath string, analyzerResults model.AnalyzedPaths) error {
	err := os.MkdirAll(filepath.Dir(resultsPath), perms)
	if err != nil {
		return err
	}

	f, err := os.Create(filepath.Clean(resultsPath))
	if err != nil {
		return err
	}

	defer func() {
		if errClose := f.Close(); errClose != nil {
			log.Error().Err(errClose).Msg("Error closing results file")
		}
	}()

	content, err := json.Marshal(analyzerResults)
	if err != nil {
		return err
	}

	_, err = f.Write(content)
	if err != nil {
		return err
	}

	return nil
}
