package test

import (
	"context"
	"encoding/json"
	"io/ioutil"
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
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: ioutil.Discard})

	queries := loadQueries(b)
	for _, entry := range queries {
		b.ResetTimer()
		for n := 0; n < b.N; n++ {
			benchmarkPositiveandNegativeQueries(b, entry)
		}
	}
}

func TestQueries(t *testing.T) {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: ioutil.Discard})

	if testing.Short() {
		t.Skip("skipping queries test in short mode.")
	}

	queries := loadQueries(t)
	for _, entry := range queries {
		testPositiveandNegativeQueries(t, entry)
	}
}

func testPositiveandNegativeQueries(t *testing.T, entry queryEntry) {
	name := strings.TrimPrefix(entry.dir, "../assets/queries/")
	t.Run(name+"_positive", func(t *testing.T) {
		testQuery(t, entry, entry.PositiveFile(), getExpectedVulnerabilities(t, entry))
	})
	t.Run(name+"_negative", func(t *testing.T) {
		testQuery(t, entry, entry.NegativeFile(), []model.Vulnerability{})
	})
}

func benchmarkPositiveandNegativeQueries(b *testing.B, entry queryEntry) {
	name := strings.TrimPrefix(entry.dir, "../assets/queries/")
	b.Run(name+"_positive", func(b *testing.B) {
		testQuery(b, entry, entry.PositiveFile(), getExpectedVulnerabilities(b, entry))
	})
	b.Run(name+"_negative", func(b *testing.B) {
		testQuery(b, entry, entry.NegativeFile(), []model.Vulnerability{})
	})
}

func getExpectedVulnerabilities(tb testing.TB, entry queryEntry) []model.Vulnerability {
	content, err := ioutil.ReadFile(entry.ExpectedPositiveResultFile())
	require.NoError(tb, err, "can't read expected result file %s", entry.ExpectedPositiveResultFile())

	var expectedVulnerabilities []model.Vulnerability
	err = json.Unmarshal(content, &expectedVulnerabilities)
	require.NoError(tb, err, "can't unmarshal expected result file %s", entry.ExpectedPositiveResultFile())

	return expectedVulnerabilities
}

func testQuery(tb testing.TB, entry queryEntry, filePath string, expectedVulnerabilities []model.Vulnerability) {
	ctrl := gomock.NewController(tb)
	defer ctrl.Finish()

	ctx := context.TODO()

	queriesSource := mock.NewMockQueriesSource(ctrl)
	queriesSource.EXPECT().GetQueries().
		DoAndReturn(func() ([]model.QueryMetadata, error) {
			q, err := query.ReadQuery(entry.dir)
			require.NoError(tb, err)

			return []model.QueryMetadata{q}, nil
		})

	queriesSource.EXPECT().GetGenericQuery("commonQuery").
		DoAndReturn(func(string) (string, error) {
			q, err := getPlatform("commonQuery")
			require.NoError(tb, err)
			return q, nil
		})

	queriesSource.EXPECT().GetGenericQuery(entry.dir).
		DoAndReturn(func(string) (string, error) {
			q, err := getPlatform(entry.platform)
			require.NoError(tb, err)
			return q, nil
		})

	inspector, err := engine.NewInspector(ctx, queriesSource, engine.DefaultVulnerabilityBuilder, &tracker.CITracker{})
	require.Nil(tb, err)
	require.NotNil(tb, inspector)

	vulnerabilities, err := inspector.Inspect(ctx, scanID, getParsedFile(tb, filePath))
	require.Nil(tb, err)
	requireEqualVulnerabilities(tb, expectedVulnerabilities, vulnerabilities)
}

func getPlatform(platform string) (string, error) {
	var genericPath = "../assets/queries/generic/"
	var content = "package generic.common"
	var errorMessage error

	if strings.Contains(platform, "commonQuery") {
		path := filepath.FromSlash(genericPath + "common/library.rego")
		content, err := ioutil.ReadFile(path)
		if err != nil {
			log.Err(err)
		}
		return string(content), err
	} else if strings.Contains(platform, "ansible") {
		path := filepath.FromSlash(genericPath + "ansible/library.rego")
		content, err := ioutil.ReadFile(path)
		if err != nil {
			log.Err(err)
		}
		return string(content), err
	} else if strings.Contains(platform, "cloudFormation") {
		path := filepath.FromSlash(genericPath + "cloudformation/library.rego")
		content, err := ioutil.ReadFile(path)
		if err != nil {
			log.Err(err)
		}
		return string(content), err
	} else if strings.Contains(platform, "dockerfile") {
		path := filepath.FromSlash(genericPath + "dockerfile/library.rego")
		content, err := ioutil.ReadFile(path)
		if err != nil {
			log.Err(err)
		}
		return string(content), err
	} else if strings.Contains(platform, "k8s") {
		path := filepath.FromSlash(genericPath + "k8s/library.rego")
		content, err := ioutil.ReadFile(path)
		if err != nil {
			log.Err(err)
		}
		return string(content), err
	} else if strings.Contains(platform, "terraform") {
		path := filepath.FromSlash(genericPath + "terraform/library.rego")
		content, err := ioutil.ReadFile(path)
		if err != nil {
			log.Err(err)
		}
		return string(content), err
	}

	return content, errorMessage
}

func requireEqualVulnerabilities(tb testing.TB, expected, actual []model.Vulnerability) {
	sort.Slice(expected, func(i, j int) bool {
		return expected[i].Line < expected[j].Line
	})
	sort.Slice(actual, func(i, j int) bool {
		return actual[i].Line < actual[j].Line
	})

	require.Len(tb, actual, len(expected), "Count of actual issues and expected vulnerabilities doesn't match")

	for i := range expected {
		if i > len(actual)-1 {
			tb.Fatalf("Not enough results detected, expected %d, found %d", len(expected), len(actual))
		}

		expectedItem := expected[i]
		actualItem := actual[i]
		require.Equal(tb, scanID, actualItem.ScanID)
		require.Equal(tb, expectedItem.Line, actualItem.Line, "Not corrected detected line")
		require.Equal(tb, expectedItem.Severity, actualItem.Severity, "Invalid severity")
		require.Equal(tb, expectedItem.QueryName, actualItem.QueryName, "Invalid query name")
		if expectedItem.Value != nil {
			require.NotNil(tb, actualItem.Value)
			require.Equal(tb, *expectedItem.Value, *actualItem.Value)
		}
	}
}
