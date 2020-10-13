package test

import (
	"io/ioutil"
	"os"
	"path"
	"testing"

	"github.com/stretchr/testify/require"
)

const (
	queryFileName    = "query.rego"
	metadataFileName = "metadata.json"

	invalidTerraformFileName = "test/invalid.tf"
	successTerraformFileName = "test/success.tf"

	invalidQueryExpectedResultFileName = "test/invalid_expected_result.json"
)

var (
	queriesPaths = [3]string{
		"../assets/queries/terraform/aws",
		"../assets/queries/terraform/azure",
		"../assets/queries/terraform/gcp",
	}
)

func TestMain(m *testing.M) {
	os.Exit(m.Run())
}

func loadQueriesDir(t *testing.T) []string {
	var queriesDir []string
	for _, queriesPath := range queriesPaths {
		fs, err := ioutil.ReadDir(queriesPath)
		require.Nil(t, err)

		for _, f := range fs {
			require.True(t, f.IsDir(), "expected directory, actual file %s", f.Name())

			queriesDir = append(queriesDir, path.Join(queriesPath, f.Name()))
		}
	}

	return queriesDir
}
