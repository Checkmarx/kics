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
// resolvedArrayPaths - strings created from pathComponents containing arrays used to create gjson paths
// targetObj - key of the interface{}, we want the line from
// usingNewComputeSimilarityID - boolean stating if the new ComputeSimilarityID is being used
type searchLineDetector struct {
	content                     []byte
	resolvedPath                string
	resolvedArrayPaths          []string
	targetObj                   string
	usingNewComputeSimilarityID bool
}

// GetLineBySearchLine makes use of the gjson pkg to find the line of a key in the original file
// with it's path given by a slice of strings
func GetLineBySearchLine(pathComponents []string, file *model.FileMetadata, usingNewComputeSimilarityID bool,
) (oldResult, newResult int, err error) {
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

func updateArrayPaths(arrPaths []*strings.Builder, s string) {
	for i := range arrPaths {
		_, _ = arrPaths[i].WriteString(s)
	}
}

// preparePath resolves the path components and retrives important information
// for the creation of the paths to search
func (d *searchLineDetector) preparePath(pathItems []string) (oldResult, newResult int) { // returns the old and new searchLine numbers
	if len(pathItems) == 0 {
		return -1, 1
	}

	// Escaping '.' in path components so it doesn't conflict with gjson pkg
	var objPath strings.Builder
	_, _ = objPath.WriteString(strings.ReplaceAll(pathItems[0], ".", `\.`))

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
func (d *searchLineDetector) getResult() (oldResult, newResult int) {
	var oldResolvedArrayPathInd int
	if l := len(d.resolvedArrayPaths); l > 1 {
		oldResolvedArrayPathInd = l - 2
	} else {
		oldResolvedArrayPathInd = 0
	}
	oldResolvedArrayPath := d.resolvedArrayPaths[oldResolvedArrayPathInd]

	pathObjects := []string{
		d.resolvedPath + "._kics_lines._kics_" + d.targetObj + "._kics_line",
		d.resolvedPath + "." + d.targetObj + "._kics_lines._kics__default._kics_line",
		oldResolvedArrayPath + "." + d.targetObj + "._kics__default._kics_line",
		oldResolvedArrayPath + "._kics_" + d.targetObj + "._kics_line",
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
				d.resolvedPath+"."+d.targetObj+"._kics_line",
			)
		} else {
			for _, resolvedArrayPath := range d.resolvedArrayPaths[0:oldResolvedArrayPathInd] {
				pathObjectsNew = append(pathObjectsNew,
					resolvedArrayPath+"."+d.targetObj+"._kics__default._kics_line",
					resolvedArrayPath+"._kics_"+d.targetObj+"._kics_line",
				)
			}
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
