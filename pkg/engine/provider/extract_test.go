package provider

import (
	"testing"

	"github.com/Checkmarx/kics/test"
	"github.com/stretchr/testify/require"
)

func TestProvider_GetSources(t *testing.T) {
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Fatal(err)
	}

	type args struct {
		source   []string
		progress bool
		insecure bool
	}

	tests := []struct {
		name    string
		args    args
		wantErr bool
		want    string
	}{
		{
			name: "test_get_sources",
			args: args{
				source: []string{
					"test/fixtures/test_zip.zip",
				},
				progress: false,
				insecure: false,
			},
			wantErr: false,
			want:    "test/fixtures/test_zip.zip",
		},
		{
			name: "test_get_local_sources",
			args: args{
				source: []string{
					"test/fixtures/all_auth_users_get_read_access",
				},
				progress: false,
				insecure: false,
			},
			wantErr: false,
			want:    "test/fixtures/all_auth_users_get_read_access",
		},
		{
			name: "test_get_error",
			args: args{
				source: []string{
					"test/fixtures/tesstest",
				},
				progress: false,
				insecure: false,
			},
			wantErr: true,
			want:    "",
		},
		{
			name: "test_get_insecure",
			args: args{
				source: []string{
					"test/fixtures/all_auth_users_get_read_access",
				},
				progress: false,
				insecure: true,
			},
			wantErr: false,
			want:    "test/fixtures/all_auth_users_get_read_access",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := GetSources(tt.args.source, tt.args.progress, tt.args.insecure)
			if (err != nil) != tt.wantErr {
				t.Errorf("GetSources() = %v, wantErr = %v", err, tt.wantErr)
			}
			if !tt.wantErr {
				require.NotNil(t, got.Path)
				require.NotNil(t, got.ExtrectionMap)
				require.Equal(t, tt.want, got.ExtrectionMap[got.Path[0]])
			}
		})
	}
}
