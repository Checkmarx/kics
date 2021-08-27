package model

import (
	"testing"

	"github.com/stretchr/testify/require"
)

// TestExtensions_MatchedFilesRegex tests the functions [MatchedFilesRegex()] and all the methods called by them
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

// TestInclude tests the functions [Include()] and all the methods called by them
func TestInclude(t *testing.T) {
	e := Extensions{
		".txt": struct{}{},
		".tf":  struct{}{},
	}
	require.Equal(t, true, e.Include(".txt"))
}

// TestFileMetadatas tests the functions [Combine(),ToMap()] and all the methods called by them
func TestFileMetadatas(t *testing.T) {
	m := FileMetadatas{
		{
			ID:           "id",
			ScanID:       "scan_id",
			OriginalData: "orig_data",
			FilePath:     "file_name",
			Document: Document{
				"id": "",
			},
		},
	}

	mEmptyDocuments := FileMetadatas{
		{
			ID:           "id",
			ScanID:       "scan_id",
			OriginalData: "orig_data",
			FilePath:     "file_name",
			Document:     nil,
		},
	}

	mIgnoreCommand := FileMetadatas{
		{
			ID:           "id",
			ScanID:       "scan_id",
			OriginalData: "orig_data",
			FilePath:     "file_name",
			Document: Document{
				"id": "",
			},
			Commands: CommentsCommands{
				"ignore": "",
			},
		},
	}

	t.Run("to_map", func(t *testing.T) {
		result := m.ToMap()
		require.Len(t, result, 1)
		require.Equal(t, m[0], result["id"])
	})

	t.Run("combine", func(t *testing.T) {
		result := m.Combine(false)
		require.Equal(t, Documents{Documents: []Document{{"file": "file_name", "id": "id"}}}, result)
	})

	t.Run("combine_empty_documents", func(t *testing.T) {
		result := mEmptyDocuments.Combine(false)
		require.Equal(t, Documents{Documents: []Document{}}, result)
	})

	t.Run("ignore_documents", func(t *testing.T) {
		result := mIgnoreCommand.Combine(false)
		require.Equal(t, Documents{Documents: []Document{}}, result)
	})
}
