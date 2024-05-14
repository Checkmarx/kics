package bicep

import (
	"encoding/json"
	"path/filepath"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/stretchr/testify/require"
)

func TestParser_GetKind(t *testing.T) {
	p := &Parser{}
	require.Equal(t, model.KindBICEP, p.GetKind())
}

func TestParser_SupportedTypes(t *testing.T) {
	p := &Parser{}
	require.Equal(t, map[string]bool{"bicep": true, "azureresourcemanager": true}, p.SupportedTypes())
}

func TestParser_SupportedExtensions(t *testing.T) {
	p := &Parser{}
	require.Equal(t, []string{".bicep"}, p.SupportedExtensions())
}

func Test_Resolve(t *testing.T) {
	parser := &Parser{}
	param := `param vmName string = 'simple-vm'`
	resolved, err := parser.Resolve([]byte(param), "test.bicep", true, 15)
	require.NoError(t, err)
	require.Equal(t, []byte(param), resolved)
}

func TestParser_GetResolvedFiles(t *testing.T) {
	tests := []struct {
		name string
		want map[string]model.ResolvedFile
	}{
		{
			name: "Should test getting empty resolved files",
			want: map[string]model.ResolvedFile{},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			p := &Parser{}
			if got := p.GetResolvedFiles(); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("GetResolvedFiles() = %v, want %v", got, tt.want)
			}
		})
	}
}

// TestParser_StringifyContent tests the StringifyContent function
func TestParser_StringifyContent(t *testing.T) {
	type args struct {
		content []byte
	}
	tests := []struct {
		name    string
		p       *Parser
		args    args
		want    string
		wantErr bool
	}{
		{
			name: "Bicep stringify content",
			p:    &Parser{},
			args: args{
				content: []byte(`param vmName string = 'simple-vm'`),
			},
			want:    `param vmName string = 'simple-vm'`,
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			p := &Parser{}
			got, err := p.StringifyContent(tt.args.content)
			if (err != nil) != tt.wantErr {
				t.Errorf("Parser.StringifyContent() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if got != tt.want {
				t.Errorf("Parser.StringifyContent() = %v, want %v", got, tt.want)
			}
		})
	}
}

// Test_GetCommentToken must get the token that represents a comment
func Test_GetCommentToken(t *testing.T) {
	parser := &Parser{}
	require.Equal(t, "//", parser.GetCommentToken())
}

