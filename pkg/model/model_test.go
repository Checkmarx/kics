package model

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestExtensions_MatchedFilesRegex(t *testing.T) {
	var e Extensions
	require.Equal(t, "NO_MATCHED_FILES", e.MatchedFilesRegex())

	e = Extensions{}
	require.Equal(t, "NO_MATCHED_FILES", e.MatchedFilesRegex())

	e = Extensions{
		".txt": struct{}{},
	}
	require.Equal(t, "(.*)(\\.txt)$", e.MatchedFilesRegex())

	e = Extensions{
		".txt": struct{}{},
		".tf":  struct{}{},
	}
	require.Equal(t, "(.*)(\\.tf|\\.txt)$", e.MatchedFilesRegex())
}
