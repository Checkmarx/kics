package scan

import (
	"io/ioutil"
	"os"
	"path/filepath"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/analyzer"
	"github.com/Checkmarx/kics/v2/pkg/engine/provider"
	"github.com/Checkmarx/kics/v2/pkg/model"
	consolePrinter "github.com/Checkmarx/kics/v2/pkg/printer"
	"github.com/stretchr/testify/require"
)

func Test_GetQueryPath(t *testing.T) {
	tests := []struct {
		name       string
		scanParams Parameters
		want       int
	}{
		{
			name: "multiple queries path",
			scanParams: Parameters{
				QueriesPath: []string{
					filepath.Join("..", "..", "assets", "queries", "terraform", "aws"),
					filepath.Join("..", "..", "assets", "queries", "terraform", "azure"),
				},
				ChangedDefaultQueryPath: true,
			},
			want: 2,
		},
		{
			name: "single query path",
			scanParams: Parameters{
				QueriesPath: []string{
					filepath.Join("..", "..", "assets", "queries", "terraform", "aws"),
				},
				ChangedDefaultQueryPath: true,
			},
			want: 1,
		},
		{
			name: "default query path",
			scanParams: Parameters{
				QueriesPath: []string{filepath.Join("..", "..", "assets", "queries")},
			},
			want: 1,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			client := Client{
				ScanParams: &tt.scanParams,
			}

			client.GetQueryPath()

			if got := client.ScanParams.QueriesPath; !reflect.DeepEqual(len(got), tt.want) {
				t.Errorf("GetQueryPath() = %v, want %v", len(got), tt.want)
			}
		})
	}
}

func Test_PrintVersionCheck(t *testing.T) {
	tests := []struct {
		name           string
		consolePrinter *consolePrinter.Printer
		modelSummary   *model.Summary
		expectedOutput string
	}{
		{
			name:           "test latest version",
			consolePrinter: consolePrinter.NewPrinter(true),
			modelSummary: &model.Summary{
				Version: "v1.0.0",
				LatestVersion: model.Version{
					Latest:           true,
					LatestVersionTag: "1.0.0",
				},
			},
			expectedOutput: "",
		},
		{
			name:           "test outdated version",
			consolePrinter: consolePrinter.NewPrinter(true),
			modelSummary: &model.Summary{
				Version: "v1.0.0",
				LatestVersion: model.Version{
					Latest:           false,
					LatestVersionTag: "1.1.0",
				},
			},
			expectedOutput: "A new version 'v1.1.0' of KICS is available, please consider updating",
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			rescueStdout := os.Stdout
			r, w, _ := os.Pipe()
			os.Stdout = w

			printVersionCheck(tt.consolePrinter, tt.modelSummary)

			w.Close()
			out, _ := ioutil.ReadAll(r)
			os.Stdout = rescueStdout

			if tt.expectedOutput != "" {
				require.Contains(t, string(out), tt.expectedOutput)
			} else {
				require.Equal(t, tt.expectedOutput, string(out))
			}
		})
	}
}

func Test_ContributionAppeal(t *testing.T) {
	tests := []struct {
		name           string
		consolePrinter *consolePrinter.Printer
		queriesPath    []string
		expectedOutput string
	}{
		{
			name:           "test custom query",
			consolePrinter: consolePrinter.NewPrinter(true),
			queriesPath:    []string{filepath.Join("custom", "query", "path")},
			expectedOutput: "\nAre you using a custom query? If so, feel free to contribute to KICS!\nCheck out how to do it: https://github.com/Checkmarx/kics/blob/master/docs/CONTRIBUTING.md",
		},
		{
			name:           "test non custom query",
			consolePrinter: consolePrinter.NewPrinter(true),
			queriesPath:    []string{filepath.Join("assets", "queries", "path")},
			expectedOutput: "",
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			rescueStdout := os.Stdout
			r, w, _ := os.Pipe()
			os.Stdout = w

			contributionAppeal(tt.consolePrinter, tt.queriesPath)

			w.Close()
			out, _ := ioutil.ReadAll(r)
			os.Stdout = rescueStdout

			if tt.expectedOutput != "" {
				require.Contains(t, string(out), tt.expectedOutput)
			} else {
				require.Equal(t, tt.expectedOutput, string(out))
			}
		})
	}

}

func Test_GetTotalFiles(t *testing.T) {
	tests := []struct {
		name           string
		paths          []string
		expectedOutput int
	}{
		{
			name:           "count utils folder files",
			paths:          []string{filepath.Join("..", "..", "pkg", "utils")},
			expectedOutput: 17,
		},
		{
			name:           "count progress folder files",
			paths:          []string{filepath.Join("..", "..", "pkg", "progress")},
			expectedOutput: 6,
		},
		{
			name:           "count progress and utils folder files",
			paths:          []string{filepath.Join("..", "..", "pkg", "progress"), filepath.Join("..", "..", "pkg", "utils")},
			expectedOutput: 23,
		},
		{
			name:           "count invalid folder",
			paths:          []string{filepath.Join("pkg", "progress")},
			expectedOutput: 0,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {

			v := getTotalFiles(tt.paths)
			require.Equal(t, tt.expectedOutput, v)

		})
	}
}

