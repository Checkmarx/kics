package parser

import (
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	dockerParser "github.com/Checkmarx/kics/v2/pkg/parser/docker"
	jsonParser "github.com/Checkmarx/kics/v2/pkg/parser/json"
	terraformParser "github.com/Checkmarx/kics/v2/pkg/parser/terraform"
	yamlParser "github.com/Checkmarx/kics/v2/pkg/parser/yaml"
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

	for _, parser := range p {
		if _, ok := parser.extensions[".dockerfile"]; !ok {
			continue
		}
		docs, err := parser.Parse("../../test/fixtures/test_extension/Dockerfile", []byte(`
FROM foo
COPY . /
RUN echo hello
`), true, false, 15)

		require.NoError(t, err)
		require.Len(t, docs.Docs, 1)
		require.Equal(t, model.KindDOCKER, docs.Kind)
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
	require.Contains(t, extensions, ".dockerfile")
	require.Contains(t, extensions, "Dockerfile")
}

func initilizeBuilder() []*Parser {
	bd, _ := NewBuilder().
		Add(&jsonParser.Parser{}).
		Add(&yamlParser.Parser{}).
		Add(terraformParser.NewDefault()).
		Add(&dockerParser.Parser{}).
		Build([]string{""}, []string{""})
	return bd
}

func TestIsValidExtension(t *testing.T) {
	parser, _ := NewBuilder().
		Add(&jsonParser.Parser{}).
		Add(&dockerParser.Parser{}).
		Build([]string{""}, []string{""})
	require.True(t, parser[0].isValidExtension("../../test/fixtures/test_extension/test.json"), "test.json should be a valid extension")
	require.True(t, parser[1].isValidExtension("../../test/fixtures/test_extension/Dockerfile"), "dockerfile should be a valid extension")
	require.False(t, parser[0].isValidExtension("../../test/fixtures/test_extension/test.xml"), "test.xml should not be a valid extension")
}

func TestCommentsCommands(t *testing.T) {
	parser, _ := NewBuilder().Add(&dockerParser.Parser{}).Build([]string{""}, []string{""})
	commands := parser[0].CommentsCommands("../../test/fixtures/test_extension/Dockerfile", []byte(`
	# kics-scan ignore
	# kics-scan disable=ffdf4b37-7703-4dfe-a682-9d2e99bc6c09
	FROM foo
	COPY . /
	RUN echo hello
	`))
	expectedCommands := model.CommentsCommands{
		"ignore":  "",
		"disable": "ffdf4b37-7703-4dfe-a682-9d2e99bc6c09",
	}
	require.Equal(t, expectedCommands, commands)
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
		{
			name: "test contains invalid",
			args: args{
				types: []string{
					"dockerfile",
				},
				supportedTypes: map[string]bool{
					"cloudformation": true,
					"terraform":      true,
					"ansible":        true,
				},
			},
			want: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := contains(tt.args.types, tt.args.supportedTypes)
			require.Equal(t, tt.want, got)
		})
	}
}
