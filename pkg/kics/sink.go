package kics

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"sort"

	sentryReport "github.com/Checkmarx/kics/internal/sentry"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/parser/jsonfilter/parser"
	"github.com/antlr/antlr4/runtime/Go/antlr"
	"github.com/google/uuid"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

var (
	lines = map[model.FileKind][]string{
		"TF":   {"pattern"},
		"JSON": {"FilterPattern"},
		"YAML": {"filter_pattern", "FilterPattern"},
	}
)

func (s *Service) sink(ctx context.Context, filename, scanID string, rc io.Reader) error {
	s.Tracker.TrackFileFound()
	log.Debug().Msgf("Starting to process file %s", filename)

	c, err := getContent(rc)

	content := c.Content

	s.Tracker.TrackFileFoundCountLines(c.CountLines)

	if err != nil {
		return errors.Wrapf(err, "failed to get file content: %s", filename)
	}

	documents, err := s.Parser.Parse(filename, *content)
	if err != nil {
		log.Err(err).Msgf("failed to parse file content: %s", filename)
		return nil
	}

	fileCommands := s.Parser.CommentsCommands(filename, *content)

	for _, document := range documents.Docs {
		_, err = json.Marshal(document)
		if err != nil {
			sentryReport.ReportSentry(&sentryReport.Report{
				Message:  fmt.Sprintf("failed to marshal content in file: %s", filename),
				Err:      err,
				Location: "func sink()",
				FileName: filename,
				Kind:     documents.Kind,
			}, true)
			continue
		}

		if len(documents.IgnoreLines) > 0 {
			sort.Ints(documents.IgnoreLines)
		}

		file := model.FileMetadata{
			ID:               uuid.New().String(),
			ScanID:           scanID,
			Document:         PrepareScanDocument(document, documents.Kind),
			LineInfoDocument: document,
			OriginalData:     documents.Content,
			Kind:             documents.Kind,
			FilePath:         filename,
			Commands:         fileCommands,
			LinesIgnore:      documents.IgnoreLines,
		}
		s.saveToFile(ctx, &file)
	}
	s.Tracker.TrackFileParse()
	log.Debug().Msgf("Finished to process file %s", filename)
	s.Tracker.TrackFileParseCountLines(documents.CountLines)

	return errors.Wrap(err, "failed to save file content")
}

func resolveJSONFilter(jsonFilter string) string {
	is := antlr.NewInputStream(jsonFilter)

	// lexer build
	lexer := parser.NewJSONFilterLexer(is)
	lexer.RemoveErrorListeners()
	stream := antlr.NewCommonTokenStream(lexer, antlr.TokenDefaultChannel)
	errorListener := parser.NewCustomErrorListener()
	lexer.RemoveErrorListeners()
	lexer.AddErrorListener(errorListener)

	// parser build
	p := parser.NewJSONFilterParser(stream)
	p.RemoveErrorListeners()
	p.AddErrorListener(errorListener)
	p.BuildParseTrees = true
	tree := p.Awsjsonfilter()

	// parse
	visitor := parser.NewJSONFilterPrinterVisitor()
	if errorListener.HasErrors() {
		return jsonFilter
	}

	parsed := visitor.VisitAll(tree)

	parsedByte, err := json.Marshal(parsed)
	if err != nil {
		return jsonFilter
	}

	return string(parsedByte)
}
