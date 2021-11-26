package report

import (
	"encoding/json"
	"encoding/xml"
	"fmt"
	"html/template"
	"os"
	"path/filepath"
	"strconv"
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
		"toString":       toString,
	}
)

func toString(value interface{}) string {
	switch v := value.(type) {
	case string:
		return v
	case int:
		return strconv.Itoa(v)
	default:
		return fmt.Sprintf("%v", v)
	}
}

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

func fileCreationReport(path, filename string) {
	log.Info().Str("fileName", filename).Msgf("Results saved to file %s", path)
	fmt.Printf("Results saved to file %s\n", path)
}

func closeFile(path, filename string, file *os.File) {
	err := file.Close()
	if err != nil {
		log.Err(err).Msgf("Failed to close file %s", path)
	}

	fileCreationReport(path, filename)
}

func getPlatforms(queries model.QueryResultSlice) string {
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

func exportXMLReport(path, filename string, body interface{}) error {
	if !strings.HasSuffix(filename, ".xml") {
		filename += ".xml"
	}

	fullPath := filepath.Join(path, filename)
	f, err := os.OpenFile(filepath.Clean(fullPath), os.O_WRONLY|os.O_CREATE|os.O_TRUNC, os.ModePerm)
	if err != nil {
		return err
	}

	defer closeFile(fullPath, filename, f)

	encoder := xml.NewEncoder(f)
	encoder.Indent("", "\t")

	return encoder.Encode(body)
}
