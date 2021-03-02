package report

import (
	"fmt"
	"html/template"
	"os"
	"path/filepath"
	"runtime"

	"github.com/rs/zerolog/log"
)

const (
	templateFile = "report.tmpl"
	cssFile      = "report.css"
)

func PrintHTMLReport(path, filename string, body interface{}) error {
	_, templatePath, _, ok := runtime.Caller(0)
	if !ok {
		return fmt.Errorf("report error: Report template not found")
	}

	fullPath := filepath.Join(path, filename+".html")
	templatePath = filepath.Join(filepath.Dir(templatePath), "template")
	t := template.Must(template.New(templateFile).Funcs(templateFuncs).ParseFiles(filepath.Join(templatePath, templateFile)))

	_ = os.MkdirAll(path, os.ModePerm)
	f, err := os.OpenFile(filepath.Clean(fullPath), os.O_WRONLY|os.O_CREATE|os.O_TRUNC, os.ModePerm)
	if err != nil {
		return err
	}
	defer closeFile(fullPath, filename+".html", f)
	if cssErr := copyFile(filepath.Join(templatePath, cssFile), filepath.Join(path, cssFile)); cssErr != nil {
		log.Err(err).Msgf("failed to copy style file from template")
	}
	err = t.Execute(f, body)
	return err
}
