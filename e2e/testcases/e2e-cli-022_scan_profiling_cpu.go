package testcases

import "regexp"

// E2E-CLI-022 - Kics  scan command with --profiling CPU and -v flags
// should display CPU usage in the CLI
func init() { //nolint
	testSample := TestCase{
		Name: "should display CPU usage in the CLI [E2E-CLI-022]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--profiling", "CPU", "-v",
					"--no-progress", "--no-color", "-p", "/path/e2e/fixtures/samples/positive.dockerfile"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Total CPU usage for start_scan: \d+`, outputText)
			return match
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}
