package detector

import (
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/rs/zerolog"
)

type kindDetectLine interface {
	DetectLine(file *model.FileMetadata, searchKey string,
		logWithFields *zerolog.Logger, outputLines int) model.VulnerabilityLines
}

type DetectLine struct {
	detectors       map[model.FileKind]kindDetectLine
	outputLines     int
	logWithFields   *zerolog.Logger
	defaultDetector kindDetectLine
}

func NewDetectLine(outputLines int) *DetectLine {
	return &DetectLine{
		detectors:       make(map[model.FileKind]kindDetectLine),
		logWithFields:   &zerolog.Logger{},
		outputLines:     outputLines,
		defaultDetector: defaultDetectLine{},
	}
}

func (d *DetectLine) SetupLogs(logger *zerolog.Logger) {
	d.logWithFields = logger
}

func (d *DetectLine) Add(detector kindDetectLine, kind model.FileKind) *DetectLine {
	d.detectors[kind] = detector
	return d
}

func (d *DetectLine) DetectLine(file *model.FileMetadata, searchKey string) model.VulnerabilityLines {
	if det, ok := d.detectors[file.Kind]; ok {
		return det.DetectLine(file, searchKey, d.logWithFields, d.outputLines)
	}
	return d.defaultDetector.DetectLine(file, searchKey, d.logWithFields, d.outputLines)
}
