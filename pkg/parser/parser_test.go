package parser

import (
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	dockerParser "github.com/Checkmarx/kics/pkg/parser/docker"
	jsonParser "github.com/Checkmarx/kics/pkg/parser/json"
	terraformParser "github.com/Checkmarx/kics/pkg/parser/terraform"
	yamlParser "github.com/Checkmarx/kics/pkg/parser/yaml"
	"github.com/stretchr/testify/require"
)

// TestParser_Parse tests the functions [Parse()] and all the methods called by them
func TestParser_Parse(t *testing.T) {
	p := initilizeBuilder()

	docs, kind, err := p.Parse("test.json", []byte(`
{
	"martin": {
		"name": "Martin D'vloper"
	}
}
`))
	require.NoError(t, err)
	require.Len(t, docs, 1)
	require.Contains(t, docs[0], "martin")
	require.Equal(t, model.KindJSON, kind)

	docs, kind, err = p.Parse("test.yaml", []byte(`
martin:
  name: Martin D'vloper
`))
	require.NoError(t, err)
	require.Len(t, docs, 1)
	require.Contains(t, docs[0], "martin")
	require.Equal(t, model.KindYAML, kind)

	docs, kind, err = p.Parse("Dockerfile", []byte(`
	FROM foo
	COPY . /
	RUN echo hello
`))

	require.NoError(t, err)
	require.Len(t, docs, 1)
	require.Equal(t, model.KindDOCKER, kind)
}

// TestParser_Empty tests the functions [Parse()] and all the methods called by them (tests an empty parser)
func TestParser_Empty(t *testing.T) {
	p := NewBuilder().
		Build()

	doc, kind, err := p.Parse("test.json", nil)
	require.Nil(t, doc)
	require.Equal(t, model.FileKind(""), kind)
	require.Error(t, err)
	require.Equal(t, ErrNotSupportedFile, err)
}

// TestParser_SupportedExtensions tests the functions [SupportedExtensions()] and all the methods called by them
func TestParser_SupportedExtensions(t *testing.T) {
	p := initilizeBuilder()

	extensions := p.SupportedExtensions()
	require.NotNil(t, extensions)
	require.Contains(t, extensions, ".json")
	require.Contains(t, extensions, ".tf")
	require.Contains(t, extensions, ".yaml")
	require.Contains(t, extensions, ".dockerfile")
	require.Contains(t, extensions, "Dockerfile")
}

func initilizeBuilder() *Parser {
	return NewBuilder().
		Add(&jsonParser.Parser{}).
		Add(&yamlParser.Parser{}).
		Add(terraformParser.NewDefault()).
		Add(&dockerParser.Parser{}).
		Build()
}
