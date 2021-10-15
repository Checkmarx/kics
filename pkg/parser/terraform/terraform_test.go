package terraform

import (
	"path/filepath"
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
	count = `
   resource "aws_instance" "server" {
	count = true == true ? 0 : 1
  
	subnet_id     = var.subnet_ids[count.index]
  
	ami           = "ami-a1b2c3d4"
	instance_type = "t2.micro"
  
  }
  
  resource "aws_instance" "server1" {
	count = length(var.subnet_ids)
  
	ami           = "ami-a1b2c3d4"
	instance_type = "t2.micro"
	subnet_id     = var.subnet_ids[count.index]
  
  }`
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

// Test_Count tests resources with count set to 0
func Test_Count(t *testing.T) {
	parser := NewDefault()
	document, err := parser.Parse("count.tf", []byte(count))
	require.NoError(t, err)
	require.Len(t, document, 1)
	require.Contains(t, document[0], "resource")
	require.Contains(t, document[0]["resource"].(model.Document)["aws_instance"], "server1")
	require.NotContains(t, document[0]["resource"].(model.Document)["aws_instance"], "server")

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
