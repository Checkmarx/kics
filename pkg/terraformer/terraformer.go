package terraformer

import (
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"

	tfLogger "log"

	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

const terraformerPathLength = 2

// for testing purposes
var (
	runTerraformerFunc        func(pathOptions *Path, destination string) (string, error) = runTerraformer
	saveTerraformerOutputFunc func(destination, output string) error                      = saveTerraformerOutput
)

// Path is a struct that contains the terraformer path information
type Path struct {
	CloudProvider string
	Regions       string
	Resources     string
	Projects      string
}

// Import imports the terraformer resources into the destination using terraformer
func Import(terraformerPath, destinationPath string) (string, error) {
	log.Info().Msg("importing terraformer resources")
	tfLogger.SetOutput(io.Discard)

	// extracts relevant info from KICS Terraformer Path Syntax
	pathOptions, err := extractTerraformerOptions(terraformerPath)
	if err != nil {
		return "", errors.Wrap(err, "wrong terraformer path syntax")
	}
	if destinationPath == "" {
		destinationPath, err = os.Getwd()
		if err != nil {
			return "", errors.Wrap(err, "failed to get working directory")
		}
	}

	// set destination folder path where the Terraform resources will be saved
	destFolderName := fmt.Sprintf("kics-extract-terraformer-%s", time.Now().Format("01-02-2006"))
	destination := filepath.Join(destinationPath, destFolderName)

	// run Terraformer
	output, err := runTerraformerFunc(pathOptions, destination)
	if err != nil {
		return "", errors.Wrap(err, "failed to import resources")
	}

	// save Terraform output
	err = saveTerraformerOutputFunc(destination, output)
	if err != nil {
		return "", errors.Wrap(err, "failed to import resources")
	}

	// clean unwanted files like output.tf
	cleanUnwantedFiles(destination)

	return destination, nil
}

// extractTerraformerOptions extracts all the information from the KICS Terraformer Path Syntax without the prefix 'terraformer::'
// {CloudProvider}:{Resources}:{Regions}:{Projects}
func extractTerraformerOptions(path string) (*Path, error) {
	pathInfo := strings.Split(path, ":")
	if len(pathInfo) != terraformerPathLength &&
		len(pathInfo) != terraformerPathLength+2 &&
		len(pathInfo) != terraformerPathLength+1 {
		return nil, errors.New("wrong terraformer path syntax")
	}
	return &Path{
		CloudProvider: pathInfo[0],
		Regions:       getRegions(pathInfo),
		Resources:     strings.ReplaceAll(pathInfo[1], "/", ","),
		Projects:      getProjects(pathInfo),
	}, nil
}

// getProjects gets all the projects pointed in the KICS Terraformer Path Syntax
// projects are only required for gcp
func getProjects(pathInfo []string) string {
	if len(pathInfo) == terraformerPathLength+2 {
		return strings.ReplaceAll(pathInfo[3], "/", ",")
	}

	return ""
}

// getRegions gets all the regions pointed in the KICS Terraformer Path Syntax
// regions are only required for aws and gcp
func getRegions(pathInfo []string) string {
	if len(pathInfo) >= terraformerPathLength+1 {
		return strings.ReplaceAll(pathInfo[2], "/", ",")
	}

	return ""
}

// buildArgs build the args for the command terraformer
func buildArgs(pathOptions *Path, destination string) []string {
	// the terraformer command for gcp is google
	if pathOptions.CloudProvider == "gcp" {
		pathOptions.CloudProvider = "google"
	}

	args := []string{
		"import", pathOptions.CloudProvider,
		"--resources=" + pathOptions.Resources,
		"-o", destination,
		"--verbose",
	}

	// probably we will need to define the profile to ""
	if pathOptions.CloudProvider == "aws" {
		args = append(args, "--regions="+pathOptions.Regions, "--profile=")
	}

	// the flag '--projects' is only required for gcp
	if pathOptions.Projects != "" && pathOptions.CloudProvider == "google" {
		args = append(args, "--regions="+pathOptions.Regions, "--projects="+pathOptions.Projects)
	}

	return args
}

// runTerraformer runs the terraformer binary
func runTerraformer(pathOptions *Path, destination string) (string, error) {
	args := buildArgs(pathOptions, destination)

	cmd := exec.Command("terraformer", args...) //#nosec
	cmd.Env = append(os.Environ(), "AWS_PROFILE=default")

	output, err := cmd.CombinedOutput()

	return string(output), err
}

// saveTerraformerOutput verifies if the destination folder exists
// if not, it means that someting went wrong in the Terraformer command
// it also saves the terraformer command output in the destination folder
func saveTerraformerOutput(destination, output string) error {
	_, err := os.Stat(destination)
	save(destination, output, err)

	return err
}
