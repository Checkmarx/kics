package report

import (
	"fmt"
	"html/template"
	"os"
	"strings"
	"time"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/rs/zerolog/log"
)

var templateFuncs = template.FuncMap{
	"lower":          strings.ToLower,
	"sprintf":        fmt.Sprintf,
	"severity":       getSeverities,
	"getCurrentTime": getCurrentTime,
	"trimSpaces":     trimSpaces,
}

var stringsSeverity = map[string]model.Severity{
	"high":   model.AllSeverities[0],
	"medium": model.AllSeverities[1],
	"low":    model.AllSeverities[2],
	"info":   model.AllSeverities[3],
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

func closeFile(path, filename string, file *os.File) {
	err := file.Close()
	if err != nil {
		log.Err(err).Msgf("Failed to close file %s", path)
	}

	log.Info().Str("fileName", filename).Msgf("Results saved to file %s", path)
}
