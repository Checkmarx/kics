package parser

import (
	"errors"
	"fmt"
	"path/filepath"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
)

type kindParser interface {
	GetKind() model.FileKind
	SupportedExtensions() []string
	SupportedTypes() []string
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

// Build prepares parsers and associates a parser to its extension and returns it
func (b *Builder) Build(types []string) (*Parser, error) {
	var suportedTypes []string
	parsers := make(map[string]kindParser, len(b.parsers))
	extensions := make(model.Extensions, len(b.parsers))
	for _, parser := range b.parsers {
		suportedTypes = append(suportedTypes, parser.SupportedTypes()...)
		if _, _, ok := contains(types, parser.SupportedTypes()); ok {
			for _, ext := range parser.SupportedExtensions() {
				parsers[ext] = parser
				extensions[ext] = struct{}{}
			}
		}
	}

	if err := validateArguments(types, suportedTypes); err != nil {
		return &Parser{}, err
	}

	return &Parser{
		parsers:    parsers,
		extensions: extensions,
	}, nil
}

// ErrNotSupportedFile represents an error when a file is not supported by KICS
var ErrNotSupportedFile = errors.New("unsupported file to parse")

// Parser is a struct that associates a parser to its supported extensions
type Parser struct {
	parsers    map[string]kindParser
	extensions model.Extensions
}

// Parse executes a parser on the fileContent and returns the file content as a Document, the file kind and
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

func validateArguments(types, validArgs []string) error {
	validArgs = removeDuplicateValues(validArgs)
	if invalidType, ok, _ := contains(types, validArgs); !ok {
		return fmt.Errorf(fmt.Sprintf("Unknown Argument: %s\nValid Arguments:\n  %s\n", invalidType, strings.Join(validArgs, "\n  ")))
	}
	return nil
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

// function to remove duplicate values in array
func removeDuplicateValues(stringSlice []string) []string {
	keys := make(map[string]bool)
	list := []string{}

	for _, entry := range stringSlice {
		if _, value := keys[entry]; !value {
			keys[entry] = true
			list = append(list, entry)
		}
	}
	return list
}
