package test

import (
	"context"
	"encoding/json"
	"os"
	"path"
	"path/filepath"
	"strings"
	"sync"
	"testing"

	"github.com/Checkmarx/kics/v2/assets"
	"github.com/Checkmarx/kics/v2/internal/tracker"
	"github.com/Checkmarx/kics/v2/pkg/engine/secrets"
	"github.com/Checkmarx/kics/v2/pkg/engine/source"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/progress"
	"github.com/stretchr/testify/require"
)

const (
	secretsQueryDir = BaseTestsScanPath + "common/passwords_and_secrets"
)

func TestSecretsQuery(t *testing.T) {
	expectedVulnerabilities := loadSecretsQueryExpectedResults(t)
	require.NotEmpty(t, expectedVulnerabilities, "expected vulnerabilities are empty")

	subTestPrefix := strings.TrimPrefix(secretsQueryDir, BaseTestsScanPath)
	t.Run(subTestPrefix+"_positive", func(t *testing.T) {
		positiveSamples, err := filepath.Glob(path.Join(secretsQueryDir, "test/positive*.*"))
		require.NoError(t, err, "unable to glob positive samples")
		testSecretsInspector(t, positiveSamples, expectedVulnerabilities)
	})
	t.Run(subTestPrefix+"_negative", func(t *testing.T) {
		negativeSamples, err := filepath.Glob(path.Join(secretsQueryDir, "test/negative*.*"))
		require.NoError(t, err, "unable to glob negative samples")
		testSecretsInspector(t, negativeSamples, []model.Vulnerability{})
	})
}

func testSecretsInspector(t *testing.T, samplePaths []string, expectedVulnerabilities []model.Vulnerability) {
	ctx := context.TODO()
	excludeResults := map[string]bool{}

	secretsInspector, err := secrets.NewInspector(
		ctx,
		excludeResults,
		&tracker.CITracker{},
		&source.QueryInspectorParameters{
			IncludeQueries: source.IncludeQueries{ByIDs: []string{}},
			ExcludeQueries: source.ExcludeQueries{ByIDs: []string{}, ByCategories: []string{}},
			InputDataPath:  "",
		},
		false,
		60,
		assets.SecretsQueryRegexRulesJSON,
		false,
	)
	require.NoError(t, err, "unable to create secrets inspector")

	wg := &sync.WaitGroup{}
	currentQuery := make(chan int64)
	wg.Add(1)

	proBarBuilder := progress.InitializePbBuilder(true, true, true)
	progressBar := proBarBuilder.BuildCounter("Executing queries: ", secretsInspector.GetQueriesLength(), wg, currentQuery)

	go progressBar.Start()

	vulnerabilities, err := secretsInspector.Inspect(
		ctx,
		[]string{BaseTestsScanPath},
		getFileMetadatas(t, samplePaths),
		currentQuery,
	)
	require.NoError(t, err, "unable to inspect secrets")

	go func() {
		defer func() {
			close(currentQuery)
		}()
	}()

	requireEqualVulnerabilities(t, expectedVulnerabilities, vulnerabilities, secretsQueryDir)
}

func loadSecretsQueryExpectedResults(t *testing.T) []model.Vulnerability {
	expectedFilepath := filepath.FromSlash(path.Join(secretsQueryDir, "test", ExpectedResultsFilename))
	b, err := os.ReadFile(expectedFilepath)
	require.NoError(t, err, "Error reading expected results file")

	var expectedResults []model.Vulnerability
	err = json.Unmarshal(b, &expectedResults)
	require.NoError(t, err, "can't unmarshal expected result file %s", expectedFilepath)

	return expectedResults
}
