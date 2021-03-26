package report

import (
	"bytes"
	_ "embed" // used for embedding report static files
	"html/template"
	"os"
	"path/filepath"
	"strings"

	"github.com/tdewolff/minify/v2"
	minifyCSS "github.com/tdewolff/minify/v2/css"
	minifyHtml "github.com/tdewolff/minify/v2/html"
)

var (
	//go:embed template/html/report.tmpl
	htmlTemplate string
	//go:embed template/html/report.css
	cssTemplate string
	//go:embed template/html/github.svg
	githubSVG string
	//go:embed template/html/info.svg
	infoSVG string
	//go:embed template/html/vulnerability_fill.svg
	vulnerabilityFillSVG string
	//go:embed template/html/vulnerability_out.svg
	vulnerabilityOutSVG string
)

var svgMap = map[string]string{
	"github.svg":             githubSVG,
	"info.svg":               infoSVG,
	"vulnerability_fill.svg": vulnerabilityFillSVG,
	"vulnerability_out.svg":  vulnerabilityOutSVG,
}

func includeSVG(name string) template.HTML {
	return template.HTML(svgMap[name]) //nolint
}

func includeCSS(name string) template.HTML {
	minifier := minify.New()
	minifier.AddFunc("text/css", minifyCSS.Minify)
	cssMinified, err := minifier.String("text/css", cssTemplate)
	if err != nil {
		return ""
	}
	return template.HTML("<style>" + cssMinified + "</style>") //nolint
}

// PrintHTMLReport creates a report file on HTML format
func PrintHTMLReport(path, filename string, body interface{}) error {
	if !strings.HasSuffix(filename, ".html") {
		filename += ".html"
	}

	templateFuncs["includeSVG"] = includeSVG
	templateFuncs["includeCSS"] = includeCSS

	fullPath := filepath.Join(path, filename)
	t := template.Must(template.New("report.tmpl").Funcs(templateFuncs).Parse(htmlTemplate))

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
