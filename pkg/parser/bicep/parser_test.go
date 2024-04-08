package bicep

import (
	"encoding/json"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/require"
)

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
								"decorators": [
									{
										"description": [
											"This is a test bool param declaration."
										]
									}
								],
								"type": "bool",
								"value": true
							},
							"middleString": {
								"decorators": [
									{
										"description": [
											"This is a test middle string param declaration."
										]
									}
								],
								"type": "string",
								"value": "'teste-${parameters('numberNodes')}${parameters('isNumber')}-teste'"
							},
							"numberNodes": {
								"decorators": [
									{
										"description": [
											"This is a test int param declaration."
										]
									}
								],
								"type": "int",
								"value": 2
							},
							"projectName": {
								"decorators": [
									{
										"description": [
											"This is a test param with secure declaration."
										]
									}
								],
								"type": "secureString",
								"value": "test"
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
							"decorators": [
								{
									"description": [
										"This is a test var declaration."
									]
								}
							],
							"value": "myVMNic"
						},
						"storageAccountName": {
							"decorators": [
								{
									"description": [
										"This is a test var declaration."
									]
								}
							],
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
							"decorators": [
								{
									"description": [
										"The Windows version for the VM. This will pick a fully patched image of this given Windows version."
									]
								},
								{
									"allowed": [
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
									]
								}
							],
							"type": "string",
							"value": "2019-Datacenter"
						},
						"adminPassword": {
							"decorators": [
								{
									"description": [
										"Password for the Virtual Machine."
									]
								},
								{
									"minLength": [
										12
									]
								}
							],
							"type": "secureString"
						},
						"adminUsername": {
							"decorators": [
								{
									"description": [
										"Username for the Virtual Machine."
									]
								}
							],
							"type": "string"
						},
						"location": {
							"decorators": [
								{
									"description": [
										"Location for all resources."
									]
								}
							],
							"type": "string",
							"value": "resourceGroup().location"
						},
						"vmName": {
							"decorators": [
								{
									"description": [
										"Name of the virtual machine."
									]
								}
							],
							"type": "string",
							"value": "simple-vm"
						},
						"vmSize": {
							"decorators": [
								{
									"description": [
										"Size of the virtual machine."
									]
								}
							],
							"type": "string",
							"value": "Standard_D2_v3"
						}
					},
					"resources": [
						{
							"apiVersion": "2021-03-01",
							"decorators": null,
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
							"name": "parameters('vmName')",
							"parameters('location')": "parameters('location')",
							"properties": {
								"diagnosticsProfile": {
									"bootDiagnostics": {
										"enabled": true,
										"storageUri": "reference(resourceId(Microsoft.Storage/storageAccounts, variables('storageAccountName'))).primaryEndpoints.blob"
									}
								},
								"hardwareProfile": {
									"parameters('vmSize')": "parameters('vmSize')"
								},
								"networkProfile": {
									"networkInterfaces": [
										{
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
									"computerName": "parameters('vmName')",
									"parameters('adminPassword')": "parameters('adminPassword')",
									"parameters('adminUsername')": "parameters('adminUsername')"
								},
								"storageProfile": {
									"dataDisks": [
										{
											"createOption": "Empty",
											"diskSizeGB": 1023,
											"lun": 0
										}
									],
									"imageReference": {
										"offer": "WindowsServer",
										"publisher": "MicrosoftWindowsServer",
										"sku": "parameters('OSVersion')",
										"version": "latest"
									},
									"osDisk": {
										"createOption": "FromImage",
										"managedDisk": {
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
							"decorators": null,
							"value": "myVMNic"
						},
						"storageAccountName": {
							"decorators": null,
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
