/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package minified

import (
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
