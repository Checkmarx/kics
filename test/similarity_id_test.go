package test

import (
	"context"
	"fmt"
	"io/ioutil"
	"testing"

	"github.com/Checkmarx/kics/internal/tracker"
	"github.com/Checkmarx/kics/pkg/engine"
	"github.com/Checkmarx/kics/pkg/engine/mock"
	"github.com/Checkmarx/kics/pkg/engine/query"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/golang/mock/gomock"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/stretchr/testify/require"
)

const (
	fixtureDir = "fixtures"
)

type testCaseParamsType struct {
	queryID           string
	samplePath        string
	sampleFixturePath string
	queryDir          string
	queryFixturePath  string
	platform          string
}

type testParamsType struct {
	queryDir      string // mandatory
	platform      string // mandatory
	queryID       func() string
	samplePath    func() string
	sampleContent func() []byte
	queryContent  func() string
}

type testCaseType struct {
	name             string
	calls            []testParamsType
	expectedFunction func(t *testing.T, condition bool)
}

var (
	fileExtension = map[string][]string{
		"ansible":        {".yaml", ".yml"},
		"terraform":      {".tf"},
		"docker":         {".dockerfile"},
		"k8s":            {".yaml", ".yml"},
		"cloudFormation": {".yaml", ".yml"},
	}
	testTable = []testCaseType{
		{
			name: "Changed Sample and Query SimID Should Be Equal",
			calls: []testParamsType{
				getTestParams(&testCaseParamsType{
					platform: "terraform",
					queryDir: "../assets/queries/terraform/aws/redshift_publicly_accessible",
				}),
				getTestParams(&testCaseParamsType{
					platform:          "terraform",
					queryDir:          "../assets/queries/terraform/aws/redshift_publicly_accessible",
					sampleFixturePath: fmt.Sprintf("%s/tc-sim01/positive.tf", fixtureDir),
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
					platform: "terraform",
					queryDir: "../assets/queries/terraform/aws/redshift_publicly_accessible",
				}),
				getTestParams(&testCaseParamsType{
					platform:          "terraform",
					queryDir:          "../assets/queries/terraform/aws/redshift_publicly_accessible",
					sampleFixturePath: fmt.Sprintf("%s/tc-sim02/positive.tf", fixtureDir),
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
					samplePath: "../ANOTHER-FILE-PATH/redshift_publicly_accessible/test/positive.tf",
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
					queryDir: "../assets/queries/cloudFormation/amazon_mq_broker_encryption_disabled",
				}),
				getTestParams(&testCaseParamsType{
					platform: "cloudFormation",
					queryDir: "../assets/queries/cloudFormation/amazon_mq_broker_encryption_disabled",
				}),
			},
			expectedFunction: func(t *testing.T, condition bool) {
				require.True(t, condition)
			},
		},
	}
)

func TestInspectorSimilarityID(t *testing.T) {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: ioutil.Discard})

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
		metadata := query.ReadMetadata(params.queryDir)
		v := metadata["id"]
		testQueryID = v.(string)
	} else {
		testQueryID = params.queryID
	}
	return testQueryID
}

func getTestSampleContent(params *testCaseParamsType) []byte {
	var testSampleContent []byte
	if params.sampleFixturePath != "" {
		testSampleContent = getFileContent(params.sampleFixturePath)
	} else {
		testSampleContent = getSampleContent(params)
	}
	return testSampleContent
}

func getTestQueryContent(params *testCaseParamsType) string {
	var testSampleContent string
	if params.queryFixturePath != "" {
		testSampleContent = string(getFileContent(params.queryFixturePath))
	} else {
		testSampleContent = getQueryContent(params.queryDir)
	}
	return testSampleContent
}

func getTestParams(params *testCaseParamsType) testParamsType {
	return testParamsType{
		queryDir: params.queryDir,
		queryID: func() string {
			return getTestQueryID(params)
		},
		samplePath: func() string {
			return getSamplePath(params)
		},
		sampleContent: func() []byte {
			return getTestSampleContent(params)
		},
		queryContent: func() string {
			return getTestQueryContent(params)
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

	queriesSource.EXPECT().GetQueries().DoAndReturn(func() ([]model.QueryMetadata, error) {
		metadata := query.ReadMetadata(testParams.queryDir)

		// Override metadata ID with custom QueryID for testing
		if testParams.queryID() != metadata["id"] {
			metadata["id"] = testParams.queryID()
		}

		q := model.QueryMetadata{
			Query:    testParams.queryID(),
			Content:  testParams.queryContent(),
			Metadata: metadata,
			Platform: testParams.platform,
		}
		return []model.QueryMetadata{q}, nil
	})

	queriesSource.EXPECT().GetGenericQuery("commonQuery").
		DoAndReturn(func(string) (string, error) {
			q, err := readLibrary("commonQuery")
			require.NoError(t, err)
			return q, nil
		})

	queriesSource.EXPECT().GetGenericQuery(testParams.platform).
		DoAndReturn(func(string) (string, error) {
			q, err := readLibrary(testParams.platform)
			require.NoError(t, err)
			return q, nil
		})

	inspector, err := engine.NewInspector(ctx, queriesSource, engine.DefaultVulnerabilityBuilder, &tracker.CITracker{})
	require.Nil(t, err)
	require.NotNil(t, inspector)

	vulnerabilities, err := inspector.Inspect(
		ctx,
		scanID,
		getScannableFileMetadatas(
			t,
			testParams.samplePath(),
			testParams.sampleContent(),
		),
	)
	require.Nil(t, err)
	return vulnerabilities
}
