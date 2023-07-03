package detector

import (
	"errors"
	"io/ioutil"
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

// regularDetectLine is used when calculating the vulnerability line without reloaded being active
func regularDetectLine(
	searchKey string,
	splitSanitized []string,
	detector *DefaultDetectLineResponse,
	lines []string,
	extractedString [][]string,
	outputLines int) (model.VulnerabilityLines, error) {
	for _, key := range splitSanitized {
		substr1, substr2 := GenerateSubstrings(key, extractedString)

		detector, lines = detector.DetectCurrentLine(substr1, substr2, 0, lines)

		if detector.IsBreak {
			break
		}
	}

	if detector.FoundAtLeastOne {
		return model.VulnerabilityLines{
			Line:         detector.CurrentLine + 1,
			VulnLines:    GetAdjacentVulnLines(detector.CurrentLine, outputLines, lines),
			ResolvedFile: detector.ResolvedFile,
		}, nil
	}
	return model.VulnerabilityLines{}, errors.New("Failed to detect line, query response " + searchKey)
}

/*
// reloadedDetectLine is used when calculating the vulnerability line while reloaded is active
func reloadedDetectLine(
	searchKey string,
	splitSanitized []string,
	lineInfoDoc map[string]interface{},
	filePath string,
	extractedString [][]string,
	outputLines int) (model.VulnerabilityLines, error) {
	var kicsLines map[string]interface{}
	line := -1
	for index, key := range splitSanitized {
		substr1, _ := GenerateSubstrings(key, extractedString)
		if newVal, ok := lineInfoDoc[substr1]; ok {
			if newValMap, ok := newVal.(map[string]interface{}); ok || index == len(splitSanitized)-1 {
				if index != len(splitSanitized)-1 || ok {
					lineInfoDoc = newValMap
				}
				if kicsLinesDoc, ok := lineInfoDoc["_kics_lines"]; ok {
					kicsLines = kicsLinesDoc.(map[string]interface{})
					lineMap := kicsLines["_kics__default"].(map[string]interface{})
					if newLineMap, ok := kicsLines["_kics_"+substr1]; ok {
						lineMap = newLineMap.(map[string]interface{})
					}
					line = int(lineMap["_kics_line"].(float64))
				}
			} else {
				break
			}
		}
	}

	if line != -1 {
		vulLines := &[]model.CodeLine{}
		if content, err := ioutil.ReadFile(filePath); err == nil {
			contentStr := string(content)
			originalFileLines := strings.Split(contentStr, "\n")
			vulLines = GetAdjacentVulnLines(line-1, outputLines, originalFileLines)
		}
		return model.VulnerabilityLines{
			Line:         line,
			VulnLines:    vulLines,
			ResolvedFile: filePath,
		}, nil
	}
	return model.VulnerabilityLines{}, errors.New("Failed to detect line, query response " + searchKey)
}
*/

// DetectLine searches vulnerability line if kindDetectLine is not in detectors
func (d defaultDetectLine) DetectLine(file *model.FileMetadata, searchKey string,
	outputLines int, logwithfields *zerolog.Logger) model.VulnerabilityLines {
	var err error
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

	splitSanitized := strings.Split(sanitizedSubstring, ".")
	for index, split := range splitSanitized {
		if strings.Contains(split, "$ref") {
			splitSanitized[index] = strings.Join(splitSanitized[index:], ".")
			splitSanitized = splitSanitized[:index+1]
			break
		}
	}

	lines := *file.LinesOriginalData
	if content, err := ioutil.ReadFile(file.FilePath); err == nil {
		contentStr := string(content)
		lines = strings.Split(contentStr, "\n")
		file.LinesOriginalData = &lines
	}
	var vulLines model.VulnerabilityLines
	/*
		if len(lines) == 0 {
			vulLines, err = reloadedDetectLine(searchKey, splitSanitized, file.LineInfoDocument, file.FilePath, extractedString, outputLines)
		} else {
			vulLines, err = regularDetectLine(searchKey, splitSanitized, detector, lines, extractedString, outputLines)
		}
	*/
	vulLines, err = regularDetectLine(searchKey, splitSanitized, detector, lines, extractedString, outputLines)
	if err == nil {
		return vulLines
	}

	logwithfields.Warn().Msgf(err.Error())

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
