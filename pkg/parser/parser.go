package parser

import (
	"errors"
	"fmt"
	"path/filepath"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/rs/zerolog/log"
)

type kindParser interface {
	GetKind() model.FileKind
	SupportedExtensions() []string
	SupportedTypes() []string
	Parse(filePath string, fileContent []byte) ([]model.Document, error)
	Resolve(fileContent []byte, filename string) (*[]byte, error)
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
func (b *Builder) Build(types []string) ([]*Parser, error) {
	paresrs := make([]*Parser, 0, len(b.parsers))
	var suportedTypes []string
	for _, parser := range b.parsers {
		var parsers kindParser
		extensions := make(model.Extensions, len(b.parsers))
		platforms := parser.SupportedTypes()
		suportedTypes = append(suportedTypes, platforms...)
		if _, _, ok := contains(types, parser.SupportedTypes()); ok {
			parsers = parser
			for _, ext := range parser.SupportedExtensions() {
				extensions[ext] = struct{}{}
			}
			paresrs = append(paresrs, &Parser{
				parsers:    parsers,
				extensions: extensions,
				Platform:   platforms,
			})
		}
	}

	if err := validateArguments(types, suportedTypes); err != nil {
		return []*Parser{}, err
	}

	return paresrs, nil
}

// ErrNotSupportedFile represents an error when a file is not supported by KICS
var ErrNotSupportedFile = errors.New("unsupported file to parse")

// Parser is a struct that associates a parser to its supported extensions
type Parser struct {
	parsers    kindParser
	extensions model.Extensions
	Platform   []string
}

// Parse executes a parser on the fileContent and returns the file content as a Document, the file kind and
// an error, if an error has occurred
func (c *Parser) Parse(filePath string, fileContent []byte) ([]model.Document, model.FileKind, error) {
	ext := filepath.Ext(filePath)
	if ext == "" {
		ext = filepath.Base(filePath)
	}
	if _, ok := c.extensions[ext]; ok {
		resolved, err := c.parsers.Resolve(fileContent, filePath)
		if err != nil {
			return nil, "", err
		}
		obj, err := c.parsers.Parse(filePath, *resolved)
		if err != nil {
			return nil, "", err
		}

		return obj, c.parsers.GetKind(), nil
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
		return fmt.Errorf("unknown argument for --type: %s\nvalid arguments:\n  %s", invalidType, strings.Join(validArgs, "\n  "))
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
