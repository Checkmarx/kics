package testcases

import "regexp"

// E2E-CLI-027 - KICS scan command with --exclude-paths
// should not perform the scan on the files/folders provided by this flag
func init() { //nolint
	testSample := TestCase{
		Name: " should exclude provided paths [E2E-CLI-027]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--exclude-paths", "/path/test/fixtures/test_swagger/swaggerFileWithoutAuthorizer.yaml",
					"-p", "/path/test/fixtures/test_swagger/", "-v"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Scanned Files: 1`, outputText)
			return match
		},
		WantStatus: []int{40},
	}

	Tests = append(Tests, testSample)
}
