package kics

import (
	"context"
	"encoding/json"
	"io"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/getsentry/sentry-go"
	"github.com/google/uuid"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

func (s *Service) sink(ctx context.Context, filename, scanID string, rc io.Reader) error {
	s.Tracker.TrackFileFound()

	content, err := getContent(rc)
	if err != nil {
		return errors.Wrapf(err, "failed to get file content: %s", filename)
	}

	documents, kind, err := s.Parser.Parse(filename, *content)
	if err != nil {
		log.Err(err).Msgf("failed to parse file content: %s", filename)
		return nil
	}

	fileCommands := s.Parser.CommentsCommands(filename, *content)

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
			OriginalData: string(*content),
			Kind:         kind,
			FilePath:     filename,
			Commands:     fileCommands,
		}
		s.saveToFile(ctx, &file)
	}
	s.Tracker.TrackFileParse()

	return errors.Wrap(err, "failed to save file content")
}
