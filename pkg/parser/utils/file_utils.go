package utils

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"

	"github.com/rs/zerolog/log"
	"gopkg.in/yaml.v3"
)

func convert(m map[interface{}]interface{}) map[string]interface{} {
	res := map[string]interface{}{}
	for k, v := range m {
		switch v2 := v.(type) {
		case map[interface{}]interface{}:
			res[fmt.Sprint(k)] = convert(v2)
		default:
			res[fmt.Sprint(k)] = v
		}
	}
	return res
}

func readFile(filePath string) (map[string]interface{}, error) {
	var result map[string]interface{}

	content, err := os.ReadFile(filePath)
	if err != nil {
		log.Trace().Msgf("failed to read %s", filePath)
		return nil, err
	}

	fileExtension := filepath.Ext(filePath)

	if fileExtension == ".json" {
		err := json.Unmarshal(content, &result)
		if err != nil {
			log.Error().Msgf("Failed to unmarshal '%s'", filePath)
			return nil, err
		}
	} else if fileExtension == ".yaml" || fileExtension == ".yml" {
		var resultYaml map[interface{}]interface{}
		err := yaml.Unmarshal(content, &resultYaml)
		if err != nil {
			log.Error().Msgf("Failed to unmarshal '%s'", filePath)
			return nil, err
		}
		result = convert(resultYaml)
	}

	return result, nil
}
