package console

import (
	_ "embed" // Embed fix flags
	"encoding/json"
	"fmt"
	"os"

	"github.com/Checkmarx/kics/internal/console/flags"
	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	sentryReport "github.com/Checkmarx/kics/internal/sentry"
	"github.com/Checkmarx/kics/pkg/engine/source"
	internalPrinter "github.com/Checkmarx/kics/pkg/printer"
	"github.com/Checkmarx/kics/pkg/remediation"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
)

var (
	//go:embed assets/fix-flags.json
	fixFlagsListContent string
)

// NewFixCmd creates a new instance of the fix Command
func NewFixCmd() *cobra.Command {
	return &cobra.Command{
		Use:   "fix",
		Short: "Auto remediates the project",
		PersistentPreRunE: func(cmd *cobra.Command, args []string) error {
			return preFix(cmd)
		},
		RunE: func(cmd *cobra.Command, args []string) error {
			return fix(cmd)
		},
	}
}

func initFixCmd(fixCmd *cobra.Command) error {
	if err := flags.InitJSONFlags(
		fixCmd,
		fixFlagsListContent,
		false,
		source.ListSupportedPlatforms(),
		source.ListSupportedCloudProviders()); err != nil {
		return err
	}

	if err := fixCmd.MarkFlagRequired(flags.Results); err != nil {
		sentryReport.ReportSentry(&sentryReport.Report{
			Message:  "Failed to add command required flags",
			Err:      err,
			Location: "func initScanCmd()",
		}, true)
		log.Err(err).Msg("Failed to add command required flags")
	}
	return nil
}

func preFix(cmd *cobra.Command) error {
	err := flags.Validate()
	if err != nil {
		return err
	}

	err = flags.ValidateQuerySelectionFlags()
	if err != nil {
		return err
	}
	err = internalPrinter.SetupPrinter(cmd.InheritedFlags())
	if err != nil {
		return errors.New(initError + err.Error())
	}
	return err
}

func fix(cmd *cobra.Command) error {
	resultsPath := flags.GetStrFlag(flags.Results)
	include := flags.GetMultiStrFlag(flags.IncludeIds)

	content, err := os.ReadFile(resultsPath)
	if err != nil {
		log.Error().Msgf("failed to read file: %s", err)
		return err
	}

	results := remediation.Report{}

	err = json.Unmarshal(content, &results)
	if err != nil {
		log.Error().Msgf("failed to unmarshal file: %s", err)
		return err
	}

	summary := &remediation.Summary{
		SelectedRemediationNumber:   0,
		ActualRemediationDoneNumber: 0,
	}

	// get all the fixs related to each filePath
	fixs := summary.GetFixs(results, include)

	for filePath := range fixs {
		fix := fixs[filePath].(remediation.Fix)
		err = summary.RemediateFile(filePath, fix)
		if err != nil {
			return err
		}
	}

	fmt.Printf("\nSelected remediation: %d\n", summary.SelectedRemediationNumber)
	fmt.Printf("Remediation done: %d\n", summary.ActualRemediationDoneNumber)

	exitCode := consoleHelpers.FixExitCode(summary.SelectedRemediationNumber, summary.ActualRemediationDoneNumber)
	if exitCode != 0 {
		os.Exit(exitCode)
	}

	return nil
}
