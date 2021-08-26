package detector

import (
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/rs/zerolog"
)

type kindDetectLine interface {
	DetectLine(file *model.FileMetadata, searchKey string,
		logWithFields *zerolog.Logger, outputLines int) model.VulnerabilityLines
	SplitLines(content string) []string
}

// DetectLine is a struct that associates a kindDetectLine to its FileKind
type DetectLine struct {
	detectors       map[model.FileKind]kindDetectLine
	outputLines     int
	logWithFields   *zerolog.Logger
	defaultDetector kindDetectLine
}

// NewDetectLine creates a new DetectLine's reference
func NewDetectLine(outputLines int) *DetectLine {
	return &DetectLine{
		detectors:       make(map[model.FileKind]kindDetectLine),
		logWithFields:   &zerolog.Logger{},
		outputLines:     outputLines,
		defaultDetector: defaultDetectLine{},
	}
}

// SetupLogs will change the logger feild to be used in kindDetectLine DetectLine method
func (d *DetectLine) SetupLogs(logger *zerolog.Logger) {
	d.logWithFields = logger
}

// Add adds a new kindDetectLine to the caller and returns it
func (d *DetectLine) Add(detector kindDetectLine, kind model.FileKind) *DetectLine {
	d.detectors[kind] = detector
	return d
}

// DetectLine will use the correct kindDetectLine according to the files kind
// if file kind is not in detectors default detect line is called
func (d *DetectLine) DetectLine(file *model.FileMetadata, searchKey string) model.VulnerabilityLines {
	if det, ok := d.detectors[file.Kind]; ok {
		return det.DetectLine(file, searchKey, d.logWithFields, d.outputLines)
	}
	return d.defaultDetector.DetectLine(file, searchKey, d.logWithFields, d.outputLines)
}

// GetAdjecent finds and returns the lines adjecent to the line containing the vulnerability
func (d *DetectLine) GetAdjecent(file *model.FileMetadata, line int) model.VulnerabilityLines {
	if det, ok := d.detectors[file.Kind]; ok {
		return model.VulnerabilityLines{
			Line:      line,
			VulnLines: GetAdjacentVulnLines(line-1, d.outputLines, det.SplitLines(file.OriginalData)),
		}
	}
	return model.VulnerabilityLines{
		Line:      line,
		VulnLines: GetAdjacentVulnLines(line-1, d.outputLines, d.defaultDetector.SplitLines(file.OriginalData)),
	}
}

// SplitLines splits lines splits the file by lines based on the type of file
func (d *DetectLine) SplitLines(file *model.FileMetadata) []string {
	if det, ok := d.detectors[file.Kind]; ok {
		return det.SplitLines(file.OriginalData)
	}
	return d.defaultDetector.SplitLines(file.OriginalData)
}
