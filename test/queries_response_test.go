package test

import (
	"context"
	"fmt"
	"io/ioutil"
	"os"
	"path"
	"path/filepath"
	"strings"
	"testing"

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

const queriesPath = "../assets/queries/"

var requiredProperties = []string{
	"documentId",
	"searchKey",
	"issueType",
	"issueType",
	"keyExpectedValue",
	"keyActualValue",
}

func TestQueriesResponse(t *testing.T) {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: ioutil.Discard})

	files, err := ioutil.ReadDir(queriesPath)
	require.Nil(t, err)

	for _, f := range files {
		if filepath.Ext(f.Name()) != ".rego" {
			continue
		}

		t.Run(f.Name(), func(t *testing.T) {
			ctrl := gomock.NewController(t)
			defer ctrl.Finish()

			scanID := "test_scan"
			fileID := 1
			ctx := context.Background()

			storage := mock.NewMockFilesStorage(ctrl)
			storage.EXPECT().GetFiles(gomock.Eq(ctx), gomock.Eq(scanID), gomock.Any()).
				DoAndReturn(func(ctx context.Context, scanID, filter string) (model.FileMetadatas, error) {
					filePath := path.Join("./test-data", strings.TrimSuffix(f.Name(), filepath.Ext(f.Name()))+".tf")
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
					q, err := query.ReadQuery("../assets/queries", f.Name())

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
							f.Name(),
							requiredProperty,
						))
					}

					return model.Vulnerability{}, nil
				},
			)
			require.Nil(t, err)
			require.NotNil(t, inspector)

			err = inspector.Inspect(ctx, scanID)
			require.Nil(t, err)
		})
	}
}
