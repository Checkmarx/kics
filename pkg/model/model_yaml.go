package model

import (
	"encoding/json"
	"errors"
	"path/filepath"
	"strconv"

	"github.com/rs/zerolog/log"
	"gopkg.in/yaml.v3"

	"github.com/Checkmarx/kics/v2/pkg/utils"
)

const (
	mergeKey = "<<"
)

// UnmarshalYAML is a custom yaml parser that places line information in the payload
func (m *Document) UnmarshalYAML(value *yaml.Node) error {
	visited := make(map[*yaml.Node]interface{})
	dpc := unmarshalWithVisited(value, visited)
	if mapDcp, ok := dpc.(map[string]interface{}); ok {
		// set line information for root level objects
		mapDcp["_kics_lines"] = getLines(value, 0)

		// place the payload in the Document struct
		tmp, _ := json.Marshal(mapDcp)
		_ = json.Unmarshal(tmp, m)
		return nil
	}
	return errors.New("failed to parse yaml content")
}

// GetIgnoreLines get the lines to ignore in the KICS results
// lines ignore can have the lines from the resolved files
// since inspector secrets only looks to original data, the lines ignore should be replaced in yaml cases
func GetIgnoreLines(file *FileMetadata) []int {
	ignoreLines := file.LinesIgnore

	if utils.Contains(filepath.Ext(file.FilePath), []string{".yml", ".yaml"}) {
		NewIgnore.Reset()
		var node yaml.Node

		if err := yaml.Unmarshal([]byte(file.OriginalData), &node); err != nil {
			log.Info().Msgf("failed to unmarshal file: %s", err)
			return ignoreLines
		}

		if node.Kind == 1 && len(node.Content) == 1 {
			visited := make(map[*yaml.Node]interface{})
			_ = unmarshalWithVisited(node.Content[0], visited)
			ignoreLines = NewIgnore.GetLines()
		}
	}

	return ignoreLines
}

/*
	YAML Node TYPES

	SequenceNode -> array
	ScalarNode -> generic (except for arrays, objects and maps)
	MappingNode -> map
*/

// unmarshalWithVisited is the function that will parse the yaml elements and call the functions needed
// to place their line information in the payload. It tracks visited nodes to prevent infinite recursion.
func unmarshalWithVisited(val *yaml.Node, visited map[*yaml.Node]interface{}) interface{} { //nolint:gocyclo
	// Check if we've already visited this node to prevent infinite recursion
	if result, found := visited[val]; found {
		return result
	}

	tmp := make(map[string]interface{})
	visited[val] = tmp
	ignoreCommentsYAML(val)

	// if Yaml Node is an Array than we are working with ansible
	// which need to be placed inside "playbooks"
	switch val.Kind {
	case yaml.SequenceNode:
		contentArray := make([]interface{}, 0)
		for _, contentEntry := range val.Content {
			contentArray = append(contentArray, unmarshalWithVisited(contentEntry, visited))
		}
		tmp["playbooks"] = contentArray
	case yaml.ScalarNode:
		result := scalarNodeResolver(val)
		visited[val] = result
		return result
	default:
		for i := 0; i < len(val.Content); i += 2 {
			if val.Content[i].Kind == yaml.ScalarNode {
				switch val.Content[i+1].Kind {
				case yaml.ScalarNode:
					tmp[val.Content[i].Value] = scalarNodeResolver(val.Content[i+1])
				// in case value iteration is a map
				case yaml.MappingNode:
					// unmarshall map value and get its line information
					tt := unmarshalWithVisited(val.Content[i+1], visited).(map[string]interface{})
					tt["_kics_lines"] = getLines(val.Content[i+1], val.Content[i].Line)
					tmp[val.Content[i].Value] = tt
				// in case value iteration is an array
				case yaml.SequenceNode:
					contentArray := make([]interface{}, 0)
					// unmarshall each iteration of the array
					for _, contentEntry := range val.Content[i+1].Content {
						contentArray = append(contentArray, unmarshalWithVisited(contentEntry, visited))
					}
					tmp[val.Content[i].Value] = contentArray
				case yaml.AliasNode:
					aliasTarget := val.Content[i+1].Alias
					if aliasTarget != nil {
						if val.Content[i].Value == mergeKey {
							// merge key: spreads aliased keys into current level
							// example: merged: { <<: *default, key3: value3 }
							if tt, ok := unmarshalWithVisited(aliasTarget, visited).(map[string]interface{}); ok {
								for k, v := range tt {
									if k != "_kics_lines" {
										tmp[k] = v
									}
								}
							}
						} else {
							// regular alias: assigns entire aliased object to a key
							// example: myfield: *default
							aliasValue := unmarshalWithVisited(aliasTarget, visited)
							if tt, ok := aliasValue.(map[string]interface{}); ok {
								ttCopy := make(map[string]interface{})
								for k, v := range tt {
									ttCopy[k] = v
								}
								ttCopy["_kics_lines"] = getLines(aliasTarget, val.Content[i].Line)
								tmp[val.Content[i].Value] = ttCopy
							} else {
								tmp[val.Content[i].Value] = aliasValue
							}
						}
					}
				}
			}
		}
	}
	visited[val] = tmp
	return tmp
}

