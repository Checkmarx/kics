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
)

// DetectLine searches vulnerability line in docker files
func (d DetectKindLine) DetectLine(file *model.FileMetadata, searchKey string,
	logWithFields *zerolog.Logger, outputLines int) model.VulnerabilityLines {
	text := strings.ReplaceAll(file.OriginalData, "\r", "")
	lines := prepareDockerFileLines(text)
	isBreak := false
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

	if foundAtLeastOne {
		return model.VulnerabilityLines{
			Line:     currentLine + 1,
			VulnLine: detector.GetAdjacentLines(currentLine, outputLines, strings.Split(text, "\n")),
		}
	}

	logWithFields.Warn().Msgf("Failed to detect Docker line, query response %s", searchKey)

	return model.VulnerabilityLines{
		Line:     undetectedVulnerabilityLine,
		VulnLine: model.VulnLines{},
	}
}

func prepareDockerFileLines(text string) []string {
	textSplit := strings.Split(text, "\n")
	for idx, key := range textSplit {
		textSplit[idx] = multiLineSpliter(textSplit, key, idx)
	}
	return textSplit
}

func multiLineSpliter(textSplit []string, key string, idx int) string {
	if nameRegexDockerFileML.MatchString(key) {
		i := idx + 1
		for textSplit[i] == "" {
			i++
		}
		textSplit[idx] = strings.ReplaceAll(textSplit[idx], " \\", " "+textSplit[i])
		textSplit[i] = ""
		textSplit[idx] = multiLineSpliter(textSplit, textSplit[idx], idx)
	}
	return textSplit[idx]
}
