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

		if s.checkConditions(info, extensions, path) {
			return nil
		}

		c, err := os.Open(path)
		if err != nil {
			return errors.Wrap(err, "failed to open file")
		}

		err = sink(ctx, strings.ReplaceAll(path, "\\", "/"), c)
		if err != nil {
			sentry.CaptureException(err)
			log.Err(err).
				Msgf("Filesystem terraform files provider couldn't parse file, file=%s", info.Name())
		}
		c.Close()
		return nil
	})

	return errors.Wrap(err, "failed to walk directory")
}

func (s *FileSystemSourceProvider) checkConditions(info os.FileInfo, extensions model.Extensions, path string) bool {
	if info.IsDir() {
		return true
	}
	if f, ok := s.excludes[info.Name()]; ok && os.SameFile(f, info) {
		return true
	}
	if !extensions.Include(filepath.Ext(path)) && !extensions.Include(filepath.Base(path)) {
		return true
	}
	return false
}
