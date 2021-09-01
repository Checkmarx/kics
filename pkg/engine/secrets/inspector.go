package secrets

import (
	"context"
	_ "embed"
	"encoding/json"
	"fmt"
	"math"
	"regexp"
	"strings"

	"github.com/Checkmarx/kics/pkg/detector"
	"github.com/Checkmarx/kics/pkg/detector/docker"
	"github.com/Checkmarx/kics/pkg/detector/helm"
	engine "github.com/Checkmarx/kics/pkg/engine"
	"github.com/Checkmarx/kics/pkg/engine/similarity"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/rs/zerolog/log"
)

const (
	defaultLineNumber         = 0
	EntropyRuleName           = "High Entropy Token"
	Base64EntropyThreashold   = 4.7
	HexCharsEntropyThreashold = 2.7
	MinStringLen              = 20
	Base64Type                = "base64"
	Base64Chars               = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
	HexType                   = "hex"
	HexChars                  = "1234567890abcdefABCDEF"
)

var (
	defaultSecretMetadata = map[string]string{
		"queryName":       "Passwords And Secrets",
		"severity":        "HIGH",
		"category":        "Secret Management",
		"descriptionText": "Query to find passwords and secrets in infrastructure code.",
		"descriptionUrl":  "https://kics.io/",
		"platform":        "Common",
		"cloudProvider":   "common",
	}
)

//go:embed regex_queries.json
var regexQueriesJSON string

type Inspector struct {
	ctx            context.Context
	tracker        engine.Tracker
	detector       *detector.DetectLine
	excludeResults map[string]bool
	regexQueries   []RegexQuery
}

type RegexQuery struct {
	ID            string `json:"id"`
	DescriptionID string `json:"descriptionID"`
	Name          string `json:"name"`
	RegexStr      string `json:"regex"`
	Regex         *regexp.Regexp
}

type RuleMatch struct {
	File     string
	RuleName string
	Matches  []string
	Line     int
	Entropy  float64
}

func NewInspector(
	ctx context.Context,
	excludeResults map[string]bool,
	tracker engine.Tracker,
) (*Inspector, error) {
	lineDetector := detector.NewDetectLine(tracker.GetOutputLines()).
		Add(helm.DetectKindLine{}, model.KindHELM).
		Add(docker.DetectKindLine{}, model.KindDOCKER)

	var regexQueries []RegexQuery

	err := json.Unmarshal([]byte(regexQueriesJSON), &regexQueries)
	if err != nil {
		return nil, err
	}

	for idx := range regexQueries {
		regexQueries[idx].Regex = regexp.MustCompile(regexQueries[idx].RegexStr)
	}

	return &Inspector{
		ctx:            ctx,
		detector:       lineDetector,
		excludeResults: excludeResults,
		tracker:        tracker,
		regexQueries:   regexQueries,
	}, nil
}

func (c *Inspector) Inspect(ctx context.Context, basePaths []string, files model.FileMetadatas) ([]model.Vulnerability, error) {
	vulnerabilities := make([]model.Vulnerability, 0)
	for _, query := range c.regexQueries {
		for idx := range files {
			// check file content line by line
			lines := c.detector.SplitLines(&files[idx])

			for lineNumber, line := range lines {
				matches := query.Regex.FindAllString(line, -1)
				if len(matches) > 0 {
					simID, err := similarity.ComputeSimilarityID(basePaths, files[idx].FilePath, defaultSecretMetadata["id"], fmt.Sprintf("%d", lineNumber), "")
					if err != nil {
						log.Error().Msg("unable to compute similarity ID")
					}

					if _, ok := c.excludeResults[ptrStringToString(simID)]; !ok {
						linesVuln := model.VulnerabilityLines{
							Line:      -1,
							VulnLines: []model.CodeLine{},
						}
						linesVuln = c.detector.GetAdjecent(&files[idx], lineNumber+1)
						vuln := model.Vulnerability{
							QueryID:       query.ID,
							QueryName:     defaultSecretMetadata["queryName"] + " - " + query.Name,
							SimilarityID:  ptrStringToString(simID),
							FileID:        files[idx].ID,
							FileName:      files[idx].FilePath,
							Line:          linesVuln.Line,
							VulnLines:     linesVuln.VulnLines,
							IssueType:     "RedundantAttribute",
							Platform:      string(model.KindCOMMON),
							Severity:      model.SeverityHigh,
							QueryURI:      defaultSecretMetadata["descriptionUrl"],
							Category:      defaultSecretMetadata["category"],
							Description:   defaultSecretMetadata["descriptionText"],
							DescriptionID: query.DescriptionID,
						}
						vulnerabilities = append(vulnerabilities, vuln)
					}
				}
			}
		}
	}
	return vulnerabilities, nil
}

func ptrStringToString(v *string) string {
	if v == nil {
		return ""
	}
	return *v
}

// calculateEntropy - calculates the entropy of a string based on the Shannon formula
func calculateEntropy(token, charSet string) float64 {
	if token == "" {
		return 0
	}
	charMap := map[rune]float64{}
	for _, char := range token {
		if strings.Contains(charSet, string(char)) {
			charMap[char]++
		}
	}

	var freq float64
	length := float64(len(token))
	for _, count := range charMap {
		freq += count * math.Log2(count)
	}

	return math.Log2(length) - freq/length
}

// getHighEntropyTokens - returns a list of tokens that have a high entropy
func GetHighEntropyTokens(s string) []RuleMatch {
	tokens := tokenizeString(s)
	ruleMatches := make([]RuleMatch, 0)
	for _, token := range tokens {
		if len(token) > MinStringLen {
			base64Entropy := calculateEntropy(token, Base64Chars)
			hexEntropy := calculateEntropy(token, HexChars)
			if base64Entropy > Base64EntropyThreashold || hexEntropy > HexCharsEntropyThreashold {
				highestEntropy := math.Max(base64Entropy, hexEntropy)

				ruleMatches = append(ruleMatches, RuleMatch{
					RuleName: EntropyRuleName,
					Matches:  []string{token},
					Entropy:  highestEntropy,
				})
			}
		}
	}
	return ruleMatches
}

// TokenizeString - returns a list of tokens from a string
func tokenizeString(s string) []string {
	return strings.Fields(s)
}
