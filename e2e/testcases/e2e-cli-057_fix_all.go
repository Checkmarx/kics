package testcases

import (
	"os"
	"path/filepath"
	"regexp"

	"github.com/Checkmarx/kics/pkg/remediation"
	"github.com/Checkmarx/kics/pkg/utils"
	"github.com/rs/zerolog/log"
)

// E2E-CLI-057 - Kics fix command
// should fix all remediation found
func init() { // nolint
	cwd, err := os.Getwd()

	if err != nil {
		log.Error().Msgf("failed to get wd: %s", err)
	}

	tmpFolderPath := filepath.Join(cwd, "fixtures", "tmp-kics-ar")

	if err := os.MkdirAll(tmpFolderPath, os.ModePerm); err != nil {
		log.Error().Msgf("failed to mkdir: %s", err)
	}

	filePathCopyFrom := filepath.Join(cwd, "fixtures", "samples", "kics-auto-remediation", "terraform.tf")

	tmpFilePath := filepath.Join(cwd, "fixtures", "tmp-kics-ar", "temporary-remediation-"+utils.NextRandom()+filepath.Ext(filePathCopyFrom))

	jsonPath := tmpFolderPath

	// create a temporary file with the same content as filePathCopyFrom
	tmpFile := remediation.CreateTempFile(filePathCopyFrom, tmpFilePath)

	// create JSON results with remediation
	generateReport(tmpFile, jsonPath)
	pathResults := filepath.Join(jsonPath, "results.json")

	testSample := TestCase{
		Name: "should fix all remediation found [E2E-CLI-057]",
		Args: args{
			Args: []cmdArgs{
				[]string{"fix", "--results", pathResults, "-v"},
			},
		},
		WantStatus: []int{0},
		Validation: func(outputText string) bool {
			match1, _ := regexp.MatchString(`Selected remediation: 5`, outputText)
			match2, _ := regexp.MatchString(`Remediation done: 5`, outputText)
			return match1 && match2
		},
	}

	Tests = append(Tests, testSample)
}
