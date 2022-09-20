package scan

import (
	"path/filepath"
	"testing"

	"github.com/Checkmarx/kics/assets"
	"github.com/Checkmarx/kics/pkg/engine/source"
	"github.com/stretchr/testify/require"
)

func Test_GetSecretsRegexRules(t *testing.T) {
	tests := []struct {
		name           string
		scanParams     Parameters
		expectedError  bool
		expectedOutput string
	}{
		{
			name: "default value",
			scanParams: Parameters{
				SecretsRegexesPath: "",
			},
			expectedOutput: assets.SecretsQueryRegexRulesJSON,
			expectedError:  false,
		},
		{
			name: "custom value",
			scanParams: Parameters{
				SecretsRegexesPath: filepath.Join("..", "..", "assets", "queries", "common", "passwords_and_secrets", "regex_rules.json"),
			},
			expectedOutput: assets.SecretsQueryRegexRulesJSON,
			expectedError:  false,
		},
		{
			name: "invalid path value",
			scanParams: Parameters{
				SecretsRegexesPath: filepath.Join("invalid", "path"),
			},
			expectedOutput: "",
			expectedError:  true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			c := &Client{}
			c.ScanParams = &tt.scanParams
			v, err := getSecretsRegexRules(c.ScanParams.SecretsRegexesPath)

			require.Equal(t, tt.expectedOutput, v)
			if tt.expectedError {
				require.Error(t, err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}

func Test_CreateQueryFilter(t *testing.T) {
	tests := []struct {
		name           string
		scanParams     Parameters
		expectedOutput source.QueryInspectorParameters
	}{
		{
			name: "test empty filter",
			scanParams: Parameters{
				ExcludeQueries:    []string{},
				ExcludeCategories: []string{},
				ExcludeSeverities: []string{},
				IncludeQueries:    []string{},
				InputData:         "",
				BillOfMaterials:   false,
			},
			expectedOutput: source.QueryInspectorParameters{
				ExcludeQueries: source.ExcludeQueries{
					ByIDs:        []string{},
					ByCategories: []string{},
					BySeverities: []string{},
				},
				IncludeQueries: source.IncludeQueries{
					ByIDs: []string{},
				},
				InputDataPath: "",
				BomQueries:    false,
			},
		},
		{
			name: "test query filter with some fields and BoM",
			scanParams: Parameters{
				ExcludeQueries:    []string{"c065b98e-1515-4991-9dca-b602bd6a2fbb"},
				ExcludeCategories: []string{},
				ExcludeSeverities: []string{"info"},
				IncludeQueries:    []string{},
				InputData:         "",
				BillOfMaterials:   true,
			},
			expectedOutput: source.QueryInspectorParameters{
				ExcludeQueries: source.ExcludeQueries{
					ByIDs:        []string{"c065b98e-1515-4991-9dca-b602bd6a2fbb"},
					ByCategories: []string{},
					BySeverities: []string{"info"},
				},
				IncludeQueries: source.IncludeQueries{
					ByIDs: []string{},
				},
				InputDataPath: "",
				BomQueries:    true,
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			c := &Client{}
			c.ScanParams = &tt.scanParams

			v := c.createQueryFilter()

			require.Equal(t, tt.expectedOutput, *v)
		})
	}
}
