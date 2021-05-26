package json

import (
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/stretchr/testify/require"
)

// TestParser_GetKind tests the functions [GetKind()] and all the methods called by them
func TestParser_GetKind(t *testing.T) {
	p := &Parser{}
	require.Equal(t, model.KindYAML, p.GetKind())
}

// TestParser_SupportedExtensions tests the functions [SupportedExtensions()] and all the methods called by them
func TestParser_SupportedExtensions(t *testing.T) {
	p := &Parser{}
	require.Equal(t, []string{".yaml", ".yml"}, p.SupportedExtensions())
}

// TestParser_SupportedExtensions tests the functions [SupportedTypes()] and all the methods called by them
func TestParser_SupportedTypes(t *testing.T) {
	p := &Parser{}
	require.Equal(t, []string{"Ansible", "CloudFormation", "Kubernetes", "OpenAPI"}, p.SupportedTypes())
}

// TestParser_Parse tests the functions [Parse()] and all the methods called by them
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
test:
  - &test_anchor
    group:
      name: "cx"
test_2:
  perm:
    - <<: *test_anchor
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

	nestedMap, err := p.Parse("test.yaml", []byte(have[2]))
	require.NoError(t, err)
	require.Len(t, nestedMap, 1)
	require.Contains(t, nestedMap[0], "test_2")
	require.Contains(t,
		nestedMap[0]["test_2"].(model.Document)["perm"].([]interface{})[0].(map[string]interface{})["group"].(model.Document)["name"], "cx")
}

// Test_Resolve tests the functions [Resolve()] and all the methods called by them
func Test_Resolve(t *testing.T) {
	have := `
	martin:
		name: test
	---
	martin2:
		name: test2
	`
	parser := &Parser{}

	resolved, err := parser.Resolve([]byte(have), "test.yaml")
	require.NoError(t, err)
	require.Equal(t, []byte(have), *resolved)
}
