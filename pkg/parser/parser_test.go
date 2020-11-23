package parser

import (
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	jsonParser "github.com/Checkmarx/kics/pkg/parser/json"
	terraformParser "github.com/Checkmarx/kics/pkg/parser/terraform"
	yamlParser "github.com/Checkmarx/kics/pkg/parser/yaml"
	"github.com/stretchr/testify/require"
)

func TestParser_Parse(t *testing.T) {
	p := NewBuilder().
		Add(&jsonParser.Parser{}).
		Add(&yamlParser.Parser{}).
		Add(terraformParser.NewDefault()).
		Build()

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
}

func TestParser_Empty(t *testing.T) {
	p := NewBuilder().
		Build()

	doc, kind, err := p.Parse("test.json", nil)
	require.Nil(t, doc)
	require.Equal(t, model.FileKind(""), kind)
	require.Error(t, err)
	require.Equal(t, ErrNotSupportedFile, err)
}

func TestParser_SupportedExtensions(t *testing.T) {
	p := NewBuilder().
		Add(&jsonParser.Parser{}).
		Add(&yamlParser.Parser{}).
		Add(terraformParser.NewDefault()).
		Build()

	extensions := p.SupportedExtensions()
	require.NotNil(t, extensions)
	require.Contains(t, extensions, ".json")
	require.Contains(t, extensions, ".tf")
	require.Contains(t, extensions, ".yaml")
}
