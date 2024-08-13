/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package kics

import (
	"context"
	"fmt"
	"reflect"
	"sync"
	"testing"

	"github.com/Checkmarx/kics/internal/storage"
	"github.com/Checkmarx/kics/internal/tracker"
	"github.com/Checkmarx/kics/pkg/engine"
	"github.com/Checkmarx/kics/pkg/engine/provider"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/parser"
	jsonParser "github.com/Checkmarx/kics/pkg/parser/json"
	terraformParser "github.com/Checkmarx/kics/pkg/parser/terraform"
	yamlParser "github.com/Checkmarx/kics/pkg/parser/yaml"
	"github.com/Checkmarx/kics/pkg/resolver"
)

// TestService tests the functions [GetVulnerabilities(), GetScanSummary(),StartScan()] and all the methods called by them
func TestService(t *testing.T) { //nolint
	mockParser, mockFilesSource, mockResolver := createParserSourceProvider("../../test/fixtures/test_helm")
	type fields struct {
		SourceProvider provider.SourceProvider
		Storage        Storage
		Parser         []*parser.Parser
		Inspector      *engine.Inspector
		Tracker        Tracker
		Resolver       *resolver.Resolver
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
				Inspector: &engine.Inspector{
					QueryLoader: &engine.QueryLoader{
						QueriesMetadata: make([]model.QueryMetadata, 0),
					},
				},
				Parser:         mockParser,
				Tracker:        &tracker.CITracker{},
				Storage:        storage.NewMemoryStorage(),
				SourceProvider: mockFilesSource,
				Resolver:       mockResolver,
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
		s := make([]*Service, 0, len(tt.fields.Parser))
		for _, parser := range tt.fields.Parser {
			s = append(s, &Service{
				SourceProvider: tt.fields.SourceProvider,
				Storage:        tt.fields.Storage,
				Parser:         parser,
				Inspector:      tt.fields.Inspector,
				Tracker:        tt.fields.Tracker,
				Resolver:       tt.fields.Resolver,
			})
		}
		t.Run(fmt.Sprintf(tt.name+"_get_vulnerabilities"), func(t *testing.T) {
			for _, serv := range s {
				got, err := serv.GetVulnerabilities(tt.args.ctx, tt.args.scanID)
				if (err != nil) != tt.wantErr {
					t.Errorf("Service.GetVulnerabilities() error = %v, wantErr %v", err, tt.wantErr)
					return
				}
				if !reflect.DeepEqual(got, tt.want.vulnerabilities) {
					t.Errorf("Service.GetVulnerabilities() = %v, want %v", got, tt.want)
				}
			}
		})
		t.Run(fmt.Sprintf(tt.name+"_get_scan_summary"), func(t *testing.T) {
			for _, serv := range s {
				got, err := serv.GetScanSummary(tt.args.ctx, tt.args.scanIDs)
				if (err != nil) != tt.wantErr {
					t.Errorf("Service.GetScanSummary() error = %v, wantErr %v", err, tt.wantErr)
					return
				}
				if !reflect.DeepEqual(got, tt.want.severitySummary) {
					t.Errorf("Service.GetScanSummary() = %v, want %v", got, tt.want)
				}
			}
		})
		t.Run(fmt.Sprintf(tt.name+"_start_scan"), func(t *testing.T) {
			var wg sync.WaitGroup
			errCh := make(chan error)
			wgDone := make(chan bool)
			currentQuery := make(chan int64)
			for _, serv := range s {
				wg.Add(1)
				serv.StartScan(tt.args.ctx, tt.args.scanID, errCh, &wg, currentQuery)
			}
			go func() {
				defer func() {
					close(currentQuery)
					close(wgDone)
				}()
				wg.Wait()
			}()
			select {
			case <-wgDone:
				break
			case err := <-errCh:
				close(errCh)
				if (err != nil) != tt.wantErr {
					t.Errorf("Service.StartScan() error = %v, wantErr %v", err, tt.wantErr)
				}
			}
		})
	}
}

func createParserSourceProvider(path string) ([]*parser.Parser,
	*provider.FileSystemSourceProvider, *resolver.Resolver) {
	mockParser, _ := parser.NewBuilder().
		Add(&jsonParser.Parser{}).
		Add(&yamlParser.Parser{}).
		Add(terraformParser.NewDefault()).
		Build([]string{""}, []string{""})

	mockFilesSource, _ := provider.NewFileSystemSourceProvider([]string{path}, []string{})

	mockResolver, _ := resolver.NewBuilder().Build()

	return mockParser, mockFilesSource, mockResolver
}
