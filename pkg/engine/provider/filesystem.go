package provider

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

type checkCondition struct {
	skip  bool
	isDir bool
}

// ErrNotSupportedFile - error representing when a file format is not supported by KICS
var ErrNotSupportedFile = errors.New("invalid file format")

// NewFileSystemSourceProvider initializes a FileSystemSourceProvider with path and files that will be ignored
func NewFileSystemSourceProvider(path string, excludes []string) (*FileSystemSourceProvider, error) {
	ex := make(map[string][]os.FileInfo, len(excludes))
	for _, exclude := range excludes {
		excludePaths, err := getExcludePaths(exclude)
		if err != nil {
			return nil, err
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

func getExcludePaths(pathExpressions string) ([]string, error) {
	if strings.ContainsAny(pathExpressions, "*?[") {
		info, err := filepath.Glob(pathExpressions)
		if err != nil {
			return nil, errors.Wrap(err, "failed to open excluded file")
		}
		return info, nil
	}
	return []string{pathExpressions}, nil
}

// GetBasePath returns base path of FileSystemSourceProvider
func (s *FileSystemSourceProvider) GetBasePath() string {
	return s.path
}

// GetSources tries to open file or directory and execute sink function on it
func (s *FileSystemSourceProvider) GetSources(ctx context.Context,
	extensions model.Extensions, sink Sink, resolverSink ResolverSink) error {
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

		return sink(ctx, s.path, c)
	}

	err = filepath.Walk(s.path, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		if shouldSkip, skipFolder := s.checkConditions(info, extensions, path); shouldSkip.skip || shouldSkip.isDir {
			// ------------------ resolver --------------------------------
			if shouldSkip.isDir && !shouldSkip.skip {
				err = resolverSink(ctx, strings.ReplaceAll(path, "\\", "/"))
				if err != nil {
					sentry.CaptureException(err)
					log.Err(err).
						Msgf("Filesystem files provider couldn't Resolve Directory, file=%s", info.Name())
				}
				return nil
				// ------------------------------------------------------------
			}
			return skipFolder
		}

		c, err := os.Open(filepath.Clean(path))
		if err != nil {
			return errors.Wrap(err, "failed to open file")
		}
		defer closeFile(c, info)

		err = sink(ctx, strings.ReplaceAll(path, "\\", "/"), c)
		if err != nil {
			sentry.CaptureException(err)
			log.Err(err).
				Msgf("Filesystem files provider couldn't parse file, file=%s", info.Name())
		}
		return nil
	})

	return errors.Wrap(err, "failed to walk directory")
}

func closeFile(file *os.File, info os.FileInfo) {
	if err := file.Close(); err != nil {
		sentry.CaptureException(err)
		log.Err(err).
			Msgf("Filesystem couldn't close file, file=%s", info.Name())
	}
}

func (s *FileSystemSourceProvider) checkConditions(info os.FileInfo, extensions model.Extensions, path string) (checkCondition, error) {
	if info.IsDir() {
		if f, ok := s.excludes[info.Name()]; ok && containsFile(f, info) {
			log.Info().Msgf("Directory ignored: %s", path)
			return checkCondition{
				skip:  true,
				isDir: true,
			}, filepath.SkipDir
		}
		return checkCondition{
			skip:  false,
			isDir: true,
		}, nil
	}
	if f, ok := s.excludes[info.Name()]; ok && containsFile(f, info) {
		log.Info().Msgf("File ignored: %s", path)
		return checkCondition{
			skip:  true,
			isDir: false,
		}, nil
	}
	if !extensions.Include(filepath.Ext(path)) && !extensions.Include(filepath.Base(path)) {
		return checkCondition{
			skip:  true,
			isDir: false,
		}, nil
	}
	return checkCondition{
		skip:  false,
		isDir: false,
	}, nil
}

func containsFile(fileList []os.FileInfo, target os.FileInfo) bool {
	for _, file := range fileList {
		if os.SameFile(file, target) {
			return true
		}
	}
	return false
}
