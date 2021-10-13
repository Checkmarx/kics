package testcases

import "regexp"

// E2E-CLI-027 - KICS scan command with --exclude-paths
// should not perform the scan on the files/folders provided by this flag
func init() { //nolint
	testSample := TestCase{
		Name: " should exclude provided paths [E2E-CLI-027]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--exclude-paths", "../test/fixtures/all_auth_users_get_read_access/test/positive.tf",
					"-q", "../assets/queries", "-p", "../test/fixtures/all_auth_users_get_read_access/test/"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Files scanned: 1`, outputText)
			return match
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}
