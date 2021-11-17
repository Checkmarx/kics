package source

import (
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/test"
)

const (
	source = "./test/fixtures/all_auth_users_get_read_access"
)

// BenchmarkFilesystemSource_GetQueries benchmarks getQueries to see improvements
func BenchmarkFilesystemSource_GetQueries(b *testing.B) {
	if err := test.ChangeCurrentDir("kics"); err != nil {
		b.Fatal(err)
	}
	type fields struct {
		Source         string
		Types          []string
		CloudProviders []string
		Library        string
	}
	tests := []struct {
		name   string
		fields fields
	}{
		{
			name: "testing_all_paths",
			fields: fields{
				Source:         "./assets/queries/",
				Types:          []string{""},
				CloudProviders: []string{""},
				Library:        "./assets/libraries",
			},
		},
	}
	for _, tt := range tests {
		b.Run(tt.name, func(b *testing.B) {
			s := NewFilesystemSource(tt.fields.Source, tt.fields.Types, tt.fields.CloudProviders, tt.fields.Library)
			for n := 0; n < b.N; n++ {
				filter := QueryInspectorParameters{
					IncludeQueries: IncludeQueries{ByIDs: []string{}},
					ExcludeQueries: ExcludeQueries{ByIDs: []string{}, ByCategories: []string{}},
					InputDataPath:  "",
				}
				if _, err := s.GetQueries(&filter); err != nil {
					b.Errorf("Error: %s", err)
				}
			}
		})
	}
}

// TestFilesystemSource_GetQueriesWithExclude test the function GetQuery with QuerySelectionFilter set for Exclude queries
func TestFilesystemSource_GetQueriesWithExclude(t *testing.T) { //nolint
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Fatal(err)
	}
	contentByte, err := os.ReadFile(filepath.FromSlash("./test/fixtures/get_queries_test/content_get_queries.rego"))
	require.NoError(t, err)
	type fields struct {
		Source         string
		Types          []string
		CloudProviders []string
		Library        string
	}
	tests := []struct {
		name              string
		fields            fields
		excludeIDs        []string
		excludeCategory   []string
		excludeSeverities []string
		want              []model.QueryMetadata
		wantErr           bool
	}{
		{
			name: "get_queries_with_exclude_result_1",
			fields: fields{
				Source: source, Types: []string{""},
				CloudProviders: []string{""}, Library: "./assets/libraries",
			},
			excludeCategory:   []string{},
			excludeSeverities: []string{},
			excludeIDs:        []string{"57b9893d-33b1-4419-bcea-a717ea87e4449"},
			want: []model.QueryMetadata{
				{
					Query:     "all_auth_users_get_read_access",
					Content:   string(contentByte),
					InputData: "{}",
					Metadata: map[string]interface{}{
						"category":        "Access Control",
						"descriptionText": "Misconfigured S3 buckets can leak private information to the entire internet or allow unauthorized data tampering / deletion", //nolint
						"descriptionUrl":  "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#acl",
						"id":              "57b9893d-33b1-4419-bcea-b828fb87e318",
						"queryName":       "All Auth Users Get Read Access",
						"severity":        model.SeverityHigh,
						"platform":        "Terraform",
					},
					Platform:    "terraform",
					Aggregation: 1,
				},
			},
			wantErr: false,
		},
		{
			name: "get_queries_with_exclude_no_result_1",
			fields: fields{
				Source: source, Types: []string{""},
				CloudProviders: []string{""}, Library: "./assets/libraries",
			},
			excludeCategory:   []string{},
			excludeIDs:        []string{"57b9893d-33b1-4419-bcea-b828fb87e318"},
			excludeSeverities: []string{},
			want:              []model.QueryMetadata{},
			wantErr:           false,
		},
		{
			name:            "get_queries_with_exclude_error",
			excludeIDs:      []string{"57b9893d-33b1-4419-bcea-b828fb87e318"},
			excludeCategory: []string{},
			fields: fields{
				Source: "../no-path",
			},
			want:    nil,
			wantErr: true,
		},
		{
			name: "get_queries_with_exclude_category_no_result",
			fields: fields{
				Source: source, Types: []string{""},
				CloudProviders: []string{""}, Library: "./assets/libraries",
			},
			excludeCategory:   []string{"Access Control"},
			excludeIDs:        []string{},
			excludeSeverities: []string{},
			want:              []model.QueryMetadata{},
			wantErr:           false,
		},
		{
			name: "get_queries_with_exclude_severity_no_result",
			fields: fields{
				Source: source, Types: []string{""},
				CloudProviders: []string{""}, Library: "./assets/libraries",
			},
			excludeCategory:   []string{},
			excludeIDs:        []string{},
			excludeSeverities: []string{"high"},
			want:              []model.QueryMetadata{},
			wantErr:           false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			s := NewFilesystemSource(tt.fields.Source, []string{""}, []string{""}, tt.fields.Library)
			filter := QueryInspectorParameters{
				IncludeQueries: IncludeQueries{ByIDs: []string{}},
				ExcludeQueries: ExcludeQueries{ByIDs: tt.excludeIDs, ByCategories: tt.excludeCategory, BySeverities: tt.excludeSeverities},
				InputDataPath:  "",
			}
			got, err := s.GetQueries(&filter)
			if (err != nil) != tt.wantErr {
				t.Errorf("FilesystemSource.GetQueries() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			wantStr, err := test.StringifyStruct(tt.want)
			require.Nil(t, err)
			gotStr, err := test.StringifyStruct(got)
			require.Nil(t, err)
			require.Equal(t, tt.want, got, "want = %s\ngot = %s", wantStr, gotStr)
		})
	}
}

