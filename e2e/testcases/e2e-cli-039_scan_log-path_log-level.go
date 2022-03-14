package testcases

import "regexp"

// E2E-CLI-039 - KICS scan command with --log-path and --log-level
// should generate and save a log file based in the provided log-level
func init() { //nolint
	testSample := TestCase{
		Name: " should generate and save a log file with log level [E2E-CLI-039]",
		Args: args{
			Args: []cmdArgs{

				[]string{"scan", "--log-path", "/path/e2e/output/E2E_CLI_039_LOG",
					"--log-level", "Trace",
					"-p", "/path/e2e/fixtures/samples/positive.yaml"},
			},

			ExpectedLog: LogValidation{
				LogFile: "E2E_CLI_039_LOG",
				ValidationFunc: func(logText string) bool {
					match1, _ := regexp.MatchString("TRACE", logText)
					match2, _ := regexp.MatchString(`Inspector executed with result`, logText)
					match3, _ := regexp.MatchString(`Scan duration: \d+`, logText)
					return match1 && match2 && match3
				},
			},
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}
