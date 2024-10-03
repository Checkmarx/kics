---
title: AKS Dashboard Is Enabled
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

-   **Query id:** c62d3b92-9a11-4ffd-b7b7-6faaae83faed
-   **Query name:** AKS Dashboard Is Enabled
-   **Platform:** AzureResourceManager
-   **Severity:** <span style="color:#edd57e">Low</span>
-   **Category:** Insecure Configurations
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/200.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/200.html')">200</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/azureResourceManager/aks_dashboard_enabled)

### Description
Azure Kubernetes Service should have the Kubernetes dashboard disabled.<br>
[Documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.containerservice/managedclusters?tabs=json#managedclusteraddonprofile)

### Code samples
#### Code samples with security vulnerabilities
```bicep title="Positive test num. 1 - bicep file" hl_lines="8"
resource aksCluster1 'Microsoft.ContainerService/managedClusters@2020-02-01' = {
  name: 'aksCluster1'
  location: resourceGroup().location
  properties: {
    kubernetesVersion: '1.15.7'
    addonProfiles: {
      kubeDashboard: {
        enabled: true
      }
    }
    dnsPrefix: 'dnsprefix'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 2
        vmSize: 'Standard_A1'
        osType: 'Linux'
        storageProfile: 'ManagedDisks'
      }
    ]
    linuxProfile: {
      adminUsername: 'adminUserName'
      ssh: {
        publicKeys: [
          {
            keyData: 'keyData'
          }
        ]
      }
    }
    servicePrincipalProfile: {
      clientId: 'servicePrincipalAppId'
      secret: 'servicePrincipalAppPassword'
    }
    networkProfile: {
      networkPolicy: 'azure'
    }
  }
}

```
```json title="Positive test num. 2 - json file" hl_lines="14"
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "name": "aksCluster1",
      "type": "Microsoft.ContainerService/managedClusters",
      "apiVersion": "2020-02-01",
      "location": "[resourceGroup().location]",
      "properties": {
        "kubernetesVersion": "1.15.7",
        "addonProfiles": {
          "kubeDashboard": {
            "enabled": true
          }
        },
        "dnsPrefix": "dnsprefix",
        "agentPoolProfiles": [
          {
            "name": "agentpool",
            "count": 2,
            "vmSize": "Standard_A1",
            "osType": "Linux",
            "storageProfile": "ManagedDisks"
          }
        ],
        "linuxProfile": {
          "adminUsername": "adminUserName",
          "ssh": {
            "publicKeys": [
              {
                "keyData": "keyData"
              }
            ]
          }
        },
        "servicePrincipalProfile": {
          "clientId": "servicePrincipalAppId",
          "secret": "servicePrincipalAppPassword"
        },
        "networkProfile": {
          "networkPolicy": "azure"
        }
      }
    }
  ]
}

```
```bicep title="Positive test num. 3 - bicep file" hl_lines="8"
resource aksCluster1 'Microsoft.ContainerService/managedClusters@2020-02-01' = {
  name: 'aksCluster1'
  location: resourceGroup().location
  properties: {
    kubernetesVersion: '1.15.7'
    addonProfiles: {
      kubeDashboard: {
        enabled: true
      }
    }
    dnsPrefix: 'dnsprefix'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 2
        vmSize: 'Standard_A1'
        osType: 'Linux'
        storageProfile: 'ManagedDisks'
      }
    ]
    linuxProfile: {
      adminUsername: 'adminUserName'
      ssh: {
        publicKeys: [
          {
            keyData: 'keyData'
          }
        ]
      }
    }
    servicePrincipalProfile: {
      clientId: 'servicePrincipalAppId'
      secret: 'servicePrincipalAppPassword'
    }
    networkProfile: {
      networkPolicy: 'azure'
    }
  }
}

```
<details><summary>Positive test num. 4 - json file</summary>

```json hl_lines="16"
{
  "properties": {
    "template": {
      "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "resources": [
        {
          "name": "aksCluster1",
          "type": "Microsoft.ContainerService/managedClusters",
          "apiVersion": "2020-02-01",
          "location": "[resourceGroup().location]",
          "properties": {
            "kubernetesVersion": "1.15.7",
            "addonProfiles": {
              "kubeDashboard": {
                "enabled": true
              }
            },
            "dnsPrefix": "dnsprefix",
            "agentPoolProfiles": [
              {
                "name": "agentpool",
                "count": 2,
                "vmSize": "Standard_A1",
                "osType": "Linux",
                "storageProfile": "ManagedDisks"
              }
            ],
            "linuxProfile": {
              "adminUsername": "adminUserName",
              "ssh": {
                "publicKeys": [
                  {
                    "keyData": "keyData"
                  }
                ]
              }
            },
            "servicePrincipalProfile": {
              "clientId": "servicePrincipalAppId",
              "secret": "servicePrincipalAppPassword"
            },
            "networkProfile": {
              "networkPolicy": "azure"
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


#### Code samples without security vulnerabilities
```bicep title="Negative test num. 1 - bicep file"
resource aksCluster1 'Microsoft.ContainerService/managedClusters@2020-02-01' = {
  name: 'aksCluster1'
  location: resourceGroup().location
  properties: {
    kubernetesVersion: '1.15.7'
    addonProfiles: {
      kubeDashboard: {
        enabled: false
      }
    }
    dnsPrefix: 'dnsprefix'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 2
        vmSize: 'Standard_A1'
        osType: 'Linux'
        storageProfile: 'ManagedDisks'
      }
    ]
    linuxProfile: {
      adminUsername: 'adminUserName'
      ssh: {
        publicKeys: [
          {
            keyData: 'keyData'
          }
        ]
      }
    }
    servicePrincipalProfile: {
      clientId: 'servicePrincipalAppId'
      secret: 'servicePrincipalAppPassword'
    }
    networkProfile: {
      networkPolicy: 'azure'
    }
  }
}

