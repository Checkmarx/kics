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
	Name           string                      `json:"name"`
	Param          Param                       `json:"param"`
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
		Name:           "",
		Param:          Param{},
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
	var jBicep *JSONBicep = newJSONBicep()

	// modules := []Module{}
	resources := []Resource{}

	for _, elem := range elems {
		switch elem.Type {
		case "resource":
			resource := elem.Resource
			if resource.Name != "" {
				resources = append(resources, resource)
				continue
			}
		}
	}

	jBicep.Resources = resources

	return jBicep, nil
}

// const kicsLinesKey = "_kics_"

/*
func Convert(bicep *BicepSyntax) (file *BicepSyntax) {
	bicepSyntax := newBicepSyntax()
	// handle panic during conversion process
	defer func() {
		if r := recover(); r != nil {
			errMessage := "Recovered from panic during conversion of Bicep file " + file.Name
			utils.HandlePanic(r, errMessage)
		}
	}()
	fmt.Printf("Bicep file conversion started %v", kicsLinesKey)

	resourceLinesBicep := []Resource{}
	resourceLinesArm := []Resource{}

	for _, line := range bicep.Lines {
		switch line {
		case bicep.Resources:
			bicepSyntax.Resources = convertARMResourceToBicep(line)
			paramLines[kicsLinesKey+line.Name] = model.LineObject{
				Line: line.LineNumber,
			}
		}
	}

	return bicepSyntax
}
*/
