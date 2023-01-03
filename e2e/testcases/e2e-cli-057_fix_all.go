package testcases

import (
	"regexp"
)

// E2E-CLI-057 - Kics remediate command
// should remediate all remediation found
func init() { //nolint
	generateResults("results-remediate-all")

	testSample := TestCase{
		Name: "should remediate all remediation found [E2E-CLI-057]",
		Args: args{
			Args: []cmdArgs{
				[]string{"remediate", "--results", "/path/e2e/tmp-kics-ar/results-remediate-all.json", "-v"},
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