// getLines creates the map containing the line information for the yaml Node
// def is the line to be used as "_kics__default"
func getLines(val *yaml.Node, def int) map[string]*LineObject {
	visited := make(map[*yaml.Node]map[string]*LineObject)
	return getLinesWithVisited(val, def, visited)
}

// getLinesWithVisited creates the map containing the line information for the yaml Node
// with visited node tracking to prevent infinite recursion on circular aliases
func getLinesWithVisited(val *yaml.Node, def int, visited map[*yaml.Node]map[string]*LineObject) map[string]*LineObject { //nolint:gocyclo
	// check if we've already visited this node
	if result, found := visited[val]; found {
		return result
	}

	lineMap := make(map[string]*LineObject)
	visited[val] = lineMap

	// if yaml Node is an Array use func getSeqLines
	if val.Kind == yaml.SequenceNode {
		result := getSeqLinesWithVisited(val, def, visited)
		visited[val] = result
		return result
	}

	// line information map
	lineMap["_kics__default"] = &LineObject{
		Line: def,
		Arr:  []map[string]*LineObject{},
	}

	// iterate two by two, since first iteration is the key and the second is the value
	for i := 0; i < len(val.Content); i += 2 {
		lineArr := make([]map[string]*LineObject, 0)
		// in case the value iteration is an array call getLines for each iteration of the array
		if val.Content[i+1].Kind == yaml.SequenceNode {
			for _, contentEntry := range val.Content[i+1].Content {
				defaultLine := val.Content[i].Line
				if contentEntry.Kind == yaml.ScalarNode {
					defaultLine = contentEntry.Line
				} else if contentEntry.Kind == yaml.MappingNode && len(contentEntry.Content) > 0 {
					defaultLine = contentEntry.Content[0].Line
				}
				lineArr = append(lineArr, getLinesWithVisited(contentEntry, defaultLine, visited))
			}
		}

		// merge key (<<: *alias): merge line information from aliased node
		if val.Content[i].Value == mergeKey && val.Content[i+1].Kind == yaml.AliasNode {
			if val.Content[i+1].Alias != nil {
				aliasLines := getLinesWithVisited(val.Content[i+1].Alias, val.Content[i+1].Alias.Line, visited)
				for key, lineObj := range aliasLines {
					if key != "_kics__default" {
						lineMap[key] = lineObj
					}
				}
			}
			continue
		}

		// line information map of each key of the yaml Node
		lineMap["_kics_"+val.Content[i].Value] = &LineObject{
			Line: val.Content[i].Line,
			Arr:  lineArr,
		}
	}

	visited[val] = lineMap
	return lineMap
}

// getSeqLinesWithVisited iterates through the elements of an Array
// creating a map with each iteration lines information, with visited node tracking
func getSeqLinesWithVisited(val *yaml.Node, def int, visited map[*yaml.Node]map[string]*LineObject) map[string]*LineObject {
	lineMap := make(map[string]*LineObject)
	lineArr := make([]map[string]*LineObject, 0)

	// get line information slice of every element in the array
	for _, cont := range val.Content {
		lineArr = append(lineArr, getLinesWithVisited(cont, cont.Line, visited))
	}

	// create line information of array with its line and elements line information
	lineMap["_kics__default"] = &LineObject{
		Line: def,
		Arr:  lineArr,
	}
	return lineMap
}

// scalarNodeResolver transforms a ScalarNode value in its correct type
func scalarNodeResolver(val *yaml.Node) interface{} {
	var transformed interface{} = val.Value
	switch val.Tag {
	case "!!bool":
		transformed = transformBoolScalarNode(val.Value)
	case "!!int":
		v, err := strconv.ParseInt(val.Value, 0, 64)
		if err != nil {
			log.Error().Msgf("failed to convert integer in yaml parser")
			return val.Value
		}
		transformed = v
	case "!!null":
		transformed = nil
	}

	return transformed
}

// transformBoolScalarNode transforms a string value to its boolean representation
func transformBoolScalarNode(value string) bool {
	switch value {
	case "true", "True":
		return true
	default:
		return false
	}
}
