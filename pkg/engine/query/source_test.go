package query

import (
	"io/ioutil"
	"path/filepath"
	"reflect"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/test"
)

// BenchmarkFilesystemSource_GetQueries benchmarks getQueries to see improvements
func BenchmarkFilesystemSource_GetQueries(b *testing.B) {
	if err := test.ChangeCurrentDir("kics"); err != nil {
		b.Fatal(err)
	}
	type fields struct {
		Source []string
	}
	tests := []struct {
		name   string
		fields fields
	}{
		{
			name: "testing_all_paths",
			fields: fields{
				Source: []string{
					"./assets/queries/",
				},
			},
		},
		{
			name: "testing_single_path",
			fields: fields{
				Source: []string{
					"./assets/queries/dockerfile",
				},
			},
		},
		{
			name: "testing_multiple_path",
			fields: fields{
				Source: []string{
					"./assets/queries/dockerfile",
					"./assets/queries/terraform",
				},
			},
		},
	}
	for _, tt := range tests {
		b.Run(tt.name, func(b *testing.B) {
			s := &FilesystemSource{
				Source: tt.fields.Source,
			}
			for n := 0; n < b.N; n++ {
				if _, err := s.GetQueries(); err != nil {
					b.Errorf("Error: %s", err)
				}
			}
		})
	}
}

// TestFilesystemSource_GetGenericQuery tests the functions [GetGenericQuery()] and all the methods called by them
func TestFilesystemSource_GetGenericQuery(t *testing.T) { // nolint
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Fatal(err)
	}
	type fields struct {
		Source []string
	}
	type args struct {
		platform string
	}
	tests := []struct {
		name     string
		fields   fields
		args     args
		contains string
		wantErr  bool
	}{
		{
			name: "get_generic_query_terraform",
			fields: fields{
				Source: []string{"./assets/queries/template"},
			},
			args: args{
				platform: "terraform",
			},
			contains: "generic.terraform",
			wantErr:  false,
		},
		{
			name: "get_generic_query_common",
			fields: fields{
				Source: []string{"./assets/queries/template"},
			},
			args: args{
				platform: "common",
			},
			contains: "generic.common",
			wantErr:  false,
		},
		{
			name: "get_generic_query_cloudformation",
			fields: fields{
				Source: []string{"./assets/queries/template"},
			},
			args: args{
				platform: "cloudFormation",
			},
			contains: "generic.cloudformation",
			wantErr:  false,
		},
		{
			name: "get_generic_query_ansible",
			fields: fields{
				Source: []string{"./assets/queries/template"},
			},
			args: args{
				platform: "ansible",
			},
			contains: "generic.ansible",
			wantErr:  false,
		},
		{
			name: "get_generic_query_dockerfile",
			fields: fields{
				Source: []string{"./assets/queries/template"},
			},
			args: args{
				platform: "dockerfile",
			},
			contains: "generic.dockerfile",
			wantErr:  false,
		},
		{
			name: "get_generic_query_k8s",
			fields: fields{
				Source: []string{"./assets/queries/template"},
			},
			args: args{
				platform: "k8s",
			},
			contains: "generic.k8s",
			wantErr:  false,
		},
		{
			name: "get_generic_query_unknown",
			fields: fields{
				Source: []string{"./assets/queries/template"},
			},
			args: args{
				platform: "unknown",
			},
			contains: "generic.common",
			wantErr:  false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			s := &FilesystemSource{
				Source: tt.fields.Source,
			}
			got, err := s.GetGenericQuery(tt.args.platform)
			if (err != nil) != tt.wantErr {
				t.Errorf("FilesystemSource.GetGenericQuery() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !strings.Contains(got, tt.contains) {
				t.Errorf("FilesystemSource.GetGenericQuery() = %v, doesn't contains %v", got, tt.contains)
			}
		})
	}
}

