package additional

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/rs/zerolog/log"
	"github.com/stretchr/testify/require"
	"gopkg.in/yaml.v3"
)

var extensions = []string{".json", ".yaml", ".yml"}

var fileSwaggerPathTest = filepath.Join("..", "..", "..", "test", "fixtures", "test_swagger", "swaggerFileWithoutAuthorizer.yaml")

func TestReadFile(t *testing.T) {
	content, err := readFile(fileSwaggerPathTest)

	require.NoError(t, err)
	require.NotNil(t, content)
	require.Contains(t, extensions, filepath.Ext(fileSwaggerPathTest))
}

func TestConvert(t *testing.T) {
	content, err := os.ReadFile(fileSwaggerPathTest)
	if err != nil {
		log.Error().Msgf("Failed to read %s", fileSwaggerPathTest)
	}

	var resultYaml map[interface{}]interface{}

	err2 := yaml.Unmarshal(content, &resultYaml)
	if err2 != nil {
		log.Error().Msgf("Failed to unmarshal '%s'", fileSwaggerPathTest)
	}

	mapConverted := convert(resultYaml)

	require.NotEmpty(t, mapConverted)
}
