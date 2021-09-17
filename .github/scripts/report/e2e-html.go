package main

import (
	"bytes"
	_ "embed" // used for embedding report static files
	"fmt"
	"html/template"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/Checkmarx/kics/pkg/utils"
	"github.com/tdewolff/minify/v2"
	minifyCSS "github.com/tdewolff/minify/v2/css"
	minifyHtml "github.com/tdewolff/minify/v2/html"
	minifyJS "github.com/tdewolff/minify/v2/js"
)

var (
	//go:embed template/html/e2e-report.tmpl
	htmlTemplate string
	//go:embed template/html/e2e-report.css
	cssTemplate string
	//go:embed template/html/e2e-report.js
	jsTemplate string
)

const (
	textHTML = "text/html"
)

func getCurrentTime() string {
	dt := time.Now()
	return fmt.Sprint(dt.Format("01/02/2006 15:04"))
}

var (
	templateFuncs = template.FuncMap{
		"getCurrentTime": getCurrentTime,
	}
)

func includeCSS(name string) template.HTML {
	minifier := minify.New()
	minifier.AddFunc("text/css", minifyCSS.Minify)
	cssMinified, err := minifier.String("text/css", cssTemplate)
	if err != nil {
		return ""
	}
	return template.HTML("<style>" + cssMinified + "</style>") //nolint
}

func includeJS(name string) template.HTML {
	minifier := minify.New()
	minifier.AddFunc("text/javascript", minifyJS.Minify)
	jsMinified, err := minifier.String("text/javascript", jsTemplate)
	if err != nil {
		return ""
	}
	return template.HTML("<script>" + jsMinified + "</script>") //nolint
}

func generateE2EReport(path, filename string, body interface{}) error {
	defer utils.PanicHandler()
	if !strings.HasSuffix(filename, ".html") {
		filename += ".html"
	}

	templateFuncs["includeCSS"] = includeCSS
	templateFuncs["includeJS"] = includeJS

	fullPath := filepath.Join(path, filename)
	t := template.Must(template.New("report.tmpl").Funcs(templateFuncs).Parse(htmlTemplate))

	f, err := os.OpenFile(filepath.Clean(fullPath), os.O_WRONLY|os.O_CREATE|os.O_TRUNC, os.ModePerm)
	if err != nil {
		return err
	}

	//defer closeFile(fullPath, filename, f)

	var buffer bytes.Buffer

	err = t.Execute(&buffer, body)
	if err != nil {
		return err
	}
	minifier := minify.New()
	minifier.AddFunc(textHTML, minifyHtml.Minify)
	minifier.Add(textHTML, &minifyHtml.Minifier{
		KeepDocumentTags: true,
		KeepEndTags:      true,
		KeepQuotes:       true,
	})

	minifierWriter := minifier.Writer(textHTML, f)
	defer minifierWriter.Close()

	_, err = minifierWriter.Write(buffer.Bytes())
	return err
}
