// Package testcases provides end-to-end (E2E) testing functionality for the application.
package testcases

// E2E-CLI-065 - KICS  scan
// should perform the scan successfully and return exit code 0
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a valid scan [E2E-CLI-065]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-p", "\"/path/e2e/fixtures/samples/panicYamlRef/file1.yaml\"",
					"--silent"},
			},
		},
		WantStatus: []int{0},
	}

	Tests = append(Tests, testSample)
}
