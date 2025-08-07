package detector

import (
	"encoding/json"
	"strconv"
	"strings"

	"github.com/tidwall/gjson"

	"github.com/Checkmarx/kics/v2/pkg/model"
)

// searchLineDetector is the struct used to get the line from the payload with lines information
// content - payload with line information
// resolvedPath - string created from pathComponents, used to create gjson paths
// resolvedArrayPath - string created from pathComponents containing an array used to create gjson paths
// targetObj - key of the interface{}, we want the line from
// usingNewComputeSimilarityID - boolean stating if the new ComputeSimilarityID is being used
type searchLineDetector struct {
	content                     []byte
	resolvedPath                string
	resolvedArrayPath           string
	targetObj                   string
	usingNewComputeSimilarityID bool
}

// GetLineBySearchLine makes use of the gjson pkg to find the line of a key in the original file
// with it's path given by a slice of strings
func GetLineBySearchLine(pathComponents []string, file *model.FileMetadata, usingNewComputeSimilarityID bool) (oldResult, newResult int, err error) {
	content, err := json.Marshal(file.LineInfoDocument)
	if err != nil {
		return -1, -1, err
	}

	detector := &searchLineDetector{
		content:                     content,
		usingNewComputeSimilarityID: usingNewComputeSimilarityID,
	}
	oldResult, newResult = detector.preparePath(pathComponents)
	return oldResult, newResult, nil
}

// preparePath resolves the path components and retrives important information
// for the creation of the paths to search
func (d *searchLineDetector) preparePath(pathItems []string) (oldResult, newResult int) { // returns the old and new searchLine numbers
	if len(pathItems) == 0 {
		return -1, 1
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
func (d *searchLineDetector) getResult() (oldResult, newResult int) {
	pathObjects := []string{
		d.resolvedPath + "._kics_lines._kics_" + d.targetObj + "._kics_line",
		d.resolvedPath + "." + d.targetObj + "._kics_lines._kics__default._kics_line",
		d.resolvedArrayPath + "." + d.targetObj + "._kics__default._kics_line",
		d.resolvedArrayPath + "._kics_" + d.targetObj + "._kics_line",
	}

	oldResult = -1
	// run gjson pkg
	for _, pathItem := range pathObjects {
		if tmpResult := gjson.GetBytes(d.content, pathItem); int(tmpResult.Int()) > 0 {
			oldResult = int(tmpResult.Int())
			return oldResult, oldResult // return the normal result if found giving precedence to the old methods
		}
	}

	newResult = -1
	if d.usingNewComputeSimilarityID {
		// new abilities to use searchLine
		pathObjectsNew := []string{}
		// for cases where key/object is in the root && usingNewComputeSimilarityID is true
		if d.resolvedPath == d.targetObj {
			pathObjectsNew = append(pathObjectsNew,
				d.resolvedPath+"._kics_lines._kics__default._kics_line", // for cases where the object is in the root
				"_kics_lines._kics_"+d.targetObj+"._kics_line",          // for cases where key is in the root
			)
		}

		if len(pathObjectsNew) > 0 {
			for _, pathItem := range pathObjectsNew {
				if tmpResult := gjson.GetBytes(d.content, pathItem); int(tmpResult.Int()) > 0 {
					newResult = int(tmpResult.Int())
					break // found using the new methods, break the loop
				}
			}
		}
	}
	return oldResult, newResult // only return the new result if found with old methods
}
