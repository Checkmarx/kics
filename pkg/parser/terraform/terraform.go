package terraform

import (
	"path/filepath"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/parser/terraform/converter"
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
	"github.com/pkg/errors"
)

// RetriesDefaultValue is default number of times a parser will retry to execute
const RetriesDefaultValue = 50

// Converter returns content json, error line, error
type Converter func(file *hcl.File, inputVariables converter.InputVariableMap) (model.Document, error)

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

// Resolve - replace or modifies in-memory content before parsing
func (p *Parser) Resolve(fileContent []byte, filename string) (*[]byte, error) {
	getInputVariables(filepath.Dir(filename))
	return &fileContent, nil
}

// Parse execute parser for the content in a file
func (p *Parser) Parse(path string, content []byte) ([]model.Document, error) {
	var (
		fc       model.Document
		parseErr error
	)

	fc, parseErr = p.doParse(content, filepath.Base(path))

	return []model.Document{fc}, errors.Wrap(parseErr, "failed terraform parse")
}

// SupportedExtensions returns Terraform extensions
func (p *Parser) SupportedExtensions() []string {
	return []string{".tf"}
}

// SupportedTypes returns types supported by this parser, which are terraform
func (p *Parser) SupportedTypes() []string {
	return []string{"Terraform"}
}

// GetKind returns Terraform kind parser
func (p *Parser) GetKind() model.FileKind {
	return model.KindTerraform
}

func (p *Parser) doParse(content []byte, fileName string) (json model.Document, err error) {
	file, diagnostics := hclsyntax.ParseConfig(content, fileName, hcl.Pos{Byte: 0, Line: 1, Column: 1})

	if diagnostics != nil && diagnostics.HasErrors() && len(diagnostics.Errs()) > 0 {
		err := diagnostics.Errs()[0]
		return nil, err
	}

	return p.convertFunc(file, inputVariableMap)
}
