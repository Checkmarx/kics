package testcases

// E2E-CLI-026 - KICS scan command with --ignore-on-exit flag
// should return status code 0 if the provided flag occurs.
// Example: '--ignore-on-exit errors' -> Returns 0 if an error was found, instead of 126/130...
func init() { //nolint
	testSample := TestCase{
		Name: "should ignore on exit provided flags [E2E-CLI-026]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "--ignore-on-exit",
					"-s", "-p", "/path/e2e/fixtures/samples/terraform-single.invalid.name"},

				[]string{"scan", "--ignore-on-exit", "errors",
					"-s", "-p", "/path/e2e/fixtures/samples/terraform-single.invalid.name"},

				[]string{"scan", "--ignore-on-exit", "errors",
					"-s", "-p", "/path/e2e/fixtures/samples/positive.yaml"},

				[]string{"scan", "--ignore-on-exit", "all",
					"-s", "-p", "/path/e2e/fixtures/samples/positive.yaml"},
			},
		},
		WantStatus: []int{126, 0, 50, 0},
	}

	Tests = append(Tests, testSample)
}
