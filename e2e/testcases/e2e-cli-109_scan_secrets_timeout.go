package testcases

import (
	"regexp"
	"strings"
)

// E2E-CLI-109 - Kics scan command with timeout flag on the passwords and secrets query
// should stop a secrets rule execution when reaching the provided timeout (seconds)
// and should not report any timeout when the timeout is large enough
func init() { //nolint
	testSample := TestCase{
		Name: "should timeout passwords and secrets rules when reaching the timeout limit [E2E-CLI-109]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "--no-progress", "--timeout", "1",
					"-p", "/path/assets/queries/common/passwords_and_secrets/test",
					"--secrets-regexes-path", "/path/e2e/fixtures/samples/secrets/regex_rules_109_slow.json",
					"--include-queries", "3c1a6b7e-5d2f-4e8a-9b41-7f0c2d9e6a15"},

				[]string{"scan", "-v", "--no-progress", "--timeout", "60",
					"-p", "/path/assets/queries/common/passwords_and_secrets/test",
					"--secrets-regexes-path", "/path/e2e/fixtures/samples/secrets/regex_rules_109_slow.json",
					"--include-queries", "3c1a6b7e-5d2f-4e8a-9b41-7f0c2d9e6a15"},
			},
		},
		WantStatus: []int{0, 0},
		Validation: func(outputText string) bool {
			matchSecretsTimeout, _ := regexp.MatchString(
				"Secrets query 'Slow Timeout Rule' executed with error: context deadline exceeded", outputText)
			// the slow rule only times out with the 1-second limit
			if strings.Contains(outputText, "Query execution timeout=1s") {
				return matchSecretsTimeout
			}
			matchTimeoutLog, _ := regexp.MatchString("Query execution timeout=1m0s", outputText)
			return matchTimeoutLog && !matchSecretsTimeout
		},
	}

	Tests = append(Tests, testSample)
}
