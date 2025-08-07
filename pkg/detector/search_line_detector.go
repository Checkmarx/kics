package detector

import (
	"encoding/json"
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
	content            []byte
	resolvedPath       string
	resolvedArrayPaths []string
	targetObj          string
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

func updateArrayPaths(arrPaths []*strings.Builder, s string) {
	for i := range arrPaths {
		_, _ = arrPaths[i].WriteString(s)
	}
}

// preparePath resolves the path components and retrives important information
// for the creation of the paths to search
func (d *searchLineDetector) preparePath(pathItems []string) int {
	if len(pathItems) == 0 {
		return 1
	}

	// Escaping '.' in path components so it doesn't conflict with gjson pkg
	var objPath strings.Builder
	_, _ = objPath.WriteString(strings.ReplaceAll(pathItems[0], ".", `\.`))

	var arrayObjects []string

	// Iterate reversely through the path components and get the key of the last array in the path
	// needed for cases where the fields in the array are <"key": "value"> type and not <object>
	foundArrayIdx := false
	for i := len(pathItems) - 1; i >= 0; i-- {
		if number, found := strings.CutPrefix(pathItems[i], "_kics_number_"); found {
			pathItems[i] = number
			foundArrayIdx = true
			continue
		}
		if foundArrayIdx {
			arrayObjects = append(arrayObjects, pathItems[i])
			foundArrayIdx = false
		}
	}

	obj := strings.ReplaceAll(pathItems[len(pathItems)-1], ".", `\.`)

	nextArray := len(arrayObjects) - 1
	arrPaths := make([]*strings.Builder, 0, len(arrayObjects)+1)
	if nextArray >= 0 && arrayObjects[nextArray] == objPath.String() {
		var sb1, sb2 strings.Builder
		_, _ = sb1.WriteString("_kics_lines._kics_" + objPath.String() + "._kics_arr")
		_, _ = sb2.WriteString(objPath.String())
		arrPaths = append(arrPaths, &sb1, &sb2)
		nextArray--
	} else {
		var sb strings.Builder
		_, _ = sb.WriteString(objPath.String())
		arrPaths = append(arrPaths, &sb)
	}

	var treatedPathItems []string
	if len(pathItems) > 1 {
		treatedPathItems = pathItems[1 : len(pathItems)-1]
	}

	// Create a string based on the path components so it can be later transformed in a gjson path
	for _, pathItem := range treatedPathItems {
		cleanPathItem := strings.ReplaceAll(pathItem, ".", `\.`)
		// In case of an array present
		if nextArray >= 0 && pathItem == arrayObjects[nextArray] {
			lastArrayInd := len(arrPaths) - 1
			// Store the last array that doesn't yet include "_kics_lines"
			lastArray := arrPaths[lastArrayInd].String()
			// Update the last path to the one where "_kics_lines" appears in the current array, and update all previous paths accordingly
			_, _ = arrPaths[lastArrayInd].WriteString("._kics_lines")
			updateArrayPaths(arrPaths, "._kics_"+cleanPathItem+"._kics_arr")
			// Account for the possibility that "_kics_lines" appears later
			var sb strings.Builder
			_, _ = sb.WriteString(lastArray + "." + cleanPathItem)
			arrPaths = append(arrPaths, &sb)

			nextArray--
		} else {
			updateArrayPaths(arrPaths, "."+cleanPathItem)
		}
		_, _ = objPath.WriteString("." + cleanPathItem)
	}

	d.resolvedArrayPaths = make([]string, len(arrPaths))
	for i := range arrPaths {
		d.resolvedArrayPaths[i] = arrPaths[i].String()
	}

	d.resolvedPath = objPath.String()
	d.targetObj = obj

	return d.getResult()
}

// getResult creates the paths to be used by gjson pkg to find the line in the content
func (d *searchLineDetector) getResult() int {
	var pathObjects []string
	if d.resolvedPath == d.targetObj {
		pathObjects = []string{"_kics_lines._kics_" + d.targetObj + "._kics_line"}
	} else {
		pathObjects = make([]string, 2, 2+2*len(d.resolvedArrayPaths))
		pathObjects[0] = d.resolvedPath + "._kics_lines._kics_" + d.targetObj + "._kics_line"
		pathObjects[1] = d.resolvedPath + "." + d.targetObj + "._kics_lines._kics__default._kics_line"
		for _, resolvedArrayPath := range d.resolvedArrayPaths {
			pathObjects = append(pathObjects,
				resolvedArrayPath+"."+d.targetObj+"._kics__default._kics_line",
				resolvedArrayPath+"._kics_"+d.targetObj+"._kics_line",
			)
		}
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
