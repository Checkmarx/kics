package json

import (
	"bytes"
	"encoding/json"
	"fmt"
	"sort"
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/model"
)

type jsonLine struct {
	LineInfo map[string]model.Document
}

// jsonLineStruct is the struct that keeps important information for the creation of line Information Map
// tmpParent is the parent key of the value we are currently on
// pathArr is an array containing the path elements of the value we are currently on
// noremoveidx keeps information of which elements should not be removed from pathArr on closing delimiters
// lastWasRune keeps information if last Token was a delimiter
// parent is the string path of the element we are currently on
type jsonLineStruct struct {
	tmpParent   string
	pathArr     []string
	lastWasRune bool
	noremoveidx map[int]string
	parent      string
}

type fifo struct {
	name  string // for debugging purposes
	Value []int
}

// initiateJSONLine will create a map, containing line information for every key present in the JSON
func initializeJSONLine(doc []byte) *jsonLine {
	newMap := make(map[string]model.Document)
	dec := json.NewDecoder(bytes.NewReader(doc))

	jstruct := jsonLineStruct{
		tmpParent:   "",
		pathArr:     make([]string, 0),
		lastWasRune: false,
		noremoveidx: make(map[int]string),
		parent:      "",
	}

	line := 1
	prevInputOffset := 0

	// for each token inside JSON
	for {
		tok, err := dec.Token()
		if err != nil {
			break
		}

		if v, ok := tok.(json.Delim); ok {
			// token is a delimiter
			jstruct.delimSetup(v)
		} else {
			jstruct.lastWasRune = false
		}

		tokStringRepresentation := ""

		// if token is a string than update temporary father key
		switch t := tok.(type) {
		case string:
			jstruct.tmpParent = t
			tokStringRepresentation = t
		case float64:
			tokStringRepresentation = fmt.Sprint(int(t))
			jstruct.tmpParent = tokStringRepresentation
		case bool:
			tokStringRepresentation = fmt.Sprint(t)
			jstruct.tmpParent = tokStringRepresentation
		case nil:
			tokStringRepresentation = fmt.Sprint(t)
			jstruct.tmpParent = tokStringRepresentation
		default:
			continue
		}

		// get the correct line based on byte offset
		currentInputOffset := int(dec.InputOffset())
		for i := prevInputOffset; i < currentInputOffset; i++ {
			if doc[i] == byte('\n') {
				line++
			}
		}
		prevInputOffset = currentInputOffset

		// insert into line information map
		if _, ok := newMap[tokStringRepresentation]; !ok {
			// key info is not in map yet
			newLineSlice := &fifo{name: tokStringRepresentation}
			parentMap := make(map[string]interface{})
			newLineSlice.add(line)
			parentMap[jstruct.parent] = newLineSlice
			newMap[tokStringRepresentation] = parentMap
		} else if v, ok := newMap[tokStringRepresentation][jstruct.parent]; ok {
			// key info is in map with the same path so append is made
			newLineSlice := &fifo{name: tokStringRepresentation}
			newLineSlice.add(v.(*fifo).Value...)
			newLineSlice.add(line)
			newMap[tokStringRepresentation][jstruct.parent] = newLineSlice
		} else {
			// key info is in map with different path
			newLineSlice := &fifo{name: tokStringRepresentation}
			newLineSlice.add(line)
			newMap[tokStringRepresentation][jstruct.parent] = newLineSlice
		}
	}
	return &jsonLine{
		LineInfo: newMap,
	}
}

// delimSetup updates the jsonLineStruct when a json delimiter (ex: { [ ...) is found
func (j *jsonLineStruct) delimSetup(v json.Delim) {
	lenPathArr := len(j.pathArr) - 1
	switch rune(v) {
	case '{', '[':
		// check if last element was a json delimiter
		if !j.lastWasRune {
			j.pathArr = append(j.pathArr, j.tmpParent)
		} else {
			// check if temporary parent is in path array, if not last element must be the tempParent
			// and added to noremoveidx
			// the next close delimiter should not remove the last element from the pathArr
			if j.tmpParent != j.pathArr[lenPathArr] {
				j.tmpParent = j.pathArr[lenPathArr]
				j.noremoveidx[lenPathArr] = j.tmpParent
			} else {
				// the next close delimiter should not remove the last element from the pathArr
				j.noremoveidx[lenPathArr] = j.tmpParent
			}
		}
		// update parent path string
		j.parent = strings.Join(j.pathArr, ".")
	case '}', ']':
		j.closeBrackets(lenPathArr)
	}
	j.lastWasRune = true
}