func Test_LogLoadingQueriesType(t *testing.T) {
	tests := []struct {
		name           string
		types          []string
		expectedOutput string
	}{
		{
			name:           "empty types",
			types:          []string{},
			expectedOutput: "",
		},
		{
			name:           "type terraform",
			types:          []string{"terraform"},
			expectedOutput: "",
		},
		{
			name:           "multiple types",
			types:          []string{"terraform", "cloudformation"},
			expectedOutput: "",
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			rescueStdout := os.Stdout
			r, w, _ := os.Pipe()
			os.Stdout = w

			logLoadingQueriesType(tt.types)

			w.Close()
			out, _ := ioutil.ReadAll(r)
			os.Stdout = rescueStdout

			require.Equal(t, tt.expectedOutput, string(out))

		})
	}

}

func Test_ExtractPathType(t *testing.T) {
	tests := []struct {
		name               string
		paths              []string
		expectedKuberneter []string
		expectedPaths      []string
	}{
		{
			name:               "kuberneter",
			paths:              []string{"kuberneter::*:*:*"},
			expectedKuberneter: []string{"*:*:*"},
			expectedPaths:      []string(nil),
		},
		{
			name:               "count progress and utils folder files",
			paths:              []string{filepath.Join("..", "..", "pkg", "progress"), filepath.Join("..", "..", "pkg", "utils")},
			expectedKuberneter: []string(nil),
			expectedPaths:      []string{filepath.Join("..", "..", "pkg", "progress"), filepath.Join("..", "..", "pkg", "utils")},
		},
		{
			name:               "empty",
			paths:              []string{},
			expectedKuberneter: []string(nil),
			expectedPaths:      []string(nil),
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {

			vPaths, vKuberneter := extractPathType(tt.paths)

			require.Equal(t, tt.expectedKuberneter, vKuberneter)
			require.Equal(t, tt.expectedPaths, vPaths)

		})
	}
}

func Test_CombinePaths(t *testing.T) {
	tests := []struct {
		name           string
		kuberneter     provider.ExtractedPath
		regular        provider.ExtractedPath
		expectedOutput provider.ExtractedPath
	}{
		{
			name: "kuberneter ExtractedPath",
			kuberneter: provider.ExtractedPath{
				Path: []string{""},
				ExtractionMap: map[string]model.ExtractedPathObject{
					"": {
						Path:      "",
						LocalPath: true,
					},
				},
			},
			regular: provider.ExtractedPath{},
			expectedOutput: provider.ExtractedPath{
				Path: []string{""},
				ExtractionMap: map[string]model.ExtractedPathObject{
					"": {
						Path:      "",
						LocalPath: true,
					},
				},
			},
		},
		{
			name: "one regular ExtractedPath",
			regular: provider.ExtractedPath{
				Path: []string{"kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled"},
				ExtractionMap: map[string]model.ExtractedPathObject{
					"": {
						Path:      "./assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled",
						LocalPath: true,
					},
				},
			},
			kuberneter: provider.ExtractedPath{},
			expectedOutput: provider.ExtractedPath{
				Path: []string{"kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled"},
				ExtractionMap: map[string]model.ExtractedPathObject{
					"": {
						Path:      "./assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled",
						LocalPath: true,
					},
				},
			},
		},
		{
			name: "multiple regular ExtractedPath",
			regular: provider.ExtractedPath{
				Path: []string{
					"/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled",
					"/home/miguel/cx/kics/assets/queries/terraform/alicloud/actiontrail_trail_oss_bucket_is_publicly_accessible",
				},
				ExtractionMap: map[string]model.ExtractedPathObject{
					"/tmp/kics-extract-872644142": {
						Path:      "github.com/Checkmarx/kics/pkg/model.ExtractedPathObject",
						LocalPath: true,
					},
					"/tmp/kics-extract-539696053": {
						Path:      "github.com/Checkmarx/kics/pkg/model.ExtractedPathObject",
						LocalPath: true,
					},
				},
			},

			kuberneter: provider.ExtractedPath{},
			expectedOutput: provider.ExtractedPath{
				Path: []string{
					"/home/miguel/cx/kics/assets/queries/terraform/alicloud/action_trail_logging_all_regions_disabled",
					"/home/miguel/cx/kics/assets/queries/terraform/alicloud/actiontrail_trail_oss_bucket_is_publicly_accessible",
				},
				ExtractionMap: map[string]model.ExtractedPathObject{
					"/tmp/kics-extract-872644142": {
						Path:      "github.com/Checkmarx/kics/pkg/model.ExtractedPathObject",
						LocalPath: true,
					},
					"/tmp/kics-extract-539696053": {
						Path:      "github.com/Checkmarx/kics/pkg/model.ExtractedPathObject",
						LocalPath: true,
					},
				},
			},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			extPath := provider.ExtractedPath{
				Path:          []string{},
				ExtractionMap: make(map[string]model.ExtractedPathObject),
			}
			v := combinePaths(tt.kuberneter, tt.regular, extPath, extPath)

			require.Equal(t, tt.expectedOutput, v)
		})
	}
}

