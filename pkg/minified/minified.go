package minified

import (
	"encoding/json"
	"regexp"
	"strings"
)

func IsMinified(filename string, content []byte) bool {
	if strings.HasSuffix(filename, ".json") {
		return isMinifiedJSON(string(content))
	}
	return false
}

func isMinifiedJSON(content string) bool {
	// Define a regular expression to match common minification patterns
	minifiedPattern := regexp.MustCompile(`\s+`)

	// Count the number of non-whitespace characters
	nonWhitespaceCount := len(minifiedPattern.ReplaceAllString(content, ""))

	// 80% of non-whitespace characters
	minifiedThreshold := 0.8

	return float64(nonWhitespaceCount)/float64(len(content)) > minifiedThreshold
}

func PrettifyJSON(content []byte) ([]byte, error) {
	var data interface{}
	if err := json.Unmarshal(content, &data); err != nil {
		return nil, err
	}
	pretty, err := json.MarshalIndent(data, "", "    ")
	if err != nil {
		return nil, err
	}
	return pretty, nil
}
