package utils

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"runtime"
	"strings"
)

// CmdOutput stores the structure of kics output
type CmdOutput struct {
	Output []string
	Status int
}

const windowsOs = "windows"

// RunCommand executes the kics in a terminal
func RunCommand(kicsArgs []string, useDocker, useMock bool, kicsDockerImage string) (*CmdOutput, error) {
	descriptionServer := getDescriptionServer(useDocker, useMock)
	var source string
	var args []string

	if useDocker {
		source, args = runKicsDocker(kicsArgs, descriptionServer, kicsDockerImage)
	} else {
		source, args = runKicsDev(kicsArgs)
	}

	cmd := exec.Command(source, args...) //#nosec
	cmd.Env = append(os.Environ(), descriptionServer)
	stdOutput, err := cmd.CombinedOutput()
	if err != nil {
		if exitError, ok := err.(*exec.ExitError); ok {
			return &CmdOutput{
				Output: strings.Split(string(stdOutput), "\n"),
				Status: exitError.ExitCode(),
			}, nil
		}
		return &CmdOutput{}, err
	}
	return &CmdOutput{
		Output: strings.Split(string(stdOutput), "\n"),
		Status: 0,
	}, nil
}

// KicsDevPathAdapter adapts the path to enable kics locally execution
func KicsDevPathAdapter(path string) string {
	// [e2e-029] and [e2e-056] config tests
	switch path {
	case "/path/e2e/fixtures/samples/configs/config.json":
		path = strings.ReplaceAll(path, "config.json", "config-dev.json")
	case "/path/e2e/fixtures/samples/configs/config.yaml":
		path = strings.ReplaceAll(path, "config.yaml", "config-dev.yaml")
	}
	regex := regexp.MustCompile(`/path/\w+/`)
	matches := regex.FindString(path)
	switch matches {
	case "":
		return path
	case "/path/e2e/":
		return strings.ReplaceAll(path, matches, "")
	default:
		return strings.ReplaceAll(path, "/path/", "../")
	}
}

// GetKICSDockerImageName gets the kics docker image name
func GetKICSDockerImageName() string {
	return os.Getenv("E2E_KICS_DOCKER")
}

// GetKICSLocalBin returns the kics local bin path
func GetKICSLocalBin() string {
	if runtime.GOOS == windowsOs {
		return filepath.Join("..", "bin", "kics.exe")
	}
	return filepath.Join("..", "bin", "kics")
}

func runKicsDev(kicsArgs []string) (bin string, args []string) {
	kicsRun := GetKICSLocalBin()
	var formatArgs []string
	for _, param := range kicsArgs {
		formatArgs = append(formatArgs, KicsDevPathAdapter(param))
	}
	return kicsRun, formatArgs
}

func runKicsDocker(kicsArgs []string, descriptionServer, kicsDockerImage string) (docker string, args []string) {
	cwd, cwdErr := os.Getwd()
	if cwdErr != nil {
		return "", []string{}
	}
	baseDir := filepath.Dir(cwd)
	dockerArgs := []string{"run", "-e", descriptionServer, "--add-host=host.docker.internal:host-gateway",
		"--user", fmt.Sprintf("%d:%d", os.Getuid(), os.Getgid()),
		"-v", baseDir + ":/path", kicsDockerImage}
	completeArgs := append(dockerArgs, kicsArgs...) //nolint
	return "docker", completeArgs
}

func getDescriptionServer(useDocker, useMock bool) string {
	descriptionServer := "KICS_DESCRIPTIONS_ENDPOINT=http://kics.io"
	if useMock {
		if useDocker {
			descriptionServer = "KICS_DESCRIPTIONS_ENDPOINT=http://host.docker.internal:3000/kics-mock"
		} else {
			descriptionServer = "KICS_DESCRIPTIONS_ENDPOINT=http://localhost:3000/kics-mock"
		}
	}
	return descriptionServer
}

// Contains returns if a string list contains an specific term
func Contains(list []string, searchTerm string) bool {
	for _, a := range list {
		if a == searchTerm {
			return true
		}
	}
	return false
}
