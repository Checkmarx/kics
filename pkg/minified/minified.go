package minified

import (
	"bytes"
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

func BeautifyJSON(content []byte) ([]byte, error) {
	var pretty bytes.Buffer
	err := json.Indent(&pretty, content, "", "    ")
	if err != nil {
		return nil, err
	}
	return pretty.Bytes(), nil
}
