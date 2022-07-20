//go:build !dev
// +build !dev

package aws

import (
	"context"
	"testing"

	importer "github.com/GoogleCloudPlatform/terraformer/cmd"
	"github.com/GoogleCloudPlatform/terraformer/terraformutils"
)

var mockOptions = &importer.ImportOptions{
	Resources:     []string{"subnet"},
	Excludes:      []string{""},
	PathPattern:   "destination",
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
}

func TestCloudProvider_Import(t *testing.T) {
	type args struct {
		ctx         context.Context
		options     *importer.ImportOptions
		destination string
	}
	tests := []struct {
		name    string
		a       CloudProvider
		args    args
		wantErr bool
	}{
		{
			name: "test import",
			a:    CloudProvider{},
			args: args{
				ctx:         context.Background(),
				options:     mockOptions,
				destination: "destination",
			},
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			a := CloudProvider{}
			ImporterFunc = mockImporter
			if err := a.Import(tt.args.ctx, tt.args.options, tt.args.destination); (err != nil) != tt.wantErr {
				t.Errorf("CloudProvider.Import() error = %v, wantErr %v", err, tt.wantErr)
			}
		})
	}
}

var mockImporter = func(provider terraformutils.ProviderGenerator, options importer.ImportOptions, args []string) error {
	return nil
}
