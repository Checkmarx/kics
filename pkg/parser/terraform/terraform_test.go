package terraform

import (
	"path/filepath"
	"strings"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/stretchr/testify/require"
)

var (
	have = `
resource "aws_s3_bucket" "b" {
  bucket = "S3B_541"
  acl    = "public-read"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
`
)

// TestParser_GetKind tests the functions [GetKind()] and all the methods called by them
func TestParser_GetKind(t *testing.T) {
	p := &Parser{}
	require.Equal(t, model.KindTerraform, p.GetKind())
}

// TestParser_GetKind tests the functions [SupportedTypes()] and all the methods called by them
func TestParser_SupportedTypes(t *testing.T) {
	p := &Parser{}
	require.Equal(t, []string{"Terraform"}, p.SupportedTypes())
}

// TestParser_SupportedExtensions tests the functions [SupportedExtensions()] and all the methods called by them
func TestParser_SupportedExtensions(t *testing.T) {
	p := &Parser{}
	require.Equal(t, []string{".tf", ".tfvars"}, p.SupportedExtensions())
}

// Test_Parser tests the functions [Parser()] and all the methods called by them
func Test_Parser(t *testing.T) {
	parser := NewDefault()
	document, err := parser.Parse("test.tf", []byte(have))

	require.NoError(t, err)
	require.Len(t, document, 1)
	require.Contains(t, document[0], "resource")
	require.Contains(t, document[0]["resource"], "aws_s3_bucket")
}

// Test_Resolve tests the functions [Resolve()] and all the methods called by them
func Test_Resolve(t *testing.T) {
	parser := NewDefault()

	resolved, err := parser.Resolve([]byte(have), "test.tf")
	require.NoError(t, err)
	require.Equal(t, []byte(have), *resolved)
}

func TestTerraform_ProcessContent(t *testing.T) {
	type args struct {
		elements model.Document
		content  string
		path     string
	}

	tests := []struct {
		name string
		args args
		want map[string]interface{}
	}{
		{
			name: "test_process_content",
			args: args{
				elements: model.Document{},
				content:  filepath.Join("..", "..", "..", "test", "fixtures", "test_certificate", "certificate.pem"),
				path:     filepath.Join("..", "..", "test", "fixtures", "test_certificate", "certificate.pem"),
			},
			want: map[string]interface{}{
				"expiration_date": [3]int{2022, 3, 27},
				"file":            filepath.Join("..", "..", "..", "test", "fixtures", "test_certificate", "certificate.pem"),
				"rsa_key_bytes":   512,
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			processContent(tt.args.elements, tt.args.content, tt.args.path)
			require.Equal(t, tt.want, tt.args.elements["certificate_body"])
		})
	}
}

// Test_GetCommentToken must get the token that represents a comment
func Test_GetCommentToken(t *testing.T) {
	parser := &Parser{}
	require.Equal(t, "#", parser.GetCommentToken())
}

func TestParseFile(t *testing.T) {
	tests := []fileTest{
		{
			name:     "Should parse variable file",
			filename: filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_variables", "terraform.tfvars"),
			want: `test_terraform = "terraform.tfvars"
`,
			wantErr: false,
		},
		{
			name:     "Should parse terraform file",
			filename: filepath.Join("..", "..", "..", "test", "fixtures", "test_terraform_variables", "test.tf"),
			want: `variable "local_default_var" {
  type    = "string"
  default = "local_default"
}

variable "" {
  type    = "string"
  default = "invalid_block"
}

variable "invalid_attr" {
}

resource "test" "test1" {
  test_map        = var.map2
  test_bool       = var.test1
  test_list       = var.test2
  test_neted_map  = var.map2[var.map1["map1key1"]]]

  test_block {
    terraform_var = var.test_terraform
  }

  test_default_local = var.local_default_var
  test_default       = var.default_var
}
`,
			wantErr: false,
		},
		{
			name:     "Should get error when trying to parse inexistent file",
			filename: filepath.Join(".", "not_found.tf"),
			want:     "",
			wantErr:  true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			parsedFile, err := parseFile(tt.filename)
			if tt.wantErr {
				require.NotNil(t, err)
				require.Nil(t, parsedFile)
			} else {
				require.NoError(t, err)
				require.Equal(t, tt.want, strings.ReplaceAll(string(parsedFile.Bytes), "\r", ""))
			}
		})
	}
}
