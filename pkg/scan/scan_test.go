package scan

import (
	"context"
	"github.com/Checkmarx/kics/v2/assets"
	"github.com/Checkmarx/kics/v2/pkg/engine/source"
	"github.com/Checkmarx/kics/v2/pkg/model"
	consolePrinter "github.com/Checkmarx/kics/v2/pkg/printer"
	"github.com/Checkmarx/kics/v2/pkg/progress"
	"github.com/stretchr/testify/require"
	"path/filepath"
	"testing"
)

func Test_ExecuteScan(t *testing.T) {
	tests := []struct {
		name                 string
		scanParams           Parameters
		ctx                  context.Context
		expectedResultsCount int
		expectedSeverity     model.Severity
		expectedLine         int
	}{
		{
			name: "test exec scan",
			scanParams: Parameters{
				ExcludePaths: []string{
					"./../../test/fixtures/test_scan_cloudfront_logging_disabled/metadata.json",
					"./../../test/fixtures/test_scan_cloudfront_logging_disabled/test/positive_expected_result.tf",
				},
				Path:                    []string{"./../../test/fixtures/test_scan_cloudfront_logging_disabled/test/positive1.yaml"},
				QueriesPath:             []string{"./../../test/fixtures/test_scan_cloudfront_logging_disabled"},
				PreviewLines:            3,
				CloudProvider:           []string{"aws"},
				Platform:                []string{"CloudFormation"},
				ChangedDefaultQueryPath: true,
				MaxFileSizeFlag:         100,
				QueryExecTimeout:        60,
			},
			ctx:                  context.Background(),
			expectedResultsCount: 1,
			expectedSeverity:     "MEDIUM",
			expectedLine:         5,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			c, err := NewClient(&tt.scanParams, &progress.PbBuilder{}, &consolePrinter.Printer{})

			if err != nil {
				t.Fatalf(`NewClient failed for path %s with error: %v`, tt.scanParams.Path[0], err)
			}

			r, err := c.executeScan(tt.ctx)

			if err != nil {
				t.Fatalf(`ExecuteScan failed for path %s with error: %v`, tt.scanParams.Path[0], err)
			}

			resultsCount := len(r.Results)
			require.Equal(t, tt.expectedResultsCount, resultsCount)

			firstResult := &r.Results[0]
			require.Equal(t, tt.expectedSeverity, firstResult.Severity)
		})
	}
}

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
