package detector

import (
	"github.com/Checkmarx/kics/pkg/resolver/file"
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
	_ *zerolog.Logger, outputLines int) model.VulnerabilityLines {
	lines := d.SplitLines(file.OriginalData)
	resFiles := d.prepareResolvedFiles(file.ResolvedFiles)
	foundAtLeastOne := false
	currentLine := 0
	adjLines := lines
	resolvedFile := file.FilePath
	var extractedString [][]string
	extractedString = GetBracketValues(searchKey, extractedString, "")
	sanitizedSubstring := searchKey
	for idx, str := range extractedString {
		sanitizedSubstring = strings.Replace(sanitizedSubstring, str[0], `{{`+strconv.Itoa(idx)+`}}`, -1)
	}

	for _, key := range strings.Split(sanitizedSubstring, ".") {
		substr1, substr2 := GenerateSubstrings(key, extractedString)

		response := DetectCurrentLine(adjLines, substr1, substr2, currentLine, foundAtLeastOne, resFiles, resolvedFile)

		currentLine = response.CurrentLine
		foundAtLeastOne = response.FoundAtLeastOne
		adjLines = response.Lines
		resolvedFile = response.ResolvedFile

		if response.IsBreak {
			break
		}
	}

	if foundAtLeastOne {
		return model.VulnerabilityLines{
			Line:         currentLine + 1,
			VulnLines:    GetAdjacentVulnLines(currentLine, outputLines, adjLines),
			ResolvedFile: resolvedFile,
		}
	}

	return model.VulnerabilityLines{
		Line:         undetectedVulnerabilityLine,
		VulnLines:    []model.CodeLine{},
		ResolvedFile: resolvedFile,
	}
}

func (d defaultDetectLine) SplitLines(content string) []string {
	text := strings.ReplaceAll(content, "\r", "")
	return strings.Split(text, "\n")
}

func (d defaultDetectLine) prepareResolvedFiles(resFiles map[string]file.ResolvedFile) map[string]model.ResolvedFileSplit {
	resolvedFiles := make(map[string]model.ResolvedFileSplit)
	for f, res := range resFiles {
		resolvedFiles[f] = model.ResolvedFileSplit{
			Path:  res.Path,
			Lines: d.SplitLines(string(res.Content)),
		}
	}
	return resolvedFiles
}
