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
	outputLines int, logwithfields *zerolog.Logger) model.VulnerabilityLines {
	det := &detector.DefaultDetectLineResponse{
		CurrentLine:     0,
		IsBreak:         false,
		FoundAtLeastOne: false,
		Lines:           prepareDockerFileLines(d.SplitLines(file.OriginalData)),
		ResolvedFile:    file.FilePath,
		ResolvedFiles:   make(map[string]model.ResolvedFileSplit),
	}

	var extractedString [][]string
	extractedString = detector.GetBracketValues(searchKey, extractedString, "")
	sKey := searchKey
	for idx, str := range extractedString {
		sKey = strings.Replace(sKey, str[0], `{{`+strconv.Itoa(idx)+`}}`, -1)
	}

	for _, key := range strings.Split(sKey, ".") {
		substr1, substr2 := detector.GenerateSubstrings(key, extractedString)

		det = det.DetectCurrentLine(substr1, substr2)

		if det.IsBreak {
			break
		}
	}

	unchangedText := d.SplitLines(file.OriginalData)

	if det.FoundAtLeastOne {
		return model.VulnerabilityLines{
			Line:         det.CurrentLine + 1,
			VulnLines:    detector.GetAdjacentVulnLines(det.CurrentLine, outputLines, unchangedText),
			ResolvedFile: file.FilePath,
		}
	}

	logwithfields.Warn().Msgf("Failed to detect Docker line, query response %s", sKey)

	return model.VulnerabilityLines{
		Line:         undetectedVulnerabilityLine,
		VulnLines:    []model.CodeLine{},
		ResolvedFile: file.FilePath,
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
