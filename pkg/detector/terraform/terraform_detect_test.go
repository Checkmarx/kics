/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package terraform

import (
	"fmt"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/utils"
	"github.com/rs/zerolog"
	"github.com/stretchr/testify/require"
)

var OriginalData1 = `resource "aws_s3_bucket" "bucket" {
  bucket = "innovationweek-fancy2023-bucket-${random_id.bucket_id.hex}"
  acl    = "authenticated-read"

  versioning {
    enabled = true
  }

  tags = {
    Demo = "true"
  }
}

resource "aws_s3_bucket" "bucket2" {
  bucket = "innovationweek2-2023-bucket-${random_id.bucket_id.hex}"

  tags = {
    Demo = "true"
    Team = "infrastructure-as-code"
  }
}

resource "aws_s3_bucket" "test3" {
  bucket = "iac-remediation-demo-bucket-notags"
  tags = {
    Demo = "true"
  }
}
`

// TestDetectTerraformLine tests the functions [DetectTerraformLine()] and all the methods called by them
func TestDetectTerraformLine(t *testing.T) { //nolint
	testCases := []struct {
		expected  model.VulnerabilityLines
		searchKey string
		file      *model.FileMetadata
	}{
		{
			expected: model.VulnerabilityLines{
				Line: 3,
				VulnLines: &[]model.CodeLine{
					{
						Position: 2,
						Line:     "  bucket = \"innovationweek-fancy2023-bucket-${random_id.bucket_id.hex}\"",
					},
					{
						Position: 3,
						Line:     "  acl    = \"authenticated-read\"",
					},
					{
						Position: 4,
						Line:     "",
					},
				},
				ResourceLocation: model.ResourceLocation{
					ResourceStart: model.ResourceLine{
						Line: 1,
						Col:  1,
					},
					ResourceEnd: model.ResourceLine{
						Line: 12,
						Col:  2,
					},
				},
			},
			searchKey: "aws_s3_bucket[bucket].acl",
			file: &model.FileMetadata{
				ScanID:            "Test2",
				ID:                "Test2",
				Kind:              model.KindTerraform,
				OriginalData:      OriginalData1,
				LinesOriginalData: utils.SplitLines(OriginalData1),
			},
		},
		{
			expected: model.VulnerabilityLines{
				Line: 15,
				VulnLines: &[]model.CodeLine{
					{
						Position: 14,
						Line:     "resource \"aws_s3_bucket\" \"bucket2\" {",
					},
					{
						Position: 15,
						Line:     "  bucket = \"innovationweek2-2023-bucket-${random_id.bucket_id.hex}\"",
					},
					{
						Position: 16,
						Line:     "",
					},
				},
				ResourceLocation: model.ResourceLocation{
					ResourceStart: model.ResourceLine{
						Line: 14,
						Col:  1,
					},
					ResourceEnd: model.ResourceLine{
						Line: 21,
						Col:  2,
					},
				},
			},
			searchKey: "aws_s3_bucket[bucket2].bucket",
			file: &model.FileMetadata{
				ScanID:            "Test2",
				ID:                "Test2",
				Kind:              model.KindTerraform,
				OriginalData:      OriginalData1,
				LinesOriginalData: utils.SplitLines(OriginalData1),
			},
		},
		{
			expected: model.VulnerabilityLines{
				Line: 25,
				VulnLines: &[]model.CodeLine{
					{
						Position: 24,
						Line:     "  bucket = \"iac-remediation-demo-bucket-notags\"",
					},
					{
						Position: 25,
						Line:     "  tags = {",
					},
					{
						Position: 26,
						Line:     "    Demo = \"true\"",
					},
				},
				ResourceLocation: model.ResourceLocation{
					ResourceStart: model.ResourceLine{
						Line: 23,
						Col:  1,
					},
					ResourceEnd: model.ResourceLine{
						Line: 28,
						Col:  2,
					},
				},
			},
			searchKey: "aws_s3_bucket[test3].tags",
			file: &model.FileMetadata{
				ScanID:            "Test3",
				ID:                "Test3",
				Kind:              model.KindTerraform,
				OriginalData:      OriginalData1,
				LinesOriginalData: utils.SplitLines(OriginalData1),
			},
		},
	}

	for i, testCase := range testCases {
		detector := DetectKindLine{}
		t.Run(fmt.Sprintf("detectTerraformLine-%d", i), func(t *testing.T) {
			v := detector.DetectLine(testCase.file, testCase.searchKey, 3, &zerolog.Logger{})
			require.Equal(t, testCase.expected, v)
		})
	}
}
