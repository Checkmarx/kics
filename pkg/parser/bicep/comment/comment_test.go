package comment

import (
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/parser/bicep/antlr/parser"
	"github.com/antlr4-go/antlr/v4"
)

var (
	samples = map[string][]byte{
		"ignore-block": []byte(`
			// kics-scan ignore-block
			resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
				name: 'storageAccountName'
				location: 'location'
				kind: storageAccountKind
				sku: {
					name: storageAccountType
				}
				properties: {
					accessTier: accessTier
					// This is a non-kics comment
					minimumTlsVersion: 'TLS1_2'
					publicNetworkAccess: 'Enabled'
					allowBlobPublicAccess: false // Also a non-kics comment
					allowSharedKeyAccess: false
					defaultToOAuthAuthentication: true
					supportsHttpsTrafficOnly: true
					networkAcls: {
						bypass: 'AzureServices'
						defaultAction: 'Allow'
					}
				}
			}
  		`),
		"ignore-line": []byte(`
		resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
				name: 'storageAccountName'
				location: 'location'
				kind: storageAccountKind
				sku: {
					// kics-scan ignore-line
					name: storageAccountType
				}
				properties: {
					accessTier: accessTier
					// This is a non-skipped comment
					minimumTlsVersion: 'TLS1_2'
					// kics-scan ignore-line
					publicNetworkAccess: 'Enabled'
					allowBlobPublicAccess: false // Also a non-skipped comment
					allowSharedKeyAccess: false
					defaultToOAuthAuthentication: true
					supportsHttpsTrafficOnly: true
					networkAcls: {
						bypass: 'AzureServices'
						defaultAction: 'Allow'
					}
				}
			}
		`),
	}
)

// TestComment_ProcessLines tests the ignore lines from retrieved comments
func TestComment_ProcessLines(t *testing.T) {
	tests := []struct {
		name     string
		content  []byte
		filename string
		want     IgnoreMap
	}{
		{
			name:     "TestComment_ProcessLines: ignore-block",
			content:  samples["ignore-block"],
			filename: "",
			want: IgnoreMap{
				model.IgnoreBlock: []Pos{
					{Line: 3, Column: 77, Byte: 107, BlockStart: 3, BlockEnd: 23},
				},
				model.IgnoreLine: []Pos{},
				model.IgnoreComment: []Pos{
					{Line: 11, Column: 0, Byte: 0},
				},
			},
		},
		{
			name:     "TestComment_ProcessLines: ignore-line",
			content:  samples["ignore-line"],
			filename: "",
			want: IgnoreMap{
				model.IgnoreBlock: []Pos{},
				model.IgnoreLine: []Pos{
					{Line: 8, Column: 29, Byte: 233, BlockStart: 6, BlockEnd: 8},
					{Line: 15, Column: 35, Byte: 422, BlockStart: 10, BlockEnd: 23},
				},
				model.IgnoreComment: []Pos{
					{Line: 11, Column: 0, Byte: 0, BlockStart: 0, BlockEnd: 0},
				},
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			stream := antlr.NewInputStream(string(tt.content))

			lexer := parser.NewbicepLexer(stream)
			linesInfo := lexer.GetLinesInfo()
			ignore := ProcessLines(linesInfo)

			// IgnoreMap
			if !reflect.DeepEqual(ignore, tt.want) {
				t.Errorf("ProcessLines() = %v, want %v", ignore, tt.want)
			}

		})
	}
}

// TestComment_GetIgnoreLines tests the ignore lines from retrieved comments
func TestComment_GetIgnoreLines(t *testing.T) {
	tests := []struct {
		name     string
		content  []byte
		filename string
		want     []int
	}{
		{
			name:     "TestComment_GetIgnoreLines: ignore-block",
			content:  samples["ignore-block"],
			filename: "",
			want:     []int{3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 11},
		},
		{
			name:     "TestComment_GetIgnoreLines: ignore-line",
			content:  samples["ignore-line"],
			filename: "",
			want:     []int{8, 15, 11},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			stream := antlr.NewInputStream(string(tt.content))

			lexer := parser.NewbicepLexer(stream)
			linesInfo := lexer.GetLinesInfo()
			ignore := ProcessLines(linesInfo)

			GetIgnoreLines := GetIgnoreLines(ignore)

			// GetIgnoreLines test
			if !reflect.DeepEqual(GetIgnoreLines, tt.want) {
				t.Errorf("ProcessLines() = %v, want %v", GetIgnoreLines, tt.want)
			}
		})
	}
}