// TestFilesystemSource_GetQueries tests the functions [GetQueries()] and all the methods called by them
func TestFilesystemSource_GetQueries(t *testing.T) {
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Fatal(err)
	}

	contentByte, err := ioutil.ReadFile(filepath.FromSlash("./test/fixtures/get_queries_test/content_get_queries.rego"))
	require.NoError(t, err)

	type fields struct {
		Source []string
	}
	tests := []struct {
		name    string
		fields  fields
		want    []model.QueryMetadata
		wantErr bool
	}{
		{
			name: "get_queries_1",
			fields: fields{
				Source: []string{filepath.FromSlash("./test/fixtures/all_auth_users_get_read_access")},
			},
			want: []model.QueryMetadata{
				{
					Query:   "all_auth_users_get_read_access",
					Content: string(contentByte),
					Metadata: map[string]interface{}{
						"category":        "Identity and Access Management",
						"descriptionText": "Misconfigured S3 buckets can leak private information to the entire internet or allow unauthorized data tampering / deletion", //nolint
						"descriptionUrl":  "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#acl",
						"id":              "57b9893d-33b1-4419-bcea-a717ea87e139",
						"queryName":       "All Auth Users Get Read Access",
						"severity":        "HIGH",
					},
					Platform: "unknown",
				},
			},
			wantErr: false,
		},
		{
			name: "get_queries_error",
			fields: fields{
				Source: []string{"../no-path"},
			},
			want:    nil,
			wantErr: true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			s := &FilesystemSource{
				Source: tt.fields.Source,
			}
			got, err := s.GetQueries()
			if (err != nil) != tt.wantErr {
				t.Errorf("FilesystemSource.GetQueries() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			require.Equal(t, tt.want, got)
		})
	}
}

// Test_ReadMetadata tests the functions [GetQueries()] and all the methods called by them (Tets, getting multiple queries types)
func TestFilesystemSource_GetQueriesByType(t *testing.T) {
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Fatal(err)
	}
	type fields struct {
		Source []string
	}
	tests := []struct {
		name    string
		fields  fields
		want    int
		wantErr bool
	}{
		{
			name: "test_multiple_paths",
			fields: fields{
				Source: []string{
					"test/fixtures/type-test01",
					"test/fixtures/type-test02",
				},
			},
			want:    5,
			wantErr: false,
		},
		{
			name: "test_path_type-test01",
			fields: fields{
				Source: []string{
					"test/fixtures/type-test01",
				},
			},
			want:    3,
			wantErr: false,
		},
		{
			name: "test_path_type-test02",
			fields: fields{
				Source: []string{
					"test/fixtures/type-test02",
				},
			},
			want:    2,
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			s := &FilesystemSource{
				Source: tt.fields.Source,
			}
			got, err := s.GetQueries()
			if (err != nil) != tt.wantErr {
				t.Errorf("FilesystemSource.GetQueries() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			require.Equal(t, tt.want, len(got))
		})
	}
}

// Test_ReadMetadata tests the functions [ReadMetadata()] and all the methods called by them
func Test_ReadMetadata(t *testing.T) {
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Fatal(err)
	}
	type args struct {
		queryDir string
	}
	tests := []struct {
		name string
		args args
		want map[string]interface{}
	}{
		{
			name: "read_metadata_error",
			args: args{
				queryDir: "error-path",
			},
			want: nil,
		},
		{
			name: "read_metadata_template",
			args: args{
				queryDir: filepath.FromSlash("./assets/queries/template"),
			},
			want: map[string]interface{}{
				"category":        nil,
				"descriptionText": "<TEXT>",
				"descriptionUrl":  "#",
				"id":              "<ID>",
				"queryName":       "<QUERY_NAME>",
				"severity":        "HIGH",
			},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := ReadMetadata(tt.args.queryDir); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("readMetadata() = %v, want %v", got, tt.want)
			}
		})
	}
}

// Test_getPlatform tests the functions [getPlatform()] and all the methods called by them
func Test_getPlatform(t *testing.T) {
	type args struct {
		queryPath string
	}
	tests := []struct {
		name string
		args args
		want string
	}{
		{
			name: "get_platform_commonQuery",
			args: args{
				queryPath: "../test/commonQuery/test",
			},
			want: "commonQuery",
		},
		{
			name: "get_platform_ansible",
			args: args{
				queryPath: "../test/ansible/test",
			},
			want: "ansible",
		},
		{
			name: "get_platform_cloudFormation",
			args: args{
				queryPath: "../test/cloudFormation/test",
			},
			want: "cloudFormation",
		},
		{
			name: "get_platform_dockerfile",
			args: args{
				queryPath: "../test/dockerfile/test",
			},
			want: "dockerfile",
		},
		{
			name: "get_platform_k8s",
			args: args{
				queryPath: "../test/k8s/test",
			},
			want: "k8s",
		},
		{
			name: "get_platform_terraform",
			args: args{
				queryPath: "../test/terraform/test",
			},
			want: "terraform",
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := getPlatform(tt.args.queryPath); got != tt.want {
				t.Errorf("getPlatform() = %v, want %v", got, tt.want)
			}
		})
	}
}
