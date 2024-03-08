package bicep

import (
	"bufio"
	"bytes"
	"encoding/json"
	"regexp"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/parser/bicep/converter"
)

// Parser - parser for Bicep files
type Parser struct {
}

// Parse - parses bicep to JSON_Bicep template (json file)
func (p *Parser) Parse(_ string, fileContent []byte) ([]model.Document, []int, error) {

	doc := model.Document{}
	elems, err := parserBicepFile(fileContent)
	if err != nil {
		return nil, nil, err
	}

	jElem, _ := converter.Convert(elems)

	elemListBytes, err := json.Marshal(jElem)
	if err != nil {
		return nil, nil, err
	}

	err = json.Unmarshal(elemListBytes, &doc)
	if err != nil {
		return nil, nil, err
	}

	return []model.Document{doc}, nil, nil
}

// parse the bicep file returning a list of elemBicep struct and an error
func parserBicepFile(bicepContent []byte) ([]converter.ElemBicep, error) {

	reader := bytes.NewReader(bicepContent)
	elems := []converter.ElemBicep{}
	scanner := bufio.NewScanner(reader)

	for scanner.Scan() {
		elem := converter.ElemBicep{}
		line := scanner.Text()

		if line == "" {
			continue
		}

		resource := parseResource(line)
		if resource != nil {
			elem.Resource = *resource
			elem.Type = "resource"
			elems = append(elems, elem)
			continue
		}

		param := parseParam(line)
		if param != nil {
			elem.Param = *param
			elem.Type = "param"
			elems = append(elems, elem)
			continue
		}

	}

	if err := scanner.Err(); err != nil {
		return []converter.ElemBicep{}, err
	}

	return elems, nil
}

// parse Resource syntax from bicep file
func parseResource(line string) *converter.Resource {

	resourceRegex := regexp.MustCompile(`^resource\s+(\S+)\s+'(\S+)'\s+=\s+\{\s*`)
	matches := resourceRegex.FindStringSubmatch(line)
	if matches != nil {
		resourceType := strings.Split(matches[2], "@")[0]
		resourceType = strings.ReplaceAll(resourceType, "'", "")
		resourceName := matches[1]

		apiVersion := ""
		apiVersionRegex := regexp.MustCompile(`@(\S+)`)
		apiMatches := apiVersionRegex.FindStringSubmatch(matches[2])
		if len(apiMatches) > 1 {
			apiVersion = apiMatches[1]
		}
		return &converter.Resource{
			APIVersion: apiVersion,
			Kind:       "StorageV2",
			Location:   "westus",
			Name:       resourceName,
			Type:       resourceType,
			Metadata:   &converter.Metadata{Description: "Description", Name: "test"},
		}
	}

	return nil
}

// parse Param syntax from bicep file
func parseParam(line string) *converter.Param {

	paramRegex := regexp.MustCompile(`^param\s+(\S+)\s+(\S+)\s+=\s+'(.+)'`)
	matches := paramRegex.FindStringSubmatch(line)
	if matches != nil {
		paramName := matches[1]
		paramType := matches[2]
		paramDefaultValue := matches[3]
		return &converter.Param{
			Name:         paramName,
			Type:         paramType,
			DefaultValue: paramDefaultValue,
			Metadata:     &converter.Metadata{Description: "Description", Name: "test"},
		}
	}

	return nil
}

// GetKind returns the kind of the parser
func (p *Parser) GetKind() model.FileKind {
	return model.KindBICEP
}

// SupportedExtensions returns Bicep extensions
func (p *Parser) SupportedExtensions() []string {
	return []string{".bicep"}
}

// SupportedTypes returns types supported by this parser, which are bicep files
func (p *Parser) SupportedTypes() map[string]bool {
	return map[string]bool{"bicep": true, "azureresourcemanager": true}
}

// GetCommentToken return the comment token of Bicep files - #
func (p *Parser) GetCommentToken() string {
	return "//"
}

// StringifyContent converts original content into string formatted version
func (p *Parser) StringifyContent(content []byte) (string, error) {
	return string(content), nil
}

// Resolve resolves bicep files variables
func (p *Parser) Resolve(fileContent []byte, _ string, _ bool) ([]byte, error) {
	return fileContent, nil
}

// GetResolvedFiles returns the list of files that are resolved
func (p *Parser) GetResolvedFiles() map[string]model.ResolvedFile {
	return make(map[string]model.ResolvedFile)
}
