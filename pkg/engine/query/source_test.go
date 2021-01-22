package query

import (
	"fmt"
	"os"
	"reflect"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	"github.com/Checkmarx/kics/pkg/model"
)

func TestFilesystemSource_GetGenericQuery(t *testing.T) { // nolint
	changeCurrentDir(t)
	type fields struct {
		Source string
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
				Source: "./assets/queries/template",
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
				Source: "./assets/queries/template",
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
				Source: "./assets/queries/template",
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
				Source: "./assets/queries/template",
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
				Source: "./assets/queries/template",
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
				Source: "./assets/queries/template",
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
				Source: "./assets/queries/template",
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

func TestFilesystemSource_GetQueries(t *testing.T) {
	changeCurrentDir(t)

	type fields struct {
		Source string
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
				Source: "./assets/queries/template",
			},
			want: []model.QueryMetadata{
				{
					Query: "template",
					Content: `package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource
  resource == "<VALUE>"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("%s", [resource]),
                "issueType":		"IncorrectValue",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": "<RESOURCE>",
                "keyActualValue": 	resource
              }
}`,
					Metadata: map[string]interface{}{
						"category":        nil,
						"descriptionText": "<TEXT>",
						"descriptionUrl":  "#",
						"id":              "<ID>",
						"queryName":       "<QUERY_NAME>",
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
				Source: "../no-path",
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

func changeCurrentDir(t *testing.T) {
	for currentDir, err := os.Getwd(); getCurrentDirName(currentDir) != "kics"; currentDir, err = os.Getwd() {
		if err == nil {
			if err := os.Chdir(".."); err != nil {
				fmt.Printf("change path error = %v", err)
				t.Fatal()
			}
		} else {
			t.Fatal()
		}
	}
}

func getCurrentDirName(path string) string {
	dirs := strings.Split(path, string(os.PathSeparator))
	if dirs[len(dirs)-1] == "" && len(dirs) > 1 {
		return dirs[len(dirs)-2]
	}
	return dirs[len(dirs)-1]
}

func Test_readMetadata(t *testing.T) {
	changeCurrentDir(t)
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
				queryDir: "./assets/queries/template",
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
