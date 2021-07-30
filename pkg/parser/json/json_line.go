package json

import (
	"bytes"
	"encoding/json"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
)

type jsonLine struct {
	lineInfo map[string]model.Document
}

type jsonLineStruct struct {
	tmpParent   string
	pathArr     []string
	lastWasRune bool
	noremoveidx []string
	parent      string
}

// initiateJSONLine will create a map, containing line information for every key
func initiateJSONLine(doc []byte) *jsonLine {
	newMap := make(map[string]model.Document)
	dec := json.NewDecoder(bytes.NewReader(doc))

	jstruct := jsonLineStruct{
		tmpParent:   "",
		pathArr:     make([]string, 0),
		lastWasRune: false,
		noremoveidx: make([]string, 0),
		parent:      "",
	}

	for {
		tok, err := dec.Token()
		if err != nil {
			break
		}
		if v, ok := tok.(json.Delim); ok {
			jstruct.delimSetup(v)
		} else {
			jstruct.lastWasRune = false
		}

		if v, ok := tok.(string); ok {
			jstruct.tmpParent = v
		} else {
			continue
		}

		line := 1
		for i, val := range doc {
			if val == byte('\n') {
				line++
			}
			if i == int(dec.InputOffset()) {
				break
			}
		}

		if _, ok := newMap[tok.(string)]; !ok {
			parentMap := make(map[string]interface{})
			parentMap[jstruct.parent] = line
			newMap[tok.(string)] = parentMap
		} else {
			newMap[tok.(string)][jstruct.parent] = line
		}
	}
	return &jsonLine{
		lineInfo: newMap,
	}
}

func (j *jsonLineStruct) delimSetup(v json.Delim) {
	switch rune(v) {
	case '{', '[':
		if !j.lastWasRune {
			j.pathArr = append(j.pathArr, j.tmpParent)
		} else {
			j.noremoveidx = append(j.noremoveidx, j.tmpParent)
		}
		j.parent = strings.Join(j.pathArr, ".")
	case '}', ']':
		j.closeBrackets()
	}
	j.lastWasRune = true
}

func (j *jsonLineStruct) closeBrackets() {
	lenPathArr := len(j.pathArr)
	lenNoRemove := len(j.noremoveidx)
	if lenPathArr > 0 {
		if lenNoRemove > 0 {
			if j.pathArr[lenPathArr-1] != j.noremoveidx[lenNoRemove-1] {
				j.pathArr = j.pathArr[:lenPathArr-1]
			} else {
				j.noremoveidx = j.noremoveidx[:lenNoRemove-1]
			}
		} else {
			j.pathArr = j.pathArr[:lenPathArr-1]
		}
	}
	j.parent = strings.Join(j.pathArr, ".")
}

func (j *jsonLine) setLineInfo(doc map[string]interface{}) map[string]interface{} {
	doc["_kics_lines"] = j.setLine(doc, 0, "")
	for key, val := range doc {
		switch v := val.(type) {
		case map[string]interface{}:
			v["_kics_lines"] = j.setLine(v, j.lineInfo[key][""].(int), "."+key)
		default:
			continue
		}
	}
	return doc
}

func (j *jsonLine) setLine(val map[string]interface{}, def int, father string) map[string]model.LineObject {
	lineMap := make(map[string]model.LineObject)
	lineMap["_kics__default"] = model.LineObject{
		Line: def,
		Arr:  []map[string]model.LineObject{},
	}
	for key, val := range val {
		if key == "_kics_lines" {
			continue
		}

		if _, ok2 := j.lineInfo[key][father]; !ok2 {
			continue
		}
		line := j.lineInfo[key][father]
		lineArr := make([]map[string]model.LineObject, 0)
		switch v := val.(type) {
		case []interface{}:
			fatherKey := father + "." + key
			for _, contentEntry := range v {
				switch con := contentEntry.(type) {
				case map[string]interface{}:
					lineArr = append(lineArr, j.setLine(con, line.(int), fatherKey))
				case string:
					if lineStr, ok2 := j.lineInfo[con][father+"."+key]; ok2 {
						lineArr = append(lineArr, map[string]model.LineObject{
							"_kics__default": {
								Line: lineStr.(int),
							},
						})
					}
				default:
					continue
				}
			}
		case map[string]interface{}:
			v["_kics_lines"] = j.setLine(v, line.(int), father+"."+key)
		default:
			lineMap["_kics_"+key] = model.LineObject{
				Line: line.(int),
				Arr:  lineArr,
			}
			continue
		}

		lineMap["_kics_"+key] = model.LineObject{
			Line: line.(int),
			Arr:  lineArr,
		}
	}
	return lineMap
}
