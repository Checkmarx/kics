package testcases

import "regexp"

// E2E-CLI-017 - KICS scan command with the -v (--verbose) flag
// should display additional information in the CLI, such as 'Inspector initialized'...

func init() {
	testSample := TestCase{
		Name: "should display verbose information in the CLI [E2E-CLI-017]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "--no-progress", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf"},
			},
		},
		Validation: func(outputText string) bool {
			match1, _ := regexp.MatchString(`Inspector initialized, number of queries=\d+`, outputText)
			match2, _ := regexp.MatchString(`Inspector stopped`, outputText)
			return match1 && match2
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}
