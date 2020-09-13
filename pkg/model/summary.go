package model

type SummaryItemFile struct {
	FileName string `json:"file_name"`
	Line     int    `json:"line"`
}

type SummaryItem struct {
	QueryName string            `json:"query_name"`
	Severity  Severity          `json:"severity"`
	Files     []SummaryItemFile `json:"files"`
}

type Summary struct {
	ScannedFiles int           `json:"scanned_files"`
	Queries      []SummaryItem `json:"queries"`
}

func CreateSummary(files FileMetadatas, items []ResultItem) Summary {
	q := make(map[string]SummaryItem, len(items))
	for _, item := range items {
		if _, ok := q[item.QueryName]; !ok {
			q[item.QueryName] = SummaryItem{
				QueryName: item.QueryName,
				Severity:  item.Severity,
				Files: []SummaryItemFile{{
					FileName: item.FileName,
					Line:     item.Line,
				}},
			}
			continue
		}

		tmp := q[item.QueryName]
		tmp.Files = append(tmp.Files, SummaryItemFile{FileName: item.FileName, Line: item.Line})
		q[item.QueryName] = tmp
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
