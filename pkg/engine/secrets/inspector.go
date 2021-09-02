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
	"github.com/Checkmarx/kics/pkg/engine/source"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/rs/zerolog/log"
)

const (
	defaultLineNumber         = 0
	Base64EntropyThreashold   = 4.7
	HexCharsEntropyThreashold = 2.7
	MinStringLen              = 5
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
		"descriptionID":   "d69d8a89",
		"cloudProvider":   "common",
	}
)

//go:embed regex_queries.json
var regexQueriesJSON string

type Inspector struct {
	ctx             context.Context
	tracker         engine.Tracker
	detector        *detector.DetectLine
	excludeResults  map[string]bool
	regexQueries    []RegexQuery
	vulnerabilities []model.Vulnerability
}

type Entropy struct {
	Group int     `json:"group"`
	Min   float64 `json:"min"`
	Max   float64 `json:"max"`
}

type RegexQuery struct {
	ID             string    `json:"id"`
	Name           string    `json:"name"`
	MultilineRegex bool      `json:"multiline"`
	RegexStr       string    `json:"regex"`
	Entropies      []Entropy `json:"entropies"`
	Regex          *regexp.Regexp
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
	queryFilter *source.QueryInspectorParameters,
) (*Inspector, error) {
	lineDetector := detector.NewDetectLine(tracker.GetOutputLines()).
		Add(helm.DetectKindLine{}, model.KindHELM).
		Add(docker.DetectKindLine{}, model.KindDOCKER)

	regexQueries, err := compileRegexQueries(queryFilter)
	if err != nil {
		return nil, err
	}

	return &Inspector{
		ctx:             ctx,
		detector:        lineDetector,
		excludeResults:  excludeResults,
		tracker:         tracker,
		regexQueries:    regexQueries,
		vulnerabilities: make([]model.Vulnerability, 0),
	}, nil
}

func compileRegexQueries(queryFilter *source.QueryInspectorParameters) ([]RegexQuery, error) {
	var allRegexQueries []RegexQuery
	var regexQueries []RegexQuery

	err := json.Unmarshal([]byte(regexQueriesJSON), &allRegexQueries)
	if err != nil {
		return nil, err
	}

	for _, query := range allRegexQueries {
		if len(queryFilter.IncludeQueries.ByIDs) > 0 {
			if isValueInArray(query.ID, queryFilter.IncludeQueries.ByIDs) {
				regexQueries = append(regexQueries, query)
			}
		} else {
			if isValueInArray(query.ID, queryFilter.ExcludeQueries.ByIDs) {
				log.Debug().
					Msgf("Excluding query ID: %s category: %s severity: %s", query.ID, defaultSecretMetadata["category"], defaultSecretMetadata["severity"])
				continue
			}
			regexQueries = append(regexQueries, query)
		}
	}
	for idx := range regexQueries {
		regexQueries[idx].Regex = regexp.MustCompile(regexQueries[idx].RegexStr)
	}
	return regexQueries, nil
}

func isValueInArray(value string, array []string) bool {
	for i := range array {
		if value == array[i] {
			return true
		}
	}
	return false
}

func (c *Inspector) Inspect(ctx context.Context, basePaths []string, files model.FileMetadatas) ([]model.Vulnerability, error) {
	for _, query := range c.regexQueries {
		for idx := range files {
			// check file content line by line
			if !query.MultilineRegex {
				lines := c.detector.SplitLines(&files[idx])

				for lineNumber, currentLine := range lines {
					c.checkLineByLine(query, basePaths, files[idx], lineNumber, currentLine)
				}
				continue
			}

			// check file content as a whole
			c.checkFileContent(query, basePaths, files[idx])
		}
	}
	return c.vulnerabilities, nil
}

func (c *Inspector) secretsDetectLine(query RegexQuery, file model.FileMetadata) int {
	detectedLineNumber := -1
	contentMatchRemoved := query.Regex.ReplaceAllString(file.OriginalData, "")
	lines := c.detector.SplitLines(&file)

	text := strings.ReplaceAll(contentMatchRemoved, "\r", "")
	contentMatchRemovedLines := strings.Split(text, "\n")
	for i := 0; i < len(lines); i++ {
		if lines[i] != contentMatchRemovedLines[i] {
			detectedLineNumber = i + 1
			break
		}
	}

	return detectedLineNumber
}

