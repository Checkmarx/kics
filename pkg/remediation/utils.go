package remediation

import (
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/utils"
	"github.com/rs/zerolog/log"
)

// Summary represents the information about the number of selected remediation and remediation done
type Summary struct {
	SelectedRemediationNumber   int
	ActualRemediationDoneNumber int
}

// GetRemediationSets collects all the replacements and additions per file
func (s *Summary) GetRemediationSets(results Report, include []string) map[string]interface{} {
	remediationSets := make(map[string]interface{})

	vulns := getVulns(results)

	if len(vulns) > 0 {
		remediationSets = s.GetRemediationSetsFromVulns(vulns, include)
	}

	return remediationSets
}

func shouldRemediate(file *File, include []string) bool {
	if file.Remediation != "" &&
		file.RemediationType != "" &&
		(include[0] == "all" || utils.Contains(file.SimilarityID, include)) &&
		filepath.Ext(file.FilePath) == ".tf" { // temporary
		return true
	}

	return false
}

func getBefore(line string) string {
	re := regexp.MustCompile(`^[\s-]*`)
	before := re.FindAll([]byte(line), -1)

	return string(before[0])
}

// willRemediate verifies if the remediation actually removes the result
func willRemediate(
	remediated []string,
	originalFileName string,
	remediation *Remediation,
	openAPIResolveReferences bool,
	maxResolverDepth int) bool {
	filepath.Clean(originalFileName)
	// create temporary file
	tmpFile := filepath.Join(os.TempDir(), "temporary-remediation-"+utils.NextRandom()+"-"+filepath.Base(originalFileName))
	f, err := os.OpenFile(filepath.Clean(tmpFile), os.O_WRONLY|os.O_CREATE|os.O_TRUNC, FilePermMode)

	if err != nil {
		log.Error().Msgf("failed to open temporary file for remediation '%s': %s", remediation.SimilarityID, err)
		return false
	}

	content := []byte(strings.Join(remediated, "\n"))

	defer func(f *os.File) {
		err = f.Close()
		if err != nil {
			log.Err(err).Msgf("failed to close file: %s", tmpFile)
		}
	}(f)

	if _, err = f.Write(content); err != nil {
		log.Error().Msgf("failed to write temporary file for remediation '%s': %s", remediation.SimilarityID, err)
		return false
	}

	// scan the temporary file to verify if the remediation removed the result
	results, err := scanTmpFile(tmpFile, remediation.QueryID, content, openAPIResolveReferences, maxResolverDepth)

	if err != nil {
		log.Error().Msgf("failed to get results of query %s: %s", remediation.QueryID, err)
		return false
	}

	err = os.Remove(tmpFile)

	if err != nil {
		log.Err(err)
	}

	return removedResult(results, remediation)
}

func removedResult(results []model.Vulnerability, remediation *Remediation) bool {
	for i := range results {
		result := results[i]

		if result.SearchKey == remediation.SearchKey &&
			result.KeyActualValue == remediation.ActualValue &&
			result.KeyExpectedValue == remediation.ExpectedValue {
			log.Info().Msgf("failed to remediate '%s'", remediation.SimilarityID)
			return false
		}
	}
	return true
}

// CreateTempFile creates a temporary file with the content as the file pointed in the filePathCopyFrom
func CreateTempFile(filePathCopyFrom, tmpFilePath string) string {
	filepath.Clean(filePathCopyFrom)
	filepath.Clean(tmpFilePath)
	f, err := os.OpenFile(tmpFilePath, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, FilePermMode)

	if err != nil {
		log.Error().Msgf("failed to open file '%s': %s", tmpFilePath, err)
		return ""
	}

	content, err := os.ReadFile(filePathCopyFrom)

	defer func(f *os.File) {
		err = f.Close()
		if err != nil {
			log.Err(err).Msgf("failed to close file: %s", tmpFilePath)
		}
	}(f)

	if err != nil {
		log.Error().Msgf("failed to read file '%s': %s", filePathCopyFrom, err)
		return ""
	}

	if _, err = f.Write(content); err != nil {
		log.Error().Msgf("failed to write file '%s': %s", tmpFilePath, err)
		return ""
	}

	return tmpFilePath
}

// GetRemediationSetsFromVulns collects all the replacements and additions per file from []model.Vulnerability
func (s *Summary) GetRemediationSetsFromVulns(vulnerabilities []model.Vulnerability, include []string) map[string]interface{} {
	remediationSets := make(map[string]interface{})

	for i := range vulnerabilities {
		vuln := vulnerabilities[i]

		file := File{
			FilePath:        vuln.FileName,
			Line:            vuln.Line,
			Remediation:     vuln.Remediation,
			RemediationType: vuln.RemediationType,
			SimilarityID:    vuln.SimilarityID,
		}

		var remediationSet Set

		if shouldRemediate(&file, include) {
			s.SelectedRemediationNumber++
			r := &Remediation{
				Line:          file.Line,
				Remediation:   file.Remediation,
				SimilarityID:  file.SimilarityID,
				QueryID:       vuln.QueryID,
				SearchKey:     vuln.SearchKey,
				ExpectedValue: vuln.KeyExpectedValue,
				ActualValue:   vuln.KeyActualValue,
			}

			if file.RemediationType == "replacement" {
				remediationSet.Replacement = append(remediationSet.Replacement, *r)
			}

			if file.RemediationType == "addition" {
				remediationSet.Addition = append(remediationSet.Addition, *r)
			}

			if _, ok := remediationSets[file.FilePath]; !ok {
				remediationSets[file.FilePath] = remediationSet
				continue
			}

			updatedRemediationSet := remediationSets[file.FilePath].(Set)

			updatedRemediationSet.Addition = append(updatedRemediationSet.Addition, remediationSet.Addition...)
			updatedRemediationSet.Replacement = append(updatedRemediationSet.Replacement, remediationSet.Replacement...)

			remediationSets[file.FilePath] = updatedRemediationSet
		}
	}
	return remediationSets
}

func getVulns(results Report) []model.Vulnerability {
	var vulns []model.Vulnerability
	for i := range results.Queries {
		query := results.Queries[i]

		for j := range query.Files {
			file := query.Files[j]
			vuln := &model.Vulnerability{
				FileName:         file.FilePath,
				Line:             file.Line,
				Remediation:      file.Remediation,
				RemediationType:  file.RemediationType,
				SimilarityID:     file.SimilarityID,
				QueryID:          query.QueryID,
				SearchKey:        file.SearchKey,
				KeyExpectedValue: file.ExpectedValue,
				KeyActualValue:   file.ActualValue,
			}

			vulns = append(vulns, *vuln)
		}
	}
	return vulns
}
