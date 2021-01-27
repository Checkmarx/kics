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

// RetriesDefaultValue is default number of times a parser will retry to execute
const RetriesDefaultValue = 50

// Converter returns content json, error line, error
type Converter func(file *hcl.File) (model.Document, int, error)

// Parser struct that contains the function to parse file and the number of retries if something goes wrong
type Parser struct {
	convertFunc  Converter
	numOfRetries int
}

// NewDefault initializes a parser with Parser default values
func NewDefault() *Parser {
	return &Parser{
		numOfRetries: RetriesDefaultValue,
		convertFunc:  converter.DefaultConverted,
	}
}

// Parse execute parser for the content in a file
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

// SupportedExtensions returns Terraform extensions
func (p *Parser) SupportedExtensions() []string {
	return []string{".tf"}
}

// GetKind returns Terraform kind parser
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