// closeBrackets is what based on the jsonLineStruct information
// will update the parent path and make necessary updates on its structure
func (j *jsonLineStruct) closeBrackets(lenPathArr int) {
	// check if there are elements in the pathArr
	if lenPathArr > 0 {
		// check if there are elements in the no noremoveidx
		if v, ok := j.noremoveidx[lenPathArr]; ok {
			// if the last elements in pathArr and noremoveidx differ,
			// than the last element on pathArr was already closed and can
			// be removed
			if j.pathArr[lenPathArr] != v {
				j.pathArr = j.pathArr[:lenPathArr]
			} else {
				// the last element was not closed but should be closed
				// on the next closing delim
				// remove from noremoveidx
				delete(j.noremoveidx, lenPathArr)
			}
		} else {
			// this last element in the pathArr was closed
			// it can now be removed from the pathArr
			j.pathArr = j.pathArr[:lenPathArr]
		}
	}
	// update parent string path
	j.parent = strings.Join(j.pathArr, ".")
}

// setLineInfo will set the line information of keys in json based on the line Information map
func (j *jsonLine) setLineInfo(doc map[string]interface{}) map[string]interface{} {
	// set the line info for keys in root level
	doc["_kics_lines"] = j.setLine(doc, 0, "", false)
	return doc
}

// setLine returns the line information for the key containing values
// def is the line of the key
// index is used in case of an array, otherwhise should be 0
// father is the path to the key
func (j *jsonLine) setLine(val map[string]interface{}, def int, father string, pop bool) map[string]*model.LineObject {
	lineMap := make(map[string]*model.LineObject)
	// set the line information of val
	lineMap["_kics__default"] = &model.LineObject{
		Line: def,
		Arr:  []map[string]*model.LineObject{},
	}

	// iterate through the values of the object
	for key, v := range val {
		// if the key with father path was not found ignore
		if _, ok2 := j.LineInfo[key][father]; !ok2 {
			continue
		}

		line := j.LineInfo[key][father]

		if len(line.(*fifo).Value) == 0 {
			continue
		}

		lineArr := make([]map[string]*model.LineObject, 0)
		lineNr := line.(*fifo).head()
		if pop {
			lineNr = line.(*fifo).pop()
		}

		switch v := v.(type) {
		// value is an array and must call func setSeqLines to set element lines
		case []interface{}:
			lineArr = j.setSeqLines(v, lineNr, father, key, lineArr)
		// value is an object and must setLines for each element of the object
		case map[string]interface{}:
			v["_kics_lines"] = j.setLine(v, lineNr, fmt.Sprintf("%s.%s", father, key), pop)
		default:
			// value as no childs
			lineMap[fmt.Sprintf("_kics_%s", key)] = &model.LineObject{
				Line: lineNr,
				Arr:  lineArr,
			}
			continue
		}

		// set line information of value with its default line and
		// if present array elements line informations
		lineMap[fmt.Sprintf("_kics_%s", key)] = &model.LineObject{
			Line: lineNr,
			Arr:  lineArr,
		}
	}
	return lineMap
}

// setSeqLines sets the elements lines information for value of type array
func (j *jsonLine) setSeqLines(v []interface{}, def int, father, key string,
	lineArr []map[string]*model.LineObject) []map[string]*model.LineObject {
	// update father path with key
	fatherKey := father + "." + key

	// iterate over each element of the array
	for _, contentEntry := range v {
		defaultLineArr := j.getMapDefaultLine(v, fatherKey)
		if defaultLineArr == -1 {
			defaultLineArr = def
		}
		switch con := contentEntry.(type) {
		// case element is a map/object call func setLine
		case map[string]interface{}:
			lineArr = append(lineArr, j.setLine(con, defaultLineArr, fatherKey, true))
		// case element is a string
		default:
			stringedCon := fmt.Sprint(con)
			// check if element is present in line info map
			if lineStr, ok2 := j.LineInfo[stringedCon][fmt.Sprintf("%s.%s", father, key)]; ok2 {
				if len(lineStr.(*fifo).Value) == 0 {
					continue
				}
				lineArr = append(lineArr, map[string]*model.LineObject{
					"_kics__default": {
						Line: lineStr.(*fifo).pop(),
					},
				})
			}
		}
	}
	return lineArr
}

// must get all and choose the smallest one
func (j *jsonLine) getMapDefaultLine(v []interface{}, father string) int {
	returnNumber := -1
	for _, contentEntry := range v {
		linesNumbers := make([]int, 0)
		if c, ok := contentEntry.(map[string]interface{}); ok {
			for key := range c {
				if _, ok2 := j.LineInfo[key][father]; !ok2 {
					continue
				}
				line := j.LineInfo[key][father]
				if len(line.(*fifo).Value) == 0 {
					continue
				}
				linesNumbers = append(linesNumbers, line.(*fifo).head())
			}
			if len(linesNumbers) > 0 {
				sort.Ints(linesNumbers)
				returnNumber = linesNumbers[0]
			}
		}
	}
	return returnNumber
}

// SET OF TOOLS TO ASSIST WITH JSON LINE

func (f *fifo) add(elements ...int) {
	f.Value = append(f.Value, elements...)
}

func (f *fifo) pop() int {
	firstElement := f.Value[0]
	f.Value = f.Value[1:]
	return firstElement
}

func (f *fifo) head() int {
	return f.Value[0]
}
