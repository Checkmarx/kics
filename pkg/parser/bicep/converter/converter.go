package converter

import (
	"encoding/json"

	"github.com/Checkmarx/kics/pkg/model"
)

// map[string]interface{}
/*
InLineDescriptions    string `json:"singleDescriptions"`
MultiLineDescriptions string `json:"multiDescriptions"`
linesToIgnore    []int                       `json:"-"`
linesNotToIgnore []int                       `json:"-"`
*/
type JSONBicep struct {
	Scope          string                      `json:"targetScope,omitempty"`
	Func           map[string]interface{}      `json:"func,omitempty"`
	Type           map[string]Type             `json:"definitions,omitempty"`
	Params         map[string]Param            `json:"-"`
	Variables      []Variable                  `json:"variables,omitempty"`
	Resources      []Resource                  `json:"resources,omitempty"`
	Outputs        []Output                    `json:"-"`
	Modules        []Module                    `json:"modules,omitempty"`
	Metadata       map[string]string           `json:"metadata,omitempty"`
	Lines          map[string]model.LineObject `json:"_kics_lines"`
	ContentVersion string                      `json:"contentVersion"`
}

type ElemBicep struct {
	TargetScope string
	Type        string
	Param       Param
	Metadata    Metadata
	Variable    Variable
	Resource    Resource
	Output      Output
	Module      Module
}

type Decorator struct {
	Allowed   []string    `json:"allowedValues,omitempty"`
	MaxLength string      `json:"maxLength,omitempty"`
	MinLength string      `json:"minLength,omitempty"`
	MaxValue  string      `json:"maxValue,omitempty"`
	MinValue  string      `json:"minValue,omitempty"`
	Metadata  []*Property `json:"metadata,omitempty"`
}

type Metadata struct {
	Name        string `json:"name,omitempty"`
	Description string `json:"description,omitempty"`
}

type Param struct {
	Name         string                 `json:"-"`
	Type         string                 `json:"type"`
	DefaultValue string                 `json:"defaultValue"`
	Metadata     *Metadata              `json:"metadata,omitempty"`
	Decorators   map[string]interface{} `json:"decorators,omitempty"`
}

type Variable struct {
	Name  string                 `json:"-"`
	Value string                 `json:"value,omitempty"`
	Prop  map[string]interface{} `json:"prop"`
}

type Resource struct {
	APIVersion string                 `json:"apiVersion"`
	Type       string                 `json:"type"`
	Metadata   *Metadata              `json:"metadata,omitempty"`
	Prop       map[string]interface{} `json:"-"`
	Decorators map[string]interface{} `json:"-"`
}

type Output struct {
	Name       string                 `json:"-"`
	Type       string                 `json:"type"`
	Metadata   *Metadata              `json:"metadata,omitempty"`
	Value      string                 `json:"value"`
	Decorators map[string]interface{} `json:"-"`
}

type Module struct {
	Name        string                 `json:"name"`
	Path        string                 `json:"path"`
	Description string                 `json:"description"`
	Decorators  map[string]interface{} `json:"-"`
}

type Prop struct {
	Prop map[string]interface{}
}

type SuperProp map[string]interface{}

type Property struct {
	Description map[string]interface{} `json:"description,omitempty"`
	Properties  []*Property            `json:"properties,omitempty"`
}

type AbsoluteParent struct {
	Resource *Resource
	Module   *Module
	Variable *Variable
}

type Type struct {
	Name          string        `json:"-"`
	Type          string        `json:"type"`
	AllowedValues []interface{} `json:"allowedValues,omitempty"`
	Items         []interface{} `json:"items,omitempty"`
}

func newJSONBicep() *JSONBicep {
	return &JSONBicep{
		Type:      map[string]Type{},
		Scope:     "",
		Params:    map[string]Param{},
		Variables: []Variable{},
		Resources: []Resource{},
		Outputs:   []Output{},
		Modules:   []Module{},
		Metadata:  map[string]string{},
		Lines:     map[string]model.LineObject{},
	}
}

func (res *Resource) MarshalJSON() ([]byte, error) {
	resourceMap := res.Prop
	resourceMap["apiVersion"] = res.APIVersion
	resourceMap["type"] = res.Type
	resourceMap["metadata"] = res.Metadata

	return json.Marshal(resourceMap)
}

func (jsonBicep *JSONBicep) MarshalJSON() ([]byte, error) {

	outputs := map[string]map[string]interface{}{}
	params := map[string]map[string]interface{}{}
	variables := map[string]interface{}{}

	for _, output := range jsonBicep.Outputs {
		tempOutput := map[string]interface{}{}
		tempOutput["type"] = output.Type
		tempOutput["metadata"] = output.Metadata
		tempOutput["value"] = output.Value

		for decorator, value := range output.Decorators {
			if !(value == "" || value == nil) {
				tempOutput[decorator] = value
			}
		}

		tempOutput["type"] = output.Type

		outputs[output.Name] = tempOutput
	}

	for _, param := range jsonBicep.Params {
		tempParam := map[string]interface{}{}
		tempParam["type"] = param.Type
		tempParam["defaultValue"] = param.DefaultValue
		tempParam["metadata"] = param.Metadata

		for decorator, value := range param.Decorators {
			if !(value == "" || value == nil) {
				tempParam[decorator] = value
			}
		}

		params[param.Name] = tempParam
	}

	for _, variable := range jsonBicep.Variables {
		tempVar := map[string]interface{}{}
		if variable.Prop != nil {
			for prop, value := range variable.Prop {
				if !(value == "" || value == nil) {
					tempVar[prop] = value
				}
			}
			variables[variable.Name] = tempVar
		} else {
			variables[variable.Name] = variable.Value
		}
	}

	type JSONBicepAlias JSONBicep
	return json.Marshal(&struct {
		*JSONBicepAlias
		Outputs   map[string]map[string]interface{} `json:"outputs"`
		Params    map[string]map[string]interface{} `json:"parameters"`
		Variables map[string]interface{}            `json:"variables"`
	}{
		JSONBicepAlias: (*JSONBicepAlias)(jsonBicep),
		Variables:      variables,
		Outputs:        outputs,
		Params:         params,
	})
}

// Convert - converts Bicep file to JSON Bicep template
func Convert(elems []ElemBicep) (file *JSONBicep, err error) {
	var jBicep = newJSONBicep()

	metadata := map[string]string{}
	resources := []Resource{}
	outputs := []Output{}
	params := map[string]Param{}
	variables := []Variable{}
	var targetScope string

	for _, elem := range elems {
		if elem.Type == "resource" {
			resources = append(resources, elem.Resource)
		}
		if elem.Type == "param" {
			params[elem.Param.Name] = elem.Param
		}
		if elem.Type == "output" {
			outputs = append(outputs, elem.Output)
		}
		if elem.Type == "metadata" {
			metadata[elem.Metadata.Name] = elem.Metadata.Description
		}
		if elem.Type == "variable" {
			variables = append(variables, elem.Variable)
		}
		if elem.Type == "targetScope" {
			targetScope = elem.TargetScope
		}
	}

	jBicep.Resources = resources
	jBicep.Params = params
	jBicep.Outputs = outputs
	jBicep.Metadata = metadata
	jBicep.Variables = variables
	jBicep.Scope = targetScope

	return jBicep, nil
}

// const kicsLinesKey = "_kics_"
