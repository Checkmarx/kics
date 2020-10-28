package writer

import (
	"bytes"
	"html/template"
	"path/filepath"

	"github.com/checkmarxDev/ice/cmd/builder/engine"
)

type RegoWriter struct {
	tmpl *template.Template
}

func NewRegoWriter() (*RegoWriter, error) {
	tmpl, err := template.ParseFiles(filepath.Join("./cmd/builder/writer/template.gorego"))
	if err != nil {
		return nil, err
	}

	return &RegoWriter{tmpl: tmpl}, nil
}

func (w *RegoWriter) Render(rules []engine.Rule) ([]byte, error) {
	wr := bytes.NewBuffer(nil)
	if err := w.tmpl.Execute(wr, rules); err != nil {
		return nil, err
	}

	return wr.Bytes(), nil
}
