package parser

import (
	"path/filepath"
	"strings"

	"github.com/checkmarxDev/ice/pkg/parser/converter"
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
	"github.com/pkg/errors"
)

const RetriesDefaultValue = 50

// Converter returns content json, error line, error
type Converter func(file *hcl.File) (string, int, error)

type TerraformParser struct {
	convertFunc  Converter
	numOfRetries int
}

func NewDefault() *TerraformParser {
	return &TerraformParser{
		numOfRetries: RetriesDefaultValue,
		convertFunc:  converter.DefaultConverted,
	}
}

func (p *TerraformParser) Parse(path string, content []byte) (string, error) {
	var (
		parsedContent string
		errLine       int
		errParse      error
	)

	for try := 0; try < p.numOfRetries; try++ {
		parsedContent, errLine, errParse = p.doParse(content, filepath.Base(path))
		if errParse != nil && errLine != 0 {
			content = p.removeProblematicLine(content, errLine)
			continue
		}

		break
	}

	if errParse != nil {
		return "", errors.Wrap(errParse, "failed terraform parse")
	}

	return parsedContent, nil
}

func (p *TerraformParser) removeProblematicLine(content []byte, line int) []byte {
	lines := strings.Split(string(content), "\n")
	if line > 0 && line <= len(lines) {
		lines[line-1] = ""
		return []byte(strings.Join(lines, "\n"))
	}
	return content
}

func (p *TerraformParser) doParse(content []byte, fileName string) (json string, errLine int, err error) {
	file, diagnostics := hclsyntax.ParseConfig(content, fileName, hcl.Pos{Byte: 0, Line: 1, Column: 1})

	if diagnostics != nil && diagnostics.HasErrors() && len(diagnostics.Errs()) > 0 {
		err := diagnostics.Errs()[0]
		line := 0

		if e, ok := err.(*hcl.Diagnostic); ok {
			line = e.Subject.Start.Line
		}

		return "", line, errors.Wrap(err, "failed to parse file")
	}

	return p.convertFunc(file)
}
