package json

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/stretchr/testify/require"
)

func TestParser_GetKind(t *testing.T) {
	p := &Parser{}
	require.Equal(t, model.KindYAML, p.GetKind())
}

func TestParser_SupportedExtensions(t *testing.T) {
	p := &Parser{}
	require.Equal(t, []string{".yaml", ".yml"}, p.SupportedExtensions())
}

func TestParser_Parse(t *testing.T) {
	p := &Parser{}
	have := `
martin:
  name: test
---
martin2:
  name: test2
`

	doc, err := p.Parse("test.yaml", []byte(have))
	require.NoError(t, err)
	require.Len(t, doc, 2)
	require.Contains(t, doc[0], "martin")
	require.Contains(t, doc[1], "martin2")
}
