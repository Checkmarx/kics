// Package utils contains various utility functions to use in other packages
package utils

import (
	"bufio"
	"encoding/json"
	"os"
	"path/filepath"
	"strings"

	"github.com/rs/zerolog/log"
)

// LineCounter returns the number of lines in a file.
// If the file is a minified JSON (single line), it returns the number of lines in its pretty-printed form.
func LineCounter(path, ext string) (int, error) {
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
	scanner.Buffer(make([]byte, 1024*1024), 10*1024*1024) // 10MB max line size
	lineCount := 0
	for scanner.Scan() {
		lineCount++
	}
	scanErr := scanner.Err()

	// Check for minified JSON: extension is .json and only one line or scan error
	if strings.EqualFold(ext, ".json") && (lineCount == 1 || scanErr != nil) {
		content, err := os.ReadFile(filepath.Clean(path))
		if err != nil {
			return 0, err
		}
		var data interface{}
		if err := json.Unmarshal(content, &data); err != nil {
			return 0, err // Not valid JSON
		}
		pretty, err := json.MarshalIndent(data, "", "    ")
		if err != nil {
			return 0, err
		}
		prettyLineCount := strings.Count(string(pretty), "\n") + 1
		return prettyLineCount, nil
	}

	if scanErr != nil {
		return 0, scanErr
	}

	return lineCount, nil
}
