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
		wantErr     bool
	}{
		{
			name:        "analyze_test_dir_single_path",
			paths:       []string{filepath.FromSlash("../../test/fixtures/analyzer_test")},
			wantTypes:   []string{"dockerfile", "cloudformation", "kubernetes", "openapi", "terraform", "ansible", "azureresourcemanager"},
			wantExclude: []string{},
			wantErr:     false,
		},
		{
			name:        "analyze_test_helm_single_path",
			paths:       []string{filepath.FromSlash("../../test/fixtures/analyzer_test/helm")},
			wantTypes:   []string{"kubernetes", "ansible"}, // ansible is added because of unknown type in values.yaml
			wantExclude: []string{},
			wantErr:     false,
		},
		{
			name: "analyze_test_multiple_path",
			paths: []string{
				filepath.FromSlash("../../test/fixtures/analyzer_test/Dockerfile"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/terraform.tf")},
			wantTypes:   []string{"dockerfile", "terraform"}, // ansible is added because of unknown type in values.yaml
			wantExclude: []string{},
			wantErr:     false,
		},
		{
			name: "analyze_test_mult_checks_path",
			paths: []string{
				filepath.FromSlash("../../test/fixtures/analyzer_test/openAPI_test")},
			wantTypes:   []string{"kubernetes"}, // ansible is added because of unknown type in values.yaml
			wantExclude: []string{},             // ansible is added because of unknown type in values.yaml
			wantErr:     false,
		},
		{
			name: "analyze_test_error_path",
			paths: []string{
				filepath.FromSlash("../../test/fixtures/analyzer_test/Dockserfile"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/terraform.tf")},
			wantTypes:   []string{},
			wantExclude: []string{},
			wantErr:     true,
		},
		{
			name: "analyze_test_unwanted_path",
			paths: []string{
				filepath.FromSlash("../../test/fixtures/type-test01/template01/metadata.json"),
			},
			wantTypes:   []string{},
			wantExclude: []string{filepath.FromSlash("../../test/fixtures/type-test01/template01/metadata.json")},
			wantErr:     false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, exc, err := Analyze(tt.paths)
			if (err != nil) != tt.wantErr {
				t.Errorf("Analyze = %v, wantErr = %v", err, tt.wantErr)
			}
			sort.Strings(tt.wantTypes)
			sort.Strings(tt.wantExclude)
			sort.Strings(got)
			sort.Strings(exc)
			require.Equal(t, tt.wantTypes, got, "wrong types from analyzer")
			require.Equal(t, tt.wantExclude, exc, "wrong excludes from analyzer")
		})
	}
}
