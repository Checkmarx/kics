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
	Param          []Param                     `json:"param"`
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
	Name         string    `json:"paramName"`
	Type         string    `json:"paramType"`
	DefaultValue string    `json:"paramDefaultValue"`
	Metadata     *Metadata `json:"paramMetadata"`
}

type Variable struct {
	Name        string `json:"varName"`
	Type        string `json:"varType"`
	Description string `json:"varDescription"`
}

type Property struct {
}

type Resource struct {
	APIVersion string    `json:"apiVersion"`
	Kind       string    `json:"kind"`
	Location   string    `json:"location"`
	Name       string    `json:"name"`
	Type       string    `json:"type"`
	Metadata   *Metadata `json:"metadata"`
}

type Output struct {
	Name        string `json:"outName"`
	Type        string `json:"outType"`
	Description string `json:"outDescription"`
}

type Module struct {
	Name        string `json:"modName"`
	Path        string `json:"modPath"`
	Description string `json:"modDescription"`
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
		if elem.Type == "resource" && elem.Resource.Name != "" {
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
