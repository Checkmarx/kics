package detector

import (
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/test"
	"github.com/rs/zerolog"
	"github.com/stretchr/testify/require"
)

// Test_detectLine tests the functions [detectLine()] and all the methods called by them
func Test_detectLine(t *testing.T) { //nolint
	type args struct {
		file      *model.FileMetadata
		searchKey string
	}
	type feilds struct {
		outputLines int
	}
	tests := []struct {
		name   string
		args   args
		feilds feilds
		want   model.VulnerabilityLines
	}{
		{
			name: "detect_line",
			args: args{
				file: &model.FileMetadata{
					ScanID: "scanID",
					ID:     "Test",
					Kind:   model.KindTerraform,
					OriginalData: `resource "aws_s3_bucket" "b" {
						bucket = "my-tf-test-bucket"
						acl    = "authenticated-read"

						tags = {
						  Name        = "My bucket"
						  Environment = "Dev"
						}
					      }
					      `,
				},
				searchKey: "aws_s3_bucket[b].acl",
			},
			feilds: feilds{
				outputLines: 3,
			},
			want: model.VulnerabilityLines{
				Line: 3,
				VulnLine: []model.VulnLines{
					{
						Position: 2,
						Line: `						bucket = "my-tf-test-bucket"`,
					},
					{
						Position: 3,
						Line: `						acl    = "authenticated-read"`,
					},
					{
						Position: 4,
						Line:     "",
					},
				},
				LineWithVulnerabilty: "",
			},
		},
		{
			name: "detect_line_with_curly_brackets",
			args: args{
				file: &model.FileMetadata{
					ScanID: "scanID",
					ID:     "Test",
					Kind:   model.KindTerraform,
					OriginalData: `resource "aws_s3_bucket" "b" {
						bucket = "my-tf-test-bucket"
						acl    = "authenticated-read"

						tags = {
						  Name        = "My bucket"
						  Environment = "Dev.123"
						  Environment = "test"
						}
					      }
					      `,
				},
				searchKey: "aws_s3_bucket[b].Environment={{Dev.123}}",
			},
			feilds: feilds{
				outputLines: 3,
			},
			want: model.VulnerabilityLines{
				Line: 7,
				VulnLine: []model.VulnLines{
					{
						Position: 6,
						Line: `						  Name        = "My bucket"`,
					},
					{
						Position: 7,
						Line: `						  Environment = "Dev.123"`,
					},
					{
						Position: 8,
						Line: `						  Environment = "test"`,
					},
				},
				LineWithVulnerabilty: "",
			},
		},
		{
			name: "detect_line_error",
			args: args{
				file: &model.FileMetadata{
					ScanID: "scanID",
					ID:     "Test",
					Kind:   model.KindTerraform,
					OriginalData: `resource "aws_s3_bucket" "b" {
						bucket = "my-tf-test-bucket"
						acl    = "authenticated-read"

						tags = {
						  Name        = "My bucket"
						  Environment = "Dev.123"
						  Environment = "test"
						}
					      }
					      `,
				},
				searchKey: "testing.error",
			},
			feilds: feilds{
				outputLines: 3,
			},
			want: model.VulnerabilityLines{
				Line:     -1,
				VulnLine: []model.VulnLines{},
			},
		},
	}
	for _, tt := range tests {
		detector := NewDetectLine(tt.feilds.outputLines)
		t.Run(tt.name, func(t *testing.T) {
			got := detector.defaultDetector.DetectLine(tt.args.file, tt.args.searchKey, &zerolog.Logger{}, 3)
			gotStrVulnerabilities, err := test.StringifyStruct(got)
			require.Nil(t, err)
			wantStrVulnerabilities, err := test.StringifyStruct(tt.want)
			require.Nil(t, err)
			if !reflect.DeepEqual(gotStrVulnerabilities, wantStrVulnerabilities) {
				t.Errorf("detectLine() = %v, want %v", gotStrVulnerabilities, wantStrVulnerabilities)
			}
		})
	}
}
