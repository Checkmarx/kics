package json

import (
	"encoding/json"
	"fmt"
	"path/filepath"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/pkg/errors"
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
	require.Equal(t, map[string]bool{
		"ansible":                 true,
		"cicd":                    true,
		"cloudformation":          true,
		"kubernetes":              true,
		"crossplane":              true,
		"knative":                 true,
		"openapi":                 true,
		"googledeploymentmanager": true,
		"dockercompose":           true,
		"pulumi":                  true,
		"serverlessfw":            true,
	}, p.SupportedTypes())
}

// TestParser_Parse tests the functions [Parse()] and all the methods called by them
func TestParser_Parse(t *testing.T) { //nolint
	p := &Parser{}
	have := []string{`
# kics-scan ignore-block
martin:
  name: test
---
martin2:
  name: test2
`, `
---
# kics-scan ignore-block
- name: Create an empty bucket2
  amazon.aws.aws_s3:
    bucket: mybucket
    mode: create
    permission: authenticated-read
`,
		`
test:
  - &test_anchor
    group:
      # kics-scan ignore-line
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
`, `
resources:
- name: &SA_NAME my-vm-access
  type: *SA_NAME
- name: my-vm
  type: vm.jinja
  properties:
    serviceAccountId: *SA_NAME
`,
	}

	type wantExpect struct {
		want              string
		wantErr           bool
		wantLinesToIgnore []int
	}

	want := []wantExpect{
		{
			want: `[
			{
			  "_kics_lines": {
				"_kics__default": {
				  "_kics_line": 0
				},
				"_kics_martin": {
				  "_kics_line": 3
				}
			  },
			  "martin": {
				"_kics_lines": {
				  "_kics__default": {
					"_kics_line": 3
				  },
				  "_kics_name": {
					"_kics_line": 4
				  }
				},
				"name": "test"
			  }
			},
			{
			  "_kics_lines": {
				"_kics__default": {
				  "_kics_line": 0
				},
				"_kics_martin2": {
				  "_kics_line": 6
				}
			  },
			  "martin2": {
				"_kics_lines": {
				  "_kics__default": {
					"_kics_line": 6
				  },
				  "_kics_name": {
					"_kics_line": 7
				  }
				},
				"name": "test2"
			  }
			}
		  ]
		  `,
			wantErr:           false,
			wantLinesToIgnore: []int{3, 2, 4},
		},
		{
			want: `[
			{
			  "_kics_lines": {
				"_kics__default": {
				  "_kics_arr": [
					{
					  "_kics__default": {
						"_kics_line": 4
					  },
					  "_kics_amazon.aws.aws_s3": {
						"_kics_line": 5
					  },
					  "_kics_name": {
						"_kics_line": 4
					  }
					}
				  ],
				  "_kics_line": 0
				}
			  },
			  "playbooks": [
				{
				  "amazon.aws.aws_s3": {
					"_kics_lines": {
					  "_kics__default": {
						"_kics_line": 5
					  },
					  "_kics_bucket": {
						"_kics_line": 6
					  },
					  "_kics_mode": {
						"_kics_line": 7
					  },
					  "_kics_permission": {
						"_kics_line": 8
					  }
					},
					"bucket": "mybucket",
					"mode": "create",
					"permission": "authenticated-read"
				  },
				  "name": "Create an empty bucket2"
				}
			  ]
			}
		  ]
		  `,
			wantErr:           false,
			wantLinesToIgnore: []int{4, 3, 5, 6, 7, 8},
		},
		{
			want: `[
			{
			  "_kics_lines": {
				"_kics__default": {
				  "_kics_line": 0
				},
				"_kics_test": {
				  "_kics_arr": [
					{
					  "_kics__default": {
						"_kics_line": 4
					  },
					  "_kics_group": {
						"_kics_line": 4
					  }
					}
				  ],
				  "_kics_line": 2
				},
				"_kics_test_2": {
				  "_kics_line": 7
				}
			  },
			  "test": [
				{
				  "group": {
					"_kics_lines": {
					  "_kics__default": {
						"_kics_line": 4
					  },
					  "_kics_name": {
						"_kics_line": 6
					  }
					},
					"name": "cx"
				  }
				}
			  ],
			  "test_2": {
				"_kics_lines": {
				  "_kics__default": {
					"_kics_line": 7
				  },
				  "_kics_perm": {
					"_kics_arr": [
					  {
						"_kics_<<": {
						  "_kics_line": 9
						},
						"_kics__default": {
						  "_kics_line": 9
						}
					  }
					],
					"_kics_line": 8
				  }
				},
				"perm": [
					{
						"_kics_lines": {
							"_kics__default": {
								"_kics_line": 9
							}
						},
						"group": {
							"_kics_lines": {
								"_kics__default": {
									"_kics_line": 4
								},
								"_kics_name": {
									"_kics_line": 6
								}
							},
							"name": "cx"
						}
					}
				]
			  }
			}
		  ]
		  `,
			wantErr:           false,
			wantLinesToIgnore: []int{5, 6},
		},
		{
			want:              "{}",
			wantErr:           true,
			wantLinesToIgnore: []int{},
		},
		{
			want: `[
				{
					"_kics_lines": {
						"_kics__default": {
							"_kics_line": 0
						},
						"_kics_resources": {
							"_kics_arr": [
								{
									"_kics__default": {
										"_kics_line": 3
									},
									"_kics_name": {
										"_kics_line": 3
									},
									"_kics_type": {
										"_kics_line": 4
									}
								},
								{
									"_kics__default": {
										"_kics_line": 5
									},
									"_kics_name": {
										"_kics_line": 5
									},
									"_kics_properties": {
										"_kics_line": 7
									},
									"_kics_type": {
										"_kics_line": 6
									}
								}
							],
							"_kics_line": 2
						}
					},
					"resources": [
						{
							"name": "my-vm-access",
							"type": "my-vm-access"
						},
						{
							"name": "my-vm",
							"properties": {
								"_kics_lines": {
									"_kics__default": {
										"_kics_line": 7
									},
									"_kics_serviceAccountId": {
										"_kics_line": 8
									}
								},
								"serviceAccountId": "my-vm-access"
							},
							"type": "vm.jinja"
						}
					]
				}
			]`,
			wantErr:           false,
			wantLinesToIgnore: []int(nil),
		},
	}

	for idx, tt := range have {
		t.Run(fmt.Sprintf("test_parse_case_%d", idx), func(t *testing.T) {
			doc, linesToIgnore, err := p.Parse("test.yaml", []byte(tt))
			if want[idx].wantErr {
				require.Error(t, err)
			} else {
				require.Equal(t, want[idx].wantLinesToIgnore, linesToIgnore)
				require.NoError(t, err)
				compareJSONLine(t, doc, want[idx].want)
			}
		})
	}
}

