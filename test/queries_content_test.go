package test

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"os"
	"path"
	"path/filepath"
	"regexp"
	"strings"
	"sync"
	"testing"

	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/Checkmarx/kics/v2/internal/tracker"
	"github.com/Checkmarx/kics/v2/pkg/detector"
	"github.com/Checkmarx/kics/v2/pkg/engine"
	"github.com/Checkmarx/kics/v2/pkg/engine/mock"
	"github.com/Checkmarx/kics/v2/pkg/engine/source"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/progress"
	"github.com/golang/mock/gomock"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/stretchr/testify/require"
)

var (
	validUUID    = regexp.MustCompile(ValidUUIDRegex)
	severityList = []string{model.SeverityCritical, model.SeverityHigh, model.SeverityMedium, model.SeverityLow, model.SeverityInfo, model.SeverityTrace}

	requiredQueryResultProperties = []string{
		"documentId",
		"searchKey",
		"issueType",
		"keyExpectedValue",
		"keyActualValue",
	}

	requiredQueryResultExtraProperties = []string{
		"resourceType",
		"resourceName",
	}

	searchValueAllowedQueriesPath = []string{
		"../assets/queries/ansible/azure/sensitive_port_is_exposed_to_entire_network",
		"../assets/queries/cloudFormation/aws/ec2_sensitive_port_is_publicly_exposed",
		"../assets/queries/cloudFormation/aws/elb_sensitive_port_is_exposed_to_entire_network",
		"../assets/queries/terraform/aws/sensitive_port_is_exposed_to_entire_network",
		"../assets/queries/terraform/aws/sensitive_port_is_exposed_to_small_public_network",
		"../assets/queries/terraform/azure/sensitive_port_is_exposed_to_entire_network",
		"../assets/queries/terraform/azure/sensitive_port_is_exposed_to_small_public_network",
		"../assets/queries/dockerfile/apt_get_install_pin_version_not_defined",
		"../assets/queries/terraform/aws/redshift_cluster_without_vpc",
		"../assets/queries/openAPI/general/response_code_missing",
		"../assets/queries/cicd/github/run_block_injection",
		"../assets/queries/cicd/github/script_block_injection",
		"../assets/queries/azureResourceManager/key_vault_not_recoverable",
		"../assets/queries/terraform/aws/iam_policy_allows_for_data_exfiltration",
	}

	// TODO uncomment this test once all metadata are fixed
	availablePlatforms = initPlatforms()
	platformKeys       = MapToStringSlice(availablePlatforms)

	CategoriesKeys = MapToStringSlice(constants.AvailableCategories)

	searchValueProperty = "searchValue"

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
			_, ok := constants.AvailableCategories[categoryValue]
			require.True(tb, ok,
				"%s in metadata: %s\nis not a valid category must be one of:\n%v",
				categoryValue, metadataPath, strings.Join(CategoriesKeys, "\n"))
		},
		"descriptionText": func(tb testing.TB, value interface{}, metadataPath string) {
			descriptionValue := testMetadataFieldStringType(tb, value, "descriptionText", metadataPath)
			require.NotEmpty(tb, descriptionValue, "empty description text in query metadata file %s", metadataPath)
		},
		"descriptionID": func(tb testing.TB, value interface{}, metadataPath string) {
			descriptionIDValue := testMetadataFieldStringType(tb, value, "descriptionID", metadataPath)
			require.NotEmpty(tb, descriptionIDValue, "empty description ID in query metadata file %s", metadataPath)
		},
		"platform": func(tb testing.TB, value interface{}, metadataPath string) {
			platformValue := testMetadataFieldStringType(tb, value, "platform", metadataPath)
			require.NotEmpty(tb, platformValue, "empty platform text in query metadata file %s", metadataPath)
			platformDir, ok := availablePlatforms[platformValue]
			require.True(tb, ok,
				"%s in metadata: %s\nis not a valid platform must be one of:\n%v",
				platformValue, metadataPath, strings.Join(platformKeys, "\n"))
			require.True(tb, strings.Contains(filepath.Clean(metadataPath), filepath.Join("assets", "queries", platformDir)),
				"platform and query directory mismatch platform:\n%s\nmetadata:\n%s", platformValue, metadataPath)
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

func initPlatforms() map[string]string {
	platforms := make(map[string]string)
	for k, v := range constants.AvailablePlatforms {
		platforms[k] = v
	}
	platforms["Common"] = "common"
	return platforms
}

func TestQueriesContent(t *testing.T) {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: io.Discard})

	queries := loadQueries(t)

	for _, entry := range queries {
		t.Run(path.Base(entry.dir), func(t *testing.T) {
			testQueryHasAllRequiredFiles(t, entry)
			testQueryHasGoodReturnParams(t, entry)
		})
	}
}

