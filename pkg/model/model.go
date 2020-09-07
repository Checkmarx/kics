package model

import (
	"strconv"
	"strings"
)

const (
	KindTerraform         FileMetadataKind = "TF"
	emptyJSONStringLength int              = 2
)

type FileMetadataKind string

type FileMetadata struct {
	ID           int
	ScanID       string `db:"scan_id"`
	JSONData     string `db:"json_data"`
	OriginalData string `db:"orig_data"`
	Kind         FileMetadataKind
	FileName     string `db:"file_name"`
	JSONHash     uint32 `db:"json_hash"`
}

type QueryMetadata struct {
	ID       int
	FileName string
	Content  string
	Filter   string
}

type Vulnerability struct {
	ID        int
	ScanID    string `db:"scan_id"`
	FileID    int    `db:"file_id"`
	QueryName string `db:"query_name"`
	Severity  string
	Line      *int
	Output    string
}

type FileMetadatas []FileMetadata

func (m FileMetadatas) ToMap() map[string]FileMetadata {
	c := make(map[string]FileMetadata, len(m))
	for _, i := range m {
		c[strconv.Itoa(i.ID)] = i
	}

	return c
}

func (m FileMetadatas) CombineToJSON() string {
	retVal := "{\"All\"   :   ["
	if len(m) > 0 {
		for i, cur := range m {
			cJSON := strings.TrimSpace(cur.JSONData)
			if len(cJSON) <= emptyJSONStringLength { // empty json or string
				continue
			}

			curJSON := "{\"CxId\": \"" + strconv.Itoa(cur.ID) + "\",\n"
			curJSON += "\"CxFile\": \"" + cur.FileName + "\",\n"
			curJSON += cJSON[1:]

			retVal += curJSON + "\n"
			if i < len(m)-1 { // not the last element
				retVal += ",\n"
			}
		}
	}

	retVal += "]}"

	return retVal
}
