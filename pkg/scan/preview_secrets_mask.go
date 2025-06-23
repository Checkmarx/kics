// Package scan implements functions and helpers to ensure the proper scan of the specified files
package scan

import (
	"encoding/json"
	"regexp"
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/engine/secrets"
	"github.com/Checkmarx/kics/v2/pkg/model"
)

func maskPreviewLines(secretsPath string, scanResults *Results) error {
	secretsRegexRulesContent, err := getSecretsRegexRules(secretsPath)
	if err != nil {
		return err
	}

	var allRegexQueries secrets.RegexRuleStruct

	err = json.Unmarshal([]byte(secretsRegexRulesContent), &allRegexQueries)
	if err != nil {
		return err
	}

	allowRules, err := secrets.CompileRegex(allRegexQueries.AllowRules)
	if err != nil {
		return err
	}

	rules, err := compileRegexQueries(allRegexQueries.Rules)
	if err != nil {
		return err
	}

	for i := range scanResults.Results {
		item := scanResults.Results[i]
		hideSecret(item.VulnLines, &allowRules, &rules)
	}
	return nil
}

func compileRegexQueries(allRegexQueries []secrets.RegexQuery) ([]secrets.RegexQuery, error) {
	for i := range allRegexQueries {
		compiledRegexp, err := regexp.Compile(allRegexQueries[i].RegexStr)
		if err != nil {
			return allRegexQueries, err
		}
		allRegexQueries[i].Regex = compiledRegexp

		for j := range allRegexQueries[i].AllowRules {
			allRegexQueries[i].AllowRules[j].Regex = regexp.MustCompile(allRegexQueries[i].AllowRules[j].RegexStr)
		}
	}
	return allRegexQueries, nil
}

func hideSecret(lines *[]model.CodeLine, allowRules *[]secrets.AllowRule, rules *[]secrets.RegexQuery) {
	for idx, line := range *lines {
		for i := range *rules {
			rule := (*rules)[i]

			isSecret, groups := isSecret(line.Line, &rule, allowRules)
			// if not a secret skip to next line
			if !isSecret {
				continue
			}

			if len(rule.Entropies) == 0 {
				maskSecret(&rule, lines, idx)
			}

			if len(groups[0]) > 0 {
				for _, entropy := range rule.Entropies {
					// if matched group does not exist continue
					if len(groups[0]) <= entropy.Group {
						return
					}
					isMatch, _ := secrets.CheckEntropyInterval(
						entropy,
						groups[0][entropy.Group],
					)
					if isMatch {
						maskSecret(&rule, lines, idx)
					}
				}
			}
		}
	}
}

func maskSecret(rule *secrets.RegexQuery, lines *[]model.CodeLine, idx int) {
	if rule.SpecialMask == "all" {
		(*lines)[idx].Line = secrets.SecretMask
		return
	}

	regex := rule.RegexStr
	line := (*lines)[idx]

	if rule.SpecialMask != "" {
		regex = "(.+)" + rule.SpecialMask
	}

	var re = regexp.MustCompile(regex)
	match := re.FindString(line.Line)

	if rule.SpecialMask != "" {
		match = line.Line[len(match):]
	}

	if match != "" {
		(*lines)[idx].Line = strings.Replace(line.Line, match, secrets.SecretMask, 1)
	} else {
		(*lines)[idx].Line = secrets.SecretMask
	}
}

// repurposed isSecret from inspector
func isSecret(line string, rule *secrets.RegexQuery, allowRules *[]secrets.AllowRule) (isSecretRet bool, groups [][]string) {
	if secrets.IsAllowRule(line, rule, *allowRules) {
		return false, [][]string{}
	}

	groups = rule.Regex.FindAllStringSubmatch(line, -1)

	for _, group := range groups {
		splitedText := strings.Split(line, "\n")
		maxSplit := -1
		for i, splited := range splitedText {
			if len(groups) < rule.Multiline.DetectLineGroup {
				if strings.Contains(splited, group[rule.Multiline.DetectLineGroup]) && i > maxSplit {
					maxSplit = i
				}
			}
		}
		if maxSplit == -1 {
			continue
		}
		secret, newGroups := isSecret(strings.Join(append(splitedText[:maxSplit], splitedText[maxSplit+1:]...), "\n"), rule, allowRules)
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
