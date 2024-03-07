package bicep

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
type JsonBicep struct {
	Name      string                      `json:"name"`
	Param     Param                       `json:"param"`
	Variables []Variable                  `json:"variables"`
	Resources []Resource                  `json:"resources"`
	Outputs   Output                      `json:"outputs"`
	Modules   []Module                    `json:"modules"`
	Metadata  *Metadata                   `json:"metadata"`
	Lines     map[string]model.LineObject `json:"_kics_lines"`
}

func newJsonBicep() *JsonBicep {
	return &JsonBicep{
		Name:      "",
		Param:     Param{},
		Variables: []Variable{},
		Resources: []Resource{},
		Outputs:   Output{},
		Modules:   []Module{},
		Metadata:  &Metadata{},
		Lines:     map[string]model.LineObject{},
	}
}

// Convert - converts Bicep file to JSON Bicep template
func Convert(elems []ElemBicep) (file *JsonBicep, err error) {

	var jBicep *JsonBicep = newJsonBicep()

	//modules := []Module{}
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

//const kicsLinesKey = "_kics_"

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

/*
func parserArmFile(armFile string, bicepSyntax *BicepSyntax) (*BicepSyntax, error) {
	file, err := os.Open(armFile)
	if err != nil {
		return nil, err
	}

	defer file.Close()

	decoder := json.NewDecoder(file)
	err = decoder.Decode(&bicepSyntax)
	if err != nil {
		return nil, err
	}

	return bicepSyntax, nil
}
*/

//parse ARM file
/*
	bicepSyntax, err = parserArmFile(armFile, bicepSyntax)
	if err != nil {
		return nil, err
	}
*/
