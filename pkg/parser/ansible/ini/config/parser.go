package ansibleconfig

import (
	"strconv"
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/parser/ansible/ini/comments"
	"github.com/bigkevmcd/go-configparser"
)

// Parser defines a parser type
type Parser struct {
}

func (p *Parser) Resolve(fileContent []byte, _ string, _ bool, _ int) ([]byte, error) {
	return fileContent, nil
}

// Parse parses .cfg/.conf file and returns it as a Document
func (p *Parser) Parse(filePath string, fileContent []byte) ([]model.Document, []int, error) {
	model.NewIgnore.Reset()

	reader := strings.NewReader(string(fileContent))
	configparser.Delimiters("=")
	inline := configparser.InlineCommentPrefixes([]string{";"})

	config, err := configparser.ParseReaderWithOptions(reader, inline)
	if err != nil {
		return nil, nil, err
	}

	doc := make(map[string]interface{})
	doc["groups"] = refactorConfig(config)

	ignoreLines := comments.GetIgnoreLines(strings.Split(string(fileContent), "\n"))

	return []model.Document{doc}, ignoreLines, nil
}

// refactorConfig removes all extra information and tries to convert
func refactorConfig(config *configparser.ConfigParser) (doc *model.Document) {
	doc = emptyDocument()
	for _, section := range config.Sections() {
		dict, err := config.Items(section)
		if err != nil {
			continue
		}
		dictRefact := make(map[string]interface{})
		for key, value := range dict {
			if boolValue, err := strconv.ParseBool(value); err == nil {
				dictRefact[key] = boolValue
			} else if floatValue, err := strconv.ParseFloat(value, 64); err == nil {
				dictRefact[key] = floatValue
			} else if strings.Contains(value, ",") {
				elements := strings.Split(value, ",")

				for i := 0; i < len(elements); i++ {
					elements[i] = strings.TrimSpace(elements[i])
				}

				dictRefact[key] = elements
			} else if value == "[]" {
				dictRefact[key] = []string{}
			} else {
				dictRefact[key] = value
			}
		}
		(*doc)[section] = dictRefact
	}

	return doc
}

// SupportedExtensions returns extensions supported by this parser, which are only ini extension
func (p *Parser) SupportedExtensions() []string {
	return []string{".cfg", ".conf"}
}

// SupportedTypes returns types supported by this parser, which is ansible
func (p *Parser) SupportedTypes() map[string]bool {
	return map[string]bool{
		"ansible": true,
	}
}

// GetKind returns CFG constant kind
func (p *Parser) GetKind() model.FileKind {
	return model.KindCFG
}

// GetCommentToken return the comment token of CFG/CONF - #
func (p *Parser) GetCommentToken() string {
	return "#"
}

// GetResolvedFiles returns resolved files
func (p *Parser) GetResolvedFiles() map[string]model.ResolvedFile {
	return make(map[string]model.ResolvedFile)
}

// StringifyContent converts original content into string formatted version
func (p *Parser) StringifyContent(content []byte) (string, error) {
	return string(content), nil
}

func emptyDocument() *model.Document {
	return &model.Document{}
}
