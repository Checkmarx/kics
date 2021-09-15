package similarity

import (
	"path/filepath"
	"runtime"
	"testing"

	"github.com/stretchr/testify/require"
)

type computeSimilarityIDParams struct {
	basePaths   []string
	filePath    string
	queryID     string
	searchKey   string
	searchValue string
}

var (
	similarityIDTests = []struct {
		name       string
		calls      []computeSimilarityIDParams
		wantEquals bool
	}{
		{
			name: "Changed file name",
			calls: []computeSimilarityIDParams{
				{
					basePaths:   []string{filepath.Join("my", "test")},
					filePath:    filepath.Join("my", "test", "test.yaml"),
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "TCP,22",
				},
				{
					basePaths:   []string{filepath.Join("my", "test")},
					filePath:    filepath.Join("my", "test", "test1.yaml"), // change
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "TCP,22",
				},
			},
			wantEquals: false,
		},
		{
			name: "Changed file name with multiple paths",
			calls: []computeSimilarityIDParams{
				{
					basePaths:   []string{filepath.Join("my", "test"), filepath.Join("my", "other", "test")},
					filePath:    filepath.Join("my", "test", "test.yaml"),
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "TCP,22",
				},
				{
					basePaths:   []string{filepath.Join("my", "test")},
					filePath:    filepath.Join("my", "test", "test1.yaml"), // change
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "TCP,22",
				},
			},
			wantEquals: false,
		},
		{
			name: "Changed queryID",
			calls: []computeSimilarityIDParams{
				{
					basePaths:   []string{filepath.Join("my", "test")},
					filePath:    filepath.Join("my", "test", "test.yaml"),
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "",
				},
				{
					basePaths:   []string{filepath.Join("my", "test")},
					filePath:    filepath.Join("my", "test", "test.yaml"),
					queryID:     "OTHER-8d74-49ef-87f8-b9613b63b6a8", // change
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "",
				},
			},
			wantEquals: false,
		},
		{
			name: "Changed searchKey",
			calls: []computeSimilarityIDParams{
				{
					basePaths:   []string{filepath.Join("my", "test")},
					filePath:    filepath.Join("my", "test", "test.yaml"),
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "",
				},
				{
					basePaths:   []string{filepath.Join("my", "test")},
					filePath:    filepath.Join("my", "test", "test.yaml"),
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MyOther.SearchKey", // change
					searchValue: "",
				},
			},
			wantEquals: false,
		},
		{
			name: "Changed filepath dir",
			calls: []computeSimilarityIDParams{
				{
					basePaths:   []string{filepath.Join("my", "test")},
					filePath:    filepath.Join("my", "filesystem", "test.yaml"),
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "",
				},
				{
					basePaths:   []string{filepath.Join("my", "test")},
					filePath:    filepath.Join("my", "filesystem", "other", "test.yaml"), // change
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "",
				},
			},
			wantEquals: false,
		},
		{
			name: "No changes",
			calls: []computeSimilarityIDParams{
				{
					basePaths:   []string{filepath.Join("my", "test")},
					filePath:    filepath.Join("my", "test", "directory", "file.tf"),
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "TCP,22",
				},
				{
					basePaths:   []string{filepath.Join("my", "test")},
					filePath:    filepath.Join("my", "test", "directory", "file.tf"),
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "TCP,22",
				},
			},
			wantEquals: true,
		},
		{
			name: "Windows path to file",
			calls: []computeSimilarityIDParams{
				{
					basePaths:   []string{".\\my\\test\\file.tf"},
					filePath:    ".\\my\\test\\file.tf",
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "TCP,22",
				},
				{
					basePaths:   []string{filepath.Join(".", "my", "test", "file.tf")},
					filePath:    filepath.Join(".", "my", "test", "file.tf"),
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "TCP,22",
				},
			},
			wantEquals: true,
		},
		{
			name: "Relative directory resolution",
			calls: []computeSimilarityIDParams{
				{
					basePaths:   []string{filepath.Join("my", "test")},
					filePath:    filepath.Join("my", "test", "directory", "..", "infra.tf"),
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "",
				},
				{
					basePaths:   []string{filepath.Join("my", "test")},
					filePath:    filepath.Join("my", "test", "infra.tf"),
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "",
				},
			},
			wantEquals: true,
		},
		{
			name: "No changes, empty searchValue",
			calls: []computeSimilarityIDParams{
				{
					basePaths:   []string{filepath.Join("my", "test")},
					filePath:    filepath.Join("..", "test", "assets", "queries", "sample.dockerfile"),
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "",
				},
				{
					basePaths:   []string{filepath.Join("my", "test")},
					filePath:    filepath.Join("..", "test", "assets", "queries", "sample.dockerfile"),
					queryID:     "e96ccbb0-8d74-49ef-87f8-b9613b63b6a8",
					searchKey:   "Resources.MySearchKeyExample",
					searchValue: "",
				},
			},
			wantEquals: true,
		},
	}
)

