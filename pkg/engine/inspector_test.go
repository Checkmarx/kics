/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package engine

import (
	"context"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"testing"
	"time"

	"github.com/open-policy-agent/opa/rego"
	"github.com/stretchr/testify/assert"

	"github.com/Checkmarx/kics/assets"
	"github.com/Checkmarx/kics/internal/tracker"
	"github.com/Checkmarx/kics/pkg/detector"
	"github.com/Checkmarx/kics/pkg/engine/source"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/test"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/stretchr/testify/require"

	"github.com/open-policy-agent/opa/cover"
)

// TestInspector_EnableCoverageReport tests the functions [EnableCoverageReport()] and all the methods called by them
func TestInspector_EnableCoverageReport(t *testing.T) {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: io.Discard})

	type fields struct {
		queryLoader          *QueryLoader
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
				queryLoader:          &QueryLoader{},
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
				QueryLoader:          tt.fields.queryLoader,
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
		queryLoader          *QueryLoader
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
				queryLoader:          &QueryLoader{},
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
				QueryLoader:          tt.fields.queryLoader,
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

// TestNewInspector tests the functions [NewInspector()] and all the methods called by them
func TestNewInspector(t *testing.T) { //nolint
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Fatal(err)
	}
	contentByte, err := os.ReadFile(filepath.FromSlash("./test/fixtures/get_queries_test/content_get_queries.rego"))
	require.NoError(t, err)
	contentByte2, err2 := os.ReadFile(filepath.FromSlash("./test/fixtures/get_queries_test/common_query.rego"))
	require.NoError(t, err2)

	track := &tracker.CITracker{}
	sources := &mockSource{
		Source: []string{
			filepath.FromSlash("./test/fixtures/all_auth_users_get_read_access"),
			filepath.FromSlash("./test/fixtures/common_query_test"),
		},
		Types: []string{""},
	}
	vbs := DefaultVulnerabilityBuilder
	opaQueries := make([]model.QueryMetadata, 0, 1)
	opaQueries = append(opaQueries, model.QueryMetadata{
		Query:     "all_auth_users_get_read_access",
		Content:   string(contentByte),
		InputData: "{}",
		Platform:  "terraform",
		Metadata: map[string]interface{}{
			"id":              "57b9893d-33b1-4419-bcea-b828fb87e318",
			"queryName":       "All Auth Users Get Read Access",
			"severity":        model.SeverityHigh,
			"category":        "Access Control",
			"descriptionText": "Misconfigured S3 buckets can leak private information to the entire internet or allow unauthorized data tampering / deletion", //nolint
			"descriptionUrl":  "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#acl",
			"platform":        "Terraform",
		},
		Aggregation: 1,
	})

	opaQueries = append(opaQueries, model.QueryMetadata{
		Query:     "common_query_test",
		Content:   string(contentByte2),
		InputData: "{}",
		Platform:  "common",
		Metadata: map[string]interface{}{
			"id":              "4a3aa2b5-9c87-452c-a3ea-f3e9e3573874",
			"queryName":       "Common Query Test",
			"severity":        model.SeverityHigh,
			"category":        "Best Practices",
			"descriptionText": "",
			"descriptionUrl":  "",
			"platform":        "Common",
		},
		Aggregation: 1,
	})
	type args struct {
		ctx                 context.Context
		source              source.QueriesSource
		vb                  VulnerabilityBuilder
		tracker             Tracker
		queryFilter         source.QueryInspectorParameters
		excludeResults      map[string]bool
		queryExecTimeout    int
		needsLog            bool
		useOldSeverities    bool
		numWorkers          int
		kicsComputeNewSimID bool
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
				ctx:     context.Background(),
				vb:      vbs,
				tracker: track,
				source:  sources,
				queryFilter: source.QueryInspectorParameters{
					IncludeQueries: source.IncludeQueries{
						ByIDs: []string{},
					},
					ExcludeQueries: source.ExcludeQueries{
						ByIDs:        []string{},
						ByCategories: []string{},
					},
				},
				excludeResults:      map[string]bool{},
				queryExecTimeout:    60,
				needsLog:            true,
				numWorkers:          1,
				kicsComputeNewSimID: true,
			},
			want: &Inspector{
				vb:      vbs,
				tracker: track,
				QueryLoader: &QueryLoader{
					QueriesMetadata: opaQueries,
				},
			},
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := NewInspector(tt.args.ctx,
				tt.args.source,
				tt.args.vb,
				tt.args.tracker,
				&tt.args.queryFilter,
				tt.args.excludeResults,
				tt.args.queryExecTimeout,
				tt.args.useOldSeverities,
				tt.args.needsLog,
				tt.args.numWorkers, tt.args.kicsComputeNewSimID)

			if (err != nil) != tt.wantErr {
				t.Errorf("NewInspector() error: got = %v,\n wantErr = %v", err, tt.wantErr)
				return
			}

			require.Equal(t, len(tt.want.QueryLoader.QueriesMetadata), len(got.QueryLoader.QueriesMetadata))

			for idx := 0; idx < len(tt.want.QueryLoader.QueriesMetadata); idx++ {
				gotStrMetadata, err := test.StringifyStruct(got.QueryLoader.QueriesMetadata[idx].Metadata)
				require.Nil(t, err)
				wantStrMetadata, err := test.StringifyStruct(tt.want.QueryLoader.QueriesMetadata[idx].Metadata)
				require.Nil(t, err)
				if !reflect.DeepEqual(got.QueryLoader.QueriesMetadata[idx].Metadata, tt.want.QueryLoader.QueriesMetadata[idx].Metadata) {
					t.Errorf("NewInspector() metadata: got = %v,\n want = %v", gotStrMetadata, wantStrMetadata)
				}
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

func TestEngine_contains(t *testing.T) {
	type args struct {
		s []string
		e string
	}
	tests := []struct {
		name string
		args args
		want bool
	}{
		{
			name: "test_contains_common",
			args: args{
				s: []string{""},
				e: "common",
			},
			want: true,
		},
		{
			name: "test_contains_k8s",
			args: args{
				s: []string{"kubernetes"},
				e: "k8s",
			},
			want: true,
		},
		{
			name: "test_contains_k8s",
			args: args{
				s: []string{"terraform", "cloudformation"},
				e: "terraform",
			},
			want: true,
		},
		{
			name: "test_not_contains",
			args: args{
				s: []string{"cloudformation"},
				e: "terraform",
			},
			want: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := contains(tt.args.s, tt.args.e)
			require.Equal(t, tt.want, got)
		})
	}
}

func TestEngine_LenQueriesByPlat(t *testing.T) {
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Fatal(err)
	}

	type args struct {
		queriesPath         []string
		platform            []string
		kicsComputeNewSimID bool
	}
	tests := []struct {
		name string
		args args
		min  int
	}{
		{
			name: "test_len_queries_plat",
			args: args{
				queriesPath:         []string{filepath.FromSlash("./test/fixtures")},
				platform:            []string{"terraform"},
				kicsComputeNewSimID: true,
			},
			min: 1,
		},
		{
			name: "test_len_queries_plat_with_multiple_queries_path",
			args: args{
				queriesPath: []string{
					filepath.FromSlash("./assets/queries/terraform/aws/alb_deletion_protection_disabled"),
					filepath.FromSlash("./assets/queries/terraform/aws/alb_is_not_integrated_with_waf"),
				},
				platform:            []string{"terraform"},
				kicsComputeNewSimID: true,
			},
			min: 2,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			ins := newInspectorInstance(t, tt.args.queriesPath, tt.args.kicsComputeNewSimID)
			got := ins.LenQueriesByPlat(tt.args.platform)
			require.True(t, got >= tt.min)
		})
	}
}

