package engine

import (
	"context"
	"io/ioutil"
	"os"
	"path/filepath"
	"reflect"
	"testing"

	"github.com/stretchr/testify/require"

	"github.com/Checkmarx/kics/internal/tracker"
	"github.com/Checkmarx/kics/pkg/engine/query"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/test"
	"github.com/open-policy-agent/opa/cover"
	"github.com/open-policy-agent/opa/rego"
)

// TestInspector_EnableCoverageReport tests the functions [EnableCoverageReport()] and all the methods called by them
func TestInspector_EnableCoverageReport(t *testing.T) {
	type fields struct {
		queries              []*preparedQuery
		vb                   VulnerabilityBuilder
		tracker              Tracker
		enableCoverageReport bool
		coverageReport       cover.Report
	}
	tests := []struct {
		name   string
		fields fields
		want   bool
	}{
		{
			name: "enable_coverage_report_1",
			fields: fields{
				queries:              []*preparedQuery{},
				vb:                   DefaultVulnerabilityBuilder,
				tracker:              &tracker.CITracker{},
				enableCoverageReport: false,
				coverageReport:       cover.Report{},
			},
			want: true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			c := &Inspector{
				queries:              tt.fields.queries,
				vb:                   tt.fields.vb,
				tracker:              tt.fields.tracker,
				enableCoverageReport: tt.fields.enableCoverageReport,
				coverageReport:       tt.fields.coverageReport,
			}
			c.EnableCoverageReport()
			if !reflect.DeepEqual(c.enableCoverageReport, tt.want) {
				t.Errorf("Inspector.enableCoverageReport() = %v, want %v", c.enableCoverageReport, tt.want)
			}
		})
	}
}

// TestInspector_GetCoverageReport tests the functions [GetCoverageReport()] and all the methods called by them
func TestInspector_GetCoverageReport(t *testing.T) {
	coverageReports := cover.Report{
		Coverage: 75.5,
		Files:    map[string]*cover.FileReport{},
	}

	type fields struct {
		queries              []*preparedQuery
		vb                   VulnerabilityBuilder
		tracker              Tracker
		enableCoverageReport bool
		coverageReport       cover.Report
	}
	tests := []struct {
		name   string
		fields fields
		want   cover.Report
	}{
		{
			name: "get_coverage_report_1",
			fields: fields{
				queries:              []*preparedQuery{},
				vb:                   DefaultVulnerabilityBuilder,
				tracker:              &tracker.CITracker{},
				enableCoverageReport: false,
				coverageReport:       coverageReports,
			},
			want: coverageReports,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			c := &Inspector{
				queries:              tt.fields.queries,
				vb:                   tt.fields.vb,
				tracker:              tt.fields.tracker,
				enableCoverageReport: tt.fields.enableCoverageReport,
				coverageReport:       tt.fields.coverageReport,
			}
			if got := c.GetCoverageReport(); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("Inspector.GetCoverageReport() = %v, want %v", got, tt.want)
			}
		})
	}
}

