package e2e

import (
	"encoding/json"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/test"
	"github.com/stretchr/testify/require"
)

type logMsg struct {
	Level    string `json:"level"`
	ErrorMgs string `json:"error"`
	Message  string `json:"message"`
}

type cmdOutput struct {
	output []string
	status int
}

func runCommand(args []string) (*cmdOutput, error) {
	cmd := exec.Command(args[0], args[1:]...) //nolint
	stdOutput, err := cmd.CombinedOutput()
	if err != nil {
		if exitError, ok := err.(*exec.ExitError); ok {
			return &cmdOutput{
				output: strings.Split(string(stdOutput), "\n"),
				status: exitError.ExitCode(),
			}, nil
		}
		return &cmdOutput{}, err
	}
	return &cmdOutput{
		output: strings.Split(string(stdOutput), "\n"),
		status: 0,
	}, nil
}

func readFixture(testName, folder string) (string, error) {
	return readFile(filepath.Join(folder, testName))
}

func readFile(path string) (string, error) {
	ostat, err := os.Open(filepath.Clean(path))
	if err != nil {
		return "", err
	}
	bytes, err := io.ReadAll(ostat)
	if err != nil {
		ostat.Close()
		return "", err
	}
	ostat.Close()
	return string(bytes), nil
}

func getKICSBinaryPath(path string) []string {
	var rtnPath string
	if path == "" {
		rtnPath = os.Getenv("E2E_KICS_BINARY")
	} else {
		rtnPath = path
	}
	return []string{rtnPath}
}

func checkJSONLog(t *testing.T, expec, want logMsg) {
	require.Equal(t, expec.Level, want.Level,
		"\nExpected Output line log level\n%s\nKICS Output line log level:\n%s\n", want.Level, expec.Level)
	require.Equal(t, expec.ErrorMgs, want.ErrorMgs,
		"\nExpected Output line error msg\n%s\nKICS Output line error msg:\n%s\n", expec.ErrorMgs, want.ErrorMgs)
	require.Equal(t, expec.Message, want.Message,
		"\nExpected Output line msg\n%s\nKICS Output line msg:\n%s\n", expec.Message, want.Message)
}

func fileCheck(t *testing.T, expectedPayloadID, wantedPayloadID, location string) {
	wantPayload, err := prepareExpected(wantedPayloadID, "fixtures")
	require.NoError(t, err, "Reading a fixture should not yield an error")
	expectPayload, err := prepareExpected(expectedPayloadID, "output")
	require.NoError(t, err, "Reading a fixture should not yield an error")
	require.Equal(t, len(wantPayload), len(expectPayload),
		"\n[%s] Expected file number of lines:%d\nKics file number of lines:%d\n", location, len(wantPayload), len(expectPayload))
	setFields(t, wantPayload, expectPayload, location)
}

func prepareExpected(path, folder string) ([]string, error) {
	cont, err := readFixture(path, folder)
	if err != nil {
		return []string{}, err
	}
	if strings.Contains(cont, "\r\n") {
		return strings.Split(cont, "\r\n"), nil
	}
	return strings.Split(cont, "\n"), nil
}

func checkLine(t *testing.T, expec, want string, line int) {
	logExp := logMsg{}
	logWant := logMsg{}
	errE := json.Unmarshal([]byte(expec), &logExp)
	errW := json.Unmarshal([]byte(want), &logWant)
	if errE == nil && errW == nil {
		checkJSONLog(t, logExp, logWant)
	} else {
		require.Equal(t, expec, want,
			"\nExpected Output line\n%s\nKICS Output line:\n%s\n line: %d", want, expec, line)
	}
}

func setFields(t *testing.T, expect, want []string, location string) {
	filekey := "file"
	switch location {
	case "payload":
		var wantI model.Documents
		var expectI model.Documents
		errE := json.Unmarshal([]byte(strings.Join(expect, "\n")), &expectI)
		require.NoError(t, errE, "[payload] Unmarshaling JSON file should not yield an error")
		errW := json.Unmarshal([]byte(strings.Join(want, "\n")), &wantI)
		require.NoError(t, errW, "[payload] Unmarshaling JSON file should not yield an error")

		idKey := "id"
		for _, docs := range wantI.Documents {
			// Here additional checks may be added as length of id, or contains in file
			require.NotNil(t, docs[idKey])
			require.NotNil(t, docs[filekey])
			docs[idKey] = "0"
			docs[filekey] = filekey
		}

		expectStr, err := test.StringifyStruct(expectI)
		require.NoError(t, err)
		wantStr, err := test.StringifyStruct(wantI)
		require.NoError(t, err)

		require.Equal(t, expectI, wantI,
			"\nExpected:\n%v\n,Actual:\n%v\n", expectStr, wantStr)

	case "result":
		timeValue := time.Date(2021, 5, 1, 9, 0, 0, 0, time.UTC)

		expectI := model.Summary{}
		wantI := model.Summary{}

		errE := json.Unmarshal([]byte(strings.Join(expect, "\n")), &expectI)
		require.NoError(t, errE, "[result] Unmarshaling JSON file should not yield an error")
		errW := json.Unmarshal([]byte(strings.Join(want, "\n")), &wantI)
		require.NoError(t, errW, "[result] Unmarshaling JSON file should not yield an error")

		wantI.TotalQueries = 0
		wantI.Start = timeValue
		wantI.End = timeValue
		expectI.Start = timeValue
		expectI.End = timeValue
		for i := range wantI.Queries {
			for j := range expectI.Queries[i].Files {
				wantI.Queries[i].Files[j].FileName = filekey
			}
		}

		require.Equal(t, expectI, wantI,
			"\nExpected:\n%v\n,Actual:\n%v\n", expectI, wantI)
	}
}