func TestEngine_GetFailedQueries(t *testing.T) {
	if err := test.ChangeCurrentDir("kics"); err != nil {
		t.Fatal(err)
	}
	type args struct {
		queriesPath         []string
		nrFailedQueries     int
		kicsComputeNewSimID bool
	}
	tests := []struct {
		name string
		args args
	}{
		{
			name: "test_get_failed_queries",
			args: args{
				queriesPath:         []string{filepath.FromSlash("./test/fixtures")},
				nrFailedQueries:     5,
				kicsComputeNewSimID: true,
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			ins := newInspectorInstance(t, tt.args.queriesPath, tt.args.kicsComputeNewSimID)
			fail := make([]string, tt.args.nrFailedQueries)
			for idx := range fail {
				ins.failedQueries[fmt.Sprint(idx)] = nil
			}
			got := ins.GetFailedQueries()
			require.Equal(t, tt.args.nrFailedQueries, len(got))
		})
	}
}

func TestShouldSkipFile(t *testing.T) {
	type args struct {
		commands model.CommentsCommands
		queryID  string
	}
	tests := []struct {
		name     string
		args     args
		expected bool
	}{
		{
			name: "test_enabled_queries_valid_query",
			args: args{
				commands: model.CommentsCommands{
					"enable": "ffdf4b37-7703-4dfe-a682-9d2e99bc6c09,0afa6ab8-a047-48cf-be07-93a2f8c34cf7",
				},
				queryID: "ffdf4b37-7703-4dfe-a682-9d2e99bc6c09",
			},
			expected: false,
		},
		{
			name: "test_enabled_queries_invalid_query",
			args: args{
				commands: model.CommentsCommands{
					"enable": "0afa6ab8-a047-48cf-be07-93a2f8c34cf7",
				},
				queryID: "ffdf4b37-7703-4dfe-a682-9d2e99bc6c09",
			},
			expected: true,
		},
		{
			name: "test_disabled_queries_invalid_query",
			args: args{
				commands: model.CommentsCommands{
					"disable": "ffdf4b37-7703-4dfe-a682-9d2e99bc6c09,0afa6ab8-a047-48cf-be07-93a2f8c34cf7",
				},
				queryID: "ffdf4b37-7703-4dfe-a682-9d2e99bc6c09",
			},
			expected: true,
		},
		{
			name: "test_disabled_queries_invalid_query",
			args: args{
				commands: model.CommentsCommands{
					"disable": "0afa6ab8-a047-48cf-be07-93a2f8c34cf7",
				},
				queryID: "ffdf4b37-7703-4dfe-a682-9d2e99bc6c09",
			},
			expected: false,
		},
		{
			name: "test_withoutCommands",
			args: args{
				commands: model.CommentsCommands{},
				queryID:  "ffdf4b37-7703-4dfe-a682-9d2e99bc6c09",
			},
			expected: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := ShouldSkipVulnerability(tt.args.commands, tt.args.queryID)
			require.Equal(t, tt.expected, got)
		})
	}
}

