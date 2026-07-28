package utils

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestSanitizePath(t *testing.T) {
	abs := func(parts ...string) string {
		p, err := filepath.Abs(filepath.Join(parts...))
		require.NoError(t, err)
		return p
	}

	base := abs("testdata")
	myDir := abs("my", "good", "dir")

	tests := []struct {
		name    string
		bases   []string
		path    string
		want    string
		wantErr bool
	}{
		{
			name:  "CWD-relative path inside base",
			bases: []string{base},
			path:  filepath.Join("testdata", "file.txt"),
			want:  filepath.Join(base, "file.txt"),
		},
		{
			name:  "CWD-relative path equal to base",
			bases: []string{base},
			path:  "testdata",
			want:  base,
		},
		{
			name:    "rejects relative path that resolves outside base",
			bases:   []string{myDir},
			path:    "outside.txt",
			wantErr: true,
		},
		{
			name:  "relative path with traversal cleaned within base",
			bases: []string{myDir},
			path:  filepath.Join("my", "good", "dir", "subdir", "..", "file.txt"),
			want:  filepath.Join(myDir, "file.txt"),
		},
		{
			name:    "rejects absolute path outside all bases",
			bases:   []string{myDir},
			path:    abs("etc", "passwd"),
			wantErr: true,
		},
		{
			name:  "allows absolute path inside one of many bases",
			bases: []string{abs("first", "good", "dir"), abs("second", "good", "dir")},
			path:  filepath.Join(abs("second", "good", "dir"), "child", "file.txt"),
			want:  filepath.Join(abs("second", "good", "dir"), "child", "file.txt"),
		},
		{
			name:    "relative path is resolved against CWD not against bases",
			bases:   []string{abs("only-allowed-base")},
			path:    "file.txt",
			wantErr: true,
		},
		{
			name:    "rejects sibling prefix collision",
			bases:   []string{abs("safe")},
			path:    filepath.Join(abs("safe-evil"), "file"),
			wantErr: true,
		},
		{
			name:    "rejects empty base list",
			bases:   nil,
			path:    "file.txt",
			wantErr: true,
		},
		{
			name:    "rejects empty base entry",
			bases:   []string{""},
			path:    "file.txt",
			wantErr: true,
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			got, err := SanitizePath(tc.bases, tc.path)
			if tc.wantErr {
				require.Error(t, err)
				return
			}
			require.NoError(t, err)
			require.Equal(t, tc.want, got)
		})
	}
}

func TestSanitizePath_BaseIsFile(t *testing.T) {
	makeFile := func(t *testing.T) (dir, file string) {
		t.Helper()
		dir = t.TempDir()
		file = filepath.Join(dir, "file.tf")
		require.NoError(t, os.WriteFile(file, nil, 0o600))
		return dir, file
	}

	tests := []struct {
		name    string
		setup   func(t *testing.T) (bases []string, path, want string)
		wantErr bool
	}{
		{
			name: "CWD-relative path inside parent directory of file base is allowed",
			setup: func(t *testing.T) ([]string, string, string) {
				dir, file := makeFile(t)
				t.Chdir(dir)
				want, err := filepath.Abs("sibling.tf")
				require.NoError(t, err)
				return []string{file}, "sibling.tf", want
			},
		},
		{
			name: "absolute path inside parent directory of file base is allowed",
			setup: func(t *testing.T) ([]string, string, string) {
				dir, file := makeFile(t)
				abs := filepath.Join(dir, "child", "deep.tf")
				return []string{file}, abs, abs
			},
		},
		{
			name: "relative traversal escaping parent of file base is rejected",
			setup: func(t *testing.T) ([]string, string, string) {
				_, file := makeFile(t)
				return []string{file}, filepath.Join("..", "outside.tf"), ""
			},
			wantErr: true,
		},
		{
			name: "CWD-relative path sharing base prefix is not concatenated",
			setup: func(t *testing.T) ([]string, string, string) {
				dir := t.TempDir()
				sub := filepath.Join("e2e", "fixtures", "openapi")
				require.NoError(t, os.MkdirAll(filepath.Join(dir, sub, "resources"), 0o700))
				require.NoError(t, os.WriteFile(filepath.Join(dir, sub, "openapi.yaml"), nil, 0o600))
				require.NoError(t, os.WriteFile(filepath.Join(dir, sub, "resources", "pets.yaml"), nil, 0o600))
				t.Chdir(dir)
				basePath := filepath.Join(sub, "openapi.yaml")
				pathArg := filepath.Join(sub, "resources", "pets.yaml")
				want, err := filepath.Abs(pathArg)
				require.NoError(t, err)
				return []string{basePath}, pathArg, want
			},
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			bases, path, want := tc.setup(t)
			got, err := SanitizePath(bases, path)
			if tc.wantErr {
				require.Error(t, err)
				return
			}
			require.NoError(t, err)
			require.Equal(t, want, got)
		})
	}
}
