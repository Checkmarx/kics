package test

import (
	"fmt"
	"io/ioutil"
	"net/url"
	"os"
	"path"
	"path/filepath"
	"strings"
	"testing"

	"github.com/Checkmarx/kics/pkg/engine/query"
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
		"../assets/queries/terraform/aws":            {FileKind: model.KindTerraform, Platform: "terraform"},
		"../assets/queries/terraform/azure":          {FileKind: model.KindTerraform, Platform: "terraform"},
		"../assets/queries/terraform/gcp":            {FileKind: model.KindTerraform, Platform: "terraform"},
		"../assets/queries/terraform/github":         {FileKind: model.KindTerraform, Platform: "terraform"},
		"../assets/queries/terraform/kubernetes_pod": {FileKind: model.KindTerraform, Platform: "terraform"},
		"../assets/queries/k8s":                      {FileKind: model.KindYAML, Platform: "k8s"},
		"../assets/queries/cloudFormation":           {FileKind: model.KindYAML, Platform: "cloudFormation"},
		"../assets/queries/ansible/aws":              {FileKind: model.KindYAML, Platform: "ansible"},
		"../assets/queries/ansible/gcp":              {FileKind: model.KindYAML, Platform: "ansible"},
		"../assets/queries/ansible/azure":            {FileKind: model.KindYAML, Platform: "ansible"},
		"../assets/queries/dockerfile":               {FileKind: model.KindDOCKER, Platform: "dockerfile"},
	}
)

func TestMain(m *testing.M) {
	os.Exit(m.Run())
}

type queryEntry struct {
	dir      string
	kind     model.FileKind
	platform string
}

func (q queryEntry) getSampleFiles(tb testing.TB, filePattern string) []string {
	files, err := filepath.Glob(path.Join(q.dir, fmt.Sprintf(filePattern, strings.ToLower(string(q.kind)))))
	require.Nil(tb, err)
	return files
}

func (q queryEntry) PositiveFiles(tb testing.TB) []string {
	return q.getSampleFiles(tb, "test/positive*.%s")
}

func (q queryEntry) NegativeFiles(tb testing.TB) []string {
	return q.getSampleFiles(tb, "test/negative*.%s")
}

func (q queryEntry) ExpectedPositiveResultFile() string {
	return path.Join(q.dir, "test/positive_expected_result.json")
}

func appendQueries(queriesDir []queryEntry, dirName string, kind model.FileKind, platform string) []queryEntry {
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
		fs, err := ioutil.ReadDir(queriesPath)
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
		content, err := ioutil.ReadFile(path)
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
	return parser.NewBuilder().
		Add(&jsonParser.Parser{}).
		Add(&yamlParser.Parser{}).
		Add(terraformParser.NewDefault()).
		Add(&dockerParser.Parser{}).
		Build()
}

func getQueryContent(queryDir string) (string, error) {
	fullQueryPath := filepath.Join(queryDir, query.QueryFileName)
	content, err := getFileContent(fullQueryPath)
	return string(content), err
}

func getSampleContent(params *testCaseParamsType) ([]byte, error) {
	samplePath := checkSampleExistsAndGetPath(params)
	return getFileContent(samplePath)
}

func getFileContent(filePath string) ([]byte, error) {
	return ioutil.ReadFile(filePath)
}

func getSamplePath(params *testCaseParamsType) string {
	var samplePath string
	if params.samplePath != "" {
		samplePath = params.samplePath
	} else {
		samplePath = checkSampleExistsAndGetPath(params)
	}
	return samplePath
}

func checkSampleExistsAndGetPath(params *testCaseParamsType) string {
	var samplePath string
	extensions := fileExtension[params.platform]
	for _, v := range extensions {
		joinedPath := filepath.Join(params.queryDir, fmt.Sprintf("test/positive%s", v))
		_, err := os.Stat(joinedPath)
		if err == nil {
			samplePath = joinedPath
			break
		}
	}
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
	pathToLib := query.GetPathToLibrary(platform, "../")
	content, err := ioutil.ReadFile(pathToLib)

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
