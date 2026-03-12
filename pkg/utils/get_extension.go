package utils

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/rs/zerolog/log"
	"golang.org/x/tools/godoc/util"
)

// GetExtension gets the extension of a file path
func GetExtension(path string) (string, error) {
	// Get file information
	fileInfo, err := os.Stat(path)
	extDockerfile := ".dockerfile"
	if err != nil {
		return "", fmt.Errorf("file %s not found", path)
	}

	if fileInfo.IsDir() {
		return "", fmt.Errorf("the path %s is a directory", path)
	}

	base := filepath.Base(path)
	if strings.HasPrefix(strings.ToLower(base), "dockerfile.") {
		return extDockerfile, nil
	}

	ext := filepath.Ext(path)
	if strings.EqualFold(ext, ".dockerfile") {
		return extDockerfile, nil
	}

	dir := strings.ToLower(filepath.Base(filepath.Dir(path)))
	if (dir == "docker" || dir == "dockerfile" || dir == "dockerfiles") && readPossibleDockerFile(path) {
		return extDockerfile, nil
	}

	switch ext {
	case ".ubi8", ".debian":
		if readPossibleDockerFile(path) {
			return extDockerfile, nil
		}
	case "":
		if base == "tfvars" {
			ext = ".tfvars"
		} else {
			isText, err := isTextFile(path)

			if err != nil {
				return "", err
			}

			if isText && readPossibleDockerFile(path) {
				return extDockerfile, nil
			}
		}

	}

	return ext, nil
}

func readPossibleDockerFile(path string) bool {
	path = filepath.Clean(path)
	if strings.HasSuffix(path, "gitignore") {
		return true
	}
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
			if strings.HasPrefix(strings.ToLower(scanner.Text()), "from") {
				return true
			} else {
				return false
			}
		}
	}
	return false
}

func isTextFile(path string) (bool, error) {
	info, err := os.Stat(path)
	if err != nil {
		log.Error().Msgf("failed to get file info: %s", err)
		return false, err
	}

	if info.IsDir() {
		return false, nil
	}

	content, err := os.ReadFile(filepath.Clean(path))
	if err != nil {
		log.Error().Msgf("failed to analyze file: %s", err)
		return false, err
	}

	content = bytes.ReplaceAll(content, []byte("\r"), []byte(""))

	isText := util.IsText(content)

	return isText, nil
}
