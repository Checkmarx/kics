package utils

import (
	"bufio"
	"bytes"
	"os"
	"path/filepath"
	"strings"

	"github.com/rs/zerolog/log"
	"golang.org/x/tools/godoc/util"
)

// GetExtension gets the extension of a file path
func GetExtension(path string) string {
	targets := []string{"Dockerfile", "tfvars"}

	ext := filepath.Ext(path)

	if ext == "" {
		base := filepath.Base(path)

		if Contains(base, targets) {
			ext = base
		} else if isTextFile(path) {
			if readPossibleDockerFile(path) {
				ext = "possibleDockerfile"
			}
		}
	}

	return ext
}

func readPossibleDockerFile(path string) bool {
	path = filepath.Clean(path)
	file, err := os.Open(path)
	if err != nil {
		return false
	}
	defer file.Close()
	// Create a scanner to read the file line by line
	scanner := bufio.NewScanner(file)
	// Read lines from the file
	for scanner.Scan() {
		if strings.HasPrefix(scanner.Text(), "FROM") {
			return true
		} else if strings.HasPrefix(scanner.Text(), "#") {
			continue
		} else {
			return false
		}
	}
	return false
}

func isTextFile(path string) bool {
	info, err := os.Stat(path)
	if err != nil {
		log.Error().Msgf("failed to get file info: %s", err)
		return false
	}

	if info.IsDir() {
		return false
	}

	content, err := os.ReadFile(filepath.Clean(path))
	if err != nil {
		log.Error().Msgf("failed to analyze file: %s", err)
		return false
	}

	content = bytes.Replace(content, []byte("\r"), []byte(""), -1)

	isText := util.IsText(content)

	return isText
}
