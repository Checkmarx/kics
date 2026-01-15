package testcases

import "regexp"

// E2E-CLI-010 - KICS  scan with invalid --type flag
// should exhibit an error message and return exit code 1
func init() { //nolint
	testSample := TestCase{
		Name: "should display an error message about unknown argument [E2E-CLI-010]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-p", "/path/e2e/fixtures/samples/terraform.tf", "-t", "xml", "--silent"},
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
