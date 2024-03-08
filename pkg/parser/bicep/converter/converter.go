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
	Outputs        Output                      `json:"outputs"`
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

type Metadata struct {
	Description string `json:"description,omitempty"`
	Name        string `json:"name,omitempty"`
}

type Param struct {
	Name         string    `json:"name"`
	Type         string    `json:"type"`
	DefaultValue string    `json:"defaultValue"`
	Metadata     *Metadata `json:"metadata"`
}

type Variable struct {
	Name        string `json:"name"`
	Type        string `json:"type"`
	Description string `json:"description"`
}

type Resource struct {
	APIVersion string     `json:"apiVersion"`
	Type       string     `json:"type"`
	Metadata   *Metadata  `json:"metadata"`
	Properties []Property `json:"properties"`
}

type Output struct {
	Type     string    `json:"type"`
	Metadata *Metadata `json:"metadata"`
	Value    string    `json:"value"`
}

type Module struct {
	Name        string `json:"name"`
	Path        string `json:"path"`
	Description string `json:"description"`
}

type Property struct {
	Name       string
	Value      interface{}
	Properties []*Property
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
		Outputs:        Output{},
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
	param := []Param{}

	for _, elem := range elems {
		if elem.Type == "resource" {
			resources = append(resources, elem.Resource)
		}
		if elem.Type == "param" && elem.Param.Name != "" {
			param = append(param, elem.Param)
		}
	}

	jBicep.Resources = resources
	jBicep.Param = param

	return jBicep, nil
}

// const kicsLinesKey = "_kics_"
