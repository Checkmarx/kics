package model

type SummaryItemFile struct {
	FileName         string    `json:"file_name"`
	Line             int       `json:"line"`
	IssueType        IssueType `json:"issue_type"`
	SearchKey        string    `json:"search_key"`
	KeyExpectedValue string    `json:"expected_value"`
	KeyActualValue   string    `json:"actual_value"`
	Value            *string   `json:"value"`
}

type SummaryItem struct {
	QueryName string            `json:"query_name"`
	QueryID   string            `json:"query_id"`
	Severity  Severity          `json:"severity"`
	Files     []SummaryItemFile `json:"files"`
}

type Summary struct {
	ScannedFiles int           `json:"scanned_files"`
	Queries      []SummaryItem `json:"queries"`
}

func CreateSummary(files FileMetadatas, vulnerabilities []Vulnerability) Summary {
	q := make(map[string]SummaryItem, len(vulnerabilities))
	for i := range vulnerabilities {
		item := vulnerabilities[i]
		if _, ok := q[item.QueryName]; !ok {
			q[item.QueryName] = SummaryItem{
				QueryName: item.QueryName,
				QueryID:   item.QueryID,
				Severity:  item.Severity,
			}
		}

		qItem := q[item.QueryName]
		qItem.Files = append(qItem.Files, SummaryItemFile{
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

	queries := make([]SummaryItem, 0, len(q))
	for _, i := range q {
		queries = append(queries, i)
	}

	return Summary{
		ScannedFiles: len(files),
		Queries:      queries,
	}
}
