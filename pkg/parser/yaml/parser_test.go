package json

import (
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
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
	have := []string{`
martin:
  name: test
---
martin2:
  name: test2
`, `
---
- name: Create an empty bucket2
  amazon.aws.aws_s3:
    bucket: mybucket
    mode: create
    permission: authenticated-read
`, `
-name: test
-name: test2
`,
	}

	doc, err := p.Parse("test.yaml", []byte(have[0]))
	require.NoError(t, err)
	require.Len(t, doc, 2)
	require.Contains(t, doc[0], "martin")
	require.Contains(t, doc[1], "martin2")

	playbook, err := p.Parse("test.yaml", []byte(have[1]))
	require.NoError(t, err)
	require.Len(t, playbook, 1)
	require.Contains(t, playbook[0]["playbooks"].([]interface{})[0].(map[string]interface{})["name"], "bucket2")
}
