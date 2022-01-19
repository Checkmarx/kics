package terraformer

import (
	"path/filepath"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/pkg/terraformer/aws"
	importer "github.com/GoogleCloudPlatform/terraformer/cmd"
	"github.com/GoogleCloudPlatform/terraformer/terraformutils"
)

func TestPath_createTfOptions(t *testing.T) {
	type fields struct {
		CloudProvider string
		Region        []string
		Resource      []string
	}
	type args struct {
		destination string
		region      string
	}
	tests := []struct {
		name   string
		fields fields
		args   args
		want   *importer.ImportOptions
	}{
		{
			name: "test createTfOptions",
			fields: fields{
				CloudProvider: "aws",
				Region:        []string{"us-east-1"},
				Resource:      []string{"subnet"},
			},
			args: args{
				destination: "destination",
				region:      "us-east-1",
			},
			want: &importer.ImportOptions{
				Resources:     []string{"subnet"},
				Excludes:      []string{""},
				PathPattern:   filepath.Join("destination", "{service}"),
				PathOutput:    "generated",
				State:         "local",
				Bucket:        "",
				Profile:       "",
				Verbose:       false,
				Zone:          "",
				Regions:       []string{"us-east-1"},
				Projects:      []string{""},
				ResourceGroup: "",
				Connect:       true,
				Compact:       false,
				Filter:        []string{},
				Plan:          false,
				Output:        "hcl",
				RetryCount:    5,
				RetrySleepMs:  300,
			},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tr := &Path{
				CloudProvider: tt.fields.CloudProvider,
				Region:        tt.fields.Region,
				Resource:      tt.fields.Resource,
			}
			if got := tr.createTfOptions(tt.args.destination, tt.args.region); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("Path.createTfOptions() = %v, want %v", got, tt.want)
			}
		})
	}
}

var mockImporter = func(provider terraformutils.ProviderGenerator, options importer.ImportOptions, args []string) error {
	return nil
}

func TestImport(t *testing.T) {
	type args struct {
		terraformerPath string
	}
	tests := []struct {
		name    string
		args    args
		want    string
		wantErr bool
	}{
		{
			name: "test import",
			args: args{
				terraformerPath: "aws:subnet:eu-west-2",
			},
			want:    "kics-extract-terraformer",
			wantErr: false,
		},
		{
			name: "test import path error",
			args: args{
				terraformerPath: "aws:eu-west-2",
			},
			want:    ".",
			wantErr: true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			aws.ImporterFunc = mockImporter
			got, err := Import(tt.args.terraformerPath, "")
			if (err != nil) != tt.wantErr {
				t.Errorf("Import() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if filepath.Base(got) != filepath.Base(tt.want) {
				t.Errorf("Import() = %v, want %v", filepath.Base(got), filepath.Base(tt.want))
			}
		})
	}
}
