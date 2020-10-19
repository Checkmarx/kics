package model

type SeveritySummary struct {
	ScanID           string            `json:"scanId"`
	SeverityCounters []SeverityCounter `json:"severityCounters"`
	TotalCounter     int               `json:"totalCounter"`
}

type SeverityCounter struct {
	Severity Severity `json:"severity"`
	Counter  int      `json:"counter"`
}

type FailedFile struct {
	FileName         string    `json:"file_name"`
	Line             int       `json:"line"`
	IssueType        IssueType `json:"issue_type"`
	SearchKey        string    `json:"search_key"`
	KeyExpectedValue string    `json:"expected_value"`
	KeyActualValue   string    `json:"actual_value"`
	Value            *string   `json:"value"`
}

type FailedQuery struct {
	QueryName string       `json:"query_name"`
	QueryID   string       `json:"query_id"`
	Severity  Severity     `json:"severity"`
	Files     []FailedFile `json:"files"`
}

type Counters struct {
	ScannedFiles           int `json:"files_scanned"`
	FailedToScanFiles      int `json:"files_failed_to_scan"`
	TotalQueries           int `json:"queries_total"`
	FailedToExecuteQueries int `json:"queries_failed_to_execute"`
}

type Summary struct {
	Counters
	FailedQueries []FailedQuery `json:"queries"`
}

func CreateSummary(counters Counters, vulnerabilities []Vulnerability) Summary {
	q := make(map[string]FailedQuery, len(vulnerabilities))
	for i := range vulnerabilities {
		item := vulnerabilities[i]
		if _, ok := q[item.QueryName]; !ok {
			q[item.QueryName] = FailedQuery{
				QueryName: item.QueryName,
				QueryID:   item.QueryID,
				Severity:  item.Severity,
			}
		}

		qItem := q[item.QueryName]
		qItem.Files = append(qItem.Files, FailedFile{
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

	queries := make([]FailedQuery, 0, len(q))
	for _, i := range q {
		queries = append(queries, i)
	}

	return Summary{
		Counters:      counters,
		FailedQueries: queries,
	}
}
