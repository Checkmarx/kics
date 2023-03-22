// Package utils contains various utility functions to use in other packages
package utils

import (
	"bufio"
	"os"
	"path/filepath"

	"github.com/rs/zerolog/log"
)

// LineCounter get the number of lines of a given file
func LineCounter(path string) (int, error) {
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
