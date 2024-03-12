package bicep

import (
	"bufio"
	"bytes"
	"encoding/json"
	"fmt"
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
	parentsStack := []converter.Property{}
	decorators := map[string]interface{}{}
	tempMap := map[string]string{}
	tempProp := converter.Prop{}
	var absoluteParent converter.AbsoluteParent

	for scanner.Scan() {
		elem := converter.ElemBicep{}
		line := scanner.Text()

		if line == "" {
			continue
		}

		metadata := parseMetadata(line)
		if metadata != nil {
			elem.Metadata = *metadata
			elem.Type = "metadata"
			elems = append(elems, elem)
			continue
		}

		isSecure := parseDecorator(decorators, line)
		if isSecure {
			fmt.Println("Is Secure?", isSecure)
		}

		resource := parseResource(decorators, line)
		if resource != nil {
			elem.Resource = *resource
			elem.Type = "resource"

			decorators = map[string]interface{}{}
			absoluteParent.Resource = resource
			absoluteParent.Module = nil
			continue
		}

		param := parseParam(decorators, line)
		if param != nil {
			decorators = map[string]interface{}{}
			elem.Param = *param
			elem.Type = "param"
			elems = append(elems, elem)
			continue
		}

		output := parseOutput(decorators, line)
		if output != nil {
			decorators = map[string]interface{}{}
			elem.Output = *output
			elem.Type = "output"
			elems = append(elems, elem)
			continue
		}

		isNewParentRegex := regexp.MustCompile(`\{`)
		isNewParent := len(isNewParentRegex.FindStringSubmatch(line)) > 0

		isParentClosingRegex := regexp.MustCompile(`\}`)
		isParentClosing := len(isParentClosingRegex.FindStringSubmatch(line)) > 0

		property := parseProperty(line)
		prop := parseProp(line)

		if prop != nil {
			if isNewParent {
				parentsStack = append(parentsStack, *property)
			} else {
				for k, v := range prop {
					tempMap[k] = v
				}
			}
			continue
		}

		if isParentClosing && len(parentsStack) > 0 {
			currentPropertyIndex := len(parentsStack) - 1
			currentProperty := parentsStack[currentPropertyIndex]
			parentsStack = append(parentsStack[:currentPropertyIndex], parentsStack[currentPropertyIndex+1:]...)
			propertyParent := parentsStack[len(parentsStack)-1]
			propertyParent.Properties = append(propertyParent.Properties, &currentProperty)
		}

		if isParentClosing && len(parentsStack) == 0 {
			if absoluteParent.Resource != nil {
				tempProp.Prop = tempMap
				absoluteParent.Resource.Prop = tempMap
				elem.Resource = *absoluteParent.Resource
				elem.Type = "resource"
				elems = append(elems, elem)
				absoluteParent.Resource = nil
			}
			continue
		}
	}

	if err := scanner.Err(); err != nil {
		return []converter.ElemBicep{}, err
	}

	return elems, nil
}

// parse Metadata syntax from bicep file
func parseMetadata(line string) *converter.Metadata {
	metadataRegex := regexp.MustCompile(`metadata ([^ ]*) * = *'?([^']*)'`)
	matches := metadataRegex.FindStringSubmatch(line)

	if matches != nil {
		name := matches[1]
		value := matches[2]
		return &converter.Metadata{Name: name, Description: value}
	}

	return nil
}