func TestQueriesMetadata(t *testing.T) {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: io.Discard})

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
	require.FileExists(t, path.Join(entry.dir, source.QueryFileName))
	require.FileExists(t, path.Join(entry.dir, source.MetadataFileName))
	require.True(t, len(entry.PositiveFiles(t)) > 0, "No positive samples found for query %s", entry.dir)
	for _, positiveFile := range entry.PositiveFiles(t) {
		require.FileExists(t, positiveFile)
	}
	require.True(t, len(entry.NegativeFiles(t)) > 0, "No negative samples found for query %s", entry.dir)
	for _, negativeFile := range entry.NegativeFiles(t) {
		require.FileExists(t, negativeFile)
	}
	require.FileExists(t, entry.ExpectedPositiveResultFile("test"))

	for positiveDirectory, positiveFiles := range entry.PositiveDirectories(t) {
		require.True(t, len(positiveFiles) > 1, "Not enough positive samples found for query %s in directory %s", entry.dir, positiveDirectory)
		for _, positiveFile := range positiveFiles {
			require.FileExists(t, positiveFile)
		}
		require.FileExists(t, entry.ExpectedPositiveResultFile("test/"+positiveDirectory))
	}
	for negativeDirectory, negativeFiles := range entry.NegativeDirectories(t) {
		require.True(t, len(negativeFiles) > 1, "Not enough negative samples found for query %s in directory %s", entry.dir, negativeDirectory)
		for _, negativeFile := range negativeFiles {
			require.FileExists(t, negativeFile)
		}
	}
}

func testQueryHasGoodReturnParams(t *testing.T, entry queryEntry) { //nolint
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()
	ctx := context.Background()
	queriesSource := mock.NewMockQueriesSource(ctrl)
	queriesSource.EXPECT().GetQueries(getQueryFilter()).
		DoAndReturn(func(interface{}) ([]model.QueryMetadata, error) {
			q, err := source.ReadQuery(entry.dir)

			return []model.QueryMetadata{q}, err
		})
	queriesSource.EXPECT().GetQueryLibrary("common").
		DoAndReturn(func(string) (source.RegoLibraries, error) {
			q, err := readLibrary("common")
			require.NoError(t, err)
			return q, nil
		})
	queriesSource.EXPECT().GetQueryLibrary(entry.platform).
		DoAndReturn(func(string) (source.RegoLibraries, error) {
			q, err := readLibrary(entry.platform)
			require.NoError(t, err)
			return q, nil
		})
	trk := &tracker.CITracker{}
	inspector, err := engine.NewInspector(
		ctx,
		queriesSource,
		func(ctx *engine.QueryContext, trk engine.Tracker, v interface{}, detector *detector.DetectLine, useOldSeverities bool, kicsComputeNewSimID bool) (*model.Vulnerability, error) {
			m, ok := v.(map[string]interface{})
			require.True(t, ok)

			platformsWithResourceInfo := []string{"ansible", "azureResourceManager", "cloudFormation", "k8s", "googleDeploymentManager", "terraform"}
			requiredProperties := requiredQueryResultProperties

			for i := range platformsWithResourceInfo {
				if entry.platform == platformsWithResourceInfo[i] && !strings.Contains(entry.dir, "aws_bom") && !strings.Contains(entry.dir, "gcp_bom") {
					requiredProperties = append(requiredProperties, requiredQueryResultExtraProperties...)

				}
			}

			for _, requiredProperty := range requiredProperties {
				_, ok := m[requiredProperty]
				require.True(t, ok, fmt.Sprintf(
					"query '%s' doesn't include parameter '%s' in response",
					path.Base(entry.dir),
					requiredProperty,
				))
			}

			if sliceContains(searchValueAllowedQueriesPath, filepath.ToSlash(entry.dir)) {
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

			if _, ok := m["remediation"]; ok {
				_, ok := m["remediationType"]
				require.True(t, ok, fmt.Sprintf(
					"query '%s' doesn't include parameter 'remediationType' in response",
					path.Base(entry.dir)))

			}

			if _, ok := m["remediationType"]; ok {
				_, ok := m["remediation"]
				require.True(t, ok, fmt.Sprintf(
					"query '%s' doesn't include parameter 'remediation' in response",
					path.Base(entry.dir)))

			}

			return &model.Vulnerability{}, nil
		},
		trk,
		&source.QueryInspectorParameters{
			IncludeQueries: source.IncludeQueries{ByIDs: []string{}},
			ExcludeQueries: source.ExcludeQueries{ByIDs: []string{}, ByCategories: []string{}},
			InputDataPath:  "",
		},
		map[string]bool{},
		60,
		true,
		true,
		1,
		false,
	)
	require.Nil(t, err)
	require.NotNil(t, inspector)

	inspector.EnableCoverageReport()

	wg := &sync.WaitGroup{}
	currentQuery := make(chan int64)
	proBarBuilder := progress.InitializePbBuilder(true, true, true)
	platforms := MapToStringSlice(constants.AvailablePlatforms)
	progressBar := proBarBuilder.BuildCounter("Executing queries: ", inspector.LenQueriesByPlat(platforms), wg, currentQuery)
	go progressBar.Start()

	wg.Add(1)
	_, err = inspector.Inspect(ctx, scanID, getFileMetadatas(
		t,
		entry.PositiveFiles(t)),
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
	metadataPath = filepath.Join(entry.dir, source.MetadataFileName)
	content, err := os.ReadFile(metadataPath)
	require.NoError(tb, err, "can't read query metadata file %s", metadataPath)

	var metadata map[string]interface{}
	err = json.Unmarshal(content, &metadata)
	require.NoError(tb, err, "can't unmarshal query metadata file %s", metadataPath)
	return metadata, metadataPath
}
