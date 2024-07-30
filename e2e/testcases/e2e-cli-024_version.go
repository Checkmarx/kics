package testcases

import "regexp"

// E2E-CLI-024  - KICS version command
// should display the version of the kics in the CLI.
func init() { //nolint
	testSample := TestCase{
		Name: "should display the kics version [E2E-CLI-024]",
		Args: args{
			Args: []cmdArgs{
				[]string{"version"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Keeping Infrastructure as Code Secure [0-9a-zA-Z]+`, outputText)
			return match
		},
		WantStatus: []int{0},
	}

	Tests = append(Tests, testSample)
}
