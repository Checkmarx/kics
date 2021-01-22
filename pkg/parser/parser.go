package parser

import (
	"errors"
	"path/filepath"

	"github.com/Checkmarx/kics/pkg/model"
)

type kindParser interface {
	GetKind() model.FileKind
	SupportedExtensions() []string
	Parse(filePath string, fileContent []byte) ([]model.Document, error)
}

// Builder is a representation of parsers that will be construct
type Builder struct {
	parsers []kindParser
}

// NewBuilder creates a new Builder's reference
func NewBuilder() *Builder {
	return &Builder{}
}

// Add is a function that adds a new parser to the caller and returns it
func (b *Builder) Add(p kindParser) *Builder {
	b.parsers = append(b.parsers, p)
	return b
}

// Build prepares parsers and associate a parser to its extension and returns it
func (b *Builder) Build() *Parser {
	parsers := make(map[string]kindParser, len(b.parsers))
	extensions := make(model.Extensions, len(b.parsers))
	for _, parser := range b.parsers {
		for _, ext := range parser.SupportedExtensions() {
			parsers[ext] = parser
			extensions[ext] = struct{}{}
		}
	}

	return &Parser{
		parsers:    parsers,
		extensions: extensions,
	}
}

// ErrNotSupportedFile represents an error when a file is not supported by KICS
var ErrNotSupportedFile = errors.New("unsupported file to parse")

// Parser is a struct that associates a parser to its supported extensions
type Parser struct {
	parsers    map[string]kindParser
	extensions model.Extensions
}

// parse executes a parser on the fileContent and return the file content as a Document, the file kind and
// an error, if an error has occurred
func (c *Parser) Parse(filePath string, fileContent []byte) ([]model.Document, model.FileKind, error) {
	ext := filepath.Ext(filePath)
	if ext == "" {
		ext = filepath.Base(filePath)
	}
	if p, ok := c.parsers[ext]; ok {
		obj, err := p.Parse(filePath, fileContent)
		if err != nil {
			return nil, "", err
		}

		return obj, p.GetKind(), nil
	}

	return nil, "", ErrNotSupportedFile
}

// SupportedExtensions returns extensions supported by KICS
func (c *Parser) SupportedExtensions() model.Extensions {
	return c.extensions
}
