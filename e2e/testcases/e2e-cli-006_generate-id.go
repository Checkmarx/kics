package testcases

import "regexp"

// E2E-CLI-006 - KICS generate-id should exhibit
// a valid UUID in the CLI and return exit code 0
func init() { //nolint
	testSample := TestCase{
		Name: "should generate a valid ID [E2E-CLI-006]",
		Args: args{
			Args: []cmdArgs{
				[]string{"generate-id"},
			},
		},
		WantStatus: []int{0},
		Validation: func(outputText string) bool {
			uuidRegex := "[a-f0-9]{8}-[a-f0-9]{4}-4{1}[a-f0-9]{3}-[89ab]{1}[a-f0-9]{3}-[a-f0-9]{12}"
			match, _ := regexp.MatchString(uuidRegex, outputText)
			return match
		},
	}

	Tests = append(Tests, testSample)
}
