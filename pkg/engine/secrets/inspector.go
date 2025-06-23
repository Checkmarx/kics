package secrets

import (
	"context"
	_ "embed" // Embed KICS regex rules
	"encoding/json"
	"fmt"
	"math"
	"regexp"
	"strings"
	"sync"
	"time"

	"github.com/Checkmarx/kics/v2/assets"
	"github.com/Checkmarx/kics/v2/pkg/detector"
	"github.com/Checkmarx/kics/v2/pkg/detector/docker"
	"github.com/Checkmarx/kics/v2/pkg/detector/helm"
	engine "github.com/Checkmarx/kics/v2/pkg/engine"
	"github.com/Checkmarx/kics/v2/pkg/engine/similarity"
	"github.com/Checkmarx/kics/v2/pkg/engine/source"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/rs/zerolog/log"
)

const (
	Base64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
	HexChars    = "1234567890abcdefABCDEF"
	SecretMask  = "<SECRET-MASKED-ON-PURPOSE>"
)

var (
	SecretsQueryMetadata map[string]string
)

// SecretTracker is Struct created to keep track of the secrets found in the inspector
// it used for masking all the secrets in the vulnerability preview in the different report formats
type SecretTracker struct {
	ResolvedFilePath string
	Line             int
	OriginalContent  string
	MaskedContent    string
}

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
	mu                    sync.RWMutex
	SecretTracker         []SecretTracker
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
	ID          string          `json:"id"`
	Name        string          `json:"name"`
	Multiline   MultilineResult `json:"multiline"`
	RegexStr    string          `json:"regex"`
	SpecialMask string          `json:"specialMask"`
	Entropies   []Entropy       `json:"entropies"`
	AllowRules  []AllowRule     `json:"allowRules"`
	Regex       *regexp.Regexp
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
			SecretTracker:         make([]SecretTracker, 0),
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

	allowRules, err := CompileRegex(allRegexQueries.AllowRules)
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

func (c *Inspector) inspectQuery(ctx context.Context, basePaths []string,
	files model.FileMetadatas, i int) ([]model.Vulnerability, error) {
	timeoutCtx, cancel := context.WithTimeout(ctx, c.queryExecutionTimeout)
	defer cancel()

	cleanFiles := cleanFiles(files)

	for idx := range cleanFiles {
		if _, ok := cleanFiles[idx].Commands["ignore"]; !ok {
			select {
			case <-timeoutCtx.Done():
				return c.vulnerabilities, timeoutCtx.Err()
			default:
				c.checkContent(i, idx, basePaths, cleanFiles)
			}
		}
	}
	return c.vulnerabilities, nil
}