func TestInspector_DecodeQueryResults(t *testing.T) {

	//context
	contextToUSe := context.Background()

	//build inspector
	c := newInspectorInstance(t, []string{}, true)

	type args struct {
		queryContext QueryContext
		regoResult   rego.ResultSet
		timeDuration string
	}
	tests := []struct {
		name     string
		args     args
		expected int
	}{
		{
			name: "should_not_fail_when_timeout",
			args: args{
				queryContext: newQueryContext(contextToUSe),
				regoResult:   newResultset(),
				timeDuration: "0s",
			},
			expected: 0,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			//create a context with 0 second to timeout
			timeoutDuration, _ := time.ParseDuration(tt.args.timeDuration)
			myCtxTimeOut, _ := context.WithTimeout(contextToUSe, timeoutDuration)
			result, err := c.DecodeQueryResults(&tt.args.queryContext, myCtxTimeOut, tt.args.regoResult)
			assert.Nil(t, err, "Error not as expected")
			assert.Equal(t, 0, len(result), "Array size is not as expected")
		})
	}
}

func newResultset() rego.ResultSet {
	myValue := make(map[string]interface{})
	myValue["documentId"] = "3a3be8f7-896e-4ef8-9db3-d6c19e60510b"
	myValue["issueType"] = "IncorrectValue"
	myValue["keyActualValue"] = "COPY --from referencesthe current FROM alias"
	myValue["keyExpectedValue"] = "COPY --from should not references the current FROM alias"
	myValue["searchKey"] = "{{ADD ${JAR_FILE} app.jar}}"

	myBinding := make([]interface{}, 1)
	myBinding[0] = myValue

	myresult := rego.Result{
		Bindings: map[string]interface{}{
			"result": myBinding,
		},
	}
	myResultSet := rego.ResultSet{myresult}
	return myResultSet
}

