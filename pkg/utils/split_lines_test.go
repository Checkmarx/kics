package utils

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/require"
)

func Test_SplitLines(t *testing.T) {
	tests := []struct {
		name     string
		content  string
		expected []string
	}{
		{
			name: "should split",
			content: `resource "aws_s3_bucket" "b" {
				bucket = "my-tf-test-bucket"
				acl    = "authenticated-read"
			}`,
			expected: []string{
				"resource \"aws_s3_bucket\" \"b\" {",
				"bucket = \"my-tf-test-bucket\"",
				"acl    = \"authenticated-read\"",
				"}",
			},
		},
	}
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			got := *SplitLines(test.content)
			for idx, s := range got {
				got[idx] = strings.ReplaceAll(s, "\t", "")
			}
			require.Equal(t, test.expected, got)
		})
	}
}
