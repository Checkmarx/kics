package test

import (
	"context"
	"testing"

	"github.com/Checkmarx/kics/internal/tracker"
	"github.com/Checkmarx/kics/pkg/engine"
	"github.com/Checkmarx/kics/pkg/engine/mock"
	"github.com/Checkmarx/kics/pkg/engine/query"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/golang/mock/gomock"
	"github.com/stretchr/testify/require"
)

const (
	fixtureDir = "fixtures"
)

type inspectorSimilarityIDParams struct {
	queryID       string
	samplePath    string
	sampleContent func(queryDir string) []byte
	queryDir      string
	queryContent  func(queryDir string) string
	platform      string
}

type inspectorSimilarityIDTestCase struct {
	testCaseID       string
	calls            []inspectorSimilarityIDParams
	expectedFunction func(t *testing.T, condition bool)
}

func TestInspectorSimilarityID(t *testing.T) {

	testTable := []inspectorSimilarityIDTestCase{
		{
			testCaseID: "tc-sim01",
			calls: []inspectorSimilarityIDParams{
				{
					queryID:    "redshift_publicly_accessible",
					samplePath: "../assets/queries/terraform/aws/redshift_publicly_accessible/test/positive.tf",
					sampleContent: func(queryDir string) []byte {
						return getSampleContent(queryDir)
					},
					queryDir: "../assets/queries/terraform/aws/redshift_publicly_accessible",
					queryContent: func(queryDir string) string {
						return getQueryContent(queryDir)
					},
					platform: "terraform",
				},
				{
					queryID:    "redshift_publicly_accessible",
					samplePath: "../assets/queries/terraform/aws/redshift_publicly_accessible/test/positive.tf",
					sampleContent: func(queryDir string) []byte {
						// TODO get fixture content
						return getSampleContent(queryDir)
					},
					queryDir: "../assets/queries/terraform/aws/redshift_publicly_accessible",
					queryContent: func(queryDir string) string {
						// TODO get fixture content
						return getQueryContent(queryDir)
					},
					platform: "terraform",
				},
			},
			expectedFunction: func(t *testing.T, condition bool) {
				require.True(t, condition)
			},
		},
		{
			testCaseID: "tc-sim02",
			calls: []inspectorSimilarityIDParams{
				{
					queryID:    "redshift_publicly_accessible",
					samplePath: "../assets/queries/terraform/aws/redshift_publicly_accessible/test/positive.tf",
					sampleContent: func(queryDir string) []byte {
						return getSampleContent(queryDir)
					},
					queryDir: "../assets/queries/terraform/aws/redshift_publicly_accessible",
					queryContent: func(queryDir string) string {
						return getQueryContent(queryDir)
					},
					platform: "terraform",
				},
				{
					queryID:    "ANOTHER_DIFFERENT_ID",
					samplePath: "../assets/queries/terraform/aws/redshift_publicly_accessible/test/positive.tf",
					sampleContent: func(queryDir string) []byte {
						// TODO get fixture content
						return getSampleContent(queryDir)
					},
					queryDir: "../assets/queries/terraform/aws/redshift_publicly_accessible",
					queryContent: func(queryDir string) string {
						// TODO get fixture content
						return getQueryContent(queryDir)
					},
					platform: "terraform",
				},
			},
			expectedFunction: func(t *testing.T, condition bool) {
				require.False(t, condition)
			},
		},
	}

	for _, tc := range testTable {
		callOneSimilarityIDS := runInspectorAndGetSimilarityIDs(t, tc.calls[0])
		callTwoSimilarityIDS := runInspectorAndGetSimilarityIDs(t, tc.calls[1])
		for _, simIDOne := range callOneSimilarityIDS {
			tc.expectedFunction(t, sliceContains(callTwoSimilarityIDS, simIDOne))
		}
	}
}

func runInspectorAndGetSimilarityIDs(t *testing.T, testParams inspectorSimilarityIDParams) []string {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	ctx := context.TODO()

	vulnerabilities := createInspectorAndGetVulnerabilities(ctx, t, ctrl, testParams)

	similarityIDs := make([]string, 0, len(vulnerabilities))
	for _, vuln := range vulnerabilities {
		similarityIDs = append(similarityIDs, vuln.SimilarityID)
	}
	return similarityIDs
}

func createInspectorAndGetVulnerabilities(ctx context.Context, t testing.TB, ctrl *gomock.Controller,
	testParams inspectorSimilarityIDParams) []model.Vulnerability {

	queriesSource := mock.NewMockQueriesSource(ctrl)

	queriesSource.EXPECT().GetQueries().
		DoAndReturn(func() ([]model.QueryMetadata, error) {

			metadata := query.ReadMetadata(testParams.queryDir)

			// Override metadata ID with custom QueryID for testing
			if testParams.queryID != metadata["id"] {
				metadata["id"] = testParams.queryID
			}

			q := model.QueryMetadata{
				Query:    testParams.queryID,
				Content:  testParams.queryContent(testParams.queryDir),
				Metadata: metadata,
				Platform: testParams.platform,
			}
			return []model.QueryMetadata{q}, nil
		})

	queriesSource.EXPECT().GetGenericQuery("commonQuery").
		DoAndReturn(func(string) (string, error) {
			q, err := getPlatform("commonQuery")
			require.NoError(t, err)
			return q, nil
		})

	queriesSource.EXPECT().GetGenericQuery(testParams.platform).
		DoAndReturn(func(string) (string, error) {
			q, err := getPlatform(testParams.platform)
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
			testParams.samplePath,
			testParams.sampleContent(testParams.samplePath),
		),
	)
	require.Nil(t, err)
	return vulnerabilities
}
