package test

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"path"
	"regexp"
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

const (
	fileID = 12345
	scanID = "test_scan"
)

var (
	validUUID    = regexp.MustCompile(ValidUUIDRegex)
	severityList = []string{"HIGH", "MEDIUM", "LOW", "INFO"}

	requiredQueryResultProperties = []string{
		"documentId",
		"searchKey",
		"issueType",
		"issueType",
		"keyExpectedValue",
		"keyActualValue",
	}

	requiredQueryMetadataProperties = map[string]func(tb testing.TB, value interface{}, metadataPath string){
		"id": func(tb testing.TB, value interface{}, metadataPath string) {
			idValue := testMetadataFieldStringType(tb, value, "id", metadataPath)
			require.True(tb, validUUID.MatchString(strings.TrimSpace(idValue)), "invalid UUID in query metadata file %s", metadataPath)
		},
		"queryName": func(tb testing.TB, value interface{}, metadataPath string) {
			nameValue := testMetadataFieldStringType(tb, value, "queryName", metadataPath)
			require.NotNil(tb, nameValue, "invalid query name in query metadata file %s", metadataPath)
		},
		"severity": func(tb testing.TB, value interface{}, metadataPath string) {
			severityValue := testMetadataFieldStringType(tb, value, "severity", metadataPath)
			require.Contains(tb, severityList, strings.ToUpper(severityValue), "invalid severity in query metadata file %s", metadataPath)
		},
		"category": func(tb testing.TB, value interface{}, metadataPath string) {
			categoryValue := testMetadataFieldStringType(tb, value, "category", metadataPath)
			require.NotEmpty(tb, categoryValue, "empty category in query metadata file %s", metadataPath)
		},
		"descriptionText": func(tb testing.TB, value interface{}, metadataPath string) {
			descriptionValue := testMetadataFieldStringType(tb, value, "descriptionText", metadataPath)
			require.NotEmpty(tb, descriptionValue, "empty description text in query metadata file %s", metadataPath)
		},
		"descriptionUrl": func(tb testing.TB, value interface{}, metadataPath string) {
			switch urlValue := value.(type) {
			case string:
				testMetadataURL(tb, urlValue, metadataPath)
			case []string:
				for _, url := range urlValue {
					testMetadataURL(tb, url, metadataPath)
				}
			}
		},
	}
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

func TestQueriesMetadata(t *testing.T) {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: ioutil.Discard})

	queries := loadQueries(t)

	for _, entry := range queries {
		t.Run(path.Base(entry.dir), func(t *testing.T) {
			metadata, metadataPath := testUnmarshalMetadata(t, entry)

			for k, validation := range requiredQueryMetadataProperties {
				value, ok := metadata[k]
				require.True(t, ok, "missing key '%s' in query metadata file %s", k, metadataPath)
				validation(t, value, metadataPath)
			}
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

			for _, requiredProperty := range requiredQueryResultProperties {
				_, ok := m[requiredProperty]
				require.True(t, ok, fmt.Sprintf(
					"query '%s' doesn't include paramert '%s' in response",
					path.Base(entry.dir),
					requiredProperty,
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

func testMetadataFieldStringType(tb testing.TB, value interface{}, key, metadataPath string) string {
	stringValue, ok := value.(string)
	require.True(tb, ok, "wrong value type for key '%s' in query metadata file %s", key, metadataPath)
	return stringValue
}

func testMetadataURL(tb testing.TB, url, metadataPath string) {
	require.True(tb, isValidURL(url), "invalid url in query metadata file %s", metadataPath)
}

func testUnmarshalMetadata(tb testing.TB, entry queryEntry) (meta map[string]interface{}, metadataPath string) {
	metadataPath = path.Join(entry.dir, query.MetadataFileName)
	content, err := ioutil.ReadFile(metadataPath)
	require.NoError(tb, err, "can't read query metadata file %s", metadataPath)

	var metadata map[string]interface{}
	err = json.Unmarshal(content, &metadata)
	require.NoError(tb, err, "can't unmarshal query metadata file %s", metadataPath)
	return metadata, metadataPath
}
