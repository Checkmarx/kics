package utils

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

// CmdOutput stores the structure of kics output
type CmdOutput struct {
	Output []string
	Status int
}

// RunCommand executes the kics in a terminal
func RunCommand(kicsDockerImage string, kicsArgs []string, useMock bool) (*CmdOutput, error) {
	descriptionServer := "KICS_DESCRIPTIONS_ENDPOINT=http://kics.io"
	if useMock {
		descriptionServer = "KICS_DESCRIPTIONS_ENDPOINT=http://host.docker.internal:3000/kics-mock"
	}

	cwd, cwdErr := os.Getwd()
	if cwdErr != nil {
		return &CmdOutput{}, cwdErr
	}

	baseDir := filepath.Dir(cwd)
	dockerArgs := []string{"run", "-e", descriptionServer, "--add-host=host.docker.internal:host-gateway",
		"-v", baseDir + ":/path", kicsDockerImage}
	completeArgs := append(dockerArgs, kicsArgs...) //nolint

	cmd := exec.Command("docker", completeArgs...) //nolint
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

// GetKICSDockerImageName gets the kics docker image name
func GetKICSDockerImageName() string {
	var imageName = os.Getenv("E2E_KICS_DOCKER")
	if imageName == "" {
		imageName = "kics:e2e-tests"
	}
	return imageName
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
