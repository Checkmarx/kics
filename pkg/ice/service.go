package ice

import (
	"context"
	"hash/fnv"
	"io"
	"io/ioutil"

	"github.com/checkmarxDev/ice/internal/logger"
	"github.com/checkmarxDev/ice/pkg/engine"
	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/pkg/parser"
	"github.com/checkmarxDev/ice/pkg/source"
	"github.com/pkg/errors"
)

type SourceProvider interface {
	GetSources(ctx context.Context, scanID string, sink source.Sink) error
}

type Storage interface {
	SaveFile(ctx context.Context, metadata *model.FileMetadata) error
	GetResults(ctx context.Context, scanID string) ([]model.Vulnerability, error)
	GetScanSummary(ctx context.Context, scanIDs []string) ([]model.SeveritySummary, error)
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
			JSONHash:     hash(ctx, filename, jsonContent),
		})

		return errors.Wrap(err, "failed to save file content")
	}); err != nil {
		return errors.Wrap(err, "failed to read sources")
	}

	err := s.Inspector.Inspect(ctx, scanID)

	return errors.Wrap(err, "failed to read sources")
}

func (s *Service) GetResults(ctx context.Context, scanID string) ([]model.Vulnerability, error) {
	return s.Storage.GetResults(ctx, scanID)
}

func (s *Service) GetScanSummary(ctx context.Context, scanIDs []string) ([]model.SeveritySummary, error) {
	return s.Storage.GetScanSummary(ctx, scanIDs)
}

func hash(ctx context.Context, filename, content string) uint32 {
	h := fnv.New32a()
	if _, err := h.Write([]byte(content)); err != nil {
		logger.GetLoggerWithFieldsFromContext(ctx).
			Err(err).
			Str("fileName", filename).
			Msgf("saving file. failed to create file hash")
	}
	return h.Sum32()
}
