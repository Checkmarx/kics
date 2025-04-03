package file

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"gopkg.in/yaml.v3"

	"github.com/Checkmarx/kics/v2/test"
)

func TestResolver_Resolve_With_ResolveReferences(t *testing.T) {
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
		name    string
		fields  fields
		args    args
		want    []byte
		wantWin []byte
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
				`UnexpectedError:description:unexpectederrorcontent:application/json:schema:type:objectrequired:-code-messageproperties:code:type:integerformat:int32message:type:stringRefMetadata:$ref:"../schemas/Error.yaml"alone:trueRefMetadata:$ref:"./UnexpectedError.yaml"alone:trueNullResponse:description:NullresponseRefMetadata:$ref:"./NullResponse.yaml"alone:true`),
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
				"{\"info\":{\"title\":\"Reference in reference example\",\"version\":\"1.0.0\"},\"openapi\":\"3.0.3\",\"paths\":{\"/api/test/ref/in/ref\":{\"post\":{\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"RefMetadata\":{\"$ref\":\"messages/request.json\",\"alone\":true},\"properties\":{\"definition_reference\":{\"RefMetadata\":{\"$ref\":\"definitions.json#/definitions/External\",\"alone\":true},\"type\":\"string\"}},\"required\":[\"definition_reference\"],\"type\":\"object\"}}}},\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"RefMetadata\":{\"$ref\":\"messages/response.json\",\"alone\":true},\"properties\":{\"id\":{\"format\":\"int32\",\"type\":\"integer\"}},\"type\":\"object\"}}},\"description\":\"Successful response\"}}}}}}",
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
		{
			name: "test_direct_cyclic_reference_with_./_yaml",
			fields: fields{
				Resolver: NewResolver(yaml.Unmarshal, yaml.Marshal, []string{".yml", ".yaml"}),
			},
			args: args{
				path: filepath.ToSlash("test/fixtures/direct_cyclic_references/sample.yaml"),
			},
			want: []byte(
				"apiVersion: scaffolder.backstage.io/v1beta3\nkind: Template\nmetadata:\n    name: template\nspec:\n    parameters:\n        - title: sample\n          required:\n            - path\n          properties:\n            path:\n                title: Path\n                type: string\n                default: ./sample.yaml\n    steps:\n        - id: step1\n          name: step1\n        - id: step2\n          name: step2\n        - id: step3\n          name: step3\n",
			),
		},
		{
			name: "test_direct_cyclic_reference_with_.\\_yaml",
			fields: fields{
				Resolver: NewResolver(yaml.Unmarshal, yaml.Marshal, []string{".yml", ".yaml"}),
			},
			args: args{
				path: filepath.ToSlash("test/fixtures/direct_cyclic_references/sample_win.yaml"),
			},
			want: []byte(
				"apiVersion: scaffolder.backstage.io/v1beta3\nkind: Template\nmetadata:\n    name: template\nspec:\n    parameters:\n        - title: sample\n          required:\n            - path\n          properties:\n            path:\n                title: Path\n                type: string\n                default: .\\sample_win.yaml\n    steps:\n        - id: step1\n          name: step1\n        - id: step2\n          name: step2\n        - id: step3\n          name: step3",
			),
		},
		{
			name: "test_direct_cyclic_reference_with_./_json",
			fields: fields{
				Resolver: NewResolver(yaml.Unmarshal, yaml.Marshal, []string{".json"}),
			},
			args: args{
				path: filepath.ToSlash("test/fixtures/direct_cyclic_references/sample.json"),
			},
			want: []byte(
				"{\n\"info\": {\n\"title\": \"Sample API\",\n\"version\": \"1.0.0\"\n},\n\"openapi\": \"3.0.0\",\n\"paths\": {\n\"/example\": {\n\"get\": {\n\"parameters\": [\n{\n\"description\": \"Path to the sample JSON file\",\n\"in\": \"query\",\n\"name\": \"filePath\",\n\"schema\": {\n\"default\": \"./sample.json\",\n\"type\": \"string\"\n}\n}\n],\n\"responses\": {\n\"200\": {\n\"description\": \"Successful response\"\n}\n},\n\"summary\": \"Example endpoint\"\n}\n}\n}\n}",
			),
		},
		{
			name: "test_direct_cyclic_reference_with_.\\_json",
			fields: fields{
				Resolver: NewResolver(json.Unmarshal, json.Marshal, []string{".json"}),
			},
			args: args{
				path: filepath.ToSlash("test/fixtures/direct_cyclic_references/sample_win.json"),
			},
			want: []byte(
				"{\n\"info\": {\n\"title\": \"Sample API\",\n\"version\": \"1.0.0\"\n},\n\"openapi\": \"3.0.0\",\n\"paths\": {\n\"/example\": {\n\"get\": {\n\"parameters\": [\n{\n\"description\": \"Path to the sample JSON file\",\n\"in\": \"query\",\n\"name\": \"filePath\",\n\"schema\": {\n\"default\": \".\\\\sample_win.json\",\n\"type\": \"string\"\n}\n}\n],\n\"responses\": {\n\"200\": {\n\"description\": \"Successful response\"\n}\n},\n\"summary\": \"Example endpoint\"\n}\n}\n}\n}",
			),
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

			if got := r.Resolve(cont, tt.args.path, 0, 15, make(map[string]ResolvedFile), true); !reflect.DeepEqual(prepareString(string(got)), prepareString(string(tt.want))) {
				t.Errorf("Resolve() = %v, want = %v", prepareString(string(got)), prepareString(string(tt.want)))
			}
		})
	}
}

