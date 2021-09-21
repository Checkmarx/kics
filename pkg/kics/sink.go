package kics

import (
	"context"
	"encoding/json"
	"io"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/parser/jsonfilter/parser"
	"github.com/antlr/antlr4/runtime/Go/antlr"
	"github.com/getsentry/sentry-go"
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
			ID:               uuid.New().String(),
			ScanID:           scanID,
			Document:         PrepareScanDocument(document, kind),
			LineInfoDocument: document,
			OriginalData:     string(*content),
			Kind:             kind,
			FilePath:         filename,
			Commands:         fileCommands,
		}
		s.saveToFile(ctx, &file)
	}
	s.Tracker.TrackFileParse()

	return errors.Wrap(err, "failed to save file content")
}

// PrepareScanDocument removes _kics_lines from payload and parses json filters
func PrepareScanDocument(body map[string]interface{}, kind model.FileKind) map[string]interface{} {
	bodyMap := make(map[string]interface{})
	j, err := json.Marshal(body)
	if err != nil {
		log.Error().Msgf("failed to remove kics line information")
		return body
	}
	if err := json.Unmarshal(j, &bodyMap); err != nil {
		log.Error().Msgf("failed to remove kics line information")
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
			if field, ok := lines[kind]; ok && contains(field, key) {
				bodyType[key] = resolveJSONFilter(value)
			}
		}
	}
}

func contains(strSlice []string, key string) bool {
	for _, v := range strSlice {
		if v == key {
			return true
		}
	}
	return false
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
