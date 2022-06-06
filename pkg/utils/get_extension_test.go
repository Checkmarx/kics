package utils

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestGetExtension(t *testing.T) {
	tests := []struct {
		name     string
		want     string
		filePath string
	}{
		{
			name:     "Get extension from a file named as Dockerfile and without extension defined ('Dockerfile')",
			want:     "Dockerfile",
			filePath: "../../Dockerfile",
		},
		{
			name:     "Get extension from a file not named as Dockerfile and without extension defined ('Dockerfile-example')",
			want:     "possibleDockerfile",
			filePath: "../../test/fixtures/dockerfile/Dockerfile-example",
		},
		{
			name:     "Get extension from a file with extension defined ('positive.tf')",
			want:     ".tf",
			filePath: "../../test/fixtures/all_auth_users_get_read_access/test/positive.tf",
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			got := GetExtension(test.filePath)
			require.Equal(t, test.want, got)
		})
	}
}
