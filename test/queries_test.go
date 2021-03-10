package test

import (
	"context"
	"encoding/json"
	"io"
	"os"
	"path/filepath"
	"sort"
	"strings"
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

func BenchmarkQueries(b *testing.B) {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: io.Discard})

	queries := loadQueries(b)
	for _, entry := range queries {
		b.ResetTimer()
		for n := 0; n < b.N; n++ {
			benchmarkPositiveandNegativeQueries(b, entry)
		}
	}
}

func TestQueries(t *testing.T) {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: io.Discard})

	if testing.Short() {
		t.Skip("skipping queries test in short mode.")
	}

	queries := loadQueries(t)
	for _, entry := range queries {
		testPositiveandNegativeQueries(t, entry)
	}
}

func TestUniqueQueryIDs(t *testing.T) {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: io.Discard})
	queries := loadQueries(t)

	queriesIdentifiers := make(map[string]string)

	for _, entry := range queries {
		metadata := query.ReadMetadata(entry.dir)
		uuid := metadata["id"].(string)
		duplicateDir, ok := queriesIdentifiers[uuid]
		require.False(t, ok, "\nnon unique query found uuid: %s\nqueryDir: %s\nduplicateDir: %s",
			uuid, entry.dir, duplicateDir)
		queriesIdentifiers[uuid] = entry.dir
	}
}

func testPositiveandNegativeQueries(t *testing.T, entry queryEntry) {
	name := strings.TrimPrefix(entry.dir, BaseTestsScanPath)
	t.Run(name+"_positive", func(t *testing.T) {
		testQuery(t, entry, entry.PositiveFiles(t), getExpectedVulnerabilities(t, entry))
	})
	t.Run(name+"_negative", func(t *testing.T) {
		testQuery(t, entry, entry.NegativeFiles(t), []model.Vulnerability{})
	})
}

func benchmarkPositiveandNegativeQueries(b *testing.B, entry queryEntry) {
	name := strings.TrimPrefix(entry.dir, BaseTestsScanPath)
	b.Run(name+"_positive", func(b *testing.B) {
		testQuery(b, entry, entry.PositiveFiles(b), getExpectedVulnerabilities(b, entry))
	})
	b.Run(name+"_negative", func(b *testing.B) {
		testQuery(b, entry, entry.NegativeFiles(b), []model.Vulnerability{})
	})
}

func getExpectedVulnerabilities(tb testing.TB, entry queryEntry) []model.Vulnerability {
	content, err := os.ReadFile(entry.ExpectedPositiveResultFile())
	require.NoError(tb, err, "can't read expected result file %s", entry.ExpectedPositiveResultFile())

	var expectedVulnerabilities []model.Vulnerability
	err = json.Unmarshal(content, &expectedVulnerabilities)
	require.NoError(tb, err, "can't unmarshal expected result file %s", entry.ExpectedPositiveResultFile())

	return expectedVulnerabilities
}

func testQuery(tb testing.TB, entry queryEntry, filesPath []string, expectedVulnerabilities []model.Vulnerability) {
	ctrl := gomock.NewController(tb)
	defer ctrl.Finish()

	ctx := context.TODO()

	queriesSource := mock.NewMockQueriesSource(ctrl)
	queriesSource.EXPECT().GetQueries(engine.ExcludeQueries{ByIDs: []string{}, ByCategories: []string{}}).
		DoAndReturn(func(interface{}) ([]model.QueryMetadata, error) {
			q, err := query.ReadQuery(entry.dir)
			require.NoError(tb, err)

			return []model.QueryMetadata{q}, nil
		})

	queriesSource.EXPECT().GetGenericQuery("common").
		DoAndReturn(func(string) (string, error) {
			q, err := readLibrary("common")
			require.NoError(tb, err)
			return q, nil
		})

	queriesSource.EXPECT().GetGenericQuery(entry.platform).
		DoAndReturn(func(string) (string, error) {
			q, err := readLibrary(entry.platform)
			require.NoError(tb, err)
			return q, nil
		})

	inspector, err := engine.NewInspector(ctx,
		queriesSource,
		engine.DefaultVulnerabilityBuilder,
		&tracker.CITracker{},
		engine.ExcludeQueries{ByIDs: []string{}, ByCategories: []string{}},
		map[string]bool{})

	require.Nil(tb, err)
	require.NotNil(tb, inspector)

	vulnerabilities, err := inspector.Inspect(ctx, scanID, getFileMetadatas(tb, filesPath), true, BaseTestsScanPath)
	require.Nil(tb, err)
	requireEqualVulnerabilities(tb, expectedVulnerabilities, vulnerabilities, entry)
}

func vulnerabilityCompare(vulnerabilitySlice []model.Vulnerability, i, j int) bool {
	if vulnerabilitySlice[i].FileName != "" {
		compareFile := strings.Compare(filepath.Base(vulnerabilitySlice[i].FileName), filepath.Base(vulnerabilitySlice[j].FileName))
		if compareFile == 0 {
			return vulnerabilitySlice[i].Line < vulnerabilitySlice[j].Line
		} else if compareFile < 0 {
			return true
		}
		return false
	}
	return vulnerabilitySlice[i].Line < vulnerabilitySlice[j].Line
}

func requireEqualVulnerabilities(tb testing.TB, expected, actual []model.Vulnerability, entry queryEntry) {
	sort.Slice(expected, func(i, j int) bool {
		return vulnerabilityCompare(expected, i, j)
	})
	sort.Slice(actual, func(i, j int) bool {
		return vulnerabilityCompare(actual, i, j)
	})

	require.Len(tb, actual, len(expected), "Count of actual issues and expected vulnerabilities doesn't match")

	for i := range expected {
		if i > len(actual)-1 {
			tb.Fatalf("Not enough results detected, expected %d, found %d", len(expected), len(actual))
		}

		expectedItem := expected[i]
		actualItem := actual[i]
		if expectedItem.FileName != "" {
			require.Equal(tb, expectedItem.FileName, filepath.Base(actualItem.FileName), "Incorrect file name for query %s", entry.dir)
		}
		require.Equal(tb, scanID, actualItem.ScanID)
		require.Equal(tb, expectedItem.Line, actualItem.Line, "Not corrected detected line for query %s \n%v\n---\n%v",
			entry.dir, filterFileNameAndLine(expected), filterFileNameAndLine(actual))
		require.Equal(tb, expectedItem.Severity, actualItem.Severity, "Invalid severity for query %s", entry.dir)
		require.Equal(tb, expectedItem.QueryName, actualItem.QueryName, "Invalid query name for query %s", entry.dir)
		if expectedItem.Value != nil {
			require.NotNil(tb, actualItem.Value)
			require.Equal(tb, *expectedItem.Value, *actualItem.Value)
		}
	}
}

type ResultItem struct {
	File string
	Line int
}

func filterFileNameAndLine(vulnerabilitySlice []model.Vulnerability) []ResultItem {
	result := []ResultItem{}
	for i := 0; i < len(vulnerabilitySlice); i++ {
		result = append(result, ResultItem{
			File: vulnerabilitySlice[i].FileName,
			Line: vulnerabilitySlice[i].Line,
		})
	}
	return result
}
