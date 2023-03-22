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
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			got, err := LineCounter(test.filePath)
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
