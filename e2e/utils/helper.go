package utils

import (
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

// RunCommand executes the kics in a terminal
func RunCommand(kicsArgs []string, useDocker bool, useMock bool) (*CmdOutput, error) {
	descriptionServer := getDescriptionServer(useDocker, useMock)
	var source string
	var args []string

	if useDocker {
		source, args = runKicsDocker(kicsArgs, descriptionServer)
	} else {
		source, args = runKicsDev(kicsArgs)
	}

	cmd := exec.Command(source, args...) //nolint
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
	if path == "/path/e2e/fixtures/samples/config.json" {
		path = strings.Replace(path, "config.json", "config-dev.json", -1)
	}
	regex := regexp.MustCompile(`/path\/\w+\/`)
	matches := regex.FindString(path)
	switch matches {
	case "":
		return path
	case "/path/e2e/":
		return strings.Replace(path, matches, "", -1)
	default:
		return strings.Replace(path, "/path/", "../", -1)
	}
}

// GetKICSDockerImageName gets the kics docker image name
func GetKICSDockerImageName() string {
	return os.Getenv("E2E_KICS_DOCKER")
}

// GetKICSLocalBin returns the kics local bin path
func GetKICSLocalBin() string {
	if runtime.GOOS == "windows" {
		return filepath.Join("..", "bin", "kics.exe")
	} else {
		return filepath.Join("..", "bin", "kics")
	}
}

func runKicsDev(kicsArgs []string) (string, []string) {
	kicsRun := GetKICSLocalBin()
	var formatArgs []string
	for _, param := range kicsArgs {
		formatArgs = append(formatArgs, KicsDevPathAdapter(param))
	}
	return kicsRun, formatArgs
}

func runKicsDocker(kicsArgs []string, descriptionServer string) (string, []string) {
	kicsDockerImage := GetKICSDockerImageName()
	cwd, cwdErr := os.Getwd()
	if cwdErr != nil {
		return "", []string{}
	}
	baseDir := filepath.Dir(cwd)
	dockerArgs := []string{"run", "-e", descriptionServer, "--add-host=host.docker.internal:host-gateway",
		"-v", baseDir + ":/path", kicsDockerImage}
	completeArgs := append(dockerArgs, kicsArgs...) //nolint
	return "docker", completeArgs
}

func getDescriptionServer(useDocker bool, useMock bool) string {
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

// Contains returns if a string list contains an especific term
func Contains(list []string, searchTerm string) bool {
	for _, a := range list {
		if a == searchTerm {
			return true
		}
	}
	return false
}
