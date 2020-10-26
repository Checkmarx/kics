package test

import (
	"context"
	"encoding/json"
	"io/ioutil"
	"path"
	"sort"
	"testing"

	"github.com/checkmarxDev/ice/internal/tracker"
	"github.com/checkmarxDev/ice/pkg/engine"
	"github.com/checkmarxDev/ice/pkg/engine/mock"
	"github.com/checkmarxDev/ice/pkg/engine/query"
	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/golang/mock/gomock"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/stretchr/testify/require"
)

func TestQueries(t *testing.T) {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: ioutil.Discard})

	queries := loadQueries(t)
	for _, entry := range queries {
		t.Run(path.Base(entry.dir)+"_positive", func(t *testing.T) {
			content, err := ioutil.ReadFile(entry.ExpectedPositiveResultFile())
			require.NoError(t, err, "can't read expected result file %s", entry.ExpectedPositiveResultFile())

			var expectedVulnerabilities []model.Vulnerability
			err = json.Unmarshal(content, &expectedVulnerabilities)
			require.NoError(t, err, "can't unmarshal expected result file %s", entry.ExpectedPositiveResultFile())

			testQuery(t, entry, entry.PositiveFile(), expectedVulnerabilities)
		})
		t.Run(path.Base(entry.dir)+"_negative", func(t *testing.T) {
			testQuery(t, entry, entry.NegativeFile(), []model.Vulnerability{})
		})
	}
}

func testQuery(t *testing.T, entry queryEntry, filePath string, expectedVulnerabilities []model.Vulnerability) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	ctx := context.TODO()

	queriesSource := mock.NewMockQueriesSource(ctrl)
	queriesSource.EXPECT().GetQueries().
		DoAndReturn(func() ([]model.QueryMetadata, error) {
			q, err := query.ReadQuery(entry.dir)
			require.NoError(t, err)

			return []model.QueryMetadata{q}, nil
		})

	inspector, err := engine.NewInspector(ctx, queriesSource, engine.DefaultVulnerabilityBuilder, &tracker.NullTracker{})
	require.Nil(t, err)
	require.NotNil(t, inspector)

	vulnerabilities, err := inspector.Inspect(ctx, scanID, getParsedFile(t, filePath))
	require.Nil(t, err)
	requireEqualVulnerabilities(t, expectedVulnerabilities, vulnerabilities)
}

func requireEqualVulnerabilities(t *testing.T, expected, actual []model.Vulnerability) {
	sort.Slice(expected, func(i, j int) bool {
		return expected[i].Line < expected[j].Line
	})
	sort.Slice(actual, func(i, j int) bool {
		return actual[i].Line < actual[j].Line
	})

	require.Len(t, actual, len(expected), "Count of actual issues and expected vulnerabilities doesn't match")

	for i := range expected {
		if i > len(actual)-1 {
			t.Fatalf("Not enough results detected, expected %d, found %d", len(expected), len(actual))
		}

		expectedItem := expected[i]
		actualItem := actual[i]
		require.Equal(t, scanID, actualItem.ScanID)
		require.Equal(t, expectedItem.Line, actualItem.Line, "Not corrected detected line")
		require.Equal(t, expectedItem.Severity, actualItem.Severity, "Invalid severity")
		require.Equal(t, expectedItem.QueryName, actualItem.QueryName, "Invalid query name")
		if expectedItem.Value != nil {
			require.NotNil(t, actualItem.Value)
			require.Equal(t, *expectedItem.Value, *actualItem.Value)
		}
	}
}
