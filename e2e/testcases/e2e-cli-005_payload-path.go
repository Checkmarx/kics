package testcases

// E2E-CLI-005 - KICS scan with -- payload-path flag should create a file with the
// passed name containing the payload of the files scanned

func init() {
	testSample := TestCase{
		Name: "should create a payload file [E2E-CLI-005]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--silent", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf",
					"--payload-path", "output/E2E_CLI_005_PAYLOAD.json"},
			},
			ExpectedOut: []string{
				"E2E_CLI_005",
			},
			ExpectedPayload: []string{
				"E2E_CLI_005_PAYLOAD.json",
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}
