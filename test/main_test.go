package test

import (
	"fmt"
	"io/ioutil"
	"os"
	"path"
	"path/filepath"
	"strconv"
	"strings"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/parser"
	dockerParser "github.com/Checkmarx/kics/pkg/parser/docker"
	jsonParser "github.com/Checkmarx/kics/pkg/parser/json"
	terraformParser "github.com/Checkmarx/kics/pkg/parser/terraform"
	yamlParser "github.com/Checkmarx/kics/pkg/parser/yaml"
	"github.com/stretchr/testify/require"
)

const (
	queryFileName    = "query.rego"
	metadataFileName = "metadata.json"
)

var (
	queriesPaths = map[string]model.QueryConfig{
		"../assets/queries/terraform/aws":            model.QueryConfig{FileKind: model.KindTerraform, Platform: "terraform"},
		"../assets/queries/terraform/azure":          model.QueryConfig{FileKind: model.KindTerraform, Platform: "terraform"},
		"../assets/queries/terraform/gcp":            model.QueryConfig{FileKind: model.KindTerraform, Platform: "terraform"},
		"../assets/queries/terraform/github":         model.QueryConfig{FileKind: model.KindTerraform, Platform: "terraform"},
		"../assets/queries/terraform/kubernetes_pod": model.QueryConfig{FileKind: model.KindTerraform, Platform: "terraform"},
		"../assets/queries/k8s":                      model.QueryConfig{FileKind: model.KindYAML, Platform: "k8s"},
		"../assets/queries/cloudFormation":           model.QueryConfig{FileKind: model.KindYAML, Platform: "cloudFormation"},
		"../assets/queries/ansible/aws":              model.QueryConfig{FileKind: model.KindYAML, Platform: "ansible"},
		"../assets/queries/ansible/gcp":              model.QueryConfig{FileKind: model.KindYAML, Platform: "ansible"},
		"../assets/queries/ansible/azure":            model.QueryConfig{FileKind: model.KindYAML, Platform: "ansible"},
		"../assets/queries/dockerfile":               model.QueryConfig{FileKind: model.KindDOCKER, Platform: "dockerfile"},
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

func (q queryEntry) PositiveFile() string {
	return path.Join(q.dir, fmt.Sprintf("test/positive.%s", strings.ToLower(string(q.kind))))
}

func (q queryEntry) NegativeFile() string {
	return path.Join(q.dir, fmt.Sprintf("test/negative.%s", strings.ToLower(string(q.kind))))
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
				queriesDir = appendQueries(queriesDir, filepath.ToSlash(queriesPath+"/"+f.Name()), queryConfig.FileKind, queryConfig.Platform)
			} else {
				queriesDir = appendQueries(queriesDir, filepath.ToSlash(queriesPath), queryConfig.FileKind, queryConfig.Platform)
				break
			}
		}
	}
	return queriesDir
}

func getParsedFile(t testing.TB, filePath string) model.FileMetadatas {
	content, err := ioutil.ReadFile(filePath)
	require.NoError(t, err)

	combinedParser := parser.NewBuilder().
		Add(&jsonParser.Parser{}).
		Add(&yamlParser.Parser{}).
		Add(terraformParser.NewDefault()).
		Add(&dockerParser.Parser{}).
		Build()

	documents, kind, err := combinedParser.Parse(filePath, content)
	require.NoError(t, err)

	files := make([]model.FileMetadata, 0, len(documents))
	for i, document := range documents {
		files = append(files, model.FileMetadata{
			ID:           strconv.Itoa(fileID + i),
			ScanID:       scanID,
			Document:     document,
			OriginalData: string(content),
			Kind:         kind,
			FileName:     filePath,
		})
	}

	return files
}
