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
	Params         map[string]Param            `json:"parameters,omitempty"`
	Variables      []Variable                  `json:"variables,omitempty"`
	Resources      []Resource                  `json:"resources,omitempty"`
	Outputs        map[string]Output           `json:"outputs,omitempty"`
	Modules        []Module                    `json:"modules,omitempty"`
	Metadata       map[string]string           `json:"metadata,omitempty"`
	Lines          map[string]model.LineObject `json:"_kics_lines"`
	ContentVersion string                      `json:"contentVersion"`
}

func (res *Resource) MarshalJSON() ([]byte, error) {
	resourceMap := res.Prop
	resourceMap["apiVersion"] = res.APIVersion
	resourceMap["type"] = res.Type
	resourceMap["metadata"] = res.Metadata

	return json.Marshal(resourceMap)
}

type ElemBicep struct {
	Type     string
	Param    Param
	Metadata Metadata
	Variable Variable
	Resource Resource
	Output   Output
	Module   Module
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
	Name        string `json:"name"`
	Type        string `json:"type"`
	Description string `json:"description"`
}

type Resource struct {
	APIVersion string    `json:"apiVersion"`
	Type       string    `json:"type"`
	Metadata   *Metadata `json:"metadata,omitempty"`
	// Properties []Property   `json:"properties"`
	Prop       map[string]interface{} `json:"-"`
	Decorators map[string]interface{} `json:"-"`
}

type Prop struct {
	Prop map[string]interface{}
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

type SuperProp map[string]interface{}

type Property struct {
	Description map[string]interface{} `json:"description,omitempty"`
	Properties  []*Property            `json:"properties,omitempty"`
}

type AbsoluteParent struct {
	Resource *Resource
	Module   *Module
}

func newJSONBicep() *JSONBicep {
	return &JSONBicep{
		Params:         map[string]Param{},
		Variables:      []Variable{},
		Resources:      []Resource{},
		Outputs:        map[string]Output{},
		Modules:        []Module{},
		Metadata:       map[string]string{},
		Lines:          map[string]model.LineObject{},
		ContentVersion: "1.0.0.0",
	}
}

// Convert - converts Bicep file to JSON Bicep template
func Convert(elems []ElemBicep) (file *JSONBicep, err error) {
	var jBicep = newJSONBicep()

	metadata := map[string]string{}
	resources := []Resource{}
	outputs := map[string]Output{}
	params := map[string]Param{}
	//outputs := map[string]Output{}

	for _, elem := range elems {
		if elem.Type == "resource" {
			resources = append(resources, elem.Resource)
		}
		if elem.Type == "param" {
			params[elem.Param.Name] = elem.Param
		}
		if elem.Type == "output" {
			outputs[elem.Output.Name] = elem.Output
		}
		if elem.Type == "metadata" {
			metadata[elem.Metadata.Name] = elem.Metadata.Description
		}
	}

	jBicep.Resources = resources
	jBicep.Params = params
	jBicep.Outputs = outputs
	jBicep.Metadata = metadata

	return jBicep, nil
}

// const kicsLinesKey = "_kics_"
