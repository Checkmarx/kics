package engine

import (
	"path/filepath"
	"runtime"
	"testing"

	"github.com/stretchr/testify/require"
)

type computeSimilarityIDParams struct {
	filePath    string
	queryID     string
	searchKey   string
	searchValue string
}

type computeSimilarityIDSubTest struct {
	calls            []computeSimilarityIDParams
	expectedFunction func(t *testing.T, firstHash, secondHash *string)
}

var (
	similarityIDTests = []computeSimilarityIDSubTest{
		{
			calls: []computeSimilarityIDParams{
				{
					filePath:    "test.yaml",
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "TCP,22",
				},
				{
					filePath:    "test1.yaml", // change
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "TCP,22",
				},
			},
			expectedFunction: func(t *testing.T, firstHash, secondHash *string) {
				require.NotEqual(t, *firstHash, *secondHash)
			},
		},
		{
			calls: []computeSimilarityIDParams{
				{
					filePath:    "test.yaml",
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "",
				},
				{
					filePath:    "test.yaml",
					queryID:     "OTHER-8d74-49ef-87f8-b9613b63b6a8", // change
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "",
				},
			},
			expectedFunction: func(t *testing.T, firstHash, secondHash *string) {
				require.NotEqual(t, *firstHash, *secondHash)
			},
		},
		{
			calls: []computeSimilarityIDParams{
				{
					filePath:    "test.yaml",
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "",
				},
				{
					filePath:    "test.yaml",
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MyOther.SearchKey", // change
					searchValue: "",
				},
			},
			expectedFunction: func(t *testing.T, firstHash, secondHash *string) {
				require.NotEqual(t, *firstHash, *secondHash)
			},
		},
		{
			calls: []computeSimilarityIDParams{
				{
					filePath:    "my/filesystem/test.yaml",
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "",
				},
				{
					filePath:    "my/filesystem/other/test.yaml", // change
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "",
				},
			},
			expectedFunction: func(t *testing.T, firstHash, secondHash *string) {
				require.NotEqual(t, *firstHash, *secondHash)
			},
		},
		{
			calls: []computeSimilarityIDParams{
				{
					filePath:    "my/directory",
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "TCP,22",
				},
				{
					filePath:    "my/directory",
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "TCP,22",
				},
			},
			expectedFunction: func(t *testing.T, firstHash, secondHash *string) {
				require.Equal(t, *firstHash, *secondHash)
			},
		},
		{
			calls: []computeSimilarityIDParams{
				{
					filePath:    "my/directory/../test.yaml/",
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "",
				},
				{
					filePath:    "my/test.yaml",
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "",
				},
			},
			expectedFunction: func(t *testing.T, firstHash, secondHash *string) {
				require.Equal(t, *firstHash, *secondHash)
			},
		},
		{
			calls: []computeSimilarityIDParams{
				{
					filePath:    "../assets/queries/",
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "",
				},
				{
					filePath:    "../assets/queries/",
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "",
				},
			},
			expectedFunction: func(t *testing.T, firstHash, secondHash *string) {
				require.Equal(t, *firstHash, *secondHash)
			},
		},
	}
)

func TestComputeSimilarityID(t *testing.T) {
	for _, tc := range similarityIDTests {
		firstHash, err := ComputeSimilarityID(tc.calls[0].filePath, tc.calls[0].queryID, tc.calls[0].searchKey, tc.calls[0].searchValue)
		require.NoError(t, err)
		require.NotEmpty(t, *firstHash)
		secondHash, err := ComputeSimilarityID(tc.calls[1].filePath, tc.calls[1].queryID, tc.calls[1].searchKey, tc.calls[1].searchValue)
		require.NoError(t, err)
		require.NotEmpty(t, *secondHash)

		tc.expectedFunction(t, firstHash, secondHash)
	}
}

func TestStandardizeFilePathEquals(t *testing.T) {
	tests := []struct {
		input            string
		expectedOutput   string
		expectedFunction func(t *testing.T, expected, actual string)
	}{
		{
			input:          "my/filesystem/test.yaml",
			expectedOutput: "my/filesystem/test.yaml",
			expectedFunction: func(t *testing.T, expected, actual string) {
				require.Equal(t, expected, actual)
			},
		},
		{
			input:          "my//filesystem///test.yaml",
			expectedOutput: "my/filesystem/test.yaml",
			expectedFunction: func(t *testing.T, expected, actual string) {
				require.Equal(t, expected, actual)
			},
		},
		{
			input:          "my//filesystem//../test.yaml",
			expectedOutput: "my/test.yaml",
			expectedFunction: func(t *testing.T, expected, actual string) {
				require.Equal(t, expected, actual)
			},
		},
		{
			input:          "my/filesystem/other/test.yaml",
			expectedOutput: "my/filesystem/test.yaml",
			expectedFunction: func(t *testing.T, expected, actual string) {
				require.NotEqual(t, expected, actual)
			},
		},
	}

	for _, tc := range tests {
		path := filepath.FromSlash(tc.input)
		standardPath, err := standardizeFilePath(path)
		require.NoError(t, err)
		require.NotEmpty(t, standardPath)
		tc.expectedFunction(t, tc.expectedOutput, standardPath)
	}
}

func TestStandardizeFilePathAbsoluteError(t *testing.T) {
	var path string
	if runtime.GOOS == "windows" {
		path = filepath.FromSlash("C://" + "my/filesystem/other/test.yaml")
	} else {
		path = filepath.FromSlash("/" + "my/filesystem/other/test.yaml")
	}
	_, err := standardizeFilePath(path)
	require.Error(t, err)
}
