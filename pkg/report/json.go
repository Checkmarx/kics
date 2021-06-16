package report

import (
	"encoding/json"
	"os"
	"path/filepath"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
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

	var summary model.Summary
	result, err := json.Marshal(body)
	if err != nil {
		return err
	}
	if err := json.Unmarshal(result, &summary); err != nil {
		return err
	}

	basePath, err := os.Getwd()
	if err != nil {
		return err
	}

	for i := range summary.Queries {
		query := summary.Queries[i]
		for j := range query.Files {
			query.Files[j].FileName = getRelativePath(basePath, query.Files[j].FileName)
		}
	}

	defer closeFile(fullPath, filename, f)

	encoder := json.NewEncoder(f)
	encoder.SetIndent("", "\t")

	return encoder.Encode(summary)
}
