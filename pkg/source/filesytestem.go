package source

import (
	"context"
	"os"
	"path/filepath"
	"strings"

	"github.com/checkmarxDev/ice/internal/logger"
	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/pkg/errors"
)

type FileSystemSourceProvider struct {
	path     string
	excludes map[string]os.FileInfo
}

var ErrNotSupportedFile = errors.New("invalid file format")

func NewFileSystemSourceProvider(path string, excludes []string) (*FileSystemSourceProvider, error) {
	ex := make(map[string]os.FileInfo, len(excludes))
	for _, exclude := range excludes {
		info, err := os.Stat(exclude)
		if err != nil {
			if os.IsNotExist(err) {
				continue
			}

			return nil, errors.Wrap(err, "failed to open excluded file")
		}
		ex[info.Name()] = info
	}

	return &FileSystemSourceProvider{
		path:     path,
		excludes: ex,
	}, nil
}

func (s *FileSystemSourceProvider) GetSources(ctx context.Context, _ string, extensions model.Extensions, sink Sink) error {
	fileInfo, err := os.Stat(s.path)
	if err != nil {
		return errors.Wrap(err, "failed to open path")
	}

	if !fileInfo.IsDir() {
		if !extensions.Include(filepath.Ext(s.path)) {
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

		if info.IsDir() {
			return nil
		}

		if f, ok := s.excludes[info.Name()]; ok && os.SameFile(f, info) {
			return nil
		}

		if !extensions.Include(filepath.Ext(path)) {
			return nil
		}

		c, err := os.Open(path)
		if err != nil {
			return errors.Wrap(err, "failed to open file")
		}

		err = sink(ctx, strings.ReplaceAll(path, "\\", "/"), c)
		if err != nil {
			logger.GetLoggerWithFieldsFromContext(ctx).
				Err(err).
				Msgf("Filesystem terraform files provider couldn't parse file, file=%s", info.Name())
		}

		return nil
	})

	return errors.Wrap(err, "failed to walk directory")
}
