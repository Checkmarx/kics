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
		return nil, nil, fmt.Errorf("error parsing bicep file on parse function: %w", err)
	}

	jElem, _ := converter.Convert(elems)

	elemListBytes, err := json.Marshal(jElem)
	if err != nil {
		return nil, nil, fmt.Errorf("error marshaling bicep file on parse function: %w", err)
	}

	err = json.Unmarshal(elemListBytes, &doc)
	if err != nil {
		return nil, nil, fmt.Errorf("error unmarshaling bicep file on parse function: %w", err)
	}

	return []model.Document{doc}, nil, nil
}

// parse the bicep file returning a list of elemBicep struct and an error
func parserBicepFile(bicepContent []byte) ([]converter.ElemBicep, error) {
	reader := bytes.NewReader(bicepContent)
	elems := []converter.ElemBicep{}
	scanner := bufio.NewScanner(reader)
	parentsStack := []converter.SuperProp{}
	decorators := map[string]interface{}{}
	tempMap := map[string]interface{}{}
	var arrayArray []interface{}
	arrayArray = nil
	tempProp := converter.Prop{}
	var absoluteParent converter.AbsoluteParent

	for scanner.Scan() {
		elem := converter.ElemBicep{}
		line := scanner.Text()

		if line == "" {
			continue
		}

		targetScope := parseTargetScope(line)
		if targetScope != "" {
			elem.TargetScope = targetScope
			elem.Type = "targetScope"
			elems = append(elems, elem)
			continue
		}

		metadata := parseMetadata(line)
		if metadata != nil {
			elem.Metadata = *metadata
			elem.Type = "metadata"
			elems = append(elems, elem)
			continue
		}

		isSecure, isAllowed := parseDecorator(decorators, line)
		if isSecure {
			fmt.Println("Is Secure?", isSecure)
		} else if isAllowed {
			absoluteParent.Allowed = decorators["allowed"].([]string)
			absoluteParent.Variable = nil
			absoluteParent.Module = nil
			absoluteParent.Resource = nil
		} else {
			fmt.Println("Is Allowed?", isAllowed)
		}

		variable, isSingle := parseVariable(line, elems)
		if variable != nil {
			if isSingle {
				elem.Variable = *variable
				elem.Type = "variable"
				elems = append(elems, elem)
			} else {
				decorators = map[string]interface{}{}
				tempMap = map[string]interface{}{}
				absoluteParent.Variable = variable
				absoluteParent.Allowed = nil
				absoluteParent.Module = nil
				absoluteParent.Resource = nil
			}
			continue
		}

		resource := parseResource(decorators, line)
		if resource != nil {
			elem.Resource = *resource
			elem.Type = "resource"

			decorators = map[string]interface{}{}
			absoluteParent.Resource = resource
			absoluteParent.Allowed = nil
			absoluteParent.Module = nil
			absoluteParent.Variable = nil
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

		inlineArray := parseInlineArray(line)
		if inlineArray != nil {
			if len(parentsStack) > 0 {
				parent := parentsStack[len(parentsStack)-1]
				var siblings converter.SuperProp
				for k := range parent {
					siblings = parent[k].(converter.SuperProp)
				}
				for k, v := range inlineArray {
					siblings[k] = v
				}
				for k := range parent {
					parent[k] = siblings
				}
			} else {
				for k, v := range inlineArray {
					tempMap[k] = v
				}
			}
			continue
		}

		isNewParentRegex := regexp.MustCompile(`\{`)
		isNewParent := len(isNewParentRegex.FindStringSubmatch(line)) > 0

		isParentClosingRegex := regexp.MustCompile(`\}`)
		isParentClosing := len(isParentClosingRegex.FindStringSubmatch(line)) > 0

		isOpeningArrayRegex := regexp.MustCompile(`\[`)
		isOpeningArray := len(isOpeningArrayRegex.FindStringSubmatch(line)) > 0

		isClosingArrayRegex := regexp.MustCompile(`\]`)
		isClosingArray := len(isClosingArrayRegex.FindStringSubmatch(line)) > 0

		if arrayArray != nil && !isClosingArray {
			arrayElementRegex := regexp.MustCompile(`^ *'?([^']*)`)
			arrayElement := arrayElementRegex.FindStringSubmatch(line)[1]
			arrayArray = append(arrayArray, arrayElement)
			continue
		}

		fmt.Println(line)

		if isClosingArray {
			if absoluteParent.Allowed != nil {
				decorators["allowed"] = arrayArray
			} else {
				currentPropertyIndex := len(parentsStack) - 1
				currentProperty := parentsStack[currentPropertyIndex]
				parentsStack = append(parentsStack[:currentPropertyIndex], parentsStack[currentPropertyIndex+1:]...)
				if len(parentsStack) > 1 {
					parent := parentsStack[len(parentsStack)-1]
					var siblings converter.SuperProp
					for k := range parent {
						siblings = parent[k].(converter.SuperProp)
					}
					for k := range currentProperty {
						siblings[k] = arrayArray
					}
					for k := range parent {
						parent[k] = siblings
					}
				} else {
					for k := range currentProperty {
						tempMap[k] = arrayArray
					}
				}
			}

			arrayArray = nil
			continue
		}

		prop := parseProp(line)

		if isOpeningArray {
			arrayArray = []interface{}{}
			newProp := converter.SuperProp{}
			var newPropValues []interface{} = nil

			for k := range prop {
				newProp[k] = newPropValues
			}

			parentsStack = append(parentsStack, newProp)
			continue
		}

		if prop != nil {
			if isNewParent {
				newProp := converter.SuperProp{}
				newPropValues := converter.SuperProp{}

				for k := range prop {
					newProp[k] = newPropValues
				}

				parentsStack = append(parentsStack, newProp)
			} else {
				if len(parentsStack) > 0 {
					parent := parentsStack[len(parentsStack)-1]
					var siblings converter.SuperProp
					for k := range parent {
						siblings = parent[k].(converter.SuperProp)
					}
					for k, v := range prop {
						siblings[k] = v
					}
					for k := range parent {
						parent[k] = siblings
					}
				} else {
					for k, v := range prop {
						tempMap[k] = v
					}
				}
			}
			continue
		}

		if isParentClosing && len(parentsStack) > 1 {
			currentPropertyIndex := len(parentsStack) - 1
			currentProperty := parentsStack[currentPropertyIndex]
			parentsStack = append(parentsStack[:currentPropertyIndex], parentsStack[currentPropertyIndex+1:]...)

			parent := parentsStack[len(parentsStack)-1]
			var siblings converter.SuperProp
			for k := range parent {
				siblings = parent[k].(converter.SuperProp)
			}
			for k, v := range currentProperty {
				siblings[k] = v
			}
			for k := range parent {
				parent[k] = siblings
			}

			continue
		}

		if isParentClosing && len(parentsStack) == 1 {
			currentPropertyIndex := len(parentsStack) - 1
			currentProperty := parentsStack[currentPropertyIndex]
			parentsStack = append(parentsStack[:currentPropertyIndex], parentsStack[currentPropertyIndex+1:]...)

			for k, v := range currentProperty {
				tempMap[k] = v
			}

			continue
		}

		if isParentClosing && len(parentsStack) == 0 {
			if absoluteParent.Resource != nil {
				tempProp.Prop = tempMap
				absoluteParent.Resource.Prop = tempMap
				elem.Resource = *absoluteParent.Resource
				elem.Type = "resource"
				elems = append(elems, elem)
				absoluteParent.Resource = nil
				tempMap = map[string]interface{}{}
			}
			if absoluteParent.Variable != nil {
				tempProp.Prop = tempMap
				absoluteParent.Variable.Prop = tempMap
				elem.Variable = *absoluteParent.Variable
				elem.Type = "variable"
				elems = append(elems, elem)
				absoluteParent.Variable = nil
				tempMap = map[string]interface{}{}
			}
			continue
		}
	}

	if err := scanner.Err(); err != nil {
		return []converter.ElemBicep{}, fmt.Errorf("error reading bicep file on parserBicepFile function: %w", err)
	}

	return elems, nil
}

func getParams(elems []converter.ElemBicep) []converter.Param {
	params := []converter.Param{}
	for _, elem := range elems {
		if elem.Type == "param" {
			params = append(params, elem.Param)
		}
	}
	return params
}

// parse targetScope syntax from bicep file
func parseTargetScope(line string) string {
	targetScopeRegex := regexp.MustCompile(`targetScope * = * *'?([^']*)'`)
	matches := targetScopeRegex.FindStringSubmatch(line)

	if matches != nil {
		targetScope := matches[1]
		return targetScope
	}

	return ""
}

// parse Variable syntax from bicep file
func parseVariable(line string, elems []converter.ElemBicep) (*converter.Variable, bool) {
	singleLineVarRegex := regexp.MustCompile(`var +([^ ]*) += +'?([^' {][^']*)'?`)
	multiLineVarRegex := regexp.MustCompile(`var +([^ ]*) += +{`)
	// forLineVarRegex := regexp.MustCompile(`for`)
	matchesSingle := singleLineVarRegex.FindStringSubmatch(line)
	matchesMulti := multiLineVarRegex.FindStringSubmatch(line)
	// matchFor := forLineVarRegex.FindStringSubmatch(line)

	if matchesSingle != nil {
		name := matchesSingle[1]
		value := matchesSingle[2]
		hasParam, paramName := checkVariableParams(value, getParams(elems))
		if hasParam {
			start := strings.Index(value, "${")
			end := strings.Index(value, "}")
			if start != -1 && end != -1 && start < end {
				// extract the middle part of the string, relative to the param on variable
				middlePart := value[start+2 : end]
				// remove middle part from value
				value = strings.Replace(value, "${"+middlePart+"}", "", 1)
				// concatenate the values from the parameter with the last part of the string, removing the middle part effectively
				value = fmt.Sprintf("parameters('%s'),%s", paramName, value)
			}
		}
		return &converter.Variable{Name: name, Value: value}, true
	}

	if matchesMulti != nil {
		name := matchesMulti[1]
		return &converter.Variable{Name: name}, false
	}

	return nil, false
}

func checkVariableParams(value string, params []converter.Param) (bool, string) {
	for _, param := range params {
		if strings.Contains(value, param.Name) {
			return true, param.Name
		}
	}
	return false, ""
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

// parse Inline Array syntax from bicep file
func parseInlineArray(line string) map[string]interface{} {
	metadataRegex := regexp.MustCompile(` *([^ :']*): *\[(?:'?([^' ]*)'?)]`)
	matches := metadataRegex.FindStringSubmatch(line)

	if matches != nil {
		name := matches[1]
		value := matches[2]

		values := []string{value}

		return map[string]interface{}{name: values}
	}

	return nil
}

// parse Decorator syntax from bicep file
func parseDecorator(decorators map[string]interface{}, line string) (bool, bool) {
	singleDecoratorRegex := regexp.MustCompile(`@(?:sys\.)?([^()]+)\('?([^')]*)'?\)`)
	// metadataDecoratorRegex := regexp.MustCompile(`^param\s+(\S+)\s+(\S+)\s+=\s+'(.+)'`)
	allowedDecoratorRegex := regexp.MustCompile(`@(?:sys\.)?allowed:?\(\[`)
	matchesSingle := singleDecoratorRegex.FindStringSubmatch(line)
	// matchesMetadata := metadataDecoratorRegex.FindStringSubmatch(line)
	matchesAllowed := allowedDecoratorRegex.FindStringSubmatch(line)

	// match single line decorators
	if matchesSingle != nil {
		name := matchesSingle[1]
		value := matchesSingle[2]

		switch name {
		case "secure":
			return true, false
		case "description":
			var description = make(map[string]interface{})
			description[name] = value
			decorators["metadata"] = map[string]interface{}{name: value}
			return false, false
		case "maxLength":
			decorators[name] = value
			return false, false
		case "minLength":
			decorators[name] = value
			return false, false
		case "maxValue":
			decorators[name] = value
			return false, false
		case "minValue":
			decorators[name] = value
			return false, false
		}
	}

	// match metadata decorators
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

	// match allowed decorators
	if matchesAllowed != nil {
		tempAllowed := []string{}

		decorators["allowed"] = tempAllowed
		return false, true
	}

	return false, false
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

func parseProp(line string) map[string]string {
	// Parse key-value pairs

	// parts := strings.SplitN(line, ":", 2)
	// if len(parts) == 2 {

	propRegex := regexp.MustCompile(`([^: ]*) *: '?([^']*)'?`)
	matches := propRegex.FindStringSubmatch(line)

	if matches != nil {
		key := strings.TrimSpace(matches[1])
		value := strings.TrimSpace(matches[2])
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
