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
)

// SourceProvider is the interface that wraps the basic GetSources method.
// GetSources receives context, receive ID, extensions supported and a sink function to save sources
type SourceProvider interface {
	GetSources(ctx context.Context, scanID string, extensions model.Extensions, sink source.Sink) error
}

// Storage is the interface that wraps following basic methods: SaveFile, SaveVulnerability, GetVulnerability and GetScanSummary
// SaveFile should append metadata to a file
// SaveVulnerabilities should append vulnerabilities list to current storage
// GetVulnerabilities should returns all vulnerabilities associated to a scan ID
// GetScanSummary should return a list of summaries based on their scan IDs
type Storage interface {
	SaveFile(ctx context.Context, metadata *model.FileMetadata) error
	SaveVulnerabilities(ctx context.Context, vulnerabilities []model.Vulnerability) error
	GetVulnerabilities(ctx context.Context, scanID string) ([]model.Vulnerability, error)
	GetScanSummary(ctx context.Context, scanIDs []string) ([]model.SeveritySummary, error)
}

// Tracker is the interface that wraps the basic methods: TrackFileFound and TrackFileParse
// TrackFileFound should increment the number of files to be scanned
// TrackFileParse should increment the number of files parsed successfully to be scanned
type Tracker interface {
	TrackFileFound()
	TrackFileParse()
}

// Service is a struct that contains a SourceProvider to receive sources, a storage to save and retrieve scanning informations
// a parser to parse and provide files in format that KICS understand, a inspector that runs the scanning and a tracker to
// update scanning numbers
type Service struct {
	SourceProvider SourceProvider
	Storage        Storage
	Parser         *parser.Parser
	Inspector      *engine.Inspector
	Tracker        Tracker
}

// StartScan executes scan over the context, using the scanID as reference
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

			for _, document := range documents {
				_, err = json.Marshal(document)
				if err != nil {
					sentry.CaptureException(err)
					log.Err(err).Msgf("failed to marshal content in file: %s", filename)
					continue
				}

				file := model.FileMetadata{
					ID:           uuid.New().String(),
					ScanID:       scanID,
					Document:     document,
					OriginalData: string(content),
					Kind:         kind,
					FileName:     filename,
				}
				files = s.saveToFile(ctx, &file, files)
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

// GetVulnerabilities returns a list of scan detected vulnerabilities
func (s *Service) GetVulnerabilities(ctx context.Context, scanID string) ([]model.Vulnerability, error) {
	return s.Storage.GetVulnerabilities(ctx, scanID)
}

// GetScanSummary returns how many vulnerabilities of each severity was found
func (s *Service) GetScanSummary(ctx context.Context, scanIDs []string) ([]model.SeveritySummary, error) {
	return s.Storage.GetScanSummary(ctx, scanIDs)
}

func (s *Service) saveToFile(ctx context.Context, file *model.FileMetadata, files model.FileMetadatas) model.FileMetadatas {
	err := s.Storage.SaveFile(ctx, file)
	if err == nil {
		files = append(files, *file)
		s.Tracker.TrackFileParse()
	}
	return files
}