// parse Decorator syntax from bicep file
func parseDecorator(decorators map[string]interface{}, line string) bool {
	singleDecoratorRegex := regexp.MustCompile(`@(?:sys\.)?([^()]+)\('?([^')]*)'?\)`)
	// metadataDecoratorRegex := regexp.MustCompile(`^param\s+(\S+)\s+(\S+)\s+=\s+'(.+)'`)
	// allowedDecoratorRegex := regexp.MustCompile(`^param\s+(\S+)\s+(\S+)\s+=\s+'(.+)'`)
	matchesSingle := singleDecoratorRegex.FindStringSubmatch(line)
	// matchesMetadata := metadataDecoratorRegex.FindStringSubmatch(line)
	// matchesAllowed := allowedDecoratorRegex.FindStringSubmatch(line)

	// match single line decorators
	if matchesSingle != nil {
		name := matchesSingle[1]
		value := matchesSingle[2]

		switch name {
		case "secure":
			return true
		case "description":
			var description = make(map[string]interface{})
			description[name] = value
			//property := converter.Property{Description: description, Properties: []*converter.Property{}}
			decorators["metadata"] = map[string]interface{}{name: value}
			return false
		case "maxLength":
			decorators[name] = value
			return false
		case "minLength":
			decorators[name] = value
			return false
		case "maxValue":
			decorators[name] = value
			return false
		case "minValue":
			decorators[name] = value
			return false
		}
	}

	// // match metadata decorators
	// if matchesMetadata != nil {

	// 	return &converter.Decorator{
	// 		Allowed:   []string{},
	// 		MaxLength: "",
	// 		MinLength: "",
	// 		MaxValue:  "",
	// 		MinValue:  "",
	// 		Metadata:  nil,
	// 	}, false
	// }

	// // match allowed decorators
	// if matchesAllowed != nil {

	// 	return &converter.Decorator{
	// 		Allowed:   []string{},
	// 		MaxLength: "",
	// 		MinLength: "",
	// 		MaxValue:  "",
	// 		MinValue:  "",
	// 		Metadata:  nil,
	// 	}, false
	// }

	return false
}

// parse Resource syntax from bicep file
func parseResource(decorators map[string]interface{}, line string) *converter.Resource {
	resourceRegex := regexp.MustCompile(`^resource\s+(\S+)\s+'(\S+)'\s+=\s+\{\s*`)

	matches := resourceRegex.FindStringSubmatch(line)
	if matches != nil {
		resourceType := strings.Split(matches[2], "@")[0]
		resourceType = strings.ReplaceAll(resourceType, "'", "")

		apiVersion := ""
		apiVersionRegex := regexp.MustCompile(`@(\S+)`)
		apiMatches := apiVersionRegex.FindStringSubmatch(matches[2])
		if len(apiMatches) > 1 {
			apiVersion = apiMatches[1]
		}

		return &converter.Resource{
			APIVersion: apiVersion,
			Type:       resourceType,
			Decorators: decorators,
			// Metadata:   &converter.Metadata{Description: "Description", Name: "test"},
		}
	}

	return nil
}

// parse Param syntax from bicep file
func parseParam(decorators map[string]interface{}, line string) *converter.Param {
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
			Decorators:   decorators,
			// Metadata:     &converter.Metadata{Description: "Description", Name: "test"},
		}
	}

	return nil
}

// parse Output syntax from bicep file
func parseOutput(decorators map[string]interface{}, line string) *converter.Output {

	outputRegex := regexp.MustCompile(`^output\s+(\S+)\s+(\S+)\s+=\s+'(.+)'`)
	matches := outputRegex.FindStringSubmatch(line)
	if matches != nil {
		outputName := matches[1]
		outputType := matches[2]
		outputValue := matches[3]

		return &converter.Output{
			Name:       outputName,
			Type:       outputType,
			Value:      outputValue,
			Decorators: decorators,
			// Metadata:   &converter.Metadata{Description: "Description", Name: "test"},
		}
	}

	return nil
}

func parseProperty(line string) *converter.Property {
	// Parse key-value pairs
	parts := strings.SplitN(line, ":", 2)
	if len(parts) == 2 {
		key := strings.TrimSpace(parts[0])
		value := strings.TrimSpace(parts[1])
		var description = make(map[string]interface{})
		description[key] = value
		tempProperty := converter.Property{Description: description, Properties: []*converter.Property{}}
		return &tempProperty
	}

	return nil
}

func parseProp(line string) map[string]string {
	// Parse key-value pairs
	parts := strings.SplitN(line, ":", 2)
	if len(parts) == 2 {
		key := strings.TrimSpace(parts[0])
		value := strings.TrimSpace(parts[1])
		var description = make(map[string]string)
		description[key] = value
		return description
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