func newQueryContext(ctx context.Context) QueryContext {
	queryMetadata := model.QueryMetadata{
		Platform: "myPlatform",
		Query:    "myQuery"}
	myQuery := PreparedQuery{
		Metadata: queryMetadata,
	}
	queryContext := QueryContext{
		Ctx:   ctx,
		Query: &myQuery,
	}
	return queryContext
}

func newInspectorInstance(t *testing.T, queryPath []string, kicsComputeNewSimID bool) *Inspector {
	querySource := source.NewFilesystemSource(queryPath, []string{""}, []string{""}, filepath.FromSlash("./assets/libraries"), true)
	var vb = func(ctx *QueryContext, tracker Tracker, v interface{},
		detector *detector.DetectLine, useOldSeverity bool, kicsComputeNewSimID bool) (*model.Vulnerability, error) {
		return &model.Vulnerability{}, nil
	}
	ins, err := NewInspector(
		context.Background(),
		querySource,
		vb,
		&tracker.CITracker{},
		&source.QueryInspectorParameters{},
		map[string]bool{}, 60,
		false, true, 1,
		kicsComputeNewSimID,
	)
	require.NoError(t, err)
	return ins
}

type mockSource struct {
	Source []string
	Types  []string
}

func (m *mockSource) GetQueries(queryFilter *source.QueryInspectorParameters) ([]model.QueryMetadata, error) {
	sources := source.NewFilesystemSource(m.Source, []string{""}, []string{""}, filepath.FromSlash("./assets/libraries"), true)

	return sources.GetQueries(queryFilter)
}

func (m *mockSource) GetQueryLibrary(platform string) (source.RegoLibraries, error) {
	library := source.GetPathToCustomLibrary(platform, "./assets/libraries")

	if library != "default" {
		content, err := os.ReadFile(library)
		return source.RegoLibraries{
			LibraryCode:      string(content),
			LibraryInputData: "{}",
		}, err
	}

	log.Debug().Msgf("Custom library not provided. Loading embedded library instead")

	// getting embedded library
	embeddedLibrary, errGettingEmbeddedLibrary := assets.GetEmbeddedLibrary(strings.ToLower(platform))

	return source.RegoLibraries{
		LibraryCode:      embeddedLibrary,
		LibraryInputData: "{}",
	}, errGettingEmbeddedLibrary
}

func TestInspector_checkComment(t *testing.T) {
	tests := []struct {
		name  string
		lines []int
		line  int
		want  bool
	}{
		{
			name:  "test_checkComment_true",
			lines: []int{1, 2, 3, 4, 5, 6},
			line:  3,
			want:  true,
		},
		{
			name:  "test_checkComment_false",
			lines: []int{1, 2, 3, 4, 5, 6},
			line:  7,
			want:  false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := checkComment(tt.line, tt.lines); got != tt.want {
				t.Errorf("checkComment() = %v, want %v", got, tt.want)
			}
		})
	}
}
