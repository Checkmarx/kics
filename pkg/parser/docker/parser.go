package docker

import (
	"bytes"
	"encoding/json"
	"fmt"
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/moby/buildkit/frontend/dockerfile/parser"
	"github.com/pkg/errors"
)

// Parser is a Dockerfile parser
type Parser struct {
}

// Resource Separates the list of commands by file
type Resource struct {
	CommandList map[string][]Command `json:"command"`
	Arguments   []Command            `json:"args"`
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
func (p *Parser) Resolve(fileContent []byte, _ string, _ bool, _ int) ([]byte, error) {
	return fileContent, nil
}

// Parse - parses dockerfile to Json
func (p *Parser) Parse(_ string, fileContent []byte) ([]model.Document, []int, error) {
	var documents []model.Document
	reader := bytes.NewReader(fileContent)

	parsed, err := parser.Parse(reader)
	if err != nil {
		return nil, []int{}, errors.Wrap(err, "failed to parse Dockerfile")
	}

	fromValue := ""
	from := make(map[string][]Command)
	arguments := make([]Command, 0)
	ignoreStruct := newIgnore()

	args := make(map[string]string, 0)
	envs := make(map[string]string, 0)

	for _, child := range parsed.AST.Children {
		child.Value = strings.ToLower(child.Value)
		if child.Value == "from" {
			fromValue = strings.TrimPrefix(child.Original, "FROM ")
		}

		if ignoreStruct.getIgnoreComments(child) {
			ignoreStruct.setIgnore(fromValue)
		}

		ignoreStruct.ignoreBlock(child, fromValue)

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

		if child.Value != "arg" {
			cmd.Value = resolveArgsAndEnvs(cmd.Value, args)
		} else {
			args = saveArgs(args, cmd.Value[0])
		}

		if child.Value != "env" {
			cmd.Value = resolveArgsAndEnvs(cmd.Value, envs)
		} else {
			envs = saveEnvs(envs, cmd.Value)
		}

		if fromValue == "" {
			arguments = append(arguments, cmd)
		} else {
			from[fromValue] = append(from[fromValue], cmd)
		}
	}

	doc := &model.Document{}
	var resource Resource
	resource.CommandList = from
	resource.Arguments = arguments

	j, err := json.Marshal(resource)
	if err != nil {
		return nil, []int{}, errors.Wrap(err, "failed to Marshal Dockerfile")
	}

	if err := json.Unmarshal(j, &doc); err != nil {
		return nil, []int{}, errors.Wrap(err, "failed to Unmarshal Dockerfile")
	}

	documents = append(documents, *doc)

	ignoreLines := ignoreStruct.getIgnoreLines()

	return documents, ignoreLines, nil
}

// GetKind returns the kind of the parser
func (p *Parser) GetKind() model.FileKind {
	return model.KindDOCKER
}

// SupportedExtensions returns Dockerfile extensions
func (p *Parser) SupportedExtensions() []string {
	return []string{"Dockerfile", ".dockerfile", ".ubi8", ".debian", "possibleDockerfile"}
}

// SupportedTypes returns types supported by this parser, which are dockerfile
func (p *Parser) SupportedTypes() map[string]bool {
	return map[string]bool{"dockerfile": true}
}

// GetCommentToken return the comment token of Docker - #
func (p *Parser) GetCommentToken() string {
	return "#"
}

// StringifyContent converts original content into string formatted version
func (p *Parser) StringifyContent(content []byte) (string, error) {
	return string(content), nil
}

// GetResolvedFiles returns the list of files that are resolved
func (p *Parser) GetResolvedFiles() map[string]model.ResolvedFile {
	return make(map[string]model.ResolvedFile)
}

func resolveArgsAndEnvs(values []string, args map[string]string) []string {
	for i := range values {
		for arg := range args {
			ref1 := fmt.Sprintf("${%s}", arg)
			values[i] = strings.Replace(values[i], ref1, args[arg], 1)
			ref2 := fmt.Sprintf("$%s", arg)
			values[i] = strings.Replace(values[i], ref2, args[arg], 1)
		}
	}

	return values
}

func saveArgs(args map[string]string, argValue string) map[string]string {
	value := strings.Split(argValue, "=")
	if len(value) == 2 {
		args[value[0]] = value[1]
	}
	if len(value) > 2 {
		// to handle cases like ARG VAR=erereR=E
		args[value[0]] = strings.Join(value[1:], "=")
	}

	return args
}

func saveEnvs(envs map[string]string, envValues []string) map[string]string {
	if len(envValues) == 2 {
		envs[envValues[0]] = envValues[1]
	}
	return envs
}
