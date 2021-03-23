package report

import (
	"fmt"
	"html/template"
	"io"
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

func copyFile(originalFilepath, destinationFilepath string) error {
	srcFile, err := os.Open(originalFilepath)
	if err != nil {
		return err
	}
	defer srcFile.Close()
	destFile, err := os.Create(destinationFilepath)
	if err != nil {
		return err
	}
	defer destFile.Close()
	_, err = io.Copy(destFile, srcFile)
	if err != nil {
		return err
	}
	return destFile.Sync()
}

func closeFile(path, filename string, file *os.File) {
	err := file.Close()
	if err != nil {
		log.Err(err).Msgf("failed to close file %s", path)
	}

	log.Info().Str("fileName", filename).Msgf("Results saved to file %s", path)
}
