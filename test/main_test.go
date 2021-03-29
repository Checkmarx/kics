package test

import (
	"fmt"
	"net/url"
	"os"
	"path"
	"path/filepath"
	"strings"
	"testing"

	"github.com/Checkmarx/kics/pkg/engine/source"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/parser"
	dockerParser "github.com/Checkmarx/kics/pkg/parser/docker"
	jsonParser "github.com/Checkmarx/kics/pkg/parser/json"
	terraformParser "github.com/Checkmarx/kics/pkg/parser/terraform"
	yamlParser "github.com/Checkmarx/kics/pkg/parser/yaml"
	"github.com/google/uuid"
	"github.com/rs/zerolog/log"
	"github.com/stretchr/testify/require"
)

var (
	queriesPaths = map[string]model.QueryConfig{
		"../assets/queries/terraform/aws":        {FileKind: []model.FileKind{model.KindTerraform}, Platform: "terraform"},
		"../assets/queries/terraform/azure":      {FileKind: []model.FileKind{model.KindTerraform}, Platform: "terraform"},
		"../assets/queries/terraform/gcp":        {FileKind: []model.FileKind{model.KindTerraform}, Platform: "terraform"},
		"../assets/queries/terraform/github":     {FileKind: []model.FileKind{model.KindTerraform}, Platform: "terraform"},
		"../assets/queries/terraform/kubernetes": {FileKind: []model.FileKind{model.KindTerraform}, Platform: "terraform"},
		"../assets/queries/k8s":                  {FileKind: []model.FileKind{model.KindYAML}, Platform: "k8s"},
		"../assets/queries/cloudFormation":       {FileKind: []model.FileKind{model.KindYAML, model.KindJSON}, Platform: "cloudFormation"},
		"../assets/queries/ansible/aws":          {FileKind: []model.FileKind{model.KindYAML}, Platform: "ansible"},
		"../assets/queries/ansible/gcp":          {FileKind: []model.FileKind{model.KindYAML}, Platform: "ansible"},
		"../assets/queries/ansible/azure":        {FileKind: []model.FileKind{model.KindYAML}, Platform: "ansible"},
		"../assets/queries/dockerfile":           {FileKind: []model.FileKind{model.KindDOCKER}, Platform: "dockerfile"},
		"../assets/queries/common":               {FileKind: []model.FileKind{model.KindCOMMON}, Platform: "common"},
	}
)

const (
	scanID            = "test_scan"
	BaseTestsScanPath = "../assets/queries/"
)

func TestMain(m *testing.M) {
	os.Exit(m.Run())
}

type queryEntry struct {
	dir      string
	kind     []model.FileKind
	platform string
}

func (q queryEntry) getSampleFiles(tb testing.TB, filePattern string) []string {
	var files []string
	for _, kinds := range q.kind {
		kindFiles, err := filepath.Glob(path.Join(q.dir, fmt.Sprintf(filePattern, strings.ToLower(string(kinds)))))
		x0 := filepath.FromSlash(path.Join(q.dir, "test/positive_expected_result.json"))
		for i, check := range kindFiles {
			if check == x0 {
				kindFiles = append(kindFiles[:i], kindFiles[i+1:]...)
			}
		}
		require.Nil(tb, err)
		files = append(files, kindFiles...)
	}
	return files
}

func (q queryEntry) PositiveFiles(tb testing.TB) []string {
	return q.getSampleFiles(tb, "test/positive*.%s")
}

func (q queryEntry) NegativeFiles(tb testing.TB) []string {
	return q.getSampleFiles(tb, "test/negative*.%s")
}

func (q queryEntry) ExpectedPositiveResultFile() string {
	return filepath.FromSlash(path.Join(q.dir, "test/positive_expected_result.json"))
}

func appendQueries(queriesDir []queryEntry, dirName string, kind []model.FileKind, platform string) []queryEntry {
	queriesDir = append(queriesDir, queryEntry{
		dir:      dirName,
		kind:     kind,
		platform: platform,
	})

	return queriesDir
}

