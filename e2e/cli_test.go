package e2e

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"text/template"
	"time"

	"github.com/Checkmarx/kics/v2/e2e/testcases"
	"github.com/Checkmarx/kics/v2/e2e/utils"
	"github.com/stretchr/testify/require"
)

func Test_E2E_CLI(t *testing.T) {
	kicsDockerImage := utils.GetKICSDockerImageName()
	// In the CI environment the tests will be run in a Docker container.
	// Locally, you are able to choose between running kics from docker or go (default)
	useDocker := kicsDockerImage != ""
	showDetailsCI := useDocker

	if !useDocker {
		kicsLocalBin := utils.GetKICSLocalBin()
		// If you are not running kics e2e tests in a docker container
		// you need to make sure that the kics binary is available.
		if _, err := os.Stat(kicsLocalBin); os.IsNotExist(err) {
			t.Skip("E2E Locally execution must have a kics binary in the 'bin' folder.\nPath not found: " + kicsLocalBin)
		}
	}

	scanStartTime := time.Now()

	if testing.Short() {
		t.Skip("skipping E2E tests in short mode.")
	}

	templates := prepareTemplates()

	for _, tt := range testcases.Tests {
		for arg := range tt.Args.Args {
			tt := tt
			arg := arg
			t.Run(fmt.Sprintf("%s_%d", tt.Name, arg), func(t *testing.T) {
				t.Parallel()

				useMock := false
				if arg <= len(tt.Args.UseMock)-1 && tt.Args.UseMock[arg] {
					useMock = true
				}

				out, err := utils.RunCommand(tt.Args.Args[arg], useDocker, useMock, kicsDockerImage)
				// Check command Error
				require.NoError(t, err, "Capture CLI output should not yield an error")

				// Check exit status code (required)
				require.True(t, arg < len(tt.WantStatus),
					"No status code associated to this test. Check the wantStatus of the test case.")

				if showDetailsCI && tt.WantStatus[arg] != out.Status {
					printTestDetails(out.Output)
				}

				require.Equalf(t, tt.WantStatus[arg], out.Status,
					"Actual KICS status code: %v\nExpected KICS status code: %v",
					out.Status, tt.WantStatus[arg])

				if tt.Validation != nil {
					fullString := strings.Join(out.Output, ";")
					validation := tt.Validation(fullString)
					if showDetailsCI && !validation {
						printTestDetails(out.Output)
					}
					require.True(t, validation, "KICS CLI output doesn't match the regex validation.")
				}

				if tt.Args.ExpectedResult != nil && arg < len(tt.Args.ExpectedResult) {
					checkExpectedOutput(t, &tt, arg)
				}

				if tt.Args.ExpectedAnalyzerResults != nil && arg < len(tt.Args.ExpectedResult) {
					checkExpectedAnalyzerResults(t, &tt, arg)
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
		if err != nil {
			t.Logf("\nError when trying to remove tests output folder %v\n", err)
		}
		err = os.RemoveAll("tmp-kics-ar")
		if err != nil {
			t.Logf("\nError when trying to remove tmp-kics-ar folder %v\n", err)
		}
		t.Logf("E2E tests ::ellapsed time:: %v", time.Since(scanStartTime))
	})
}

func checkExpectedAnalyzerResults(t *testing.T, tt *testcases.TestCase, argIndex int) {
	jsonFileName := tt.Args.ExpectedResult[argIndex].ResultsFile + ".json"
	utils.JSONSchemaValidationFromFile(t, jsonFileName, "AnalyzerResults.json")
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
		utils.JSONSchemaValidationFromFile(t, jsonFileName, "result.json")
	}
	// Check result file (JSON including BoM)
	if utils.Contains(resultsFormats, "json-bom") {
		utils.JSONSchemaValidationFromFile(t, jsonFileName, "resultBoM.json")
	}
	// Check result file (JSON including CIS Descriptions)
	if utils.Contains(resultsFormats, "json-cis") {
		utils.JSONSchemaValidationFromFile(t, jsonFileName, "resultCIS.json")
	}
	// Check result file (GLSAST)
	if utils.Contains(resultsFormats, "glsast") {
		utils.JSONSchemaValidationFromFile(t, "gl-sast-"+jsonFileName, "result-gl-sast.json")
	}
	// Check result file (SONARQUBE)
	if utils.Contains(resultsFormats, "sonarqube") {
		utils.JSONSchemaValidationFromFile(t, "sonarqube-"+jsonFileName, "result-sonarqube.json")
	}
	// Check result file (ASFF)
	if utils.Contains(resultsFormats, "asff") {
		utils.JSONSchemaValidationFromFile(t, "asff-"+jsonFileName, "result-asff.json")
	}
	// Check result file (CODECLIMATE)
	if utils.Contains(resultsFormats, "codeclimate") {
		utils.JSONSchemaValidationFromFile(t, "codeclimate-"+jsonFileName, "result-codeclimate.json")
	}
	// Check result file (SARIF)
	if utils.Contains(resultsFormats, "sarif") {
		utils.JSONSchemaValidationFromFile(t, tt.Args.ExpectedResult[argIndex].ResultsFile+".sarif", "result-sarif.json")
	}
	// Check result file (HTML)
	if utils.Contains(resultsFormats, "html") {
		utils.HTMLValidation(t, tt.Args.ExpectedResult[argIndex].ResultsFile+".html")
	}
	// Check result file (JUNIT - XML)
	if utils.Contains(resultsFormats, "junit") {
		filename := "junit-" + tt.Args.ExpectedResult[argIndex].ResultsFile + ".xml"
		json := utils.XMLToJSON(t, filename, "junit")
		utils.JSONSchemaValidationFromData(t, json, "result-junit.json")
	}
	// Check result file (CYCLONEDX - XML)
	if utils.Contains(resultsFormats, "cyclonedx") {
		filename := "cyclonedx-" + tt.Args.ExpectedResult[argIndex].ResultsFile + ".xml"
		json := utils.XMLToJSON(t, filename, "cyclonedx")
		utils.JSONSchemaValidationFromData(t, json, "result-cyclonedx.json")
	}
	// Check result file (CSV)
	if utils.Contains(resultsFormats, "csv") || utils.Contains(resultsFormats, "csv-cis") {
		filename := tt.Args.ExpectedResult[argIndex].ResultsFile + ".csv"
		json := utils.CSVToJSON(t, filename)

		if utils.Contains(resultsFormats, "csv-cis") {
			utils.JSONSchemaValidationFromData(t, json, "result-csv-cis.json")
		} else {
			utils.JSONSchemaValidationFromData(t, json, "result-csv.json")
		}
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

	var remediateHelp, errFH = utils.PrepareExpected("remediate_help", "fixtures/assets")
	if errFH != nil {
		remediateHelp = []string{}
	}

	var analyzeHelp, errAH = utils.PrepareExpected("analyze_help", "fixtures/assets")
	if errAH != nil {
		analyzeHelp = []string{}
	}

	return testcases.TestTemplates{
		Help:          strings.Join(help, "\n"),
		ScanHelp:      strings.Join(scanHelp, "\n"),
		RemediateHelp: strings.Join(remediateHelp, "\n"),
		AnalyzeHelp:   strings.Join(analyzeHelp, "\n"),
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

	t := builder.String()

	builder.Reset()
	builder = nil

	return strings.Split(t, "\n")
}

func printTestDetails(output []string) {
	fmt.Println("\nKICS OUTPUT:")
	fmt.Println("====== BEGIN ======")
	for _, line := range output {
		fmt.Println(line)
	}
	fmt.Println("======= END =======")
}
