package testcases

import "regexp"

// E2E-CLI-023 - Kics  scan command with --profiling MEM and -v flags
// should display MEM usage in the CLI
func init() {
	testSample := TestCase{
		Name: "should display memory usage in the CLI [E2E-CLI-023]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--profiling", "MEM", "-v",
					"--no-progress", "--no-color", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Total MEM usage for start_scan: \d+`, outputText)
			return match
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}
