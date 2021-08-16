package model

import (
	json "encoding/json"

	"gopkg.in/yaml.v3"
)

func (m *Document) UnmarshalYAML(value *yaml.Node) error {
	dpc := unmarshal(value)
	dpc["_kics_lines"] = getLines(value, 0)

	tmp, _ := json.Marshal(dpc)
	_ = json.Unmarshal(tmp, m)
	return nil
}

func unmarshal(val *yaml.Node) map[string]interface{} {
	tmp := make(map[string]interface{})

	if val.Kind == yaml.SequenceNode {
		var contentArray []map[string]interface{}
		for _, contentEntry := range val.Content {
			contentArray = append(contentArray, unmarshal(contentEntry))
		}

		tmp["playbooks"] = contentArray
	} else {
		for i := 0; i < len(val.Content); i += 2 {
			if val.Content[i].Kind == yaml.ScalarNode {
				switch val.Content[i+1].Kind {
				case yaml.ScalarNode:
					tmp[val.Content[i].Value] = val.Content[i+1].Value

				case yaml.MappingNode:
					tt := unmarshal(val.Content[i+1])
					tt["_kics_lines"] = getLines(val.Content[i+1], val.Content[i].Line)
					tmp[val.Content[i].Value] = tt

				case yaml.SequenceNode:
					var contentArray []map[string]interface{}
					for _, contentEntry := range val.Content[i+1].Content {
						contentArray = append(contentArray, unmarshal(contentEntry))
					}

					tmp[val.Content[i].Value] = contentArray
				}
			}
		}
	}

	return tmp
}

func getSeqLines(val *yaml.Node, def int) map[string]LineObject {
	lineMap := make(map[string]LineObject)
	lineArr := make([]map[string]LineObject, 0)
	for _, cont := range val.Content {
		lineArr = append(lineArr, getLines(cont, cont.Line))
	}
	lineMap["_kics__default"] = LineObject{
		Line: def,
		Arr:  lineArr,
	}
	return lineMap
}

func getLines(val *yaml.Node, def int) map[string]LineObject {
	lineMap := make(map[string]LineObject)
	lineMap["_kics__default"] = LineObject{
		Line: def,
		Arr:  []map[string]LineObject{},
	}
	if val.Kind == yaml.SequenceNode {
		return getSeqLines(val, def)
	}
	for i := 0; i < len(val.Content); i += 2 {
		lineArr := make([]map[string]LineObject, 0)
		if val.Content[i+1].Kind == yaml.SequenceNode {
			for _, contentEntry := range val.Content[i+1].Content {
				lineArr = append(lineArr, getLines(contentEntry, val.Content[i].Line))
			}
		}
		lineMap["_kics_"+val.Content[i].Value] = LineObject{
			Line: val.Content[i].Line,
			Arr:  lineArr,
		}
	}
	return lineMap
}
