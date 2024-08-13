/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package parser

import (
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	jsonParser "github.com/Checkmarx/kics/pkg/parser/json"
	terraformParser "github.com/Checkmarx/kics/pkg/parser/terraform"
	yamlParser "github.com/Checkmarx/kics/pkg/parser/yaml"
	"github.com/stretchr/testify/require"
)

// TestParser_Parse tests the functions [Parse()] and all the methods called by them
func TestParser_Parse(t *testing.T) {
	p := initilizeBuilder()

	for _, parser := range p {
		if _, ok := parser.extensions[".json"]; !ok {
			continue
		}
		docs, err := parser.Parse("../../test/fixtures/test_extension/test.json", []byte(`
{
	"martin": {
		"name": "CxBraga"
	}
}
`), true, false, 15)
		require.NoError(t, err)
		require.Len(t, docs.Docs, 1)
		require.Contains(t, docs.Docs[0], "martin")
		require.Equal(t, model.KindJSON, docs.Kind)
	}

	for _, parser := range p {
		if _, ok := parser.extensions[".yaml"]; !ok {
			continue
		}
		docs, err := parser.Parse("../../test/fixtures/test_extension/test.yaml", []byte(`
martin:
  name: CxBraga
`), true, false, 15)
		require.NoError(t, err)
		require.Len(t, docs.Docs, 1)
		require.Contains(t, docs.Docs[0], "martin")
		require.Equal(t, model.KindYAML, docs.Kind)
	}
}

// TestParser_Empty tests the functions [Parse()] and all the methods called by them (tests an empty parser)
func TestParser_Empty(t *testing.T) {
	p, err := NewBuilder().
		Build([]string{""}, []string{""})
	if err != nil {
		t.Errorf("Error building parser: %s", err)
	}
	for _, parser := range p {
		docs, err := parser.Parse("test.json", nil, true, false, 15)
		require.Nil(t, docs.Docs)
		require.Equal(t, model.FileKind(""), docs.Kind)
		require.Error(t, err)
		require.Equal(t, ErrNotSupportedFile, err)
	}
}

// TestParser_SupportedExtensions tests the functions [SupportedExtensions()] and all the methods called by them
func TestParser_SupportedExtensions(t *testing.T) {
	p := initilizeBuilder()
	extensions := make(map[string]struct{})

	for _, parser := range p {
		got := parser.SupportedExtensions()
		for key := range got {
			extensions[key] = struct{}{}
		}
	}
	require.NotNil(t, extensions)
	require.Contains(t, extensions, ".json")
	require.Contains(t, extensions, ".tf")
	require.Contains(t, extensions, ".yaml")
}

func initilizeBuilder() []*Parser {
	bd, _ := NewBuilder().
		Add(&jsonParser.Parser{}).
		Add(&yamlParser.Parser{}).
		Add(terraformParser.NewDefault()).
		Build([]string{""}, []string{""})
	return bd
}

func TestIsValidExtension(t *testing.T) {
	parser, _ := NewBuilder().
		Add(&jsonParser.Parser{}).
		Build([]string{""}, []string{""})
	require.True(t, parser[0].isValidExtension("../../test/fixtures/test_extension/test.json"), "test.json should be a valid extension")
	require.False(t, parser[0].isValidExtension("../../test/fixtures/test_extension/test.xml"), "test.xml should not be a valid extension")
}

func TestParser_Contains(t *testing.T) {
	type args struct {
		types          []string
		supportedTypes map[string]bool
	}
	tests := []struct {
		name string
		args args
		want bool
	}{
		{
			name: "test contains",
			args: args{
				types: []string{
					"cloudformation",
				},
				supportedTypes: map[string]bool{
					"cloudformation": true,
					"terraform":      true,
					"ansible":        true,
				},
			},
			want: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := contains(tt.args.types, tt.args.supportedTypes)
			require.Equal(t, tt.want, got)
		})
	}
}
