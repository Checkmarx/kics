package report

import (
	"fmt"
	"html/template"
	"os"
	"path/filepath"
	"runtime"
	"strings"

	"github.com/rs/zerolog/log"
)

const (
	templateFile = "report.tmpl"
)

func PrintHTMLReport(path, filename string, body interface{}) error {
	_, templatePath, _, ok := runtime.Caller(0)
	if !ok {
		return fmt.Errorf("report error: Report template not found")
	}
	path = filepath.Join(path, "html_report")
	fullPath := filepath.Join(path, filename+".html")
	templatePath = filepath.Join(filepath.Dir(templatePath), "template", "html")
	t := template.Must(template.New(templateFile).Funcs(templateFuncs).ParseFiles(filepath.Join(templatePath, templateFile)))

	_ = os.MkdirAll(path, os.ModePerm)
	f, err := os.OpenFile(filepath.Clean(fullPath), os.O_WRONLY|os.O_CREATE|os.O_TRUNC, os.ModePerm)
	if err != nil {
		return err
	}
	defer closeFile(fullPath, filename+".html", f)

	resourceFiles, err := os.ReadDir(templatePath)
	if err != nil {
		return err
	}
	for _, resourceFile := range resourceFiles {
		resourceName := resourceFile.Name()
		if resourceFile.IsDir() || strings.HasSuffix(resourceName, ".tmpl") {
			continue
		}
		if copyErr := copyFile(filepath.Join(templatePath, resourceName), filepath.Join(path, resourceName)); copyErr != nil {
			log.Err(err).Msgf("failed to copy style file from template")
		}
	}
	err = t.Execute(f, body)
	return err
}
