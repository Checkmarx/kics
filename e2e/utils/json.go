package utils

import (
	"encoding/json"
	"io"
	"os"
	"path/filepath"
	"reflect"
	"runtime"
	"sort"
	"strings"
	"testing"
	"time"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/stretchr/testify/require"
	"github.com/xeipuuv/gojsonschema"
)

var filekey = "file"

type logMsg struct {
	Level    string `json:"level"`
	ErrorMgs string `json:"error"`
	Message  string `json:"message"`
}

func prepareJSONPath(path string) string {
	cwd, err := os.Getwd()
	if err != nil {
		return ""
	}

	jsonPath := "file://" + filepath.Join(cwd, path)
	if runtime.GOOS == windowsOs {
		jsonPath = strings.ReplaceAll(jsonPath, `\`, "/")
	}
	return jsonPath
}

// JSONSchemaValidationFromFile loads a json file and validates it against a schema
func JSONSchemaValidationFromFile(t *testing.T, file, schema string) {
	schemaPath := prepareJSONPath(filepath.Join("fixtures", "schemas", schema))
	resultPath := prepareJSONPath(filepath.Join("output", file))

	schemaLoader := gojsonschema.NewReferenceLoader(schemaPath)
	resultLoader := gojsonschema.NewReferenceLoader(resultPath)

	JSONSchemaCompare(t, schemaLoader, resultLoader)
}

// JSONSchemaValidationFromData loads a json data and validates it against a schema
func JSONSchemaValidationFromData(t *testing.T, data []byte, schema string) {
	schemaPath := prepareJSONPath(filepath.Join("fixtures", "schemas", schema))

	schemaLoader := gojsonschema.NewReferenceLoader(schemaPath)
	resultLoader := gojsonschema.NewBytesLoader(data)

	JSONSchemaCompare(t, schemaLoader, resultLoader)
}

// JSONSchemaCompare executes schema assertions to validate the content of a JSON file
func JSONSchemaCompare(t *testing.T, schema, report gojsonschema.JSONLoader) {
	result, err := gojsonschema.Validate(schema, report)
	require.NoError(t, err, "Schema Validation: Reading Json/Schema files should not yield an error"+
		"\nSchema: '%s'\nActual File: '%s'", schema.JsonSource(), report.JsonSource())

	schemaErrors := ""
	if !result.Valid() {
		for _, desc := range result.Errors() {
			schemaErrors += "- " + desc.String() + "\n"
		}
	}

	require.True(t, result.Valid(), "Schema Validation Failed\nSchema: '%s'"+
		"\nActual File: '%s'\nFailed validations:\n%v\n", schema.JsonSource(), report.JsonSource(), schemaErrors)
}

// PrepareExpected prepares the files for validation tests
func PrepareExpected(path, folder string) ([]string, error) {
	cont, err := ReadFixture(path, folder)
	if err != nil {
		return []string{}, err
	}
	cont = strings.Trim(cont, "")
	if strings.Contains(cont, "\r\n") {
		return strings.Split(cont, "\r\n"), nil
	}
	return strings.Split(cont, "\n"), nil
}

// ReadFixture reads a file based on a provided path and filename
func ReadFixture(testName, folder string) (string, error) {
	return readFile(filepath.Join(folder, testName))
}

func readFile(path string) (string, error) {
	ostat, err := os.Open(filepath.Clean(path))
	if err != nil {
		return "", err
	}
	bytes, err := io.ReadAll(ostat)
	if err != nil {
		errClose := ostat.Close()
		if errClose != nil {
			return "", errClose
		}
		return "", err
	}
	errClosed := ostat.Close()
	if errClosed != nil {
		return "", errClosed
	}
	return string(bytes), nil
}

func checkJSONLog(t *testing.T, expec, want logMsg) {
	require.Equal(t, expec.Level, want.Level,
		"\nExpected Output line log level\n%s\nKICS Output line log level:\n%s\n", want.Level, expec.Level)
	require.Equal(t, expec.ErrorMgs, want.ErrorMgs,
		"\nExpected Output line error msg\n%s\nKICS Output line error msg:\n%s\n", expec.ErrorMgs, want.ErrorMgs)
	require.Equal(t, expec.Message, want.Message,
		"\nExpected Output line msg\n%s\nKICS Output line msg:\n%s\n", expec.Message, want.Message)
}

// FileCheck executes assertions to validate file content length
func FileCheck(t *testing.T, actualPayloadName, expectPayloadName, location string) {
	expectPayload, err := PrepareExpected(expectPayloadName, "fixtures")
	require.NoError(t, err, "[fixtures/%s]: Reading a fixture should not yield an error", expectPayloadName)

	actualPayload, err := PrepareExpected(actualPayloadName, "output")
	require.NoError(t, err, "[output/%s] Reading a fixture should not yield an error", actualPayloadName)

	require.Equal(t, len(expectPayload), len(actualPayload),
		"[fixtures/%s] Expected file number of lines: %d\n[output/%s] Actual file number of lines: %d\n",
		expectPayloadName, len(expectPayload), actualPayloadName, len(actualPayload))
	setFields(t, expectPayload, actualPayload, expectPayloadName, actualPayloadName, location)
}

// CheckLine executes assertions to validate the content of two JSON files
func CheckLine(t *testing.T, expec, want string, line int) {
	logExp := logMsg{}
	logWant := logMsg{}
	errE := json.Unmarshal([]byte(expec), &logExp)
	errW := json.Unmarshal([]byte(want), &logWant)
	if errE == nil && errW == nil {
		checkJSONLog(t, logExp, logWant)
	} else {
		require.Equal(t, expec, want,
			"Expected Output line:\n%s\n\nKICS Output line:\n%s\n\nLine Number: %d", want, expec, line)
	}
}

//nolint:funlen
func setFields(t *testing.T, expect, actual []string, expectFileName, actualFileName, location string) {
	switch location {
	case "payload":
		var actualI model.Documents
		var expectI model.Documents
		errE := json.Unmarshal([]byte(strings.Join(expect, "\n")), &expectI)
		require.NoError(t, errE,
			"[fixtures/%s] Expected Payload - Unmarshaling JSON file should not yield an error", expectFileName)
		errW := json.Unmarshal([]byte(strings.Join(actual, "\n")), &actualI)
		require.NoError(t, errW,
			"[output/%s] Actual Payload - Unmarshaling JSON file should not yield an error", actualFileName)

		idKey := "id"
		for _, docs := range actualI.Documents {
			// Here additional checks may be added as length of id, or contains in file
			require.NotNil(t, docs[idKey])
			require.NotNil(t, docs[filekey])
			docs[idKey] = "0"
			docs[filekey] = filekey
		}

		require.Equal(t, expectI, actualI,
			"Expected Payload content: 'fixtures/%s' doesn't match the Actual Payload content: 'output/%s'.",
			expectFileName, actualFileName)

	case "result":
		timeValue := time.Date(2021, 5, 1, 9, 0, 0, 0, time.UTC)

		expectI := model.Summary{}
		actualI := model.Summary{}

		errE := json.Unmarshal([]byte(strings.Join(expect, "\n")), &expectI)
		require.NoError(t, errE,
			"[fixtures/%s] Expected Result - Unmarshaling JSON file should not yield an error", expectFileName)
		errW := json.Unmarshal([]byte(strings.Join(actual, "\n")), &actualI)
		require.NoError(t, errW,
			"[output/%s] Actual Result - Unmarshaling JSON file should not yield an error", actualFileName)

		// Disable dynamic values (to avoid errors during file comparison)
		actualI.TotalQueries = 0
		actualI.Start = timeValue
		actualI.End = timeValue
		expectI.TotalQueries = 0
		expectI.Start = timeValue
		expectI.End = timeValue
		actualI.Version = "development"
		expectI.Version = actualI.Version
		actualI.FailedToExecuteQueries = 0
		expectI.FailedToExecuteQueries = 0

		// Adapt path if running locally (dev)
		if GetKICSDockerImageName() == "" {
			for i, scanPath := range expectI.ScannedPaths {
				expectI.ScannedPaths[i] = KicsDevPathAdapter(scanPath)
			}
		}

		for i := range actualI.Queries {
			actualQuery := actualI.Queries[i]
			expectQuery := expectI.Queries[i]

			require.Equal(t, actualQuery.QueryName, expectQuery.QueryName,
				"Expected Result queries doesn't match the actual result queries [in the index: %d]."+
					"\nExpected File: 'fixtures/%s'.\nActual File: 'output/%s'.",
				i, expectFileName, actualFileName)

			require.Equal(t, len(actualQuery.Files), len(expectQuery.Files),
				"Expected query results doesn't match the actual query results [query: %s]."+
					"\nExpected File: 'fixtures/%s'.\nActual File: 'output/%s'.",
				actualQuery.QueryName, expectFileName, actualFileName)

			for j := range actualI.Queries[i].Files {
				actualQuery.Files[j].FileName = ""
				expectQuery.Files[j].FileName = ""
			}
			sort.Slice(actualQuery.Files, func(a, b int) bool {
				return actualQuery.Files[a].SimilarityID < actualQuery.Files[b].SimilarityID
			})
			sort.Slice(expectQuery.Files, func(a, b int) bool {
				return expectQuery.Files[a].SimilarityID < expectQuery.Files[b].SimilarityID
			})
		}

		require.ElementsMatch(t, expectI.ScannedPaths, actualI.ScannedPaths,
			"Expected Result content: 'fixtures/%s' doesn't match the Actual Result Scanned Paths content: 'output/%s'.",
			expectFileName, actualFileName)

		// compare the results
		expectToCompare := []model.VulnerableFile{}
		for i := range expectI.Queries {
			expectToCompare = append(expectToCompare, expectI.Queries[i].Files...)
		}
		actualToCompare := []model.VulnerableFile{}
		for i := range actualI.Queries {
			actualToCompare = append(actualToCompare, actualI.Queries[i].Files...)
		}
		require.ElementsMatch(t, expectToCompare, actualToCompare,
			"Expected Queries content: 'fixtures/%s' doesn't match the Actual Queries content: 'output/%s'.",
			expectToCompare, actualToCompare)

		// compare severity counters
		compare := reflect.DeepEqual(expectI.SeverityCounters, actualI.SeverityCounters)
		require.True(t, compare, "Expected Severity Counters content: 'fixtures/%s' doesn't match the Actual Severity Counters content: 'output/%s'.", //nolint:lll
			expectI.SeverityCounters, actualI.SeverityCounters)
	}
}
