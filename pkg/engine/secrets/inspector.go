package secrets

import (
	"context"
	"fmt"
	"path/filepath"

	"github.com/Checkmarx/kics/pkg/detector"
	"github.com/Checkmarx/kics/pkg/detector/docker"
	"github.com/Checkmarx/kics/pkg/detector/helm"
	engine "github.com/Checkmarx/kics/pkg/engine"
	"github.com/Checkmarx/kics/pkg/engine/similarity"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/rs/zerolog/log"
)

const (
	defaultLineNumber = 0
)

var (
	queryMetadata = map[string]string{
		"id":              "f996f3cb-00fc-480c-8973-8ab04d44a8cc",
		"queryName":       "Passwords And Secrets",
		"severity":        "HIGH",
		"category":        "Secret Management",
		"descriptionText": "Query to find passwords and secrets in infrastructure code.",
		"descriptionUrl":  "https://kics.io/",
		"platform":        "Common",
		"descriptionID":   "d69d8a89",
		"cloudProvider":   "common",
	}
)

type Inspector struct {
	ctx            context.Context
	tracker        engine.Tracker
	detector       *detector.DetectLine
	excludeResults map[string]bool
}

func NewInspector(
	ctx context.Context,
	excludeResults map[string]bool,
	tracker engine.Tracker,
) (*Inspector, error) {
	lineDetector := detector.NewDetectLine(tracker.GetOutputLines()).
		Add(helm.DetectKindLine{}, model.KindHELM).
		Add(docker.DetectKindLine{}, model.KindDOCKER)

	return &Inspector{
		ctx:            ctx,
		detector:       lineDetector,
		excludeResults: excludeResults,
		tracker:        tracker,
	}, nil
}

func secretsVulnerability(fileMetadata model.FileMetadata, basePaths []string, lineNumber int, simID *string) model.Vulnerability {
	return model.Vulnerability{
		QueryID:       queryMetadata["id"],
		SimilarityID:  *simID,
		FileID:        fileMetadata.ID,
		FileName:      fileMetadata.FilePath,
		Line:          lineNumber,
		IssueType:     "IncorrectValue",
		Platform:      string(model.KindCOMMON),
		Severity:      model.SeverityHigh,
		QueryURI:      queryMetadata["descriptionUrl"],
		Category:      queryMetadata["category"],
		Description:   queryMetadata["descriptionText"],
		DescriptionID: queryMetadata["descriptionID"],
	}
}

func (c *Inspector) Inspect(ctx context.Context, basePaths []string, files model.FileMetadatas) ([]model.Vulnerability, error) {
	vulnerabilities := make([]model.Vulnerability, 0)
	for idx := range files {
		log.Info().Msg(files[idx].FilePath)

		if checkSecretsInPathOrFileName(files[idx].FilePath) {
			vulnerabilities = c.secretFound(vulnerabilities, basePaths, files[idx], defaultLineNumber)
		}

		if checkSecretsInPathOrFileName(filepath.Base(files[idx].FilePath)) {
			vulnerabilities = c.secretFound(vulnerabilities, basePaths, files[idx], defaultLineNumber)
		}

		lines := c.detector.SplitLines(&files[idx])
		for lineNumber, line := range lines {
			if matches := checkSecrets(line); len(matches) > 0 {
				vulnerabilities = c.secretFound(vulnerabilities, basePaths, files[idx], lineNumber)
			}
		}
	}
	return vulnerabilities, nil
}

func (c *Inspector) secretFound(vulnerabilities []model.Vulnerability, basePaths []string, fileMetadata model.FileMetadata, lineNumber int) []model.Vulnerability {
	log.Info().Msg("found secrets")
	simID, err := similarity.ComputeSimilarityID(basePaths, fileMetadata.FilePath, queryMetadata["id"], fmt.Sprintf("%d", lineNumber), "")
	if err != nil {
		log.Error().Msg("unable to compute similarity ID")
	}
	if !c.excludeResults[*simID] {
		vulnerabilities = append(vulnerabilities, secretsVulnerability(fileMetadata, basePaths, defaultLineNumber, simID))
	}
	return vulnerabilities
}

func checkSecretsInPathOrFileName(filePath string) bool {
	ruleMatches := checkSecrets(filePath)
	return len(ruleMatches) > 0
}

func checkSecrets(input string) []RuleMatch {
	ruleMatches := ApplyAllRegexRules(input)
	if len(ruleMatches) == 0 {
		ruleMatches = GetHighEntropyTokens(input)
	}
	return ruleMatches
}
