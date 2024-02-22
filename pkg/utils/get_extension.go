package utils

import (
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
		ok, resp := containsIgnoreCase(filepath.Base(path), targets)
		if ok {
			ext = resp
		} else if isTextFile(path) {
			ext = "possibleDockerfile"
		}
	}

	return ext
}

func containsIgnoreCase(str string, targets []string) (bool, string) {
	for _, s := range targets {
		if strings.EqualFold(s, str) {
			return true, s
		}
	}
	return false, ""
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