func TestParseBicepFile(t *testing.T) {
	parser := &Parser{}
	tests := []struct {
		name     string
		filename string
		want     string
		wantErr  bool
	}{
		{
			name:     "Parse Bicep file with Unsuported Content",
			filename: filepath.Join("..", "..", "..", "test", "fixtures", "bicep_test", "unsuported.bicep"),
			want: `{
					"parameters": {
						"diagnosticLogCategoriesToEnable": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 44
								},
								"_kics_type": {
									"_kics_line": 44
								}
							},
							"allowedValues": [
								[
									"allLogs",
									"ConnectedClientList"
								]
							],
							"defaultValue": [
								"allLogs"
							],
							"metadata": {
								"description": "Optional. The name of logs that will be streamed. \"allLogs\" includes all possible logs for the resource."
							},
							"type": "array"
						},
						"diagnosticMetricsToEnable": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 52
								},
								"_kics_type": {
									"_kics_line": 52
								}
							},
							"allowedValues": [
								[
									"AllMetrics"
								]
							],
							"defaultValue": [
								"AllMetrics"
							],
							"metadata": {
								"description": "Optional. The name of metrics that will be streamed."
							},
							"type": "array"
						},
						"diagnosticSettingsName": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 32
								},
								"_kics_type": {
									"_kics_line": 32
								}
							},
							"defaultValue": "'${parameters('name')}-diagnosticSettings'",
							"metadata": {
								"description": "Optional. The name of the diagnostic setting, if deployed."
							},
							"type": "string"
						},
						"diagnosticWorkspaceId": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 35
								},
								"_kics_type": {
									"_kics_line": 35
								}
							},
							"defaultValue": "",
							"metadata": {
								"description": "Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub."
							},
							"type": "string"
						},
						"keyvaultName": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 23
								},
								"_kics_type": {
									"_kics_line": 23
								}
							},
							"metadata": {
								"description": "The name of an existing keyvault, that it will be used to store secrets (connection string)"
							},
							"type": "string"
						},
						"name": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 20
								},
								"_kics_type": {
									"_kics_line": 20
								}
							},
							"maxLength": 63,
							"metadata": {
								"description": "Required. The name of the Redis cache resource. Start and end with alphanumeric. Consecutive hyphens not allowed"
							},
							"minLength": 1,
							"type": "string"
						}
					},
					"resources": [
						{
							"_kics_lines": {
								"_kics__default": {
									"_kics_line": 110
								},
								"_kics_apiVersion": {
									"_kics_line": 110
								},
								"_kics_name": {
									"_kics_line": 111
								},
								"_kics_type": {
									"_kics_line": 110
								}
							},
							"apiVersion": "2022-11-01",
							"identifier": "keyVault",
							"name": "[parameters('keyvaultName')]",
							"type": "Microsoft.KeyVault/vaults"
						},
						{
							"apiVersion": "2021-05-01-preview",
							"identifier": "redisCache_diagnosticSettings",
							"type": "Microsoft.Insights/diagnosticSettings"
						}
					],
					"variables": {
						"diagnosticsLogs": {
							"value": null
						},
						"diagnosticsLogsSpecified": {
							"value": null
						},
						"diagnosticsMetrics": {
							"value": null
						},
						"dogs": {
							"value": [
								{
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 73
										},
										"_kics_age": {
											"_kics_line": 75
										},
										"_kics_name": {
											"_kics_line": 74
										}
									},
									"age": 3,
									"name": "Fido"
								},
								{
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 77
										},
										"_kics_age": {
											"_kics_line": 79
										},
										"_kics_name": {
											"_kics_line": 78
										}
									},
									"age": 7,
									"name": "Rex"
								}
							]
						}
					}
				}`,
		},
		{
			name:     "Parse Bicep file with parameters",
			filename: filepath.Join("..", "..", "..", "test", "fixtures", "bicep_test", "parameters.bicep"),
			want: `{
					"parameters": {
						"array": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 17
								},
								"_kics_type": {
									"_kics_line": 17
								}
							},
							"defaultValue": [
								"string"
							],
							"type": "string"
						},
						"isNumber": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 9
								},
								"_kics_type": {
									"_kics_line": 9
								}
							},
							"defaultValue": true,
							"metadata": {
								"description": "This is a test bool param declaration."
							},
							"type": "bool"
						},
						"middleString": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 12
								},
								"_kics_type": {
									"_kics_line": 12
								}
							},
							"defaultValue": "'teste-${parameters('numberNodes')}${parameters('isNumber')}-teste'",
							"metadata": {
								"description": "This is a test middle string param declaration."
							},
							"type": "string"
						},
						"null": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 19
								},
								"_kics_type": {
									"_kics_line": 19
								}
							},
							"defaultValue": null,
							"type": "string"
						},
						"numberNodes": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 6
								},
								"_kics_type": {
									"_kics_line": 6
								}
							},
							"defaultValue": 2,
							"metadata": {
								"description": "This is a test int param declaration."
							},
							"type": "int"
						},
						"projectName": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 3
								},
								"_kics_type": {
									"_kics_line": 3
								}
							},
							"defaultValue": "[newGuid()]",
							"metadata": {
								"description": "This is a test param with secure declaration."
							},
							"type": "secureString"
						},
						"secObj": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 15
								},
								"_kics_type": {
									"_kics_line": 15
								}
							},
							"defaultValue": false,
							"type": "secureObject"
						}
					},
					"resources": [],
					"variables": {}
				}`,
			wantErr: false,
		},
		{
			name:     "Parse Bicep file with variables",
			filename: filepath.Join("..", "..", "..", "test", "fixtures", "bicep_test", "variables.bicep"),
			want: `{
					"variables": {
						"nicName": {
							"metadata": {
								"description": "This is a test var declaration."
							},
							"value": "myVMNic"
						},
						"storageAccountName": {
							"metadata": {
								"description": "This is a test var declaration."
							},
							"value": "'bootdiags${[uniqueString(resourceGroup().id)]}'"
						}
					},
					"resources": [],
					"parameters": {}
				}`,
			wantErr: false,
		},
		{
			name:     "Parse completed Bicep file",
			filename: filepath.Join("..", "..", "..", "test", "fixtures", "bicep_test", "resources.bicep"),
			want: `{
					"parameters": {
						"OSVersion": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 42
								},
								"_kics_type": {
									"_kics_line": 42
								}
							},
							"allowedValues": [
								[
									"2008-R2-SP1",
									"2012-Datacenter",
									"2012-R2-Datacenter",
									"2016-Nano-Server",
									"2016-Datacenter-with-Containers",
									"2016-Datacenter",
									"2019-Datacenter",
									"2019-Datacenter-Core",
									"2019-Datacenter-Core-smalldisk",
									"2019-Datacenter-Core-with-Containers",
									"2019-Datacenter-Core-with-Containers-smalldisk",
									"2019-Datacenter-smalldisk",
									"2019-Datacenter-with-Containers",
									"2019-Datacenter-with-Containers-smalldisk"
								]
							],
							"defaultValue": "2019-Datacenter",
							"metadata": {
								"description": "The Windows version for the VM. This will pick a fully patched image of this given Windows version."
							},
							"type": "string"
						},
						"adminPassword": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 9
								},
								"_kics_type": {
									"_kics_line": 9
								}
							},
							"metadata": {
								"description": "Password for the Virtual Machine."
							},
							"minLength": 12,
							"type": "secureString"
						},
						"adminUsername": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 4
								},
								"_kics_type": {
									"_kics_line": 4
								}
							},
							"metadata": {
								"description": "Username for the Virtual Machine."
							},
							"type": "string"
						},
						"arrayP": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 136
								},
								"_kics_type": {
									"_kics_line": 136
								}
							},
							"defaultValue": [
								"allLogs",
								"ConnectedClientList"
							],
							"type": "array"
						},
						"capacity": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 65
								},
								"_kics_type": {
									"_kics_line": 65
								}
							},
							"allowedValues": [
								[
									0,
									1,
									2,
									3,
									4,
									5,
									6
								]
							],
							"defaultValue": 2,
							"metadata": {
								"description": "Optional. The size of the Redis cache to deploy. Valid values: for C (Basic/Standard) family (0, 1, 2, 3, 4, 5, 6), for P (Premium) family (1, 2, 3, 4)."
							},
							"type": "int"
						},
						"diagnosticLogCategoriesToEnable": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 18
								},
								"_kics_type": {
									"_kics_line": 18
								}
							},
							"allowedValues": [
								[
									"allLogs",
									"ConnectedClientList"
								]
							],
							"defaultValue": [
								"allLogs"
							],
							"metadata": {
								"description": "Optional. The name of logs that will be streamed. \"allLogs\" includes all possible logs for the resource."
							},
							"type": "array"
						},
						"diagnosticMetricsToEnable": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 93
								},
								"_kics_type": {
									"_kics_line": 93
								}
							},
							"allowedValues": [
								[
									"AllMetrics"
								]
							],
							"defaultValue": [
								"AllMetrics"
							],
							"metadata": {
								"description": "Optional. The name of metrics that will be streamed."
							},
							"type": "array"
						},
						"diagnosticSettingsName": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 82
								},
								"_kics_type": {
									"_kics_line": 82
								}
							},
							"defaultValue": "'${name}-diagnosticSettings'",
							"metadata": {
								"description": "Optional. The name of the diagnostic setting, if deployed."
							},
							"type": "string"
						},
						"diagnosticWorkspaceId": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 85
								},
								"_kics_type": {
									"_kics_line": 85
								}
							},
							"defaultValue": "",
							"metadata": {
								"description": "Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub."
							},
							"type": "string"
						},
						"enableNonSslPort": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 99
								},
								"_kics_type": {
									"_kics_line": 99
								}
							},
							"defaultValue": false,
							"metadata": {
								"description": "Optional. Specifies whether the non-ssl Redis server port (6379) is enabled."
							},
							"type": "bool"
						},
						"existingContainerSubnetName": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 126
								},
								"_kics_type": {
									"_kics_line": 126
								}
							},
							"metadata": {
								"description": "Name of the subnet to use for cloud shell containers."
							},
							"type": "string"
						},
						"existingStorageSubnetName": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 123
								},
								"_kics_type": {
									"_kics_line": 123
								}
							},
							"metadata": {
								"description": "Name of the subnet to use for storage account."
							},
							"type": "string"
						},
						"existingVNETName": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 120
								},
								"_kics_type": {
									"_kics_line": 120
								}
							},
							"metadata": {
								"description": "Name of the virtual network to use for cloud shell containers."
							},
							"type": "string"
						},
						"hasPrivateLink": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 96
								},
								"_kics_type": {
									"_kics_line": 96
								}
							},
							"defaultValue": false,
							"metadata": {
								"description": "Has the resource private endpoint?"
							},
							"type": "bool"
						},
						"keyvaultName": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 68
								},
								"_kics_type": {
									"_kics_line": 68
								}
							},
							"metadata": {
								"description": "The name of an existing keyvault, that it will be used to store secrets (connection string)"
							},
							"type": "string"
						},
						"location": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 112
								},
								"_kics_type": {
									"_kics_line": 112
								}
							},
							"defaultValue": "[resourceGroup().location]",
							"metadata": {
								"description": "Location for all resources."
							},
							"type": "string"
						},
						"name": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 131
								},
								"_kics_type": {
									"_kics_line": 131
								}
							},
							"maxLength": 63,
							"metadata": {
								"description": "Required. The name of the Redis cache resource. Start and end with alphanumeric. Consecutive hyphens not allowed"
							},
							"minLength": 1,
							"type": "string"
						},
						"parenthesis": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 117
								},
								"_kics_type": {
									"_kics_line": 117
								}
							},
							"defaultValue": "simple-vm",
							"type": "string"
						},
						"redisConfiguration": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 102
								},
								"_kics_type": {
									"_kics_line": 102
								}
							},
							"defaultValue": {
								"_kics_lines": {
									"_kics__default": {
										"_kics_line": 102
									}
								}
							},
							"metadata": {
								"description": "Optional. All Redis Settings. Few possible keys: rdb-backup-enabled,rdb-storage-connection-string,rdb-backup-frequency,maxmemory-delta,maxmemory-policy,notify-keyspace-events,maxmemory-samples,slowlog-log-slower-than,slowlog-max-len,list-max-ziplist-entries,list-max-ziplist-value,hash-max-ziplist-entries,hash-max-ziplist-value,set-max-intset-entries,zset-max-ziplist-entries,zset-max-ziplist-value etc."
							},
							"type": "object"
						},
						"replicasPerMaster": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 106
								},
								"_kics_type": {
									"_kics_line": 106
								}
							},
							"defaultValue": 1,
							"metadata": {
								"description": "Optional. The number of replicas to be created per primary."
							},
							"minValue": 1,
							"type": "int"
						},
						"replicasPerPrimary": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 49
								},
								"_kics_type": {
									"_kics_line": 49
								}
							},
							"defaultValue": 1,
							"metadata": {
								"description": "Optional. The number of replicas to be created per primary."
							},
							"minValue": 1,
							"type": "int"
						},
						"shardCount": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 53
								},
								"_kics_type": {
									"_kics_line": 53
								}
							},
							"defaultValue": 1,
							"metadata": {
								"description": "Optional. The number of shards to be created on a Premium Cluster Cache."
							},
							"minValue": 1,
							"type": "int"
						},
						"skuName": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 76
								},
								"_kics_type": {
									"_kics_line": 76
								}
							},
							"allowedValues": [
								[
									"Basic",
									"Premium",
									"Standard"
								]
							],
							"defaultValue": "Standard",
							"metadata": {
								"description": "Optional, default is Standard. The type of Redis cache to deploy."
							},
							"type": "string"
						},
						"subnetId": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 79
								},
								"_kics_type": {
									"_kics_line": 79
								}
							},
							"defaultValue": "",
							"metadata": {
								"description": "Optional. The full resource ID of a subnet in a virtual network to deploy the Redis cache in. Example format: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/Microsoft.{Network|ClassicNetwork}/VirtualNetworks/vnet1/subnets/subnet1."
							},
							"type": "string"
						},
						"tags": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 45
								},
								"_kics_type": {
									"_kics_line": 45
								}
							},
							"defaultValue": {
								"_kics_lines": {
									"_kics__default": {
										"_kics_line": 45
									}
								}
							},
							"metadata": {
								"description": "Optional. Tags of the resource."
							},
							"type": "object"
						},
						"vmName": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 115
								},
								"_kics_type": {
									"_kics_line": 115
								}
							},
							"defaultValue": "simple-vm",
							"metadata": {
								"description": "Name of the virtual machine."
							},
							"type": "string"
						},
						"vmSize": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 109
								},
								"_kics_type": {
									"_kics_line": 109
								}
							},
							"defaultValue": "Standard_D2_v3",
							"metadata": {
								"description": "Size of the virtual machine."
							},
							"type": "string"
						}
					},
					"resources": [
						{
							"_kics_lines": {
								"_kics__default": {
									"_kics_line": 173
								},
								"_kics_apiVersion": {
									"_kics_line": 172
								},
								"_kics_dependsOn": {
									"_kics_arr": [
										{
											"_kics__default": {
												"_kics_line": 222
											}
										}
									],
									"_kics_line": 222
								},
								"_kics_location": {
									"_kics_line": 175
								},
								"_kics_name": {
									"_kics_line": 174
								},
								"_kics_properties": {
									"_kics_line": 176
								},
								"_kics_type": {
									"_kics_line": 172
								}
							},
							"apiVersion": "2021-03-01",
							"dependsOn": [
								{
									"resourceId": [
										"Microsoft.Network/networkInterfaces",
										"variables('nicName')"
									]
								},
								{
									"resourceId": [
										"Microsoft.Storage/storageAccounts",
										"variables('storageAccountName')"
									]
								}
							],
							"identifier": "vm",
							"location": "[parameters('location')]",
							"metadata": {
								"description": "This is a test description for resources"
							},
							"name": "[parameters('vmName')]",
							"properties": {
								"_kics_lines": {
									"_kics__default": {
										"_kics_line": 176
									},
									"_kics_diagnosticsProfile": {
										"_kics_line": 213
									},
									"_kics_hardwareProfile": {
										"_kics_line": 177
									},
									"_kics_networkProfile": {
										"_kics_line": 206
									},
									"_kics_osProfile": {
										"_kics_line": 180
									},
									"_kics_storageProfile": {
										"_kics_line": 185
									}
								},
								"diagnosticsProfile": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 213
										},
										"_kics_bootDiagnostics": {
											"_kics_line": 214
										}
									},
									"bootDiagnostics": {
										"_kics_lines": {
											"_kics__default": {
												"_kics_line": 214
											},
											"_kics_enabled": {
												"_kics_line": 215
											},
											"_kics_storageUri": {
												"_kics_line": 216
											}
										},
										"enabled": true,
										"storageUri": "[reference(resourceId(Microsoft.Storage/storageAccounts, variables('storageAccountName'))).primaryEndpoints.blob]"
									}
								},
								"hardwareProfile": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 177
										},
										"_kics_vmSize": {
											"_kics_line": 178
										}
									},
									"vmSize": "[parameters('vmSize')]"
								},
								"networkProfile": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 206
										},
										"_kics_networkInterfaces": {
											"_kics_arr": [
												{
													"_kics__default": {
														"_kics_line": 207
													}
												}
											],
											"_kics_line": 207
										}
									},
									"networkInterfaces": [
										{
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 208
												},
												"_kics_id": {
													"_kics_line": 209
												}
											},
											"id": {
												"resourceId": [
													"Microsoft.Network/networkInterfaces",
													"nick"
												]
											}
										}
									]
								},
								"osProfile": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 180
										},
										"_kics_adminPassword": {
											"_kics_line": 183
										},
										"_kics_adminUsername": {
											"_kics_line": 182
										},
										"_kics_computerName": {
											"_kics_line": 181
										}
									},
									"adminPassword": "[parameters('adminPassword')]",
									"adminUsername": "[parameters('adminUsername')]",
									"computerName": "computer"
								},
								"storageProfile": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 185
										},
										"_kics_dataDisks": {
											"_kics_arr": [
												{
													"_kics__default": {
														"_kics_line": 198
													}
												}
											],
											"_kics_line": 198
										},
										"_kics_imageReference": {
											"_kics_line": 186
										},
										"_kics_osDisk": {
											"_kics_line": 192
										}
									},
									"dataDisks": [
										{
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 199
												},
												"_kics_createOption": {
													"_kics_line": 202
												},
												"_kics_diskSizeGB": {
													"_kics_line": 200
												},
												"_kics_lun": {
													"_kics_line": 201
												}
											},
											"createOption": "Empty",
											"diskSizeGB": 1023,
											"lun": 0
										}
									],
									"imageReference": {
										"_kics_lines": {
											"_kics__default": {
												"_kics_line": 186
											},
											"_kics_offer": {
												"_kics_line": 188
											},
											"_kics_publisher": {
												"_kics_line": 187
											},
											"_kics_sku": {
												"_kics_line": 189
											},
											"_kics_version": {
												"_kics_line": 190
											}
										},
										"offer": "WindowsServer",
										"publisher": "MicrosoftWindowsServer",
										"sku": "[parameters('OSVersion')]",
										"version": "latest"
									},
									"osDisk": {
										"_kics_lines": {
											"_kics__default": {
												"_kics_line": 192
											},
											"_kics_createOption": {
												"_kics_line": 193
											},
											"_kics_managedDisk": {
												"_kics_line": 194
											}
										},
										"createOption": "FromImage",
										"managedDisk": {
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 194
												},
												"_kics_storageAccountType": {
													"_kics_line": 195
												}
											},
											"storageAccountType": "StandardSSD_LRS"
										}
									}
								}
							},
							"type": "Microsoft.Compute/virtualMachines"
						},
						{
							"_kics_lines": {
								"_kics__default": {
									"_kics_line": 228
								},
								"_kics_apiVersion": {
									"_kics_line": 228
								},
								"_kics_assignableScopes": {
									"_kics_arr": [
										{
											"_kics__default": {
												"_kics_line": 238
											}
										}
									],
									"_kics_line": 238
								},
								"_kics_location": {
									"_kics_line": 230
								},
								"_kics_name": {
									"_kics_line": 229
								},
								"_kics_type": {
									"_kics_line": 228
								},
								"_kics_userAssignedIdentities": {
									"_kics_line": 235
								}
							},
							"apiVersion": "2021-03-01",
							"assignableScopes": [
								"[subscription().id]"
							],
							"identifier": "nic",
							"location": null,
							"name": null,
							"type": "Microsoft.Network/networkInterfaces",
							"userAssignedIdentities": {
								"'${[resourceId(Microsoft.ManagedIdentity/userAssignedIdentities, variables('nicName'))]}'": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 236
										}
									}
								},
								"_kics_lines": {
									"_kics_'${[resourceId(Microsoft.ManagedIdentity/userAssignedIdentities, variables('nicName'))]}'": {
										"_kics_line": 236
									},
									"_kics__default": {
										"_kics_line": 235
									}
								}
							}
						},
						{
							"_kics_lines": {
								"_kics__default": {
									"_kics_line": 241
								},
								"_kics_apiVersion": {
									"_kics_line": 241
								},
								"_kics_kind": {
									"_kics_line": 248
								},
								"_kics_location": {
									"_kics_line": 243
								},
								"_kics_name": {
									"_kics_line": 242
								},
								"_kics_properties": {
									"_kics_line": 249
								},
								"_kics_sku": {
									"_kics_line": 244
								},
								"_kics_type": {
									"_kics_line": 241
								}
							},
							"apiVersion": "2019-06-01",
							"identifier": "storageAccount",
							"kind": "StorageV2",
							"location": "[parameters('location')]",
							"name": "[variables('storageAccountName')]",
							"properties": {
								"_kics_lines": {
									"_kics__default": {
										"_kics_line": 249
									},
									"_kics_accessTier": {
										"_kics_line": 278
									},
									"_kics_encryption": {
										"_kics_line": 265
									},
									"_kics_networkAcls": {
										"_kics_line": 250
									},
									"_kics_supportsHttpsTrafficOnly": {
										"_kics_line": 264
									}
								},
								"accessTier": "Cool",
								"encryption": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 265
										},
										"_kics_keySource": {
											"_kics_line": 276
										},
										"_kics_services": {
											"_kics_line": 266
										}
									},
									"keySource": "Microsoft.Storage",
									"services": {
										"_kics_lines": {
											"_kics__default": {
												"_kics_line": 266
											},
											"_kics_blob": {
												"_kics_line": 271
											},
											"_kics_file": {
												"_kics_line": 267
											}
										},
										"blob": {
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 271
												},
												"_kics_enabled": {
													"_kics_line": 273
												},
												"_kics_keyType": {
													"_kics_line": 272
												}
											},
											"enabled": true,
											"keyType": "Account"
										},
										"file": {
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 267
												},
												"_kics_enabled": {
													"_kics_line": 269
												},
												"_kics_keyType": {
													"_kics_line": 268
												}
											},
											"enabled": true,
											"keyType": "Account"
										}
									}
								},
								"networkAcls": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 250
										},
										"_kics_bypass": {
											"_kics_line": 251
										},
										"_kics_defaultAction": {
											"_kics_line": 262
										},
										"_kics_virtualNetworkRules": {
											"_kics_arr": [
												{
													"_kics__default": {
														"_kics_line": 252
													}
												}
											],
											"_kics_line": 252
										}
									},
									"bypass": "None",
									"defaultAction": "Deny",
									"virtualNetworkRules": [
										{
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 253
												},
												"_kics_action": {
													"_kics_line": 255
												},
												"_kics_id": {
													"_kics_line": 254
												}
											},
											"action": "Allow",
											"id": "[variables('containerSubnetRef')]"
										},
										{
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 257
												},
												"_kics_action": {
													"_kics_line": 259
												},
												"_kics_id": {
													"_kics_line": 258
												}
											},
											"action": "Allow",
											"id": "[variables('storageSubnetRef')]"
										}
									]
								},
								"supportsHttpsTrafficOnly": true
							},
							"resources": [
								{
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 282
										},
										"_kics_apiVersion": {
											"_kics_line": 282
										},
										"_kics_name": {
											"_kics_line": 284
										},
										"_kics_parent": {
											"_kics_line": 283
										},
										"_kics_properties": {
											"_kics_line": 289
										},
										"_kics_sku": {
											"_kics_line": 285
										},
										"_kics_type": {
											"_kics_line": 282
										}
									},
									"apiVersion": "2019-06-01",
									"identifier": "storageAccountName_default",
									"name": "default",
									"parent": "storageAccount",
									"properties": {
										"_kics_lines": {
											"_kics__default": {
												"_kics_line": 289
											},
											"_kics_deleteRetentionPolicy": {
												"_kics_line": 290
											}
										},
										"deleteRetentionPolicy": {
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 290
												},
												"_kics_enabled": {
													"_kics_line": 291
												}
											},
											"enabled": false
										}
									},
									"resources": [
										{
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 296
												},
												"_kics_apiVersion": {
													"_kics_line": 296
												},
												"_kics_name": {
													"_kics_line": 298
												},
												"_kics_parent": {
													"_kics_line": 297
												},
												"_kics_properties": {
													"_kics_line": 299
												},
												"_kics_type": {
													"_kics_line": 296
												}
											},
											"apiVersion": "2019-06-01",
											"identifier": "storageAccountName_default_container",
											"name": "container",
											"parent": "storageAccountName_default",
											"properties": {
												"_kics_lines": {
													"_kics__default": {
														"_kics_line": 299
													},
													"_kics_denyEncryptionScopeOverride": {
														"_kics_line": 300
													},
													"_kics_metadata": {
														"_kics_line": 302
													},
													"_kics_publicAccess": {
														"_kics_line": 301
													}
												},
												"denyEncryptionScopeOverride": true,
												"metadata": {
													"_kics_lines": {
														"_kics__default": {
															"_kics_line": 302
														}
													}
												},
												"publicAccess": "Blob"
											},
											"type": "containers"
										}
									],
									"sku": {
										"_kics_lines": {
											"_kics__default": {
												"_kics_line": 285
											},
											"_kics_name": {
												"_kics_line": 286
											},
											"_kics_tier": {
												"_kics_line": 287
											}
										},
										"name": "Standard_LRS",
										"tier": "Standard"
									},
									"type": "blobServices"
								}
							],
							"sku": {
								"_kics_lines": {
									"_kics__default": {
										"_kics_line": 244
									},
									"_kics_name": {
										"_kics_line": 245
									},
									"_kics_tier": {
										"_kics_line": 246
									}
								},
								"name": "Standard_LRS",
								"tier": "Standard"
							},
							"type": "Microsoft.Storage/storageAccounts"
						},
						{
							"_kics_lines": {
								"_kics__default": {
									"_kics_line": 306
								},
								"_kics_apiVersion": {
									"_kics_line": 306
								},
								"_kics_location": {
									"_kics_line": 308
								},
								"_kics_name": {
									"_kics_line": 307
								},
								"_kics_properties": {
									"_kics_line": 311
								},
								"_kics_tags": {
									"_kics_line": 309
								},
								"_kics_type": {
									"_kics_line": 306
								},
								"_kics_zones": {
									"_kics_line": 327
								}
							},
							"apiVersion": "2021-06-01",
							"identifier": "redisCache",
							"location": "[parameters('location')]",
							"name": "[parameters('name')]",
							"properties": {
								"_kics_lines": {
									"_kics__default": {
										"_kics_line": 311
									},
									"_kics_enableNonSslPort": {
										"_kics_line": 312
									},
									"_kics_minimumTlsVersion": {
										"_kics_line": 313
									},
									"_kics_publicNetworkAccess": {
										"_kics_line": 314
									},
									"_kics_redisConfiguration": {
										"_kics_line": 315
									},
									"_kics_redisVersion": {
										"_kics_line": 316
									},
									"_kics_replicasPerMaster": {
										"_kics_line": 317
									},
									"_kics_replicasPerPrimary": {
										"_kics_line": 318
									},
									"_kics_shardCount": {
										"_kics_line": 319
									},
									"_kics_sku": {
										"_kics_line": 320
									},
									"_kics_subnetId": {
										"_kics_line": 325
									}
								},
								"enableNonSslPort": "[parameters('enableNonSslPort')]",
								"minimumTlsVersion": "1.2",
								"publicNetworkAccess": null,
								"redisConfiguration": null,
								"redisVersion": "6",
								"replicasPerMaster": null,
								"replicasPerPrimary": null,
								"shardCount": null,
								"sku": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 320
										},
										"_kics_capacity": {
											"_kics_line": 321
										},
										"_kics_family": {
											"_kics_line": 322
										},
										"_kics_name": {
											"_kics_line": 323
										}
									},
									"capacity": "[parameters('capacity')]",
									"family": null,
									"name": "[parameters('skuName')]"
								},
								"subnetId": null
							},
							"tags": "[parameters('tags')]",
							"type": "Microsoft.Cache/redis",
							"zones": null
						},
						{
							"apiVersion": "2021-05-01-preview",
							"identifier": "redisCache_diagnosticSettings",
							"type": "Microsoft.Insights/diagnosticSettings"
						},
						{
							"_kics_lines": {
								"_kics__default": {
									"_kics_line": 351
								},
								"_kics_apiVersion": {
									"_kics_line": 351
								},
								"_kics_name": {
									"_kics_line": 352
								},
								"_kics_type": {
									"_kics_line": 351
								}
							},
							"apiVersion": "2022-11-01",
							"identifier": "keyVault",
							"name": "[parameters('keyvaultName')]",
							"resources": [
								{
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 330
										},
										"_kics_apiVersion": {
											"_kics_line": 330
										},
										"_kics_name": {
											"_kics_line": 331
										},
										"_kics_parent": {
											"_kics_line": 332
										},
										"_kics_properties": {
											"_kics_line": 333
										},
										"_kics_type": {
											"_kics_line": 330
										}
									},
									"apiVersion": "2018-02-14",
									"identifier": "redisConnectionStringSecret",
									"name": "redisConStrSecret",
									"parent": "keyVault",
									"properties": {
										"_kics_lines": {
											"_kics__default": {
												"_kics_line": 333
											},
											"_kics_value": {
												"_kics_line": 334
											}
										},
										"value": "['${redisCache.properties.hostName},password=${redisCache.listKeys().primaryKey},ssl=True,abortConnect=False']"
									},
									"type": "secrets"
								}
							],
							"type": "Microsoft.KeyVault/vaults"
						}
					],
					"variables": {
						"containerSubnetRef": {
							"value": {
								"resourceId": [
									"Microsoft.Network/virtualNetworks/subnets",
									"parameters('existingVNETName')",
									"parameters('existingContainerSubnetName')"
								]
							}
						},
						"diagnosticsLogs": {
							"value": null
						},
						"diagnosticsLogsSpecified": {
							"value": null
						},
						"diagnosticsMetrics": {
							"value": null
						},
						"nicName": {
							"value": "myVMNic"
						},
						"storageAccountName": {
							"value": "'bootdiags${[uniqueString(resourceGroup().id)]}'"
						},
						"storageSubnetRef": {
							"value": {
								"resourceId": [
									"Microsoft.Network/virtualNetworks/subnets",
									"parameters('existingVNETName')",
									"parameters('existingStorageSubnetName')"
								]
							}
						}
					}
				}`,
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			document, _, err := parser.Parse(tt.filename, nil)
			if (err != nil) != tt.wantErr {
				t.Errorf("Parser.Parse() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			require.Len(t, document, 1)
			//get first element of parsed file
			parsedDoc := document[0]
			fileString, err := json.Marshal(parsedDoc)
			require.NoError(t, err)
			require.JSONEq(t, tt.want, string(fileString))
		})
	}
}
