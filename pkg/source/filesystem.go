package source

import (
	"context"
	"os"
	"path/filepath"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/getsentry/sentry-go"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

// FileSystemSourceProvider provides a path to be scanned
// and a list of files which will not be scanned
type FileSystemSourceProvider struct {
	path     string
	excludes map[string][]os.FileInfo
}

// ErrNotSupportedFile - error representing when a file format is not supported by KICS
var ErrNotSupportedFile = errors.New("invalid file format")

// NewFileSystemSourceProvider initializes a FileSystemSourceProvider with path and files that will be ignored
func NewFileSystemSourceProvider(path string, excludes []string) (*FileSystemSourceProvider, error) {
	ex := make(map[string][]os.FileInfo, len(excludes))
	for _, exclude := range excludes {
		var excludePaths []string
		if strings.ContainsAny(exclude, "*?[") {
			info, err := filepath.Glob(exclude)
			if err != nil {
				return nil, errors.Wrap(err, "failed to open excluded file")
			}
			excludePaths = info
		} else {
			excludePaths = []string{exclude}
		}
		for _, excludePath := range excludePaths {
			info, err := os.Stat(excludePath)
			if err != nil {
				if os.IsNotExist(err) {
					continue
				}

				return nil, errors.Wrap(err, "failed to open excluded file")
			}
			if _, ok := ex[info.Name()]; !ok {
				ex[info.Name()] = make([]os.FileInfo, 0)
			}
			ex[info.Name()] = append(ex[info.Name()], info)
		}
	}

	return &FileSystemSourceProvider{
		path:     filepath.FromSlash(path),
		excludes: ex,
	}, nil
}

// GetBasePath returns base path of FileSystemSourceProvider
func (s *FileSystemSourceProvider) GetBasePath() string {
	return s.path
}

// GetSources tries to open file or directory and execute sink function on it
func (s *FileSystemSourceProvider) GetSources(ctx context.Context, _ string, extensions model.Extensions, sink Sink) error {
	fileInfo, err := os.Stat(s.path)
	if err != nil {
		return errors.Wrap(err, "failed to open path")
	}

	if !fileInfo.IsDir() {
		if !extensions.Include(filepath.Ext(s.path)) && !extensions.Include(filepath.Base(s.path)) {
			return ErrNotSupportedFile
		}

		c, errOpenFile := os.Open(s.path)
		if errOpenFile != nil {
			return errors.Wrap(errOpenFile, "failed to open path")
		}

		return sink(ctx, fileInfo.Name(), c)
	}

	err = filepath.Walk(s.path, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		if shouldSkip, skipFolder := s.checkConditions(info, extensions, path); shouldSkip {
			return skipFolder
		}
		c, err := os.Open(filepath.Clean(path))
		if err != nil {
			return errors.Wrap(err, "failed to open file")
		}

		err = sink(ctx, strings.ReplaceAll(path, "\\", "/"), c)
		if err != nil {
			sentry.CaptureException(err)
			log.Err(err).
				Msgf("Filesystem terraform files provider couldn't parse file, file=%s", info.Name())
		}
		if err := c.Close(); err != nil {
			sentry.CaptureException(err)
			log.Err(err).
				Msgf("Filesystem couldn't close file, file=%s", info.Name())
		}
		return nil
	})

	return errors.Wrap(err, "failed to walk directory")
}

func (s *FileSystemSourceProvider) checkConditions(info os.FileInfo, extensions model.Extensions, path string) (bool, error) {
	if info.IsDir() {
		if f, ok := s.excludes[info.Name()]; ok && containsFile(f, info) {
			log.Info().Msgf("Directory ignored: %s", path)
			return true, filepath.SkipDir
		}
		return true, nil
	}
	if f, ok := s.excludes[info.Name()]; ok && containsFile(f, info) {
		log.Info().Msgf("File ignored: %s", path)
		return true, nil
	}
	if !extensions.Include(filepath.Ext(path)) && !extensions.Include(filepath.Base(path)) {
		return true, nil
	}
	return false, nil
}

func containsFile(fileList []os.FileInfo, target os.FileInfo) bool {
	for _, file := range fileList {
		if os.SameFile(file, target) {
			return true
		}
	}
	return false
}
