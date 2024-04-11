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
							"defaultValue": true,
							"metadata": {
								"description": "This is a test bool param declaration."
							},
							"type": "bool"
						},
						"middleString": {
							"defaultValue": "'teste-${parameters('numberNodes')}${parameters('isNumber')}-teste'",
							"metadata": {
								"description": "This is a test middle string param declaration."
							},
							"type": "string"
						},
						"numberNodes": {
							"defaultValue": 2,
							"metadata": {
								"description": "This is a test int param declaration."
							},
							"type": "int"
						},
						"projectName": {
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
							"metadata": {
								"description": "Password for the Virtual Machine."
							},
							"minLength": 12,
							"type": "secureString"
						},
						"adminUsername": {
							"metadata": {
								"description": "Username for the Virtual Machine."
							},
							"type": "string"
						},
						"location": {
							"defaultValue": "[resourceGroup().location]",
							"metadata": {
								"description": "Location for all resources."
							},
							"type": "string"
						},
						"parenthesis": {
							"defaultValue": "simple-vm",
							"type": "string"
						},
						"vmName": {
							"defaultValue": "simple-vm",
							"metadata": {
								"description": "Name of the virtual machine."
							},
							"type": "string"
						},
						"vmSize": {
							"defaultValue": "Standard_D2_v3",
							"metadata": {
								"description": "Size of the virtual machine."
							},
							"type": "string"
						}
					},
					"resources": [
						{
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
							"location": "[parameters('location')]",
							"name": "[parameters('vmName')]",
							"properties": {
								"diagnosticsProfile": {
									"bootDiagnostics": {
										"enabled": true,
										"storageUri": "[reference(resourceId(Microsoft.Storage/storageAccounts, variables('storageAccountName'))).primaryEndpoints.blob]"
									}
								},
								"hardwareProfile": {
									"vmSize": "[parameters('vmSize')]"
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
									"adminPassword": "[parameters('adminPassword')]",
									"adminUsername": "[parameters('adminUsername')]",
									"computerName": "[parameters('vmName')]"
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
										"sku": "[parameters('OSVersion')]",
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
