package utils

import (
	"encoding/csv"
	"encoding/json"
	"os"
	"path/filepath"
	"strconv"
	"testing"

	"github.com/stretchr/testify/require"
)

// CSVToJSON - converts CSV to JSON Structure
func CSVToJSON(t *testing.T, filename string) []byte {
	cwd, _ := os.Getwd()
	filePath := filepath.Join("output", filename)
	fullPath := filepath.Join(cwd, filePath)

	csvFile, err := os.Open(filepath.Clean(fullPath))
	require.NoError(t, err, "Error reading file: %s", fullPath)

	reader := csv.NewReader(csvFile)
	reader.FieldsPerRecord = -1
	csvData, err := reader.ReadAll()
	require.NoError(t, err, "Error reading CSV file: %s", fullPath)

	err = csvFile.Close()
	require.NoError(t, err, "Error when closing file: %s", fullPath)

	var csvStruct csvSchema
	var csvItems []csvSchema

	for _, row := range csvData[1:] {
		line, lineErr := strconv.Atoi(row[16])
		require.NoError(t, lineErr, "Error when converting CSV: %s", fullPath)
		searchLine, searchErr := strconv.Atoi(row[19])
		require.NoError(t, searchErr, "Error when converting CSV: %s", fullPath)

		csvStruct.QueryName = row[0]
		csvStruct.QueryID = row[1]
		csvStruct.QueryURI = row[2]
		csvStruct.Severity = row[3]
		csvStruct.Platform = row[4]
		csvStruct.Cwe = row[5]
		csvStruct.RiskScore = row[6]
		csvStruct.CloudProvider = row[7]
		csvStruct.Category = row[8]
		csvStruct.DescriptionID = row[9]
		csvStruct.Description = row[10]
		csvStruct.CISDescriptionIDFormatted = row[11]
		csvStruct.CISDescriptionTitle = row[12]
		csvStruct.CISDescriptionTextFormatted = row[13]
		csvStruct.FileName = row[14]
		csvStruct.SimilarityID = row[15]
		csvStruct.Line = line
		csvStruct.IssueType = row[17]
		csvStruct.SearchKey = row[18]
		csvStruct.SearchLine = searchLine
		csvStruct.SearchValue = row[20]
		csvStruct.ExpectedValue = row[21]
		csvStruct.ActualValue = row[22]
		csvItems = append(csvItems, csvStruct)
	}

	jsondata, err := json.Marshal(csvItems)
	require.NoError(t, err, "Error marshaling file: %s", fullPath)

	return jsondata
}

type csvSchema struct {
	QueryName                   string
	QueryID                     string
	QueryURI                    string
	Severity                    string
	Platform                    string
	Cwe                         string
	RiskScore                   string
	CloudProvider               string
	Category                    string
	DescriptionID               string
	Description                 string
	CISDescriptionIDFormatted   string
	CISDescriptionTitle         string
	CISDescriptionTextFormatted string
	FileName                    string
	SimilarityID                string
	Line                        int
	IssueType                   string
	SearchKey                   string
	SearchLine                  int
	SearchValue                 string
	ExpectedValue               string
	ActualValue                 string
}
