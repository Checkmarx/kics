package kics

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"regexp"
	"sort"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"

	sentryReport "github.com/Checkmarx/kics/v2/internal/sentry"
	"github.com/Checkmarx/kics/v2/pkg/minified"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/utils"
)

func (s *Service) resolverSink(
	ctx context.Context,
	filename, scanID string,
	openAPIResolveReferences bool,
	maxResolverDepth int) ([]string, error) {
	kind := s.Resolver.GetType(filename)
	if kind == model.KindCOMMON {
		return []string{}, nil
	}
	resFiles, err := s.Resolver.Resolve(filename, kind)
	if err != nil {
		log.Err(err).Msgf("failed to render file content")
		return []string{}, err
	}

	for _, rFile := range resFiles.File {
		s.Tracker.TrackFileFound(rFile.FileName)

		isMinified := minified.IsMinified(rFile.FileName, rFile.Content)
		documents, err := s.Parser.Parse(rFile.FileName, rFile.Content, openAPIResolveReferences, isMinified, maxResolverDepth)
		if err != nil {
			if documents.Kind == "break" {
				return []string{}, nil
			}
			log.Err(err).Msgf("failed to parse file content")
			return []string{}, nil
		}

		if kind == model.KindHELM {
			ignoreList, errorIL := s.getOriginalIgnoreLines(
				rFile.FileName, rFile.OriginalData,
				openAPIResolveReferences, isMinified, maxResolverDepth)
			if errorIL == nil {
				documents.IgnoreLines = ignoreList

				// Need to ignore #KICS_HELM_ID Line
				documents.CountLines = bytes.Count(rFile.OriginalData, []byte{'\n'})
			}
		} else {
			documents.CountLines = bytes.Count(rFile.OriginalData, []byte{'\n'}) + 1
		}

		fileCommands := s.Parser.CommentsCommands(rFile.FileName, rFile.OriginalData)

		for _, document := range documents.Docs {
			_, err = json.Marshal(document)
			if err != nil {
				sentryReport.ReportSentry(&sentryReport.Report{
					Message:  fmt.Sprintf("failed to marshal content in file: %s", rFile.FileName),
					Err:      err,
					Location: "func resolverSink()",
					FileName: rFile.FileName,
					Kind:     kind,
				}, true)
				continue
			}

			if len(documents.IgnoreLines) > 0 {
				sort.Ints(documents.IgnoreLines)
			}

			file := model.FileMetadata{
				ID:                uuid.New().String(),
				ScanID:            scanID,
				Document:          PrepareScanDocument(document, kind),
				OriginalData:      string(rFile.OriginalData),
				LineInfoDocument:  document,
				Kind:              kind,
				FilePath:          rFile.FileName,
				Content:           string(rFile.Content),
				HelmID:            rFile.SplitID,
				Commands:          fileCommands,
				IDInfo:            rFile.IDInfo,
				LinesIgnore:       documents.IgnoreLines,
				ResolvedFiles:     documents.ResolvedFiles,
				LinesOriginalData: utils.SplitLines(string(rFile.OriginalData)),
				IsMinified:        documents.IsMinified,
				ContextSelector:   rFile.ContextSelector,
			}
			s.saveToFile(ctx, &file)
		}
		s.Tracker.TrackFileParse(rFile.FileName)
		s.Tracker.TrackFileFoundCountLines(documents.CountLines)
		s.Tracker.TrackFileParseCountLines(documents.CountLines - len(documents.IgnoreLines))
		s.Tracker.TrackFileIgnoreCountLines(len(documents.IgnoreLines))
	}
	return resFiles.Excluded, nil
}

func (s *Service) getOriginalIgnoreLines(filename string,
	originalFile []uint8,
	openAPIResolveReferences, isMinified bool,
	maxResolverDepth int) (ignoreLines []int, err error) {
	refactor := regexp.MustCompile(`.*\n?.*KICS_HELM_ID.+\n`).ReplaceAll(originalFile, []uint8{})
	refactor = regexp.MustCompile(`{{-\s*(.*?)\s*}}`).ReplaceAll(refactor, []uint8{})

	documentsOriginal, err := s.Parser.Parse(filename, refactor, openAPIResolveReferences, isMinified, maxResolverDepth)
	if err == nil {
		ignoreLines = documentsOriginal.IgnoreLines
	}
	return
}
