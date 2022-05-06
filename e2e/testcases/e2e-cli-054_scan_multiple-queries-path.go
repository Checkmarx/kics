package testcases

import "regexp"

// E2E-CLI-054 - Kics scan command with --queries-path using multiple entries
// should load and execute queries found in the provided paths
func init() { //nolint
	testSample := TestCase{
		Name: "should load and execute queries from multiple paths [E2E-CLI-054]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--queries-path", "/path/e2e/fixtures/samples/queries/valid/single_query," +
					"/path/e2e/fixtures/samples/queries/valid/multiple_query",
					"-p", "/path/e2e/fixtures/samples/bom-positive.tf"},
			},
		},
		Validation: func(outputText string) bool {
			matchQueryPath1, _ := regexp.MatchString(`Athena Database Not Encrypted`, outputText)
			matchQueryPath2, _ := regexp.MatchString(`S3 Bucket Without Enabled MFA Delete`, outputText)
			return matchQueryPath1 && matchQueryPath2
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}
