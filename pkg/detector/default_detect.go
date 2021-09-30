package detector

import (
	"strconv"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/rs/zerolog"
)

const (
	undetectedVulnerabilityLine = -1
)

type defaultDetectLine struct {
}

// DetectLine searches vulnerability line if kindDetectLine is not in detectors
func (d defaultDetectLine) DetectLine(file *model.FileMetadata, searchKey string,
	logWithFields *zerolog.Logger, outputLines int) model.VulnerabilityLines {
	lines := d.SplitLines(file.OriginalData)
	var isBreak bool
	foundAtLeastOne := false
	currentLine := 0
	var extractedString [][]string
	extractedString = GetBracketValues(searchKey, extractedString, "")
	sanitizedSubstring := searchKey
	for idx, str := range extractedString {
		sanitizedSubstring = strings.Replace(sanitizedSubstring, str[0], `{{`+strconv.Itoa(idx)+`}}`, -1)
	}

	for _, key := range strings.Split(sanitizedSubstring, ".") {
		substr1, substr2 := GenerateSubstrings(key, extractedString)

		foundAtLeastOne, currentLine, isBreak = DetectCurrentLine(lines, substr1, substr2, currentLine, foundAtLeastOne)

		if isBreak {
			break
		}
	}

	if foundAtLeastOne {
		return model.VulnerabilityLines{
			Line:      currentLine + 1,
			VulnLines: GetAdjacentVulnLines(currentLine, outputLines, lines),
		}
	}

	return model.VulnerabilityLines{
		Line:      undetectedVulnerabilityLine,
		VulnLines: []model.CodeLine{},
	}
}

func (d defaultDetectLine) SplitLines(content string) []string {
	text := strings.ReplaceAll(content, "\r", "")
	return strings.Split(text, "\n")
}
