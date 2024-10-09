package test

import (
	"context"
	"fmt"
	"io"
	"sync"
	"testing"

	"github.com/Checkmarx/kics/v2/internal/tracker"
	"github.com/Checkmarx/kics/v2/pkg/engine"
	"github.com/Checkmarx/kics/v2/pkg/engine/mock"
	"github.com/Checkmarx/kics/v2/pkg/engine/source"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/progress"
	"github.com/golang/mock/gomock"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/stretchr/testify/require"
)

const (
	fixtureDir = "fixtures"
)

type testCaseParamsType struct {
	queryDir          string // mandatory - query path inside assets directory
	platform          string // mandatory - query platform type
	queryID           string
	samplePath        string
	sampleFixturePath string
	queryFixturePath  string
}

type testParamsType struct {
	queryDir      string // mandatory
	platform      string // mandatory
	queryID       func() string
	samplePath    func(t testing.TB) string
	sampleContent func(t testing.TB) []byte
	queryContent  func(t testing.TB) string
}

type testCaseType struct {
	name             string
	calls            []testParamsType
	expectedFunction func(t *testing.T, condition bool)
}

var (
	fileExtension = map[string][]string{
		"ansible":                 {".yaml", ".yml"},
		"azureResourceManager":    {".json"},
		"buildah":                 {".sh"},
		"cicd":                    {".yaml", ".yml"},
		"cloudFormation":          {".json", ".yaml", ".yml"},
		"docker":                  {".dockerfile"},
		"googleDeploymentManager": {".yaml", ".yml"},
		"grpc":                    {".proto"},
		"k8s":                     {".yaml", ".yml"},
		"openapi":                 {".json", ".yaml", ".yml"},
		"terraform":               {".tf"},
	}
	testTable = []testCaseType{
		{
			name: "Changed Sample and Query SimID Should Be Equal",
			calls: []testParamsType{
				getTestParams(&testCaseParamsType{
					platform:          "terraform",
					queryDir:          "../assets/queries/terraform/aws/redshift_publicly_accessible",
					sampleFixturePath: fmt.Sprintf("%s/tc-sim01/positive1.tf", fixtureDir),
				}),
				getTestParams(&testCaseParamsType{
					platform:          "terraform",
					queryDir:          "../assets/queries/terraform/aws/redshift_publicly_accessible",
					sampleFixturePath: fmt.Sprintf("%s/tc-sim01/positive2.tf", fixtureDir),
					queryFixturePath:  fmt.Sprintf("%s/tc-sim01/query.rego", fixtureDir),
				}),
			},
			expectedFunction: func(t *testing.T, condition bool) {
				require.True(t, condition)
			},
		},
		{
			name: "Changed QueryID SimID Should Be Different",
			calls: []testParamsType{
				getTestParams(&testCaseParamsType{
					platform: "terraform",
					queryDir: "../assets/queries/terraform/aws/redshift_publicly_accessible",
				}),
				getTestParams(&testCaseParamsType{
					platform: "terraform",
					queryDir: "../assets/queries/terraform/aws/redshift_publicly_accessible",
					queryID:  "ANOTHER_DIFFERENT_ID",
				}),
			},
			expectedFunction: func(t *testing.T, condition bool) {
				require.False(t, condition)
			},
		},
		{
			name: "Changed Sample SimID Should Be Equal",
			calls: []testParamsType{
				getTestParams(&testCaseParamsType{
					platform:          "terraform",
					queryDir:          "../assets/queries/terraform/aws/redshift_publicly_accessible",
					sampleFixturePath: fmt.Sprintf("%s/tc-sim02/positive1.tf", fixtureDir),
				}),
				getTestParams(&testCaseParamsType{
					platform:          "terraform",
					queryDir:          "../assets/queries/terraform/aws/redshift_publicly_accessible",
					sampleFixturePath: fmt.Sprintf("%s/tc-sim02/positive2.tf", fixtureDir),
				}),
			},
			expectedFunction: func(t *testing.T, condition bool) {
				require.True(t, condition)
			},
		},
		{
			name: "Changed Query SimID Should Be Equal",
			calls: []testParamsType{
				getTestParams(&testCaseParamsType{
					platform: "terraform",
					queryDir: "../assets/queries/terraform/aws/redshift_publicly_accessible",
				}),
				getTestParams(&testCaseParamsType{
					platform:         "terraform",
					queryDir:         "../assets/queries/terraform/aws/redshift_publicly_accessible",
					queryFixturePath: fmt.Sprintf("%s/tc-sim03/query.rego", fixtureDir),
				}),
			},
			expectedFunction: func(t *testing.T, condition bool) {
				require.True(t, condition)
			},
		},
		{
			name: "Changed Sample Path SimID Should Be Different",
			calls: []testParamsType{
				getTestParams(&testCaseParamsType{
					platform: "terraform",
					queryDir: "../assets/queries/terraform/aws/redshift_publicly_accessible",
				}),
				getTestParams(&testCaseParamsType{
					platform:   "terraform",
					queryDir:   "../assets/queries/terraform/aws/redshift_publicly_accessible",
					samplePath: "../test/fixtures/test_extension/positive.tf",
				}),
			},
			expectedFunction: func(t *testing.T, condition bool) {
				require.False(t, condition)
			},
		},
		{
			name: "Unchaged CloudFormation Sample SimID Should Be Equal",
			calls: []testParamsType{
				getTestParams(&testCaseParamsType{
					platform: "cloudFormation",
					queryDir: "../assets/queries/cloudFormation/aws/api_gateway_with_open_access",
				}),
				getTestParams(&testCaseParamsType{
					platform: "cloudFormation",
					queryDir: "../assets/queries/cloudFormation/aws/api_gateway_with_open_access",
				}),
			},
			expectedFunction: func(t *testing.T, condition bool) {
				require.True(t, condition)
			},
		},
	}
)

