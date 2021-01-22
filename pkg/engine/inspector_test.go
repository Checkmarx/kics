package engine

import (
	"context"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/internal/tracker"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/open-policy-agent/opa/cover"
	"github.com/open-policy-agent/opa/rego"
)

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
				enableCoverageReport: true,
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
	})

	type fields struct {
		queries              []*preparedQuery
		vb                   VulnerabilityBuilder
		tracker              Tracker
		enableCoverageReport bool
		coverageReport       cover.Report
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
			name: "Test",
			fields: fields{
				queries:              opaQueries,
				vb:                   DefaultVulnerabilityBuilder,
				tracker:              &tracker.CITracker{},
				enableCoverageReport: false,
				coverageReport:       cover.Report{},
			},
			args: args{
				ctx:    ctx,
				scanID: "scanID",
				files: model.FileMetadatas{
					{
						ID:     "3a3be8f7-896e-4ef8-9db3-d6c19e60510b",
						ScanID: "scanID",
						Document: map[string]interface{}{
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
						},
						OriginalData: "orig_data",
						Kind:         "DOCKERFILE",
						FileName:     "assets/queries/dockerfile/add_instead_of_copy/test/positive.dockerfile",
					},
				},
			},
			want: []model.Vulnerability{
				{
					ID:               0,
					SimilarityID:     "b84570a546f2064d483b5916d3bf3c6949c8cfc227a8c61fce22220b2f5d77bd",
					ScanID:           "scanID",
					FileID:           "3a3be8f7-896e-4ef8-9db3-d6c19e60510b",
					FileName:         "assets/queries/dockerfile/add_instead_of_copy/test/positive.dockerfile",
					QueryID:          "Undefined",
					QueryName:        "Anonymous",
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
			got, err := c.Inspect(tt.args.ctx, tt.args.scanID, tt.args.files)
			if tt.wantErr {
				if err == nil {
					t.Errorf("Inspector.GetCoverageReport() = %v, want %v", err, tt.want)
				}
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("Inspector.GetCoverageReport() = %v, want %v", got, tt.want)
			}
		})
	}
}
