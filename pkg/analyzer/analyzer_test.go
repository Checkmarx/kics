package analyzer

import (
	"path/filepath"
	"sort"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestAnalyzer_Analyze(t *testing.T) {
	tests := []struct {
		name  string
		paths []string
		want  []string
	}{
		{
			name:  "analyze_test_dir_single_path",
			paths: []string{filepath.FromSlash("../../test/fixtures/analyzer_test")},
			want:  []string{"dockerfile", "cloudformation", "kubernetes", "openapi", "terraform", "ansible"},
		},
		{
			name:  "analyze_test_helm_single_path",
			paths: []string{filepath.FromSlash("../../test/fixtures/test_helm")},
			want:  []string{"kubernetes", "ansible"}, // ansible is added because of unknown type in values.yaml
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := Analyze(tt.paths)
			sort.Strings(tt.want)
			sort.Strings(got)
			require.Equal(t, tt.want, got)
		})
	}
}
