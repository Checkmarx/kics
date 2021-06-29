package provider

import (
	"testing"

	"github.com/Checkmarx/kics/test"
	"github.com/stretchr/testify/require"
)

func TestProvider_CheckAndExtractZip(t *testing.T) {
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Fatal(err)
	}

	type args struct {
		absPath string
	}
	tests := []struct {
		name      string
		args      args
		wantErr   bool
		wantEmpty bool
	}{
		{
			name: "test_check_and_extract_zip",
			args: args{
				absPath: "test/fixtures/test_zip.zip",
			},
			wantErr:   false,
			wantEmpty: false,
		},
		{
			name: "test_check_and_extract_zip_no_path",
			args: args{
				absPath: "",
			},
			wantErr:   true,
			wantEmpty: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			prov := &ZipSystemSourceProvider{}
			got, err := prov.CheckAndExtractZip(tt.args.absPath)
			if (err != nil) != tt.wantErr {
				t.Errorf("CheckAndExtractZip() = %v, wantErr = %v", err, tt.wantErr)
			}
			if tt.wantEmpty {
				require.Empty(t, got)
			} else {
				require.NotEmpty(t, got)
			}
		})
	}
}
