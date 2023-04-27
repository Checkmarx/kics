package testcases

import "regexp"

// E2E-CLI-046 - Kics scan command with --disable-metrics
// should not fetch metrics from environment URL KICS_DESCRIPTIONS_ENDPOINT.
func init() { //nolint
	testSample := TestCase{
		Name: "should not fetch metrics from environment [E2E-CLI-046]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-p", "/path/e2e/fixtures/samples/positive.dockerfile",
					"--no-color", "-v",
					"--disable-metrics"},
			},
		},
		Validation: func(outputText string) bool {
			uuidRegex := "Skipping all metrics because provided disable flag is set"
			match, _ := regexp.MatchString(uuidRegex, outputText)
			return match
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}
