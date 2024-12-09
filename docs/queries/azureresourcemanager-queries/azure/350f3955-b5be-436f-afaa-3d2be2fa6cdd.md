---
title: Azure Managed Disk Without Encryption
hide:
  toc: true
  navigation: true
---

<style>
  .highlight .hll {
    background-color: #ff171742;
  }
  .md-content {
    max-width: 1100px;
    margin: 0 auto;
  }
</style>

-   **Query id:** 350f3955-b5be-436f-afaa-3d2be2fa6cdd
-   **Query name:** Azure Managed Disk Without Encryption
-   **Platform:** AzureResourceManager
-   **Severity:** <span style="color:#bb2124">High</span>
-   **Category:** Encryption
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/311.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/311.html')">311</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/azureResourceManager/azure_managed_disk_without_encryption)

### Description
Azure Disk Encryption should be enabled<br>
[Documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/disks?tabs=json#encryptionsettingscollection-object)

### Code samples
#### Code samples with security vulnerabilities
```bicep title="Positive test num. 1 - bicep file" hl_lines="18"
@description('Specifies a name for generating resource names.')
param projectName string

var vmName = '${projectName}-vm'

resource vmName_disk1 'Microsoft.Compute/disks@2020-09-30' = {
  name: '${vmName}-disk1'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: 512
    encryptionSettingsCollection: {
      enabled: false
      encryptionSettings: [
        {
          diskEncryptionKey: {
            secretUrl: 'https://secret.com/secrets/secret'
            sourceVault: {
              id: '/someid/somekey'
            }
          }
        }
      ]
    }
  }
}

```
```json title="Positive test num. 2 - json file" hl_lines="30"
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "projectName": {
      "type": "string",
      "metadata": {
        "description": "Specifies a name for generating resource names."
      }
    }
  },
  "variables": {
    "vmName": "[concat(parameters('projectName'), '-vm')]"
  },
  "resources": [
    {
      "type": "Microsoft.Compute/disks",
      "apiVersion": "2020-09-30",
      "name": "[concat(variables('vmName'),'-disk1')]",
      "location": "[resourceGroup().location]",
      "sku": {
        "name": "Standard_LRS"
      },
      "properties": {
        "creationData": {
          "createOption": "Empty"
        },
        "diskSizeGB": 512,
        "encryptionSettingsCollection": {
          "enabled": false,
          "encryptionSettings": [
            {
              "diskEncryptionKey": {
                "secretUrl": "https://secret.com/secrets/secret",
                "sourceVault": {
                  "id": "/someid/somekey"
                }
              }
            }
          ]
        }
      }
    }
  ]
}

```
```bicep title="Positive test num. 3 - bicep file" hl_lines="7"
@description('Specifies a name for generating resource names.')
param projectName string

var vmName = '${projectName}-vm'

resource vmName_disk1 'Microsoft.Compute/disks@2020-09-30' = {
  name: '${vmName}-disk1'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: 512
  }
}

```
<details><summary>Positive test num. 4 - json file</summary>

```json hl_lines="19"
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "projectName": {
      "type": "string",
      "metadata": {
        "description": "Specifies a name for generating resource names."
      }
    }
  },
  "variables": {
    "vmName": "[concat(parameters('projectName'), '-vm')]"
  },
  "resources": [
    {
      "type": "Microsoft.Compute/disks",
      "apiVersion": "2020-09-30",
      "name": "[concat(variables('vmName'),'-disk1')]",
      "location": "[resourceGroup().location]",
      "sku": {
        "name": "Standard_LRS"
      },
      "properties": {
        "creationData": {
          "createOption": "Empty"
        },
        "diskSizeGB": 512
      }
    }
  ]
}

```
</details>
<details><summary>Positive test num. 5 - bicep file</summary>

```bicep hl_lines="18"
@description('Specifies a name for generating resource names.')
param projectName string

var vmName = '${projectName}-vm'

resource vmName_disk1 'Microsoft.Compute/disks@2020-09-30' = {
  name: '${vmName}-disk1'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: 512
    encryptionSettingsCollection: {
      enabled: false
      encryptionSettings: [
        {
          diskEncryptionKey: {
            secretUrl: 'https://secret.com/secrets/secret'
            sourceVault: {
              id: '/someid/somekey'
            }
          }
        }
      ]
    }
  }
}

```
</details>
<details><summary>Positive test num. 6 - json file</summary>

```json hl_lines="32"
{
  "properties": {
    "template": {
      "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "parameters": {
        "projectName": {
          "type": "string",
          "metadata": {
            "description": "Specifies a name for generating resource names."
          }
        }
      },
      "variables": {
        "vmName": "[concat(parameters('projectName'), '-vm')]"
      },
      "resources": [
        {
          "type": "Microsoft.Compute/disks",
          "apiVersion": "2020-09-30",
          "name": "[concat(variables('vmName'),'-disk1')]",
          "location": "[resourceGroup().location]",
          "sku": {
            "name": "Standard_LRS"
          },
          "properties": {
            "creationData": {
              "createOption": "Empty"
            },
            "diskSizeGB": 512,
            "encryptionSettingsCollection": {
              "enabled": false,
              "encryptionSettings": [
                {
                  "diskEncryptionKey": {
                    "secretUrl": "https://secret.com/secrets/secret",
                    "sourceVault": {
                      "id": "/someid/somekey"
                    }
                  }
                }
              ]
            }
          }
        }
      ],
      "outputs": {}
    },
    "parameters": {}
  },
  "kind": "template",
  "type": "Microsoft.Blueprint/blueprints/artifacts",
  "name": "myTemplate"
}

```
</details>
<details><summary>Positive test num. 7 - bicep file</summary>

```bicep hl_lines="7"
@description('Specifies a name for generating resource names.')
param projectName string

var vmName = '${projectName}-vm'

resource vmName_disk1 'Microsoft.Compute/disks@2020-09-30' = {
  name: '${vmName}-disk1'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: 512
  }
}

```
</details>
<details><summary>Positive test num. 8 - json file</summary>

```json hl_lines="21"
{
  "properties": {
    "template": {
      "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "parameters": {
        "projectName": {
          "type": "string",
          "metadata": {
            "description": "Specifies a name for generating resource names."
          }
        }
      },
      "variables": {
        "vmName": "[concat(parameters('projectName'), '-vm')]"
      },
      "resources": [
        {
          "type": "Microsoft.Compute/disks",
          "apiVersion": "2020-09-30",
          "name": "[concat(variables('vmName'),'-disk1')]",
          "location": "[resourceGroup().location]",
          "sku": {
            "name": "Standard_LRS"
          },
          "properties": {
            "creationData": {
              "createOption": "Empty"
            },
            "diskSizeGB": 512
          }
        }
      ],
      "outputs": {}
    },
    "parameters": {}
  },
  "kind": "template",
  "type": "Microsoft.Blueprint/blueprints/artifacts",
  "name": "myTemplate"
}

```
</details>


#### Code samples without security vulnerabilities
```bicep title="Negative test num. 1 - bicep file"
@description('Specifies a name for generating resource names.')
param projectName string

var vmName = '${projectName}-vm'

resource vmName_disk1 'Microsoft.Compute/disks@2020-09-30' = {
  name: '${vmName}-disk1'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: 512
    encryptionSettingsCollection: {
      enabled: true
      encryptionSettings: [
        {
          diskEncryptionKey: {
            secretUrl: 'https://secret.com/secrets/secret'
            sourceVault: {
              id: '/someid/somekey'
            }
          }
        }
      ]
    }
  }
}

```
```json title="Negative test num. 2 - json file"
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "projectName": {
      "type": "string",
      "metadata": {
        "description": "Specifies a name for generating resource names."
      }
    }
  },
  "variables": {
    "vmName": "[concat(parameters('projectName'), '-vm')]"
  },
  "resources": [
    {
      "type": "Microsoft.Compute/disks",
      "apiVersion": "2020-09-30",
      "name": "[concat(variables('vmName'),'-disk1')]",
      "location": "[resourceGroup().location]",
      "sku": {
        "name": "Standard_LRS"
      },
      "properties": {
        "creationData": {
          "createOption": "Empty"
        },
        "diskSizeGB": 512,
        "encryptionSettingsCollection": {
          "enabled": true,
          "encryptionSettings": [
            {
              "diskEncryptionKey": {
                "secretUrl": "https://secret.com/secrets/secret",
                "sourceVault": {
                  "id": "/someid/somekey"
                }
              }
            }
          ]
        }
      }
    }
  ]
}

```
```bicep title="Negative test num. 3 - bicep file"
@description('Specifies a name for generating resource names.')
param projectName string

var vmName = '${projectName}-vm'

resource vmName_disk1 'Microsoft.Compute/disks@2020-09-30' = {
  name: '${vmName}-disk1'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: 512
    encryptionSettingsCollection: {
      enabled: true
      encryptionSettings: [
        {
          diskEncryptionKey: {
            secretUrl: 'https://secret.com/secrets/secret'
            sourceVault: {
              id: '/someid/somekey'
            }
          }
        }
      ]
    }
  }
}

```
<details><summary>Negative test num. 4 - json file</summary>

```json
{
  "properties": {
    "template": {
      "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "parameters": {
        "projectName": {
          "type": "string",
          "metadata": {
            "description": "Specifies a name for generating resource names."
          }
        }
      },
      "variables": {
        "vmName": "[concat(parameters('projectName'), '-vm')]"
      },
      "resources": [
        {
          "type": "Microsoft.Compute/disks",
          "apiVersion": "2020-09-30",
          "name": "[concat(variables('vmName'),'-disk1')]",
          "location": "[resourceGroup().location]",
          "sku": {
            "name": "Standard_LRS"
          },
          "properties": {
            "creationData": {
              "createOption": "Empty"
            },
            "diskSizeGB": 512,
            "encryptionSettingsCollection": {
              "enabled": true,
              "encryptionSettings": [
                {
                  "diskEncryptionKey": {
                    "secretUrl": "https://secret.com/secrets/secret",
                    "sourceVault": {
                      "id": "/someid/somekey"
                    }
                  }
                }
              ]
            }
          }
        }
      ],
      "outputs": {}
    },
    "parameters": {}
  },
  "kind": "template",
  "type": "Microsoft.Blueprint/blueprints/artifacts",
  "name": "myTemplate"
}

```
</details>