func Test_GetLibraryPath(t *testing.T) {

	tests := []struct {
		name           string
		scanParameters Parameters
		expectedError  bool
	}{
		{
			name: "default without flag",
			scanParameters: Parameters{
				LibrariesPath:               "./assets/libraries",
				ChangedDefaultLibrariesPath: false,
			},
			expectedError: false,
		},
		{
			name: "default with flag",
			scanParameters: Parameters{
				LibrariesPath:               filepath.Join("..", "..", "assets", "libraries"),
				ChangedDefaultLibrariesPath: true,
			},
			expectedError: false,
		},
		{
			name: "custom",
			scanParameters: Parameters{
				LibrariesPath:               "./test",
				ChangedDefaultLibrariesPath: true,
			},
			expectedError: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			c := &Client{}

			c.ScanParams = &tt.scanParameters
			_, v := c.getLibraryPath()

			if tt.expectedError {
				require.Error(t, v)
			} else {
				require.NoError(t, v)
			}

		})
	}
}

func Test_PreparePaths(t *testing.T) {

	tests := []struct {
		name            string
		scanParameters  Parameters
		expectedError   bool
		queriesQuantity int
	}{
		{
			name: "default without flag",
			scanParameters: Parameters{
				LibrariesPath:               "./assets/libraries",
				ChangedDefaultLibrariesPath: false,
				QueriesPath: []string{
					filepath.Join("..", "..", "assets", "queries", "terraform", "aws"),
					filepath.Join("..", "..", "assets", "queries", "terraform", "azure"),
				},
				ChangedDefaultQueryPath: true,
			},
			expectedError:   false,
			queriesQuantity: 2,
		},
		{
			name: "default with flag",
			scanParameters: Parameters{
				LibrariesPath:               filepath.Join("..", "..", "assets", "libraries"),
				ChangedDefaultLibrariesPath: true,
				QueriesPath: []string{
					filepath.Join("..", "..", "assets", "queries", "terraform", "aws"),
					filepath.Join("..", "..", "assets", "queries", "terraform", "azure"),
				},
				ChangedDefaultQueryPath: true,
			},
			queriesQuantity: 2,
			expectedError:   false,
		},
		{
			name: "custom",
			scanParameters: Parameters{
				LibrariesPath:               "./test",
				ChangedDefaultLibrariesPath: true,
				QueriesPath: []string{
					filepath.Join("..", "..", "assets", "queries", "terraform", "aws"),
				},
				ChangedDefaultQueryPath: true,
			},
			queriesQuantity: 1,
			expectedError:   true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			c := &Client{}
			c.ScanParams = &tt.scanParameters
			_, _, v := c.preparePaths()

			require.Equal(t, tt.queriesQuantity, len(c.ScanParams.QueriesPath))
			if tt.expectedError {
				require.Error(t, v)
			} else {
				require.NoError(t, v)
			}

		})
	}
}

func Test_AnalyzePaths(t *testing.T) {
	tests := []struct {
		name           string
		analyzer       analyzer.Analyzer
		expectedError  bool
		expectedOutput model.AnalyzedPaths
	}{
		{
			name: "test",
			analyzer: analyzer.Analyzer{
				Paths: []string{
					filepath.Join("..", "..", "assets", "queries", "terraform", "alicloud", "action_trail_logging_all_regions_disabled"),
					filepath.Join("..", "..", "assets", "queries", "terraform", "alicloud", "actiontrail_trail_oss_bucket_is_publicly_accessible"),
				},
				Types:             []string{""},
				ExcludeTypes:      []string{""},
				Exc:               []string{},
				GitIgnoreFileName: ".gitignore",
				ExcludeGitIgnore:  false,
				MaxFileSize:       -1,
			},
			expectedError: false,
			expectedOutput: model.AnalyzedPaths{
				Types: []string{"terraform"},
				Exc: []string{
					filepath.Join("..", "..", "assets", "queries", "terraform", "alicloud", "action_trail_logging_all_regions_disabled", "test", "positive_expected_result.json"),
					filepath.Join("..", "..", "assets", "queries", "terraform", "alicloud", "action_trail_logging_all_regions_disabled", "metadata.json"),
					filepath.Join("..", "..", "assets", "queries", "terraform", "alicloud", "actiontrail_trail_oss_bucket_is_publicly_accessible", "metadata.json"),
					filepath.Join("..", "..", "assets", "queries", "terraform", "alicloud", "actiontrail_trail_oss_bucket_is_publicly_accessible", "test", "positive_expected_result.json"),
				},
			},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			anPaths, err := analyzePaths(&tt.analyzer)
			require.ElementsMatch(t, tt.expectedOutput.Types, anPaths.Types)
			require.ElementsMatch(t, tt.expectedOutput.Exc, anPaths.Exc)
			if tt.expectedError {
				require.Error(t, err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}
