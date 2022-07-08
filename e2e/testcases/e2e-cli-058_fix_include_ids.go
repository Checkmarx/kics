package testcases

import (
	"os"
	"path/filepath"
	"regexp"

	"github.com/Checkmarx/kics/pkg/remediation"
	"github.com/Checkmarx/kics/pkg/utils"
	"github.com/rs/zerolog/log"
)

// E2E-CLI-058 - Kics fix command with include-ids flag
// should fix the recomendations pointed in include-ids flag
func init() { // nolint
	if err := os.MkdirAll("./fixtures/tmp-kics-ar", os.ModePerm); err != nil {
		log.Error().Msgf("failed to mkdir: %s", err)
	}

	filePathCopyFrom := "./fixtures/samples/kics-auto-remediation/terraform.tf"
	tmpFilePath := "./fixtures/tmp-kics-ar/temporary-remediation" + utils.NextRandom() + filepath.Ext(filePathCopyFrom)
	jsonPath := "./fixtures/tmp-kics-ar"

	// create a temporary file with the same content as filePathCopyFrom
	tmpFile := remediation.CreateTempFile(filePathCopyFrom, tmpFilePath)

	// create JSON results with remediation
	generateReport(tmpFile, jsonPath)
	pathResults := filepath.Join(jsonPath, "results.json")

	testSample := TestCase{
		Name: "should fix the recomendations pointed in include-ids flag [E2E-CLI-058]",
		Args: args{
			Args: []cmdArgs{
				[]string{"fix", "--results", pathResults,
					"--include-ids", "f282fa13cf5e4ffd4bbb0ee2059f8d0240edcd2ca54b3bb71633145d961de5ce," +
						"87abbee5d0ec977ba193371c702dca2c040ea902d2e606806a63b66119ff89bc",
					"-v"},
			},
		},
		WantStatus: []int{0},
		Validation: func(outputText string) bool {
			match1, _ := regexp.MatchString(`Selected remediation: 2`, outputText)
			match2, _ := regexp.MatchString(`Remediation done: 2`, outputText)
			return match1 && match2
		},
	}

	Tests = append(Tests, testSample)
}
