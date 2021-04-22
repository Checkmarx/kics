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

// ErrNotSupportedFile - error representing when a file format is not supported by KICS
var ErrNotSupportedFile = errors.New("invalid file format")

// NewFileSystemSourceProvider initializes a FileSystemSourceProvider with path and files that will be ignored
func NewFileSystemSourceProvider(path string, excludes []string) (*FileSystemSourceProvider, error) {
	log.Debug().Msgf("provider.NewFileSystemSourceProvider()")
	ex := make(map[string][]os.FileInfo, len(excludes))
	fs := &FileSystemSourceProvider{
		path:     filepath.FromSlash(path),
		excludes: ex,
	}
	for _, exclude := range excludes {
		excludePaths, err := getExcludePaths(exclude)
		if err != nil {
			return nil, err
		}
		if err := fs.AddExcluded(excludePaths); err != nil {
			return nil, err
		}
	}

	return fs, nil
}

// AddExcluded add new excluded files to the File System Source Provider
func (s *FileSystemSourceProvider) AddExcluded(excludePaths []string) error {
	for _, excludePath := range excludePaths {
		info, err := os.Stat(excludePath)
		if err != nil {
			if os.IsNotExist(err) {
				continue
			}
			return errors.Wrap(err, "failed to open excluded file")
		}
		if _, ok := s.excludes[info.Name()]; !ok {
			s.excludes[info.Name()] = make([]os.FileInfo, 0)
		}
		s.excludes[info.Name()] = append(s.excludes[info.Name()], info)
	}
	return nil
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
	resolved := false
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

		if shouldSkip, skipFolder := s.checkConditions(info, extensions, path, resolved); shouldSkip {
			return skipFolder
		}

		// ------------------ Helm resolver --------------------------------
		if info.IsDir() {
			excluded, errRes := resolverSink(ctx, strings.ReplaceAll(path, "\\", "/"))
			if errRes != nil {
				sentry.CaptureException(errRes)
				log.Err(errRes).
					Msgf("Filesystem files provider couldn't Resolve Directory, file=%s", info.Name())
				return nil
			}
			if errAdd := s.AddExcluded(excluded); errAdd != nil {
				log.Err(errAdd).Msgf("Filesystem files provider couldn't exclude rendered Chart files, Chart=%s", info.Name())
			}
			resolved = true
			return nil
		}
		// -----------------------------------------------------------------

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

func (s *FileSystemSourceProvider) checkConditions(info os.FileInfo, extensions model.Extensions,
	path string, resolved bool) (bool, error) {
	if info.IsDir() {
		if f, ok := s.excludes[info.Name()]; ok && containsFile(f, info) {
			log.Info().Msgf("Directory ignored: %s", path)
			return true, filepath.SkipDir
		}
		_, err := os.Stat(filepath.Join(path, "Chart.yaml"))
		if err != nil || resolved {
			return true, nil
		}
		return false, nil
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
