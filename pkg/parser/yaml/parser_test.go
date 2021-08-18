package json

import (
	"path/filepath"
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
`, `
kube_node_ready_controller_memory: "200Mi"
{{if eq .Cluster.Environment "test"}}
downscaler_default_uptime: "Mon-Fri 07:30-20:30 Europe/Berlin"
downscaler_default_downtime: "never"
downscaler_enabled: "true"
{{else if eq .Cluster.Environment "e2e"}}
downscaler_default_uptime: "always"
downscaler_default_downtime: "never"
downscaler_enabled: "true"
{{else}}
downscaler_default_uptime: "always"
downscaler_default_downtime: "never"
downscaler_enabled: "false"
{{end}}
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

	_, err = p.Parse("test.yaml", []byte(have[3]))
	require.Error(t, err)
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

func TestYaml_processElements(t *testing.T) {
	type args struct {
		elements map[string]interface{}
		filePath string
	}
	tests := []struct {
		name     string
		args     args
		wantCert map[string]interface{}
		wantSwag string
	}{
		{
			name: "test_process_elements",
			args: args{
				elements: map[string]interface{}{
					"swagger_file": "test",
					"certificate":  filepath.Join("..", "..", "..", "test", "fixtures", "test_certificate", "certificate.pem"),
				},
				filePath: filepath.Join("..", "..", "..", "test", "fixtures", "test_certificate", "certificate.pem"),
			},
			wantCert: map[string]interface{}{
				"expiration_date": [3]int{2022, 3, 27},
				"file":            filepath.Join("..", "..", "..", "test", "fixtures", "test_certificate", "certificate.pem"),
				"rsa_key_bytes":   512,
			},
			wantSwag: "test",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			processElements(tt.args.elements, tt.args.filePath)
			require.Equal(t, tt.wantCert, tt.args.elements["certificate"])
			require.Equal(t, tt.wantSwag, tt.args.elements["swagger_file"])
		})
	}
}

func TestModel_TestYamlParser(t *testing.T) {
	tests := []struct {
		name   string
		sample string
		want   string
	}{
		{
			name: "test_ansible_yaml",
			sample: `
- name: Setup AWS API Gateway setup on AWS and deploy API definition
  community.aws.aws_api_gateway:
	swagger_file: my_api.yml
	stage: production
	cache_enabled: true
	cache_size: '1.6'
	tracing_enabled: true
	endpoint_type: PRIVATE
	state: present
`,
			want: "",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			parser := Parser{}
			got, err := parser.Parse("", []byte(tt.sample))
			require.NoError(t, err)
			require.Equal(t, tt.want, got)
		})
	}
}

// Test_GetCommentToken must get the token that represents a comment
func Test_GetCommentToken(t *testing.T) {
	parser := &Parser{}
	require.Equal(t, "#", parser.GetCommentToken())
}
