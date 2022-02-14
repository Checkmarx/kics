package testcases

import "regexp"

// E2E-CLI-038 - KICS scan command with --log-path
// should generate and save a log file for the scan
func init() { //nolint
	testSample := TestCase{
		Name: "should generate and save a log file [E2E-CLI-038]",
		Args: args{
			Args: []cmdArgs{

				[]string{"scan", "--log-path", "output/E2E_CLI_038_LOG",
					"-q", "../assets/queries", "-p", "fixtures/samples/positive.yaml"},
			},

			ExpectedLog: LogValidation{
				LogFile: "E2E_CLI_038_LOG",
				ValidationFunc: func(logText string) bool {
					match1, _ := regexp.MatchString("Scanning with Keeping Infrastructure as Code Secure", logText)
					match2, _ := regexp.MatchString(`Files scanned: \d+`, logText)
					match3, _ := regexp.MatchString(`Queries loaded: \d+`, logText)
					return match1 && match2 && match3
				},
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}
