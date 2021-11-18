package e2e

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"text/template"
	"time"

	"github.com/Checkmarx/kics/e2e/testcases"
	"github.com/Checkmarx/kics/e2e/utils"
	"github.com/stretchr/testify/require"
)

func Test_E2E_CLI(t *testing.T) {
	kicsPath := utils.GetKICSBinaryPath("")
	scanStartTime := time.Now()

	if testing.Short() {
		t.Skip("skipping E2E tests in short mode.")
	}

	templates := prepareTemplates()

	for _, tt := range testcases.Tests[30:31] {
		for arg := range tt.Args.Args {
			tt := tt
			arg := arg
			t.Run(fmt.Sprintf("%s_%d", tt.Name, arg), func(t *testing.T) {
				t.Parallel()

				useMock := false
				if arg <= len(tt.Args.UseMock)-1 && tt.Args.UseMock[arg] {
					useMock = true
				}

				out, err := utils.RunCommand(append(kicsPath, tt.Args.Args[arg]...), useMock)
				// Check command Error
				require.NoError(t, err, "Capture CLI output should not yield an error")

				// Check exit status code (required)
				require.True(t, arg < len(tt.WantStatus),
					"No status code associated to this test. Check the wantStatus of the test case.")
				require.Equalf(t, tt.WantStatus[arg], out.Status,
					"Actual KICS status code: %v\nExpected KICS status code: %v",
					out.Status, tt.WantStatus[arg])

				if tt.Validation != nil {
					fullString := strings.Join(out.Output, ";")
					validation := tt.Validation(fullString)
					require.True(t, validation, "KICS CLI output doesn't match the regex validation.")
				}

				if tt.Args.ExpectedResult != nil && arg < len(tt.Args.ExpectedResult) {
					checkExpectedOutput(t, &tt, arg)
				}

				if tt.Args.ExpectedPayload != nil {
					// Check payload file
					utils.FileCheck(t, tt.Args.ExpectedPayload[arg], tt.Args.ExpectedPayload[arg], "payload")
				}

				if tt.Args.ExpectedLog.ValidationFunc != nil {
					// Check log file
					logData, _ := utils.ReadFixture(tt.Args.ExpectedLog.LogFile, "output")
					validation := tt.Args.ExpectedLog.ValidationFunc(logData)
					require.Truef(t, validation, "The output log file 'output/%s' doesn't match the regex validation",
						tt.Args.ExpectedLog.LogFile)
				}

				if tt.Args.ExpectedOut != nil {
					// Get and preapare expected output
					want, errPrep := utils.PrepareExpected(tt.Args.ExpectedOut[arg], "fixtures")
					require.NoErrorf(t, errPrep, "[fixtures/%s] Reading a fixture should not yield an error",
						tt.Args.ExpectedOut[arg])

					formattedWant := loadTemplates(want, templates)

					// Check number of Lines
					require.Equal(t, len(formattedWant), len(out.Output),
						"[fixtures/%s] Expected number lines: %d\n[CLI] Actual KICS output lines: %d",
						tt.Args.ExpectedOut[arg], len(formattedWant), len(out.Output))

					// Check output lines
					for idx := range formattedWant {
						utils.CheckLine(t, out.Output[idx], formattedWant[idx], idx+1)
					}
				}
			})
		}
	}

	t.Cleanup(func() {
		err := os.RemoveAll("output")
		require.NoError(t, err)
		t.Logf("E2E tests ::ellapsed time:: %v", time.Since(scanStartTime))
	})
}

func checkExpectedOutput(t *testing.T, tt *testcases.TestCase, argIndex int) {
	jsonFileName := tt.Args.ExpectedResult[argIndex].ResultsFile + ".json"
	resultsFormats := tt.Args.ExpectedResult[argIndex].ResultsFormats
	// Check result file (compare with sample)
	if _, err := os.Stat(filepath.Join("fixtures", jsonFileName)); err == nil {
		utils.FileCheck(t, jsonFileName, jsonFileName, "result")
	}
	// Check result file (JSON)
	if utils.Contains(resultsFormats, "json") {
		utils.JSONSchemaValidation(t, jsonFileName, "result.json")
	}
	// Check result file (JSON including BoM)
	if utils.Contains(resultsFormats, "json-bom") {
		utils.JSONSchemaValidation(t, jsonFileName, "resultBoM.json")
	}
	// Check result file (JSON including BoM)
	if utils.Contains(resultsFormats, "json-cis") {
		utils.JSONSchemaValidation(t, jsonFileName, "resultCIS.json")
	}
	// Check result file (GLSAST)
	if utils.Contains(resultsFormats, "glsast") {
		utils.JSONSchemaValidation(t, "gl-sast-"+jsonFileName, "result-gl-sast.json")
	}
	// Check result file (SARIF)
	if utils.Contains(resultsFormats, "sarif") {
		utils.JSONSchemaValidation(t, tt.Args.ExpectedResult[argIndex].ResultsFile+".sarif", "result-sarif.json")
	}
	// Check result file (HTML)
	if utils.Contains(resultsFormats, "html") {
		utils.HTMLValidation(t, tt.Args.ExpectedResult[argIndex].ResultsFile+".html")
	}
}

func prepareTemplates() testcases.TestTemplates {
	var help, errH = utils.PrepareExpected("help", "fixtures/assets")
	if errH != nil {
		help = []string{}
	}

	var scanHelp, errSH = utils.PrepareExpected("scan_help", "fixtures/assets")
	if errSH != nil {
		scanHelp = []string{}
	}

	return testcases.TestTemplates{
		Help:     strings.Join(help, "\n"),
		ScanHelp: strings.Join(scanHelp, "\n"),
	}
}

func loadTemplates(lines []string, templates testcases.TestTemplates) []string {
	temp, err := template.New("templates").Parse(strings.Join(lines, "\n"))
	if err != nil {
		return []string{}
	}

	builder := &strings.Builder{}

	err = temp.Execute(builder, templates)
	if err != nil {
		return []string{}
	}

	return strings.Split(builder.String(), "\n")
}
