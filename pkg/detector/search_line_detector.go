package detector

import (
	"encoding/json"
	"slices"
	"strconv"
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/tidwall/gjson"
)

// searchLineDetector is the struct used to get the line from the payload with lines information
// content - payload with line information
// resolvedPath - string created from pathComponents, used to create gjson paths
// resolvedArrayPath - string created from pathComponents containing an array used to create gjson paths
// targetObj - key of the interface{}, we want the line from
type searchLineDetector struct {
	content           []byte
	resolvedPath      string
	resolvedArrayPath string
	targetObj         string
}

// GetLineBySearchLine makes use of the gjson pkg to find the line of a key in the original file
// with it's path given by a slice of strings
func GetLineBySearchLine(pathComponents []string, file *model.FileMetadata) (int, error) {
	content, err := json.Marshal(file.LineInfoDocument)
	if err != nil {
		return -1, err
	}

	detector := &searchLineDetector{
		content: content,
	}

	return detector.preparePath(pathComponents), nil
}

// preparePath resolves the path components and retrives important information
// for the creation of the paths to search
func (d *searchLineDetector) preparePath(pathItems []string) int {
	if len(pathItems) == 0 {
		return 1
	}
	// Escaping '.' in path components so it doesn't conflict with gjson pkg
	var objPath, ArrPath strings.Builder
	objPath.WriteString(strings.ReplaceAll(pathItems[0], ".", `\.`))

	obj := strings.ReplaceAll(pathItems[len(pathItems)-1], ".", `\.`)

	var arrayObjects []string

	// Iterate reversely through the path components and get the key of the last array in the path
	// needed for cases where the fields in the array are <"key": "value"> type and not <object>
	foundArrayIdx := false
	for i := len(pathItems) - 1; i >= 0; i-- {
		if _, err := strconv.Atoi(pathItems[i]); err == nil {
			foundArrayIdx = true
			continue
		}
		if foundArrayIdx {
			arrayObjects = append(arrayObjects, pathItems[i])
			foundArrayIdx = false
		}
	}

	numArrays := len(arrayObjects)
	hasKicsLines := numArrays > 0 && arrayObjects[numArrays-1] == objPath.String()
	if hasKicsLines {
		ArrPath.WriteString("_kics_lines._kics_" + objPath.String() + "._kics_arr")
	} else {
		ArrPath.WriteString(strings.ReplaceAll(pathItems[0], ".", `\.`))
	}

	var treatedPathItems []string
	if len(pathItems) > 1 {
		treatedPathItems = pathItems[1 : len(pathItems)-1]
	}

	// Create a string based on the path components so it can be later transformed in a gjson path
	for _, pathItem := range treatedPathItems {
		// In case of an array present
		if slices.Contains(arrayObjects, pathItem) {
			if !hasKicsLines {
				ArrPath.WriteString("._kics_lines")
				hasKicsLines = true
			}
			ArrPath.WriteString("._kics_" + strings.ReplaceAll(pathItem, ".", `\.`) + "._kics_arr")
		} else {
			ArrPath.WriteString("." + strings.ReplaceAll(pathItem, ".", `\.`))
		}
		objPath.WriteString("." + strings.ReplaceAll(pathItem, ".", `\.`))
	}

	d.resolvedPath = objPath.String()
	d.resolvedArrayPath = ArrPath.String()
	d.targetObj = obj

	return d.getResult()
}

// getResult creates the paths to be used by gjson pkg to find the line in the content
func (d *searchLineDetector) getResult() int {
	pathObjects := []string{
		d.resolvedPath + "._kics_lines._kics_" + d.targetObj + "._kics_line",
		d.resolvedPath + "." + d.targetObj + "._kics_lines._kics__default._kics_line",
		d.resolvedArrayPath + "." + d.targetObj + "._kics__default._kics_line",
		d.resolvedArrayPath + "._kics_" + d.targetObj + "._kics_line",
	}

	result := -1
	// run gjson pkg
	for _, pathItem := range pathObjects {
		if tmpResult := gjson.GetBytes(d.content, pathItem); int(tmpResult.Int()) > 0 {
			result = int(tmpResult.Int())
			break
		}
	}
	return result
}
