package json

import (
	"bytes"
	"encoding/json"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/parser/additional"
	"github.com/pkg/errors"
	"gopkg.in/yaml.v3"
)

// Parser defines a parser type
type Parser struct {
}

// Playbooks represents a playbook object from parsed yaml files
type Playbooks struct {
	Tasks []map[string]interface{} `json:"playbooks"`
}

// Resolve - replace or modifies in-memory content before parsing
func (p *Parser) Resolve(fileContent []byte, filename string) (*[]byte, error) {
	return &fileContent, nil
}

// Parse parses yaml/yml file and returns it as a Document
func (p *Parser) Parse(filePath string, fileContent []byte) ([]model.Document, error) {
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
		documents, err = playbookParser(filePath, fileContent)
		if err != nil {
			return nil, errors.Wrap(err, "failed to Parse YAML")
		}
		if documents == nil {
			return nil, errors.Wrap(errors.New("invalid yaml"), "failed to parse yaml")
		}
	}

	return documents, nil
}

// SupportedExtensions returns extensions supported by this parser, which are yaml and yml extension
func (p *Parser) SupportedExtensions() []string {
	return []string{".yaml", ".yml"}
}

// SupportedTypes returns types supported by this parser, which are ansible, cloudFormation, k8s
func (p *Parser) SupportedTypes() []string {
	return []string{"Ansible", "CloudFormation", "Kubernetes", "OpenAPI"}
}

// GetKind returns YAML constant kind
func (p *Parser) GetKind() model.FileKind {
	return model.KindYAML
}

func addExtraInfo(documents []model.Document, filePath string) []model.Document {
	var elements map[string]interface{}
	var certInfo map[string]interface{}
	var swaggerInfo map[string]interface{}

	for _, documentPlaybooks := range documents { // iterate over documents
		for _, resources := range documentPlaybooks["playbooks"].([]interface{}) { // iterate over playbooks
			for _, v := range resources.(map[string]interface{}) {
				_, ok := v.(map[string]interface{})
				if ok {
					elements = v.(map[string]interface{})
					if elements["certificate"] != nil {
						content := additional.CheckCertificate(elements["certificate"].(string))
						if content != "" {
							certInfo = additional.AddCertificateInfo(filePath, content)
							if certInfo != nil {
								elements["certificate"] = certInfo
							}
						}
					}
					if elements["swagger_file"] != nil {
						swaggerInfo = additional.AddSwaggerInfo(filePath, elements["swagger_file"].(string))
						if swaggerInfo != nil {
							elements["swagger_file"] = swaggerInfo
						}
					}
				}
			}
		}
	}

	return documents
}

func playbookParser(filePath string, fileContent []byte) ([]model.Document, error) {
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
				return nil, errors.Wrap(err, "failed to Marshal YAML")
			}

			if err := json.Unmarshal(j, &doc); err != nil {
				return nil, errors.Wrap(err, "failed to Unmarshal YAML")
			}
			documents = append(documents, *doc)
		}
		doc = &model.Document{}
		arr = make([]map[string]interface{}, 0)
	}

	return addExtraInfo(documents, filePath), nil
}
