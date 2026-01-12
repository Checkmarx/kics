package comment_test

import (
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/parser/bicep/comment"
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
		"ignore-line-inline": []byte(`
		resource aksCluster1 'Microsoft.ContainerService/managedClusters@2020-02-01' = {
			name: 'aksCluster1'
			location: resourceGroup().location
			properties: { // kics-scan ignore-line
				kubernetesVersion: '1.15.7'
				dnsPrefix: 'dnsprefix'
			}
		}
		`),
		"ignore-full-file": []byte(`
		// kics-scan ignore
		resource aksCluster1 'Microsoft.ContainerService/managedClusters@2020-02-01' = {
			name: 'aksCluster1'
			location: resourceGroup().location
			properties: {
				kubernetesVersion: '1.15.7'
			}
		}
		`),
		"ignore-block-multiple": []byte(`
		// kics-scan ignore-block
		resource aksCluster1 'Microsoft.ContainerService/managedClusters@2020-02-01' = {
			name: 'aksCluster1'
		}
		resource aksCluster2 'Microsoft.ContainerService/managedClusters@2020-02-01' = {
			name: 'aksCluster2'
		}
		`),
		"ignore-block-property": []byte(`
		resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
			name: 'storageaccountname'
			// kics-scan ignore-block
			sku: {
				name: 'Standard_LRS'
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
		want     comment.IgnoreMap
	}{
		{
			name:     "TestComment_ProcessLines: ignore-block",
			content:  samples["ignore-block"],
			filename: "",
			want: comment.IgnoreMap{
				model.IgnoreBlock: []comment.Pos{
					{Line: 3, Column: 3, Byte: 107, BlockStart: 3, BlockEnd: 24},
				},
				model.IgnoreLine: []comment.Pos{},
				model.IgnoreComment: []comment.Pos{
					{Line: 11, Column: 0, Byte: 0},
					{Line: 14, Column: 0, Byte: 0},
				},
			},
		},
		{
			name:     "TestComment_ProcessLines: ignore-line",
			content:  samples["ignore-line"],
			filename: "",
			want: comment.IgnoreMap{
				model.IgnoreBlock: []comment.Pos{},
				model.IgnoreLine: []comment.Pos{
					{Line: 8, Column: 5, Byte: 233, BlockStart: 6, BlockEnd: 9},
					{Line: 15, Column: 5, Byte: 422, BlockStart: 10, BlockEnd: 24},
				},
				model.IgnoreComment: []comment.Pos{
					{Line: 11, Column: 0, Byte: 0, BlockStart: 0, BlockEnd: 0},
					{Line: 15, Column: 0, Byte: 0, BlockStart: 0, BlockEnd: 0},
				},
			},
		},
		{
			name:     "TestComment_ProcessLines: ignore-line-inline",
			content:  samples["ignore-line-inline"],
			filename: "",
			want: comment.IgnoreMap{
				model.IgnoreBlock: []comment.Pos{},
				model.IgnoreLine: []comment.Pos{
					{Line: 5, Column: 17, Byte: 186, BlockStart: 2, BlockEnd: 8},
				},
				model.IgnoreComment: []comment.Pos{},
			},
		},
		{
			name:     "TestComment_ProcessLines: ignore-full-file",
			content:  samples["ignore-full-file"],
			filename: "",
			want: comment.IgnoreMap{
				model.IgnoreBlock: []comment.Pos{},
				model.IgnoreLine:  []comment.Pos{},
				model.IgnoreComment: []comment.Pos{
					{Line: 1, Column: 0, Byte: 0, BlockStart: 0, BlockEnd: 0},
				},
			},
		},
		{
			name:     "TestComment_ProcessLines: ignore-block-multiple",
			content:  samples["ignore-block-multiple"],
			filename: "",
			want: comment.IgnoreMap{
				model.IgnoreBlock: []comment.Pos{
					{Line: 3, Column: 2, Byte: 111, BlockStart: 3, BlockEnd: 5},
				},
				model.IgnoreLine:    []comment.Pos{},
				model.IgnoreComment: []comment.Pos{},
			},
		},
		{
			name:     "TestComment_ProcessLines: ignore-block-property",
			content:  samples["ignore-block-property"],
			filename: "",
			want: comment.IgnoreMap{
				model.IgnoreBlock: []comment.Pos{
					{Line: 5, Column: 3, Byte: 146, BlockStart: 5, BlockEnd: 7},
				},
				model.IgnoreLine:    []comment.Pos{},
				model.IgnoreComment: []comment.Pos{},
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			linesInfo := comment.GetLinesInfo(string(tt.content))
			ignore := comment.ProcessLines(linesInfo)

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
			want:     []int{3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 11, 14},
		},
		{
			name:     "TestComment_GetIgnoreLines: ignore-line",
			content:  samples["ignore-line"],
			filename: "",
			want:     []int{8, 15, 11, 15},
		},
		{
			name:     "TestComment_GetIgnoreLines: ignore-line-inline",
			content:  samples["ignore-line-inline"],
			filename: "",
			want:     []int{5},
		},
		{
			name:     "TestComment_GetIgnoreLines: ignore-full-file",
			content:  samples["ignore-full-file"],
			filename: "",
			want:     []int{1},
		},
		{
			name:     "TestComment_GetIgnoreLines: ignore-block-multiple",
			content:  samples["ignore-block-multiple"],
			filename: "",
			want:     []int{3, 4, 5},
		},
		{
			name:     "TestComment_GetIgnoreLines: ignore-block-property",
			content:  samples["ignore-block-property"],
			filename: "",
			want:     []int{5, 6, 7},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			linesInfo := comment.GetLinesInfo(string(tt.content))
			ignore := comment.ProcessLines(linesInfo)

			GetIgnoreLines := comment.GetIgnoreLines(ignore)

			// GetIgnoreLines test
			if !reflect.DeepEqual(GetIgnoreLines, tt.want) {
				t.Errorf("ProcessLines() = %v, want %v", GetIgnoreLines, tt.want)
			}
		})
	}
}
