package utils

import (
	"encoding/json"
	"encoding/xml"
	"os"
	"path/filepath"
	"testing"

	reportModel "github.com/Checkmarx/kics/v2/pkg/report/model"
	"github.com/stretchr/testify/require"
)

// XMLToJSON - converts XML to JSON Structure
func XMLToJSON(t *testing.T, filename, model string) []byte {
	cwd, _ := os.Getwd()
	filePath := filepath.Join("output", filename)
	fullPath := filepath.Join(cwd, filePath)

	file, err := ReadFixture(filePath, cwd)
	require.NoError(t, err, "Error reading file: %s", fullPath)

	switch model {
	default:
		return []byte{}
	case "junit":
		data := reportModel.NewJUnitReport("")
		return readXMLasJSON(t, fullPath, file, data)
	case "cyclonedx":
		data := CycloneSchema{}
		return readXMLasJSON(t, fullPath, file, &data)
	}
}

func readXMLasJSON(t *testing.T, fullPath, file string, data interface{}) []byte {
	err := xml.Unmarshal([]byte(file), &data)
	require.NoError(t, err, "Error unmarshalling file: %s", fullPath)

	jsonData, err := json.Marshal(data)
	require.NoError(t, err, "Error marshaling file: %s", fullPath)

	return jsonData
}

// CycloneSchema is the struct used to unmarshal the cyclonedx xml
type CycloneSchema struct {
	XMLName      xml.Name `xml:"bom"`
	XMLNS        string   `xml:"xmlns,attr"`
	XMLNSV       string   `xml:"v,attr"`
	SerialNumber string   `xml:"serialNumber,attr"`
	Version      string   `xml:"version,attr"`
	Metadata     struct {
		Timestamp string `xml:"timestamp"`
		Tools     []struct {
			Vendor  string `xml:"vendor"`
			Name    string `xml:"name"`
			Version string `xml:"version"`
		} `xml:"tools>tool"`
	} `xml:"metadata"`
	Components struct {
		Components []struct {
			Type    string `xml:"type,attr"`
			BomRef  string `xml:"bom-ref,attr"`
			Name    string `xml:"name"`
			Version string `xml:"version"`
			Hashes  []struct {
				Alg     string `xml:"alg,attr"`
				Content string `xml:",chardata"`
			} `xml:"hashes>hash"`
			Purl            string `xml:"purl"`
			Vulnerabilities []struct {
				Ref    string `xml:"ref,attr"`
				ID     string `xml:"id"`
				CWE    string `xml:"cwe"`
				Source struct {
					Name string `xml:"name"`
					URL  string `xml:"url"`
				} `xml:"source"`
				Ratings []struct {
					Severity string `xml:"severity"`
					Method   string `xml:"method"`
				} `xml:"ratings>rating"`
				Description     string `xml:"description"`
				Recommendations []struct {
					Recommendation string `xml:"Recommendation"`
				} `xml:"recommendations>recommendation"`
			} `xml:"vulnerabilities>vulnerability"`
		} `xml:"component"`
	} `xml:"components"`
}
