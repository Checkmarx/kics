// Package testcases provides end-to-end (E2E) testing functionality for the application.
package testcases

// E2E-CLI-099 - KICS scan with OpenAPI reference resolution enabled on JSON and YAML files containing circular references.
// The scan should complete successfully, returning exit code 50, producing equivalent payloads for both formats.
// The only differences should be the file extensions between payloads.
func init() { //nolint
	testSample := TestCase{
		Name: "scan should generate equivalent payloads for OpenAPI YAML and JSON files with circular references [E2E-CLI-099]",
		Args: args{
			Args: []cmdArgs{
				[]string{
					"scan", "-p", "\"/path/e2e/fixtures/samples/compare-openapi-payload-json-yaml/openAPIJson/openAPI.json\"",
					"-v", "-d", "/path/e2e/output/E2E_CLI_099_JSON_PAYLOAD.json", "--enable-openapi-refs",
				},
				[]string{
					"scan", "-p", "\"/path/e2e/fixtures/samples/compare-openapi-payload-json-yaml/openAPIYaml/openAPI.yaml\"",
					"-v", "-d", "/path/e2e/output/E2E_CLI_099_YAML_PAYLOAD.json", "--enable-openapi-refs",
				},
			},
			ExpectedPayload: []string{
				"E2E_CLI_099_JSON_PAYLOAD.json",
				"E2E_CLI_099_YAML_PAYLOAD.json",
			},
		},
		WantStatus: []int{50, 50},
	}

	Tests = append(Tests, testSample)
}
