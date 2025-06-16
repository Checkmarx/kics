package comment

import (
	"bufio"
	"reflect"
	"strings"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/parser/bicep/antlr/parser"
	"github.com/antlr4-go/antlr/v4"
)

// Helper function to get lines info from content (replicates the functionality from parser package)
func getLinesInfoFromContent(content string) []LineInfo {
	var linesInfo []LineInfo
	scanner := bufio.NewScanner(strings.NewReader(content))
	lineNumber := 0
	byteOffset := 0

	type blockInfo struct {
		BlockType string
		StartLine int
		EndLine   int
	}

	var currentBlock blockInfo
	var blockStack []blockInfo

	for scanner.Scan() {
		line := scanner.Text()
		trimmedLine := strings.TrimSpace(line)
		lineBytes := []byte(line)
		lineLength := len(lineBytes)

		// Create a new lexer instance for the current line
		lineLexer := parser.NewbicepLexer(antlr.NewInputStream(line))
		tokens := lineLexer.GetAllTokens()

		if len(blockStack) > 0 {
			currentBlock = blockStack[len(blockStack)-1]
		}

		if strings.HasSuffix(trimmedLine, "{") {
			currentBlock = blockInfo{
				BlockType: trimmedLine,
				StartLine: lineNumber,
			}
			blockStack = append(blockStack, currentBlock)
		} else if strings.Contains(trimmedLine, "}") {
			if len(blockStack) > 0 {
				currentBlock.EndLine = lineNumber
				for i := range linesInfo {
					if linesInfo[i].Block.StartLine == currentBlock.StartLine {
						linesInfo[i].Block.EndLine = lineNumber
					}
				}
				blockStack = blockStack[:len(blockStack)-1]
			}
		}

		// Determine the type of the line based on the tokens
		lineType := "other"
		if len(tokens) > 0 {
			symbolicNames := lineLexer.GetSymbolicNames()
			if tokens[0].GetTokenType() < len(symbolicNames) {
				lineType = symbolicNames[tokens[0].GetTokenType()]
			}
		}

		lineInfo := LineInfo{
			Type: lineType,
			Bytes: struct {
				Bytes  []byte
				String string
			}{
				Bytes:  lineBytes,
				String: line,
			},
			Range: struct {
				Start struct {
					Line   int
					Column int
					Byte   int
				}
				End struct {
					Line   int
					Column int
					Byte   int
				}
			}{
				Start: struct {
					Line   int
					Column int
					Byte   int
				}{
					Line:   lineNumber,
					Column: 0,
					Byte:   byteOffset,
				},
				End: struct {
					Line   int
					Column int
					Byte   int
				}{
					Line:   lineNumber,
					Column: lineLength,
					Byte:   byteOffset + lineLength,
				},
			},
			Block: struct {
				BlockType string
				StartLine int
				EndLine   int
			}{
				BlockType: currentBlock.BlockType,
				StartLine: currentBlock.StartLine,
				EndLine:   currentBlock.EndLine,
			},
		}

		linesInfo = append(linesInfo, lineInfo)
		lineNumber++
		byteOffset += lineLength + 1 // +1 for the newline character
	}

	return linesInfo
}

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
			linesInfo := getLinesInfoFromContent(string(tt.content))
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
			linesInfo := getLinesInfoFromContent(string(tt.content))
			ignore := ProcessLines(linesInfo)

			GetIgnoreLines := GetIgnoreLines(ignore)

			// GetIgnoreLines test
			if !reflect.DeepEqual(GetIgnoreLines, tt.want) {
				t.Errorf("ProcessLines() = %v, want %v", GetIgnoreLines, tt.want)
			}
		})
	}
}
