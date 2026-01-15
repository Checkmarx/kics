package testcases

// E2E-CLI-025 - KICS scan command with --fail-on flag should
// return status code different from 0 only when results match the severity provided in this flag
func init() { //nolint
	testSample := TestCase{
		Name: "should fail-on provided values [E2E-CLI-025]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--fail-on", "info,low",
					"-s", "-p", "/path/assets/queries/dockerfile/apk_add_using_local_cache_path/test/positive.dockerfile"},

				[]string{"scan", "--fail-on", "info",
					"-s", "-p", "/path/assets/queries/dockerfile/apk_add_using_local_cache_path/test/positive.dockerfile"},
			},
		},
		WantStatus: []int{30, 20},
	}

	Tests = append(Tests, testSample)
}
