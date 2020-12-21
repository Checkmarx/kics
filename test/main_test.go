package test

import (
	"fmt"
	"io/ioutil"
	"os"
	"path"
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
	queriesPaths = map[string]model.FileKind{
		"../assets/queries/terraform/aws":            model.KindTerraform,
		"../assets/queries/terraform/azure":          model.KindTerraform,
		"../assets/queries/terraform/gcp":            model.KindTerraform,
		"../assets/queries/k8s":                      model.KindYAML,
		"../assets/queries/cloudFormation":           model.KindYAML,
		"../assets/queries/ansible":                  model.KindYAML,
		"../assets/queries/dockerfile":               model.KindDOCKER,
		"../assets/queries/terraform/github":         model.KindTerraform,
		"../assets/queries/terraform/kubernetes_pod": model.KindTerraform,
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

func loadQueries(t *testing.T) []queryEntry {
	var queriesDir []queryEntry
	for queriesPath, kind := range queriesPaths {
		fs, err := ioutil.ReadDir(queriesPath)
		require.Nil(t, err)

		for _, f := range fs {
			require.True(t, f.IsDir(), "expected directory, actual file %s", f.Name())

			queriesDir = append(queriesDir, queryEntry{
				dir:  path.Join(queriesPath, f.Name()),
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
