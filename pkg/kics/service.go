package kics

import (
	"context"
	"encoding/json"
	"io"
	"io/ioutil"

	"github.com/Checkmarx/kics/pkg/engine"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/parser"
	"github.com/Checkmarx/kics/pkg/source"
	"github.com/getsentry/sentry-go"
	"github.com/google/uuid"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
	"golang.org/x/sync/semaphore"
)

type SourceProvider interface {
	GetSources(ctx context.Context, scanID string, extensions model.Extensions, sink source.Sink) error
}

type Storage interface {
	SaveFile(ctx context.Context, metadata *model.FileMetadata) error
	SaveVulnerabilities(ctx context.Context, vulnerabilities []model.Vulnerability) error
	GetVulnerabilities(ctx context.Context, scanID string) ([]model.Vulnerability, error)
	GetScanSummary(ctx context.Context, scanIDs []string) ([]model.SeveritySummary, error)
}

type Tracker interface {
	TrackFileFound()
	TrackFileParse()
}

type Service struct {
	SourceProvider SourceProvider
	Storage        Storage
	Parser         *parser.Parser
	Inspector      *engine.Inspector
	Tracker        Tracker
}

func (s *Service) StartScan(ctx context.Context, scanID string) error {
	var files model.FileMetadatas
	if err := s.SourceProvider.GetSources(
		ctx,
		scanID,
		s.Parser.SupportedExtensions(),
		func(ctx context.Context, filename string, rc io.ReadCloser) error {
			s.Tracker.TrackFileFound()

			content, err := ioutil.ReadAll(rc)
			if err != nil {
				return errors.Wrap(err, "failed to read file content")
			}

			documents, kind, err := s.Parser.Parse(filename, content)
			if err != nil {
				return errors.Wrap(err, "failed to parse file content")
			}

			var sem = semaphore.NewWeighted(int64(10))
			ctx2 := context.Background()
			for _, document := range documents { // Here is the problem
				if err := sem.Acquire(ctx2, 1); err != nil {
					// handle error and maybe break
				}
				go func() {
					_, err = json.Marshal(document)
					if err != nil {
						sentry.CaptureException(err)
						log.Err(err).Msgf("failed to marshal content in file: %s", filename)
					}
					file := model.FileMetadata{
						ID:           uuid.New().String(),
						ScanID:       scanID,
						Document:     document,
						OriginalData: string(content),
						Kind:         kind,
						FileName:     filename,
					}

					err = s.Storage.SaveFile(ctx, &file)
					if err == nil {
						files = append(files, file)
						s.Tracker.TrackFileParse()
					}
					sem.Release(1)
				}()
			}

			return errors.Wrap(err, "failed to save file content")
		},
	); err != nil {
		return errors.Wrap(err, "failed to read sources")
	}

	vulnerabilities, err := s.Inspector.Inspect(ctx, scanID, files)
	if err != nil {
		return errors.Wrap(err, "failed to inspect files")
	}

	err = s.Storage.SaveVulnerabilities(ctx, vulnerabilities)

	return errors.Wrap(err, "failed to save vulnerabilities")
}

func (s *Service) GetVulnerabilities(ctx context.Context, scanID string) ([]model.Vulnerability, error) {
	return s.Storage.GetVulnerabilities(ctx, scanID)
}

func (s *Service) GetScanSummary(ctx context.Context, scanIDs []string) ([]model.SeveritySummary, error) {
	return s.Storage.GetScanSummary(ctx, scanIDs)
}