func loadQueries(tb testing.TB) []queryEntry {
	var queriesDir []queryEntry

	for queriesPath, queryConfig := range queriesPaths {
		fs, err := os.ReadDir(queriesPath)
		require.Nil(tb, err)

		for _, f := range fs {
			f.Name()
			if f.IsDir() && f.Name() != "test" {
				queriesDir = appendQueries(queriesDir, filepath.FromSlash(path.Join(queriesPath, f.Name())), queryConfig.FileKind, queryConfig.Platform)
			} else {
				queriesDir = appendQueries(queriesDir, filepath.FromSlash(queriesPath), queryConfig.FileKind, queryConfig.Platform)
				break
			}
		}
	}
	return queriesDir
}

func getFileMetadatas(t testing.TB, filesPath []string) model.FileMetadatas {
	fileMetadatas := make(model.FileMetadatas, 0)
	for _, path := range filesPath {
		content, err := os.ReadFile(path)
		require.NoError(t, err)
		fileMetadatas = append(fileMetadatas, getFilesMetadatasWithContent(t, path, content)...)
	}
	return fileMetadatas
}

func getFilesMetadatasWithContent(t testing.TB, filePath string, content []byte) model.FileMetadatas {
	combinedParser := getCombinedParser()
	files := make(model.FileMetadatas, 0)

	parsedDocuments, kind, err := combinedParser.Parse(filePath, content)
	require.NoError(t, err)
	for _, document := range parsedDocuments {
		files = append(files, model.FileMetadata{
			ID:           uuid.NewString(),
			ScanID:       scanID,
			Document:     document,
			OriginalData: string(content),
			Kind:         kind,
			FileName:     filePath,
		})
	}

	return files
}

func getCombinedParser() *parser.Parser {
	bd, _ := parser.NewBuilder().
		Add(&jsonParser.Parser{}).
		Add(&yamlParser.Parser{}).
		Add(terraformParser.NewDefault()).
		Add(&dockerParser.Parser{}).
		Build([]string{""})
	return bd
}

func getQueryContent(queryDir string) (string, error) {
	fullQueryPath := filepath.Join(queryDir, source.QueryFileName)
	content, err := getFileContent(fullQueryPath)
	return string(content), err
}

func getSampleContent(tb testing.TB, params *testCaseParamsType) ([]byte, error) {
	samplePath := checkSampleExistsAndGetPath(tb, params)
	return getFileContent(samplePath)
}

func getFileContent(filePath string) ([]byte, error) {
	return os.ReadFile(filePath)
}

func getSamplePath(tb testing.TB, params *testCaseParamsType) string {
	var samplePath string
	if params.samplePath != "" {
		samplePath = params.samplePath
	} else {
		samplePath = checkSampleExistsAndGetPath(tb, params)
	}
	return samplePath
}

func checkSampleExistsAndGetPath(tb testing.TB, params *testCaseParamsType) string {
	var samplePath string
	var globMatch string
	extensions := fileExtension[params.platform]
	for _, v := range extensions {
		joinedPathList, _ := filepath.Glob(filepath.Join(params.queryDir, fmt.Sprintf("test/positive*%s", v)))
		for _, path := range joinedPathList {
			globMatch = path
			_, err := os.Stat(path)
			if err == nil {
				samplePath = path
				break
			}
		}
	}
	require.False(tb, samplePath == "", "Sample not found in path: %s", globMatch)
	return samplePath
}

func sliceContains(s []string, str string) bool {
	for _, v := range s {
		if v == str {
			return true
		}
	}
	return false
}

func readLibrary(platform string) (string, error) {
	pathToLib := source.GetPathToLibrary(platform, "../")
	content, err := os.ReadFile(pathToLib)

	if err != nil {
		log.Err(err)
	}

	return string(content), err
}

func isValidURL(toTest string) bool {
	_, err := url.ParseRequestURI(toTest)
	if err != nil {
		return false
	}

	u, err := url.Parse(toTest)
	return err == nil && u.Scheme != "" && u.Host != ""
}
