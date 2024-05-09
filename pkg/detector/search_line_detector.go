package detector

import (
	"encoding/json"
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
	objPath := strings.ReplaceAll(pathItems[0], ".", "\\.")
	ArrPath := strings.ReplaceAll(pathItems[0], ".", "\\.")

	obj := pathItems[len(pathItems)-1]

	arrayObject := ""

	// Iterate reversely through the path components and get the key of the last array in the path
	// needed for cases where the fields in the array are <"key": "value"> type and not <object>
	foundArrayIdx := false
	for i := len(pathItems) - 1; i >= 0; i-- {
		if _, err := strconv.Atoi(pathItems[i]); err == nil {
			foundArrayIdx = true
			continue
		}
		if foundArrayIdx {
			arrayObject = pathItems[i]
			break
		}
	}

	if arrayObject == objPath {
		ArrPath = "_kics_lines._kics_" + arrayObject + "._kics_arr"
	}

	var treatedPathItems []string
	if len(pathItems) > 1 {
		treatedPathItems = pathItems[1 : len(pathItems)-1]
	}

	// Create a string based on the path components so it can be later transformed in a gjson path
	for _, pathItem := range treatedPathItems {
		// In case of an array present
		if pathItem == arrayObject {
			ArrPath += "._kics_lines._kics_" + strings.ReplaceAll(pathItem, ".", "\\.") + "._kics_arr"
		} else {
			ArrPath += "." + strings.ReplaceAll(pathItem, ".", "\\.")
		}
		objPath += "." + strings.ReplaceAll(pathItem, ".", "\\.")
	}

	d.resolvedPath = objPath
	d.resolvedArrayPath = ArrPath
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
