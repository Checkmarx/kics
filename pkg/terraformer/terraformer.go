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

const terraformerPathLength = 3

// Path is a struct that contains the terraformer path information
type Path struct {
	CloudProvider string
	Region        string
	Resource      string
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

	destination := filepath.Join(destinationPath, destFolderName)

	args := buildArgs(pathOptions, destination)

	cmd := exec.Command("terraformer", args...)
	cmd.Env = os.Environ()

	output, err := cmd.CombinedOutput()
	fmt.Println(string(output))
	if err != nil {
		return "", errors.Wrap(err, "failed to import resources")
	}

	_, err = os.Stat(destination)
	if err != nil {
		saveTerraformerOutput(destination, string(output))
		return "", errors.Wrap(err, "failed to import resources")
	}

	cleanUnwantedFiles(destination)

	return destination, nil
}

func extractTerraformerOptions(path string) (*Path, error) {
	pathInfo := strings.Split(path, ":")
	if len(pathInfo) != terraformerPathLength && len(pathInfo) != terraformerPathLength+1 {
		return nil, errors.New("wrong terraformer path syntax")
	}
	return &Path{
		CloudProvider: pathInfo[0],
		Region:        strings.ReplaceAll(pathInfo[2], "/", ","),
		Resource:      strings.ReplaceAll(pathInfo[1], "/", ","),
		Projects:      getProjects(pathInfo),
	}, nil
}

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

func deleteOutputFile(path string, output fs.FileInfo) {
	if output.Name() == "outputs.tf" {
		err := os.Remove(path)
		if err != nil {
			log.Err(err).Msgf("failed to remove outputs.tf in path %s", path)
		}
	}
}

func getProjects(pathInfo []string) string {
	if len(pathInfo) == terraformerPathLength+1 {
		return strings.ReplaceAll(pathInfo[3], "/", ",")
	}

	return ""
}

func buildArgs(pathOptions *Path, destination string) []string {
	args := []string{
		"import", pathOptions.CloudProvider,
		"--resources=" + pathOptions.Resource,
		"--regions=" + pathOptions.Region,
		"--profile=\"\"",
		"-o", destination,
		"--verbose",
	}

	if pathOptions.Projects != "" {
		args = append(args, "--projects="+pathOptions.Projects)
	}

	return args
}

func saveTerraformerOutput(destination, output string) {
	filepath.Clean(destination)
	f, err := os.OpenFile(destination, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, os.ModePerm)

	if err != nil {
		log.Error().Msgf("failed to open file '%s': %s", destination, err)
	}

	defer func(f *os.File) {
		err = f.Close()
		if err != nil {
			log.Err(err).Msgf("failed to close file: %s", destination)
		}
	}(f)

	if _, err = f.WriteString(output); err != nil {
		log.Error().Msgf("failed to write file '%s': %s", destination, err)

	}
}
