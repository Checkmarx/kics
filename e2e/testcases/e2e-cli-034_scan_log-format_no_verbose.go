package testcases

import "regexp"

// E2E-CLI-034 - KICS scan command with --log-format without --verbose
// should not output log messages in the CLI (json)
func init() { //nolint
	testSample := TestCase{
		Name: "should not display messages in the CLI [E2E-CLI-034]",
		Args: args{
			Args: []cmdArgs{

				[]string{"scan", "--log-format", "json",
					"-p", "/path/e2e/fixtures/samples/single.dockerfile"},
			},
		},

		Validation: func(outputText string) bool {
			match1, _ := regexp.MatchString(`{"level":"info"`, outputText)
			match2, _ := regexp.MatchString(`"message":"Inspector initialized, number of queries=\d+"`, outputText)
			return !match1 && !match2
		},

		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}
