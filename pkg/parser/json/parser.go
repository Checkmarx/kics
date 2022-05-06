package json

import (
	"bytes"
	"encoding/json"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/mailru/easyjson"
)

// Parser defines a parser type
type Parser struct {
	shouldIdent bool
}

// Resolve - replace or modifies in-memory content before parsing
func (p *Parser) Resolve(fileContent []byte, filename string) (*[]byte, error) {
	return &fileContent, nil
}

// Parse parses json file and returns it as a Document
func (p *Parser) Parse(_ string, fileContent []byte) ([]model.Document, []int, error) {
	r := model.Document{}
	err := easyjson.Unmarshal(fileContent, &r)
	if err != nil {
		r := []model.Document{}
		err = json.Unmarshal(fileContent, &r)
		return r, []int{}, err
	}

	jLine := initializeJSONLine(fileContent)
	kicsJSON := jLine.setLineInfo(r)

	// Try to parse JSON as Terraform plan
	kicsPlan, err := parseTFPlan(kicsJSON)
	if err != nil {
		// JSON is not a tf plan
		return []model.Document{kicsJSON}, []int{}, nil
	}

	p.shouldIdent = true

	return []model.Document{kicsPlan}, []int{}, nil
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
func (p *Parser) SupportedTypes() map[string]bool {
	return map[string]bool{"cloudformation": true, "openapi": true, "azureresourcemanager": true, "terraform": true, "kubernetes": true}
}

// GetCommentToken return an empty string, since JSON does not have comment token
func (p *Parser) GetCommentToken() string {
	return ""
}

// StringifyContent converts original content into string formated version
func (p *Parser) StringifyContent(content []byte) (string, error) {
	if p.shouldIdent {
		var out bytes.Buffer
		err := json.Indent(&out, content, "", "  ")
		if err != nil {
			return "", err
		}
		return out.String(), nil
	}
	return string(content), nil
}
