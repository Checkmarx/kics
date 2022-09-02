package fileglob

import (
	"errors"
	"fmt"
	"io"
	"io/fs"
	"os"
	"path/filepath"
	"strings"

	"github.com/gobwas/glob"
)

const (
	separatorRune   = '/'
	separatorString = string(separatorRune)
)

type globOptions struct {
	fs fs.FS

	// if matchDirectories directly is set to true a matching directory will
	// be treated just like a matching file. If set to false, a matching directory
	// will auto-match all files inside instead of the directory itself.
	matchDirectoriesDirectly bool

	prefix string

	pattern string
}

// OptFunc is a function that allow to customize Glob.
type OptFunc func(opts *globOptions)

// WithFs allows to provide another fs.FS implementation to Glob.
func WithFs(f fs.FS) OptFunc {
	return func(opts *globOptions) {
		opts.fs = f
	}
}

// MaybeRootFS setups fileglob to walk from the root directory (/) or
// volume (on windows) if the given pattern is an absolute path.
//
// Result will also be prepended with the root path or volume.
func MaybeRootFS(opts *globOptions) {
	if !filepath.IsAbs(opts.pattern) {
		return
	}
	prefix := ""
	if strings.HasPrefix(opts.pattern, separatorString) {
		prefix = separatorString
	}
	if vol := filepath.VolumeName(opts.pattern); vol != "" {
		prefix = vol + "/"
	}
	if prefix != "" {
		opts.prefix = prefix
		opts.fs = os.DirFS(prefix)
	}
}

// WriteOptions write the current options to the given writer.
func WriteOptions(w io.Writer) OptFunc {
	return func(opts *globOptions) {
		_, _ = fmt.Fprintf(w, "%+v", opts)
	}
}

// MatchDirectoryIncludesContents makes a match on a directory match all
// files inside it as well.
//
// This is the default behavior.
//
// Also check MatchDirectoryAsFile.
func MatchDirectoryIncludesContents(opts *globOptions) {
	opts.matchDirectoriesDirectly = false
}

// MatchDirectoryAsFile makes a match on a directory match its name only.
//
// Also check MatchDirectoryIncludesContents.
func MatchDirectoryAsFile(opts *globOptions) {
	opts.matchDirectoriesDirectly = true
}

// QuoteMeta quotes all glob pattern meta characters inside the argument text.
// For example, QuoteMeta for a pattern `{foo*}` sets the pattern to `\{foo\*\}`.
func QuoteMeta(opts *globOptions) {
	opts.pattern = glob.QuoteMeta(opts.pattern)
}

// toNixPath converts the path to the nix style path
// Windows style path separators are escape characters so cause issues with the compiled glob.
func toNixPath(s string) string {
	return filepath.ToSlash(filepath.Clean(s))
}

// Glob returns all files that match the given pattern in the current directory.
// If the given pattern indicates an absolute path, it will glob from `/`.
// If the given pattern starts with `../`, it will resolve to its absolute path and glob from `/`.
func Glob(pattern string, opts ...OptFunc) ([]string, error) { // nolint:funlen,cyclop
	var matches []string

	if strings.HasPrefix(pattern, "../") {
		p, err := filepath.Abs(pattern)
		if err != nil {
			return matches, fmt.Errorf("failed to resolve pattern: %s: %w", pattern, err)
		}
		pattern = filepath.ToSlash(p)
	}

	options := compileOptions(opts, pattern)

	pattern = strings.TrimSuffix(strings.TrimPrefix(options.pattern, options.prefix), separatorString)
	matcher, err := glob.Compile(pattern, separatorRune)
	if err != nil {
		return matches, fmt.Errorf("compile glob pattern: %w", err)
	}

	prefix, err := staticPrefix(pattern)
	if err != nil {
		return nil, fmt.Errorf("cannot determine static prefix: %w", err)
	}

	// Check if the file is valid symlink without following it
	// It works only for valid absolut or relative file paths, in other words, will fail for WithFs() option
	if patternInfo, err := os.Lstat(pattern); err == nil { // nolint:govet
		if patternInfo.Mode()&os.ModeSymlink == os.ModeSymlink {
			return cleanFilepaths([]string{pattern}, options.prefix), nil
		}
	}

	prefixInfo, err := fs.Stat(options.fs, prefix)
	if errors.Is(err, fs.ErrNotExist) {
		if !ContainsMatchers(pattern) {
			// glob contains no dynamic matchers so prefix is the file name that
			// the glob references directly. When the glob explicitly references
			// a single non-existing file, return an error for the user to check.
			return []string{}, fmt.Errorf(`matching "%s%s": %w`, options.prefix, prefix, fs.ErrNotExist)
		}

		return []string{}, nil
	}
	if err != nil {
		return nil, fmt.Errorf("stat static prefix %s%s: %w", options.prefix, prefix, err)
	}

	if !prefixInfo.IsDir() {
		// if the prefix is a file, it either has to be
		// the only match, or nothing matches at all
		if matcher.Match(prefix) {
			return cleanFilepaths([]string{prefix}, options.prefix), nil
		}

		return []string{}, nil
	}

	if err := fs.WalkDir(options.fs, prefix, func(path string, info fs.DirEntry, err error) error {
		if err != nil {
			return err
		}

		// The glob ast from github.com/gobwas/glob only works properly with linux paths
		path = toNixPath(path)
		if !matcher.Match(path) {
			return nil
		}

		if info.IsDir() {
			if options.matchDirectoriesDirectly {
				matches = append(matches, path)
				return nil
			}

			// a direct match on a directory implies that all files inside
			// match if options.matchFolders is false
			filesInDir, err := filesInDirectory(options, path)
			if err != nil {
				return err
			}

			matches = append(matches, filesInDir...)
			return fs.SkipDir
		}

		matches = append(matches, path)

		return nil
	}); err != nil {
		return nil, fmt.Errorf("glob failed: %w", err)
	}

	return cleanFilepaths(matches, options.prefix), nil
}

func compileOptions(optFuncs []OptFunc, pattern string) *globOptions {
	opts := &globOptions{
		fs:      os.DirFS("."),
		prefix:  "./",
		pattern: pattern,
	}

	for _, apply := range optFuncs {
		apply(opts)
	}

	return opts
}

func filesInDirectory(options *globOptions, dir string) ([]string, error) {
	var files []string

	err := fs.WalkDir(options.fs, dir, func(path string, info fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if info.IsDir() {
			return nil
		}
		path = toNixPath(path)
		files = append(files, path)
		return nil
	})
	if err != nil {
		return files, fmt.Errorf("failed to get files in directory: %w", err)
	}
	return files, nil
}

func cleanFilepaths(paths []string, prefix string) []string {
	if prefix == "./" {
		// if prefix is relative, no prefix and ./ is the same thing, ignore
		return paths
	}
	result := make([]string, len(paths))
	for i, p := range paths {
		result[i] = prefix + p
	}
	return result
}
