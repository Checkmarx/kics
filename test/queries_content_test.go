package test

import (
	"context"
	"fmt"
	"io/ioutil"
	"os"
	"path"
	"testing"

	"github.com/checkmarxDev/ice/internal/tracker"
	"github.com/checkmarxDev/ice/pkg/engine"
	"github.com/checkmarxDev/ice/pkg/engine/mock"
	"github.com/checkmarxDev/ice/pkg/engine/query"
	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/pkg/parser"
	"github.com/golang/mock/gomock"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/stretchr/testify/require"
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
)

func TestQueriesContent(t *testing.T) {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: ioutil.Discard})

	queriesDir := loadQueriesDir(t)

	for _, queryDir := range queriesDir {
		t.Run(path.Base(queryDir), func(t *testing.T) {
			testQueryHasAllRequiredFiles(t, queryDir)
			testQueryHasGoodReturnParams(t, queryDir)
		})
	}
}

func testQueryHasAllRequiredFiles(t *testing.T, queryDir string) {
	require.FileExists(t, path.Join(queryDir, queryFileName))
	require.FileExists(t, path.Join(queryDir, metadataFileName))
	require.FileExists(t, path.Join(queryDir, invalidTerraformFileName))
	require.FileExists(t, path.Join(queryDir, invalidQueryExpectedResultFileName))
	require.FileExists(t, path.Join(queryDir, successTerraformFileName))
}

func testQueryHasGoodReturnParams(t *testing.T, queryDir string) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	scanID := "test_scan"
	fileID := 1
	ctx := context.Background()

	storage := mock.NewMockFilesStorage(ctrl)
	storage.EXPECT().GetFiles(gomock.Eq(ctx), gomock.Eq(scanID)).
		DoAndReturn(func(ctx context.Context, scanID string) (model.FileMetadatas, error) {
			filePath := path.Join(queryDir, invalidTerraformFileName)
			f, err := os.Open(filePath)
			if err != nil {
				return nil, err
			}

			content, err := ioutil.ReadAll(f)
			if err != nil {
				return nil, err
			}

			jsonContent, err := parser.NewDefault().Parse(filePath, content)
			if err != nil {
				return nil, err
			}

			return []model.FileMetadata{
				{
					ID:           fileID,
					ScanID:       scanID,
					JSONData:     jsonContent,
					OriginalData: string(content),
					Kind:         model.KindTerraform,
					FileName:     filePath,
					JSONHash:     0,
				},
			}, nil
		})
	storage.EXPECT().SaveVulnerabilities(gomock.Any(), gomock.Any()).
		Return(nil)

	queriesSource := mock.NewMockQueriesSource(ctrl)
	queriesSource.EXPECT().GetQueries().
		DoAndReturn(func() ([]model.QueryMetadata, error) {
			q, err := query.ReadQuery(queryDir)

			return []model.QueryMetadata{q}, err
		})

	inspector, err := engine.NewInspector(
		ctx,
		queriesSource,
		storage,
		func(ctx engine.QueryContext, v interface{}) (model.Vulnerability, error) {
			m, ok := v.(map[string]interface{})
			require.True(t, ok)

			for _, requiredProperty := range requiredProperties {
				_, ok := m[requiredProperty]
				require.True(t, ok, fmt.Sprintf(
					"query '%s' doesn't include paramert '%s' in response",
					path.Base(queryDir),
					requiredProperty,
				))
			}

			return model.Vulnerability{}, nil
		},
		&tracker.NullTracker{},
	)
	require.Nil(t, err)
	require.NotNil(t, inspector)

	err = inspector.Inspect(ctx, scanID)
	require.Nil(t, err)
}
