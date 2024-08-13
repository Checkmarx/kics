/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package model

// RemoveDuplicates removes duplicate lines from a slice of lines.
func RemoveDuplicates(lines []int) []int {
	seen := make(map[int]bool)
	var result []int
	for _, line := range lines {
		if !seen[line] {
			result = append(result, line)
			seen[line] = true
		}
	}
	return result
}

// ProcessCommands processes a slice of commands.
func ProcessCommands(commands []string) CommentCommand {
	for _, command := range commands {
		switch com := CommentCommand(command); com {
		case IgnoreLine:
			return IgnoreLine
		case IgnoreBlock:
			return IgnoreBlock
		default:
			continue
		}
	}

	return CommentCommand(commands[0])
}

// Range returns a slice of lines between the start and end line numbers.
func Range(start, end int) (lines []int) {
	lines = make([]int, end-start+1)
	for i := range lines {
		lines[i] = start + i
	}
	return
}