// TestFilesystemSource_GetQueriesWithInclude test the function GetQuery with QuerySelectionFilter set for include queries
func TestFilesystemSource_GetQueriesWithInclude(t *testing.T) {
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Fatal(err)
	}

	contentByte, err := os.ReadFile(filepath.FromSlash("./test/fixtures/get_queries_test/content_get_queries.rego"))
	require.NoError(t, err)

	type fields struct {
		Source         string
		Types          []string
		CloudProviders []string
		Library        string
	}
	tests := []struct {
		name       string
		fields     fields
		includeIDs []string
		want       []model.QueryMetadata
		wantErr    bool
	}{
		{
			name: "get_queries_with_include_result_1",
			fields: fields{
				Source: source, Types: []string{""}, CloudProviders: []string{""}, Library: "./assets/libraries",
			},
			includeIDs: []string{"57b9893d-33b1-4419-bcea-b828fb87e318"},
			want: []model.QueryMetadata{
				{
					Query:     "all_auth_users_get_read_access",
					Content:   string(contentByte),
					InputData: "{}",
					Metadata: map[string]interface{}{
						"category":        "Access Control",
						"descriptionText": "Misconfigured S3 buckets can leak private information to the entire internet or allow unauthorized data tampering / deletion", //nolint
						"descriptionUrl":  "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#acl",
						"id":              "57b9893d-33b1-4419-bcea-b828fb87e318",
						"queryName":       "All Auth Users Get Read Access",
						"severity":        model.SeverityHigh,
						"platform":        "Terraform",
					},
					Platform:    "terraform",
					Aggregation: 1,
				},
			},
			wantErr: false,
		},
		{
			name: "get_queries_with_include_no_result_1",
			fields: fields{
				Source: source, Types: []string{""}, CloudProviders: []string{""}, Library: "./assets/libraries",
			},
			includeIDs: []string{"57b9893d-33b1-4419-bcea-xxxxxxx"},
			want:       []model.QueryMetadata{},
			wantErr:    false,
		},
		{
			name:       "get_queries_with_include_error",
			includeIDs: []string{"57b9893d-33b1-4419-bcea-b828fb87e318"},
			fields: fields{
				Source: "../no-path",
			},
			want:    nil,
			wantErr: true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			s := NewFilesystemSource(tt.fields.Source, []string{""}, []string{""}, tt.fields.Library)
			filter := QueryInspectorParameters{
				IncludeQueries: IncludeQueries{
					ByIDs: tt.includeIDs,
				},
				ExcludeQueries: ExcludeQueries{
					ByIDs:        []string{},
					ByCategories: []string{},
				},
				InputDataPath: "",
			}

			got, err := s.GetQueries(&filter)
			if (err != nil) != tt.wantErr {
				t.Errorf("FilesystemSource.GetQueries() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			wantStr, err := test.StringifyStruct(tt.want)
			require.Nil(t, err)
			gotStr, err := test.StringifyStruct(got)
			require.Nil(t, err)

			require.Equal(t, tt.want, got, "want = %s\ngot = %s", wantStr, gotStr)
		})
	}
}

