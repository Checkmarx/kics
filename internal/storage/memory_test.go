/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package storage

import (
	"context"
	"fmt"
	"reflect"
	"testing"

	"github.com/stretchr/testify/require"

	"github.com/Checkmarx/kics/pkg/model"
)

// TestMemoryStorage_SaveFile tests the functions [SaveFile()]
func TestMemoryStorage_SaveFile(t *testing.T) {
	type fields struct {
		vulnerabilities []model.Vulnerability
		allFiles        model.FileMetadatas
	}
	type args struct {
		in0      context.Context
		metadata *model.FileMetadata
	}
	tests := []struct {
		name    string
		fields  fields
		args    args
		wantErr bool
	}{
		{
			name: "SaveFile",
			fields: fields{
				vulnerabilities: []model.Vulnerability{},
				allFiles:        model.FileMetadatas{},
			},
			args: args{
				in0: nil,
				metadata: &model.FileMetadata{
					ID:           "id",
					ScanID:       "scan_id",
					OriginalData: "orig_data",
					FilePath:     "file_name",
				},
			},
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			m := &MemoryStorage{
				vulnerabilities: tt.fields.vulnerabilities,
				allFiles:        tt.fields.allFiles,
			}
			if err := m.SaveFile(tt.args.in0, tt.args.metadata); (err != nil) != tt.wantErr {
				t.Errorf("MemoryStorage.SaveFile() error = %v, wantErr %v", err, tt.wantErr)
			}
			require.Equal(t, *tt.args.metadata, m.allFiles[0])
		})
	}
}

// TestMemoryStorage_SaveFile tests the functions [GetFiles(), GetVulnerabilities(), GetScanSummary()]
func TestMemoryStorage(t *testing.T) { //nolint
	type fields struct {
		vulnerabilities []model.Vulnerability
		allFiles        model.FileMetadatas
	}
	type args struct {
		in0 context.Context
		in1 string
		in2 []string
	}
	type want struct {
		metadata        model.FileMetadatas
		vulnerabilities []model.Vulnerability
		scanSummary     []model.SeveritySummary
	}
	tests := []struct {
		name    string
		fields  fields
		args    args
		want    want
		wantErr bool
	}{
		{
			name: "test_case",
			fields: fields{
				vulnerabilities: []model.Vulnerability{
					{
						ID:               0,
						ScanID:           "scan_id",
						FileID:           "file_id",
						FileName:         "file_name",
						QueryID:          "query_id",
						QueryName:        "query_name",
						Line:             1,
						SearchKey:        "search_key",
						KeyExpectedValue: "key_expected_value",
						KeyActualValue:   "key_actual_value",
						Output:           "-",
					},
				},
				allFiles: model.FileMetadatas{
					{
						ID:           "id",
						ScanID:       "scan_id",
						OriginalData: "orig_data",
						FilePath:     "file_name",
					},
				},
			},
			args: args{
				in0: nil,
				in1: "",
				in2: []string{},
			},
			wantErr: false,
			want: want{
				metadata: model.FileMetadatas{
					{
						ID:           "id",
						ScanID:       "scan_id",
						OriginalData: "orig_data",
						FilePath:     "file_name",
					},
				},
				vulnerabilities: []model.Vulnerability{
					{
						ID:               0,
						ScanID:           "scan_id",
						FileID:           "file_id",
						FileName:         "file_name",
						QueryID:          "query_id",
						QueryName:        "query_name",
						Line:             1,
						SearchKey:        "search_key",
						KeyExpectedValue: "key_expected_value",
						KeyActualValue:   "key_actual_value",
						Output:           "-",
					},
				},
				scanSummary: nil,
			},
		},
	}
	for _, tt := range tests {
		m := &MemoryStorage{
			vulnerabilities: tt.fields.vulnerabilities,
			allFiles:        tt.fields.allFiles,
		}
		t.Run(fmt.Sprintf(tt.name+"_GetFiles"), func(t *testing.T) {
			got, err := m.GetFiles(tt.args.in0, tt.args.in1)
			if (err != nil) != tt.wantErr {
				t.Errorf("MemoryStorage.GetFiles() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want.metadata) {
				t.Errorf("MemoryStorage.GetFiles() = %v, want %v", got, tt.want)
			}
		})
		t.Run(fmt.Sprintf(tt.name+"_GetVulnerabilities"), func(t *testing.T) {
			got, err := m.GetVulnerabilities(tt.args.in0, tt.args.in1)
			if (err != nil) != tt.wantErr {
				t.Errorf("MemoryStorage.GetVulnerabilities() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want.vulnerabilities) {
				t.Errorf("MemoryStorage.GetVulnerabilities() = %v, want %v", got, tt.want)
			}
		})
		t.Run(fmt.Sprintf(tt.name+"_GetScanSummary"), func(t *testing.T) {
			got, err := m.GetScanSummary(tt.args.in0, tt.args.in2)
			if (err != nil) != tt.wantErr {
				t.Errorf("MemoryStorage.GetScanSummary() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want.scanSummary) {
				t.Errorf("MemoryStorage.GetScanSummary() = %v, want %v", got, tt.want)
			}
		})
	}
}

// TestMemoryStorage_SaveVulnerabilities tests the functions [SaveVulnerabilities()]
func TestMemoryStorage_SaveVulnerabilities(t *testing.T) {
	type fields struct {
		vulnerabilities []model.Vulnerability
		allFiles        model.FileMetadatas
	}
	type args struct {
		in0             context.Context
		vulnerabilities []model.Vulnerability
	}
	tests := []struct {
		name    string
		fields  fields
		args    args
		wantErr bool
	}{
		{
			name: "SaveVulnerabilities",
			fields: fields{
				vulnerabilities: []model.Vulnerability{},
				allFiles:        model.FileMetadatas{},
			},
			args: args{
				in0: nil,
				vulnerabilities: []model.Vulnerability{
					{
						ID:               0,
						ScanID:           "scan_id",
						FileID:           "file_id",
						FileName:         "file_name",
						QueryID:          "query_id",
						QueryName:        "query_name",
						Line:             1,
						SearchKey:        "search_key",
						KeyExpectedValue: "key_expected_value",
						KeyActualValue:   "key_actual_value",
						Output:           "-",
					},
				},
			},
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			m := &MemoryStorage{
				vulnerabilities: tt.fields.vulnerabilities,
				allFiles:        tt.fields.allFiles,
			}
			if err := m.SaveVulnerabilities(tt.args.in0, tt.args.vulnerabilities); (err != nil) != tt.wantErr {
				t.Errorf("MemoryStorage.SaveVulnerabilities() error = %v, wantErr %v", err, tt.wantErr)
			}
			require.Equal(t, tt.args.vulnerabilities, m.vulnerabilities)
		})
	}
}

// TestNewMemoryStorage tests the functions [NewMemoryStorage()]
func TestNewMemoryStorage(t *testing.T) {
	tests := []struct {
		name string
		want *MemoryStorage
	}{
		{
			name: "new_memory_storage",
			want: &MemoryStorage{
				allFiles:        make(model.FileMetadatas, 0),
				vulnerabilities: make([]model.Vulnerability, 0),
			},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := NewMemoryStorage(); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("NewMemoryStorage() = %v, want %v", got, tt.want)
			}
		})
	}
}
