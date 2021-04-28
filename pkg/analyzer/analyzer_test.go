package analyzer

import (
	"path/filepath"
	"sort"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestAnalyzer_Analyze(t *testing.T) {
	tests := []struct {
		name    string
		paths   []string
		want    []string
		wantErr bool
	}{
		{
			name:    "analyze_test_dir_single_path",
			paths:   []string{filepath.FromSlash("../../test/fixtures/analyzer_test")},
			want:    []string{"dockerfile", "cloudformation", "kubernetes", "openapi", "terraform", "ansible"},
			wantErr: false,
		},
		{
			name:    "analyze_test_helm_single_path",
			paths:   []string{filepath.FromSlash("../../test/fixtures/analyzer_test/helm")},
			want:    []string{"kubernetes", "ansible"}, // ansible is added because of unknown type in values.yaml
			wantErr: false,
		},
		{
			name: "analyze_test_multiple_path",
			paths: []string{
				filepath.FromSlash("../../test/fixtures/analyzer_test/Dockerfile"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/terraform.tf")},
			want:    []string{"dockerfile", "terraform"}, // ansible is added because of unknown type in values.yaml
			wantErr: false,
		},
		{
			name: "analyze_test_mult_checks_path",
			paths: []string{
				filepath.FromSlash("../../test/fixtures/analyzer_test/openAPI_test")},
			want:    []string{"kubernetes"}, // ansible is added because of unknown type in values.yaml
			wantErr: false,
		},
		{
			name: "analyze_test_error_path",
			paths: []string{
				filepath.FromSlash("../../test/fixtures/analyzer_test/Dockserfile"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/terraform.tf")},
			want:    []string{}, // ansible is added because of unknown type in values.yaml
			wantErr: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := Analyze(tt.paths)
			if (err != nil) != tt.wantErr {
				t.Errorf("Analyze = %v, wantErr = %v", err, tt.wantErr)
			}
			sort.Strings(tt.want)
			sort.Strings(got)
			require.Equal(t, tt.want, got)
		})
	}
}
