package report

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/Checkmarx/kics/v2/test"
	"github.com/stretchr/testify/require"
)

// TestPrintSonarQubeReport prints the SonarQube report
func TestPrintSonarQubeReport(t *testing.T) {
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
			name: "Test PrintSonarQubeReport",
			args: args{
				path:     "./testdir",
				filename: "testout",
				body:     test.SummaryMock,
			},
			wantErr: false,
		},
		{
			name: "Test PrintSonarQubeReport with cwe field",
			args: args{
				path:     "./testdir",
				filename: "testout2",
				body:     test.SummaryMockCWE,
			},
			wantErr: false,
		},
		{
			name: "Test PrintSonarQubeReport Critical Severity",
			args: args{
				path:     "./testdir",
				filename: "testout2",
				body:     test.SummaryMockCritical,
			},
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if err := os.MkdirAll(tt.args.path, os.ModePerm); err != nil {
				t.Fatal(err)
			}
			if err := PrintSonarQubeReport(tt.args.path, tt.args.filename, tt.args.body); (err != nil) != tt.wantErr {
				t.Errorf("PrintSonarQubeReport() error = %v, wantErr %v", err, tt.wantErr)
			}
			require.FileExists(t, filepath.Join(tt.args.path, "sonarqube-"+tt.args.filename+".json"))
			os.RemoveAll(tt.args.path)
		})
	}
}
