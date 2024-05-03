package report

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/test"
	"github.com/stretchr/testify/require"
)

// TestPrintCycloneDxReport prints the CycloneDX report
func TestPrintCycloneDxReport(t *testing.T) {
	type args struct {
		path     string
		filename string
		body     interface{}
	}
	tests := []struct {
		name    string
		args    args
		wantErr bool
	}{
		{
			name: "Test1 PrintCycloneDxReport", // Unable to get sha-256: reports no vulnerabilities
			args: args{
				path:     "./testdir",
				filename: "testout",
				body:     test.SummaryMock,
			},
			wantErr: false,
		},
		{
			name: "Test2 PrintCycloneDxReport", // Able to get sha-256: reports vulnerabilities
			args: args{
				path:     "./testdir",
				filename: "testout2",
				body:     test.ExampleSummaryMock,
			},
			wantErr: false,
		},
		{
			name: "Test3 PrintCycloneDxReport", // Able to get sha-256: reports vulnerabilities
			args: args{
				path:     "./testdir",
				filename: "testout3",
				body:     test.SummaryMockCritical,
			},
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			queries := tt.args.body.(model.Summary).Queries
			for idx := range queries {
				for i := range queries[idx].Files {
					queries[idx].Files[i].FileName = filepath.Join("..", "..", queries[idx].Files[i].FileName)
				}
			}
			if err := os.MkdirAll(tt.args.path, os.ModePerm); err != nil {
				t.Fatal(err)
			}
			if err := PrintCycloneDxReport(tt.args.path, tt.args.filename, tt.args.body); (err != nil) != tt.wantErr {
				t.Errorf("PrintCycloneDxReport() error = %v, wantErr %v", err, tt.wantErr)
			}
			require.FileExists(t, filepath.Join(tt.args.path, "cyclonedx-"+tt.args.filename+".xml"))
			os.RemoveAll(tt.args.path)
		})
	}
}
