package report

import (
	"fmt"
	"html/template"
	"os"
	"path/filepath"
	"runtime"
)

func PrintHTMLReport(path, filename string, body interface{}) error {
	_, templatePath, _, ok := runtime.Caller(0)
	if !ok {
		return fmt.Errorf("report error: Report template not found")
	}

	fullPath := filepath.Join(path, filename+".html")
	templatePath = filepath.Join(filepath.Dir(templatePath), "template", "report.tmpl")
	t := template.Must(template.New(filepath.Base(templatePath)).ParseFiles(templatePath))

	_ = os.MkdirAll(path, os.ModePerm)
	f, err := os.OpenFile(filepath.Clean(fullPath), os.O_WRONLY|os.O_CREATE|os.O_TRUNC, os.ModePerm)
	if err != nil {
		return err
	}

	err = t.Execute(f, body)
	return err
}
