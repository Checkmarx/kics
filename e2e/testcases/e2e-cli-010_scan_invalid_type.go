package testcases

import "regexp"

// E2E-CLI-010 - KICS  scan with invalid --type flag
// should exhibit an error message and return exit code 1
func init() { //nolint
	testSample := TestCase{
		Name: "should display an error message [E2E-CLI-010]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf", "-t", "xml", "--silent"},
			},
		},
		Validation: func(outputText string) bool {
			unknownArgRegex := regexp.MustCompile(`Error: unknown argument\(s\) for --type: xml`)
			match := unknownArgRegex.MatchString(outputText)
			return match
		},
		WantStatus: []int{126},
	}

	Tests = append(Tests, testSample)
}
