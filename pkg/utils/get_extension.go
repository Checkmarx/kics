package utils

import (
	"bufio"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/rs/zerolog/log"
)

const (
	extDockerfile = ".dockerfile"
)

// GetExtension gets the extension of a file path
func GetExtension(path string) (string, error) {
	fileInfo, err := os.Stat(path)
	if err != nil {
		return "", fmt.Errorf("file %s not found", path)
	}

	if fileInfo.IsDir() {
		return "", fmt.Errorf("the path %s is a directory", path)
	}

	if ext, ok := isDockerfileExtension(path); ok {
		return ext, nil
	}

	ext := filepath.Ext(path)
	switch ext {
	case ".ubi8", ".debian":
		if readPossibleDockerFile(path) {
			return extDockerfile, nil
		}
	case "":
		if filepath.Base(path) == "tfvars" {
			return ".tfvars", nil
		}
		if readPossibleDockerFile(path) {
			return extDockerfile, nil
		}
	}
	return ext, nil
}

func isDockerfileExtension(path string) (string, bool) {
	base := filepath.Base(path)

	lower := strings.ToLower(base)
	if lower == constants.AvailablePlatforms["Dockerfile"] || strings.HasPrefix(lower, "dockerfile.") {
		return extDockerfile, true
	}

	if strings.EqualFold(filepath.Ext(path), extDockerfile) {
		return extDockerfile, true
	}

	dir := strings.ToLower(filepath.Base(filepath.Dir(path)))
	if (dir == "docker" || dir == constants.AvailablePlatforms["Dockerfile"] || dir == "dockerfiles") && readPossibleDockerFile(path) {
		return extDockerfile, true
	}

	return "", false
}

func readPossibleDockerFile(path string) bool {
	path = filepath.Clean(path)
	file, err := os.Open(path)
	if err != nil {
		return false
	}
	defer func() {
		if errClose := file.Close(); errClose != nil {
			log.Error().Err(errClose).Msg("Error closing file")
		}
	}()
	// Create a scanner to read the file line by line
	scanner := bufio.NewScanner(file)
	// Read lines from the file
	for scanner.Scan() {
		if strings.HasPrefix(scanner.Text(), "#") || strings.HasPrefix(strings.ToLower(scanner.Text()), "arg") || scanner.Text() == "" {
			continue
		} else {
			matched, _ := regexp.MatchString(`(?i)FROM\s+\S+(\s*$|\s+AS\s+\S+\s*$)`, scanner.Text())
			return matched
		}
	}
	return false
}
