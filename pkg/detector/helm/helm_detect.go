package helm

import (
	"fmt"
	"sort"
	"strconv"
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/detector"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/agnivade/levenshtein"
	"github.com/rs/zerolog"
)

// DetectKindLine defines a kindDetectLine type
type DetectKindLine struct {
}

type detectCurlLine struct {
	foundRes   bool
	lineRes    int
	breakRes   bool
	lastUnique dupHistory
}

// dupHistory keeps the history of uniques
type dupHistory struct {
	unique         bool
	lastUniqueLine int
}

const (
	undetectedVulnerabilityLine = -1
)

// DetectLine is used to detect line on the helm template,
// it looks only at the keys of the template and will make use of the auxiliary added
// lines (ex: "# KICS_HELM_ID_")
func (d DetectKindLine) DetectLine(file *model.FileMetadata, searchKey string,
	outputLines int, logWithFields *zerolog.Logger) model.VulnerabilityLines {
	searchKey = fmt.Sprintf("%s.%s", strings.TrimRight(strings.TrimLeft(file.HelmID, "# "), ":"), searchKey)

	lines := make([]string, len(*file.LinesOriginalData))
	copy(lines, *file.LinesOriginalData)

	curLineRes := detectCurlLine{
		foundRes: false,
		lineRes:  0,
		breakRes: false,
	}
	var extractedString [][]string
	extractedString = detector.GetBracketValues(searchKey, extractedString, "")
	sanitizedSubstring := searchKey
	for idx, str := range extractedString {
		sanitizedSubstring = strings.ReplaceAll(sanitizedSubstring, str[0], `{{`+strconv.Itoa(idx)+`}}`)
	}

	helmID, err := strconv.Atoi(strings.TrimSuffix(strings.TrimPrefix(file.HelmID, "# KICS_HELM_ID_"), ":"))
	if err != nil {
		helmID = -1
	}

	// Since we are only looking at keys we can ignore the second value passed through '=' and '[]'
	for _, key := range strings.Split(sanitizedSubstring, ".") {
		substr1, _ := detector.GenerateSubstrings(key, extractedString)
		curLineRes = curLineRes.detectCurrentLine(lines, fmt.Sprintf("%s:", substr1), "", true, file.IDInfo, helmID)

		if curLineRes.breakRes {
			break
		}
	}

	// Look at dupHistory to see if the last element was duplicate, if so
	// change the line to the last unique key
	if !curLineRes.lastUnique.unique {
		curLineRes.lineRes = curLineRes.lastUnique.lastUniqueLine
	}

	if curLineRes.foundRes {
		lineRemove := make(map[int]int)
		count := 0
		for i, line := range lines { // Remove auxiliary lines
			if strings.Contains(line, "# KICS_HELM_ID_") {
				count++
				lineRemove[i] = count
				lines = append(lines[:i], lines[i+1:]...)
			}
		}
		// Update found line
		curLineRes.lineRes = removeLines(curLineRes.lineRes, lineRemove)
		return model.VulnerabilityLines{
			Line:                  curLineRes.lineRes + 1,
			VulnLines:             detector.GetAdjacentVulnLines(curLineRes.lineRes, outputLines, lines),
			LineWithVulnerability: strings.Split(lines[curLineRes.lineRes], ": ")[0],
			ResolvedFile:          file.FilePath,
		}
	}

	var filePathSplit = strings.Split(file.FilePath, "/")
	logWithFields.Warn().Msgf("Failed to detect line associated with identified result in file %s\n", filePathSplit[len(filePathSplit)-1])

	return model.VulnerabilityLines{
		Line:         undetectedVulnerabilityLine,
		VulnLines:    &[]model.CodeLine{},
		ResolvedFile: file.FilePath,
	}
}

// removeLines is used to update the vulnerability line after removing the "# KICS_HELM_ID_"
func removeLines(current int, lineRemove map[int]int) int {
	orderByKey := make([]int, len(lineRemove))
	i := 0
	for k := range lineRemove {
		orderByKey[i] = k
		i++
	}
	remove := 0
	sort.Ints(orderByKey)
	for _, k := range orderByKey {
		if current > k {
			remove = lineRemove[k]
		} else {
			break
		}
	}
	current -= remove
	return current
}

func (d detectCurlLine) detectCurrentLine(lines []string, str1,
	str2 string, byKey bool, idInfo map[int]interface{}, id int) detectCurlLine {
	distances := make(map[int]int)
	for i := d.lineRes; i < len(lines); i++ {
		if str1 != "" && str2 != "" {
			if strings.Contains(lines[i], str1) && strings.Contains(lines[i], str2) {
				distances[i] = levenshtein.ComputeDistance(detector.ExtractLineFragment(lines[i], str2, byKey), str2)
			}
		} else if str1 != "" {
			if strings.Contains(lines[i], str1) {
				distances[i] = levenshtein.ComputeDistance(
					detector.ExtractLineFragment(strings.TrimSpace(lines[i]), str1, byKey), str1)
			}
		}
	}

	lastSingle := d.lastUnique.lastUniqueLine

	if len(distances) == 0 {
		return detectCurlLine{
			foundRes: d.foundRes,
			lineRes:  d.lineRes,
			breakRes: true,
			lastUnique: dupHistory{
				lastUniqueLine: lastSingle,
				unique:         d.lastUnique.unique,
			},
		}
	}

	lineResponse := detector.SelectLineWithMinimumDistance(distances, d.lineRes)
	// if lineResponse is unique
	unique := detectLastSingle(lineResponse, distances, idInfo, id)
	if unique {
		lastSingle = lineResponse
	}

	return detectCurlLine{
		foundRes: true,
		lineRes:  lineResponse,
		breakRes: false,
		lastUnique: dupHistory{
			unique:         unique,
			lastUniqueLine: lastSingle,
		},
	}
}

// detectLastSingle checks if the line is unique or a duplicate
func detectLastSingle(line int, dis map[int]int, idInfo map[int]interface{}, id int) bool {
	if idInfo == nil {
		return true
	}
	for key, value := range dis {
		if value == dis[line] && key != line {
			// check if we are only looking at original data equivalent to the vulnerability
			if ok := idInfo[id].(map[int]int)[key]; ok != 0 {
				return false
			}
		}
	}
	return true
}
