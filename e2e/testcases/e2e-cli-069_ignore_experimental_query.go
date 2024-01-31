package testcases

// E2E-CLI-069 - KICS  scan and ignore experimental queries
// should perform the scan successfully and return exit code 40
import (
	"sort"
)

func init() { //nolint
	samplePath := "/path/test/fixtures/experimental_test/sample"
	queriesPath := "/path/test/fixtures/experimental_test/queries"

	paths := []string{samplePath, queriesPath}
	sort.Strings(paths)

	testSample := TestCase{
		Name: "should perform a valid scan and ignore the experimental queries [E2E-CLI-069]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-o", "/path/e2e/output", "--output-name", "E2E_CLI_069_RESULT",
					"-p", "\"" + paths[1] + "\"", "-q", "\"" + paths[0] + "\"",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "E2E_CLI_069_RESULT",
					ResultsFormats: []string{"json"},
				},
			},
		},
		WantStatus: []int{40},
	}

	Tests = append(Tests, testSample)
}
