package ice

import (
	"context"
	"hash/fnv"
	"io"
	"io/ioutil"

	"github.com/checkmarxDev/ice/pkg/engine"
	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/pkg/parser"
	"github.com/checkmarxDev/ice/pkg/source"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

type SourceProvider interface {
	GetSources(ctx context.Context, scanID string, sink source.Sink) error
}

type Storage interface {
	SaveFile(ctx context.Context, metadata *model.FileMetadata) error
	GetResults(ctx context.Context, scanID string) ([]model.ResultItem, error)
}

type Service struct {
	SourceProvider SourceProvider
	Storage        Storage
	Parser         *parser.TerraformParser
	Inspector      *engine.Inspector
}

func (s *Service) StartScan(ctx context.Context, scanID string) error {
	if err := s.SourceProvider.GetSources(ctx, scanID, func(ctx context.Context, filename string, rc io.ReadCloser) error {
		content, err := ioutil.ReadAll(rc)
		if err != nil {
			return errors.Wrap(err, "failed to read file content")
		}

		jsonContent, err := s.Parser.Parse(filename, content)
		if err != nil {
			return errors.Wrap(err, "failed to parse file content")
		}

		err = s.Storage.SaveFile(ctx, &model.FileMetadata{
			ScanID:       scanID,
			JSONData:     jsonContent,
			OriginalData: string(content),
			Kind:         model.KindTerraform,
			FileName:     filename,
			JSONHash:     hash(jsonContent),
		})

		return errors.Wrap(err, "failed to save file content")
	}); err != nil {
		return errors.Wrap(err, "failed to read sources")
	}

	err := s.Inspector.Inspect(ctx, scanID)

	return errors.Wrap(err, "failed to read sources")
}

func (s *Service) GetResults(ctx context.Context, scanID string) ([]model.ResultItem, error) {
	return s.Storage.GetResults(ctx, scanID)
}

func hash(s string) uint32 {
	h := fnv.New32a()
	if _, err := h.Write([]byte(s)); err != nil {
		log.Err(err).Msgf("failed to create file hash")
	}
	return h.Sum32()
}
