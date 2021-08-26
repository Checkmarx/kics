package docker

import (
	"regexp"
	"strconv"
	"strings"

	"github.com/Checkmarx/kics/pkg/detector"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/rs/zerolog"
)

// DetectKindLine defines a kindDetectLine type
type DetectKindLine struct {
}

const (
	undetectedVulnerabilityLine = -1
)

var (
	nameRegexDockerFileML = regexp.MustCompile(`.+\s+\\$`)
	commentRegex          = regexp.MustCompile(`^\s*#.*`)
	splitRegex            = regexp.MustCompile(`\s\\`)
)

// DetectLine searches vulnerability line in docker files
func (d DetectKindLine) DetectLine(file *model.FileMetadata, searchKey string,
	logWithFields *zerolog.Logger, outputLines int) model.VulnerabilityLines {
	text := d.SplitLines(file.OriginalData)
	lines := prepareDockerFileLines(text)
	var isBreak bool
	foundAtLeastOne := false
	currentLine := 0
	var extractedString [][]string
	extractedString = detector.GetBracketValues(searchKey, extractedString, "")
	sKey := searchKey
	for idx, str := range extractedString {
		sKey = strings.Replace(sKey, str[0], `{{`+strconv.Itoa(idx)+`}}`, -1)
	}

	for _, key := range strings.Split(sKey, ".") {
		substr1, substr2 := detector.GenerateSubstrings(key, extractedString)

		foundAtLeastOne, currentLine, isBreak = detector.DetectCurrentLine(lines, substr1, substr2,
			currentLine, foundAtLeastOne)

		if isBreak {
			break
		}
	}

	unchangedText := strings.Split(strings.ReplaceAll(file.OriginalData, "\r", ""), "\n")

	if foundAtLeastOne {
		return model.VulnerabilityLines{
			Line:      currentLine + 1,
			VulnLines: detector.GetAdjacentVulnLines(currentLine, outputLines, unchangedText),
		}
	}

	logWithFields.Warn().Msgf("Failed to detect Docker line, query response %s", searchKey)

	return model.VulnerabilityLines{
		Line:      undetectedVulnerabilityLine,
		VulnLines: []model.CodeLine{},
	}
}

// SplitLines splits Dockerfile document by line, multiline are considered as one
func (d DetectKindLine) SplitLines(content string) []string {
	text := strings.ReplaceAll(content, "\r", "")
	return strings.Split(text, "\n")
}

func prepareDockerFileLines(text []string) []string {
	for idx, key := range text {
		if !commentRegex.MatchString(key) {
			text[idx] = multiLineSpliter(text, key, idx)
		}
	}
	return text
}

func multiLineSpliter(textSplit []string, key string, idx int) string {
	if nameRegexDockerFileML.MatchString(key) {
		i := idx + 1
		if i >= len(textSplit) {
			return textSplit[idx]
		}
		for textSplit[i] == "" {
			i++
			if i >= len(textSplit) {
				return textSplit[idx]
			}
		}
		if commentRegex.MatchString(textSplit[i]) {
			textSplit[i] += " \\"
		}
		textSplit[idx] = splitRegex.ReplaceAllLiteralString(textSplit[idx], " "+textSplit[i])
		textSplit[i] = ""
		textSplit[idx] = multiLineSpliter(textSplit, textSplit[idx], idx)
	}
	return textSplit[idx]
}
