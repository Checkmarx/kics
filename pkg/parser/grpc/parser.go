package grpc

import (
	"bytes"
	"encoding/json"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/parser/grpc/converter"
	"github.com/emicklei/proto"
)

// Parser - parser for Proto files
type Parser struct {
}

// Parse - parses dockerfile to Json
func (p *Parser) Parse(_ string, fileContent []byte) ([]model.Document, []int, error) {
	reader := bytes.NewReader(fileContent)
	parserProto := proto.NewParser(reader)
	nodes, err := parserProto.Parse()
	if err != nil {
		return nil, nil, err
	}

	var doc model.Document

	jproto, linesIgnore := converter.Convert(nodes)

	protoBytes, err := json.Marshal(jproto)
	if err != nil {
		return nil, nil, err
	}

	err = json.Unmarshal(protoBytes, &doc)
	if err != nil {
		return nil, nil, err
	}

	return []model.Document{doc}, linesIgnore, nil
}

// GetKind returns the kind of the parser
func (p *Parser) GetKind() model.FileKind {
	return model.KindPROTO
}

// SupportedExtensions returns Dockerfile extensions
func (p *Parser) SupportedExtensions() []string {
	return []string{".proto"}
}

// SupportedTypes returns types supported by this parser, which are dockerfile
func (p *Parser) SupportedTypes() []string {
	return []string{"grpc"}
}

// GetCommentToken return the comment token of Docker - #
func (p *Parser) GetCommentToken() string {
	return "//"
}

// StringifyContent converts original content into string formated version
func (p *Parser) StringifyContent(content []byte) (string, error) {
	return string(content), nil
}

// Resolve resolves proto files variables
func (p *Parser) Resolve(fileContent []byte, filename string) (*[]byte, error) {
	return &fileContent, nil
}
