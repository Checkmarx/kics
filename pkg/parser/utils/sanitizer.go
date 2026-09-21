package utils

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

// SanitizePath resolves path to an absolute, cleaned form and ensures it stays
// within at least one of allowedBases. Both path and each base are resolved
// independently via filepath.Abs (so relative inputs are interpreted against
// the current working directory). If a base entry resolves to an existing
// regular file, its parent directory is used as the boundary. Returns an
// error if the resolved path escapes every allowed base (e.g. via "..") or
// if allowedBases is empty.
func SanitizePath(allowedBases []string, path string) (string, error) {
	if len(allowedBases) == 0 {
		return "", fmt.Errorf("sanitize path: no allowed base directories provided")
	}

	absBases := make([]string, 0, len(allowedBases))
	for _, base := range allowedBases {
		if base == "" {
			return "", fmt.Errorf("sanitize path: empty allowed base directory")
		}
		absBase, err := filepath.Abs(base)
		if err != nil {
			return "", fmt.Errorf("sanitize path: resolve base %q: %w", base, err)
		}
		if info, statErr := os.Stat(absBase); statErr == nil && !info.IsDir() {
			absBase = filepath.Dir(absBase)
		}
		absBases = append(absBases, absBase)
	}

	absPath, err := filepath.Abs(path)
	if err != nil {
		return "", fmt.Errorf("sanitize path: resolve %q: %w", path, err)
	}

	for _, absBase := range absBases {
		if absPath == absBase || strings.HasPrefix(absPath, absBase+string(filepath.Separator)) {
			return absPath, nil
		}
	}

	return "", fmt.Errorf("sanitize path: %q escapes allowed base directories", path)
}