func compareJSONLine(t *testing.T, test1 interface{}, test2 string) {
	stringefiedJSON, err := json.Marshal(&test1)
	require.NoError(t, err)
	require.JSONEq(t, test2, string(stringefiedJSON))
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

	resolved, err := parser.Resolve([]byte(have), "test.yaml", true, 15)
	require.NoError(t, err)
	require.Equal(t, []byte(have), resolved)
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
		wantErr  bool
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
			wantErr:  false,
		},
		{
			name: "test_process_elements not string",
			args: args{
				elements: map[string]interface{}{
					"certificate": map[string]interface{}{
						"swagger_file": "test",
						"certificate":  filepath.Join("..", "..", "..", "test", "fixtures", "test_certificate", "certificate.pem"),
					},
				},
				filePath: filepath.Join("..", "..", "..", "test", "fixtures", "test_certificate", "certificate.pem"),
			},
			wantErr: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			processElements(tt.args.elements, tt.args.filePath)
			if tt.wantErr {
				require.Error(t, errors.New("Failed to parse certificate: ..\\..\\..\\test\\fixtures\\test_certificate\\certificate.pem"))
			} else {
				require.Equal(t, tt.wantCert, tt.args.elements["certificate"])
				require.Equal(t, tt.wantSwag, tt.args.elements["swagger_file"])
			}
		})
	}
}

func TestModel_TestYamlParser(t *testing.T) {
	tests := []struct {
		name    string
		sample  string
		want    string
		wantErr bool
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
			want:    `[]`,
			wantErr: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			parser := Parser{}
			got, _, err := parser.Parse("", []byte(tt.sample))
			if tt.wantErr {
				require.Error(t, err)
			} else {
				require.NoError(t, err)
				compareJSONLine(t, got, tt.want)
			}
		})
	}
}

// Test_GetCommentToken must get the token that represents a comment
func Test_GetCommentToken(t *testing.T) {
	parser := &Parser{}
	require.Equal(t, "#", parser.GetCommentToken())
}

func TestYAML_StringifyContent(t *testing.T) {
	type fields struct {
		parser Parser
	}
	type args struct {
		content []byte
	}
	tests := []struct {
		name    string
		fields  fields
		args    args
		want    string
		wantErr bool
	}{
		{
			name: "test stringify content",
			fields: fields{
				parser: Parser{},
			},
			args: args{
				content: []byte(`
martin:
  name: test
---
martin2:
  name: test2
`),
			},
			want: `
martin:
  name: test
---
martin2:
  name: test2
`,
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := tt.fields.parser.StringifyContent(tt.args.content)
			require.Equal(t, tt.wantErr, (err != nil))
			require.Equal(t, tt.want, got)
		})
	}
}

func TestParser_GetResolvedFiles(t *testing.T) {
	type fields struct {
		resolvedFiles map[string]model.ResolvedFile
	}
	tests := []struct {
		name   string
		fields fields
		want   map[string]model.ResolvedFile
	}{
		{
			name: "test get resolved files",
			fields: fields{
				resolvedFiles: map[string]model.ResolvedFile{
					"test": {
						Content: []byte(`1`),
					},
				},
			},
			want: map[string]model.ResolvedFile{
				"test": {
					Content: []byte(`1`),
				},
			},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			p := &Parser{
				resolvedFiles: tt.fields.resolvedFiles,
			}
			if got := p.GetResolvedFiles(); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("GetResolvedFiles() = %v, want %v", got, tt.want)
			}
		})
	}
}
