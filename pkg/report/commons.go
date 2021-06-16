package report

import (
	"encoding/json"
	"fmt"
	"html/template"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/rs/zerolog/log"
)

var (
	stringsSeverity = map[string]model.Severity{
		"high":   model.AllSeverities[0],
		"medium": model.AllSeverities[1],
		"low":    model.AllSeverities[2],
		"info":   model.AllSeverities[3],
	}

	templateFuncs = template.FuncMap{
		"lower":          strings.ToLower,
		"sprintf":        fmt.Sprintf,
		"severity":       getSeverities,
		"getCurrentTime": getCurrentTime,
		"trimSpaces":     trimSpaces,
	}
)

func trimSpaces(value string) string {
	return strings.TrimPrefix(value, " ")
}

func getSeverities(severity string) model.Severity {
	return stringsSeverity[severity]
}

func getCurrentTime() string {
	dt := time.Now()
	return fmt.Sprint(dt.Format("01/02/2006 15:04"))
}

func closeFile(path, filename string, file *os.File) {
	err := file.Close()
	if err != nil {
		log.Err(err).Msgf("Failed to close file %s", path)
	}

	log.Info().Str("fileName", filename).Msgf("Results saved to file %s", path)
	fmt.Printf("Results saved to file %s\n", path)
}

func getPlatforms(queries model.VulnerableQuerySlice) string {
	platforms := make([]string, 0)
	alreadyAdded := make(map[string]string)
	for idx := range queries {
		if _, ok := alreadyAdded[queries[idx].Platform]; !ok {
			alreadyAdded[queries[idx].Platform] = ""
			platforms = append(platforms, queries[idx].Platform)
		}
	}
	return strings.Join(platforms, ", ")
}

func getRelativePath(basePath, filePath string) string {
	var rtn string
	relativePath, err := filepath.Rel(basePath, filePath)
	if err != nil {
		log.Error().Msgf("Cannot make %s relative to %s", filePath, basePath)
		rtn = filePath
	} else {
		rtn = relativePath
	}
	return rtn
}

// ExportJSONReport - encodes a given body to a JSON file in a given filepath
func ExportJSONReport(path, filename string, body interface{}) error {
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

func getSummary(body interface{}) (sum model.Summary, err error) {
	var summary model.Summary
	result, err := json.Marshal(body)
	if err != nil {
		return model.Summary{}, err
	}
	if err := json.Unmarshal(result, &summary); err != nil {
		return model.Summary{}, err
	}

	return summary, nil
}