func (c *Inspector) checkFileContent(query RegexQuery, basePaths []string, file model.FileMetadata) {
	groups := query.Regex.FindStringSubmatch(file.OriginalData)

	lineNumber := c.secretsDetectLine(query, file)

	if len(query.Entropies) == 0 {
		c.addVulnerability(
			basePaths,
			file,
			query,
			lineNumber,
			groups[0],
		)
	}

	if len(groups) > 0 {
		for _, entropy := range query.Entropies {
			// if matched group does not exist continue
			if len(groups) <= entropy.Group {
				return
			}
			isMatch, entropyFloat := CheckEntropyInterval(
				entropy,
				groups[entropy.Group],
			)
			log.Debug().Msgf("match: %v :: %v", isMatch, fmt.Sprint(entropyFloat))

			if isMatch {
				c.addVulnerability(
					basePaths,
					file,
					query,
					lineNumber,
					groups[entropy.Group],
				)
			}
		}
	}
}

func (c *Inspector) checkLineByLine(query RegexQuery, basePaths []string, file model.FileMetadata, lineNumber int, currentLine string) {
	groups := query.Regex.FindStringSubmatch(currentLine)
	if len(groups) == 0 {
		return
	}

	if len(query.Entropies) == 0 {
		c.addVulnerability(
			basePaths,
			file,
			query,
			lineNumber,
			currentLine,
		)
	}

	for i := range query.Entropies {
		entropy := query.Entropies[i]

		// if matched group does not exist continue
		if len(groups) <= entropy.Group {
			return
		}

		isMatch, entropyFloat := CheckEntropyInterval(
			entropy,
			groups[entropy.Group],
		)
		log.Debug().Msgf("match: %v :: %v", isMatch, fmt.Sprint(entropyFloat))

		if isMatch {
			c.addVulnerability(
				basePaths,
				file,
				query,
				lineNumber,
				groups[entropy.Group],
			)
		}
	}
}

func (c *Inspector) addVulnerability(basePaths []string, file model.FileMetadata, query RegexQuery, lineNumber int, line string) {
	simID, err := similarity.ComputeSimilarityID(
		basePaths,
		file.FilePath,
		query.ID,
		fmt.Sprintf("%d", lineNumber),
		"",
	)
	if err != nil {
		log.Error().Msg("unable to compute similarity ID")
	}

	if _, ok := c.excludeResults[ptrStringToString(simID)]; !ok {
		linesVuln := model.VulnerabilityLines{
			Line:      -1,
			VulnLines: []model.CodeLine{},
		}
		linesVuln = c.detector.GetAdjecent(&file, lineNumber+1)
		vuln := model.Vulnerability{
			QueryID:       query.ID,
			QueryName:     defaultSecretMetadata["queryName"] + " - " + query.Name,
			SimilarityID:  ptrStringToString(simID),
			FileID:        file.ID,
			FileName:      file.FilePath,
			Line:          linesVuln.Line,
			VulnLines:     linesVuln.VulnLines,
			IssueType:     "RedundantAttribute",
			Platform:      string(model.KindCOMMON),
			Severity:      model.SeverityHigh,
			QueryURI:      defaultSecretMetadata["descriptionUrl"],
			Category:      defaultSecretMetadata["category"],
			Description:   defaultSecretMetadata["descriptionText"],
			DescriptionID: defaultSecretMetadata["descriptionID"],
		}
		c.vulnerabilities = append(c.vulnerabilities, vuln)
	}
}

// CheckEntropyInterval - verifies if a given token's entropy is within expected bounds
func CheckEntropyInterval(entropy Entropy, token string) (bool, float64) {
	if len(token) > MinStringLen {
		base64Entropy := calculateEntropy(token, Base64Chars)
		hexEntropy := calculateEntropy(token, HexChars)
		if insideInterval(entropy, base64Entropy) || insideInterval(entropy, hexEntropy) {
			highestEntropy := math.Max(base64Entropy, hexEntropy)
			return true, highestEntropy
		}
	}
	return false, 0
}

func insideInterval(entropy Entropy, floatEntropy float64) bool {
	return floatEntropy >= entropy.Min && floatEntropy <= entropy.Max
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

func ptrStringToString(v *string) string {
	if v == nil {
		return ""
	}
	return *v
}
