package scan

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/Checkmarx/kics/assets"
	"github.com/Checkmarx/kics/pkg/engine/provider"
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

func Test_GetFileSystemSourceProvider(t *testing.T) {
	tests := []struct {
		name           string
		paths          []string
		scanParams     Parameters
		expectedOutput provider.FileSystemSourceProvider
		expectedError  bool
	}{
		{
			name: "get FileSystemSourceProvider",
			scanParams: Parameters{
				PayloadPath: "",
				ExcludePaths: []string{
					filepath.Join("..", "..", "assets", "queries", "terraform", "alicloud", "action_trail_logging_all_regions_disabled", "test", "positive_expected_result.json"),
					filepath.Join("..", "..", "assets", "queries", "terraform", "alicloud", "action_trail_logging_all_regions_disabled", "metadata.json"),
					filepath.Join("..", "..", "assets", "queries", "terraform", "alicloud", "actiontrail_trail_oss_bucket_is_publicly_accessible", "metadata.json"),
					filepath.Join("..", "..", "assets", "queries", "terraform", "alicloud", "actiontrail_trail_oss_bucket_is_publicly_accessible", "test", "positive_expected_result.json"),
				},
			},
			paths: []string{
				filepath.Join("..", "..", "assets", "queries", "terraform", "alicloud", "action_trail_logging_all_regions_disabled"),
				filepath.Join("..", "..", "assets", "queries", "terraform", "alicloud", "actiontrail_trail_oss_bucket_is_publicly_accessible"),
			},
			expectedOutput: provider.FileSystemSourceProvider{
				Paths: []string{
					filepath.Join("..", "..", "assets", "queries", "terraform", "alicloud", "action_trail_logging_all_regions_disabled"),
					filepath.Join("..", "..", "assets", "queries", "terraform", "alicloud", "actiontrail_trail_oss_bucket_is_publicly_accessible"),
				},
				Excludes: map[string][]os.FileInfo{
					"positive_expected_result.json": {},
					"metadata.json":                 {},
				},
			},
			expectedError: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			c := &Client{}
			c.ScanParams = &tt.scanParams
			v, err := c.getFileSystemSourceProvider(tt.paths)

			for k := range tt.expectedOutput.Excludes {
				require.Contains(t, (*v).Excludes, k)
			}
			require.ElementsMatch(t, tt.expectedOutput.Paths, (*v).Paths)
			if tt.expectedError {
				require.Error(t, err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}
