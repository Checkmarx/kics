package file

import (
	"github.com/Checkmarx/kics/test"
	"gopkg.in/yaml.v3"
	"io/ioutil"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"testing"
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
				Resolver: NewResolver(yaml.Unmarshal, yaml.Marshal),
			},
			args: args{
				path: filepath.ToSlash("test/fixtures/unresolved_openapi/responses/_index.yaml"),
			},
			want: []byte(
				`NullResponse:
            description: Null response
        UnexpectedError:
            content:
                application/json:
                    schema:
                        properties:
                            code:
                                format: int32
                                type: integer
                            message:
                                type: string
                        required:
                            - code
                            - message
                        type: object
            description: unexpected error`),
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			r := &Resolver{
				unmarshler:    tt.fields.unmarshler,
				marshler:      tt.fields.marshler,
				ResolvedFiles: tt.fields.ResolvedFiles,
			}

			cont, err := getFileContent(tt.args.path)
			if err != nil {
				t.Fatal(err)
			}

			if got := r.Resolve(cont, tt.args.path, 0); !reflect.DeepEqual(prepareString(string(got)), prepareString(string(tt.want))) {
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
