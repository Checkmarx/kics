// Package testcases provides end-to-end (E2E) testing functionality for the application.
package testcases

// E2E-CLI-064 - KICS  scan with json/yaml file with ## in non ref
// should perform the scan successfully and return exit code 0
func init() { //nolint
	testSample := TestCase{
		Name: "should perform a valid scan with json/yaml file with ## in non ref [E2E-CLI-064]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-p", "\"/path/e2e/fixtures/samples/swagger\"",
					"--silent"},
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}