func TestInspectorSimilarityID(t *testing.T) {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: io.Discard})

	for _, tc := range testTable {
		t.Run(tc.name, func(tt *testing.T) {
			callOneSimilarityIDS := runInspectorAndGetSimilarityIDs(tt, tc.calls[0])
			require.Greater(t, len(callOneSimilarityIDS), 0)
			callTwoSimilarityIDS := runInspectorAndGetSimilarityIDs(tt, tc.calls[1])
			require.Greater(t, len(callTwoSimilarityIDS), 0)
			for _, simIDOne := range callOneSimilarityIDS {
				tc.expectedFunction(tt, sliceContains(callTwoSimilarityIDS, simIDOne))
			}
		})
	}
}

func getTestQueryID(params *testCaseParamsType) string {
	var testQueryID string
	if params.queryID == "" {
		metadata, err := source.ReadMetadata(params.queryDir)
		if err != nil {
			return ""
		}
		v := metadata["id"]
		testQueryID = v.(string)
	} else {
		testQueryID = params.queryID
	}
	return testQueryID
}

func getTestSampleContent(tb testing.TB, params *testCaseParamsType) ([]byte, error) {
	var testSampleContent []byte
	var err error
	if params.sampleFixturePath != "" {
		testSampleContent, err = getFileContent(params.sampleFixturePath)
	} else {
		testSampleContent, err = getSampleContent(tb, params)
	}
	return testSampleContent, err
}

func getTestQueryContent(params *testCaseParamsType) (string, error) {
	var testSampleContent string
	var err error
	if params.queryFixturePath != "" {
		content, contentErr := getFileContent(params.queryFixturePath)
		err = contentErr
		testSampleContent = string(content)
	} else {
		testSampleContent, err = getQueryContent(params.queryDir)
	}
	return testSampleContent, err
}

