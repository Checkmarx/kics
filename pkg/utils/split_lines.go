package utils

import "strings"

// SplitLines splits the document by line
func SplitLines(content string) *[]string {
	text := strings.ReplaceAll(content, "\r", "")
	split := strings.Split(text, "\n")

	return &split
}
