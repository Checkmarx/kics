package bicep

import (
	"encoding/json"
	"fmt"

	"github.com/Checkmarx/kics/pkg/model"
)

// Parser - parser for Bicep files
type Parser struct {
}

type ElemBicep struct {
	Type     string
	Param    Param
	Metadata *Metadata
	Variable Variable
	Resource Resource
	Output   Output
	Module   Module
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

// Parse - parses bicep to JSON_Bicep template (json file)
func (p *Parser) Parse(bicepPath string, fileContent []byte) ([]model.Document, []int, error) {

	doc := model.Document{}
	//reader := bytes.NewReader(fileContent)
	//scanner := bufio.NewScanner(reader)
	//elems, err := parserBicepFile(bicepPath)
	elems := []ElemBicep{
		{
			Resource: Resource{
				Name:        "test_resource",
				Type:        "Microsoft.Web/sites",
				Description: "Description",
			},
			Type:     "resource",
			Param:    Param{},
			Metadata: &Metadata{},
			Variable: Variable{},
			Output:   Output{},
			Module:   Module{},
		},
	}

	jBicep, err := Convert(elems)
	if err != nil {
		return nil, nil, err
	}
	fmt.Println("jBicep:", jBicep)

	bicepBytes, err := json.Marshal(jBicep)

	if err != nil {
		return nil, nil, err
	}

	err = json.Unmarshal(bicepBytes, &doc)

	if err != nil {
		return nil, nil, err
	}

	return []model.Document{doc}, []int{}, nil

}

/*
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
*/

/*
func parserBicepFile(bicepFile string) ([]ElemBicep, error) {

	file, err := os.Open(bicepFile)
	if err != nil {
		return []ElemBicep{}, err
	}

	defer file.Close()

	scanner := bufio.NewScanner(file)
	//modules := []Module{}
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
		return []ElemBicep{}, err
	}

	return []ElemBicep{}, nil
}
*/

/*
func convertBicepToArm(bicepPath string) ([]byte, error) {

	armPath := filepath.Join("./teste", "arm.json")
	//tmp := os.TempDir()
	// armFile := filepath.Join(tmp, fmt.Sprintf("%s_%s.json", filename, uuid.New().String()))

	//creates an ARM template from the bicep file
	cmd := exec.Command("bicep", "build", bicepPath, "--outfile", armPath)
	err := cmd.Run()
	if err != nil {
		fmt.Printf("ERROR CMD %v", err)
		return nil, err
	}

	fileContent, err := os.ReadFile(filepath.Clean(armPath))
	if err != nil {
		return nil, err
	}

	return fileContent, nil
}
*/

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
	return map[string]bool{"bicep": true}
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
