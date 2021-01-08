package model

type SeveritySummary struct {
	ScanID           string           `json:"scanId"`
	SeverityCounters map[Severity]int `json:"severityCounters"`
	TotalCounter     int              `json:"totalCounter"`
}

// type SeverityCounter struct {
// 	Severity Severity `json:"severity"`
// 	Counter  int      `json:"counter"`
// }

type VulnerableFile struct {
	FileName         string    `json:"file_name"`
	Line             int       `json:"line"`
	IssueType        IssueType `json:"issue_type"`
	SearchKey        string    `json:"search_key"`
	KeyExpectedValue string    `json:"expected_value"`
	KeyActualValue   string    `json:"actual_value"`
	Value            *string   `json:"value"`
}

type VulnerableQuery struct {
	QueryName string           `json:"query_name"`
	QueryID   string           `json:"query_id"`
	Severity  Severity         `json:"severity"`
	Files     []VulnerableFile `json:"files"`
}

type Counters struct {
	ScannedFiles           int `json:"files_scanned"`
	ParsedFiles            int `json:"files_parsed"`
	FailedToScanFiles      int `json:"files_failed_to_scan"`
	TotalQueries           int `json:"queries_total"`
	FailedToExecuteQueries int `json:"queries_failed_to_execute"`
}

type Summary struct {
	Counters
	Queries []VulnerableQuery `json:"queries"`
	SeveritySummary
}

func CreateSummary(counters Counters, vulnerabilities []Vulnerability, scanID string) Summary {
	q := make(map[string]VulnerableQuery, len(vulnerabilities))
	severitySummary := SeveritySummary{
		ScanID: scanID,
	}
	for i := range vulnerabilities {
		item := vulnerabilities[i]
		if _, ok := q[item.QueryName]; !ok {
			q[item.QueryName] = VulnerableQuery{
				QueryName: item.QueryName,
				QueryID:   item.QueryID,
				Severity:  item.Severity,
			}
		}

		qItem := q[item.QueryName]
		qItem.Files = append(qItem.Files, VulnerableFile{
			FileName:         item.FileName,
			Line:             item.Line,
			IssueType:        item.IssueType,
			SearchKey:        item.SearchKey,
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
