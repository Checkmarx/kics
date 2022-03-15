package testcases

import (
	"regexp"
)

// E2E-CLI-019 - KICS scan with multiple paths
// should run a scan for all provided paths/files
func init() { //nolint
	testSample := TestCase{
		Name: "should run a scan in multiple paths [E2E-CLI-019]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-v", "-p", "/path/e2e/fixtures/samples/positive.dockerfile,/path/e2e/fixtures/samples/positive.yaml"},
			},
		},
		Validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Loading queries of type: (dockerfile|cloudformation), (dockerfile|cloudformation)`, outputText)
			return match
		},
		WantStatus: []int{50},
	}

	Tests = append(Tests, testSample)
}
