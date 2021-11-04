package json

import (
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/stretchr/testify/require"
)

var have = `
{
	"martin": {
		"name": "Martin D'vloper"
	}
}
`

// TestParser_GetKind tests the functions [GetKind()] and all the methods called by them
func TestParser_GetKind(t *testing.T) {
	p := &Parser{}
	require.Equal(t, model.KindJSON, p.GetKind())
}

// TestParser_SupportedExtensions tests the functions [SupportedExtensions()] and all the methods called by them
func TestParser_SupportedExtensions(t *testing.T) {
	p := &Parser{}
	require.Equal(t, []string{".json"}, p.SupportedExtensions())
}

// TestParser_SupportedExtensions tests the functions [SupportedTypes()] and all the methods called by them
func TestParser_SupportedTypes(t *testing.T) {
	p := &Parser{}
	require.Equal(t, []string{"CloudFormation", "OpenAPI", "AzureResourceManager", "Terraform"}, p.SupportedTypes())
}

// TestParser_Parse tests the functions [Parse()] and all the methods called by them
func TestParser_Parse(t *testing.T) {
	p := &Parser{}

	doc, _, err := p.Parse("test.json", []byte(have))
	require.NoError(t, err)
	require.Len(t, doc, 1)
	require.Contains(t, doc[0], "martin")
}

// Test_Resolve tests the functions [Resolve()] and all the methods called by them
func Test_Resolve(t *testing.T) {
	parser := &Parser{}

	resolved, err := parser.Resolve([]byte(have), "test.json")
	require.NoError(t, err)
	require.Equal(t, []byte(have), *resolved)
}

// Test_GetCommentToken must get the token that represents a comment
func Test_GetCommentToken(t *testing.T) {
	parser := &Parser{}
	require.Equal(t, "", parser.GetCommentToken())
}

func TestJSON_StringifyContent(t *testing.T) {
	type fields struct {
		parser Parser
	}
	type args struct {
		content []byte
	}
	tests := []struct {
		name    string
		fields  fields
		args    args
		want    string
		wantErr bool
	}{
		{
			name: "test stringify content",
			fields: fields{
				parser: Parser{shouldIdent: false},
			},
			args: args{
				content: []byte(`{
					"key" : "value"
				}
`),
			},
			want: `{
					"key" : "value"
				}
`,
			wantErr: false,
		},
		{
			name: "test stringify content single line",
			fields: fields{
				parser: Parser{shouldIdent: true},
			},
			args: args{
				content: []byte(`{"key":"value"}`),
			},
			want: `{
  "key": "value"
}`,
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := tt.fields.parser.StringifyContent(tt.args.content)
			require.Equal(t, tt.wantErr, (err != nil))
			require.Equal(t, tt.want, got)
		})
	}
}
