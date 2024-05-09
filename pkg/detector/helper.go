package detector

import (
	"fmt"
	"regexp"
	"strconv"
	"strings"

	"github.com/agnivade/levenshtein"

	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/rs/zerolog/log"
)

var (
	nameRegex       = regexp.MustCompile(`^([A-Za-z\d-_]+)\[([A-Za-z\d-_{}]+)]$`)
	nameRegexDocker = regexp.MustCompile(`{{(.*?)}}`)
)

const (
	namePartsLength  = 3
	valuePartsLength = 2
)

// DefaultDetectLineResponse is the default response for struct DetectLine
type DefaultDetectLineResponse struct {
	CurrentLine     int
	IsBreak         bool
	FoundAtLeastOne bool
	ResolvedFile    string
	ResolvedFiles   map[string]model.ResolvedFileSplit
}

// GetBracketValues gets values inside "{{ }}" ignoring any "{{" or "}}" inside
func GetBracketValues(expr string, list [][]string, restOfString string) [][]string {
	var tempList []string
	firstOpen := strings.Index(expr, "{{")
	firstClose := strings.Index(expr, "}}")
	for firstOpen > firstClose && firstClose != -1 {
		firstClose = strings.Index(expr[firstOpen:], "}}") + firstOpen
	}
	// in case we have '}}}' we need to advance one position to get the close
	for firstClose+2 < len(expr) && string(expr[firstClose+2]) == `}` && firstClose != -1 {
		firstClose++
	}

	switch t := firstClose - firstOpen; t >= 0 {
	case true:
		if t == 0 && expr != "" {
			tempList = append(tempList, fmt.Sprintf("{{%s}}", expr), expr)
			list = append(list, tempList)
		}
		if t == 0 && restOfString == "" {
			return list // if there is no more string to read from return value of list
		}
		if t > 0 && firstOpen+2 <= firstClose {
			list = GetBracketValues(expr[firstOpen+2:firstClose], list, expr[firstClose+2:])
		} else {
			list = GetBracketValues(restOfString, list, "") // recursive call to the rest of the string
		}
	case false:
		nextClose := strings.Index(restOfString, "}}")
		tempNextClose := nextClose + 2
		if tempNextClose == len(restOfString) {
			tempNextClose = nextClose
		}
		tempList = append(tempList, fmt.Sprintf("{{%s}}%s}}", expr, restOfString[:tempNextClose]),
			fmt.Sprintf("%s}}%s", expr, restOfString[:tempNextClose]))
		list = append(list, tempList)
		list = GetBracketValues(restOfString[nextClose+2:], list, "") // recursive call to the rest of the string
	}

	return list
}

// GenerateSubstrings returns the substrings used for line searching depending on search key
// '.' is new line
// '=' is value in the same line
// '[]' is in the same line
func GenerateSubstrings(key string, extractedString [][]string) (substr1Res, substr2Res string) {
	var substr1, substr2 string
	if parts := nameRegex.FindStringSubmatch(key); len(parts) == namePartsLength {
		substr1, substr2 = getKeyWithCurlyBrackets(key, extractedString, parts)
	} else if parts := strings.Split(key, "="); len(parts) == valuePartsLength {
		substr1, substr2 = getKeyWithCurlyBrackets(key, extractedString, parts)
	} else {
		parts := []string{key, ""}
		substr1, substr2 = getKeyWithCurlyBrackets(key, extractedString, parts)
	}
	return substr1, substr2
}

func getKeyWithCurlyBrackets(key string, extractedString [][]string, parts []string) (substr1Res, substr2Res string) {
	var substr1, substr2 string
	extractedPart := nameRegexDocker.FindStringSubmatch(key)
	if len(extractedPart) == valuePartsLength {
		for idx, key := range parts {
			if extractedPart[0] == key {
				switch idx {
				case len(parts) - 2:
					i, err := strconv.Atoi(extractedPart[1])
					if err != nil {
						log.Error().Msgf("failed to extract curly brackets substring")
					}
					if len(extractedString) > i {
						if extractedString[i][1] != "" {
							substr1 = extractedString[i][1]
						}
					}
				case len(parts) - 1:
					i, err := strconv.Atoi(extractedPart[1])
					if err != nil {
						log.Error().Msgf("failed to extract curly brackets substring")
					}
					if len(extractedString) > i {
						if extractedString[i][1] != "" {
							substr2 = extractedString[i][1]
						}
					}
				}
			} else {
				substr1 = generateSubstr(substr1, parts, valuePartsLength)
				substr2 = generateSubstr(substr2, parts, 1)
			}
		}
	} else {
		substr1 = parts[len(parts)-2]
		substr2 = parts[len(parts)-1]
	}

	return substr1, substr2
}

