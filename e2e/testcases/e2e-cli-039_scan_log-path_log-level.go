package testcases

import "regexp"

// E2E-CLI-039 - KICS scan command with --log-path and --log-level
// should generate and save a log file based in the provided log-level
func init() { //nolint
	testSample := TestCase{
		Name: " should generate and save a log file with log level [E2E-CLI-039]",
		Args: args{
			Args: []cmdArgs{

				[]string{"scan", "--log-path", "output/E2E_CLI_039_LOG",
					"--log-level", "Trace",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},
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
		WantStatus: []int{40},
	}

	Tests = append(Tests, testSample)
}
