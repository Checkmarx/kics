package bicep

import (
	"bufio"
	"encoding/json"
	"fmt"
	"os"
	"regexp"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
)

// map[string]interface{}
/*
InLineDescriptions    string `json:"singleDescriptions"`
MultiLineDescriptions string `json:"multiDescriptions"`
linesToIgnore    []int                       `json:"-"`
linesNotToIgnore []int                       `json:"-"`
*/
type BicepSyntax struct {
	Name      string                      `json:"name"`
	Param     Param                       `json:"param"`
	Variables []Variable                  `json:"variables"`
	Resources []Resource                  `json:"resources"`
	Outputs   Output                      `json:"outputs"`
	Modules   []Module                    `json:"modules"`
	Metadata  *Metadata                   `json:"metadata"`
	Lines     map[string]model.LineObject `json:"_kics_lines"`
}

type Metadata struct {
	Description string `json:"description"`
	Name        string `json:"name"`
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

type Resource struct {
	Name        string `json:"resName"`
	Type        string `json:"resType"`
	Description string `json:"resDescription"`
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

func newBicepSyntax() *BicepSyntax {
	return &BicepSyntax{
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

func parserFiles(bicepFile, armFile string) (*BicepSyntax, error) {

	var err error
	var bicepSyntax *BicepSyntax = newBicepSyntax()

	//parse Bicep file
	bicepSyntax.Modules, bicepSyntax.Resources, err = parserBicepFile(bicepFile)
	if err != nil {
		return nil, err
	}

	//parse ARM file
	bicepSyntax, err = parserArmFile(armFile, bicepSyntax)
	if err != nil {
		return nil, err
	}

	fmt.Println("BYCEP SYNTAX:", bicepSyntax)
	fmt.Println("RESOURCES:", bicepSyntax.Resources)

	return bicepSyntax, nil
}

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

func parserBicepFile(bicepFile string) ([]Module, []Resource, error) {

	file, err := os.Open(bicepFile)
	if err != nil {
		return []Module{}, []Resource{}, err
	}

	defer file.Close()

	scanner := bufio.NewScanner(file)
	modules := []Module{}
	resources := []Resource{}

	for scanner.Scan() {
		line := scanner.Text()

		if line == "" {
			continue
		}

		resource := parseResource(line)
		if resource != nil {
			resources = append(resources, *resource)
			continue
		}

	}

	if err := scanner.Err(); err != nil {
		return []Module{}, []Resource{}, err
	}

	return modules, resources, nil
}

func parseResource(line string) *Resource {

	resourceRegex := regexp.MustCompile(`^resource\s+(\S+)\s+'(\S+)'`)
	matches := resourceRegex.FindStringSubmatch(line)
	if matches != nil {
		resourceType := strings.Split(matches[2], "@")[0]
		resourceType = strings.ReplaceAll(resourceType, "'", "")
		return &Resource{
			Name:        matches[1],
			Type:        resourceType,
			Description: "Description",
		}
	}

	return nil
}

func teste(bicepPath string) (*BicepSyntax, error) {

	bicepSyntax, err := parserFiles(bicepPath, "./teste/arm.json")
	if err != nil {
		return nil, err
	}

	return bicepSyntax, nil
}
