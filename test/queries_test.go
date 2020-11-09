package test

import (
	"context"
	"encoding/json"
	"io/ioutil"
	"sort"
	"strings"
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
		name := strings.TrimPrefix(entry.dir, "../assets/queries/")
		t.Run(name+"_positive", func(t *testing.T) {
			content, err := ioutil.ReadFile(entry.ExpectedPositiveResultFile())
			require.NoError(t, err, "can't read expected result file %s", entry.ExpectedPositiveResultFile())

			var keysToMatch []map[string]interface{}
			err = json.Unmarshal(content, &keysToMatch)
			require.NoError(t, err, "can't unmarshal expected result file %s", entry.ExpectedPositiveResultFile())

			testQuery(t, entry, entry.PositiveFile(), keysToMatch)
		})
		t.Run(name+"_negative", func(t *testing.T) {
			testQuery(t, entry, entry.NegativeFile(), nil)
		})
	}
}

func testQuery(t *testing.T, entry queryEntry, filePath string, keysToMatch []map[string]interface{}) {
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
	requireVulnerabilitiesHasKeys(t, keysToMatch, vulnerabilities)
}

func requireVulnerabilitiesHasKeys(t *testing.T, objects []map[string]interface{}, actual []model.Vulnerability) {
	sort.Slice(actual, func(i, j int) bool {
		return actual[i].Line < actual[j].Line
	})

	require.Len(t, actual, len(objects), "Count of actual issues and expected vulnerabilities doesn't match")

	actualJSON, err := json.Marshal(actual)
	require.NoError(t, err)

	var actualObjects []map[string]interface{}
	err = json.Unmarshal(actualJSON, &actualObjects)
	require.NoError(t, err)

	for i, object := range objects {
		if i > len(actual)-1 {
			t.Fatalf("Not enough results detected, expected %d, found %d", len(objects), len(actual))
		}

		actualItem := actualObjects[i]

		for key, value := range object {
			require.Contains(t, actualItem, key)
			require.Equal(t, value, actualItem[key])
		}
	}
}
