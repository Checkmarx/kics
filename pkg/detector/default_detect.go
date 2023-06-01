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
	outputLines int, logwithfields *zerolog.Logger) model.VulnerabilityLines {
	detector := &DefaultDetectLineResponse{
		CurrentLine:     0,
		IsBreak:         false,
		FoundAtLeastOne: false,
		ResolvedFile:    file.FilePath,
		ResolvedFiles:   d.prepareResolvedFiles(file.ResolvedFiles),
	}

	var extractedString [][]string
	extractedString = GetBracketValues(searchKey, extractedString, "")
	sanitizedSubstring := searchKey
	for idx, str := range extractedString {
		sanitizedSubstring = strings.Replace(sanitizedSubstring, str[0], `{{`+strconv.Itoa(idx)+`}}`, -1)
	}

	lines := *file.LinesOriginalData
	for _, key := range strings.Split(sanitizedSubstring, ".") {
		substr1, substr2 := GenerateSubstrings(key, extractedString)

		previousDetector := detector
		previousLines := lines
		detector, lines = detector.DetectCurrentLine(substr1, substr2, 0, lines)

		if detector.IsBreak {
			detector, lines = previousDetector.DetectCurrentLine("$ref", "", 0, previousLines)
			break
		}
	}

	if detector.FoundAtLeastOne {
		return model.VulnerabilityLines{
			Line:         detector.CurrentLine + 1,
			VulnLines:    GetAdjacentVulnLines(detector.CurrentLine, outputLines, lines),
			ResolvedFile: detector.ResolvedFile,
		}
	}

	logwithfields.Warn().Msgf("Failed to detect line, query response %s", searchKey)

	return model.VulnerabilityLines{
		Line:         undetectedVulnerabilityLine,
		VulnLines:    &[]model.CodeLine{},
		ResolvedFile: detector.ResolvedFile,
	}
}

func (d defaultDetectLine) prepareResolvedFiles(resFiles map[string]model.ResolvedFile) map[string]model.ResolvedFileSplit {
	resolvedFiles := make(map[string]model.ResolvedFileSplit)
	for f, res := range resFiles {
		resolvedFiles[f] = model.ResolvedFileSplit{
			Path:  res.Path,
			Lines: *res.LinesContent,
		}
	}
	return resolvedFiles
}