// TestComputeSimilarityID tests the functions [ComputeSimilarityID()] and all the methods called by them
func TestComputeSimilarityID(t *testing.T) {
	for _, tc := range similarityIDTests {
		t.Run(tc.name, func(tt *testing.T) {
			firstHash, err := ComputeSimilarityID(tc.calls[0].basePaths, tc.calls[0].filePath, tc.calls[0].queryID, tc.calls[0].searchKey,
				tc.calls[0].searchValue)
			require.NoError(tt, err, "test[%s] expects no error", tc.name)
			require.NotEmpty(tt, *firstHash, "test[%s] expects firstHash not empty", tc.name)
			secondHash, err := ComputeSimilarityID(tc.calls[1].basePaths, tc.calls[1].filePath, tc.calls[1].queryID, tc.calls[1].searchKey,
				tc.calls[1].searchValue)
			require.NoError(tt, err, "test[%s] expects no error", tc.name)
			require.NotEmpty(tt, *secondHash, "test[%s] expects secondHash not empty", tc.name)

			if tc.wantEquals {
				require.Equal(t, *firstHash, *secondHash, "test[%s] hashes should be equal first %s second %s", tc.name, *firstHash, *secondHash)
			} else {
				require.NotEqual(t, *firstHash, *secondHash, "test[%s] hashes should not be equal first %s second %s", tc.name, *firstHash, *secondHash)
			}
		})
	}
}

// TestStandardizeFilePathEquals tests the functions [standardizeFilePath()] and all the methods called by them
func TestStandardizeFilePathEquals(t *testing.T) {
	var volumeName string
	if runtime.GOOS == "windows" {
		volumeName = "C:"
	} else {
		volumeName = "/"
	}

	tests := []struct {
		basePath         string
		name             string
		input            string
		expectedOutput   string
		expectedFunction func(t *testing.T, expected, actual string, err error)
	}{
		{
			name:           "Clean input",
			basePath:       filepath.Join(volumeName, "test", "my", "project"),
			input:          filepath.Join(volumeName, "test", "my", "project", "test.yaml"),
			expectedOutput: "test.yaml",
			expectedFunction: func(t *testing.T, expected, actual string, err error) {
				require.NotEmpty(t, actual)
				require.Equal(t, expected, actual)
			},
		},
		{
			name:           "Resolve relative path",
			basePath:       filepath.Join(volumeName, "test", "my", "project"),
			input:          filepath.Join(volumeName, "test", "my", "project", "..", "test.yaml"),
			expectedOutput: "../test.yaml",
			expectedFunction: func(t *testing.T, expected, actual string, err error) {
				require.NotEmpty(t, actual)
				require.Equal(t, expected, actual)
			},
		},
		{
			name:           "Check different directory",
			basePath:       filepath.Join(volumeName, "test", "my", "project"),
			input:          filepath.Join(volumeName, "test", "my", "project", "other", "test.yaml"),
			expectedOutput: volumeName + "test/my/project/test.yaml",
			expectedFunction: func(t *testing.T, expected, actual string, err error) {
				require.NotEmpty(t, actual)
				require.NotEqual(t, expected, actual)
			},
		},
		{
			name:           "Check different directory",
			basePath:       filepath.Join("D:", "test", "my", "project"),
			input:          filepath.Join(volumeName, "test", "my", "project", "other", "test.yaml"),
			expectedOutput: volumeName + "/test/my/project/test.yaml",
			expectedFunction: func(t *testing.T, expected, actual string, err error) {
				require.Error(t, err)
			},
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(tt *testing.T) {
			path := filepath.FromSlash(tc.input)
			standardPath, err := standardizeToRelativePath(tc.basePath, path)
			tc.expectedFunction(t, tc.expectedOutput, standardPath, err)
		})
	}
}
