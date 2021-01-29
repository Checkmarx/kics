package json

import (
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/stretchr/testify/require"
)

// TestParser_GetKind tests the functions [GetKind()] and all the methods called by them
func TestParser_GetKind(t *testing.T) {
	p := &Parser{}
	require.Equal(t, model.KindJSON, p.GetKind())
}

// TestParser_SupportedExtensions tests the functions [SupportedExtensions()] and all the methods called by them
func TestParser_SupportedExtensions(t *testing.T) {
	p := &Parser{}
	require.Equal(t, []string{".json"}, p.SupportedExtensions())
}

// TestParser_SupportedExtensions tests the functions [SupportedTypes()] and all the methods called by them
func TestParser_SupportedTypes(t *testing.T) {
	p := &Parser{}
	require.Equal(t, []string{"cloudFormation"}, p.SupportedTypes())
}

// TestParser_Parse tests the functions [Parse()] and all the methods called by them
func TestParser_Parse(t *testing.T) {
	p := &Parser{}
	have := `
{
	"martin": {
		"name": "Martin D'vloper"
	}
}
`

	doc, err := p.Parse("test.json", []byte(have))
	require.NoError(t, err)
	require.Len(t, doc, 1)
	require.Contains(t, doc[0], "martin")
}
