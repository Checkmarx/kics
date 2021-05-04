package e2e

import (
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

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

func readFixture(testName string) (string, error) {
	return readFile(filepath.Join("fixtures", testName))
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