func generateSubstr(substr string, parts []string, length int) string {
	if substr == "" {
		substr = parts[len(parts)-length]
	}
	return substr
}

// GetAdjacentVulnLines is used to get the lines adjacent to the line that contains the vulnerability
// adj is the amount of lines wanted
func GetAdjacentVulnLines(idx, adj int, lines []string) *[]model.CodeLine {
	var endPos int
	var startPos int
	if adj <= len(lines) {
		endPos = idx + adj/2 + 1 // if adj lines passes the number of lines in file
		if len(lines) < endPos {
			endPos = len(lines)
		}
		startAdj := adj
		if adj%2 == 0 {
			startAdj--
		}

		startPos = idx - startAdj/2 // if adj lines passes the first line in the file
		if startPos < 0 {
			startPos = 0
		}
	} else { // in case adj is bigger than number of lines in file
		adj = len(lines)
		endPos = len(lines)
		startPos = 0
	}

	switch idx {
	case 0:
		// case vulnerability is the first line of the file
		return createVulnLines(1, lines[:adj])
	case len(lines) - 1:
		// case vulnerability is the last line of the file
		return createVulnLines(len(lines)-adj+1, lines[len(lines)-adj:])
	default:
		// case vulnerability is in the middle of the file
		return createVulnLines(startPos+1, lines[startPos:endPos])
	}
}

// createVulnLines is the function that will  generate the array that contains the lines numbers
// used to alter the color of the line that contains the vulnerability
func createVulnLines(startPos int, lines []string) *[]model.CodeLine {
	vulns := make([]model.CodeLine, len(lines))
	for idx, line := range lines {
		vulns[idx] = model.CodeLine{
			Line:     line,
			Position: startPos,
		}
		startPos++
	}
	return &vulns
}

// SelectLineWithMinimumDistance will search a map of levenshtein distances to find the minimum distance
func SelectLineWithMinimumDistance(distances map[int]int, startingFrom int) int {
	minDistance, lineOfMinDistance := constants.MaxInteger, startingFrom
	for line, distance := range distances {
		if distance < minDistance || distance == minDistance && line < lineOfMinDistance {
			minDistance = distance
			lineOfMinDistance = line
		}
	}

	return lineOfMinDistance
}

// ExtractLineFragment will prepare substr for line detection
func ExtractLineFragment(line, substr string, key bool) string {
	// If detecting line by keys only
	idx := strings.Index(line, ":")
	if key && idx >= 0 {
		return line[:idx]
	}
	start := strings.Index(line, substr)
	end := start + len(substr)

	for start >= 0 {
		if line[start] == ' ' {
			break
		}

		start--
	}

	for end < len(line) {
		if line[end] == ' ' {
			break
		}

		end++
	}

	return removeExtras(line, start, end)
}

func removeExtras(result string, start, end int) string {
	// workaround for selecting yaml keys
	if result[end-1] == ':' {
		end--
	}

	if result[end-1] == '"' {
		end--
	}

	if result[start+1] == '"' {
		start++
	}

	return result[start+1 : end]
}

// DetectCurrentLine uses levenshtein distance to find the most accurate line for the vulnerability
func (d *DefaultDetectLineResponse) DetectCurrentLine(str1, str2 string, recurseCount int,
	lines []string) (det *DefaultDetectLineResponse, l []string) {
	distances := make(map[int]int)

	for i := d.CurrentLine; i < len(lines); i++ {
		distances = checkLine(str1, str2, distances, lines[i], i)
	}

	if len(distances) == 0 {
		d.IsBreak = true
		return d, lines
	}

	d.CurrentLine = SelectLineWithMinimumDistance(distances, d.CurrentLine)
	d.IsBreak = false
	d.FoundAtLeastOne = true

	return d, lines
}

func checkLine(str1, str2 string, distances map[int]int, line string, i int) map[int]int {
	regex := regexp.MustCompile(`^\s+`)
	line = regex.ReplaceAllString(line, "")
	if str1 != "" && str2 != "" && strings.Contains(line, str1) {
		restLine := line[strings.Index(line, str1)+len(str1):]
		if strings.Contains(restLine, str2) {
			distances[i] = levenshtein.ComputeDistance(ExtractLineFragment(line, str1, false), str1)
			distances[i] += levenshtein.ComputeDistance(ExtractLineFragment(restLine, str2, false), str2)
		}
	} else if str1 != "" && strings.Contains(line, str1) {
		distances[i] = levenshtein.ComputeDistance(ExtractLineFragment(line, str1, false), str1)
	}

	return distances
}
