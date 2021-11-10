package secrets

import (
	"context"
	_ "embed" // Embed KICS regex rules
	"encoding/json"
	"fmt"
	"math"
	"regexp"
	"strings"
	"time"

	"github.com/Checkmarx/kics/assets"
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
	Base64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
	HexChars    = "1234567890abcdefABCDEF"
)

var (
	SecretsQueryMetadata map[string]string
)

type Inspector struct {
	ctx                   context.Context
	tracker               engine.Tracker
	detector              *detector.DetectLine
	excludeResults        map[string]bool
	regexQueries          []RegexQuery
	allowRules            []AllowRule
	vulnerabilities       []model.Vulnerability
	queryExecutionTimeout time.Duration
	foundLines            []int
}

type Entropy struct {
	Group int     `json:"group"`
	Min   float64 `json:"min"`
	Max   float64 `json:"max"`
}

type MultilineResult struct {
	DetectLineGroup int `json:"detectLineGroup"`
}

type AllowRule struct {
	Description string `json:"description"`
	RegexStr    string `json:"regex"`
	Regex       *regexp.Regexp
}

type RegexQuery struct {
	ID         string          `json:"id"`
	Name       string          `json:"name"`
	Multiline  MultilineResult `json:"multiline"`
	RegexStr   string          `json:"regex"`
	Entropies  []Entropy       `json:"entropies"`
	AllowRules []AllowRule     `json:"allowRules"`
	Regex      *regexp.Regexp
}

type RegexRuleStruct struct {
	Rules      []RegexQuery `json:"rules"`
	AllowRules []AllowRule  `json:"allowRules"`
}

type RuleMatch struct {
	File     string
	RuleName string
	Matches  []string
	Line     int
	Entropy  float64
}

type lineVulneInfo struct {
	lineContent string
	lineNumber  int
	groups      []string
}

func NewInspector(
	ctx context.Context,
	excludeResults map[string]bool,
	tracker engine.Tracker,
	queryFilter *source.QueryInspectorParameters,
	disableSecretsQuery bool,
	executionTimeout int,
	regexRulesContent string,
	isCustomSecretsRegexes bool,
) (*Inspector, error) {
	passwordsAndSecretsQueryID, err := getPasswordsAndSecretsQueryID()
	if err != nil {
		return nil, err
	}
	excludeSecretsQuery := isValueInArray(passwordsAndSecretsQueryID, queryFilter.ExcludeQueries.ByIDs)
	if disableSecretsQuery || excludeSecretsQuery && !isCustomSecretsRegexes {
		return &Inspector{
			ctx:                   ctx,
			tracker:               tracker,
			excludeResults:        excludeResults,
			regexQueries:          make([]RegexQuery, 0),
			allowRules:            make([]AllowRule, 0),
			vulnerabilities:       make([]model.Vulnerability, 0),
			queryExecutionTimeout: time.Duration(executionTimeout) * time.Second,
		}, nil
	}

	lineDetector := detector.NewDetectLine(tracker.GetOutputLines()).
		Add(helm.DetectKindLine{}, model.KindHELM).
		Add(docker.DetectKindLine{}, model.KindDOCKER)

	err = json.Unmarshal([]byte(assets.SecretsQueryMetadataJSON), &SecretsQueryMetadata)
	if err != nil {
		return nil, err
	}
	queryExecutionTimeout := time.Duration(executionTimeout) * time.Second

	var allRegexQueries RegexRuleStruct
	err = json.Unmarshal([]byte(regexRulesContent), &allRegexQueries)
	if err != nil {
		return nil, err
	}

	if isCustomSecretsRegexes {
		err = validateCustomSecretsQueriesID(allRegexQueries.Rules)
		if err != nil {
			return nil, err
		}
	}

	regexQueries, err := compileRegexQueries(queryFilter, allRegexQueries.Rules, isCustomSecretsRegexes, passwordsAndSecretsQueryID)
	if err != nil {
		return nil, err
	}

	allowRules, err := compileRegex(allRegexQueries.AllowRules)
	if err != nil {
		return nil, err
	}

	return &Inspector{
		ctx:                   ctx,
		detector:              lineDetector,
		excludeResults:        excludeResults,
		tracker:               tracker,
		regexQueries:          regexQueries,
		allowRules:            allowRules,
		vulnerabilities:       make([]model.Vulnerability, 0),
		queryExecutionTimeout: queryExecutionTimeout,
		foundLines:            make([]int, 0),
	}, nil
}

