package report

import (
	"encoding/json"
	"os"
	"path/filepath"
)

func PrintJSONReport(path, filename string, body interface{}) error {
	fullPath := filepath.Join(path, filename+".json")
	_ = os.MkdirAll(path, os.ModePerm)
	f, err := os.OpenFile(filepath.Clean(fullPath), os.O_WRONLY|os.O_CREATE|os.O_TRUNC, os.ModePerm)
	if err != nil {
		return err
	}

	defer closeFile(fullPath, filename+".json", f)

	encoder := json.NewEncoder(f)
	encoder.SetIndent("", "\t")

	return encoder.Encode(body)
}
