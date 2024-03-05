package bicep

import (
	"os"
	"os/exec"
	"path/filepath"

	"github.com/Checkmarx/kics/pkg/model"
)

// Parser - parser for Proto files
type Parser struct {
}

// armFile := filepath.Join(tmp, fmt.Sprintf("%s_%s.json", filename, uuid.New().String()))
// Parse - parses bicep to ARM template (json file)
func (p *Parser) Parse(bicepPath string, fileContent []byte) ([]model.Document, []int, error) {

	tmp := os.TempDir()
	var cmd *exec.Cmd

	armFile := filepath.Join(tmp, "arm.json")
	//creates an ARM template from the bicep file
	cmd = exec.Command("bicep", "build", bicepPath, "--outfile", armFile)

	/*
		reader := bytes.NewReader(fileContent)
		parserBicep := bicep.NewParser(reader)
		bicepFile, err := parserBicep.Parse()
		if err != nil {
			return nil, nil, err
		}

		var doc model.Document

		armFile, linesIgnore := converter.Convert(bicepFile)

		armBytes, err := json.Marshal(armFile)
		if err != nil {
			return nil, nil, err
		}

		err = json.Unmarshal(armBytes, &doc)
		if err != nil {
			return nil, nil, err
		}

		return []model.Document{doc}, linesIgnore, nil
	*/
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
func (p *Parser) GetCommentToken() []string {
	return []string{"//", "/*", "*/"}
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
