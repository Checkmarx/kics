//go:build !dev
// +build !dev

package terraformer

import (
	"fmt"
	"io"
	"io/fs"
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

	destFolderName := fmt.Sprintf("kics-extract-terraformer-%s", time.Now().Format("01-02-2006"))

	// destination folder where the Terraform resources will be saved
	destination := filepath.Join(destinationPath, destFolderName)

	args := buildArgs(pathOptions, destination)
	fmt.Println(args)

	cmd := exec.Command("terraformer", args...)
	cmd.Env = os.Environ()

	fmt.Println(cmd.Env)

	output, err := cmd.CombinedOutput()
	fmt.Println(string(output))
	if err != nil {
		return "", errors.Wrap(err, "failed to import resources")
	}

	_, err = os.Stat(destination)
	fmt.Println(err)
	saveTerraformerOutput(destination, string(output), err)

	if err != nil {
		return "", errors.Wrap(err, "failed to import resources")
	}

	cleanUnwantedFiles(destination)

	return destination, nil
}

// extractTerraformerOptions extracts all the information from the KICS Terraformer Path Syntax without the prefix 'terraformer::'
// {CloudProvider}:{Resources}:{Regions}:{Projects}
func extractTerraformerOptions(path string) (*Path, error) {
	pathInfo := strings.Split(path, ":")
	if len(pathInfo) != terraformerPathLength && len(pathInfo) != terraformerPathLength+1 {
		return nil, errors.New("wrong terraformer path syntax")
	}
	return &Path{
		CloudProvider: pathInfo[0],
		Regions:       strings.ReplaceAll(pathInfo[2], "/", ","),
		Resources:     strings.ReplaceAll(pathInfo[1], "/", ","),
		Projects:      getProjects(pathInfo),
	}, nil
}

// cleanUnwantedFiles deletes the output files from the destination folder
func cleanUnwantedFiles(destination string) {
	err := filepath.Walk(destination, func(path string, info fs.FileInfo, err error) error {
		if info != nil {
			deleteOutputFile(path, info)
		}
		return nil
	})

	if err != nil {
		log.Err(err).Msg("failed to clean unwanted files")
	}
}

// deleteOutputFile deletes a 'outputs.tf' file
func deleteOutputFile(path string, output fs.FileInfo) {
	if output.Name() == "outputs.tf" {
		err := os.Remove(path)
		if err != nil {
			log.Err(err).Msgf("failed to remove outputs.tf in path %s", path)
		}
	}
}

// getProjects gets all the projects pointed in the KICS Terraformer Path Syntax
// projects are only required for gcp
func getProjects(pathInfo []string) string {
	if len(pathInfo) == terraformerPathLength+1 {
		return strings.ReplaceAll(pathInfo[3], "/", ",")
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
		args = append(args, "--regions="+pathOptions.Regions)
		args = append(args, "--profile=\"\"")
	}

	// the flag '--projects' is only required for gcp
	if pathOptions.Projects != "" && pathOptions.CloudProvider == "google" {
		args = append(args, "--regions="+pathOptions.Regions)
		args = append(args, "--projects="+pathOptions.Projects)
	}

	return args
}

// saveTerraformerOutput saves the terraformer command output in the destination folder
func saveTerraformerOutput(destination, output string, statErr error) {
	if statErr != nil {
		if err := os.MkdirAll(destination, os.ModePerm); err != nil {
			log.Error().Msgf("failed to mkdir: %s", err)
		}
	}

	filePath := filepath.Join(destination, "terraformer-output.txt")
	filepath.Clean(filePath)

	f, err := os.OpenFile(filePath, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, os.ModePerm)

	if err != nil {
		log.Error().Msgf("failed to open file '%s': %s", filePath, err)
	}

	defer func(f *os.File) {
		err = f.Close()
		if err != nil {
			log.Err(err).Msgf("failed to close file: %s", filePath)
		}
	}(f)

	if _, err = f.WriteString(output); err != nil {
		log.Error().Msgf("failed to write file '%s': %s", filePath, err)
	}
}
