package docker

import (
	"bytes"
	"encoding/json"
	"fmt"
	"regexp"
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/moby/buildkit/frontend/dockerfile/parser"
	"github.com/pkg/errors"
)

// variableRegex matches $NAME and ${NAME}, always capturing the whole variable name
var variableRegex = regexp.MustCompile(`\$(?:\{([A-Za-z_][A-Za-z0-9_]*)\}|([A-Za-z_][A-Za-z0-9_]*))`)

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
	fromCount := make(map[string]int)
	arguments := make([]Command, 0)
	ignoreStruct := newIgnore()

	args := make(map[string]string, 0)
	envs := make(map[string]string, 0)

	for _, child := range parsed.AST.Children {
		child.Value = strings.ToLower(child.Value)
		if child.Value == "from" {
			fromValue = child.Original[5:]
			fromValue = strings.TrimSpace(fromValue)
			fromCount[fromValue]++
			if fromCount[fromValue] > 1 {
				fromValue = fmt.Sprintf("%s(%d)", fromValue, fromCount[fromValue]-1)
			}
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

		cmd.Value = resolveCommand(child.Value, cmd.Value, args, envs)

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
	return []string{".dockerfile"}
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

// resolveCommand resolves the variables of a command and records the ones it declares in args or envs.
// ENV takes precedence over ARG when both define the same name
func resolveCommand(name string, values []string, args, envs map[string]string) []string {
	switch name {
	case "arg":
		values = resolveArgsAndEnvs(values, envs)
		saveArgs(args, values[0])
	case "env":
		values = resolveArgsAndEnvs(values, args)
		saveEnvs(envs, values)
	default:
		values = resolveArgsAndEnvs(values, mergeVariables(args, envs))
	}

	return values
}

// mergeVariables returns a new map with the args overridden by the envs
func mergeVariables(args, envs map[string]string) map[string]string {
	merged := make(map[string]string, len(args)+len(envs))
	for k, v := range args {
		merged[k] = v
	}
	for k, v := range envs {
		merged[k] = v
	}
	return merged
}

// resolveArgsAndEnvs replaces every $NAME and ${NAME} found in values with the matching entry of vars.
// Whole variable names are matched in a single pass, so the result does not depend on map iteration order
// and substituted values are never expanded again. Unknown variables are kept untouched
func resolveArgsAndEnvs(values []string, vars map[string]string) []string {
	if len(vars) == 0 {
		return values
	}
	for i := range values {
		values[i] = variableRegex.ReplaceAllStringFunc(values[i], func(match string) string {
			sub := variableRegex.FindStringSubmatch(match)
			name := sub[1]
			if name == "" {
				name = sub[2]
			}
			if value, ok := vars[name]; ok {
				return value
			}
			return match
		})
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

// saveEnvs stores the pairs of an ENV instruction, which BuildKit emits as [key, value, delimiter] triples
func saveEnvs(envs map[string]string, envValues []string) map[string]string {
	const tripleSize = 3
	for i := 0; i+tripleSize <= len(envValues); i += tripleSize {
		envs[envValues[i]] = envValues[i+1]
	}
	return envs
}
