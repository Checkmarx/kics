package detector

import (
	"reflect"
	"strings"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/stretchr/testify/require"
)

type mockkindDetectLine struct {
}

type mockDefaultDetector struct {
}

func (m mockkindDetectLine) DetectLine(file *model.FileMetadata, searchKey string,
	logWithFields *zerolog.Logger, outputLines int) model.VulnerabilityLines {
	return model.VulnerabilityLines{
		Line: 1,
	}
}

func (m mockDefaultDetector) DetectLine(file *model.FileMetadata, searchKey string,
	logWithFields *zerolog.Logger, outputLines int) model.VulnerabilityLines {
	return model.VulnerabilityLines{
		Line: 5,
	}
}

func (m mockkindDetectLine) SplitLines(content string) []string {
	return splitLines(content)
}

func (m mockDefaultDetector) SplitLines(content string) []string {
	return splitLines(content)
}

func splitLines(content string) []string {
	text := strings.ReplaceAll(content, "\r", "")
	return strings.Split(text, "\n")
}

func TestDetector_Add(t *testing.T) {
	var mock mockkindDetectLine
	det := initDetector()
	type args struct {
		kindDetector kindDetectLine
		fileKind     model.FileKind
	}
	tests := []struct {
		name string
		args args
	}{
		{
			name: "test_add",
			args: args{
				kindDetector: mock,
				fileKind:     model.KindDOCKER,
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			det = det.Add(tt.args.kindDetector, tt.args.fileKind)
			got, ok := det.detectors[tt.args.fileKind]
			if !ok {
				t.Errorf("Add(), mockKindDetectLine is not in detectors")
			}
			if !reflect.DeepEqual(got, mock) {
				t.Errorf("Add() = %v, want = %v", got, mock)
			}
		})
	}
}

func TestDetector_SetupLogs(t *testing.T) {
	det := initDetector()
	type args struct {
		log zerolog.Logger
	}
	tests := []struct {
		name string
		args args
	}{
		{
			name: "test_setup_logs",
			args: args{
				log: log.With().
					Str("scanID", "Test").
					Str("fileName", "Test_file_name").
					Str("queryName", "Test_Query_name").
					Logger(),
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			det.SetupLogs(&tt.args.log)
			got := det.logWithFields
			if !reflect.DeepEqual(*got, tt.args.log) {
				t.Errorf("SetupLogs() = %v, want = %v", got, tt.args.log)
			}
		})
	}
}

func TestDetector_DetectLine(t *testing.T) {
	var mock mockkindDetectLine
	var defaultmock mockDefaultDetector
	det := initDetector().Add(mock, model.KindCOMMON)
	det.defaultDetector = defaultmock

	type args struct {
		file      *model.FileMetadata
		searchKey string
	}
	tests := []struct {
		name string
		args args
		want model.VulnerabilityLines
	}{
		{
			name: "test_kind_detect_line",
			args: args{
				file: &model.FileMetadata{
					Kind: model.KindCOMMON,
				},
				searchKey: "",
			},
			want: model.VulnerabilityLines{
				Line: 1,
			},
		},
		{
			name: "test_default_detect_line",
			args: args{
				file: &model.FileMetadata{
					Kind: model.KindTerraform,
				},
				searchKey: "",
			},
			want: model.VulnerabilityLines{
				Line: 5,
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := det.DetectLine(tt.args.file, tt.args.searchKey)
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("DetectLine() = %v, want = %v", got, tt.want)
			}
		})
	}
}

func TestDetector_SplitLines(t *testing.T) {
	var defaultDetector defaultDetectLine
	det := initDetector().Add(defaultDetector, model.KindTerraform)
	det.defaultDetector = defaultDetector

	tests := []struct {
		name         string
		fileMetadata *model.FileMetadata
		expected     []string
	}{
		{
			name: "should split lines without default detector",
			fileMetadata: &model.FileMetadata{
				Kind: model.KindTerraform,
				OriginalData: `resource "aws_s3_bucket" "b" {
					bucket = "my-tf-test-bucket"
					acl    = "authenticated-read"
				}`,
			},
			expected: []string{
				"resource \"aws_s3_bucket\" \"b\" {",
				"bucket = \"my-tf-test-bucket\"",
				"acl    = \"authenticated-read\"",
				"}",
			},
		},
		{
			name: "should split lines with default detector",
			fileMetadata: &model.FileMetadata{
				Kind: model.KindJSON,
				OriginalData: `resource "aws_s3_bucket" "b" {
					bucket = "my-tf-test-bucket"
					acl    = "authenticated-read"
				}`,
			},
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
			got := det.SplitLines(test.fileMetadata)
			for idx, s := range got {
				got[idx] = strings.ReplaceAll(s, "\t", "")
			}
			require.Equal(t, test.expected, got)
		})
	}
}

func TestDetector_GetAdjacent(t *testing.T) {
	var defaultDetector defaultDetectLine
	det := initDetector().Add(defaultDetector, model.KindTerraform)
	det.defaultDetector = defaultDetector

	tests := []struct {
		name         string
		fileMetadata *model.FileMetadata
		line         int
		expected     model.VulnerabilityLines
	}{
		{
			name: "should get adjacent lines without default detector",
			fileMetadata: &model.FileMetadata{
				Kind: model.KindTerraform,
				OriginalData: `resource "aws_s3_bucket" "b" {
bucket = "my-tf-test-bucket"
acl    = "authenticated-read"
}`,
			},
			line: 1,
			expected: model.VulnerabilityLines{
				Line: 1,
				VulnLines: []model.CodeLine{
					{
						Position: 1,
						Line:     "resource \"aws_s3_bucket\" \"b\" {",
					},
					{
						Position: 2,
						Line:     "bucket = \"my-tf-test-bucket\"",
					},
					{
						Position: 3,
						Line:     "acl    = \"authenticated-read\"",
					},
				},
				LineWithVulnerabilty: "",
			},
		},
		{
			name: "should get adjacent lines with default detector",
			fileMetadata: &model.FileMetadata{
				Kind: model.KindJSON,
				OriginalData: `resource "aws_s3_bucket" "b" {
bucket = "my-tf-test-bucket"
acl    = "authenticated-read"
}`,
			},
			line: 1,
			expected: model.VulnerabilityLines{
				Line: 1,
				VulnLines: []model.CodeLine{
					{
						Position: 1,
						Line:     "resource \"aws_s3_bucket\" \"b\" {",
					},
					{
						Position: 2,
						Line:     "bucket = \"my-tf-test-bucket\"",
					},
					{
						Position: 3,
						Line:     "acl    = \"authenticated-read\"",
					},
				},
				LineWithVulnerabilty: "",
			},
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			got := det.GetAdjecent(test.fileMetadata, test.line)
			require.Equal(t, test.expected, got)
		})
	}
}

func initDetector() *DetectLine {
	return NewDetectLine(3)
}
