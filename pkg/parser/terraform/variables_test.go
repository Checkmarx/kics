package terraform

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/parser/terraform/converter"
	"github.com/stretchr/testify/require"
	"github.com/zclconf/go-cty/cty"
)

// filepath: filepath.FromSlash("../../test/fixtures/test_helm"),

type mergeMapsTest struct {
	name string
	args struct {
		baseMap converter.VariableMap
		newMap  converter.VariableMap
	}
	want converter.VariableMap
}

type inputVarTest struct {
	name     string
	filename string
	want     converter.VariableMap
	wantErr  bool
}

func TestMergeMaps(t *testing.T) {
	tests := []mergeMapsTest{
		{
			name: "Should merge the second map on the first map",
			args: struct {
				baseMap converter.VariableMap
				newMap  converter.VariableMap
			}{
				baseMap: converter.VariableMap{
					"test": cty.StringVal("test"),
				},
				newMap: converter.VariableMap{
					"new": cty.StringVal("new"),
				},
			},
			want: converter.VariableMap{
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
	t.Cleanup(func() {
		inputVariableMap = make(converter.VariableMap)
	})
}

func TestSetInputVariablesDefaultValues(t *testing.T) {
	tests := []inputVarTest{
		{
			name:     "Should get default variable values from tf file",
			filename: filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_variables", "test.tf"),
			want: converter.VariableMap{
				"local_default_var": cty.StringVal("local_default"),
			},
			wantErr: false,
		},
		{
			name:     "Should get default variable values from tf file",
			filename: filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_variables", "variables.tf"),
			want: converter.VariableMap{
				"default_var_file": cty.StringVal("default_var_file"),
			},
			wantErr: false,
		},
		{
			name:     "Should get empty map from variable blockless file",
			filename: filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_variables", "test_without_variables_block.tf"),
			want:     converter.VariableMap{},
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
	t.Cleanup(func() {
		inputVariableMap = make(converter.VariableMap)
	})
}

func TestGetInputVariablesFromFile(t *testing.T) {
	tests := []inputVarTest{
		{
			name:     "Should get variables from file",
			filename: filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_variables", "variable_set.auto.tfvars"),
			want: converter.VariableMap{
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
			filename: filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_variables", "invalid.auto.tfvars"),
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
	t.Cleanup(func() {
		inputVariableMap = make(converter.VariableMap)
	})
}

func TestGetInputVariables(t *testing.T) {
	tests := []inputVarTest{
		{
			name:     "Should load input variables",
			filename: filepath.FromSlash("../../../test/fixtures/test_terraform_variables"),
			want: converter.VariableMap{
				"var": cty.ObjectVal(map[string]cty.Value{
					"test1": cty.BoolVal(false),
					"test2": cty.TupleVal([]cty.Value{cty.BoolVal(false), cty.BoolVal(true)}),
					"map1": cty.ObjectVal(map[string]cty.Value{
						"map1key1": cty.StringVal("map2Key1"),
					}),
					"map2": cty.ObjectVal(map[string]cty.Value{
						"map2Key1": cty.StringVal("nestedMap"),
					}),
					"map3": cty.ObjectVal(map[string]cty.Value{
						"map3Key1": cty.StringVal("givenByVar"),
					}),
					"test_terraform":    cty.StringVal("terraform.tfvars"),
					"default_var_file":  cty.StringVal("default_var_file"),
					"local_default_var": cty.StringVal("local_default"),
				}),
			},
			wantErr: false,
		},
		{
			name:     "Should load input variables",
			filename: filepath.FromSlash("../../../test/fixtures/test_terraform_variables/test_variables_comment_path.tf"),
			want: converter.VariableMap{
				"var": cty.ObjectVal(map[string]cty.Value{
					"map3": cty.ObjectVal(map[string]cty.Value{
						"map3Key1": cty.StringVal("givenByVar"),
					}),
				}),
			},
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			fileContent, _ := os.ReadFile(tt.filename)
			getInputVariables(tt.filename, string(fileContent), "../../../test/fixtures/test_terraform_variables/varsToUse/varsToUse.tf")
			require.Equal(t, tt.want, inputVariableMap)
		})
	}
	t.Cleanup(func() {
		inputVariableMap = make(converter.VariableMap)
		variableCache = make(map[string]converter.VariableMap)
	})
}

func TestBuildVariablesForDirectory(t *testing.T) {
	tests := []struct {
		name              string
		currentPath       string
		terraformVarsPath string
		want              converter.VariableMap
		wantErr           bool
	}{
		{
			name:              "Should build variables from directory with multiple tf files",
			currentPath:       filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_variables"),
			terraformVarsPath: "",
			want: converter.VariableMap{
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
			},
			wantErr: false,
		},
		{
			name:              "Should build variables with custom vars path",
			currentPath:       filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_variables"),
			terraformVarsPath: filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_variables", "varsToUse", "varsToUse.tf"),
			want: converter.VariableMap{
				"test1": cty.BoolVal(false),
				"test2": cty.TupleVal([]cty.Value{cty.BoolVal(false), cty.BoolVal(true)}),
				"map1": cty.ObjectVal(map[string]cty.Value{
					"map1key1": cty.StringVal("map2Key1"),
				}),
				"map2": cty.ObjectVal(map[string]cty.Value{
					"map2Key1": cty.StringVal("nestedMap"),
				}),
				"map3": cty.ObjectVal(map[string]cty.Value{
					"map3Key1": cty.StringVal("givenByVar"),
				}),
				"test_terraform":    cty.StringVal("terraform.tfvars"),
				"default_var_file":  cty.StringVal("default_var_file"),
				"local_default_var": cty.StringVal("local_default"),
			},
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := buildVariablesForDirectory(tt.currentPath, tt.terraformVarsPath)
			if tt.wantErr {
				require.NotNil(t, err)
			} else {
				require.NoError(t, err)
				require.Equal(t, tt.want, got)
			}
		})
	}

	t.Cleanup(func() {
		variableCache = make(map[string]converter.VariableMap)
	})
}

func TestGetInputVariables_Caching(t *testing.T) {
	tests := []struct {
		name             string
		firstCallPath    string
		secondCallPath   string
		shouldUseCache   bool
		expectedVarCount int
	}{
		{
			name:             "Should use cache for same directory",
			firstCallPath:    filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_variables"),
			secondCallPath:   filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_variables"),
			shouldUseCache:   true,
			expectedVarCount: 7,
		},
		{
			name:             "Should not use cache for different directory",
			firstCallPath:    filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_variables"),
			secondCallPath:   filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_variables", "varsToUse"),
			shouldUseCache:   false,
			expectedVarCount: 0,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			variableCache = make(map[string]converter.VariableMap)
			inputVariableMap = make(converter.VariableMap)

			fileContent1, err := os.ReadFile(filepath.Join(tt.firstCallPath, "test.tf"))
			require.NoError(t, err)
			getInputVariables(tt.firstCallPath, string(fileContent1), "")

			cacheSize := len(variableCache)
			require.Equal(t, 1, cacheSize, "cache should have one entry after first call")

			fileContent2, err := os.ReadFile(filepath.Join(tt.secondCallPath, "test.tf"))
			if err != nil {
				fileContent2, err = os.ReadFile(filepath.Join(tt.secondCallPath, "varsToUse.tf"))
			}
			require.NoError(t, err)
			getInputVariables(tt.secondCallPath, string(fileContent2), "")

			if tt.shouldUseCache {
				require.Equal(t, cacheSize, len(variableCache), "cache size should not change when reusing cache")
			} else {
				require.Equal(t, cacheSize+1, len(variableCache), "cache should grow for new directory")
			}

			varObj, ok := inputVariableMap["var"]
			require.True(t, ok, "inputVariableMap should contain 'var' key")
			require.Equal(t, tt.expectedVarCount, len(varObj.AsValueMap()), "wrong number of variables")
		})
	}

	t.Cleanup(func() {
		inputVariableMap = make(converter.VariableMap)
		variableCache = make(map[string]converter.VariableMap)
	})
}
