package testcases

import (
	"regexp"
)

// E2E-CLI-056 - Kics scan command with timeout flag
// should stop a query execution when reaching the provided timeout (seconds)
func init() { //nolint
	testSample := TestCase{
		Name: "should timeout queries when reaching the timeout limit [E2E-CLI-056]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--config", "/path/e2e/fixtures/samples/configs/config.yaml", "-v"},
				[]string{"scan", "-p", "/path/e2e/fixtures/samples/positive.dockerfile", "--timeout", "1", "-v"},
				[]string{"scan", "-p", "/path/e2e/fixtures/samples/positive.dockerfile", "--timeout", "0", "-v"},
			},
		},
		WantStatus: []int{50, 50, 126},
		Validation: func(outputText string) bool {
			matchTimeoutLog, _ := regexp.MatchString("Query execution timeout=(0|1|12)s", outputText)
			return matchTimeoutLog
		},
	}

	Tests = append(Tests, testSample)
}
