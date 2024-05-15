package kics

import (
	"bytes"
	"context"
	"encoding/json"
	"io"
	"sync"

	"github.com/Checkmarx/kics/v2/pkg/engine"
	"github.com/Checkmarx/kics/v2/pkg/engine/provider"
	"github.com/Checkmarx/kics/v2/pkg/engine/secrets"
	"github.com/Checkmarx/kics/v2/pkg/minified"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/parser"
	"github.com/Checkmarx/kics/v2/pkg/resolver"

	"github.com/Checkmarx/kics/v2/pkg/utils"
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
	TrackFileFound(path string)
	TrackFileParse(path string)
	TrackFileFoundCountLines(countLines int)
	TrackFileParseCountLines(countLines int)
	TrackFileIgnoreCountLines(countLines int)
}

// Service is a struct that contains a SourceProvider to receive sources, a storage to save and retrieve scanning informations
// a parser to parse and provide files in format that KICS understand, a inspector that runs the scanning and a tracker to
// update scanning numbers
type Service struct {
	SourceProvider   provider.SourceProvider
	Storage          Storage
	Parser           *parser.Parser
	Inspector        *engine.Inspector
	SecretsInspector *secrets.Inspector
	Tracker          Tracker
	Resolver         *resolver.Resolver
	files            model.FileMetadatas
	MaxFileSize      int
}

// PrepareSources will prepare the sources to be scanned
func (s *Service) PrepareSources(ctx context.Context,
	scanID string,
	openAPIResolveReferences bool,
	maxResolverDepth int,
	wg *sync.WaitGroup, errCh chan<- error) {
	defer wg.Done()
	// CxSAST query under review
	data := make([]byte, mbConst)
	if err := s.SourceProvider.GetSources(
		ctx,
		s.Parser.SupportedExtensions(),
		func(ctx context.Context, filename string, rc io.ReadCloser) error {
			return s.sink(ctx, filename, scanID, rc, data, openAPIResolveReferences, maxResolverDepth)
		},
		func(ctx context.Context, filename string) ([]string, error) { // Sink used for resolver files and templates
			return s.resolverSink(ctx, filename, scanID, openAPIResolveReferences, maxResolverDepth)
		},
	); err != nil {
		errCh <- errors.Wrap(err, "failed to read sources")
	}
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

	secretsVulnerabilities, err := s.SecretsInspector.Inspect(
		ctx,
		s.SourceProvider.GetBasePaths(),
		s.files,
		currentQuery,
	)
	if err != nil {
		errCh <- errors.Wrap(err, "failed to inspect secrets")
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
	vulnerabilities = append(vulnerabilities, secretsVulnerabilities...)

	updateMaskedSecrets(&vulnerabilities, s.SecretsInspector.SecretTracker)

	err = s.Storage.SaveVulnerabilities(ctx, vulnerabilities)
	if err != nil {
		errCh <- errors.Wrap(err, "failed to save vulnerabilities")
	}
}

// Content keeps the content of the file and the number of lines
type Content struct {
	Content    *[]byte
	CountLines int
	IsMinified bool
}

/*
getContent will read the passed file 1MB at a time
to prevent resource exhaustion and return its content
*/
func getContent(rc io.Reader, data []byte, maxSizeMB int, filename string) (*Content, error) {
	var content []byte
	countLines := 0

	c := &Content{
		Content:    &[]byte{},
		CountLines: 0,
	}

	for {
		if maxSizeMB < 0 {
			return c, errors.New("file size limit exceeded")
		}
		data = data[:cap(data)]
		n, err := rc.Read(data)
		if err != nil {
			if err == io.EOF {
				break
			}
			return c, err
		}
		countLines += bytes.Count(data[:n], []byte{'\n'}) + 1
		content = append(content, data[:n]...)
		maxSizeMB--
	}
	c.Content = &content
	c.CountLines = countLines

	c.IsMinified = minified.IsMinified(filename, content)
	return c, nil
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

// PrepareScanDocument removes _kics_lines from payload and parses json filters
func PrepareScanDocument(body map[string]interface{}, kind model.FileKind) map[string]interface{} {
	var bodyMap map[string]interface{}
	j, err := json.Marshal(body)
	if err != nil {
		log.Error().Msgf("failed to remove kics line information")
		return body
	}
	if err := json.Unmarshal(j, &bodyMap); err != nil {
		log.Error().Msgf("failed to remove kics line information: '%s'", err)
		return body
	}
	prepareScanDocumentRoot(bodyMap, kind)
	return bodyMap
}

func prepareScanDocumentRoot(body interface{}, kind model.FileKind) {
	switch bodyType := body.(type) {
	case map[string]interface{}:
		prepareScanDocumentValue(bodyType, kind)
	case []interface{}:
		for _, indx := range bodyType {
			prepareScanDocumentRoot(indx, kind)
		}
	}
}

func prepareScanDocumentValue(bodyType map[string]interface{}, kind model.FileKind) {
	delete(bodyType, "_kics_lines")
	for key, v := range bodyType {
		switch value := v.(type) {
		case map[string]interface{}:
			prepareScanDocumentRoot(value, kind)
		case []interface{}:
			for _, indx := range value {
				prepareScanDocumentRoot(indx, kind)
			}
		case string:
			if field, ok := lines[kind]; ok && utils.Contains(key, field) {
				bodyType[key] = resolveJSONFilter(value)
			}
		}
	}
}

func updateMaskedSecrets(vulnerabilities *[]model.Vulnerability, maskedSecretsTracked []secrets.SecretTracker) {
	for idx := range *vulnerabilities {
		for _, secretT := range maskedSecretsTracked {
			updateMaskedSecretLine(&(*vulnerabilities)[idx], secretT)
		}
	}
}

func updateMaskedSecretLine(vulnerability *model.Vulnerability, secretT secrets.SecretTracker) {
	if vulnerability.FileName == secretT.ResolvedFilePath {
		for vlidx := range *vulnerability.VulnLines {
			if (*vulnerability.VulnLines)[vlidx].Position == secretT.Line {
				(*vulnerability.VulnLines)[vlidx].Line = secretT.MaskedContent
			}
		}
	}
}
