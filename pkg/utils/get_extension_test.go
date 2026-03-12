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
			want:     ".dockerfile",
			filePath: "../../Dockerfile",
			toCreate: false,
			err:      nil,
		},
		{
			name:     "Get extension from a file named as dockerFILE and without extension defined ('dockerFILE')",
			want:     ".dockerfile",
			filePath: "../../test/fixtures/dockerfile/dockerFILE",
			toCreate: false,
			err:      nil,
		},
		{
			name:     "Get extension from a file not named 'dockerfile' with extension defined as Dockerfile ('file.Dockerfile')",
			want:     ".dockerfile",
			filePath: "../../test/fixtures/dockerfile/file.Dockerfile",
			toCreate: false,
			err:      nil,
		},
		{
			name:     "Get extension from a file not named 'dockerfile' with extension defined as DOCKERfile ('file_2.DOCKERfile')",
			want:     ".dockerfile",
			filePath: "../../test/fixtures/dockerfile/file_2.DOCKERfile",
			toCreate: false,
			err:      nil,
		},
		{
			name:     "Get extension from a file named 'Dockerfile' with any extension defined ('Dockerfile.something')",
			want:     ".dockerfile",
			filePath: "../../test/fixtures/dockerfile/Dockerfile.something",
			toCreate: false,
			err:      nil,
		},
		{
			name:     "Get extension from a file named 'DOCKERfile' with any extension defined ('DOCKERfile.txt')",
			want:     ".dockerfile",
			filePath: "../../test/fixtures/dockerfile/DOCKERfile.txt",
			toCreate: false,
			err:      nil,
		},
		{
			name:     "Get extension from a file not named as Dockerfile and without a relevant extension defined ('any_file.txt'), should detect due to parent folder 'docker'",
			want:     ".dockerfile",
			filePath: "../../test/fixtures/dockerfile/test_folder_names/docker/any_file.txt",
			toCreate: false,
			err:      nil,
		},
		{
			name:     "Get extension from a file not named as Dockerfile and without a relevant extension defined ('any_file.txt'), should detect due to parent folder 'Docker'",
			want:     ".dockerfile",
			filePath: "../../test/fixtures/dockerfile/test_folder_names_case/Docker/any_file.txt",
			toCreate: false,
			err:      nil,
		},
		{
			name:     "Get extension from a file not named as Dockerfile and without a relevant extension defined ('any_file.txt'), should detect due to parent folder 'dockerfile'",
			want:     ".dockerfile",
			filePath: "../../test/fixtures/dockerfile/test_folder_names/dockerfile/any_file.txt",
			toCreate: false,
			err:      nil,
		},
		{
			name:     "Get extension from a file not named as Dockerfile and without a relevant extension defined ('any_file.txt'), should detect due to parent folder 'Dockerfile'",
			want:     ".dockerfile",
			filePath: "../../test/fixtures/dockerfile/test_folder_names_case/Dockerfile/any_file.txt",
			toCreate: false,
			err:      nil,
		},
		{
			name:     "Get extension from a file not named as Dockerfile and without a relevant extension defined ('any_file.txt'), should detect due to parent folder 'dockerfiles'",
			want:     ".dockerfile",
			filePath: "../../test/fixtures/dockerfile/test_folder_names/dockerfiles/any_file.txt",
			toCreate: false,
			err:      nil,
		},
		{
			name:     "Get extension from a file not named as Dockerfile and without a relevant extension defined ('any_file.txt'), should detect due to parent folder 'Dockerfiles'",
			want:     ".dockerfile",
			filePath: "../../test/fixtures/dockerfile/test_folder_names_case/Dockerfiles/any_file.txt",
			toCreate: false,
			err:      nil,
		},
		{
			name:     "Get extension from a file not named as Dockerfile and without extension defined ('random_name'), due to parent folder scan will identify dockerfile syntax regardless",
			want:     ".dockerfile",
			filePath: "../../test/fixtures/dockerfile/random_name",
			toCreate: false,
			err:      nil,
		},
		{
			name:     "Get extension from a valid text file with dockerfile syntax and '.ubi8' extension ('any_name.ubi8')",
			want:     ".dockerfile",
			filePath: "../../test/fixtures/dockerfile/any_name.ubi8",
			toCreate: false,
			err:      nil,
		},
		{
			name:     "Get extension from a valid text file with dockerfile syntax and '.debian' extension ('any_name.debian')",
			want:     ".dockerfile",
			filePath: "../../test/fixtures/dockerfile/any_name.debian",
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
			name:     "Get literal extension from a file not named as Dockerfile and with extension that is not .dockerfile,.ubi8 or .debian, regardless of text syntax",
			want:     ".txt",
			filePath: "../../test/fixtures/negative_dockerfile/not_dockerfile.txt",
			toCreate: false,
			err:      nil,
		},
		{
			name:     "Get literal extension from a valid text file with '.ubi8' extension that lacks relevant dockerfile syntax('any_name.ubi8')",
			want:     ".ubi8",
			filePath: "../../test/fixtures/negative_dockerfile/not_dockerfile.ubi8",
			toCreate: false,
			err:      nil,
		},
		{
			name:     "Get literal extension from a valid text file with '.debian' extension that lacks relevant dockerfile syntax('any_name.debian')",
			want:     ".debian",
			filePath: "../../test/fixtures/negative_dockerfile/not_dockerfile.debian",
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
