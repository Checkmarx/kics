package console

import (
	_ "embed" // Embed remediate flags
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"

	"github.com/Checkmarx/kics/v2/internal/console/flags"
	consoleHelpers "github.com/Checkmarx/kics/v2/internal/console/helpers"
	sentryReport "github.com/Checkmarx/kics/v2/internal/sentry"
	"github.com/Checkmarx/kics/v2/pkg/engine/source"
	internalPrinter "github.com/Checkmarx/kics/v2/pkg/printer"
	"github.com/Checkmarx/kics/v2/pkg/remediation"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
)

var (
	//go:embed assets/remediate-flags.json
	remediateFlagsListContent string
)

// NewRemediateCmd creates a new instance of the remediate Command
func NewRemediateCmd() *cobra.Command {
	return &cobra.Command{
		Use:   "remediate",
		Short: "Auto remediates the project",
		PersistentPreRunE: func(cmd *cobra.Command, args []string) error {
			return preRemediate(cmd)
		},
		RunE: func(cmd *cobra.Command, args []string) error {
			return remediate()
		},
	}
}

func initRemediateCmd(remediateCmd *cobra.Command) error {
	if err := flags.InitJSONFlags(
		remediateCmd,
		remediateFlagsListContent,
		false,
		source.ListSupportedPlatforms(),
		source.ListSupportedCloudProviders()); err != nil {
		return err
	}

	if err := remediateCmd.MarkFlagRequired(flags.Results); err != nil {
		sentryReport.ReportSentry(&sentryReport.Report{
			Message:  "Failed to add command required flags",
			Err:      err,
			Location: "func initScanCmd()",
		}, true)
		log.Err(err).Msg("Failed to add command required flags")
	}
	return nil
}

func preRemediate(cmd *cobra.Command) error {
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

func remediate() error {
	resultsPath := flags.GetStrFlag(flags.Results)
	include := flags.GetMultiStrFlag(flags.IncludeIds)
	openAPIResolveReferences := flags.GetBoolFlag(flags.OpenAPIReferencesFlag)
	maxResolverDepth := flags.GetIntFlag(flags.MaxResolverDepth)

	filepath.Clean(resultsPath)

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

	// get all the remediationSets related to each filePath
	remediationSets := summary.GetRemediationSets(results, include)

	for filePath := range remediationSets {
		fix := remediationSets[filePath].(remediation.Set)
		err = summary.RemediateFile(filePath, fix, openAPIResolveReferences, maxResolverDepth)
		if err != nil {
			return err
		}
	}

	fmt.Printf("\nSelected remediation: %d\n", summary.SelectedRemediationNumber)
	fmt.Printf("Remediation done: %d\n", summary.ActualRemediationDoneNumber)

	exitCode := consoleHelpers.RemediateExitCode(summary.SelectedRemediationNumber, summary.ActualRemediationDoneNumber)
	if exitCode != 0 {
		os.Exit(exitCode)
	}

	return nil
}
