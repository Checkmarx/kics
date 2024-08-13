/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package utils

import "strings"

// SplitLines splits the document by line
func SplitLines(content string) *[]string {
	text := strings.ReplaceAll(content, "\r", "")
	split := strings.Split(text, "\n")

	return &split
}