func (c *Inspector) Inspect(ctx context.Context, basePaths []string,
	files model.FileMetadatas, currentQuery chan<- int64) ([]model.Vulnerability, error) {
	for i := range c.regexQueries {
		currentQuery <- 1

		timeoutCtx, cancel := context.WithTimeout(ctx, c.queryExecutionTimeout*time.Second)
		defer cancel()
		for idx := range files {
			select {
			case <-timeoutCtx.Done():
				return c.vulnerabilities, timeoutCtx.Err()
			default:
				// check file content line by line
				if c.regexQueries[i].Multiline == (MultilineResult{}) {
					lines := c.detector.SplitLines(&files[idx])

					for lineNumber, currentLine := range lines {
						c.checkLineByLine(&c.regexQueries[i], basePaths, &files[idx], lineNumber, currentLine)
					}
					continue
				}

				// check file content as a whole
				c.checkFileContent(&c.regexQueries[i], basePaths, &files[idx])
			}
		}
	}
	return c.vulnerabilities, nil
}

func compileRegexQueries(
	queryFilter *source.QueryInspectorParameters,
	allRegexQueries []RegexQuery,
	isCustom bool,
	passwordsAndSecretsQueryID string,
) ([]RegexQuery, error) {
	var regexQueries []RegexQuery
	var includeSpecificSecretQuery bool

	allSecretsQueryAndCustom := false

	includeAllSecretsQuery := isValueInArray(passwordsAndSecretsQueryID, queryFilter.IncludeQueries.ByIDs)

	if includeAllSecretsQuery && isCustom { // merge case
		var kicsRegexQueries RegexRuleStruct
		err := json.Unmarshal([]byte(assets.SecretsQueryRegexRulesJSON), &kicsRegexQueries)
		if err != nil {
			return nil, err
		}
		allSecretsQueryAndCustom = true
		regexQueries = kicsRegexQueries.Rules
	}

	for i := range allRegexQueries {
		includeSpecificSecretQuery = isValueInArray(allRegexQueries[i].ID, queryFilter.IncludeQueries.ByIDs)
		if len(queryFilter.IncludeQueries.ByIDs) > 0 && !allSecretsQueryAndCustom {
			if includeAllSecretsQuery || includeSpecificSecretQuery {
				regexQueries = append(regexQueries, allRegexQueries[i])
			}
		} else {
			if !shouldExecuteQuery(
				allRegexQueries[i].ID,
				allRegexQueries[i].ID,
				SecretsQueryMetadata["category"],
				SecretsQueryMetadata["severity"],
				queryFilter.ExcludeQueries.ByIDs,
			) {
				continue
			}
			if !shouldExecuteQuery(
				SecretsQueryMetadata["category"],
				allRegexQueries[i].ID,
				SecretsQueryMetadata["category"],
				SecretsQueryMetadata["severity"],
				queryFilter.ExcludeQueries.ByCategories,
			) {
				continue
			}
			if !shouldExecuteQuery(
				SecretsQueryMetadata["severity"],
				allRegexQueries[i].ID,
				SecretsQueryMetadata["category"],
				SecretsQueryMetadata["severity"],
				queryFilter.ExcludeQueries.BySeverities,
			) {
				continue
			}
			regexQueries = append(regexQueries, allRegexQueries[i])
		}
	}
	for i := range regexQueries {
		compiledRegexp, err := regexp.Compile(regexQueries[i].RegexStr)
		if err != nil {
			return regexQueries, err
		}
		regexQueries[i].Regex = compiledRegexp
		for j := range regexQueries[i].AllowRules {
			regexQueries[i].AllowRules[j].Regex = regexp.MustCompile(regexQueries[i].AllowRules[j].RegexStr)
		}
	}
	return regexQueries, nil
}

