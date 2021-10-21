package docker

import (
	"bytes"
	"encoding/json"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/moby/buildkit/frontend/dockerfile/parser"
	"github.com/pkg/errors"
)

// Parser is a Dockerfile parser
type Parser struct {
}

// Resource Separates the list of commands by file
type Resource struct {
	CommandList map[string][]Command `json:"command"`
}

// Command is the struct for each dockerfile command
type Command struct {
	Cmd       string
	SubCmd    string
	Flags     []string
	Value     []string
	Original  string
	StartLine int `json:"_kics_line"`
	EndLine   int
	JSON      bool
}

// Resolve - replace or modifies in-memory content before parsing
func (p *Parser) Resolve(fileContent []byte, filename string) (*[]byte, error) {
	return &fileContent, nil
}

// Parse - parses dockerfile to Json
func (p *Parser) Parse(_ string, fileContent []byte) ([]model.Document, error) {
	var documents []model.Document
	reader := bytes.NewReader(fileContent)

	parsed, err := parser.Parse(reader)
	if err != nil {
		return nil, errors.Wrap(err, "failed to parse Dockerfile")
	}

	fromValue := "args"
	from := make(map[string][]Command)

	for _, child := range parsed.AST.Children {
		child.Value = strings.ToLower(child.Value)
		if child.Value == "from" {
			fromValue = strings.TrimPrefix(child.Original, "FROM ")
		}

		cmd := Command{
			Cmd:       child.Value,
			Original:  child.Original,
			Flags:     child.Flags,
			StartLine: child.StartLine,
			EndLine:   child.EndLine,
		}

		if child.Next != nil && len(child.Next.Children) > 0 {
			cmd.SubCmd = strings.ToLower(child.Next.Children[0].Value)
			child = child.Next.Children[0]
		}

		cmd.JSON = child.Attributes["json"]
		for n := child.Next; n != nil; n = n.Next {
			cmd.Value = append(cmd.Value, n.Value)
		}

		from[fromValue] = append(from[fromValue], cmd)
	}

	doc := &model.Document{}
	var resource Resource
	resource.CommandList = from

	j, err := json.Marshal(resource)
	if err != nil {
		return nil, errors.Wrap(err, "failed to Marshal Dockerfile")
	}

	if err := json.Unmarshal(j, &doc); err != nil {
		return nil, errors.Wrap(err, "failed to Unmarshal Dockerfile")
	}

	documents = append(documents, *doc)

	return documents, nil
}

// GetKind returns the kind of the parser
func (p *Parser) GetKind() model.FileKind {
	return model.KindDOCKER
}

// SupportedExtensions returns Dockerfile extensions
func (p *Parser) SupportedExtensions() []string {
	return []string{"Dockerfile", ".dockerfile"}
}

// SupportedTypes returns types supported by this parser, which are dockerfile
func (p *Parser) SupportedTypes() []string {
	return []string{"Dockerfile"}
}

// GetCommentToken return the comment token of Docker - #
func (p *Parser) GetCommentToken() string {
	return "#"
}

// StringifyContent converts original content into string formated version
func (p *Parser) StringifyContent(content []byte) (string, error) {
	return string(content), nil
}
