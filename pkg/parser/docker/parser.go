package docker

import (
	"bytes"
	"encoding/json"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/asottile/dockerfile"
	"github.com/pkg/errors"
)

// Parser is a Dockerfile parser
type Parser struct {
}

// Resource Separates the list of commands by file
type Resource struct {
	CommandList []dockerfile.Command `json:"resource"`
}

// Parse - parses dockerfile to Json
func (p *Parser) Parse(_ string, fileContent []byte) ([]model.Document, error) {
	var documents []model.Document
	com, err := dockerfile.ParseReader(bytes.NewReader(fileContent))
	if err != nil {
		return nil, errors.Wrap(err, "Failed to parse Dockerfile")
	}

	doc := &model.Document{}

	var resource Resource
	resource.CommandList = com

	j, err := json.Marshal(resource)
	if err != nil {
		return nil, errors.Wrap(err, "Failed to Marshal Dockerfile")
	}

	if err := json.Unmarshal(j, &doc); err != nil {
		return nil, errors.Wrap(err, "Failed to Unmarshal Dockerfile")
	}

	documents = append(documents, *doc)

	return documents, nil
}

// GetKind returns the kind of the parser
func (p *Parser) GetKind() model.FileKind {
	return model.KindDOCKER
}

// SupportedExtensions returns Dockerfile extensions
func (p *Parser) SupportedExtensions() []string {
	return []string{"Dockerfile", ".dockerfile"}
}