func compileRegex(allowRules []AllowRule) ([]AllowRule, error) {
	for j := range allowRules {
		compiledRegex, err := regexp.Compile(allowRules[j].RegexStr)
		if err != nil {
			return nil, err
		}
		allowRules[j].Regex = compiledRegex
	}
	return allowRules, nil
}

func (c *Inspector) GetQueriesLength() int {
	return len(c.regexQueries)
}

func isValueInArray(value string, array []string) bool {
	for i := range array {
		if strings.EqualFold(value, array[i]) {
			return true
		}
	}
	return false
}

func (c *Inspector) isSecret(s string, query *RegexQuery) (isSecretRet bool, groups [][]string) {
	if isAllowRule(s, query.AllowRules) || isAllowRule(s, c.allowRules) {
		return false, [][]string{}
	}

	groups = query.Regex.FindAllStringSubmatch(s, -1)

	for _, group := range groups {
		splitedText := strings.Split(s, "\n")
		max := -1
		for i, splited := range splitedText {
			if len(groups) < query.Multiline.DetectLineGroup {
				if strings.Contains(splited, group[query.Multiline.DetectLineGroup]) && i > max {
					max = i
				}
			}
		}
		if max == -1 {
			continue
		}
		secret, newGroups := c.isSecret(strings.Join(append(splitedText[:max], splitedText[max+1:]...), "\n"), query)
		if !secret {
			continue
		}
		groups = append(groups, newGroups...)
	}

	if len(groups) > 0 {
		return true, groups
	}
	return false, [][]string{}
}

func isAllowRule(s string, allowRules []AllowRule) bool {
	for i := range allowRules {
		if allowRules[i].Regex.MatchString(s) {
			return true
		}
	}
	return false
}

func (c *Inspector) checkFileContent(query *RegexQuery, basePaths []string, file *model.FileMetadata) {
	isSecret, groups := c.isSecret(file.OriginalData, query)
	if !isSecret {
		return
	}

	lineVulns := c.secretsDetectLine(query, file, groups)

	for _, lineVuln := range lineVulns {
		if len(query.Entropies) == 0 {
			c.addVulnerability(
				basePaths,
				file,
				query,
				lineVuln.lineNumber,
				lineVuln.lineContent,
			)
		}

		if len(lineVuln.groups) > 0 {
			for _, entropy := range query.Entropies {
				// if matched group does not exist continue
				if len(lineVuln.groups) <= entropy.Group {
					return
				}
				isMatch, entropyFloat := CheckEntropyInterval(
					entropy,
					lineVuln.groups[entropy.Group],
				)
				log.Debug().Msgf("match: %v :: %v", isMatch, fmt.Sprint(entropyFloat))

				if isMatch {
					c.addVulnerability(
						basePaths,
						file,
						query,
						lineVuln.lineNumber,
						lineVuln.lineContent,
					)
				}
			}
		}
	}
}

func (c *Inspector) secretsDetectLine(query *RegexQuery, file *model.FileMetadata, vulnGroups [][]string) []lineVulneInfo {
	content := file.OriginalData
	lines := c.detector.SplitLines(file)
	lineVulneInfoSlice := make([]lineVulneInfo, 0)
	realLineUpdater := 0
	for _, groups := range vulnGroups {
		lineVulneInfoObject := lineVulneInfo{
			lineNumber:  -1,
			lineContent: "-",
			groups:      groups,
		}

		if len(groups) <= query.Multiline.DetectLineGroup {
			log.Warn().Msgf("Unable to detect line in file %v Multiline group not found: %v", file.FilePath, query.Multiline.DetectLineGroup)
			lineVulneInfoSlice = append(lineVulneInfoSlice, lineVulneInfoObject)
			continue
		}

		contentMatchRemoved := strings.Replace(content, groups[query.Multiline.DetectLineGroup], "", 1)

		text := strings.ReplaceAll(contentMatchRemoved, "\r", "")
		contentMatchRemovedLines := strings.Split(text, "\n")
		for i := 0; i < len(lines); i++ {
			if lines[i] != contentMatchRemovedLines[i] {
				lineVulneInfoObject.lineNumber = i + realLineUpdater
				lineVulneInfoObject.lineContent = lines[i]
				break
			}
		}

		realLineUpdater += len(lines) - len(contentMatchRemovedLines)
		content = contentMatchRemoved
		lines = contentMatchRemovedLines

		lineVulneInfoSlice = append(lineVulneInfoSlice, lineVulneInfoObject)
	}

	return lineVulneInfoSlice
}

