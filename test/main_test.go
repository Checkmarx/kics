package test

import (
	"fmt"
	"net/url"
	"os"
	"path"
	"path/filepath"
	"strings"
	"testing"

	"github.com/Checkmarx/kics/v2/assets"
	"github.com/Checkmarx/kics/v2/pkg/engine/source"
	"github.com/Checkmarx/kics/v2/pkg/kics"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/parser"
	ansibleConfigParser "github.com/Checkmarx/kics/v2/pkg/parser/ansible/ini/config"
	ansibleHostsParser "github.com/Checkmarx/kics/v2/pkg/parser/ansible/ini/hosts"
	bicepParser "github.com/Checkmarx/kics/v2/pkg/parser/bicep"
	buildahParser "github.com/Checkmarx/kics/v2/pkg/parser/buildah"
	dockerParser "github.com/Checkmarx/kics/v2/pkg/parser/docker"
	protoParser "github.com/Checkmarx/kics/v2/pkg/parser/grpc"
	jsonParser "github.com/Checkmarx/kics/v2/pkg/parser/json"
	terraformParser "github.com/Checkmarx/kics/v2/pkg/parser/terraform"
	yamlParser "github.com/Checkmarx/kics/v2/pkg/parser/yaml"
	"github.com/Checkmarx/kics/v2/pkg/utils"
	"github.com/google/uuid"
	"github.com/rs/zerolog/log"
	"github.com/stretchr/testify/require"
)

