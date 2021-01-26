package test

import (
	"context"
	"fmt"
	"io/ioutil"
	"path"
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
	fileID = 12345
	scanID = "test_scan"
)

var (
	requiredProperties = []string{
		"documentId",
		"searchKey",
		"issueType",
		"issueType",
		"keyExpectedValue",
		"keyActualValue",
	}

	searchValueAllowedQueriesPath = []string{
		"../assets/queries/ansible/azure/sensitive_port_is_exposed_to_entire_network",
		"../assets/queries/cloudFormation/ec2_sensitive_port_is_publicly_exposed",
		"../assets/queries/cloudFormation/elb_sensitive_port_is_exposed_to_entire_network",
		"../assets/queries/terraform/aws/sensitive_port_is_exposed_to_entire_network",
		"../assets/queries/terraform/aws/sensitive_port_is_exposed_to_small_public_network",
		"../assets/queries/terraform/azure/sensitive_port_is_exposed_to_entire_network",
		"../assets/queries/terraform/azure/sensitive_port_is_exposed_to_small_public_network",
	}

	searchValueProperty = "searchValue"
)

func TestQueriesContent(t *testing.T) {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: ioutil.Discard})

	queries := loadQueries(t)

	for _, entry := range queries {
		t.Run(path.Base(entry.dir), func(t *testing.T) {
			testQueryHasAllRequiredFiles(t, entry)
			testQueryHasGoodReturnParams(t, entry)
		})
	}
}

func testQueryHasAllRequiredFiles(t *testing.T, entry queryEntry) {
	require.FileExists(t, path.Join(entry.dir, query.QueryFileName))
	require.FileExists(t, path.Join(entry.dir, query.MetadataFileName))
	require.FileExists(t, entry.PositiveFile())
	require.FileExists(t, entry.NegativeFile())
	require.FileExists(t, entry.ExpectedPositiveResultFile())
}

func testQueryHasGoodReturnParams(t *testing.T, entry queryEntry) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	ctx := context.Background()

	queriesSource := mock.NewMockQueriesSource(ctrl)
	queriesSource.EXPECT().GetQueries().
		DoAndReturn(func() ([]model.QueryMetadata, error) {
			q, err := query.ReadQuery(entry.dir)

			return []model.QueryMetadata{q}, err
		})

	queriesSource.EXPECT().GetGenericQuery("commonQuery").
		DoAndReturn(func(string) (string, error) {
			q, err := readLibrary("commonQuery")
			require.NoError(t, err)
			return q, nil
		})

	queriesSource.EXPECT().GetGenericQuery(entry.platform).
		DoAndReturn(func(string) (string, error) {
			q, err := readLibrary(entry.platform)
			require.NoError(t, err)
			return q, nil
		})

	trk := &tracker.CITracker{}

	inspector, err := engine.NewInspector(
		ctx,
		queriesSource,
		func(ctx engine.QueryContext, trk engine.Tracker, v interface{}) (model.Vulnerability, error) {
			m, ok := v.(map[string]interface{})
			require.True(t, ok)

			for _, requiredProperty := range requiredProperties {
				_, ok := m[requiredProperty]
				require.True(t, ok, fmt.Sprintf(
					"query '%s' doesn't include parameter '%s' in response",
					path.Base(entry.dir),
					requiredProperty,
				))
			}

			if sliceContains(searchValueAllowedQueriesPath, entry.dir) {
				_, ok := m[searchValueProperty]
				require.True(t, ok, fmt.Sprintf(
					"query '%s' doesn't include parameter '%s' in response",
					path.Base(entry.dir),
					searchValueProperty,
				))
			} else {
				_, ok := m[searchValueProperty]
				require.False(t, ok, fmt.Sprintf(
					"query '%s' should not include parameter '%s' in response",
					path.Base(entry.dir),
					searchValueProperty,
				))
			}

			return model.Vulnerability{}, nil
		},
		trk,
	)
	require.Nil(t, err)
	require.NotNil(t, inspector)

	inspector.EnableCoverageReport()

	_, err = inspector.Inspect(ctx, scanID, getParsedFile(t, entry.PositiveFile()))
	require.Nil(t, err)

	report := inspector.GetCoverageReport()
	if report.Coverage < 100 {
		t.Logf("Query '%s' has not full coverage. Want 100%%. Has %d%%", path.Base(entry.dir), int(report.Coverage))
	}
}