// Inspect inspects the source code for passwords & secrets and returns the list of vulnerabilities
func (c *Inspector) Inspect(ctx context.Context, basePaths []string,
	files model.FileMetadatas, currentQuery chan<- int64) ([]model.Vulnerability, error) {
	for i := range c.regexQueries {
		currentQuery <- 1

		vulns, err := c.inspectQuery(ctx, basePaths, files, i)

		if err != nil {
			return vulns, err
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

// CompileRegex compiles the regex allow rules
func CompileRegex(allowRules []AllowRule) ([]AllowRule, error) {
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
	if IsAllowRule(s, query, append(query.AllowRules, c.allowRules...)) {
		return false, [][]string{}
	}

	groups = query.Regex.FindAllStringSubmatch(s, -1)

	for _, group := range groups {
		splitedText := strings.Split(s, "\n")
		maxSplit := -1
		for i, splited := range splitedText {
			if len(groups) < query.Multiline.DetectLineGroup {
				if strings.Contains(splited, group[query.Multiline.DetectLineGroup]) && i > maxSplit {
					maxSplit = i
				}
			}
		}
		if maxSplit == -1 {
			continue
		}
		secret, newGroups := c.isSecret(strings.Join(append(splitedText[:maxSplit], splitedText[maxSplit+1:]...), "\n"), query)
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

// IsAllowRule check if string matches any of the allow rules for the secret queries
func IsAllowRule(s string, query *RegexQuery, allowRules []AllowRule) bool {
	regexMatch := query.Regex.FindStringIndex(s)
	if regexMatch != nil {
		allowRuleMatches := AllowRuleMatches(s, append(query.AllowRules, allowRules...))

		for _, allowMatch := range allowRuleMatches {
			allowStart, allowEnd := allowMatch[0], allowMatch[1]
			regexStart, regexEnd := regexMatch[0], regexMatch[1]

			if (allowStart <= regexEnd && allowStart >= regexStart) || (regexStart <= allowEnd && regexStart >= allowStart) {
				return true
			}
		}
	}

	return false
}

// AllowRuleMatches return all the allow rules matches for the secret queries
func AllowRuleMatches(s string, allowRules []AllowRule) [][]int {
	allowRuleMatches := [][]int{}
	for i := range allowRules {
		allowRuleMatches = append(allowRuleMatches, allowRules[i].Regex.FindAllStringIndex(s, -1)...)
	}
	return allowRuleMatches
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
	lines := *file.LinesOriginalData
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

func (c *Inspector) checkLineByLine(wg *sync.WaitGroup, query *RegexQuery,
	basePaths []string, file *model.FileMetadata, lineNumber int, currentLine string) {
	defer wg.Done()
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
	if engine.ShouldSkipVulnerability(file.Commands, query.ID) {
		log.Debug().Msgf("Skipping vulnerability in file %s for query '%s':%s", file.FilePath, query.Name, query.ID)
		return
	}
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

	c.mu.Lock()
	if _, ok := c.excludeResults[engine.PtrStringToString(simID)]; !ok {
		linesVuln := c.detector.GetAdjacent(file, lineNumber+1)
		if !ignoreLine(linesVuln.Line, file.LinesIgnore) {
			vuln := model.Vulnerability{
				QueryID:          query.ID,
				QueryName:        SecretsQueryMetadata["queryName"] + " - " + query.Name,
				SimilarityID:     engine.PtrStringToString(simID),
				FileID:           file.ID,
				FileName:         file.FilePath,
				Line:             linesVuln.Line,
				VulnLines:        hideSecret(&linesVuln, issueLine, query, &c.SecretTracker),
				IssueType:        "RedundantAttribute",
				Platform:         SecretsQueryMetadata["platform"],
				CWE:              SecretsQueryMetadata["cwe"],
				Severity:         model.SeverityHigh,
				QueryURI:         SecretsQueryMetadata["descriptionUrl"],
				Category:         SecretsQueryMetadata["category"],
				Description:      SecretsQueryMetadata["descriptionText"],
				DescriptionID:    SecretsQueryMetadata["descriptionID"],
				KeyExpectedValue: "Hardcoded secret key should not appear in source",
				KeyActualValue:   "Hardcoded secret key appears in source",
				CloudProvider:    SecretsQueryMetadata["cloudProvider"],
			}
			c.vulnerabilities = append(c.vulnerabilities, vuln)
		}
	}
	c.mu.Unlock()
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

func (c *Inspector) checkContent(i, idx int, basePaths []string, files model.FileMetadatas) {
	// lines ignore can have the lines from the resolved files
	// since inspector secrets only looks to original data, the lines ignore should be replaced
	files[idx].LinesIgnore = model.GetIgnoreLines(&files[idx])

	wg := &sync.WaitGroup{}
	// check file content line by line
	if c.regexQueries[i].Multiline == (MultilineResult{}) {
		lines := (&files[idx]).LinesOriginalData
		for lineNumber, currentLine := range *lines {
			wg.Add(1)
			go c.checkLineByLine(wg, &c.regexQueries[i], basePaths, &files[idx], lineNumber, currentLine)
		}
		wg.Wait()
		return
	}

	// check file content as a whole
	c.checkFileContent(&c.regexQueries[i], basePaths, &files[idx])
}

func ignoreLine(lineNumber int, linesIgnore []int) bool {
	for _, ignoreLine := range linesIgnore {
		if lineNumber == ignoreLine {
			return true
		}
	}
	return false
}

// cleanFiles keeps one file per filePath
func cleanFiles(files model.FileMetadatas) model.FileMetadatas {
	keys := make(map[string]bool)

	cleanFiles := model.FileMetadatas{}

	for i := range files {
		filePath := files[i].FilePath
		if _, value := keys[filePath]; !value {
			keys[filePath] = true
			cleanFiles = append(cleanFiles, files[i])
		}
	}

	return cleanFiles
}

func hideSecret(linesVuln *model.VulnerabilityLines,
	issueLine string,
	query *RegexQuery,
	secretTracker *[]SecretTracker) *[]model.CodeLine {
	for idx := range *linesVuln.VulnLines {
		if query.SpecialMask == "all" && idx != 0 {
			addToSecretTracker(secretTracker, linesVuln.ResolvedFile, linesVuln.Line, (*linesVuln.VulnLines)[idx].Line, SecretMask)
			(*linesVuln.VulnLines)[idx].Line = SecretMask
			continue
		}

		if (*linesVuln.VulnLines)[idx].Line == issueLine {
			regex := query.RegexStr

			if query.SpecialMask != "" {
				regex = "(.*)" + query.SpecialMask // get key
			}

			var re = regexp.MustCompile(regex)
			match := re.FindString(issueLine)

			if query.SpecialMask != "" {
				match = issueLine[len(match):] // get value
			}

			if match != "" {
				originalCntAux := (*linesVuln.VulnLines)[idx].Line
				(*linesVuln.VulnLines)[idx].Line = strings.Replace(issueLine, match, SecretMask, 1)
				addToSecretTracker(secretTracker, linesVuln.ResolvedFile, linesVuln.Line, originalCntAux, (*linesVuln.VulnLines)[idx].Line)
			} else {
				addToSecretTracker(secretTracker,
					linesVuln.ResolvedFile,
					linesVuln.Line,
					(*linesVuln.VulnLines)[idx].Line,
					SecretMask)
				(*linesVuln.VulnLines)[idx].Line = SecretMask
			}
		}
	}
	return linesVuln.VulnLines
}

func addToSecretTracker(secretTracker *[]SecretTracker, path string, line int, originalCnt, maskedCnt string) {
	*secretTracker = append(*secretTracker, SecretTracker{
		ResolvedFilePath: path,
		Line:             line,
		OriginalContent:  originalCnt,
		MaskedContent:    maskedCnt,
	})
}
