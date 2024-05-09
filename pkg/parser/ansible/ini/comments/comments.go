package comments

import (
	"regexp"
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/model"
)

func getKicsIgnore(comment string) string {
	commentLower := model.KICSCommentRgxp.ReplaceAllString(strings.ToLower(comment), "")
	commentLower = strings.Trim(commentLower, "\r")
	commentLower = strings.Trim(commentLower, "\n")
	return commentLower
}

func getIgnoreLinesFromBlock(lines []string, ignoreBlockLine int) int {
	i := ignoreBlockLine + 1

	if i >= len(lines) {
		return ignoreBlockLine
	}

	// Check if the next line is a group: [group_name]
	if match, _ := regexp.MatchString(`^\s*\[`, lines[i]); !match {
		return ignoreBlockLine
	}

	// Now needs to find the end of the block (next group or end of file)
	i += 1
	nextGroup := regexp.MustCompile(`^\s*\[`)

	for ; i < len(lines); i++ {
		if nextGroup.MatchString(lines[i]) {
			return i - 1
		}
	}
	return i - 1
}

func GetIgnoreLines(lines []string) []int {
	ignoreLines := make([]int, 0)
	comment := regexp.MustCompile(`^[#;]`)

	for i, line := range lines {
		if model.KICSCommentRgxp.MatchString(line) {
			kicsIgnore := getKicsIgnore(line)

			switch model.CommentCommand(kicsIgnore) {
			case model.IgnoreLine:
				if i+1 < len(lines) {
					ignoreLines = append(ignoreLines, i, i+1)
				} else {
					ignoreLines = append(ignoreLines, i)
				}
			case model.IgnoreBlock:
				until := getIgnoreLinesFromBlock(lines, i)
				if until > i {
					ignoreLines = append(ignoreLines, model.Range(i, until)...)
				} else {
					ignoreLines = append(ignoreLines, i)
				}
			}
		} else if comment.MatchString(line) {
			ignoreLines = append(ignoreLines, i+1)
		}
	}
	return ignoreLines
}