// TestInspect tests the functions [Inspect()] and all the methods called by them
func TestInspect(t *testing.T) { //nolint
	ctx := context.Background()
	opaQuery, _ := rego.New(
		rego.Query(regoQuery),
		rego.Module("add_instead_of_copy", `package Cx

		CxPolicy [ result ] {
		  resource := input.document[i].command[name][_]
		  resource.Cmd == "add"
		  not tarfileChecker(resource.Value, ".tar")
		  not tarfileChecker(resource.Value, ".tar.")

			result := {
				"documentId": 		input.document[i].id,
				"searchKey": 	    sprintf("{{%s}}", [resource.Original]),
				"issueType":		"IncorrectValue",
				"keyExpectedValue": sprintf("'COPY' %s", [resource.Value[0]]),
				"keyActualValue": 	sprintf("'ADD' %s", [resource.Value[0]])
			      }
		}

		tarfileChecker(cmdValue, elem) {
		  contains(cmdValue[_], elem)
		}`),
		rego.UnsafeBuiltins(unsafeRegoFunctions),
	).PrepareForEval(ctx)

	opaQueries := make([]*preparedQuery, 0, 1)
	opaQueries = append(opaQueries, &preparedQuery{
		opaQuery: opaQuery,
		metadata: model.QueryMetadata{
			Query: "add_instead_of_copy",
			Content: `package Cx

			CxPolicy [ result ] {
			  resource := input.document[i].command[name][_]
			  resource.Cmd == "add"
			  not tarfileChecker(resource.Value, ".tar")
			  not tarfileChecker(resource.Value, ".tar.")

				result := {
					"documentId": 		input.document[i].id,
					"searchKey": 	    sprintf("{{%s}}", [resource.Original]),
					"issueType":		"IncorrectValue",
					"keyExpectedValue": sprintf("'COPY' %s", [resource.Value[0]]),
					"keyActualValue": 	sprintf("'ADD' %s", [resource.Value[0]])
					  }
			}

			tarfileChecker(cmdValue, elem) {
			  contains(cmdValue[_], elem)
			}`,
		},
	})

	mockedFileMetadataDocument := map[string]interface{}{
		"id":   nil,
		"file": nil,
		"command": map[string]interface{}{
			"openjdk:10-jdk": []map[string]interface{}{
				{
					"Cmd":       "add",
					"EndLine":   8,
					"JSON":      false,
					"Original":  "ADD ${JAR_FILE} app.jar",
					"StartLine": 8,
					"SubCmd":    "",
					"Value": []string{
						"app.jar",
					},
				},
			},
		},
	}

	type fields struct {
		queries              []*preparedQuery
		vb                   VulnerabilityBuilder
		tracker              Tracker
		enableCoverageReport bool
		coverageReport       cover.Report
		excludeResults       map[string]bool
	}
	type args struct {
		ctx    context.Context
		scanID string
		files  model.FileMetadatas
	}
	tests := []struct {
		name    string
		fields  fields
		args    args
		want    []model.Vulnerability
		wantErr bool
	}{
		{
			name: "TestInspect",
			fields: fields{
				queries:              opaQueries,
				vb:                   DefaultVulnerabilityBuilder,
				tracker:              &tracker.CITracker{},
				enableCoverageReport: true,
				coverageReport:       cover.Report{},
				excludeResults:       map[string]bool{},
			},
			args: args{
				ctx:    ctx,
				scanID: "scanID",
				files: model.FileMetadatas{
					{
						ID:           "3a3be8f7-896e-4ef8-9db3-d6c19e60510b",
						ScanID:       "scanID",
						Document:     mockedFileMetadataDocument,
						OriginalData: "orig_data",
						Kind:         "DOCKERFILE",
						FileName:     "assets/queries/dockerfile/add_instead_of_copy/test/positive.dockerfile",
					},
				},
			},
			want: []model.Vulnerability{
				{
					ID:               0,
					SimilarityID:     "fec62a97d569662093dbb9739360942fc2a0c47bedec0bfcae05dc9d899d3ebe",
					ScanID:           "scanID",
					FileID:           "3a3be8f7-896e-4ef8-9db3-d6c19e60510b",
					FileName:         "assets/queries/dockerfile/add_instead_of_copy/test/positive.dockerfile",
					QueryID:          "Undefined",
					QueryName:        "Anonymous",
					QueryURI:         "https://github.com/Checkmarx/kics/",
					Severity:         "INFO",
					Line:             -1,
					IssueType:        "IncorrectValue",
					SearchKey:        "{{ADD ${JAR_FILE} app.jar}}",
					KeyExpectedValue: "'COPY' app.jar",
					KeyActualValue:   "'ADD' app.jar",
					Value:            nil,
					Output:           `{"documentId":"3a3be8f7-896e-4ef8-9db3-d6c19e60510b","issueType":"IncorrectValue","keyActualValue":"'ADD' app.jar","keyExpectedValue":"'COPY' app.jar","searchKey":"{{ADD ${JAR_FILE} app.jar}}"}`, // nolint
				},
			},
			wantErr: false,
		},
		{
			name: "TestInspectExcludeResult",
			fields: fields{
				queries:              opaQueries,
				vb:                   DefaultVulnerabilityBuilder,
				tracker:              &tracker.CITracker{},
				enableCoverageReport: true,
				coverageReport:       cover.Report{},
				excludeResults:       map[string]bool{"fec62a97d569662093dbb9739360942fc2a0c47bedec0bfcae05dc9d899d3ebe": true},
			},
			args: args{
				ctx:    ctx,
				scanID: "scanID",
				files: model.FileMetadatas{
					{
						ID:           "3a3be8f7-896e-4ef8-9db3-d6c19e60510b",
						ScanID:       "scanID",
						Document:     mockedFileMetadataDocument,
						OriginalData: "orig_data",
						Kind:         "DOCKERFILE",
						FileName:     "assets/queries/dockerfile/add_instead_of_copy/test/positive.dockerfile",
					},
				},
			},
			want:    []model.Vulnerability{},
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			c := &Inspector{
				queries:              tt.fields.queries,
				vb:                   tt.fields.vb,
				tracker:              tt.fields.tracker,
				enableCoverageReport: tt.fields.enableCoverageReport,
				coverageReport:       tt.fields.coverageReport,
				excludeResults:       tt.fields.excludeResults,
			}
			got, err := c.Inspect(tt.args.ctx, tt.args.scanID, tt.args.files, true, filepath.FromSlash("assets/queries/"))
			if tt.wantErr {
				if err == nil {
					t.Errorf("Inspector.Inspect() = %v,\nwant %v", err, tt.want)
				}
			}
			if !reflect.DeepEqual(got, tt.want) {
				gotStrVulnerabilities, err := test.StringifyStruct(got)
				require.Nil(t, err)
				wantStrVulnerabilities, err := test.StringifyStruct(tt.want)
				require.Nil(t, err)
				t.Errorf("Inspector.Inspect() = %v,\nwant %v", gotStrVulnerabilities, wantStrVulnerabilities)
			}
		})
	}
}

