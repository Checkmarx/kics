package json

import (
	"bytes"

	"github.com/Checkmarx/kics/v2/pkg/parser/utils"

	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
	"gopkg.in/yaml.v3"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/resolver/file"
)

// Parser defines a parser type
type Parser struct {
	resolvedFiles map[string]model.ResolvedFile
}

// Resolve - replace or modifies in-memory content before parsing
func (p *Parser) Resolve(fileContent []byte, filename string, resolveReferences bool, maxResolverDepth int) ([]byte, error) {
	// Resolve files passed as arguments with file resolver (e.g. file://)
	res := file.NewResolver(yaml.Unmarshal, yaml.Marshal, p.SupportedExtensions())
	initialResolvingStatus := file.ResolvingStatus{
		CurrentDepth:       0,
		MaxDepth:           maxResolverDepth,
		ResolvedFilesCache: make(map[string]file.ResolvedFile),
		ResolveReferences:  resolveReferences,
	}
	resolved, _ := res.Resolve(fileContent, filename, initialResolvingStatus)
	p.resolvedFiles = res.ResolvedFiles
	if len(res.ResolvedFiles) == 0 {
		return fileContent, nil
	}

	return resolved, nil
}

// Parse parses yaml/yml file and returns it as a Document
func (p *Parser) Parse(filePath string, fileContent []byte) ([]model.Document, []int, error) {
	model.NewIgnore.Reset()
	var documents []model.Document
	dec := yaml.NewDecoder(bytes.NewReader(fileContent))

	doc := emptyDocument()
	for dec.Decode(doc) == nil {
		if len(*doc) > 0 {
			documents = append(documents, *doc)
		}

		doc = emptyDocument()
	}

	if len(documents) == 0 {
		return nil, []int{}, errors.Wrap(errors.New("invalid yaml"), "failed to parse yaml")
	}

	linesToIgnore := model.NewIgnore.GetLines()

	return convertKeysToString(addExtraInfo(documents, filePath)), linesToIgnore, nil
}

// convertKeysToString goes through every document to convert map[interface{}]interface{}
// to map[string]interface{}
func convertKeysToString(docs []model.Document) []model.Document {
	documents := make([]model.Document, 0, len(docs))
	for _, doc := range docs {
		for key, value := range doc {
			doc[key] = convert(value)
		}
		documents = append(documents, doc)
	}
	return documents
}

// convert goes recursively through the keys in the given value and converts nested maps type of map[interface{}]interface{}
// to map[string]interface{}
func convert(value interface{}) interface{} {
	switch t := value.(type) {
	case map[interface{}]interface{}:
		mapStr := map[string]interface{}{}
		for key, val := range t {
			if t, ok := key.(string); ok {
				mapStr[t] = convert(val)
			}
		}
		return mapStr
	case []interface{}:
		for key, val := range t {
			t[key] = convert(val)
		}
	case model.Document:
		for key, val := range t {
			t[key] = convert(val)
		}
	}
	return value
}

// SupportedExtensions returns extensions supported by this parser, which are yaml and yml extension
func (p *Parser) SupportedExtensions() []string {
	return []string{".yaml", ".yml"}
}

// SupportedTypes returns types supported by this parser, which are ansible, cloudFormation, k8s
func (p *Parser) SupportedTypes() map[string]bool {
	return map[string]bool{
		"ansible":                 true,
		"cloudformation":          true,
		"kubernetes":              true,
		"crossplane":              true,
		"knative":                 true,
		"openapi":                 true,
		"googledeploymentmanager": true,
		"dockercompose":           true,
		"pulumi":                  true,
		"serverlessfw":            true,
		"cicd":                    true,
	}
}

// GetKind returns YAML constant kind
func (p *Parser) GetKind() model.FileKind {
	return model.KindYAML
}

func processCertContent(elements map[string]interface{}, content, filePath string) {
	var certInfo map[string]interface{}
	if content != "" {
		certInfo = utils.AddCertificateInfo(filePath, content)
		if certInfo != nil {
			elements["certificate"] = certInfo
		}
	}
}

func processElements(elements map[string]interface{}, filePath string) {
	if elements["certificate"] != nil {
		certificate, ok := elements["certificate"].(string)
		if !ok {
			log.Warn().Msgf("Failed to parse certificate: %s", filePath)
			return
		}
		processCertContent(elements, utils.CheckCertificate(certificate), filePath)
	}
}

func addExtraInfo(documents []model.Document, filePath string) []model.Document {
	for _, documentPlaybooks := range documents { // iterate over documents
		if playbooks, ok := documentPlaybooks["playbooks"]; ok {
			processPlaybooks(playbooks, filePath)
		}
	}

	return documents
}

func processPlaybooks(playbooks interface{}, filePath string) {
	sliceResources, ok := playbooks.([]interface{})
	if !ok { // prevent panic if playbooks is not a slice
		log.Warn().Msgf("Failed to parse playbooks: %s", filePath)
		return
	}
	for _, resources := range sliceResources { // iterate over playbooks
		processPlaybooksElements(resources, filePath)
	}
}

func processPlaybooksElements(resources interface{}, filePath string) {
	mapResources, ok := resources.(map[string]interface{})
	if !ok {
		log.Warn().Msgf("Failed to parse playbooks elements: %s", filePath)
		return
	}
	for _, value := range mapResources {
		mapValue, ok := value.(map[string]interface{})
		if !ok {
			continue
		}
		processElements(mapValue, filePath)
	}
}

// GetCommentToken return the comment token of YAML - #
func (p *Parser) GetCommentToken() string {
	return "#"
}

// StringifyContent converts original content into string formatted version
func (p *Parser) StringifyContent(content []byte) (string, error) {
	return string(content), nil
}

func emptyDocument() *model.Document {
	return &model.Document{}
}

// GetResolvedFiles returns resolved files
func (p *Parser) GetResolvedFiles() map[string]model.ResolvedFile {
	return p.resolvedFiles
}
