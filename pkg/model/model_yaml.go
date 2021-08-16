package model

import (
	json "encoding/json"
	"strconv"

	"github.com/rs/zerolog/log"
	"gopkg.in/yaml.v3"
)

func (m *Document) UnmarshalYAML(value *yaml.Node) error {
	dpc := unmarshal(value).(map[string]interface{})
	dpc["_kics_lines"] = getLines(value, 0)

	tmp, _ := json.Marshal(dpc)
	_ = json.Unmarshal(tmp, m)
	return nil
}

func unmarshal(val *yaml.Node) interface{} {
	tmp := make(map[string]interface{})

	if val.Kind == yaml.SequenceNode {
		contentArray := make([]interface{}, 0)
		for _, contentEntry := range val.Content {
			contentArray = append(contentArray, unmarshal(contentEntry))
		}
		tmp["playbooks"] = contentArray
	} else if val.Kind == yaml.ScalarNode {
		return transfromScalarNode(val) // Need to place bool
	} else {
		for i := 0; i < len(val.Content); i += 2 {
			if val.Content[i].Kind == yaml.ScalarNode {
				switch val.Content[i+1].Kind {
				case yaml.ScalarNode: // Need to place bool
					tmp[val.Content[i].Value] = transfromScalarNode(val.Content[i+1])

				case yaml.MappingNode:
					tt := unmarshal(val.Content[i+1]).(map[string]interface{})
					tt["_kics_lines"] = getLines(val.Content[i+1], val.Content[i].Line)
					tmp[val.Content[i].Value] = tt

				case yaml.SequenceNode:
					contentArray := make([]interface{}, 0)
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

func transfromScalarNode(val *yaml.Node) interface{} {
	if val.Tag == "!!bool" {
		switch val.Value {
		case "true", "True":
			return true
		default:
			return false
		}
	} else if val.Tag == "!!int" {
		v, err := strconv.Atoi(val.Value)
		if err != nil {
			log.Error().Msgf("failed to convert integer in yaml parser")
			return val.Value
		}
		return v
	} else if val.Tag == "!!null" {
		return nil
	}
	return val.Value
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
