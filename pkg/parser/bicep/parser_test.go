package bicep

import (
	"encoding/json"
	"path/filepath"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
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
	resolved, err := parser.Resolve([]byte(param), "test.bicep", true)
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
									"_kics_line": 33
								},
								"_kics_type": {
									"_kics_line": 33
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
						"existingContainerSubnetName": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 53
								},
								"_kics_type": {
									"_kics_line": 53
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
									"_kics_line": 50
								},
								"_kics_type": {
									"_kics_line": 50
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
									"_kics_line": 47
								},
								"_kics_type": {
									"_kics_line": 47
								}
							},
							"metadata": {
								"description": "Name of the virtual network to use for cloud shell containers."
							},
							"type": "string"
						},
						"location": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 39
								},
								"_kics_type": {
									"_kics_line": 39
								}
							},
							"defaultValue": "[resourceGroup().location]",
							"metadata": {
								"description": "Location for all resources."
							},
							"type": "string"
						},
						"parenthesis": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 44
								},
								"_kics_type": {
									"_kics_line": 44
								}
							},
							"defaultValue": "simple-vm",
							"type": "string"
						},
						"vmName": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 42
								},
								"_kics_type": {
									"_kics_line": 42
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
									"_kics_line": 36
								},
								"_kics_type": {
									"_kics_line": 36
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
									"_kics_line": 72
								},
								"_kics_apiVersion": {
									"_kics_line": 71
								},
								"_kics_dependsOn": {
									"_kics_arr": [
										{
											"_kics__default": {
												"_kics_line": 121
											}
										}
									],
									"_kics_line": 121
								},
								"_kics_location": {
									"_kics_line": 74
								},
								"_kics_name": {
									"_kics_line": 73
								},
								"_kics_properties": {
									"_kics_line": 75
								},
								"_kics_type": {
									"_kics_line": 71
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
										"_kics_line": 75
									},
									"_kics_diagnosticsProfile": {
										"_kics_line": 112
									},
									"_kics_hardwareProfile": {
										"_kics_line": 76
									},
									"_kics_networkProfile": {
										"_kics_line": 105
									},
									"_kics_osProfile": {
										"_kics_line": 79
									},
									"_kics_storageProfile": {
										"_kics_line": 84
									}
								},
								"diagnosticsProfile": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 112
										},
										"_kics_bootDiagnostics": {
											"_kics_line": 113
										}
									},
									"bootDiagnostics": {
										"_kics_lines": {
											"_kics__default": {
												"_kics_line": 113
											},
											"_kics_enabled": {
												"_kics_line": 114
											},
											"_kics_storageUri": {
												"_kics_line": 115
											}
										},
										"enabled": true,
										"storageUri": "[reference(resourceId(Microsoft.Storage/storageAccounts, variables('storageAccountName'))).primaryEndpoints.blob]"
									}
								},
								"hardwareProfile": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 76
										},
										"_kics_vmSize": {
											"_kics_line": 77
										}
									},
									"vmSize": "[parameters('vmSize')]"
								},
								"networkProfile": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 105
										},
										"_kics_networkInterfaces": {
											"_kics_arr": [
												{
													"_kics__default": {
														"_kics_line": 106
													}
												}
											],
											"_kics_line": 106
										}
									},
									"networkInterfaces": [
										{
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 107
												},
												"_kics_id": {
													"_kics_line": 108
												}
											},
											"id": {
												"resourceId": [
													"Microsoft.Network/networkInterfaces",
													"nick.variables('nicName')"
												]
											}
										}
									]
								},
								"osProfile": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 79
										},
										"_kics_adminPassword": {
											"_kics_line": 82
										},
										"_kics_adminUsername": {
											"_kics_line": 81
										},
										"_kics_computerName": {
											"_kics_line": 80
										}
									},
									"adminPassword": "[parameters('adminPassword')]",
									"adminUsername": "[parameters('adminUsername')]",
									"computerName": "[computer.parameters('vmName')]"
								},
								"storageProfile": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 84
										},
										"_kics_dataDisks": {
											"_kics_arr": [
												{
													"_kics__default": {
														"_kics_line": 97
													}
												}
											],
											"_kics_line": 97
										},
										"_kics_imageReference": {
											"_kics_line": 85
										},
										"_kics_osDisk": {
											"_kics_line": 91
										}
									},
									"dataDisks": [
										{
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 98
												},
												"_kics_createOption": {
													"_kics_line": 101
												},
												"_kics_diskSizeGB": {
													"_kics_line": 99
												},
												"_kics_lun": {
													"_kics_line": 100
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
												"_kics_line": 85
											},
											"_kics_offer": {
												"_kics_line": 87
											},
											"_kics_publisher": {
												"_kics_line": 86
											},
											"_kics_sku": {
												"_kics_line": 88
											},
											"_kics_version": {
												"_kics_line": 89
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
												"_kics_line": 91
											},
											"_kics_createOption": {
												"_kics_line": 92
											},
											"_kics_managedDisk": {
												"_kics_line": 93
											}
										},
										"createOption": "FromImage",
										"managedDisk": {
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 93
												},
												"_kics_storageAccountType": {
													"_kics_line": 94
												}
											},
											"storageAccountType": "StandardSSD_LRS"
										}
									}
								}
							},
							"resources": [],
							"type": "Microsoft.Compute/virtualMachines"
						},
						{
							"_kics_lines": {
								"_kics__default": {
									"_kics_line": 127
								},
								"_kics_apiVersion": {
									"_kics_line": 127
								},
								"_kics_assignableScopes": {
									"_kics_arr": [
										{
											"_kics__default": {
												"_kics_line": 137
											}
										}
									],
									"_kics_line": 137
								},
								"_kics_location": {
									"_kics_line": 129
								},
								"_kics_name": {
									"_kics_line": 128
								},
								"_kics_type": {
									"_kics_line": 127
								},
								"_kics_userAssignedIdentities": {
									"_kics_line": 134
								}
							},
							"apiVersion": "2021-03-01",
							"assignableScopes": [
								"[subscription().id]"
							],
							"identifier": "nic",
							"location": null,
							"name": "",
							"resources": [],
							"type": "Microsoft.Network/networkInterfaces",
							"userAssignedIdentities": {
								"'${[resourceId(Microsoft.ManagedIdentity/userAssignedIdentities, variables('nicName'))]}'": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 135
										}
									}
								},
								"_kics_lines": {
									"_kics_'${[resourceId(Microsoft.ManagedIdentity/userAssignedIdentities, variables('nicName'))]}'": {
										"_kics_line": 135
									},
									"_kics__default": {
										"_kics_line": 134
									}
								}
							}
						},
						{
							"_kics_lines": {
								"_kics__default": {
									"_kics_line": 140
								},
								"_kics_apiVersion": {
									"_kics_line": 140
								},
								"_kics_kind": {
									"_kics_line": 147
								},
								"_kics_location": {
									"_kics_line": 142
								},
								"_kics_name": {
									"_kics_line": 141
								},
								"_kics_properties": {
									"_kics_line": 148
								},
								"_kics_sku": {
									"_kics_line": 143
								},
								"_kics_type": {
									"_kics_line": 140
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
										"_kics_line": 148
									},
									"_kics_accessTier": {
										"_kics_line": 177
									},
									"_kics_encryption": {
										"_kics_line": 164
									},
									"_kics_networkAcls": {
										"_kics_line": 149
									},
									"_kics_supportsHttpsTrafficOnly": {
										"_kics_line": 163
									}
								},
								"accessTier": "Cool",
								"encryption": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 164
										},
										"_kics_keySource": {
											"_kics_line": 175
										},
										"_kics_services": {
											"_kics_line": 165
										}
									},
									"keySource": "Microsoft.Storage",
									"services": {
										"_kics_lines": {
											"_kics__default": {
												"_kics_line": 165
											},
											"_kics_blob": {
												"_kics_line": 170
											},
											"_kics_file": {
												"_kics_line": 166
											}
										},
										"blob": {
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 170
												},
												"_kics_enabled": {
													"_kics_line": 172
												},
												"_kics_keyType": {
													"_kics_line": 171
												}
											},
											"enabled": true,
											"keyType": "Account"
										},
										"file": {
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 166
												},
												"_kics_enabled": {
													"_kics_line": 168
												},
												"_kics_keyType": {
													"_kics_line": 167
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
											"_kics_line": 149
										},
										"_kics_bypass": {
											"_kics_line": 150
										},
										"_kics_defaultAction": {
											"_kics_line": 161
										},
										"_kics_virtualNetworkRules": {
											"_kics_arr": [
												{
													"_kics__default": {
														"_kics_line": 151
													}
												}
											],
											"_kics_line": 151
										}
									},
									"bypass": "None",
									"defaultAction": "Deny",
									"virtualNetworkRules": [
										{
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 152
												},
												"_kics_action": {
													"_kics_line": 154
												},
												"_kics_id": {
													"_kics_line": 153
												}
											},
											"action": "Allow",
											"id": "[variables('containerSubnetRef')]"
										},
										{
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 156
												},
												"_kics_action": {
													"_kics_line": 158
												},
												"_kics_id": {
													"_kics_line": 157
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
											"_kics_line": 181
										},
										"_kics_apiVersion": {
											"_kics_line": 181
										},
										"_kics_name": {
											"_kics_line": 183
										},
										"_kics_parent": {
											"_kics_line": 182
										},
										"_kics_properties": {
											"_kics_line": 188
										},
										"_kics_sku": {
											"_kics_line": 184
										},
										"_kics_type": {
											"_kics_line": 181
										}
									},
									"apiVersion": "2019-06-01",
									"identifier": "storageAccountName_default",
									"name": "default",
									"parent": "storageAccount",
									"properties": {
										"_kics_lines": {
											"_kics__default": {
												"_kics_line": 188
											},
											"_kics_deleteRetentionPolicy": {
												"_kics_line": 189
											}
										},
										"deleteRetentionPolicy": {
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 189
												},
												"_kics_enabled": {
													"_kics_line": 190
												}
											},
											"enabled": false
										}
									},
									"resources": [
										{
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 195
												},
												"_kics_apiVersion": {
													"_kics_line": 195
												},
												"_kics_name": {
													"_kics_line": 197
												},
												"_kics_parent": {
													"_kics_line": 196
												},
												"_kics_properties": {
													"_kics_line": 198
												},
												"_kics_type": {
													"_kics_line": 195
												}
											},
											"apiVersion": "2019-06-01",
											"identifier": "storageAccountName_default_container",
											"name": "container",
											"parent": "storageAccountName_default",
											"properties": {
												"_kics_lines": {
													"_kics__default": {
														"_kics_line": 198
													},
													"_kics_denyEncryptionScopeOverride": {
														"_kics_line": 199
													},
													"_kics_metadata": {
														"_kics_line": 201
													},
													"_kics_publicAccess": {
														"_kics_line": 200
													}
												},
												"denyEncryptionScopeOverride": true,
												"metadata": {
													"_kics_lines": {
														"_kics__default": {
															"_kics_line": 201
														}
													}
												},
												"publicAccess": "Blob"
											},
											"resources": [],
											"type": "containers"
										}
									],
									"sku": {
										"_kics_lines": {
											"_kics__default": {
												"_kics_line": 184
											},
											"_kics_name": {
												"_kics_line": 185
											},
											"_kics_tier": {
												"_kics_line": 186
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
										"_kics_line": 143
									},
									"_kics_name": {
										"_kics_line": 144
									},
									"_kics_tier": {
										"_kics_line": 145
									}
								},
								"name": "Standard_LRS",
								"tier": "Standard"
							},
							"type": "Microsoft.Storage/storageAccounts"
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
