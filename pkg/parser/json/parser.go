/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package json

import (
	"bytes"
	"encoding/json"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/resolver/file"
)

// Parser defines a parser type
type Parser struct {
	shouldIdent   bool
	resolvedFiles map[string]model.ResolvedFile
}

// Resolve - replace or modifies in-memory content before parsing
func (p *Parser) Resolve(fileContent []byte, filename string, resolveReferences bool, maxResolverDepth int) ([]byte, error) {
	// Resolve files passed as arguments with file resolver (e.g. file://)
	res := file.NewResolver(json.Unmarshal, json.Marshal, p.SupportedExtensions())
	resolvedFilesCache := make(map[string]file.ResolvedFile)
	resolved := res.Resolve(fileContent, filename, 0, maxResolverDepth, resolvedFilesCache, resolveReferences)
	p.resolvedFiles = res.ResolvedFiles
	if len(res.ResolvedFiles) == 0 {
		return fileContent, nil
	}
	return resolved, nil
}

// Parse parses json file and returns it as a Document
func (p *Parser) Parse(_ string, fileContent []byte) ([]model.Document, []int, error) {
	r := model.Document{}
	err := json.Unmarshal(fileContent, &r)
	if err != nil {
		var r []model.Document
		err = json.Unmarshal(fileContent, &r)
		return r, []int{}, err
	}

	jLine := initializeJSONLine(fileContent)
	kicsJSON := jLine.setLineInfo(r)

	// Try to parse JSON as Terraform plan
	kicsPlan, err := parseTFPlan(kicsJSON)
	if err != nil {
		// JSON is not a tf plan
		return []model.Document{kicsJSON}, []int{}, nil
	}

	p.shouldIdent = true

	return []model.Document{kicsPlan}, []int{}, nil
}

// SupportedExtensions returns extensions supported by this parser, which is json extension
func (p *Parser) SupportedExtensions() []string {
	return []string{".json"}
}

// GetKind returns JSON constant kind
func (p *Parser) GetKind() model.FileKind {
	return model.KindJSON
}

// SupportedTypes returns types supported by this parser, which are cloudFormation
func (p *Parser) SupportedTypes() map[string]bool {
	return map[string]bool{
		"ansible":              true,
		"cloudformation":       true,
		"openapi":              true,
		"azureresourcemanager": true,
		"terraform":            true,
		"kubernetes":           true,
	}
}

// GetCommentToken return an empty string, since JSON does not have comment token
func (p *Parser) GetCommentToken() string {
	return ""
}

// StringifyContent converts original content into string formatted version
func (p *Parser) StringifyContent(content []byte) (string, error) {
	if p.shouldIdent {
		var out bytes.Buffer
		err := json.Indent(&out, content, "", "  ")
		if err != nil {
			return "", err
		}
		return out.String(), nil
	}
	return string(content), nil
}

// GetResolvedFiles returns resolved files
func (p *Parser) GetResolvedFiles() map[string]model.ResolvedFile {
	return p.resolvedFiles
}
