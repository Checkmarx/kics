package e2e

import (
	"io"
	"os"
	"os/exec"
	"path/filepath"
)

func runCommandAndReturnOutput(args []string) (stdout string, err error) {
	cmd := exec.Command(args[0], args[1:]...) //nolint
	stdOutput, err := cmd.Output()
	if err != nil {
		return "", err
	}
	return string(stdOutput), nil
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
		return "", err
	}
	return string(bytes), nil
}

func getKICSBinaryPath(path string) string {
	var rtnPath string
	if path == "" {
		rtnPath = os.Getenv("E2E_KICS_BINARY")
	} else {
		rtnPath = path
	}
	return rtnPath
}
