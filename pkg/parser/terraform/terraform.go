package terraform

import (
	"path/filepath"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/parser/terraform/converter"
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
	"github.com/pkg/errors"
)

const RetriesDefaultValue = 50

// Converter returns content json, error line, error
type Converter func(file *hcl.File) (model.Document, int, error)

type Parser struct {
	convertFunc  Converter
	numOfRetries int
}

func NewDefault() *Parser {
	return &Parser{
		numOfRetries: RetriesDefaultValue,
		convertFunc:  converter.DefaultConverted,
	}
}

func (p *Parser) Parse(path string, content []byte) ([]model.Document, error) {
	var (
		fc        model.Document
		lineOfErr int
		parseErr  error
	)

	for try := 0; try < p.numOfRetries; try++ {
		fc, lineOfErr, parseErr = p.doParse(content, filepath.Base(path))
		if parseErr != nil && lineOfErr != 0 {
			content = p.removeProblematicLine(content, lineOfErr)
			continue
		}

		break
	}

	return []model.Document{fc}, errors.Wrap(parseErr, "failed terraform parse")
}

func (p *Parser) SupportedExtensions() []string {
	return []string{".tf"}
}

func (p *Parser) GetKind() model.FileKind {
	return model.KindTerraform
}

func (p *Parser) removeProblematicLine(content []byte, line int) []byte {
	lines := strings.Split(string(content), "\n")
	if line > 0 && line <= len(lines) {
		lines[line-1] = ""
		return []byte(strings.Join(lines, "\n"))
	}
	return content
}

func (p *Parser) doParse(content []byte, fileName string) (json model.Document, errLine int, err error) {
	file, diagnostics := hclsyntax.ParseConfig(content, fileName, hcl.Pos{Byte: 0, Line: 1, Column: 1})

	if diagnostics != nil && diagnostics.HasErrors() && len(diagnostics.Errs()) > 0 {
		err := diagnostics.Errs()[0]
		line := 0

		if e, ok := err.(*hcl.Diagnostic); ok {
			line = e.Subject.Start.Line
		}

		return nil, line, errors.Wrap(err, "failed to parse file")
	}

	return p.convertFunc(file)
}
