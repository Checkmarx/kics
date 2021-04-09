package kics

import (
	"context"
	"encoding/json"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/getsentry/sentry-go"
	"github.com/google/uuid"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

func (s *Service) resolverSink(ctx context.Context, filename, scanID string) ([]string, error) {
	kind := s.Resolver.GetType(filename)
	if kind == model.KindCOMMON {
		return []string{}, nil
	}
	resFiles, err := s.Resolver.Resolve(filename, kind)
	if err != nil {
		return []string{}, errors.Wrap(err, "failed to render file content")
	}

	excluded := make([]string, len(resFiles.File))

	for idx, rfile := range resFiles.File {
		s.Tracker.TrackFileFound()
		excluded[idx] = rfile.FileName
		documents, _, err := s.Parser.Parse(rfile.FileName, rfile.Content)
		if err != nil {
			return []string{}, errors.Wrap(err, "failed to parse file content")
		}
		for _, document := range documents {
			_, err = json.Marshal(document)
			if err != nil {
				sentry.CaptureException(err)
				log.Err(err).Msgf("failed to marshal content in file: %s", rfile.FileName)
				continue
			}

			file := model.FileMetadata{
				ID:           uuid.New().String(),
				ScanID:       scanID,
				Document:     document,
				OriginalData: string(rfile.OriginalData),
				Kind:         kind,
				FileName:     rfile.FileName,
				Content:      string(rfile.Content),
				HelmID:       rfile.SplitID,
				IDInfo:       rfile.IDInfo,
			}
			s.saveToFile(ctx, &file)
		}
		s.Tracker.TrackFileParse()
	}
	return excluded, nil
}
