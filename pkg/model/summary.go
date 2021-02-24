package model

// SeveritySummary contains scans' result numbers, how many vulnerabilities of each severity was detected
type SeveritySummary struct {
	ScanID           string           `json:"scan_id"`
	SeverityCounters map[Severity]int `json:"severity_counters"`
	TotalCounter     int              `json:"total_counter"`
}

// VulnerableFile contains information of a vulnerable file and where the vulnerability was found
type VulnerableFile struct {
	FileName         string    `json:"file_name"`
	SimilarityID     string    `json:"similarity_id"`
	Line             int       `json:"line"`
	VulnLines        VulnLines `json:"vulnLines"`
	IssueType        IssueType `json:"issue_type"`
	SearchKey        string    `json:"search_key"`
	SearchValue      string    `json:"search_value"`
	KeyExpectedValue string    `json:"expected_value"`
	KeyActualValue   string    `json:"actual_value"`
	Value            *string   `json:"value"`
}

// VulnerableQuery contains a query that tested positive ID, name, severity and a list of files that tested vulnerable
type VulnerableQuery struct {
	QueryName   string           `json:"query_name"`
	QueryID     string           `json:"query_id"`
	Category    string           `json:"category"`
	Description string           `json:"description"`
	Severity    Severity         `json:"severity"`
	Platform    string           `json:"platform"`
	Files       []VulnerableFile `json:"files"`
}

// Counters hold information about how many files were scanned, parsed, failed to be scaned, the total of queries
// and how many queries failed to execute
type Counters struct {
	ScannedFiles           int `json:"files_scanned"`
	ParsedFiles            int `json:"files_parsed"`
	FailedToScanFiles      int `json:"files_failed_to_scan"`
	TotalQueries           int `json:"queries_total"`
	FailedToExecuteQueries int `json:"queries_failed_to_execute"`
	FailedSimilarityID     int `json:"queries_failed_to_compute_similarity_id"`
}

// Summary is a report of a single scan
type Summary struct {
	Counters
	Queries []VulnerableQuery `json:"queries"`
	SeveritySummary
}

// CreateSummary creates a report for a single scan, based on its scanID
func CreateSummary(counters Counters, vulnerabilities []Vulnerability, scanID string) Summary {
	q := make(map[string]VulnerableQuery, len(vulnerabilities))
	severitySummary := SeveritySummary{
		ScanID: scanID,
	}
	for i := range vulnerabilities {
		item := vulnerabilities[i]
		if _, ok := q[item.QueryName]; !ok {
			q[item.QueryName] = VulnerableQuery{
				QueryName:   item.QueryName,
				QueryID:     item.QueryID,
				Category:    item.Category,
				Description: item.Description,
				Platform:    item.Platform,
				Severity:    item.Severity,
			}
		}

		qItem := q[item.QueryName]
		qItem.Files = append(qItem.Files, VulnerableFile{
			FileName:         item.FileName,
			SimilarityID:     item.SimilarityID,
			Line:             item.Line,
			VulnLines:        item.VulnLines,
			IssueType:        item.IssueType,
			SearchKey:        item.SearchKey,
			SearchValue:      item.SearchValue,
			KeyExpectedValue: item.KeyExpectedValue,
			KeyActualValue:   item.KeyActualValue,
			Value:            item.Value,
		})

		q[item.QueryName] = qItem
	}

	queries := make([]VulnerableQuery, 0, len(q))
	sevs := map[Severity]int{"INFO": 0, "LOW": 0, "MEDIUM": 0, "HIGH": 0}
	for _, i := range q {
		queries = append(queries, i)
		sevs[i.Severity] += len(i.Files)
		severitySummary.TotalCounter += len(i.Files)
	}
	severitySummary.SeverityCounters = sevs

	return Summary{
		Counters:        counters,
		Queries:         queries,
		SeveritySummary: severitySummary,
	}
}
