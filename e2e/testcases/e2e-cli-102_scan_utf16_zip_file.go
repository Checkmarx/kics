package testcases

// E2E-CLI-102 - KICS should scan a zip folder containing UTF-16 encoded files
// and successfully complete the scan with proper encoding handling, returning exit code 40
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a scan on zip file with UTF-16 files and return exit code 40 [E2E-CLI-102]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--payload-path", "/path/e2e/output/E2E_CLI_102_PAYLOAD",
					"-p", "/path/e2e/fixtures/samples/utf16_encoded_files.zip",
				},
			},
			ExpectedPayload: []string{
				"E2E_CLI_102_PAYLOAD.json",
			},
		},
		WantStatus: []int{40},
	}

	Tests = append(Tests, testSample)
}