// TestFilesystemSource_GetQueryLibrary tests the functions [GetQueryLibrary()] and all the methods called by them
func TestFilesystemSource_GetQueryLibrary(t *testing.T) { // nolint
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Fatal(err)
	}
	type fields struct {
		Source  string
		Library string
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
				Source:  "./assets/queries/template",
				Library: "./assets/libraries",
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
				Source:  "./assets/queries/template",
				Library: "./assets/libraries",
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
				Source:  "./assets/queries/template",
				Library: "./assets/libraries",
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
				Source:  "./assets/queries/template",
				Library: "./assets/libraries",
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
				Source:  "./assets/queries/template",
				Library: "./assets/libraries",
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
				Source:  "./assets/queries/template",
				Library: "./assets/libraries",
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
				Source:  "./assets/queries/template",
				Library: "./assets/libraries",
			},
			args: args{
				platform: "unknown",
			},
			contains: "",
			wantErr:  true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			s := NewFilesystemSource(tt.fields.Source, []string{""}, []string{""}, tt.fields.Library)

			got, err := s.GetQueryLibrary(tt.args.platform)
			if (err != nil) != tt.wantErr {
				t.Errorf("FilesystemSource.GetQueryLibrary() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !strings.Contains(got.LibraryCode, tt.contains) {
				t.Errorf("FilesystemSource.GetQueryLibrary() = %v, doesn't contains %v", got, tt.contains)
			}
		})
	}
}

// TestFilesystemSource_GetQueries tests the functions [GetQueries()] and all the methods called by them
func TestFilesystemSource_GetQueries(t *testing.T) {
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Fatal(err)
	}

	contentByte, err := os.ReadFile(filepath.FromSlash("./test/fixtures/get_queries_test/content_get_queries.rego"))
	require.NoError(t, err)

	type fields struct {
		Source         string
		Types          []string
		CloudProviders []string
		Library        string
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
				Source: source, Types: []string{""}, CloudProviders: []string{""}, Library: "./assets/libraries",
			},
			want: []model.QueryMetadata{
				{
					Query:     "all_auth_users_get_read_access",
					Content:   string(contentByte),
					InputData: "{}",
					Metadata: map[string]interface{}{
						"category":        "Access Control",
						"descriptionText": "Misconfigured S3 buckets can leak private information to the entire internet or allow unauthorized data tampering / deletion", //nolint
						"descriptionUrl":  "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#acl",
						"id":              "57b9893d-33b1-4419-bcea-b828fb87e318",
						"queryName":       "All Auth Users Get Read Access",
						"severity":        model.SeverityHigh,
						"platform":        "Terraform",
					},
					Platform:    "terraform",
					Aggregation: 1,
				},
			},
			wantErr: false,
		},
		{
			name: "get_queries_error",
			fields: fields{
				Source: "../no-path",
			},
			want:    nil,
			wantErr: true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			s := NewFilesystemSource(tt.fields.Source, []string{""}, []string{""}, tt.fields.Library)
			filter := QueryInspectorParameters{
				IncludeQueries: IncludeQueries{
					ByIDs: []string{}},
				ExcludeQueries: ExcludeQueries{
					ByIDs:        []string{},
					ByCategories: []string{},
				},
				InputDataPath: "",
			}
			got, err := s.GetQueries(&filter)
			if (err != nil) != tt.wantErr {
				t.Errorf("FilesystemSource.GetQueries() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			wantStr, err := test.StringifyStruct(tt.want)
			require.Nil(t, err)
			gotStr, err := test.StringifyStruct(got)
			require.Nil(t, err)

			require.Equal(t, tt.want, got, "want = %s\ngot = %s", wantStr, gotStr)
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
		name    string
		args    args
		want    map[string]interface{}
		wantErr bool
	}{
		{
			name: "read_metadata_error",
			args: args{
				queryDir: "error-path",
			},
			want:    nil,
			wantErr: false,
		},
		{
			name: "read_metadata_template",
			args: args{
				queryDir: filepath.FromSlash("./test/fixtures/type-test01/template01"),
			},
			want: map[string]interface{}{
				"category":        nil,
				"descriptionText": "<TEXT>",
				"descriptionUrl":  "#",
				"id":              "<ID>",
				"queryName":       "<QUERY_NAME>",
				"severity":        model.SeverityHigh,
				"platform":        "Dockerfile",
				"aggregation":     float64(1),
			},
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got, err := ReadMetadata(tt.args.queryDir); !reflect.DeepEqual(got, tt.want) {
				require.Equal(t, tt.wantErr, (err != nil))
				gotStr, err := test.StringifyStruct(got)
				require.Nil(t, err)
				wantStr, err := test.StringifyStruct(tt.want)
				require.Nil(t, err)
				t.Errorf("readMetadata()\ngot = %v\nwant = %v", gotStr, wantStr)
			}
		})
	}
}