```
```json title="Negative test num. 2 - json file"
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "name": "aksCluster1",
      "type": "Microsoft.ContainerService/managedClusters",
      "apiVersion": "2020-02-01",
      "location": "[resourceGroup().location]",
      "properties": {
        "kubernetesVersion": "1.15.7",
        "addonProfiles": {
          "kubeDashboard": {
            "enabled": false
          }
        },
        "dnsPrefix": "dnsprefix",
        "agentPoolProfiles": [
          {
            "name": "agentpool",
            "count": 2,
            "vmSize": "Standard_A1",
            "osType": "Linux",
            "storageProfile": "ManagedDisks"
          }
        ],
        "linuxProfile": {
          "adminUsername": "adminUserName",
          "ssh": {
            "publicKeys": [
              {
                "keyData": "keyData"
              }
            ]
          }
        },
        "servicePrincipalProfile": {
          "clientId": "servicePrincipalAppId",
          "secret": "servicePrincipalAppPassword"
        },
        "networkProfile": {
          "networkPolicy": "azure"
        }
      }
    }
  ]
}

```
```bicep title="Negative test num. 3 - bicep file"
resource aksCluster1 'Microsoft.ContainerService/managedClusters@2020-02-01' = {
  name: 'aksCluster1'
  location: resourceGroup().location
  properties: {
    kubernetesVersion: '1.15.7'
    addonProfiles: {
      kubeDashboard: {
        enabled: false
      }
    }
    dnsPrefix: 'dnsprefix'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 2
        vmSize: 'Standard_A1'
        osType: 'Linux'
        storageProfile: 'ManagedDisks'
      }
    ]
    linuxProfile: {
      adminUsername: 'adminUserName'
      ssh: {
        publicKeys: [
          {
            keyData: 'keyData'
          }
        ]
      }
    }
    servicePrincipalProfile: {
      clientId: 'servicePrincipalAppId'
      secret: 'servicePrincipalAppPassword'
    }
    networkProfile: {
      networkPolicy: 'azure'
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
      "resources": [
        {
          "name": "aksCluster1",
          "type": "Microsoft.ContainerService/managedClusters",
          "apiVersion": "2020-02-01",
          "location": "[resourceGroup().location]",
          "properties": {
            "kubernetesVersion": "1.15.7",
            "addonProfiles": {
              "kubeDashboard": {
                "enabled": false
              }
            },
            "dnsPrefix": "dnsprefix",
            "agentPoolProfiles": [
              {
                "name": "agentpool",
                "count": 2,
                "vmSize": "Standard_A1",
                "osType": "Linux",
                "storageProfile": "ManagedDisks"
              }
            ],
            "linuxProfile": {
              "adminUsername": "adminUserName",
              "ssh": {
                "publicKeys": [
                  {
                    "keyData": "keyData"
                  }
                ]
              }
            },
            "servicePrincipalProfile": {
              "clientId": "servicePrincipalAppId",
              "secret": "servicePrincipalAppPassword"
            },
            "networkProfile": {
              "networkPolicy": "azure"
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
<details><summary>Negative test num. 5 - bicep file</summary>

```bicep
resource aksCluster1 'Microsoft.ContainerService/managedClusters@2020-02-01' = {
  name: 'aksCluster1'
  location: resourceGroup().location
  properties: {
    kubernetesVersion: '1.15.7'
    dnsPrefix: 'dnsprefix'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 2
        vmSize: 'Standard_A1'
        osType: 'Linux'
        storageProfile: 'ManagedDisks'
      }
    ]
    linuxProfile: {
      adminUsername: 'adminUserName'
      ssh: {
        publicKeys: [
          {
            keyData: 'keyData'
          }
        ]
      }
    }
    servicePrincipalProfile: {
      clientId: 'servicePrincipalAppId'
      secret: 'servicePrincipalAppPassword'
    }
    networkProfile: {
      networkPolicy: 'azure'
    }
  }
}

```
</details>
<details><summary>Negative test num. 6 - json file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "name": "aksCluster1",
      "type": "Microsoft.ContainerService/managedClusters",
      "apiVersion": "2020-02-01",
      "location": "[resourceGroup().location]",
      "properties": {
        "kubernetesVersion": "1.15.7",
        "dnsPrefix": "dnsprefix",
        "agentPoolProfiles": [
          {
            "name": "agentpool",
            "count": 2,
            "vmSize": "Standard_A1",
            "osType": "Linux",
            "storageProfile": "ManagedDisks"
          }
        ],
        "linuxProfile": {
          "adminUsername": "adminUserName",
          "ssh": {
            "publicKeys": [
              {
                "keyData": "keyData"
              }
            ]
          }
        },
        "servicePrincipalProfile": {
          "clientId": "servicePrincipalAppId",
          "secret": "servicePrincipalAppPassword"
        },
        "networkProfile": {
          "networkPolicy": "azure"
        }
      }
    }
  ]
}

```
</details>
<details><summary>Negative test num. 7 - bicep file</summary>

```bicep
resource aksCluster1 'Microsoft.ContainerService/managedClusters@2020-02-01' = {
  name: 'aksCluster1'
  location: resourceGroup().location
  properties: {
    kubernetesVersion: '1.15.7'
    dnsPrefix: 'dnsprefix'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 2
        vmSize: 'Standard_A1'
        osType: 'Linux'
        storageProfile: 'ManagedDisks'
      }
    ]
    linuxProfile: {
      adminUsername: 'adminUserName'
      ssh: {
        publicKeys: [
          {
            keyData: 'keyData'
          }
        ]
      }
    }
    servicePrincipalProfile: {
      clientId: 'servicePrincipalAppId'
      secret: 'servicePrincipalAppPassword'
    }
    networkProfile: {
      networkPolicy: 'azure'
    }
  }
}

```
</details>
<details><summary>Negative test num. 8 - json file</summary>

```json
{
  "properties": {
    "template": {
      "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "resources": [
        {
          "name": "aksCluster1",
          "type": "Microsoft.ContainerService/managedClusters",
          "apiVersion": "2020-02-01",
          "location": "[resourceGroup().location]",
          "properties": {
            "kubernetesVersion": "1.15.7",
            "dnsPrefix": "dnsprefix",
            "agentPoolProfiles": [
              {
                "name": "agentpool",
                "count": 2,
                "vmSize": "Standard_A1",
                "osType": "Linux",
                "storageProfile": "ManagedDisks"
              }
            ],
            "linuxProfile": {
              "adminUsername": "adminUserName",
              "ssh": {
                "publicKeys": [
                  {
                    "keyData": "keyData"
                  }
                ]
              }
            },
            "servicePrincipalProfile": {
              "clientId": "servicePrincipalAppId",
              "secret": "servicePrincipalAppPassword"
            },
            "networkProfile": {
              "networkPolicy": "azure"
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
