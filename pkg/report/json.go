package report

import (
	"encoding/json"
	"os"
	"path/filepath"
	"strings"
)

const jsonExtension = ".json"

// PrintJSONReport prints on JSON file the summary results
func PrintJSONReport(path, filename string, body interface{}) error {
	if !strings.Contains(filename, ".") {
		filename += jsonExtension
	}
	fullPath := filepath.Join(path, filename)

	f, err := os.OpenFile(filepath.Clean(fullPath), os.O_WRONLY|os.O_CREATE|os.O_TRUNC, os.ModePerm)
	if err != nil {
		return err
	}

	defer closeFile(fullPath, filename, f)

	encoder := json.NewEncoder(f)
	encoder.SetIndent("", "\t")

	return encoder.Encode(body)
}
