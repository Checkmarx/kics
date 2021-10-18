package kics

import (
	"context"
	"encoding/json"
	"fmt"

	sentry_report "github.com/Checkmarx/kics/internal/sentry"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/google/uuid"
	"github.com/rs/zerolog/log"
)

func (s *Service) resolverSink(ctx context.Context, filename, scanID string) ([]string, error) {
	kind := s.Resolver.GetType(filename)
	if kind == model.KindCOMMON {
		return []string{}, nil
	}
	resFiles, err := s.Resolver.Resolve(filename, kind)
	if err != nil {
		log.Err(err).Msgf("failed to render file content")
		return []string{}, nil
	}

	for _, rfile := range resFiles.File {
		s.Tracker.TrackFileFound()
		documents, retParse, err := s.Parser.Parse(rfile.FileName, rfile.Content)
		if err != nil {
			if retParse == "break" {
				return []string{}, nil
			}
			log.Err(err).Msgf("failed to parse file content")
			return []string{}, nil
		}
		for _, document := range documents {
			_, err = json.Marshal(document)
			if err != nil {
				sentry_report.ReportSentry(&sentry_report.Report{
					Message:  fmt.Sprintf("failed to marshal content in file: %s", rfile.FileName),
					Err:      err,
					Location: "func resolverSink()",
					FileName: rfile.FileName,
					Kind:     kind,
				}, true)
				continue
			}

			file := model.FileMetadata{
				ID:               uuid.New().String(),
				ScanID:           scanID,
				Document:         PrepareScanDocument(document, kind),
				OriginalData:     string(rfile.OriginalData),
				LineInfoDocument: document,
				Kind:             kind,
				FilePath:         rfile.FileName,
				Content:          string(rfile.Content),
				HelmID:           rfile.SplitID,
				IDInfo:           rfile.IDInfo,
			}
			s.saveToFile(ctx, &file)
		}
		s.Tracker.TrackFileParse()
	}
	return resFiles.Excluded, nil
}
