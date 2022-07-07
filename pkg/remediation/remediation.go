package remediation

import (
	"encoding/json"
	"os"
	"sort"
	"strings"

	"github.com/rs/zerolog/log"
)

type Result struct {
	Queries []Query `json:"queries"`
}

type Query struct {
	Files   []File `json:"files"`
	QueryID string `json:"query_id"`
}

type File struct {
	FilePath        string `json:"file_name"`
	Line            int    `json:"line"`
	Remediation     string `json:"remediation"`
	RemediationType string `json:"remediation_type"`
	SimilarityID    string `json:"similarity_id"`
}

type Remediation struct {
	Line         int
	Remediation  string
	SimilarityID string
	QueryID      string
}

type Fix struct {
	Replacement []Remediation
	Addition    []Remediation
}

// RemediateFile remediates the replacements first and secondly, the additions sorted down
func (s *Summary) RemediateFile(filePath string, fix Fix) error {
	content, err := os.ReadFile(filePath)

	if err != nil {
		log.Error().Msgf("failed to read file: %s", err)
		return err
	}

	lines := strings.Split(string(content), "\n")

	// do replacements first
	if len(fix.Replacement) > 0 {
		for i := range fix.Replacement {
			r := fix.Replacement[i]
			remediatedLines := replacement(r, lines)
			if len(remediatedLines) > 0 && willRemediate(remediatedLines, filePath, &r) {
				lines = s.writeRemediations(remediatedLines, lines, filePath, r.SimilarityID)
			}
		}
	}

	// do additions after
	if len(fix.Addition) > 0 {
		// descending order
		sort.Slice(fix.Addition, func(i, j int) bool {
			return fix.Addition[i].Line > fix.Addition[j].Line
		})

		for i := range fix.Addition {
			a := fix.Addition[i]
			remediatedLines := addition(a, &lines)
			if len(remediatedLines) > 0 && willRemediate(remediatedLines, filePath, &a) {
				lines = s.writeRemediations(remediatedLines, lines, filePath, a.SimilarityID)
			}
		}
	}

	return nil
}

type ReplacementInfo struct {
	Before string `json:"before"`
	After  string `json:"after"`
}

func replacement(r Remediation, lines []string) []string {
	originalLine := lines[r.Line-1]

	var replacement ReplacementInfo
	err := json.Unmarshal([]byte(r.Remediation), &replacement)

	if err != nil || replacement == (ReplacementInfo{}) {
		return []string{}
	}

	remediated := strings.Replace(lines[r.Line-1], replacement.Before, replacement.After, 1)

	if strings.Contains(originalLine, remediated) {
		log.Info().Msgf("remediation '%s' is already done", r.SimilarityID)
		return []string{}
	}

	// replace the original line with remediation
	lines[r.Line-1] = remediated

	return lines
}

func addition(r Remediation, lines *[]string) []string {
	fatherNumberLine := r.Line - 1

	if len(*lines) <= fatherNumberLine+1 {
		return []string{}
	}

	if strings.Contains((*lines)[fatherNumberLine+1], r.Remediation) {
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

func (s *Summary) writeRemediations(remediatedLines, lines []string, filePath, similarityID string) []string {
	remediated := []byte(strings.Join(remediatedLines, "\n"))

	if err := os.WriteFile(filePath, remediated, os.ModePerm); err != nil {
		log.Error().Msgf("failed to write file: %s", err)
		return lines
	}

	log.Info().Msgf("file '%s' was remediated with '%s'", filePath, similarityID)
	s.ActualRemediationsDoneNumber++

	return remediatedLines
}
