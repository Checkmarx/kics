package test

import (
	"context"
	"encoding/json"
	"io"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"sync"
	"testing"

	"github.com/Checkmarx/kics/internal/tracker"
	"github.com/Checkmarx/kics/pkg/engine"
	"github.com/Checkmarx/kics/pkg/engine/mock"
	"github.com/Checkmarx/kics/pkg/engine/source"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/progress"
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
	descriptionIdentifiers := make(map[string]string)

	for _, entry := range queries {
		metadata := source.ReadMetadata(entry.dir)
		uuid := metadata["id"].(string)
		duplicateDir, ok := queriesIdentifiers[uuid]
		require.False(t, ok, "\nnon unique queryID found uuid: %s\nqueryDir: %s\nduplicateDir: %s",
			uuid, entry.dir, duplicateDir)
		queriesIdentifiers[uuid] = entry.dir

		descID := ""
		if _, exists := metadata["descriptionID"]; exists {
			descID = metadata["descriptionID"].(string)
			duplicateDir, ok = descriptionIdentifiers[descID]
			require.False(t, ok, "\nnon unique descriptionID found descID: %s\nqueryDir: %s\nduplicateDir: %s",
				descID, entry.dir, duplicateDir)
			descriptionIdentifiers[descID] = entry.dir
		}

		if override, ok := metadata["override"].(map[string]interface{}); ok {
			for _, v := range override {
				if convertedValue, converted := v.(map[string]interface{}); converted {
					if id, ok := convertedValue["id"].(string); ok {
						duplicateDir, ok = queriesIdentifiers[id]
						require.False(t, ok, "\nnon unique queryID found on overriding uuid: %s\nqueryDir: %s\nduplicateDir: %s",
							id, entry.dir, duplicateDir)
						queriesIdentifiers[id] = entry.dir

						if _, exists := override["descriptionID"]; exists {
							descID = override["descriptionID"].(string)
							duplicateDir, ok = descriptionIdentifiers[descID]
							require.False(t, ok, "\nnon unique descriptionID found in override\ndescID: %s\nqueryDir: %s\nduplicateDir: %s",
								descID, entry.dir, duplicateDir)
							descriptionIdentifiers[descID] = entry.dir
						}
					}
				}
			}
		}
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
	queriesSource.EXPECT().GetQueries(getQueryFilter()).
		DoAndReturn(func(interface{}) ([]model.QueryMetadata, error) {
			q, err := source.ReadQuery(entry.dir)
			require.NoError(tb, err)

			return []model.QueryMetadata{q}, nil
		})

	queriesSource.EXPECT().GetQueryLibrary("common").
		DoAndReturn(func(string) (string, error) {
			q, err := readLibrary("common")
			require.NoError(tb, err)
			return q, nil
		})

	queriesSource.EXPECT().GetQueryLibrary(entry.platform).
		DoAndReturn(func(string) (string, error) {
			q, err := readLibrary(entry.platform)
			require.NoError(tb, err)
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
		map[string]bool{}, 60)

	require.Nil(tb, err)
	require.NotNil(tb, inspector)

	wg := &sync.WaitGroup{}
	currentQuery := make(chan int64)
	proBarBuilder := progress.InitializePbBuilder(true, true, true)
	platforms := []string{"Ansible", "CloudFormation", "Kubernetes", "OpenAPI", "Terraform", "Dockerfile", "AzureResourceManager"}
	progressBar := proBarBuilder.BuildCounter("Executing queries: ", inspector.LenQueriesByPlat(platforms), wg, currentQuery)
	go progressBar.Start()
	wg.Add(1)

	vulnerabilities, err := inspector.Inspect(
		ctx,
		scanID,
		getFileMetadatas(tb, filesPath),
		[]string{BaseTestsScanPath},
		platforms,
		currentQuery,
	)

	go func() {
		defer func() {
			close(currentQuery)
		}()
		wg.Wait()
	}()

	require.Nil(tb, err)
	validateIssueTypes(tb, vulnerabilities)
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

func validateIssueTypes(tb testing.TB, vulnerabilies []model.Vulnerability) {
	for idx := range vulnerabilies {
		issueType := string(vulnerabilies[idx].IssueType)
		_, ok := issueTypes[issueType]
		require.True(tb, ok, "Results 'issueType' is not valid :: %v", issueType)
	}
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
