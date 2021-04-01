package terraform

import (
	"path/filepath"
	"testing"

	"github.com/Checkmarx/kics/pkg/parser/terraform/converter"
	"github.com/stretchr/testify/require"
	"github.com/zclconf/go-cty/cty"
)

// filepath: filepath.FromSlash("../../test/fixtures/test_helm"),

type mergeMapsTest struct {
	name string
	args struct {
		baseMap converter.InputVariableMap
		newMap  converter.InputVariableMap
	}
	want converter.InputVariableMap
}

type fileTest struct {
	name     string
	filename string
	want     string
	wantErr  bool
}

type inputVarTest struct {
	name     string
	filename string
	want     converter.InputVariableMap
	wantErr  bool
}

func TestMergeMaps(t *testing.T) {
	tests := []mergeMapsTest{
		{
			name: "Should merge the second map on the first map",
			args: struct {
				baseMap converter.InputVariableMap
				newMap  converter.InputVariableMap
			}{
				baseMap: converter.InputVariableMap{
					"test": cty.StringVal("test"),
				},
				newMap: converter.InputVariableMap{
					"new": cty.StringVal("new"),
				},
			},
			want: converter.InputVariableMap{
				"test": cty.StringVal("test"),
				"new":  cty.StringVal("new"),
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			mergeMaps(tt.args.baseMap, tt.args.newMap)
			require.Equal(t, tt.want, tt.args.baseMap)
		})
	}
}

func TestParseFile(t *testing.T) {
	tests := []fileTest{
		{
			name:     "Should parse variable file",
			filename: filepath.FromSlash("../../../test/fixtures/test_terraform_variables/terraform.tfvars"),
			want: `test_terraform = "terraform.tfvars"
`,
			wantErr: false,
		},
		{
			name:     "Should parse terraform file",
			filename: filepath.FromSlash("../../../test/fixtures/test_terraform_variables/test.tf"),
			want: `variable "local_default_var" {
  type    = "string"
  default = "local_default"
}

variable "" {
  type    = "string"
  default = "invalid_block"
}

variable "invalid_attr" {
}

resource "test" "test1" {
  test_map        = var.map2
  test_bool       = var.test1
  test_list       = var.test2
  test_neted_map  = var.map2[var.map1["map1key1"]]]

  test_block {
    terraform_var = var.test_terraform
  }

  test_default_local = var.local_default_var
  test_default       = var.default_var
}
`,
			wantErr: false,
		},
		{
			name:     "Should get error when trying to parse inexistent file",
			filename: filepath.FromSlash("not_found.tf"),
			want:     "",
			wantErr:  true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			parsedFile, err := parseFile(tt.filename)
			if tt.wantErr {
				require.NotNil(t, err)
				require.Nil(t, parsedFile)
			} else {
				require.NoError(t, err)
				require.Equal(t, tt.want, string(parsedFile.Bytes))
			}
		})
	}
}

func TestSetInputVariablesDefaultValues(t *testing.T) {
	tests := []inputVarTest{
		{
			name:     "Should get default variable values from tf file",
			filename: filepath.FromSlash("../../../test/fixtures/test_terraform_variables/test.tf"),
			want: converter.InputVariableMap{
				"local_default_var": cty.StringVal("local_default"),
			},
			wantErr: false,
		},
		{
			name:     "Should get default variable values from tf file",
			filename: filepath.FromSlash("../../../test/fixtures/test_terraform_variables/variables.tf"),
			want: converter.InputVariableMap{
				"default_var_file": cty.StringVal("default_var_file"),
			},
			wantErr: false,
		},
		{
			name:     "Should get empty map from variable blockless file",
			filename: filepath.FromSlash("../../../test/fixtures/test_terraform_variables/test_without_variables_block.tf"),
			want:     converter.InputVariableMap{},
			wantErr:  false,
		},
		{
			name:     "Should get an error when trying to set input variables from inexistent file",
			filename: filepath.FromSlash("not_found.tf"),
			want:     nil,
			wantErr:  true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			defaultValues, err := setInputVariablesDefaultValues(tt.filename)
			if tt.wantErr {
				require.NotNil(t, err)
			} else {
				require.NoError(t, err)
			}
			require.Equal(t, tt.want, defaultValues)
		})
	}
}

func TestGetInputVariablesFromFile(t *testing.T) {
	tests := []inputVarTest{
		{
			name:     "Should get variables from file",
			filename: filepath.FromSlash("../../../test/fixtures/test_terraform_variables/variable_set.auto.tfvars"),
			want: converter.InputVariableMap{
				"test1": cty.BoolVal(false),
				"test2": cty.TupleVal([]cty.Value{cty.BoolVal(false), cty.BoolVal(true)}),
				"map1": cty.ObjectVal(map[string]cty.Value{
					"map1key1": cty.StringVal("map2Key1"),
				}),
				"map2": cty.ObjectVal(map[string]cty.Value{
					"map2Key1": cty.StringVal("nestedMap"),
				}),
			},
			wantErr: false,
		},
		{
			name:     "Should get an error when trying to set input variables from inexistent file",
			filename: filepath.FromSlash("../../../test/fixtures/test_terraform_variables/invalid.auto.tfvars"),
			want:     nil,
			wantErr:  true,
		},
		{
			name:     "Should get an error when trying to set input variables from inexistent file",
			filename: filepath.FromSlash("not_found.tf"),
			want:     nil,
			wantErr:  true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			inputVars, err := getInputVariablesFromFile(tt.filename)
			if tt.wantErr {
				require.NotNil(t, err)
			} else {
				require.NoError(t, err)
			}
			require.Equal(t, tt.want, inputVars)
		})
	}
}

func TestGetInputVariables(t *testing.T) {
	tests := []inputVarTest{
		{
			name:     "Should load input variables",
			filename: filepath.FromSlash("../../../test/fixtures/test_terraform_variables"),
			want: converter.InputVariableMap{
				"var": cty.ObjectVal(map[string]cty.Value{
					"test1": cty.BoolVal(false),
					"test2": cty.TupleVal([]cty.Value{cty.BoolVal(false), cty.BoolVal(true)}),
					"map1": cty.ObjectVal(map[string]cty.Value{
						"map1key1": cty.StringVal("map2Key1"),
					}),
					"map2": cty.ObjectVal(map[string]cty.Value{
						"map2Key1": cty.StringVal("nestedMap"),
					}),
					"test_terraform":    cty.StringVal("terraform.tfvars"),
					"default_var_file":  cty.StringVal("default_var_file"),
					"local_default_var": cty.StringVal("local_default"),
				}),
			},
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			getInputVariables(tt.filename)
			require.Equal(t, tt.want, inputVariableMap)
		})
	}
}
