package analyzer

import (
	"path/filepath"
	"sort"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestAnalyzer_Analyze(t *testing.T) {
	tests := []struct {
		name        string
		paths       []string
		wantTypes   []string
		wantExclude []string
		wantExt     []string
		wantErr     bool
	}{
		{
			name:        "analyze_test_dir_single_path",
			paths:       []string{filepath.FromSlash("../../test/fixtures/analyzer_test")},
			wantTypes:   []string{"dockerfile", "googledeploymentmanager", "cloudformation", "kubernetes", "openapi", "terraform", "ansible", "azureresourcemanager"},
			wantExclude: []string{},
			wantExt:     []string{},
			wantErr:     false,
		},
		{
			name:        "analyze_test_helm_single_path",
			paths:       []string{filepath.FromSlash("../../test/fixtures/analyzer_test/helm")},
			wantTypes:   []string{"kubernetes"},
			wantExclude: []string{},
			wantExt:     []string{},
			wantErr:     false,
		},
		{
			name: "analyze_test_multiple_path",
			paths: []string{
				filepath.FromSlash("../../test/fixtures/analyzer_test/Dockerfile"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/terraform.tf")},
			wantTypes:   []string{"dockerfile", "terraform"},
			wantExclude: []string{},
			wantExt:     []string{},
			wantErr:     false,
		},
		{
			name: "analyze_test_multi_checks_path",
			paths: []string{
				filepath.FromSlash("../../test/fixtures/analyzer_test/openAPI_test")},
			wantTypes:   []string{"openapi"},
			wantExclude: []string{},
			wantExt:     []string{},
			wantErr:     false,
		},
		{
			name: "analyze_test_error_path",
			paths: []string{
				filepath.FromSlash("../../test/fixtures/analyzer_test/Dockserfile"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/terraform.tf")},
			wantTypes:   []string{},
			wantExclude: []string{},
			wantExt:     []string{},
			wantErr:     true,
		},
		{
			name: "analyze_test_unwanted_path",
			paths: []string{
				filepath.FromSlash("../../test/fixtures/type-test01/template01/metadata.json"),
			},
			wantTypes:   []string{},
			wantExclude: []string{filepath.FromSlash("../../test/fixtures/type-test01/template01/metadata.json")},
			wantExt:     []string{},
			wantErr:     false,
		},
		{
			name: "analyze_test_tfplan",
			paths: []string{
				filepath.FromSlash("../../test/fixtures/tfplan"),
			},
			wantTypes:   []string{"terraform"},
			wantExclude: []string{},
			wantExt:     []string{},
			wantErr:     false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			res, err := Analyze(tt.paths)
			if (err != nil) != tt.wantErr {
				t.Errorf("Analyze = %v, wantErr = %v", err, tt.wantErr)
			}
			sort.Strings(tt.wantTypes)
			sort.Strings(tt.wantExclude)
			sort.Strings(res.Ext)
			sort.Strings(res.Unwanted)
			sort.Strings(res.Types)
			require.Equal(t, tt.wantTypes, res.Types, "wrong types from analyzer")
			require.Equal(t, tt.wantExclude, res.Unwanted, "wrong excludes from analyzer")
			require.Equal(t, tt.wantExclude, res.Unwanted, "wrong excludes from analyzer")
		})
	}
}
