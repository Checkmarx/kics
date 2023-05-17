package file

import (
	"encoding/json"
	"io/ioutil"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/test"
	"gopkg.in/yaml.v3"
)

func TestResolver_Resolve(t *testing.T) {
	err := test.ChangeCurrentDir("kics")
	if err != nil {
		t.Fatal(err)
	}
	type fields struct {
		*Resolver
	}
	type args struct {
		path string
	}
	tests := []struct {
		name   string
		fields fields
		args   args
		want   []byte
	}{
		{
			name: "test",
			fields: fields{
				Resolver: NewResolver(yaml.Unmarshal, yaml.Marshal, []string{".yml", ".yaml"}),
			},
			args: args{
				path: filepath.ToSlash("test/fixtures/unresolved_openapi/responses/_index.yaml"),
			},
			want: []byte(
				`UnexpectedError:
					description: unexpected error
					content:
					application/json:
						schema:
							type: object
							required:
							- code
							- message
							properties:
							code:
								type: integer
								format: int32
							message:
								type: string		
		NullResponse:
            description: Null response`),
		},
		{
			name: "json test",
			fields: fields{
				Resolver: NewResolver(json.Unmarshal, json.Marshal, []string{".json"}),
			},
			args: args{
				path: filepath.ToSlash("test/fixtures/unresolved_openapi_json/openapi.json"),
			},
			want: []byte(
				"{\"info\":{\"title\":\"Reference in reference example\",\"version\":\"1.0.0\"},\"openapi\":\"3.0.3\",\"paths\":{\"/api/test/ref/in/ref\":{\"post\":{\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"definition_reference\":{\"$ref\":\"definitions.json#/definitions/External\"}},\"required\":[\"definition_reference\"],\"type\":\"object\"}}}},\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"id\":{\"format\":\"int32\",\"type\":\"integer\"}},\"type\":\"object\"}}},\"description\":\"Successful response\"}}}}}}",
			),
		},
		{
			name: "test_serverless",
			fields: fields{
				Resolver: NewResolver(yaml.Unmarshal, yaml.Marshal, []string{".yml", ".yaml"}),
			},
			args: args{
				path: filepath.ToSlash("test/fixtures/unresolved_serverless/serverless.yml"),
			},
			want: []byte(
				"service: aws-node-project\nframeworkVersion: '3'\nprovider:\n    name: aws\n    runtime: nodejs14.x\nfunctions:\n    eventRouterHandler:\n        handler: handler.hello\n        role: eventRouterHandlerRole\n        timeout: 30\n"),
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			r := &Resolver{
				unmarshler:    tt.fields.unmarshler,
				marshler:      tt.fields.marshler,
				ResolvedFiles: tt.fields.ResolvedFiles,
				Extension:     tt.fields.Extension,
			}

			cont, err := getFileContent(tt.args.path)
			if err != nil {
				t.Fatal(err)
			}

			if got := r.Resolve(cont, tt.args.path, 0, make(map[string]model.ResolvedFileData)); !reflect.DeepEqual(prepareString(string(got)), prepareString(string(tt.want))) {
				t.Errorf("Resolve() = %v, want = %v", prepareString(string(got)), prepareString(string(tt.want)))
			}
		})
	}
}

func getFileContent(path string) ([]byte, error) {
	_, err := os.Stat(path)
	if err != nil {
		return nil, err
	}

	return ioutil.ReadFile(path)
}

func prepareString(content string) string {
	content = strings.Replace(content, "\n", "", -1)
	content = strings.Replace(content, "\t", "", -1)
	content = strings.Replace(content, " ", "", -1)
	return content
}
