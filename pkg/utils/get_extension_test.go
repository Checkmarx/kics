package utils

import (
	"fmt"
	"os"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestGetExtension(t *testing.T) {
	tests := []struct {
		name     string
		want     string
		err      error
		filePath string
		toCreate bool
	}{
		{
			name:     "Get extension from a file named as Dockerfile and without extension defined ('Dockerfile')",
			want:     "Dockerfile",
			filePath: "../../Dockerfile",
			toCreate: false,
			err:      nil,
		},
		{
			name:     "Get extension from a file not named as Dockerfile and without extension defined ('Dockerfile-example')",
			want:     "possibleDockerfile",
			filePath: "../../test/fixtures/dockerfile/Dockerfile-example",
			toCreate: false,
			err:      nil,
		},
		{
			name:     "Get extension from a file with extension defined ('positive.tf')",
			want:     ".tf",
			filePath: "../../test/fixtures/all_auth_users_get_read_access/test/positive.tf",
			toCreate: false,
			err:      nil,
		},
		{
			name:     "Get empty extension from a file not named as Dockerfile and without extension defined",
			want:     "",
			filePath: "../../test/fixtures/negative_dockerfile/CW671X02_EBM_EVENT_RULE",
			toCreate: false,
			err:      nil,
		},
		{
			name:     "Get error when analyze a folder",
			want:     "",
			filePath: "../../test/fixtures/for_test_folder",
			toCreate: true,
			err:      fmt.Errorf("the path %s is a directory", "../../test/fixtures/for_test_folder"),
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			if test.toCreate {
				err := os.Mkdir(test.filePath, 0755)

				if err != nil {
					require.Nil(t, err, "error creating folder")
				}
			}

			got, err := GetExtension(test.filePath)
			require.Equal(t, test.want, got)
			require.Equal(t, test.err, err)

			if test.toCreate {
				os.RemoveAll(test.filePath)
			}
		})
	}
}
