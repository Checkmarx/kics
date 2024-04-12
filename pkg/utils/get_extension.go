package utils

import (
	"bufio"
	"bytes"
	"os"
	"path/filepath"
	"strings"

	"github.com/rs/zerolog/log"
	"golang.org/x/exp/slices"
	"golang.org/x/tools/godoc/util"
)

const (
	FinalASCII = 165
)

// GetExtension gets the extension of a file path
func GetExtension(path string) (string, error) {
	targets := []string{"Dockerfile", "tfvars"}

	ext := filepath.Ext(path)

	if ext == "" {
		base := filepath.Base(path)

		if Contains(base, targets) {
			ext = base
		} else {
			isText, err := isTextFile(path)

			if err != nil {
				return "", err
			}

			if isText {
				if readPossibleDockerFile(path) {
					ext = "possibleDockerfile"
				}
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

	invalidChars := slices.ContainsFunc[byte](content, func(b byte) bool {
		return b > FinalASCII // character after which it is not a regular file character
	})

	if len(content) == 0 || invalidChars {
		return false, nil
	}

	content = bytes.Replace(content, []byte("\r"), []byte(""), -1)

	isText := util.IsText(content)

	return isText, nil
}
