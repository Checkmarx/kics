// Package utils contains various utility functions to use in other packages
package utils

import (
	"bufio"
	"os"
	"path/filepath"
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/minified"
	"github.com/rs/zerolog/log"
)

// LineCounter returns the number of lines in a file
// For files with a .json extension, if the file is detected as minified JSON,
// it will Beautifying the JSON and return the number of lines in the formatted output
// For all other files, or non-minified JSON, it returns the actual number of lines in the file
// If an error occurs reading the file, fallbackMinifiedFileLOC is returned for minified JSON files
func LineCounter(path string, fallbackMinifiedFileLOC int) (int, error) {
	if strings.HasSuffix(path, ".json") {
		content, err := os.ReadFile(filepath.Clean(path))
		if err != nil {
			return fallbackMinifiedFileLOC, err
		}
		isMinified := minified.IsMinified(path, content)
		if isMinified {
			pretty, err := minified.BeautifyJSON(content)
			if err != nil {
				return fallbackMinifiedFileLOC, err
			}
			return countLines(string(pretty)), nil
		}
	}

	file, err := os.Open(filepath.Clean(path))
	if err != nil {
		return 0, err
	}
	defer func() {
		if err := file.Close(); err != nil {
			log.Err(err).Msgf("failed to close '%s'", filepath.Clean(path))
		}
	}()

	scanner := bufio.NewScanner(file)
	lineCount := 0
	for scanner.Scan() {
		lineCount++
	}
	if err := scanner.Err(); err != nil {
		return 0, err
	}

	return lineCount, nil
}

// countLines normalizes line endings and returns the number of lines in the input string
func countLines(s string) int {
	s = strings.ReplaceAll(s, "\r\n", "\n")
	s = strings.ReplaceAll(s, "\r", "\n")
	if s == "" {
		return 0
	}
	// Remove trailing newline to avoid counting an extra line
	s = strings.TrimSuffix(s, "\n")
	return strings.Count(s, "\n") + 1
}
