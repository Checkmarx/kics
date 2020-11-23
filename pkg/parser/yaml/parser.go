package json

import (
	"bytes"

	"github.com/Checkmarx/kics/pkg/model"
	"gopkg.in/yaml.v3"
)

type Parser struct {
}

func (p *Parser) Parse(_ string, fileContent []byte) ([]model.Document, error) {
	var documents []model.Document
	dec := yaml.NewDecoder(bytes.NewReader(fileContent))

	doc := &model.Document{}
	for dec.Decode(doc) == nil {
		if doc != nil {
			documents = append(documents, *doc)
		}
		doc = &model.Document{}
	}

	return documents, nil
}

func (p *Parser) SupportedExtensions() []string {
	return []string{".yaml", ".yml"}
}

func (p *Parser) GetKind() model.FileKind {
	return model.KindYAML
}
