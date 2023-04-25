package scan

import (
	_ "embed" // Embed kics CLI img and scan-flags
	"encoding/json"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"time"

	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/pkg/descriptions"
	"github.com/Checkmarx/kics/pkg/engine/provider"
	secret "github.com/Checkmarx/kics/pkg/engine/secrets"
	"github.com/Checkmarx/kics/pkg/model"
	consolePrinter "github.com/Checkmarx/kics/pkg/printer"
	"github.com/Checkmarx/kics/pkg/progress"
	"github.com/Checkmarx/kics/pkg/report"
	"github.com/rs/zerolog/log"
)

func (c *Client) getSummary(results []model.Vulnerability, end time.Time, pathParameters model.PathParameters) model.Summary {
	counters := model.Counters{
		ScannedFiles:           c.Tracker.FoundFiles,
		ScannedFilesLines:      c.Tracker.FoundCountLines,
		ParsedFilesLines:       c.Tracker.ParsedCountLines,
		ParsedFiles:            c.Tracker.ParsedFiles,
		TotalQueries:           c.Tracker.LoadedQueries,
		FailedToExecuteQueries: c.Tracker.ExecutingQueries - c.Tracker.ExecutedQueries,
		FailedSimilarityID:     c.Tracker.FailedSimilarityID,
	}

	summary := model.CreateSummary(counters, results, c.ScanParams.ScanID, pathParameters.PathExtractionMap, c.Tracker.Version)
	summary.Times = model.Times{
		Start: c.ScanStartTime,
		End:   end,
	}

	if c.ScanParams.DisableCISDesc || c.ScanParams.DisableFullDesc {
		log.Warn().Msg("Skipping CIS descriptions because provided disable flag is set")
	} else {
		err := descriptions.RequestAndOverrideDescriptions(&summary)
		if err != nil {
			log.Warn().Msgf("Unable to get descriptions: %s", err)
			log.Warn().Msgf("Using default descriptions")
		}
	}

	return summary
}

func (c *Client) resolveOutputs(
	summary *model.Summary,
	documents model.Documents,
	failedQueries map[string]error,
	printer *consolePrinter.Printer,
	proBarBuilder progress.PbBuilder,
) error {
	log.Debug().Msg("console.resolveOutputs()")

	if err := consolePrinter.PrintResult(summary, failedQueries, printer); err != nil {
		return err
	}
	if c.ScanParams.PayloadPath != "" {
		if err := report.ExportJSONReport(
			filepath.Dir(c.ScanParams.PayloadPath),
			filepath.Base(c.ScanParams.PayloadPath),
			documents,
		); err != nil {
			return err
		}
	}

	return printOutput(
		c.ScanParams.OutputPath,
		c.ScanParams.OutputName,
		summary, c.ScanParams.ReportFormats,
		proBarBuilder,
	)
}

func printOutput(outputPath, filename string, body interface{}, formats []string, proBarBuilder progress.PbBuilder) error {
	log.Debug().Msg("console.printOutput()")
	if outputPath == "" {
		return nil
	}
	if len(formats) == 0 {
		formats = []string{"json"}
	}

	log.Debug().Msgf("Output formats provided [%v]", strings.Join(formats, ","))
	err := consoleHelpers.GenerateReport(outputPath, filename, body, formats, proBarBuilder)

	return err
}

// postScan is responsible for the output results
func (c *Client) postScan(scanResults *Results) error {
	if scanResults == nil {
		log.Info().Msg("No files were scanned")
		scanResults = &Results{
			Results:        []model.Vulnerability{},
			ExtractedPaths: provider.ExtractedPath{},
			Files:          model.FileMetadatas{},
			FailedQueries:  map[string]error{},
		}
	}

	secretsRegexRulesContent, err := getSecretsRegexRules(c.ScanParams.SecretsRegexesPath)

	if err != nil {
		return err
	}

	var allRegexQueries secret.RegexRuleStruct

	err = json.Unmarshal([]byte(secretsRegexRulesContent), &allRegexQueries)
	if err != nil {
		return err
	}

	allowRules, err := secret.CompileRegex(allRegexQueries.AllowRules)

	if err != nil {
		return err
	}

	rules, err := compileRegexQueries(allRegexQueries.Rules)

	if err != nil {
		return err
	}

	for _, item := range scanResults.Results {
		hideSecret(item.VulnLines, &allowRules, &rules)
	}

	summary := c.getSummary(scanResults.Results, time.Now(), model.PathParameters{
		ScannedPaths:      c.ScanParams.Path,
		PathExtractionMap: scanResults.ExtractedPaths.ExtractionMap,
	})

	if err := c.resolveOutputs(
		&summary,
		scanResults.Files.Combine(c.ScanParams.LineInfoPayload),
		scanResults.FailedQueries,
		c.Printer,
		*c.ProBarBuilder); err != nil {
		log.Err(err)
		return err
	}

	deleteExtractionFolder(scanResults.ExtractedPaths.ExtractionMap)

	consolePrinter.PrintScanDuration(time.Since(c.ScanStartTime))

	printVersionCheck(c.Printer, &summary)

	contributionAppeal(c.Printer, c.ScanParams.QueriesPath)

	exitCode := consoleHelpers.ResultsExitCode(&summary)
	if consoleHelpers.ShowError("results") && exitCode != 0 {
		os.Exit(exitCode)
	}

	return nil
}

func compileRegexQueries(allRegexQueries []secret.RegexQuery) ([]secret.RegexQuery, error) {
	var regexQueries []secret.RegexQuery

	for i := range allRegexQueries {
		regexQueries = append(regexQueries, allRegexQueries[i])
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

func hideSecret(lines *[]model.CodeLine, allowRules *[]secret.AllowRule, rules *[]secret.RegexQuery) {

	for idx, line := range *lines {
		for _, rule := range *rules {
			isSecret, groups := isSecret(line.Line, &rule, allowRules)
			//if isAllowRule is TRUE then this is not a secret so skip to next line
			if !isSecret {
				continue
			}

			if rule.SpecialMask == "all" {
				(*lines)[idx].Line = "<SECRET-MASKED-ON-PURPOSE>"
				continue
			}

			regex := rule.RegexStr
			issueLine := line.Line

			if len(rule.Entropies) == 0 {
				if len(rule.SpecialMask) > 0 {
					regex = "(.+)" + rule.SpecialMask // get key
				}

				var re = regexp.MustCompile(regex)
				match := re.FindString(issueLine)

				if len(rule.SpecialMask) > 0 {
					match = issueLine[len(match):] // get value
				}

				if match != "" {
					(*lines)[idx].Line = strings.Replace(issueLine, match, "<SECRET-MASKED-ON-PURPOSE>", 1)
				} else {
					(*lines)[idx].Line = "<SECRET-MASKED-ON-PURPOSE>"
				}
			}

			//TODO: check if you should remove this entire segment
			for i := range rule.Entropies {
				entropy := rule.Entropies[i]

				// if matched group does not exist continue
				if len(groups[0]) <= entropy.Group {
					return
				}

				//TODO: check if we need to mask. when does this happen?
			}

		}
	}
}

func isSecret(s string, query *secret.RegexQuery, allowRules *[]secret.AllowRule) (isSecretRet bool, groups [][]string) {
	if secret.IsAllowRule(s, *allowRules) {
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
		secret, newGroups := isSecret(strings.Join(append(splitedText[:max], splitedText[max+1:]...), "\n"), query, allowRules)
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
