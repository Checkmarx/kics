package parser

import (
	"errors"
	"path/filepath"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/rs/zerolog/log"
)

type kindParser interface {
	GetKind() model.FileKind
	GetCommentToken() string
	SupportedExtensions() []string
	SupportedTypes() []string
	Parse(filePath string, fileContent []byte) ([]model.Document, []int, error)
	Resolve(fileContent []byte, filename string) (*[]byte, error)
	StringifyContent(content []byte) (string, error)
}

// Builder is a representation of parsers that will be construct
type Builder struct {
	parsers []kindParser
}

// NewBuilder creates a new Builder's reference
func NewBuilder() *Builder {
	log.Debug().Msg("parser.NewBuilder()")
	return &Builder{}
}

// Add is a function that adds a new parser to the caller and returns it
func (b *Builder) Add(p kindParser) *Builder {
	b.parsers = append(b.parsers, p)
	return b
}

// Build prepares parsers and associates a parser to its extension and returns it
func (b *Builder) Build(types, ext []string) ([]*Parser, error) {
	parserSlice := make([]*Parser, 0, len(b.parsers))
	for _, parser := range b.parsers {
		var parsers kindParser
		extensions := make(model.Extensions, len(b.parsers))
		platformsParser := parser.SupportedTypes()
		supported := parser.SupportedExtensions()
		platforms := ext

		if len(ext) == 0 { // --type flag usage
			platforms = types
			supported = platformsParser
		}

		if _, _, ok := contains(platforms, supported); ok {
			parsers = parser
			for _, ext := range parser.SupportedExtensions() {
				extensions[ext] = struct{}{}
			}
			parserSlice = append(parserSlice, &Parser{
				parsers:    parsers,
				extensions: extensions,
				Platform:   platformsParser,
			})
		}
	}

	return parserSlice, nil
}

// ErrNotSupportedFile represents an error when a file is not supported by KICS
var ErrNotSupportedFile = errors.New("unsupported file to parse")

// Parser is a struct that associates a parser to its supported extensions
type Parser struct {
	parsers    kindParser
	extensions model.Extensions
	Platform   []string
}

// ParsedDocument is a struct containing data retrieved from parsing
type ParsedDocument struct {
	Docs        []model.Document
	Kind        model.FileKind
	Content     string
	IgnoreLines []int
}

// CommentsCommands gets commands on comments in the file beginning, before the code starts
func (c *Parser) CommentsCommands(filePath string, fileContent []byte) model.CommentsCommands {
	if c.isValidExtension(filePath) {
		commentsCommands := make(model.CommentsCommands)
		commentToken := c.parsers.GetCommentToken()
		if commentToken != "" {
			lines := strings.Split(string(fileContent), "\n")
			for _, line := range lines {
				line = strings.TrimSpace(line)
				if line == "" {
					continue
				}
				if !strings.HasPrefix(line, commentToken) {
					break
				}
				fields := strings.Fields(strings.TrimSpace(strings.TrimPrefix(line, commentToken)))
				if len(fields) > 1 && fields[0] == "kics-scan" && fields[1] != "" {
					commandParameters := strings.SplitN(fields[1], "=", 2) //nolint:gomnd
					if len(commandParameters) > 1 {
						commentsCommands[commandParameters[0]] = commandParameters[1]
					} else {
						commentsCommands[commandParameters[0]] = ""
					}
				}
			}
		}
		return commentsCommands
	}
	return nil
}

// Parse executes a parser on the fileContent and returns the file content as a Document, the file kind and
// an error, if an error has occurred
func (c *Parser) Parse(filePath string, fileContent []byte) (ParsedDocument, error) {
	if c.isValidExtension(filePath) {
		resolved, err := c.parsers.Resolve(fileContent, filePath)
		if err != nil {
			return ParsedDocument{}, err
		}
		obj, igLines, err := c.parsers.Parse(filePath, *resolved)
		if err != nil {
			return ParsedDocument{}, err
		}

		cont, err := c.parsers.StringifyContent(fileContent)
		if err != nil {
			log.Error().Msgf("failed to stringify original content: %s", err)
			cont = string(fileContent)
		}

		return ParsedDocument{
			Docs:        obj,
			Kind:        c.parsers.GetKind(),
			Content:     cont,
			IgnoreLines: igLines,
		}, nil
	}
	return ParsedDocument{
		Docs:        nil,
		Kind:        "break",
		Content:     "",
		IgnoreLines: []int{},
	}, ErrNotSupportedFile
}

// SupportedExtensions returns extensions supported by KICS
func (c *Parser) SupportedExtensions() model.Extensions {
	return c.extensions
}

func contains(types, supportedTypes []string) (invalidArgsRes []string, contRes, supportedRes bool) {
	if types[0] == "" {
		return []string{}, true, true
	}
	set := make(map[string]struct{}, len(supportedTypes))
	for _, s := range supportedTypes {
		set[strings.ToUpper(s)] = struct{}{}
	}
	cont := true
	supported := false
	var invalidArgs []string
	for _, item := range types {
		_, ok := set[strings.ToUpper(item)]
		if !ok {
			cont = false
			invalidArgs = append(invalidArgs, item)
		} else {
			supported = true
		}
	}
	return invalidArgs, cont, supported
}

func (c *Parser) isValidExtension(filePath string) bool {
	ext := filepath.Ext(filePath)
	if ext == "" {
		ext = filepath.Base(filePath)
	}
	_, ok := c.extensions[ext]
	return ok
}
