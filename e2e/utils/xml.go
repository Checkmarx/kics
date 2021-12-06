package utils

import (
	"encoding/json"
	"encoding/xml"
	"io/ioutil"
	"os"
	"path/filepath"
	"testing"

	reportModel "github.com/Checkmarx/kics/pkg/report/model"
	"github.com/stretchr/testify/require"
)

// XMLToJson - converts XML to JSON Structure
func XMLToJson(t *testing.T, filename string) []byte {
	cwd, _ := os.Getwd()
	fullPath := filepath.Join(cwd, "output", filename)

	file, err := os.Open(fullPath)
	require.NoError(t, err, "Error opening file: %s", fullPath)
	defer file.Close()

	body, err := ioutil.ReadAll(file)
	require.NoError(t, err, "Error reading file: %s", fullPath)

	data := reportModel.NewJUnitReport("")
	err = xml.Unmarshal(body, &data)
	require.NoError(t, err, "Error unmarshalling file: %s", fullPath)

	json, err := json.Marshal(data)
	require.NoError(t, err, "Error marshalling file: %s", fullPath)

	return json
}
