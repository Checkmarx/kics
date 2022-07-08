package remediation

import (
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/utils"
	"github.com/rs/zerolog/log"
)

// Summary represents the information about the number of selected remediation and remediation done
type Summary struct {
	SelectedRemediationNumber   int
	ActualRemediationDoneNumber int
}

// GetFixs collects all the replacements and additions per file
func (s *Summary) GetFixs(results Report, include []string) map[string]interface{} {
	fixs := make(map[string]interface{})

	for i := range results.Queries {
		query := results.Queries[i]

		for j := range query.Files {
			file := query.Files[j]

			var fix Fix

			if shouldRemediate(&file, include) {
				s.SelectedRemediationNumber++

				r := &Remediation{
					Line:         file.Line,
					Remediation:  file.Remediation,
					SimilarityID: file.SimilarityID,
					QueryID:      query.QueryID,
				}
				if file.RemediationType == "replacement" {
					fix.Replacement = append(fix.Replacement, *r)
				}

				if file.RemediationType == "addition" {
					fix.Addition = append(fix.Addition, *r)
				}

				if _, ok := fixs[file.FilePath]; !ok {
					fixs[file.FilePath] = fix
					continue
				}

				updatedFix := fixs[file.FilePath].(Fix)

				updatedFix.Addition = append(updatedFix.Addition, fix.Addition...)
				updatedFix.Replacement = append(updatedFix.Replacement, fix.Replacement...)

				fixs[file.FilePath] = updatedFix
			}
		}
	}

	return fixs
}

func shouldRemediate(file *File, include []string) bool {
	if len(file.Remediation) > 0 && (include[0] == "all" || utils.Contains(file.SimilarityID, include)) {
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
func willRemediate(remediated []string, originalFileName string, remediation *Remediation) bool {
	// create temporary file
	tmpFile := filepath.Join(os.TempDir(), "temporary-remediation-"+utils.NextRandom()+filepath.Ext(originalFileName))
	f, err := os.OpenFile(tmpFile, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, os.ModePerm)

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
	results, err := scanTmpFile(tmpFile, remediation.QueryID, content)

	if err != nil {
		log.Error().Msgf("failed to get results of query %s: %s", remediation.QueryID, err)
		return false
	}

	return removedSimilarityID(results, remediation.SimilarityID)
}

func removedSimilarityID(results []model.Vulnerability, similarity string) bool {
	for i := range results {
		result := results[i]

		if result.SimilarityID == similarity {
			log.Info().Msgf("failed to remediate '%s'", similarity)
			return false
		}
	}
	return true
}

// CreateTempFile creates a temporary file with the content as the file pointed in the filePathCopyFrom
func CreateTempFile(filePathCopyFrom, tmpFilePath string) string {
	filepath.Clean(filePathCopyFrom)
	filepath.Clean(tmpFilePath)
	f, err := os.OpenFile(tmpFilePath, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, os.ModePerm)

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
