package utils

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestLineCounter(t *testing.T) {
	tests := []struct {
		name      string
		want      int
		filePath  string
		wantError bool
	}{
		{
			name:      "Get lines from non existent file",
			want:      0,
			filePath:  "../../Dockerfile2",
			wantError: true,
		},
		{
			name:      "Get lines from a dockerfile file",
			want:      7,
			filePath:  "../../test/fixtures/dockerfile/Dockerfile-example",
			wantError: false,
		},
		{
			name:      "Get lines from a yaml file",
			want:      25,
			filePath:  "../../test/assets/sample_K8S_CONFIG_FILE.yaml",
			wantError: false,
		},
		{
			name:      "Get lines from a minified json file",
			want:      31973,
			filePath:  "../../e2e/fixtures/samples/blacklisted-files/azurepipelinesvscode/service-schema.min.json",
			wantError: false,
		},
		{
			name:      "Get lines from a invalid minified json file",
			want:      100,
			filePath:  "../../test/assets/invalid.min.json",
			wantError: true,
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			got, err := LineCounter(test.filePath, 100)
			if test.wantError {
				require.NotEqual(t, err, nil)
				require.Equal(t, test.want, got)
			} else {
				require.Equal(t, test.want, got)
				require.Equal(t, err, nil)
			}

		})
	}
}

func TestCountLines(t *testing.T) {
	tests := []struct {
		name  string
		input string
		want  int
	}{
		{"empty", "", 0},
		{"one line", "abc", 1},
		{"two lines LF", "abc\ndef", 2},
		{"two lines CF", "abc\rdef", 2},
		{"three lines CRLF", "a\r\nb\r\nc", 3},
		{"four lines mixed", "a\nb\rc\r\nd", 4},
		{"ends with newline", "a\nb\n", 2},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			require.Equal(t, tt.want, countLines(tt.input))
		})
	}
}
