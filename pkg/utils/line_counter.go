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
// it will prettifying the JSON and return the number of lines in the formatted output
// For all other files, or non-minified JSON, it returns the actual number of lines in the file
// If an error occurs reading the file, fallbackMinifiedFileLOC is returned for minified JSON files
func LineCounter(path string, maxFileSize, fallbackMinifiedFileLOC int) (int, error) {
	if strings.HasSuffix(path, ".json") {
		content, err := os.ReadFile(filepath.Clean(path))
		if err != nil {
			return fallbackMinifiedFileLOC, err
		}
		isMinified := minified.IsMinified(path, content)
		if isMinified {
			pretty, err := minified.PrettifyJSON(content)
			if err != nil {
				return fallbackMinifiedFileLOC, err
			}
			prettyStr := string(pretty)
			prettyStr = strings.ReplaceAll(prettyStr, "\r\n", "\n")
			prettyStr = strings.ReplaceAll(prettyStr, "\r", "\n")
			prettyLineCount := strings.Count(prettyStr, "\n") + 1
			return prettyLineCount, nil
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
	if maxFileSize > 0 {
		scanner.Buffer(make([]byte, 1024*1024), maxFileSize*1024*1024) // maxFileSize for max line size
	}
	lineCount := 0
	for scanner.Scan() {
		lineCount++
	}
	if err := scanner.Err(); err != nil {
		return 0, err
	}

	return lineCount, nil
}
