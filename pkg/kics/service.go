package kics

import (
	"context"
	"io"
	"sync"

	"github.com/Checkmarx/kics/pkg/engine"
	"github.com/Checkmarx/kics/pkg/engine/provider"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/parser"
	"github.com/Checkmarx/kics/pkg/resolver"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

const (
	mbConst = 1048576
)

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
	SourceProvider provider.SourceProvider
	Storage        Storage
	Parser         *parser.Parser
	Inspector      *engine.Inspector
	Tracker        Tracker
	Resolver       *resolver.Resolver
	files          model.FileMetadatas
}

// StartScan executes scan over the context, using the scanID as reference
func (s *Service) StartScan(
	ctx context.Context,
	scanID string,
	errCh chan<- error,
	wg *sync.WaitGroup,
	currentQuery chan<- int64) {
	log.Debug().Msg("service.StartScan()")
	defer wg.Done()
	if err := s.SourceProvider.GetSources(
		ctx,
		s.Parser.SupportedExtensions(),
		func(ctx context.Context, filename string, rc io.ReadCloser) error {
			return s.sink(ctx, filename, scanID, rc)
		},
		func(ctx context.Context, filename string) ([]string, error) { // Sink used for resolver files and templates
			return s.resolverSink(ctx, filename, scanID)
		},
	); err != nil {
		errCh <- errors.Wrap(err, "failed to read sources")
	}
	vulnerabilities, err := s.Inspector.Inspect(
		ctx,
		scanID,
		s.files,
		s.SourceProvider.GetBasePaths(),
		s.Parser.Platform,
		currentQuery,
	)
	if err != nil {
		errCh <- errors.Wrap(err, "failed to inspect files")
	}
	err = s.Storage.SaveVulnerabilities(ctx, vulnerabilities)
	if err != nil {
		errCh <- errors.Wrap(err, "failed to save vulnerabilities")
	}
}

/*
   getContent will read the passed file 1MB at a time
   to prevent resource exhaustion and return its content
*/
func getContent(rc io.Reader) (*[]byte, error) {
	maxSizeMB := 5 // Max size of file in MBs
	var content []byte
	data := make([]byte, mbConst)
	for {
		if maxSizeMB < 0 {
			return &[]byte{}, errors.New("file size limit exceeded")
		}
		data = data[:cap(data)]
		n, err := rc.Read(data)
		if err != nil {
			if err == io.EOF {
				break
			}
			return &[]byte{}, err
		}
		content = append(content, data[:n]...)
		maxSizeMB--
	}
	return &content, nil
}

// GetVulnerabilities returns a list of scan detected vulnerabilities
func (s *Service) GetVulnerabilities(ctx context.Context, scanID string) ([]model.Vulnerability, error) {
	return s.Storage.GetVulnerabilities(ctx, scanID)
}

// GetScanSummary returns how many vulnerabilities of each severity was found
func (s *Service) GetScanSummary(ctx context.Context, scanIDs []string) ([]model.SeveritySummary, error) {
	return s.Storage.GetScanSummary(ctx, scanIDs)
}

func (s *Service) saveToFile(ctx context.Context, file *model.FileMetadata) {
	err := s.Storage.SaveFile(ctx, file)
	if err == nil {
		s.files = append(s.files, *file)
	}
}