// TestNewInspector tests the functions [NewInspector()] and all the methods called by them
func TestNewInspector(t *testing.T) { // nolint
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Fatal(err)
	}
	contentByte, err := ioutil.ReadFile(filepath.FromSlash("./test/fixtures/get_queries_test/content_get_queries.rego"))
	require.NoError(t, err)

	track := &tracker.CITracker{}
	sources := &mockSource{
		Source: filepath.FromSlash("./test/fixtures/all_auth_users_get_read_access"),
		Types:  []string{""},
	}
	vbs := DefaultVulnerabilityBuilder
	opaQueries := make([]*preparedQuery, 0, 1)
	opaQueries = append(opaQueries, &preparedQuery{
		opaQuery: rego.PreparedEvalQuery{},
		metadata: model.QueryMetadata{
			Query:    "all_auth_users_get_read_access",
			Content:  string(contentByte),
			Platform: "unknown",
			Metadata: map[string]interface{}{
				"id":              "57b9893d-33b1-4419-bcea-a717ea87e139",
				"queryName":       "All Auth Users Get Read Access",
				"severity":        "HIGH",
				"category":        "Identity and Access Management",
				"descriptionText": "Misconfigured S3 buckets can leak private information to the entire internet or allow unauthorized data tampering / deletion", // nolint
				"descriptionUrl":  "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#acl",
				"platform":        "CloudFormation",
			},
			Aggregation: 1,
		},
	})
	type args struct {
		ctx            context.Context
		source         QueriesSource
		vb             VulnerabilityBuilder
		tracker        Tracker
		excludeResults map[string]bool
	}
	tests := []struct {
		name    string
		args    args
		want    *Inspector
		wantErr bool
	}{
		{
			name: "test_new_inspector",
			args: args{
				ctx:            context.Background(),
				vb:             vbs,
				tracker:        track,
				source:         sources,
				excludeResults: map[string]bool{},
			},
			want: &Inspector{
				vb:      vbs,
				tracker: track,
				queries: opaQueries,
			},
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := NewInspector(tt.args.ctx, tt.args.source, tt.args.vb, tt.args.tracker, tt.args.excludeResults)
			if (err != nil) != tt.wantErr {
				t.Errorf("NewInspector() error: got = %v,\n wantErr = %v", err, tt.wantErr)
				return
			}
			gotStrMetadata, err := test.StringifyStruct(got.queries[0].metadata)
			require.Nil(t, err)
			wantStrMetadata, err := test.StringifyStruct(tt.want.queries[0].metadata)
			require.Nil(t, err)
			if !reflect.DeepEqual(got.queries[0].metadata, tt.want.queries[0].metadata) {
				t.Errorf("NewInspector() metadata: got = %v,\n want = %v", gotStrMetadata, wantStrMetadata)
			}

			gotStrTracker, err := test.StringifyStruct(got.tracker)
			require.Nil(t, err)
			wantStrTracker, err := test.StringifyStruct(tt.want.tracker)
			require.Nil(t, err)
			if !reflect.DeepEqual(got.tracker, tt.want.tracker) {
				t.Errorf("NewInspector() tracker: got = %v,\n want = %v", gotStrTracker, wantStrTracker)
			}
			require.NotNil(t, got.vb)
		})
	}
}

type mockSource struct {
	Source string
	Types  []string
}

func (m *mockSource) GetQueries() ([]model.QueryMetadata, error) {
	sources := query.NewFilesystemSource(m.Source, []string{""})

	return sources.GetQueries()
}
func (m *mockSource) GetGenericQuery(platform string) (string, error) {
	currentWorkdir, _ := os.Getwd()

	pathToLib := query.GetPathToLibrary(platform, currentWorkdir)
	content, err := ioutil.ReadFile(filepath.Clean(pathToLib))

	return string(content), err
}
