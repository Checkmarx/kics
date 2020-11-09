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

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/pkg/parser"
	jsonParser "github.com/checkmarxDev/ice/pkg/parser/json"
	terraformParser "github.com/checkmarxDev/ice/pkg/parser/terraform"
	yamlParser "github.com/checkmarxDev/ice/pkg/parser/yaml"
	"github.com/stretchr/testify/require"
)

const (
	queryFileName    = "query.rego"
	metadataFileName = "metadata.json"
)

var (
	queriesPaths = map[string]model.FileKind{
		"../assets/queries/terraform/aws":   model.KindTerraform,
		"../assets/queries/terraform/azure": model.KindTerraform,
		"../assets/queries/terraform/gcp":   model.KindTerraform,
		"../assets/queries/k8s":             model.KindYAML,
	}
)

func TestMain(m *testing.M) {
	os.Exit(m.Run())
}

type queryEntry struct {
	dir  string
	kind model.FileKind
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

func getQueriesPaths(t *testing.T, queriesPath string) []string {
	queryDirs := make([]string, 0)
	err := filepath.Walk(queriesPath,
		func(p string, f os.FileInfo, err error) error {
			require.Nil(t, err)

			if f.IsDir() || f.Name() != "query.rego" {
				return nil
			}

			queryDirs = append(queryDirs, filepath.Dir(p))

			return nil
		})

	require.Nil(t, err)

	return queryDirs
}

func loadQueries(t *testing.T) []queryEntry {
	var queriesDir []queryEntry

	for queriesPath, kind := range queriesPaths {
		var queriesDirPaths = getQueriesPaths(t, queriesPath)

		for _, queriesDirPath := range queriesDirPaths {
			queriesDir = append(queriesDir, queryEntry{
				dir:  queriesDirPath,
				kind: kind,
			})
		}
	}

	return queriesDir
}

func getParsedFile(t *testing.T, filePath string) model.FileMetadatas {
	content, err := ioutil.ReadFile(filePath)
	require.NoError(t, err)

	combinedParser := parser.NewBuilder().
		Add(&jsonParser.Parser{}).
		Add(&yamlParser.Parser{}).
		Add(terraformParser.NewDefault()).
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
