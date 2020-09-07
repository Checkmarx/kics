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
}

type Service struct {
	sourceProvider SourceProvider
	storage        Storage
	parser         *parser.TerraformParser
	inspector      *engine.Inspector
}

func NewService(
	sourceProvider SourceProvider,
	storage Storage,
	terraformParser *parser.TerraformParser,
	inspector *engine.Inspector,
) *Service {
	return &Service{sourceProvider: sourceProvider, storage: storage, parser: terraformParser, inspector: inspector}
}

func (s *Service) StartScan(ctx context.Context, scanID string) error {
	if err := s.sourceProvider.GetSources(ctx, scanID, func(ctx context.Context, filename string, rc io.ReadCloser) error {
		content, err := ioutil.ReadAll(rc)
		if err != nil {
			return errors.Wrap(err, "failed to read file content")
		}

		jsonContent, err := s.parser.Parse(filename, content)
		if err != nil {
			return errors.Wrap(err, "failed to parse file content")
		}

		err = s.storage.SaveFile(ctx, &model.FileMetadata{
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

	err := s.inspector.Inspect(ctx, scanID)

	return errors.Wrap(err, "failed to read sources")
}

func hash(s string) uint32 {
	h := fnv.New32a()
	if _, err := h.Write([]byte(s)); err != nil {
		log.Err(err).Msgf("failed to create file hash")
	}
	return h.Sum32()
}
