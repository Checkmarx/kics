package testcases

import "regexp"

// E2E-CLI-055 - Kics scan command with openapi files that are not resolved
// should resolve openapi files and return results in same file
func init() { //nolint
	testSample := TestCase{
		Name: "should resolve openapi files and return results in different files [E2E-CLI-055]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan", "-p", "/path/e2e/fixtures/samples/unresolved_openapi"},
			},
		},
		WantStatus: []int{50},
		Validation: func(outputText string) bool {
			matchQueryPath1, _ := regexp.MatchString(`openapi.yaml`, outputText)
			return matchQueryPath1
		},
	}

	Tests = append(Tests, testSample)
}
