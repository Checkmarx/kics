package testcases

import "regexp"

// E2E-CLI-012 - kics scan with minimal-ui flag should perform a scan
// without showing detailed results on each line of code
// test to be removed in the future
func init() { //nolint
	testSample := TestCase{
		Name: "should not display minimal-ui [E2E-CLI-012]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-p", "/path/e2e/fixtures/samples/positive.dockerfile"},
			},
		},
		WantStatus: []int{50},
		Validation: func(outputText string) bool {
			match1, _ := regexp.MatchString("Description:", outputText)
			match2, _ := regexp.MatchString("Platform:", outputText)
			// if not found -> the the test was successful
			return match1 && match2
		},
	}

	Tests = append(Tests, testSample)
}
