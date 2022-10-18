// testcases for E2E tests
package testcases

import (
	"regexp"
)

// E2E-CLI-061 - KICS remediate command
// should remediate all remediation found
func init() { // nolint
	generateResults("results-remediate-custom-queries")

	testSample := TestCase{
		Name: "should remediate the recomendations from the loaded custom queries [E2E-CLI-061]",
		Args: args{
			Args: []cmdArgs{
				[]string{"remediate", "--results", "/path/e2e/tmp-kics-ar/results-remediate-custom-queries.json",
					"--queries", "/path/e2e/fixtures/samples/custom-queries",
					"-v"},
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