var (
	queriesPaths = map[string]model.QueryConfig{
		"../assets/queries/terraform/aws_bom":               {FileKind: []model.FileKind{model.KindTerraform, model.KindJSON}, Platform: "terraform"},
		"../assets/queries/terraform/aws":                   {FileKind: []model.FileKind{model.KindTerraform, model.KindJSON}, Platform: "terraform"},
		"../assets/queries/terraform/azure":                 {FileKind: []model.FileKind{model.KindTerraform, model.KindJSON}, Platform: "terraform"},
		"../assets/queries/terraform/databricks":            {FileKind: []model.FileKind{model.KindTerraform, model.KindJSON}, Platform: "terraform"},
		"../assets/queries/terraform/gcp":                   {FileKind: []model.FileKind{model.KindTerraform, model.KindJSON}, Platform: "terraform"},
		"../assets/queries/terraform/gcp_bom":               {FileKind: []model.FileKind{model.KindTerraform, model.KindJSON}, Platform: "terraform"},
		"../assets/queries/terraform/github":                {FileKind: []model.FileKind{model.KindTerraform, model.KindJSON}, Platform: "terraform"},
		"../assets/queries/terraform/kubernetes":            {FileKind: []model.FileKind{model.KindTerraform, model.KindJSON}, Platform: "terraform"},
		"../assets/queries/terraform/general":               {FileKind: []model.FileKind{model.KindTerraform, model.KindJSON}, Platform: "terraform"},
		"../assets/queries/terraform/alicloud":              {FileKind: []model.FileKind{model.KindTerraform, model.KindJSON}, Platform: "terraform"},
		"../assets/queries/terraform/nifcloud":              {FileKind: []model.FileKind{model.KindTerraform, model.KindJSON}, Platform: "terraform"},
		"../assets/queries/terraform/tencentcloud":          {FileKind: []model.FileKind{model.KindTerraform, model.KindJSON}, Platform: "terraform"},
		"../assets/queries/crossplane/aws":                  {FileKind: []model.FileKind{model.KindYAML}, Platform: "crossplane"},
		"../assets/queries/crossplane/azure":                {FileKind: []model.FileKind{model.KindYAML}, Platform: "crossplane"},
		"../assets/queries/crossplane/gcp":                  {FileKind: []model.FileKind{model.KindYAML}, Platform: "crossplane"},
		"../assets/queries/pulumi/aws":                      {FileKind: []model.FileKind{model.KindYAML}, Platform: "pulumi"},
		"../assets/queries/pulumi/gcp":                      {FileKind: []model.FileKind{model.KindYAML}, Platform: "pulumi"},
		"../assets/queries/pulumi/kubernetes":               {FileKind: []model.FileKind{model.KindYAML}, Platform: "pulumi"},
		"../assets/queries/pulumi/azure":                    {FileKind: []model.FileKind{model.KindYAML}, Platform: "pulumi"},
		"../assets/queries/k8s":                             {FileKind: []model.FileKind{model.KindYAML, model.KindJSON}, Platform: "k8s"},
		"../assets/queries/cloudFormation/aws":              {FileKind: []model.FileKind{model.KindYAML, model.KindJSON}, Platform: "cloudFormation"},
		"../assets/queries/cloudFormation/aws_bom":          {FileKind: []model.FileKind{model.KindYAML, model.KindJSON}, Platform: "cloudFormation"},
		"../assets/queries/cloudFormation/aws_sam":          {FileKind: []model.FileKind{model.KindYAML}, Platform: "cloudFormation"},
		"../assets/queries/ansible/aws":                     {FileKind: []model.FileKind{model.KindYAML}, Platform: "ansible"},
		"../assets/queries/ansible/gcp":                     {FileKind: []model.FileKind{model.KindYAML}, Platform: "ansible"},
		"../assets/queries/ansible/azure":                   {FileKind: []model.FileKind{model.KindYAML}, Platform: "ansible"},
		"../assets/queries/ansible/general":                 {FileKind: []model.FileKind{model.KindYAML}, Platform: "ansible"},
		"../assets/queries/ansible/config":                  {FileKind: []model.FileKind{model.KindCFG}, Platform: "ansible"},
		"../assets/queries/ansible/hosts":                   {FileKind: []model.FileKind{model.KindINI, model.KindYAML}, Platform: "ansible"},
		"../assets/queries/dockerfile":                      {FileKind: []model.FileKind{model.KindDOCKER}, Platform: "dockerfile"},
		"../assets/queries/dockerCompose":                   {FileKind: []model.FileKind{model.KindYAML}, Platform: "dockerCompose"},
		"../assets/queries/openAPI/general":                 {FileKind: []model.FileKind{model.KindYAML, model.KindJSON}, Platform: "openAPI"},
		"../assets/queries/openAPI/3.0":                     {FileKind: []model.FileKind{model.KindYAML, model.KindJSON}, Platform: "openAPI"},
		"../assets/queries/openAPI/2.0":                     {FileKind: []model.FileKind{model.KindYAML, model.KindJSON}, Platform: "openAPI"},
		"../assets/queries/azureResourceManager":            {FileKind: []model.FileKind{model.KindJSON, model.KindBICEP}, Platform: "azureResourceManager"},
		"../assets/queries/googleDeploymentManager/gcp":     {FileKind: []model.FileKind{model.KindYAML}, Platform: "googleDeploymentManager"},
		"../assets/queries/googleDeploymentManager/gcp_bom": {FileKind: []model.FileKind{model.KindYAML}, Platform: "googleDeploymentManager"},
		"../assets/queries/grpc":                            {FileKind: []model.FileKind{model.KindPROTO}, Platform: "grpc"},
		"../assets/queries/buildah":                         {FileKind: []model.FileKind{model.KindBUILDAH}, Platform: "buildah"},
		"../assets/queries/serverlessFW":                    {FileKind: []model.FileKind{model.KindYAML, model.KindYML}, Platform: "serverlessFW"},
		"../assets/queries/knative":                         {FileKind: []model.FileKind{model.KindYAML}, Platform: "knative"},
		"../assets/queries/cicd/github":                     {FileKind: []model.FileKind{model.KindYAML}, Platform: "cicd"},
	}

	issueTypes = map[string]string{
		"MissingAttribute":   "",
		"IncorrectValue":     "",
		"RedundantAttribute": "",
		"BillOfMaterials":    "",
	}
)

const (
	scanID                  = "test_scan"
	BaseTestsScanPath       = "../assets/queries/"
	ExpectedResultsFilename = "positive_expected_result.json"
)

func TestMain(m *testing.M) {
	os.Exit(m.Run())
}

type queryEntry struct {
	dir      string
	kind     []model.FileKind
	platform string
}

func (q queryEntry) getSampleFiles(tb testing.TB, directory, filePattern string) []string {
	var files []string
	for _, kinds := range q.kind {
		kindFiles, err := filepath.Glob(path.Join(q.dir, directory, fmt.Sprintf(filePattern, strings.ToLower(string(kinds)))))
		positiveExpectedResultsFilepath := q.ExpectedPositiveResultFile(directory)
		for i, check := range kindFiles {
			if check == positiveExpectedResultsFilepath {
				kindFiles = append(kindFiles[:i], kindFiles[i+1:]...)
			}
		}
		require.Nil(tb, err)
		files = append(files, kindFiles...)
	}
	return files
}

