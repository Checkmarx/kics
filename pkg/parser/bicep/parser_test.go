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
						"isNumber": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 10
								},
								"_kics_type": {
									"_kics_line": 10
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
									"_kics_line": 13
								},
								"_kics_type": {
									"_kics_line": 13
								}
							},
							"defaultValue": "'teste-${parameters('numberNodes')}${parameters('isNumber')}-teste'",
							"metadata": {
								"description": "This is a test middle string param declaration."
							},
							"type": "string"
						},
						"numberNodes": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 7
								},
								"_kics_type": {
									"_kics_line": 7
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
									"_kics_line": 4
								},
								"_kics_type": {
									"_kics_line": 4
								}
							},
							"defaultValue": "test",
							"metadata": {
								"description": "This is a test param with secure declaration."
							},
							"type": "secureString"
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
									"_kics_line": 35
								},
								"_kics_type": {
									"_kics_line": 35
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
									"_kics_line": 10
								},
								"_kics_type": {
									"_kics_line": 10
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
									"_kics_line": 5
								},
								"_kics_type": {
									"_kics_line": 5
								}
							},
							"metadata": {
								"description": "Username for the Virtual Machine."
							},
							"type": "string"
						},
						"location": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 41
								},
								"_kics_type": {
									"_kics_line": 41
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
									"_kics_line": 46
								},
								"_kics_type": {
									"_kics_line": 46
								}
							},
							"defaultValue": "simple-vm",
							"type": "string"
						},
						"vmName": {
							"_kics_lines": {
								"_kics_defaultValue": {
									"_kics_line": 44
								},
								"_kics_type": {
									"_kics_line": 44
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
									"_kics_line": 38
								},
								"_kics_type": {
									"_kics_line": 38
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
									"_kics_line": 50
								},
								"_kics_apiVersion": {
									"_kics_line": 50
								},
								"_kics_dependsOn": {
									"_kics_arr": [
										{
											"_kics__default": {
												"_kics_line": 99
											}
										}
									],
									"_kics_line": 99
								},
								"_kics_location": {
									"_kics_line": 52
								},
								"_kics_name": {
									"_kics_line": 51
								},
								"_kics_properties": {
									"_kics_line": 53
								},
								"_kics_type": {
									"_kics_line": 50
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
							"name": "[parameters('vmName')]",
							"properties": {
								"_kics_lines": {
									"_kics__default": {
										"_kics_line": 53
									},
									"_kics_diagnosticsProfile": {
										"_kics_line": 90
									},
									"_kics_hardwareProfile": {
										"_kics_line": 54
									},
									"_kics_networkProfile": {
										"_kics_line": 83
									},
									"_kics_osProfile": {
										"_kics_line": 57
									},
									"_kics_storageProfile": {
										"_kics_line": 62
									}
								},
								"diagnosticsProfile": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 90
										},
										"_kics_bootDiagnostics": {
											"_kics_line": 91
										}
									},
									"bootDiagnostics": {
										"_kics_lines": {
											"_kics__default": {
												"_kics_line": 91
											},
											"_kics_enabled": {
												"_kics_line": 92
											},
											"_kics_storageUri": {
												"_kics_line": 93
											}
										},
										"enabled": true,
										"storageUri": "[reference(resourceId(Microsoft.Storage/storageAccounts, variables('storageAccountName'))).primaryEndpoints.blob]"
									}
								},
								"hardwareProfile": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 54
										},
										"_kics_vmSize": {
											"_kics_line": 55
										}
									},
									"vmSize": "[parameters('vmSize')]"
								},
								"networkProfile": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 83
										},
										"_kics_networkInterfaces": {
											"_kics_arr": [
												{
													"_kics__default": {
														"_kics_line": 84
													}
												}
											],
											"_kics_line": 84
										}
									},
									"networkInterfaces": [
										{
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 85
												},
												"_kics_id": {
													"_kics_line": 86
												}
											},
											"id": {
												"resourceId": [
													"Microsoft.Network/networkInterfaces",
													"variables('nicName')"
												]
											}
										}
									]
								},
								"osProfile": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 57
										},
										"_kics_adminPassword": {
											"_kics_line": 60
										},
										"_kics_adminUsername": {
											"_kics_line": 59
										},
										"_kics_computerName": {
											"_kics_line": 58
										}
									},
									"adminPassword": "[parameters('adminPassword')]",
									"adminUsername": "[parameters('adminUsername')]",
									"computerName": "[parameters('vmName')]"
								},
								"storageProfile": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 62
										},
										"_kics_dataDisks": {
											"_kics_arr": [
												{
													"_kics__default": {
														"_kics_line": 75
													}
												}
											],
											"_kics_line": 75
										},
										"_kics_imageReference": {
											"_kics_line": 63
										},
										"_kics_osDisk": {
											"_kics_line": 69
										}
									},
									"dataDisks": [
										{
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 76
												},
												"_kics_createOption": {
													"_kics_line": 79
												},
												"_kics_diskSizeGB": {
													"_kics_line": 77
												},
												"_kics_lun": {
													"_kics_line": 78
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
												"_kics_line": 63
											},
											"_kics_offer": {
												"_kics_line": 65
											},
											"_kics_publisher": {
												"_kics_line": 64
											},
											"_kics_sku": {
												"_kics_line": 66
											},
											"_kics_version": {
												"_kics_line": 67
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
												"_kics_line": 69
											},
											"_kics_createOption": {
												"_kics_line": 70
											},
											"_kics_managedDisk": {
												"_kics_line": 71
											}
										},
										"createOption": "FromImage",
										"managedDisk": {
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 71
												},
												"_kics_storageAccountType": {
													"_kics_line": 72
												}
											},
											"storageAccountType": "StandardSSD_LRS"
										}
									}
								}
							},
							"type": "Microsoft.Compute/virtualMachines"
						}
					],
					"variables": {
						"nicName": {
							"value": "myVMNic"
						},
						"storageAccountName": {
							"value": "'bootdiags${[uniqueString(resourceGroup().id)]}'"
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
