package utils

import (
	"encoding/json"
	"encoding/xml"
	"os"
	"path/filepath"
	"testing"

	reportModel "github.com/Checkmarx/kics/pkg/report/model"
	"github.com/stretchr/testify/require"
)

// XMLToJSON - converts XML to JSON Structure
func XMLToJSON(t *testing.T, filename string) []byte {
	cwd, _ := os.Getwd()
	filePath := filepath.Join("output", filename)
	fullPath := filepath.Join(cwd, filePath)

	file, err := ReadFixture(filePath, cwd)
	require.NoError(t, err, "Error reading file: %s", fullPath)

	data := reportModel.NewJUnitReport("")
	err = xml.Unmarshal([]byte(file), &data)
	require.NoError(t, err, "Error unmarshalling file: %s", fullPath)

	jsonData, err := json.Marshal(data)
	require.NoError(t, err, "Error marshaling file: %s", fullPath)

	return jsonData
}
