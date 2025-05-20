package buildah

import (
	"bytes"
	"sort"
	"strings"

	"github.com/rs/zerolog/log"

	"encoding/json"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/pkg/errors"
	"mvdan.cc/sh/v3/syntax"
)

// Parser is a Buildah parser
type Parser struct {
}

// Resource separates the list of commands by file
type Resource struct {
	CommandList map[string][]Command `json:"command"`
}

// Command is the struct for each Buildah command
type Command struct {
	Cmd       string
	Original  string
	Value     string
	StartLine int `json:"_kics_line"`
	EndLine   int
}

// FromValue is the struct for each from
type FromValue struct {
	Value string
	Line  int
}

// Info has the relevant information to Buildah parser
type Info struct {
	IgnoreLines      []int
	From             map[string][]Command
	FromValues       []FromValue
	IgnoreBlockLines []int
}

const (
	buildah = "buildah"
)

// Resolve - replace or modifies in-memory content before parsing
func (p *Parser) Resolve(fileContent []byte, _ string, _ bool, _ int) ([]byte, error) {
	return fileContent, nil
}

// Parse - parses Buildah file to Json
func (p *Parser) Parse(_ string, fileContent []byte) ([]model.Document, []int, error) {
	var info Info
	info.From = map[string][]Command{}

	reader := bytes.NewReader(fileContent)
	f, err := syntax.NewParser(syntax.KeepComments(true)).Parse(reader, "")

	if err != nil {
		return nil, []int{}, err
	}

	syntax.Walk(f, func(node syntax.Node) bool {
		switch x := node.(type) {
		case *syntax.Stmt:
			info.getStmt(x)
		case *syntax.Comment:
			info.getIgnoreLines(x)
		}
		return true
	})

	// get kics-scan ignore-block related to from
	info.ignoreFromBlock()

	var documents []model.Document
	var resource Resource
	resource.CommandList = info.From
	doc := &model.Document{}
	j, err := json.Marshal(resource)
	if err != nil {
		return nil, []int{}, errors.Wrap(err, "failed to Marshal Buildah")
	}

	err = json.Unmarshal(j, &doc)
	if err != nil {
		return nil, []int{}, errors.Wrap(err, "failed to Unmarshal Buildah")
	}

	documents = append(documents, *doc)

	sort.Ints(info.IgnoreLines)

	return documents, info.IgnoreLines, nil
}

func (i *Info) getStmt(stmt *syntax.Stmt) {
	if cmd, ok := stmt.Cmd.(*syntax.CallExpr); ok {
		args := cmd.Args

		// get kics-scan ignore-block related to command + get command
		stCommand := i.getStmtInfo(stmt, args)

		if stCommand.Cmd == "buildah from" {
			fromValue := FromValue{
				Value: stCommand.Value,
				Line:  stCommand.StartLine,
			}
			i.FromValues = append(i.FromValues, fromValue)
		}

		if stCommand.Cmd != "" {
			if len(i.FromValues) != 0 {
				v := i.FromValues[len(i.FromValues)-1].Value
				i.From[v] = append(i.From[v], stCommand)
			}
		}
	}
}

func (i *Info) getStmtInfo(stmt *syntax.Stmt, args []*syntax.Word) Command {
	var command Command
	minimumArgs := 2

	if len(args) > minimumArgs {
		if getWordValue(args[0]) == buildah {
			cmd := "buildah " + strings.TrimSpace(getWordValue(args[1]))
			fullCmd := strings.TrimSpace(getFullCommand(args))
			value := strings.TrimPrefix(fullCmd, cmd)
			start := int(args[0].Pos().Line())         //nolint:gosec
			end := int(args[len(args)-1].End().Line()) //nolint:gosec

			command = Command{
				Cmd:       cmd,
				Original:  fullCmd,
				StartLine: start,
				EndLine:   end,
				Value:     strings.TrimSpace(value),
			}

			// get kics-scan ignore-block comments
			i.getIgnoreBlockLines(stmt.Comments, start, end)

			return command
		}
	}
	return command
}

func getWordValue(wd *syntax.Word) string {
	printer := syntax.NewPrinter()
	var buf bytes.Buffer

	err := printer.Print(&buf, wd)

	if err != nil {
		log.Debug().Msgf("failed to get word value: %s", err)
	}

	value := buf.String()
	buf.Reset()

	return value
}

func getFullCommand(args []*syntax.Word) string {
	var buf bytes.Buffer
	printer := syntax.NewPrinter()

	call := &syntax.CallExpr{Args: args}

	err := printer.Print(&buf, call)

	if err != nil {
		log.Debug().Msgf("failed to get full command: %s", err)
	}

	command := buf.String()
	buf.Reset()

	command = strings.ReplaceAll(command, "\n", "")
	command = strings.ReplaceAll(command, "\r", "")
	command = strings.ReplaceAll(command, "\t", "")
	command = strings.ReplaceAll(command, "\\", "")

	return command
}

// GetKind returns the kind of the parser
func (p *Parser) GetKind() model.FileKind {
	return model.KindBUILDAH
}

// SupportedExtensions returns Buildah extensions
func (p *Parser) SupportedExtensions() []string {
	return []string{".sh"}
}

// SupportedTypes returns types supported by this parser, which are Buildah
func (p *Parser) SupportedTypes() map[string]bool {
	return map[string]bool{"buildah": true}
}

// GetCommentToken return the comment token of Buildah - #
func (p *Parser) GetCommentToken() string {
	return "#"
}

// StringifyContent converts original content into string formatted version
func (p *Parser) StringifyContent(content []byte) (string, error) {
	return string(content), nil
}

// GetResolvedFiles returns the resolved files
func (p *Parser) GetResolvedFiles() map[string]model.ResolvedFile {
	return make(map[string]model.ResolvedFile)
}
