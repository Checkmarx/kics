package kics

import (
	"context"
	"fmt"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/internal/storage"
	"github.com/Checkmarx/kics/internal/tracker"
	"github.com/Checkmarx/kics/pkg/engine"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/parser"
	dockerParser "github.com/Checkmarx/kics/pkg/parser/docker"
	terraformParser "github.com/Checkmarx/kics/pkg/parser/terraform"
	yamlParser "github.com/Checkmarx/kics/pkg/parser/yaml"
	"github.com/Checkmarx/kics/pkg/source"
)

func TestService(t *testing.T) {
	mockParser, mockFilesSource := createParserSourceProvider("../../assets/queries/template")

	type fields struct {
		SourceProvider SourceProvider
		Storage        Storage
		Parser         *parser.Parser
		Inspector      *engine.Inspector
		Tracker        Tracker
	}
	type args struct {
		ctx     context.Context
		scanID  string
		scanIDs []string
	}
	type want struct {
		vulnerabilities []model.Vulnerability
		severitySummary []model.SeveritySummary
	}
	tests := []struct {
		name    string
		fields  fields
		args    args
		want    want
		wantErr bool
	}{
		{
			name: "service",
			fields: fields{
				Inspector:      &engine.Inspector{},
				Parser:         mockParser,
				Tracker:        &tracker.CITracker{},
				Storage:        storage.NewMemoryStorage(),
				SourceProvider: mockFilesSource,
			},
			args: args{
				ctx:     nil,
				scanID:  "scanID",
				scanIDs: []string{"scanID"},
			},
			wantErr: false,
			want: want{
				vulnerabilities: []model.Vulnerability{},
				severitySummary: nil,
			},
		},
	}
	for _, tt := range tests {
		s := &Service{
			SourceProvider: tt.fields.SourceProvider,
			Storage:        tt.fields.Storage,
			Parser:         tt.fields.Parser,
			Inspector:      tt.fields.Inspector,
			Tracker:        tt.fields.Tracker,
		}
		t.Run(fmt.Sprintf(tt.name+"_get_vulnerabilities"), func(t *testing.T) {
			got, err := s.GetVulnerabilities(tt.args.ctx, tt.args.scanID)
			if (err != nil) != tt.wantErr {
				t.Errorf("Service.GetVulnerabilities() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want.vulnerabilities) {
				t.Errorf("Service.GetVulnerabilities() = %v, want %v", got, tt.want)
			}
		})
		t.Run(fmt.Sprintf(tt.name+"_get_scan_summary"), func(t *testing.T) {
			got, err := s.GetScanSummary(tt.args.ctx, tt.args.scanIDs)
			if (err != nil) != tt.wantErr {
				t.Errorf("Service.GetScanSummary() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want.severitySummary) {
				t.Errorf("Service.GetScanSummary() = %v, want %v", got, tt.want)
			}
		})
		t.Run(fmt.Sprintf(tt.name+"_start_scan"), func(t *testing.T) {
			if err := s.StartScan(tt.args.ctx, tt.args.scanID); (err != nil) != tt.wantErr {
				t.Errorf("Service.StartScan() error = %v, wantErr %v", err, tt.wantErr)
			}
		})
	}
}

func createParserSourceProvider(path string) (*parser.Parser, *source.FileSystemSourceProvider) {
	mockParser := parser.NewBuilder().
		Add(&yamlParser.Parser{}).
		Add(terraformParser.NewDefault()).
		Add(&dockerParser.Parser{}).
		Build()

	mockFilesSource, _ := source.NewFileSystemSourceProvider(path, []string{})

	return mockParser, mockFilesSource
}
