package terraform

import (
	"path/filepath"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/parser/additional"
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
	file, diagnostics := hclsyntax.ParseConfig(content, filepath.Base(path), hcl.Pos{Byte: 0, Line: 1, Column: 1})

	if diagnostics != nil && diagnostics.HasErrors() && len(diagnostics.Errs()) > 0 {
		err := diagnostics.Errs()[0]
		return nil, err
	}

	fc, parseErr := p.convertFunc(file, inputVariableMap)

	json := []model.Document{fc}

	var resourcesElements model.Document
	var elements model.Document
	var certInfo map[string]interface{}

	for _, documents := range json { // iterate over documents
		if documents["resource"] != nil {
			for _, resources := range documents["resource"].(model.Document) { // iterate over resources
				resourcesElements = resources.(model.Document)
				for _, v2 := range resourcesElements { // resource name
					elements = v2.(model.Document)
					for k, v3 := range elements { // resource elements
						if k == "certificate_body" {
							ok, content := additional.CheckCertificateBody(v3.(string))
							if ok {
								certInfo = additional.AddCertificateInfo(path, content)
								if certInfo != nil {
									elements["certificate_body"] = certInfo
								}
							}
						}
					}
				}
			}
		}
	}

	return json, errors.Wrap(parseErr, "failed terraform parse")
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
