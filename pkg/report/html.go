package report

import (
	"bytes"
	"fmt"
	"html/template"
	"os"
	"path/filepath"
	"runtime"
	"strings"

	"github.com/rs/zerolog/log"
	"github.com/tdewolff/minify/v2"
	minifyCSS "github.com/tdewolff/minify/v2/css"
	minifyHtml "github.com/tdewolff/minify/v2/html"
)

const (
	templateFile = "report.tmpl"
)

var templatePath = ""

func includeSVG(name string) template.HTML {
	svg, err := os.ReadFile(filepath.Join(templatePath, name))
	if err != nil {
		log.Err(err).Msgf("failed to open svg: %s", name)
		return ""
	}
	return template.HTML(string(svg)) //nolint
}

func includeCSS(name string) template.HTML {
	css, err := os.ReadFile(filepath.Join(templatePath, name))
	if err != nil {
		log.Err(err).Msgf("failed to open svg: %s", name)
		return ""
	}
	minifier := minify.New()
	minifier.AddFunc("text/css", minifyCSS.Minify)
	cssMinified, err := minifier.Bytes("text/css", css)
	if err != nil {
		return ""
	}
	return template.HTML("<style>" + string(cssMinified) + "</style>") //nolint
}

func PrintHTMLReport(path, filename string, body interface{}) error {
	if !strings.HasSuffix(filename, ".html") {
		filename += ".html"
	}

	_, templatePathFromStack, _, ok := runtime.Caller(0)
	if !ok {
		return fmt.Errorf("report error: Report template not found")
	}
	templatePath = templatePathFromStack
	templateFuncs["includeSVG"] = includeSVG
	templateFuncs["includeCSS"] = includeCSS

	fullPath := filepath.Join(path, filename)
	templatePath = filepath.Join(filepath.Dir(templatePath), "template", "html")
	t := template.Must(template.New(templateFile).Funcs(templateFuncs).ParseFiles(filepath.Join(templatePath, templateFile)))

	_ = os.MkdirAll(path, os.ModePerm)
	f, err := os.OpenFile(filepath.Clean(fullPath), os.O_WRONLY|os.O_CREATE|os.O_TRUNC, os.ModePerm)
	if err != nil {
		return err
	}
	defer closeFile(fullPath, filename, f)
	var buffer bytes.Buffer

	err = t.Execute(&buffer, body)
	if err != nil {
		return err
	}
	minifier := minify.New()
	minifier.AddFunc("text/html", minifyHtml.Minify)
	minifier.Add("text/html", &minifyHtml.Minifier{
		KeepDocumentTags: true,
		KeepEndTags:      true,
		KeepQuotes:       true,
	})

	minifierWriter := minifier.Writer("text/html", f)
	defer minifierWriter.Close()

	_, err = minifierWriter.Write(buffer.Bytes())
	return err
}
