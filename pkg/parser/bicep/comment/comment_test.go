package comment

import (
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
	"github.com/stretchr/testify/require"
)

var (
	samples = map[string][]byte{
		"ignore-block": []byte(`
		// kics-scan ignore-block
		resource "aws_api_gateway_stage" "positive2" {
			deployment_id = "some deployment id"
			rest_api_id   = "some rest api id"
			stage_name    = "development"
		}`),
		"ignore-line": []byte(`
		resource "aws_api_gateway_stage" "positive2" {
		  deployment_id = "some deployment id"
		  // kics-scan ignore-line
		  rest_api_id   = "some rest api id"
		  stage_name    = "development"
		}`),
		"regular-comment": []byte(`
		resource "aws_api_gateway_stage" "positive2" {
		  deployment_id = "some deployment id"
		  // kics-scan do-not-ignore
		  rest_api_id   = "some rest api id"
		  // regular comment
		  stage_name    = "development"
		}`),
		"ignore-inner-block": []byte(`
		resource "aws_api_gateway_stage" "positive2" {
		  deployment_id = "some deployment id"
		  // kics-scan ignore-block
		  tags = {
			Terraform   = "true"
			Environment = "dev"
		  }
		  stage_name    = "development"
		}`),
		"dont-ignore-lines-with-comment-at-the-end": []byte(`
		resource "aws_api_gateway_stage" "positive2" {
			deployment_id = "some deployment id"
			rest_api_id   = "some rest api id" # comment
			stage_name    = "development"     // comment
			description   = "DEV"             /* comment */
		}`),
	}
)

// TestComment_ParseComments tests the parsing of comments
func TestComment_ParseComments(t *testing.T) {
	tests := []struct {
		name     string
		content  []byte
		filename string
		want     Ignore
		wantErr  bool
	}{
		{
			name:     "TestComment_ParseComments: ignore-block",
			content:  samples["ignore-block"],
			filename: "",
			want: Ignore{
				model.IgnoreBlock: []hcl.Pos{
					{Line: 3, Column: 11, Byte: 39},
					{Line: 2, Column: 0, Byte: 0},
				},
				model.IgnoreLine:    []hcl.Pos{},
				model.IgnoreComment: []hcl.Pos{},
			},
			wantErr: false,
		},
		{
			name:     "TestComment_ParseComments: ignore-line",
			content:  samples["ignore-line"],
			filename: "",
			want: Ignore{
				model.IgnoreBlock: []hcl.Pos{},
				model.IgnoreLine: []hcl.Pos{
					{Line: 5, Column: 16, Byte: 135},
					{Line: 4, Column: 0, Byte: 0},
				},
				model.IgnoreComment: []hcl.Pos{},
			},
			wantErr: false,
		},
		{
			name:     "TestComment_ParseComments: regular-comment",
			content:  samples["regular-comment"],
			filename: "",
			want: Ignore{
				model.IgnoreBlock: []hcl.Pos{},
				model.IgnoreLine:  []hcl.Pos{},
				model.IgnoreComment: []hcl.Pos{
					{Line: 4, Column: 0, Byte: 0},
					{Line: 6, Column: 0, Byte: 0},
				},
			},
			wantErr: false,
		},
		{
			name:     "TestComment_ParseComments: ignore inner-block",
			content:  samples["ignore-inner-block"],
			filename: "",
			want: Ignore{
				model.IgnoreBlock: []hcl.Pos{
					{Line: 5, Column: 9, Byte: 129},
					{Line: 4, Column: 0, Byte: 0},
				},
				model.IgnoreLine:    []hcl.Pos{},
				model.IgnoreComment: []hcl.Pos{},
			},
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := ParseComments(tt.content, tt.filename)
			if (err != nil) != tt.wantErr {
				t.Errorf("ParseComments() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("ParseComments() = %v, want %v", got, tt.want)
			}
		})
	}
}

// TestComment_GetIgnoreLines tests the ignore lines from retrieved comments
func TestComment_GetIgnoreLines(t *testing.T) {
	tests := []struct {
		name     string
		content  []byte
		filename string
		want     []int
	}{
		{
			name:     "TestComment_GetIgnoreLines: ignore-block",
			content:  samples["ignore-block"],
			filename: "",
			want:     []int{3, 4, 5, 6, 7},
		},
		{
			name:     "TestComment_GetIgnoreLines: ignore-line",
			content:  samples["ignore-line"],
			filename: "",
			want:     []int{5, 4},
		},
		{
			name:     "TestComment_GetIgnoreLines: regular-comment",
			content:  samples["regular-comment"],
			filename: "",
			want:     []int{4, 6},
		},
		{
			name:     "TestComment_GetIgnoreLines: ignore inner-block",
			content:  samples["ignore-inner-block"],
			filename: "",
			want:     []int{5, 6, 7, 8},
		},
		{
			name:     "TestComment_GetIgnoreLines: dont-ignore-lines-with-comment-at-the-end",
			content:  samples["dont-ignore-lines-with-comment-at-the-end"],
			filename: "",
			want:     []int{},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			ignore, err := ParseComments(tt.content, tt.filename)
			require.NoError(t, err)
			file, diagnostics := hclsyntax.ParseConfig(tt.content, tt.filename, hcl.Pos{Byte: 0, Line: 1, Column: 1})
			require.False(t, diagnostics.HasErrors())
			if got := GetIgnoreLines(ignore, file.Body.(*hclsyntax.Body)); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("GetIgnoreLines() = %v, want %v", got, tt.want)
			}
		})
	}
}
