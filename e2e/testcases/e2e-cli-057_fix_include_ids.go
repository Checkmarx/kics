package testcases

import (
	"regexp"
)

// E2E-CLI-057 - Kics remediate command
// should remediate all remediation found
func init() { //nolint
	generateResults("results-remediate-include-ids")

	testSample := TestCase{
		Name: "should remediate the recommendations pointed in include-ids flag [E2E-CLI-058]",
		Args: args{
			Args: []cmdArgs{
				[]string{"remediate", "--results", "/path/e2e/tmp-kics-ar/results-remediate-include-ids.json",
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