func TestResolver_Resolve_Without_ResolveReferences(t *testing.T) {
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
			name: "yaml should resolve because is not openapi file",
			fields: fields{
				Resolver: NewResolver(yaml.Unmarshal, yaml.Marshal, []string{".yml", ".yaml"}),
			},
			args: args{
				path: filepath.ToSlash("test/fixtures/unresolved_openapi/responses/_index.yaml"),
			},
			want: []byte(
				`UnexpectedError:description:unexpectederrorcontent:application/json:schema:type:objectrequired:-code-messageproperties:code:type:integerformat:int32message:type:stringRefMetadata:$ref:"../schemas/Error.yaml"alone:trueRefMetadata:$ref:"./UnexpectedError.yaml"alone:trueNullResponse:description:NullresponseRefMetadata:$ref:"./NullResponse.yaml"alone:true`),
		},
		{
			name: "json should not resolve because is a openapi file",
			fields: fields{
				Resolver: NewResolver(json.Unmarshal, json.Marshal, []string{".json"}),
			},
			args: args{
				path: filepath.ToSlash("test/fixtures/unresolved_openapi_json/openapi.json"),
			},
			want: []byte(
				"{\"openapi\":\"3.0.3\",\"info\":{\"title\":\"Reference in reference example\",\"version\":\"1.0.0\"},\"paths\":{\"/api/test/ref/in/ref\":{\"post\":{\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"$ref\":\"messages/request.json\"}}}},\"responses\":{\"200\":{\"description\":\"Successful response\",\"content\":{\"application/json\":{\"schema\":{\"$ref\":\"messages/response.json\"}}}}}}}}}",
			),
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

			if got := r.Resolve(cont, tt.args.path, 0, 15, make(map[string]ResolvedFile), false); !reflect.DeepEqual(prepareString(string(got)), prepareString(string(tt.want))) {
				t.Errorf("Resolve() = %v, want = %v", prepareString(string(got)), prepareString(string(tt.want)))
			}
		})
	}
}

// when using the key 'include_vars', the resolver will search for the file inside the folder 'current_path/vars' and then in the 'current_path'.
func TestResolver_Resolve_Ansible_Vars(t *testing.T) {
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
			name: "resolve ansible vars when vars folder is present",
			fields: fields{
				Resolver: NewResolver(yaml.Unmarshal, yaml.Marshal, []string{".yml", ".yaml"}),
			},
			args: args{
				path: filepath.ToSlash("test/fixtures/resolve_ansible_vars_with_vars_folder/main.yml"),
			},
			want: []byte(
				`-hosts:localhosttasks:-name:Includetask.ymlansible.builtin.include_tasks:-name:Addvariablesansible.builtin.include_vars:world:"World"-name:Printvariablefrommain.ymldebug:msg:"Hello{{world}}"-name:Includetask.ymlagainansible.builtin.include_tasks:-name:Addvariablesansible.builtin.include_vars:world:"World"-name:Printvariablefrommain.ymldebug:msg:"Hello{{world}}"`,
			),
		},
		{
			name: "resolve ansible vars when vars folder is not present",
			fields: fields{
				Resolver: NewResolver(yaml.Unmarshal, yaml.Marshal, []string{".yml", ".yaml"}),
			},
			args: args{
				path: filepath.ToSlash("test/fixtures/resolve_ansible_vars_without_vars_folder/main.yml"),
			},
			want: []byte(
				`-hosts:localhosttasks:-name:Includetask.ymlansible.builtin.include_tasks:-name:Addvariablesinclude_vars:world:"World"-name:Printvariablefrommain.ymldebug:msg:"Hello{{world}}"-name:Includetask.ymlagainansible.builtin.include_tasks:-name:Addvariablesinclude_vars:world:"World"-name:Printvariablefrommain.ymldebug:msg:"Hello{{world}}"`,
			),
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

			if got := r.Resolve(cont, tt.args.path, 0, 15, make(map[string]ResolvedFile), false); !reflect.DeepEqual(prepareString(string(got)), prepareString(string(tt.want))) {
				t.Errorf("Resolve() = %v, want = %v", prepareString(string(got)), prepareString(string(tt.want)))
			}
		})
	}
}

func Test_IsOpenApi(t *testing.T) {
	err := test.ChangeCurrentDir("kics")
	if err != nil {
		t.Fatal(err)
	}

	tests := []struct {
		name string
		path string
		want bool
	}{
		{
			name: "yaml Open Api",
			path: "test/fixtures/resolve_references/swagger.yaml",
			want: true,
		},
		{
			name: "json Open Api",
			path: "test/fixtures/resolve_references_json/scan-2files.json",
			want: true,
		},
		{
			name: "yml not Open Api",
			path: "test/fixtures/resolve_references/paths/users/user.yaml",
			want: false,
		},
		{
			name: "json not Open Api",
			path: "test/fixtures/resolve_references_json/definitions.json",
			want: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			cont, err := getFileContent(tt.path)
			require.NoError(t, err)
			got := isOpenAPI(cont)
			assert.Equal(t, tt.want, got, fmt.Sprintf("Error: %s", tt.name))
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
	content = strings.Replace(content, "\r", "", -1)
	content = strings.Replace(content, " ", "", -1)
	return content
}
