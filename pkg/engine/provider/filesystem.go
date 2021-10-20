package provider

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	sentryReport "github.com/Checkmarx/kics/internal/sentry"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

// FileSystemSourceProvider provides a path to be scanned
// and a list of files which will not be scanned
type FileSystemSourceProvider struct {
	paths    []string
	excludes map[string][]os.FileInfo
}

// ErrNotSupportedFile - error representing when a file format is not supported by KICS
var ErrNotSupportedFile = errors.New("invalid file format")

// NewFileSystemSourceProvider initializes a FileSystemSourceProvider with path and files that will be ignored
func NewFileSystemSourceProvider(paths, excludes []string) (*FileSystemSourceProvider, error) {
	log.Debug().Msgf("provider.NewFileSystemSourceProvider()")
	ex := make(map[string][]os.FileInfo, len(excludes))
	osPaths := make([]string, len(paths))
	for idx, path := range paths {
		osPaths[idx] = filepath.FromSlash(path)
	}
	fs := &FileSystemSourceProvider{
		paths:    osPaths,
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

// GetBasePaths returns base path of FileSystemSourceProvider
func (s *FileSystemSourceProvider) GetBasePaths() []string {
	return s.paths
}

// GetSources tries to open file or directory and execute sink function on it
func (s *FileSystemSourceProvider) GetSources(ctx context.Context,
	extensions model.Extensions, sink Sink, resolverSink ResolverSink) error {
	for _, scanPath := range s.paths {
		resolved := false
		fileInfo, err := os.Stat(scanPath)
		if err != nil {
			return errors.Wrap(err, "failed to open path")
		}

		if !fileInfo.IsDir() {
			c, openFileErr := openScanFile(scanPath, extensions)
			if openFileErr != nil {
				if openFileErr == ErrNotSupportedFile {
					continue
				}
				return openFileErr
			}
			if sinkErr := sink(ctx, scanPath, c); sinkErr != nil {
				return sinkErr
			}
			continue
		}

		err = s.walkDir(ctx, scanPath, resolved, sink, resolverSink, extensions)
		if err != nil {
			return errors.Wrap(err, "failed to walk directory")
		}
		continue
	}
	return nil
}

func (s *FileSystemSourceProvider) walkDir(ctx context.Context, scanPath string, resolved bool,
	sink Sink, resolverSink ResolverSink, extensions model.Extensions) error {
	return filepath.Walk(scanPath, func(path string, info os.FileInfo, err error) error {
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
				sentryReport.ReportSentry(&sentryReport.Report{
					Message:  fmt.Sprintf("Filesystem files provider couldn't Resolve Directory, file=%s", info.Name()),
					Err:      errRes,
					Location: "func walkDir()",
					FileName: info.Name(),
				}, true)
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
			sentryReport.ReportSentry(&sentryReport.Report{
				Message:  fmt.Sprintf("Filesystem files provider couldn't parse file, file=%s", info.Name()),
				Err:      err,
				Location: "func walkDir()",
				FileName: info.Name(),
			}, true)
		}
		return nil
	})
}

func openScanFile(scanPath string, extensions model.Extensions) (*os.File, error) {
	if !extensions.Include(filepath.Ext(scanPath)) && !extensions.Include(filepath.Base(scanPath)) {
		return nil, ErrNotSupportedFile
	}

	c, errOpenFile := os.Open(scanPath)
	if errOpenFile != nil {
		return nil, errors.Wrap(errOpenFile, "failed to open path")
	}
	return c, nil
}

func closeFile(file *os.File, info os.FileInfo) {
	if err := file.Close(); err != nil {
		sentryReport.ReportSentry(&sentryReport.Report{
			Message:  fmt.Sprintf("Filesystem couldn't close file, file=%s", info.Name()),
			Err:      err,
			Location: "func closeFile()",
			FileName: info.Name(),
		}, true)
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
		log.Trace().Msgf("File ignored: %s", path)
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
