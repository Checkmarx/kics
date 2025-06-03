package engine

import (
	"context"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/open-policy-agent/opa/v1/rego"
	"github.com/stretchr/testify/assert"

	"github.com/Checkmarx/kics/v2/assets"
	"github.com/Checkmarx/kics/v2/internal/tracker"
	"github.com/Checkmarx/kics/v2/pkg/detector"
	"github.com/Checkmarx/kics/v2/pkg/detector/docker"
	"github.com/Checkmarx/kics/v2/pkg/detector/helm"
	"github.com/Checkmarx/kics/v2/pkg/engine/source"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/progress"
	"github.com/Checkmarx/kics/v2/pkg/utils"
	"github.com/Checkmarx/kics/v2/test"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/stretchr/testify/require"

	"github.com/open-policy-agent/opa/v1/cover"
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

// TestInspect tests the functions [Inspect()] and all the methods called by them
func TestInspect(t *testing.T) { //nolint
	inspDetector := detector.NewDetectLine(3).
		Add(helm.DetectKindLine{}, model.KindHELM).
		Add(docker.DetectKindLine{}, model.KindDOCKER)
	ctx := context.Background()
	opaQueries := make([]model.QueryMetadata, 0, 1)
	opaQueries = append(opaQueries, model.QueryMetadata{
		Query:     "add_instead_of_copy",
		Platform:  "Dockerfile",
		InputData: "{}",
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
		queryLoader          QueryLoader
		vb                   VulnerabilityBuilder
		tracker              Tracker
		enableCoverageReport bool
		coverageReport       cover.Report
		excludeResults       map[string]bool
	}
	type args struct {
		ctx                 context.Context
		scanID              string
		files               model.FileMetadatas
		kicsComputeNewSimID bool
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
				queryLoader: QueryLoader{
					QueriesMetadata: opaQueries,
					commonLibrary: source.RegoLibraries{
						LibraryCode:      "package generic.common",
						LibraryInputData: "",
					},
					platformLibraries: map[string]source.RegoLibraries{
						"Dockerfile": {
							LibraryCode:      "package generic.dockerfile",
							LibraryInputData: "",
						},
					},
				},
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
						ID:                "3a3be8f7-896e-4ef8-9db3-d6c19e60510b",
						ScanID:            "scanID",
						Document:          mockedFileMetadataDocument,
						OriginalData:      "orig_data",
						Kind:              "DOCKERFILE",
						FilePath:          "assets/queries/dockerfile/add_instead_of_copy/test/positive.dockerfile",
						LinesOriginalData: utils.SplitLines("orig_data"),
					},
				},
				kicsComputeNewSimID: true,
			},
			want: []model.Vulnerability{
				{
					ID:               0,
					SimilarityID:     "fec62a97d569662093dbb9739360942fc2a0c47bedec0bfcae05dc9d899d3ebe",
					OldSimilarityID:  "fec62a97d569662093dbb9739360942fc2a0c47bedec0bfcae05dc9d899d3ebe",
					ScanID:           "scanID",
					FileID:           "3a3be8f7-896e-4ef8-9db3-d6c19e60510b",
					FileName:         "assets/queries/dockerfile/add_instead_of_copy/test/positive.dockerfile",
					QueryID:          "Undefined",
					QueryName:        "Anonymous",
					QueryURI:         "https://github.com/Checkmarx/kics/",
					Description:      "",
					DescriptionID:    "Undefined",
					Severity:         model.SeverityInfo,
					Line:             1,
					SearchLine:       -1,
					VulnLines:        &[]model.CodeLine{},
					IssueType:        "IncorrectValue",
					SearchKey:        "{{ADD ${JAR_FILE} app.jar}}",
					KeyExpectedValue: "'COPY' app.jar",
					KeyActualValue:   "'ADD' app.jar",
					Value:            nil,
					Output:           `{"documentId":"3a3be8f7-896e-4ef8-9db3-d6c19e60510b","issueType":"IncorrectValue","keyActualValue":"'ADD' app.jar","keyExpectedValue":"'COPY' app.jar","searchKey":"{{ADD ${JAR_FILE} app.jar}}"}`, //nolint
				},
			},
			wantErr: false,
		},
		{
			name: "TestInspectExcludeResult",
			fields: fields{
				queryLoader: QueryLoader{
					QueriesMetadata: opaQueries,
					commonLibrary: source.RegoLibraries{
						LibraryCode:      "package generic.common",
						LibraryInputData: "",
					},
					platformLibraries: map[string]source.RegoLibraries{
						"Dockerfile": {
							LibraryCode:      "package generic.dockerfile",
							LibraryInputData: "",
						},
					},
				},
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
						ID:                "3a3be8f7-896e-4ef8-9db3-d6c19e60510b",
						ScanID:            "scanID",
						Document:          mockedFileMetadataDocument,
						OriginalData:      "orig_data",
						Kind:              "DOCKERFILE",
						FilePath:          "assets/queries/dockerfile/add_instead_of_copy/test/positive.dockerfile",
						LinesOriginalData: utils.SplitLines("orig_data"),
					},
				},
				kicsComputeNewSimID: true,
			},
			want:    []model.Vulnerability{},
			wantErr: false,
		},
	}

	wg := &sync.WaitGroup{}
	for _, tt := range tests {
		currentQuery := make(chan int64)
		wg.Add(1)
		proBarBuilder := progress.InitializePbBuilder(true, true, true)
		progressBar := proBarBuilder.BuildCounter("Executing queries: ", len(tt.fields.queryLoader.QueriesMetadata), wg, currentQuery)

		go progressBar.Start()
		t.Run(tt.name, func(t *testing.T) {
			c := &Inspector{
				QueryLoader:          &tt.fields.queryLoader,
				vb:                   tt.fields.vb,
				tracker:              tt.fields.tracker,
				enableCoverageReport: tt.fields.enableCoverageReport,
				coverageReport:       tt.fields.coverageReport,
				excludeResults:       tt.fields.excludeResults,
				detector:             inspDetector,
				queryExecTimeout:     time.Duration(60) * time.Second,
				numWorkers:           1,
				kicsComputeNewSimID:  tt.args.kicsComputeNewSimID,
			}
			got, err := c.Inspect(tt.args.ctx, tt.args.scanID, tt.args.files,
				[]string{filepath.FromSlash("assets/queries/")}, []string{"Dockerfile"}, currentQuery)
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
				t.Errorf("Inspector.Inspect() got %v,\nwant %v", gotStrVulnerabilities, wantStrVulnerabilities)
			}
		})

		defer func() {
			close(currentQuery)
		}()
	}
	wg.Wait()
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
				s: []string{"terraform", "dockerfile", "cloudformation"},
				e: "terraform",
			},
			want: true,
		},
		{
			name: "test_not_contains",
			args: args{
				s: []string{"dockerfile", "cloudformation"},
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

func TestInspector_prepareQueries(t *testing.T) {
	type args struct {
		queries           []model.QueryMetadata
		commonLibrary     source.RegoLibraries
		platformLibraries map[string]source.RegoLibraries
		tracker           Tracker
	}

	tests := []struct {
		name string
		args args
		want QueryLoader
	}{
		{
			name: "test_prepareQueries",
			args: args{
				queries: []model.QueryMetadata{
					{
						Metadata: map[string]interface{}{
							"id":          "ffdf4b37-7703-4dfe-a682-9d2e99bc6c09",
							"aggregation": 3,
						},
						Query:       `package main`,
						Aggregation: 3,
					},
				},
				commonLibrary: source.RegoLibraries{
					LibraryCode:      "",
					LibraryInputData: "{}",
				},
				platformLibraries: map[string]source.RegoLibraries{
					"Dockerfile": {
						LibraryCode:      "",
						LibraryInputData: "{}",
					},
				},
				tracker: &tracker.CITracker{},
			},
			want: QueryLoader{
				QueriesMetadata: []model.QueryMetadata{
					{
						Metadata: map[string]interface{}{
							"id":          "ffdf4b37-7703-4dfe-a682-9d2e99bc6c09",
							"aggregation": 3,
						},
						Query:       `package main`,
						Aggregation: 3,
					},
				},
				querySum: 3,
				commonLibrary: source.RegoLibraries{
					LibraryCode:      "",
					LibraryInputData: "{}",
				},
				platformLibraries: map[string]source.RegoLibraries{
					"Dockerfile": {
						LibraryCode:      "",
						LibraryInputData: "{}",
					},
				},
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := prepareQueries(tt.args.queries, tt.args.commonLibrary, tt.args.platformLibraries, tt.args.tracker); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("prepareQueries() = %v, want %v", got, tt.want)
			}
		})
	}
}
