package testcases

import "regexp"

// E2E-CLI-009 - kics scan with no-progress flag
// should perform a scan without showing progress bar in the CLI
func init() {
	testSample := TestCase{
		Name: "should hide the progress bar in the CLI [E2E-CLI-009]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf", "--no-progress"},
			},
		},
		WantStatus: []int{50},
		Validation: func(outputText string) bool {
			getProgressRegex := "Executing queries:"
			match, _ := regexp.MatchString(getProgressRegex, outputText)
			// if not found -> the the test was successful
			return !match
		},
	}

	Tests = append(Tests, testSample)
}