func getTestParams(params *testCaseParamsType) testParamsType {
	return testParamsType{
		queryDir: params.queryDir,
		queryID: func() string {
			return getTestQueryID(params)
		},
		samplePath: func(t testing.TB) string {
			return getSamplePath(t, params)
		},
		sampleContent: func(t testing.TB) []byte {
			content, err := getTestSampleContent(t, params)
			require.Nil(t, err)
			return content
		},
		queryContent: func(t testing.TB) string {
			content, err := getTestQueryContent(params)
			require.Nil(t, err)
			return content
		},
		platform: params.platform,
	}
}

func runInspectorAndGetSimilarityIDs(t *testing.T, testParams testParamsType) []string {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	ctx := context.TODO()

	vulnerabilities := createInspectorAndGetVulnerabilities(ctx, t, ctrl, testParams)

	similarityIDs := make([]string, 0, len(vulnerabilities))
	for i := 0; i < len(vulnerabilities); i++ {
		similarityIDs = append(similarityIDs, vulnerabilities[i].SimilarityID)
	}
	return similarityIDs
}

func createInspectorAndGetVulnerabilities(ctx context.Context, t testing.TB,
	ctrl *gomock.Controller, testParams testParamsType) []model.Vulnerability {
	queriesSource := mock.NewMockQueriesSource(ctrl)

	queriesSource.EXPECT().GetQueries(getQueryFilter()).
		DoAndReturn(func(interface{}) ([]model.QueryMetadata, error) {
			metadata, err := source.ReadMetadata(testParams.queryDir)
			require.NoError(t, err)

			// Override metadata ID with custom QueryID for testing
			if testParams.queryID() != metadata["id"] {
				metadata["id"] = testParams.queryID()
			}

			q := model.QueryMetadata{
				Query:     testParams.queryID(),
				Content:   testParams.queryContent(t),
				InputData: "{}",
				Metadata:  metadata,
				Platform:  testParams.platform,
			}
			return []model.QueryMetadata{q}, nil
		})

	queriesSource.EXPECT().GetQueryLibrary("common").
		DoAndReturn(func(string) (source.RegoLibraries, error) {
			q, err := readLibrary("common")
			require.NoError(t, err)
			return q, nil
		})

	queriesSource.EXPECT().GetQueryLibrary(testParams.platform).
		DoAndReturn(func(string) (source.RegoLibraries, error) {
			q, err := readLibrary(testParams.platform)
			require.NoError(t, err)
			return q, nil
		})

	inspector, err := engine.NewInspector(ctx,
		queriesSource,
		engine.DefaultVulnerabilityBuilder,
		&tracker.CITracker{},
		&source.QueryInspectorParameters{
			IncludeQueries: source.IncludeQueries{ByIDs: []string{}},
			ExcludeQueries: source.ExcludeQueries{ByIDs: []string{}, ByCategories: []string{}},
			InputDataPath:  "",
		},
		map[string]bool{}, 60, true, true, 1, false)

	require.Nil(t, err)
	require.NotNil(t, inspector)

	currentQuery := make(chan int64)

	wg := &sync.WaitGroup{}
	proBarBuilder := progress.InitializePbBuilder(true, true, true)
	platforms := []string{"Ansible", "AzureResourceManager", "Buildah", "CICD", "CloudFormation", "Dockerfile", "GRPC", "Kubernetes", "OpenAPI", "Terraform"}
	progressBar := proBarBuilder.BuildCounter("Executing queries: ", inspector.LenQueriesByPlat(platforms), wg, currentQuery)
	go progressBar.Start()

	wg.Add(1)
	vulnerabilities, err := inspector.Inspect(
		ctx,
		scanID,
		getFilesMetadatasWithContent(
			t,
			testParams.samplePath(t),
			testParams.sampleContent(t),
		),
		[]string{BaseTestsScanPath},
		[]string{"Ansible", "AzureResourceManager", "Buildah", "CICD", "CloudFormation", "Dockerfile", "GRPC", "Kubernetes", "OpenAPI", "Terraform"},
		currentQuery,
	)

	go func() {
		defer func() {
			close(currentQuery)
		}()
		wg.Wait()
	}()

	require.Nil(t, err)
	return vulnerabilities
}