func (q queryEntry) PositiveFiles(tb testing.TB) []string {
	return q.getSampleFiles(tb, "test", "positive*.%s")
}

func (q queryEntry) NegativeFiles(tb testing.TB) []string {
	return q.getSampleFiles(tb, "test", "negative*.%s")
}

func (q queryEntry) ExpectedPositiveResultFile(directory string) string {
	return filepath.FromSlash(path.Join(q.dir, directory, ExpectedResultsFilename))
}

func (q queryEntry) getSampleDirectories(tb testing.TB, dirPattern string) map[string][]string {
	matches, err := filepath.Glob(path.Join(q.dir, dirPattern))
	require.Nil(tb, err)

	dirs := make(map[string][]string)
	for _, match := range matches {
		info, err := os.Stat(match)
		require.Nil(tb, err)
		if info.IsDir() {
			relativePath, err := filepath.Rel(q.dir, match)
			require.Nil(tb, err)
			base := filepath.Base(relativePath)
			dirs[base] = q.getSampleFiles(tb, relativePath, base+"*.%s")
		}
	}
	return dirs
}

func (q queryEntry) PositiveDirectories(tb testing.TB) map[string][]string {
	return q.getSampleDirectories(tb, "test/positive*")
}

func (q queryEntry) NegativeDirectories(tb testing.TB) map[string][]string {
	return q.getSampleDirectories(tb, "test/negative*")
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

	for _, parser := range combinedParser {
		docs, err := parser.Parse(filePath, content, true, false, 15)
		for _, document := range docs.Docs {
			require.NoError(t, err)
			files = append(files, model.FileMetadata{
				ID:                uuid.NewString(),
				ScanID:            scanID,
				Document:          kics.PrepareScanDocument(document, docs.Kind),
				LineInfoDocument:  document,
				OriginalData:      docs.Content,
				Kind:              docs.Kind,
				FilePath:          filePath,
				LinesOriginalData: utils.SplitLines(docs.Content),
				ResolvedFiles:     docs.ResolvedFiles,
			})
		}
	}
	return files
}

func getCombinedParser() []*parser.Parser {
	bd, _ := parser.NewBuilder().
		Add(&jsonParser.Parser{}).
		Add(&yamlParser.Parser{}).
		Add(&bicepParser.Parser{}).
		Add(terraformParser.NewDefault()).
		Add(&dockerParser.Parser{}).
		Add(&protoParser.Parser{}).
		Add(&buildahParser.Parser{}).
		Add(&ansibleConfigParser.Parser{}).
		Add(&ansibleHostsParser.Parser{}).
		Build([]string{""}, []string{""})
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

func readLibrary(platform string) (source.RegoLibraries, error) {
	library := source.GetPathToCustomLibrary(platform, "./assets/libraries")

	libraryData, err := assets.GetEmbeddedLibraryData(strings.ToLower(platform))
	if err != nil {
		log.Debug().Msgf("Couldn't load input data for library of %s platform.", platform)
		libraryData = "{}"
	}

	if library != "default" {
		content, err := os.ReadFile(library)
		return source.RegoLibraries{
			LibraryCode:      string(content),
			LibraryInputData: libraryData,
		}, err
	}

	log.Debug().Msgf("Custom library not provided. Loading embedded library instead")

	// getting embedded library
	embeddedLibrary, errGettingEmbeddedLibrary := assets.GetEmbeddedLibrary(strings.ToLower(platform))

	return source.RegoLibraries{
		LibraryCode:      embeddedLibrary,
		LibraryInputData: libraryData,
	}, errGettingEmbeddedLibrary
}

func isValidURL(toTest string) bool {
	_, err := url.ParseRequestURI(toTest)
	if err != nil {
		return false
	}

	u, err := url.Parse(toTest)
	return err == nil && u.Scheme != "" && u.Host != ""
}

func getQueryFilter() *source.QueryInspectorParameters {
	return &source.QueryInspectorParameters{
		IncludeQueries: source.IncludeQueries{ByIDs: []string{}},
		ExcludeQueries: source.ExcludeQueries{ByIDs: []string{}, ByCategories: []string{}},
		InputDataPath:  "",
	}
}

