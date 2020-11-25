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

type Builder struct {
	parsers []kindParser
}

func NewBuilder() *Builder {
	return &Builder{}
}

func (b *Builder) Add(p kindParser) *Builder {
	b.parsers = append(b.parsers, p)
	return b
}

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

var ErrNotSupportedFile = errors.New("unsupported file to parse")

type Parser struct {
	parsers    map[string]kindParser
	extensions model.Extensions
}

func (c *Parser) Parse(filePath string, fileContent []byte) ([]model.Document, model.FileKind, error) {
	ext := filepath.Ext(filePath) //Its here that i need to verify
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

func (c *Parser) SupportedExtensions() model.Extensions {
	return c.extensions
}
