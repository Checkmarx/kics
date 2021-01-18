package json

import (
	"bytes"
	"encoding/json"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/pkg/errors"
	"gopkg.in/yaml.v3"
)

type Parser struct {
}

type Playbooks struct {
	Tasks []map[string]interface{} `json:"playbooks"`
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

	if documents == nil {
		var err error
		documents, err = playbookParser(fileContent)
		if err != nil {
			return nil, errors.Wrap(err, "Failed to Parse Yaml")
		}
	}

	return documents, nil
}

func (p *Parser) SupportedExtensions() []string {
	return []string{".yaml", ".yml"}
}

func (p *Parser) GetKind() model.FileKind {
	return model.KindYAML
}

func playbookParser(fileContent []byte) ([]model.Document, error) {
	doc := &model.Document{}
	dec := yaml.NewDecoder(bytes.NewReader(fileContent))
	arr := make([]map[string]interface{}, 0)
	var playBooks Playbooks
	var documents []model.Document
	for dec.Decode(&arr) == nil {
		if doc != nil {
			playBooks.Tasks = append(playBooks.Tasks, arr...)
			j, err := json.Marshal(playBooks)
			if err != nil {
				return nil, errors.Wrap(err, "Failed to Marshal Yaml")
			}

			if err := json.Unmarshal(j, &doc); err != nil {
				return nil, errors.Wrap(err, "Failed to Unmarshal Yaml")
			}
			documents = append(documents, *doc)
		}
		doc = &model.Document{}
		arr = make([]map[string]interface{}, 0)
	}

	return documents, nil
}
