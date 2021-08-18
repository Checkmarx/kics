package json

import (
	"encoding/json"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/pkg/errors"
)

// Parser defines a parser type
type Parser struct {
}

// var (
// 	jsonKey = regexp.MustCompile(`"(.*?)"`)
// )

// Resolve - replace or modifies in-memory content before parsing
func (p *Parser) Resolve(fileContent []byte, filename string) (*[]byte, error) {
	return &fileContent, nil
}

// Parse parses json file and returns it as a Document
func (p *Parser) Parse(_ string, fileContent []byte) ([]model.Document, error) {
	r := model.Document{}
	err := json.Unmarshal(fileContent, &r)
	if err != nil {
		r := []model.Document{}
		err = json.Unmarshal(fileContent, &r)
		return r, err
	}

	jLine := initiateJSONLine(fileContent)
	dd := jLine.setLineInfo(r)

	return []model.Document{dd}, errors.Wrap(err, "failed to unmarshall json content")
}

// SupportedExtensions returns extensions supported by this parser, which is json extension
func (p *Parser) SupportedExtensions() []string {
	return []string{".json"}
}

// GetKind returns JSON constant kind
func (p *Parser) GetKind() model.FileKind {
	return model.KindJSON
}

// SupportedTypes returns types supported by this parser, which are cloudFormation
func (p *Parser) SupportedTypes() []string {
	return []string{"CloudFormation", "OpenAPI", "AzureResourceManager"}
}

// GetCommentToken return an empty string, since JSON does not have comment token
func (p *Parser) GetCommentToken() string {
	return ""
}
