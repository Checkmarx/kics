package testcases

import "regexp"

// E2E-CLI-015 KICS scan with --no-color flag
// should disable the colored outputs of kics in the CLI
func init() { //nolint
	testSample := TestCase{
		Name: "should disable colored output in the CLI [E2E-CLI-015]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--no-color", "-p", "/path/e2e/fixtures/samples/positive.dockerfile"},
			},
		},
		Validation: func(outputText string) bool {
			match1, _ := regexp.MatchString(`HIGH: \d+`, outputText)
			match2, _ := regexp.MatchString(`MEDIUM: \d+`, outputText)
			match3, _ := regexp.MatchString(`LOW: \d+`, outputText)
			match4, _ := regexp.MatchString(`INFO: \d+`, outputText)
			return match1 && match2 && match3 && match4
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}
