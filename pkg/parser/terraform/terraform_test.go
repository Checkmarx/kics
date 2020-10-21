package terraform

import (
	"testing"

	"github.com/stretchr/testify/require"
)

var (
	have = `
resource "aws_s3_bucket" "b" {
  bucket = "S3B_541"
  acl    = public-read"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
`
)

func Test_Parser(t *testing.T) {
	parser := NewDefault()
	document, err := parser.Parse("test.tf", []byte(have))

	require.NoError(t, err)
	require.Len(t, document, 1)
	require.Contains(t, document[0], "resource")
	require.Contains(t, document[0]["resource"], "aws_s3_bucket")
}