// Test_getPlatform tests the functions [getPlatform()] and all the methods called by them
func Test_getPlatform(t *testing.T) {
	type args struct {
		PlatformInMetadata string
	}
	tests := []struct {
		name string
		args args
		want string
	}{
		{
			name: "get_platform_common",
			args: args{
				PlatformInMetadata: "Common",
			},
			want: "common",
		},
		{
			name: "get_platform_ansible",
			args: args{
				PlatformInMetadata: "Ansible",
			},
			want: "ansible",
		},
		{
			name: "get_platform_cloudFormation",
			args: args{
				PlatformInMetadata: "CloudFormation",
			},
			want: "cloudFormation",
		},
		{
			name: "get_platform_dockerfile",
			args: args{
				PlatformInMetadata: "Dockerfile",
			},
			want: "dockerfile",
		},
		{
			name: "get_platform_k8s",
			args: args{
				PlatformInMetadata: "Kubernetes",
			},
			want: "k8s",
		},
		{
			name: "get_platform_open_api",
			args: args{
				PlatformInMetadata: "OpenAPI",
			},
			want: "openAPI",
		},
		{
			name: "get_platform_terraform",
			args: args{
				PlatformInMetadata: "Terraform",
			},
			want: "terraform",
		},
		{
			name: "get_platform_AzureResourceManager",
			args: args{
				PlatformInMetadata: "AzureResourceManager",
			},
			want: "azureResourceManager",
		},
		{
			name: "get_platform_unknown",
			args: args{
				PlatformInMetadata: "Unknown",
			},
			want: "unknown",
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := getPlatform(tt.args.PlatformInMetadata); got != tt.want {
				t.Errorf("getPlatform() = %v, want %v", got, tt.want)
			}
		})
	}
}

// TestListSupportedPlatforms tests the function ListSupportedPlatforms
func TestListSupportedPlatforms(t *testing.T) {
	expected := []string{
		"Ansible",
		"AzureResourceManager",
		"CloudFormation",
		"Dockerfile",
		"GoogleDeploymentManager",
		"Kubernetes",
		"OpenAPI",
		"Terraform",
	}
	listActual := ListSupportedPlatforms()
	for _, actual := range listActual {
		require.Contains(t, expected, actual, "expected=%s\ngot=%s", expected, listActual)
	}
}

// TestReadInputData tests readInputData function
func TestReadInputData(t *testing.T) {
	tests := []struct {
		name string
		path string
		want string
	}{
		{
			name: "Should generate input data string",
			path: filepath.FromSlash("./test/fixtures/input_data/test.json"),
			want: `{"test": "success"}`,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := readInputData(tt.path)
			require.NoError(t, err)
			require.Equal(t, tt.want, got)
		})
	}
}

func TestSource_validateMetadata(t *testing.T) {
	tests := []struct {
		name         string
		metadata     map[string]interface{}
		wantValid    bool
		wantInvField string
	}{
		{
			name: "valid metadata test case",
			metadata: map[string]interface{}{
				"id":       "1234",
				"platform": "terraform",
			},
			wantValid:    true,
			wantInvField: "platform",
		},
		{
			name: "invalid metadata platform test case",
			metadata: map[string]interface{}{
				"id": "1234",
			},
			wantValid:    false,
			wantInvField: "platform",
		},
		{
			name: "invalid metadata id test case",
			metadata: map[string]interface{}{
				"platform": "terraform",
			},
			wantValid:    false,
			wantInvField: "id",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			valid, invField := validateMetadata(tt.metadata)
			require.Equal(t, tt.wantValid, valid)
			require.Equal(t, tt.wantInvField, invField)
		})
	}
}

// TestSource_ListSupportedCloudProviders tests the function ListSupportedCloudProviders.
func TestSource_ListSupportedCloudProviders(t *testing.T) {
	want := []string{"aws", "azure", "gcp"}
	t.Run("test List Suported CP", func(t *testing.T) {
		got := ListSupportedCloudProviders()
		require.Equal(t, want, got)
	})
}

func TestSource_getLibraryInDir(t *testing.T) {
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Fatal(err)
	}

	type args struct {
		platform       string
		libraryDirPath string
	}

	tests := []struct {
		name string
		args args
		want string
	}{
		{
			name: "test get library in dir for terraform",
			args: args{
				platform:       "terraform",
				libraryDirPath: filepath.FromSlash("./assets/libraries"),
			},
			want: filepath.FromSlash("assets/libraries/terraform.rego"),
		},
		{
			name: "test get library in dir error",
			args: args{
				platform:       "",
				libraryDirPath: filepath.FromSlash("./assets/libraries"),
			},
			want: "",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := getLibraryInDir(tt.args.platform, tt.args.libraryDirPath)
			require.Equal(t, tt.want, got)
		})
	}
}
