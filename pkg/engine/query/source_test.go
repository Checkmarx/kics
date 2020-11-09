package query

import (
	"testing"

	"github.com/stretchr/testify/require"
)

const source = "../../../assets/queries"

func TestQueriesSource(t *testing.T) {
	s := FilesystemSource{
		Source: source,
	}

	queries, err := s.GetQueries()
	require.NoError(t, err)
	require.Greater(t, len(queries), 50, "Looks like not all queries can be loaded. Expected at least 50.")

	query := queries[0]
	require.NotEmpty(t, query.Query)
	require.NotEmpty(t, query.Content)
	require.NotNil(t, query.Metadata)
}
