package bicep

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"

	"github.com/Checkmarx/kics/pkg/model"
)

// Parser - parser for Bicep files
type Parser struct {
}

// Parse - parses bicep to ARM template (json file)
func (p *Parser) Parse(bicepPath string, _ []byte) ([]model.Document, []int, error) {

	doc := model.Document{}

	fileContent, err := convertBicepToArm(bicepPath)

	if err != nil {
		return nil, nil, err
	}

	BicepSyntax, err := teste(bicepPath)
	if err != nil {
		return nil, nil, err
	}
	fmt.Println(BicepSyntax)

	err = json.Unmarshal(fileContent, &doc)

	if err != nil {
		return nil, nil, err
	}

	return []model.Document{doc}, []int{}, nil

}

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
