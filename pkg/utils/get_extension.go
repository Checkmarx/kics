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
	extDockerfile := ".dockerfile"
	fileInfo, err := os.Stat(path)
	if err != nil {
		return "", fmt.Errorf("file %s not found", path)
	}

	if fileInfo.IsDir() {
		return "", fmt.Errorf("the path %s is a directory", path)
	}

	if strings.HasSuffix(filepath.Clean(path), "gitignore") {
		return "gitignore", nil
	}

	if ext, ok := isDockerfileExtension(path, extDockerfile); ok {
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
		isText, err := isTextFile(path)
		if err != nil {
			return "", err
		}
		if isText && readPossibleDockerFile(path) {
			return extDockerfile, nil
		}
	}
	return ext, nil
}

func isDockerfileExtension(path, extDockerfile string) (string, bool) {
	base := filepath.Base(path)
	d := "dockerfile"

	lower := strings.ToLower(base)
	if lower == d || strings.HasPrefix(lower, "dockerfile.") {
		return extDockerfile, true
	}

	if strings.EqualFold(filepath.Ext(path), extDockerfile) {
		return extDockerfile, true
	}

	dir := strings.ToLower(filepath.Base(filepath.Dir(path)))
	if (dir == "docker" || dir == d || dir == "dockerfiles") && readPossibleDockerFile(path) {
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
