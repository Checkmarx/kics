package utils

import (
	"os"
	"path/filepath"

	"github.com/rs/zerolog/log"
)

// AddSwaggerInfo gets and adds the content of a swagger file
func AddSwaggerInfo(path, swaggerPath string) map[string]interface{} {
	var filePath string

	if _, err := os.Stat(swaggerPath); err != nil { // content is not a full valid path or is an incomplete path
		log.Trace().Msgf("path to the swagger specification is not a valid: %s", err)
		filePath = filepath.Join(filepath.Dir(path), swaggerPath)
	} else { // content is a full valid path
		filePath = swaggerPath
	}

	swaggerContent, err := readFile(filePath)

	if err == nil {
		attributes := make(map[string]interface{})
		attributes["file"] = filePath
		attributes["content"] = swaggerContent
		return attributes
	}

	return nil
}
