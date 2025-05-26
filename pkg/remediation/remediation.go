package remediation

import (
	"encoding/json"
	"os"
	"path/filepath"
	"sort"
	"strings"

	"github.com/rs/zerolog/log"
)

// Report includes all query results
type Report struct {
	Queries []Query `json:"queries"`
}

// Query includes all the files that presents a result related to the queryID
type Query struct {
	Files   []File `json:"files"`
	QueryID string `json:"query_id"`
}

// File presents the result information related to the file
type File struct {
	FilePath        string `json:"file_name"`
	Line            int    `json:"line"`
	Remediation     string `json:"remediation"`
	RemediationType string `json:"remediation_type"`
	SimilarityID    string `json:"similarity_id"`
	SearchKey       string `json:"search_key"`
	ExpectedValue   string `json:"expected_value"`
	ActualValue     string `json:"actual_value"`
}

// Remediation presents all the relevant information for the fix
type Remediation struct {
	Line          int
	Remediation   string
	SimilarityID  string
	QueryID       string
	SearchKey     string
	ExpectedValue string
	ActualValue   string
}

// Set includes all the replacements and additions related to a file
type Set struct {
	Replacement []Remediation
	Addition    []Remediation
}

// RemediateFile remediationSets the replacements first and secondly, the additions sorted down
func (s *Summary) RemediateFile(filePath string, remediationSet Set, openAPIResolveReferences bool, maxResolverDepth int) error {
	filepath.Clean(filePath)
	content, err := os.ReadFile(filePath)

	if err != nil {
		log.Error().Msgf("failed to read file: %s", err)
		return err
	}

	lines := strings.Split(string(content), "\n")

	// do replacements first
	if len(remediationSet.Replacement) > 0 {
		for i := range remediationSet.Replacement {
			r := remediationSet.Replacement[i]
			remediatedLines := replacement(&r, lines)
			if len(remediatedLines) > 0 && willRemediate(remediatedLines, filePath, &r, openAPIResolveReferences, maxResolverDepth) {
				lines = s.writeRemediation(remediatedLines, lines, filePath, r.SimilarityID)
			}
		}
	}

	// do additions after
	if len(remediationSet.Addition) > 0 {
		// descending order
		sort.Slice(remediationSet.Addition, func(i, j int) bool {
			return remediationSet.Addition[i].Line > remediationSet.Addition[j].Line
		})

		for i := range remediationSet.Addition {
			a := remediationSet.Addition[i]
			remediatedLines := addition(&a, &lines)
			if len(remediatedLines) > 0 && willRemediate(remediatedLines, filePath, &a, openAPIResolveReferences, maxResolverDepth) {
				lines = s.writeRemediation(remediatedLines, lines, filePath, a.SimilarityID)
			}
		}
	}

	return nil
}

// ReplacementInfo presents the relevant information to do the replacement
type ReplacementInfo struct {
	Before string `json:"before"`
	After  string `json:"after"`
}

func replacement(r *Remediation, lines []string) []string {
	originalLine := lines[r.Line-1]

	var replacement ReplacementInfo
	err := json.Unmarshal([]byte(r.Remediation), &replacement)

	if err != nil || replacement == (ReplacementInfo{}) {
		return []string{}
	}

	remediated := strings.Replace(lines[r.Line-1], replacement.Before, replacement.After, 1)

	if originalLine == remediated {
		log.Info().Msgf("remediation '%s' is already done", r.SimilarityID)
		return []string{}
	}

	// replace the original line with remediation
	lines[r.Line-1] = remediated

	return lines
}

func addition(r *Remediation, lines *[]string) []string {
	fatherNumberLine := r.Line - 1

	if len(*lines) <= fatherNumberLine+1 {
		return []string{}
	}

	firstLine := strings.Split(r.Remediation, "\n")[0]

	if strings.TrimSpace((*lines)[fatherNumberLine+1]) == strings.TrimSpace(firstLine) {
		log.Info().Msgf("remediation '%s' is already done", r.SimilarityID)
		return []string{}
	}

	begin := make([]string, len(*lines))
	end := make([]string, len(*lines))

	copy(begin, *lines)
	copy(end, *lines)

	begin = begin[:fatherNumberLine+1]
	end = end[fatherNumberLine+1:]

	before := getBefore((*lines)[fatherNumberLine+1])

	remediation := begin
	remediation = append(remediation, before+r.Remediation)
	remediation = append(remediation, end...)

	return remediation
}

const (
	FilePermMode = 0777
)

func (s *Summary) writeRemediation(remediatedLines, lines []string, filePath, similarityID string) []string {
	remediated := []byte(strings.Join(remediatedLines, "\n"))

	mode := os.FileMode(FilePermMode)

	if err := os.WriteFile(filePath, remediated, mode); err != nil {
		log.Error().Msgf("failed to write file: %s", err)
		return lines
	}

	log.Info().Msgf("file '%s' was remediated with '%s'", filePath, similarityID)
	s.ActualRemediationDoneNumber++

	return remediatedLines
}