func (c *Inspector) checkLineByLine(query *RegexQuery, basePaths []string, file *model.FileMetadata, lineNumber int, currentLine string) {
	isSecret, groups := c.isSecret(currentLine, query)
	if !isSecret {
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
		if len(groups[0]) <= entropy.Group {
			return
		}

		isMatch, entropyFloat := CheckEntropyInterval(
			entropy,
			groups[0][entropy.Group],
		)
		log.Debug().Msgf("match: %v :: %v", isMatch, fmt.Sprint(entropyFloat))

		if isMatch {
			c.addVulnerability(
				basePaths,
				file,
				query,
				lineNumber,
				currentLine,
			)
		}
	}
}

func (c *Inspector) addVulnerability(basePaths []string, file *model.FileMetadata, query *RegexQuery, lineNumber int, issueLine string) {
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

	if _, ok := c.excludeResults[engine.PtrStringToString(simID)]; !ok {
		linesVuln := c.detector.GetAdjecent(file, lineNumber+1)
		vuln := model.Vulnerability{
			QueryID:          query.ID,
			QueryName:        SecretsQueryMetadata["queryName"] + " - " + query.Name,
			SimilarityID:     engine.PtrStringToString(simID),
			FileID:           file.ID,
			FileName:         file.FilePath,
			Line:             linesVuln.Line,
			VulnLines:        linesVuln.VulnLines,
			IssueType:        "RedundantAttribute",
			Platform:         SecretsQueryMetadata["platform"],
			Severity:         model.SeverityHigh,
			QueryURI:         SecretsQueryMetadata["descriptionUrl"],
			Category:         SecretsQueryMetadata["category"],
			Description:      SecretsQueryMetadata["descriptionText"],
			DescriptionID:    SecretsQueryMetadata["descriptionID"],
			KeyExpectedValue: "Hardcoded secret key should not appear in source",
			KeyActualValue:   fmt.Sprintf("'%s' contains a secret", issueLine),
		}
		c.vulnerabilities = append(c.vulnerabilities, vuln)
	}
}

// CheckEntropyInterval - verifies if a given token's entropy is within expected bounds
func CheckEntropyInterval(entropy Entropy, token string) (isEntropyInInterval bool, entropyLevel float64) {
	base64Entropy := calculateEntropy(token, Base64Chars)
	hexEntropy := calculateEntropy(token, HexChars)
	highestEntropy := math.Max(base64Entropy, hexEntropy)
	if insideInterval(entropy, base64Entropy) || insideInterval(entropy, hexEntropy) {
		return true, highestEntropy
	}
	return false, highestEntropy
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

func shouldExecuteQuery(filterTarget, id, category, severity string, filter []string) bool {
	if isValueInArray(filterTarget, filter) {
		log.Debug().
			Msgf("Excluding query ID: %s category: %s severity: %s",
				id,
				category,
				severity)
		return false
	}
	return true
}

func getPasswordsAndSecretsQueryID() (string, error) {
	var metadata = make(map[string]string)
	err := json.Unmarshal([]byte(assets.SecretsQueryMetadataJSON), &metadata)
	if err != nil {
		return "", err
	}
	return metadata["id"], nil
}

func validateCustomSecretsQueriesID(allRegexQueries []RegexQuery) error {
	for i := range allRegexQueries {
		re := regexp.MustCompile(`^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$`)
		if !(re.MatchString(allRegexQueries[i].ID)) {
			return fmt.Errorf("the query %s defines an invalid query ID (%s)", allRegexQueries[i].Name, allRegexQueries[i].ID)
		}
	}
	return nil
}
