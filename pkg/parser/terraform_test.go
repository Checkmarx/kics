package parser

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
	want = `{"resource":{"aws_s3_bucket":{"b":{"bucket":"S3B_541","tags":{"Environment":"Dev","Name":"My bucket"}}}}}`
)

func Test_Parser(t *testing.T) {
	parser := NewDefault()
	str, err := parser.Parse("test.tf", []byte(have))

	require.NoError(t, err)
	require.Equal(t, want, str)
}
