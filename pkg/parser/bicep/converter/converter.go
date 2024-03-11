package converter

import (
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
	Param          []Param                     `json:"parameters"`
	Variables      []Variable                  `json:"variables"`
	Resources      []Resource                  `json:"resources"`
	Outputs        []Output                    `json:"outputs"`
	Modules        []Module                    `json:"modules"`
	Metadata       *Metadata                   `json:"metadata"`
	Lines          map[string]model.LineObject `json:"_kics_lines"`
	ContentVersion string                      `json:"contentVersion"`
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
	Description string `json:"description,omitempty"`
	Name        string `json:"name,omitempty"`
}

type Param struct {
	Name         string       `json:"name"`
	Type         string       `json:"type"`
	DefaultValue string       `json:"defaultValue"`
	Metadata     *Metadata    `json:"metadata"`
	Decorator    []*Decorator `json:"decorators,omitempty"`
}

type Variable struct {
	Name        string `json:"name"`
	Type        string `json:"type"`
	Description string `json:"description"`
}

type Resource struct {
	APIVersion string       `json:"apiVersion"`
	Type       string       `json:"type"`
	Metadata   *Metadata    `json:"metadata"`
	Properties []Property   `json:"properties"`
	Decorator  []*Decorator `json:"decorators,omitempty"`
}

type Output struct {
	Name      string       `json:"name"`
	Type      string       `json:"type"`
	Metadata  *Metadata    `json:"metadata"`
	Value     string       `json:"value"`
	Decorator []*Decorator `json:"decorators,omitempty"`
}

type Module struct {
	Name        string       `json:"name"`
	Path        string       `json:"path"`
	Description string       `json:"description"`
	Decorator   []*Decorator `json:"decorators,omitempty"`
}

type Property struct {
	Description map[string]interface{} `json:"description,omitempty"`
	Properties []*Property `json:"properties,omitempty"`
}

type AbsoluteParent struct {
	Resource *Resource
	Module   *Module
}

func newJSONBicep() *JSONBicep {
	return &JSONBicep{
		Param:          []Param{},
		Variables:      []Variable{},
		Resources:      []Resource{},
		Outputs:        []Output{},
		Modules:        []Module{},
		Metadata:       &Metadata{},
		Lines:          map[string]model.LineObject{},
		ContentVersion: "1.0.0.0",
	}
}

// Convert - converts Bicep file to JSON Bicep template
func Convert(elems []ElemBicep) (file *JSONBicep, err error) {
	var jBicep = newJSONBicep()

	resources := []Resource{}
	params := []Param{}
	outputs := []Output{}

	for _, elem := range elems {
		if elem.Type == "resource" {
			resources = append(resources, elem.Resource)
		}
		if elem.Type == "param" {
			params = append(params, elem.Param)
		}
		if elem.Type == "output" {
			outputs = append(outputs, elem.Output)
		}
	}

	jBicep.Resources = resources
	jBicep.Param = params
	jBicep.Outputs = outputs

	return jBicep, nil
}

// const kicsLinesKey = "_kics_"
