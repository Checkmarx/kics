package e2e

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/test"
	"github.com/stretchr/testify/require"
)

type logMsg struct {
	Level    string `json:"level"`
	ErrorMgs string `json:"error"`
	Message  string `json:"message"`
}

type cmdArgs []string

type args struct {
	args            []cmdArgs // args to pass to kics binary
	expectedOut     []string  // path to file with expected output
	expectedPayload []string
}

var tests = []struct {
	name          string
	args          args
	wantStatus    int
	removePayload []string
}{
	// E2E_CLI_001 - KICS command should display a help text in the CLI when provided with the
	// 	 --help flag and it should describe the available commands plus the global flags
	{
		name: "E2E_CLI_001",
		args: args{
			args: []cmdArgs{
				[]string{"--help"},
			},
			expectedOut:     []string{"E2E_CLI_001"},
			expectedPayload: []string{},
		},
		removePayload: []string{},
		wantStatus:    0,
	},
	// E2E-CLI-002 - KICS scan command should display a help text in the CLI when provided with the
	// --help flag and it should describe the options related with scan plus the global options
	{
		name: "E2E-CLI-002",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--help"},
			},
			expectedOut: []string{"E2E_CLI_002"},
		},
		wantStatus: 0,
	},
	// E2E-CLI-003 - KICS scan command had a mandatory flag -p the CLI should exhibit
	// an error message and return exit code 1
	{
		name: "E2E-CLI-003",
		args: args{
			args: []cmdArgs{
				[]string{"scan"},
			},
			expectedOut: []string{"E2E_CLI_003"},
		},
		wantStatus: 1,
	},
	// E2E-CLI-004 - KICS scan command had a mandatory flag -p the CLI should exhibit
	// an error message and return exit code 1
	{
		name: "E2E-CLI-004",
		args: args{
			args: []cmdArgs{
				[]string{"--ci", "--verbose"},
				[]string{"scan", "--ci", "--verbose"},
				[]string{"--ci", "scan", "--verbose"},
			},
			expectedOut: []string{
				"E2E_CLI_004",
				"E2E_CLI_004",
				"E2E_CLI_004",
			},
		},
		wantStatus: 1,
	},
	// E2E-CLI-005 - KICS scan with -- payload-path flag should create a file with the
	// passed name containing the payload of the files scanned
	{
		name: "E2E-CLI-005",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--silent", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf",
					"--payload-path", "fixtures/payload.json", "-q", "../assets/queries"},
			},
			expectedOut: []string{
				"E2E_CLI_005",
			},
			expectedPayload: []string{
				"E2E_CLI_005_PAYLOAD",
			},
		},
		wantStatus:    0,
		removePayload: []string{"payload.json"},
	},
}

func Test_E2E_CLI(t *testing.T) {
	kicsPath := getKICSBinaryPath("")

	if testing.Short() {
		t.Skip("skipping E2E tests in short mode.")
	}

	for _, tt := range tests {
		for arg := range tt.args.args {
			t.Run(fmt.Sprintf("%s_%d", tt.name, arg), func(t *testing.T) {
				out, err := runCommand(append(kicsPath, tt.args.args[arg]...))
				// Check command Error
				require.NoError(t, err, "Capture output should not yield an error")
				// Check exit status code
				if !reflect.DeepEqual(out.status, tt.wantStatus) {
					t.Errorf("kics status = %v, want status = %v", out.status, tt.wantStatus)
				}
				// Get and preapare expected output
				want, err := prepareExpected(tt.args.expectedOut[arg])
				require.NoError(t, err, "Reading a fixture should not yield an error")
				// Check Number of Lines
				require.Equal(t, len(want), len(out.output),
					"\nExpected number of stdout lines:%d\nActual of stdout lines:%d\n", len(want), len(out.output))
				// Check output lines
				for idx := range want {
					checkLine(t, out.output[idx], want[idx], idx+1)
				}
				// Check payload files
				for _, file := range tt.removePayload {
					fileCheck(t, file, tt.args.expectedPayload[arg])
				}
			})
		}
	}
}

func prepareExpected(path string) ([]string, error) {
	cont, err := readFixture(path)
	if err != nil {
		return []string{}, err
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

func checkJSONLog(t *testing.T, expec, want logMsg) {
	require.Equal(t, expec.Level, want.Level,
		"\nExpected Output line log level\n%s\nKICS Output line log level:\n%s\n", want.Level, expec.Level)
	require.Equal(t, expec.ErrorMgs, want.ErrorMgs,
		"\nExpected Output line error msg\n%s\nKICS Output line error msg:\n%s\n", expec.ErrorMgs, want.ErrorMgs)
	require.Equal(t, expec.Message, want.Message,
		"\nExpected Output line msg\n%s\nKICS Output line msg:\n%s\n", expec.Message, want.Message)
}

func fileCheck(t *testing.T, remove, payload string) {
	wantPayload, err := prepareExpected(payload)
	require.NoError(t, err, "Reading a fixture should not yield an error")
	expectPayload, err := prepareExpected(remove)
	require.NoError(t, err, "Reading a fixture should not yield an error")
	require.Equal(t, len(wantPayload), len(expectPayload),
		"\nExpected file number of lines:%d\nKics file number of lines:%d\n", len(wantPayload), len(expectPayload))
	checkJSONFile(t, wantPayload, expectPayload)
	err = os.Remove(filepath.Join("fixtures", remove))
	require.NoError(t, err)
}

func checkJSONFile(t *testing.T, expect, want []string) { // Needs to fixed
	var wantI model.Documents
	var expecI model.Documents
	errE := json.Unmarshal([]byte(strings.Join(expect, "\n")), &expecI)
	require.NoError(t, errE, "Unmarshaling JSON file should not yield an error")
	errW := json.Unmarshal([]byte(strings.Join(want, "\n")), &wantI)
	require.NoError(t, errW, "Unmarshaling JSON file should not yield an error")
	setFields(t, wantI, expecI, "payload")
}

func setFields(t *testing.T, want, expect model.Documents, location string) {
	switch location {
	case "payload":
		for _, docs := range want.Documents {
			require.NotNil(t, docs["id"]) // Here additional checks may be added as length of id, or contains in file
			require.NotNil(t, docs["file"])
			docs["id"] = "0"
			docs["file"] = "file"
		}
		if !reflect.DeepEqual(expect, want) {
			expectStr, err := test.StringifyStruct(expect)
			require.NoError(t, err)
			wantStr, err := test.StringifyStruct(want)
			require.NoError(t, err)
			t.Errorf("Expected:\n%v\n,want:\n%v\n", expectStr, wantStr)
		}
	case "result": // TODO
	default:
	}
}
