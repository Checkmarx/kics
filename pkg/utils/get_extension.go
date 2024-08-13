/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package utils

import (
	"bytes"
	"fmt"
	"os"
	"path/filepath"

	"github.com/rs/zerolog/log"
	"golang.org/x/tools/godoc/util"
)

// GetExtension gets the extension of a file path
func GetExtension(path string) (string, error) {
	targets := []string{"tfvars"}

	// Get file information
	fileInfo, err := os.Stat(path)
	if err != nil {
		return "", fmt.Errorf("file %s not found", path)
	}

	if fileInfo.IsDir() {
		return "", fmt.Errorf("the path %s is a directory", path)
	}

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
				return "", fmt.Errorf("file %s does not have a supported extension", path)
			}
		}
	}

	return ext, nil
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

	content = bytes.Replace(content, []byte("\r"), []byte(""), -1)

	isText := util.IsText(content)

	return isText, nil
}
