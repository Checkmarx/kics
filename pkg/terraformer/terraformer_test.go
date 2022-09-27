package terraformer

import (
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestImport(t *testing.T) {
	type args struct {
		terraformerPath string
	}
	tests := []struct {
		name           string
		runTerraformer func(pathOptions *Path, destination string) (string, error)
		args           args
		want           string
		wantErr        bool
	}{
		{
			name: "test import aws",
			runTerraformer: func(pathOptions *Path, destination string) (string, error) {
				return "", nil
			},
			args: args{
				terraformerPath: "aws:subnet:eu-west-2",
			},
			want:    "kics-extract-terraformer",
			wantErr: false,
		},
		{
			name: "test import gcp",
			runTerraformer: func(pathOptions *Path, destination string) (string, error) {
				return "", nil
			},
			args: args{
				terraformerPath: "gcp:instances:us-west4:cosmic-1234",
			},
			want:    "kics-extract-terraformer",
			wantErr: false,
		},
		{
			name: "test import azure",
			runTerraformer: func(pathOptions *Path, destination string) (string, error) {
				return "", nil
			},
			args: args{
				terraformerPath: "azure:storage_account",
			},
			want:    "kics-extract-terraformer",
			wantErr: false,
		},
		{
			name: "test import path error",
			runTerraformer: func(pathOptions *Path, destination string) (string, error) {
				return "", nil
			},
			args: args{
				terraformerPath: "aws",
			},
			want:    ".",
			wantErr: true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			runTerraformerFunc = tt.runTerraformer
			saveTerraformerOutputFunc = func(destination, output string) error { return nil }
			got, err := Import(tt.args.terraformerPath, "")
			os.RemoveAll(got)
			if (err != nil) != tt.wantErr {
				t.Errorf("Import() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !strings.Contains(filepath.Base(got), filepath.Base(tt.want)) {
				t.Errorf("Import() = %v, want %v", filepath.Base(got), filepath.Base(tt.want))
			}
		})
	}
}

func Test_BuildArgs(t *testing.T) {

	tests := []struct {
		name           string
		pathOptions    *Path
		destination    string
		expectedOutput []string
	}{
		{
			name: "test aws build",
			pathOptions: &Path{
				CloudProvider: "aws",
				Regions:       "eu-central-1",
				Resources:     "s3",
				Projects:      "",
			},
			destination:    "some/dest",
			expectedOutput: []string{"import", "aws", "--resources=s3", "-o", "some/dest", "--verbose", "--regions=eu-central-1", "--profile="},
		},
		{
			name: "test gcp build",
			pathOptions: &Path{
				CloudProvider: "gcp",
				Regions:       "eu-central-1",
				Resources:     "google_storage_bucket",
				Projects:      "someProj",
			},
			destination:    "some/dest",
			expectedOutput: []string{"import", "google", "--resources=google_storage_bucket", "-o", "some/dest", "--verbose", "--regions=eu-central-1", "--projects=someProj"},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			v := buildArgs(tt.pathOptions, tt.destination)
			require.Equal(t, tt.expectedOutput, v)
		})
	}
}
