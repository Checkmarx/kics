/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
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

// Parse - parses grpc to Json
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

// SupportedExtensions returns GRPC extensions
func (p *Parser) SupportedExtensions() []string {
	return []string{".proto"}
}

// SupportedTypes returns types supported by this parser, which are grpc
func (p *Parser) SupportedTypes() map[string]bool {
	return map[string]bool{"grpc": true}
}

// GetCommentToken return the comment token of GRPC - #
func (p *Parser) GetCommentToken() string {
	return "//"
}

// StringifyContent converts original content into string formatted version
func (p *Parser) StringifyContent(content []byte) (string, error) {
	return string(content), nil
}

// Resolve resolves proto files variables
func (p *Parser) Resolve(fileContent []byte, _ string, _ bool, _ int) ([]byte, error) {
	return fileContent, nil
}

// GetResolvedFiles returns the list of files that are resolved
func (p *Parser) GetResolvedFiles() map[string]model.ResolvedFile {
	return make(map[string]model.ResolvedFile)
}
