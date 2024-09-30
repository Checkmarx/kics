---
title: PostgreSQL Database Server Log Connections Disabled
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

-   **Query id:** e69bda39-e1e2-47ca-b9ee-b6531b23aedd
-   **Query name:** PostgreSQL Database Server Log Connections Disabled
-   **Platform:** AzureResourceManager
-   **Severity:** <span style="color:#ff7213">Medium</span>
-   **Category:** Networking and Firewall
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/778.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/778.html')">778</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/azureResourceManager/postgresql_server_log_connections_disabled)

### Description
Microsoft.DBforPostgreSQL/servers/configurations should have 'log_connections' property set to 'on'<br>
[Documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.dbforpostgresql/servers/configurations?tabs=json#configurationproperties-object)

### Code samples
#### Code samples with security vulnerabilities
```bicep title="Positive test num. 1 - bicep file" hl_lines="31"
resource MyDBServer1 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  kind: ''
  location: resourceGroup().location
  name: 'MyDBServer1'
  properties: {
    sslEnforcement: 'Disabled'
    version: '11'
    administratorLogin: 'root'
    administratorLoginPassword: '12345'
    storageMB: '2048'
    createMode: 'Default'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    creationDate: '2019-04-01T00:00:00Z'
    lastModifiedDate: '2019-04-01T00:00:00Z'
    maxSizeUnits: 'SizeUnit.megabytes'
    isReadOnly: 'false'
    isAutoUpgradeEnabled: 'true'
    isStateful: 'false'
    isExternal: 'false'
  }
  sku: {
    name: 'S0'
    tier: 'Basic'
    capacity: 1
    family: 'GeneralPurpose'
  }
}

resource MyDBServer1_log_connections 'Microsoft.DBforPostgreSQL/servers/configurations@2017-12-01' = {
  parent: MyDBServer1
  name: 'log_connections'
  properties: {
    configurationSets: [
      {
        configurationSetType: 'Microsoft.DBforPostgreSQL/servers/configurations/dbconfig'
        configurationSet: {
          name: 'dbconfig'
        }
      }
    ]
  }
  location: resourceGroup().location
}

```
```json title="Positive test num. 2 - json file" hl_lines="40"
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "apiVersion": "2017-12-01",
      "kind": "",
      "location": "[resourceGroup().location]",
      "name": "MyDBServer1",
      "properties": {
        "sslEnforcement": "Disabled",
        "version": "11",
        "administratorLogin": "root",
        "administratorLoginPassword": "12345",
        "storageMB": "2048",
        "createMode": "Default",
        "collation": "SQL_Latin1_General_CP1_CI_AS",
        "creationDate": "2019-04-01T00:00:00Z",
        "lastModifiedDate": "2019-04-01T00:00:00Z",
        "maxSizeUnits": "SizeUnit.megabytes",
        "isReadOnly": "false",
        "isAutoUpgradeEnabled": "true",
        "isStateful": "false",
        "isExternal": "false"
      },
      "sku": {
        "name": "S0",
        "tier": "Basic",
        "capacity": 1,
        "family": "GeneralPurpose"
      },
      "type": "Microsoft.DBforPostgreSQL/servers",
      "resources": [
        {
          "type": "configurations",
          "apiVersion": "2017-12-01",
          "dependsOn": [
            "[resourceId('Microsoft.DBforPostgreSQL/servers', 'MyDBServer1')]"
          ],
          "name": "log_connections",
          "properties": {
            "configurationSets": [
              {
                "configurationSetType": "Microsoft.DBforPostgreSQL/servers/configurations/dbconfig",
                "configurationSet": {
                  "name": "dbconfig"
                }
              }
            ]
          },
          "location": "[resourceGroup().location]"
        }
      ]
    }
  ]
}

```
```bicep title="Positive test num. 3 - bicep file" hl_lines="33"
resource MyDBServer2 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  kind: ''
  location: resourceGroup().location
  name: 'MyDBServer2'
  properties: {
    sslEnforcement: 'Disabled'
    version: '11'
    administratorLogin: 'root'
    administratorLoginPassword: '12345'
    storageMB: '2048'
    createMode: 'Default'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    creationDate: '2019-04-01T00:00:00Z'
    lastModifiedDate: '2019-04-01T00:00:00Z'
    maxSizeUnits: 'SizeUnit.megabytes'
    isReadOnly: 'false'
    isAutoUpgradeEnabled: 'true'
    isStateful: 'false'
    isExternal: 'false'
  }
  sku: {
    name: 'S0'
    tier: 'Basic'
    capacity: 1
    family: 'GeneralPurpose'
  }
}

resource MyDBServer2_log_connections 'Microsoft.DBforPostgreSQL/servers/configurations@2017-12-01' = {
  parent: MyDBServer2
  name: 'log_connections'
  properties: {
    value: 'off'
  }
  location: resourceGroup().location
}

```
<details><summary>Positive test num. 4 - json file</summary>

```json hl_lines="45"
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {},
  "functions": [],
  "variables": {},
  "resources": [
    {
      "apiVersion": "2017-12-01",
      "kind": "",
      "location": "[resourceGroup().location]",
      "name": "MyDBServer2",
      "properties": {
        "sslEnforcement": "Disabled",
        "version": "11",
        "administratorLogin": "root",
        "administratorLoginPassword": "12345",
        "storageMB": "2048",
        "createMode": "Default",
        "collation": "SQL_Latin1_General_CP1_CI_AS",
        "creationDate": "2019-04-01T00:00:00Z",
        "lastModifiedDate": "2019-04-01T00:00:00Z",
        "maxSizeUnits": "SizeUnit.megabytes",
        "isReadOnly": "false",
        "isAutoUpgradeEnabled": "true",
        "isStateful": "false",
        "isExternal": "false"
      },
      "sku": {
        "name": "S0",
        "tier": "Basic",
        "capacity": 1,
        "family": "GeneralPurpose"
      },
      "type": "Microsoft.DBforPostgreSQL/servers",
      "resources": [
        {
          "type": "configurations",
          "apiVersion": "2017-12-01",
          "dependsOn": [
            "[resourceId('Microsoft.DBforPostgreSQL/servers', 'MyDBServer2')]"
          ],
          "name": "log_connections",
          "properties": {
            "value": "off"
          },
          "location": "[resourceGroup().location]"
        }
      ]
    }
  ],
  "outputs": {}
}

```
</details>
<details><summary>Positive test num. 5 - bicep file</summary>

```bicep hl_lines="32"
resource MyDBServer3 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  kind: ''
  location: resourceGroup().location
  name: 'MyDBServer3'
  properties: {
    sslEnforcement: 'Disabled'
    version: '11'
    administratorLogin: 'root'
    administratorLoginPassword: '12345'
    storageMB: '2048'
    createMode: 'Default'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    creationDate: '2019-04-01T00:00:00Z'
    lastModifiedDate: '2019-04-01T00:00:00Z'
    maxSizeUnits: 'SizeUnit.megabytes'
    isReadOnly: 'false'
    isAutoUpgradeEnabled: 'true'
    isStateful: 'false'
    isExternal: 'false'
  }
  sku: {
    name: 'S0'
    tier: 'Basic'
    capacity: 1
    family: 'GeneralPurpose'
  }
}

resource MyDBServer_log_connections 'Microsoft.DBforPostgreSQL/servers/configurations@2017-12-01' = {
  name: 'MyDBServer/log_connections'
  properties: {
    value: 'off'
  }
  location: resourceGroup().location
  dependsOn: ['MyDBServer']
}

```
</details>
<details><summary>Positive test num. 6 - json file</summary>

```json hl_lines="44"
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {},
  "functions": [],
  "variables": {},
  "resources": [
    {
      "type": "Microsoft.DBforPostgreSQL/servers",
      "apiVersion": "2017-12-01",
      "kind": "",
      "location": "[resourceGroup().location]",
      "name": "MyDBServer3",
      "properties": {
        "sslEnforcement": "Disabled",
        "version": "11",
        "administratorLogin": "root",
        "administratorLoginPassword": "12345",
        "storageMB": "2048",
        "createMode": "Default",
        "collation": "SQL_Latin1_General_CP1_CI_AS",
        "creationDate": "2019-04-01T00:00:00Z",
        "lastModifiedDate": "2019-04-01T00:00:00Z",
        "maxSizeUnits": "SizeUnit.megabytes",
        "isReadOnly": "false",
        "isAutoUpgradeEnabled": "true",
        "isStateful": "false",
        "isExternal": "false"
      },
      "sku": {
        "name": "S0",
        "tier": "Basic",
        "capacity": 1,
        "family": "GeneralPurpose"
      },
      "resources": [
      ]
    },
    {
      "type": "Microsoft.DBforPostgreSQL/servers/configurations",
      "apiVersion": "2017-12-01",
      "name": "MyDBServer/log_connections",
      "properties": {
        "value": "off"
      },
      "dependsOn": [
        "MyDBServer"
      ],
      "location": "[resourceGroup().location]"
    }
  ],
  "outputs": {}
}

```
</details>
<details><summary>Positive test num. 7 - bicep file</summary>

```bicep hl_lines="31"
resource MyDBServer3 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  kind: ''
  location: resourceGroup().location
  name: 'MyDBServer3'
  properties: {
    sslEnforcement: 'Disabled'
    version: '11'
    administratorLogin: 'root'
    administratorLoginPassword: '12345'
    storageMB: '2048'
    createMode: 'Default'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    creationDate: '2019-04-01T00:00:00Z'
    lastModifiedDate: '2019-04-01T00:00:00Z'
    maxSizeUnits: 'SizeUnit.megabytes'
    isReadOnly: 'false'
    isAutoUpgradeEnabled: 'true'
    isStateful: 'false'
    isExternal: 'false'
  }
  sku: {
    name: 'S0'
    tier: 'Basic'
    capacity: 1
    family: 'GeneralPurpose'
  }
}

resource MyDBServer_log_connections 'Microsoft.DBforPostgreSQL/servers/configurations@2017-12-01' = {
  name: 'MyDBServer/log_connections'
  properties: {
    configurationSets: [
      {
        configurationSetType: 'Microsoft.DBforPostgreSQL/servers/configurations/dbconfig'
        configurationSet: {
          name: 'dbconfig'
        }
      }
    ]
  }
  location: resourceGroup().location
  dependsOn: ['MyDBServer']
}

```
</details>
<details><summary>Positive test num. 8 - json file</summary>

```json hl_lines="43"
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {},
  "functions": [],
  "variables": {},
  "resources": [
    {
      "type": "Microsoft.DBforPostgreSQL/servers",
      "apiVersion": "2017-12-01",
      "kind": "",
      "location": "[resourceGroup().location]",
      "name": "MyDBServer3",
      "properties": {
        "sslEnforcement": "Disabled",
        "version": "11",
        "administratorLogin": "root",
        "administratorLoginPassword": "12345",
        "storageMB": "2048",
        "createMode": "Default",
        "collation": "SQL_Latin1_General_CP1_CI_AS",
        "creationDate": "2019-04-01T00:00:00Z",
        "lastModifiedDate": "2019-04-01T00:00:00Z",
        "maxSizeUnits": "SizeUnit.megabytes",
        "isReadOnly": "false",
        "isAutoUpgradeEnabled": "true",
        "isStateful": "false",
        "isExternal": "false"
      },
      "sku": {
        "name": "S0",
        "tier": "Basic",
        "capacity": 1,
        "family": "GeneralPurpose"
      },
      "resources": [
      ]
    },
    {
      "type": "Microsoft.DBforPostgreSQL/servers/configurations",
      "apiVersion": "2017-12-01",
      "name": "MyDBServer/log_connections",
      "properties": {
        "configurationSets": [
          {
            "configurationSetType": "Microsoft.DBforPostgreSQL/servers/configurations/dbconfig",
            "configurationSet": {
              "name": "dbconfig"
            }
          }
        ]
      },
      "dependsOn": [
        "MyDBServer"
      ],
      "location": "[resourceGroup().location]"
    }
  ],
  "outputs": {}
}

```
</details>
<details><summary>Positive test num. 9 - bicep file</summary>

```bicep hl_lines="31"
resource MyDBServer1 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  kind: ''
  location: resourceGroup().location
  name: 'MyDBServer1'
  properties: {
    sslEnforcement: 'Disabled'
    version: '11'
    administratorLogin: 'root'
    administratorLoginPassword: '12345'
    storageMB: '2048'
    createMode: 'Default'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    creationDate: '2019-04-01T00:00:00Z'
    lastModifiedDate: '2019-04-01T00:00:00Z'
    maxSizeUnits: 'SizeUnit.megabytes'
    isReadOnly: 'false'
    isAutoUpgradeEnabled: 'true'
    isStateful: 'false'
    isExternal: 'false'
  }
  sku: {
    name: 'S0'
    tier: 'Basic'
    capacity: 1
    family: 'GeneralPurpose'
  }
}

resource MyDBServer1_log_connections 'Microsoft.DBforPostgreSQL/servers/configurations@2017-12-01' = {
  parent: MyDBServer1
  name: 'log_connections'
  properties: {
    configurationSets: [
      {
        configurationSetType: 'Microsoft.DBforPostgreSQL/servers/configurations/dbconfig'
        configurationSet: {
          name: 'dbconfig'
        }
      }
    ]
  }
  location: resourceGroup().location
}

```
</details>
<details><summary>Positive test num. 10 - json file</summary>

```json hl_lines="42"
{
  "properties": {
    "template": {
      "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "resources": [
        {
          "apiVersion": "2017-12-01",
          "kind": "",
          "location": "[resourceGroup().location]",
          "name": "MyDBServer1",
          "properties": {
            "sslEnforcement": "Disabled",
            "version": "11",
            "administratorLogin": "root",
            "administratorLoginPassword": "12345",
            "storageMB": "2048",
            "createMode": "Default",
            "collation": "SQL_Latin1_General_CP1_CI_AS",
            "creationDate": "2019-04-01T00:00:00Z",
            "lastModifiedDate": "2019-04-01T00:00:00Z",
            "maxSizeUnits": "SizeUnit.megabytes",
            "isReadOnly": "false",
            "isAutoUpgradeEnabled": "true",
            "isStateful": "false",
            "isExternal": "false"
          },
          "sku": {
            "name": "S0",
            "tier": "Basic",
            "capacity": 1,
            "family": "GeneralPurpose"
          },
          "type": "Microsoft.DBforPostgreSQL/servers",
          "resources": [
            {
              "type": "configurations",
              "apiVersion": "2017-12-01",
              "dependsOn": [
                "[resourceId('Microsoft.DBforPostgreSQL/servers', 'MyDBServer1')]"
              ],
              "name": "log_connections",
              "properties": {
                "configurationSets": [
                  {
                    "configurationSetType": "Microsoft.DBforPostgreSQL/servers/configurations/dbconfig",
                    "configurationSet": {
                      "name": "dbconfig"
                    }
                  }
                ]
              },
              "location": "[resourceGroup().location]"
            }
          ]
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
<details><summary>Positive test num. 11 - bicep file</summary>

```bicep hl_lines="33"
resource MyDBServer2 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  kind: ''
  location: resourceGroup().location
  name: 'MyDBServer2'
  properties: {
    sslEnforcement: 'Disabled'
    version: '11'
    administratorLogin: 'root'
    administratorLoginPassword: '12345'
    storageMB: '2048'
    createMode: 'Default'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    creationDate: '2019-04-01T00:00:00Z'
    lastModifiedDate: '2019-04-01T00:00:00Z'
    maxSizeUnits: 'SizeUnit.megabytes'
    isReadOnly: 'false'
    isAutoUpgradeEnabled: 'true'
    isStateful: 'false'
    isExternal: 'false'
  }
  sku: {
    name: 'S0'
    tier: 'Basic'
    capacity: 1
    family: 'GeneralPurpose'
  }
}

resource MyDBServer2_log_connections 'Microsoft.DBforPostgreSQL/servers/configurations@2017-12-01' = {
  parent: MyDBServer2
  name: 'log_connections'
  properties: {
    value: 'off'
  }
  location: resourceGroup().location
}

```
</details>
<details><summary>Positive test num. 12 - json file</summary>

```json hl_lines="47"
{
  "properties": {
    "template": {
      "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "parameters": {},
      "functions": [],
      "variables": {},
      "resources": [
        {
          "apiVersion": "2017-12-01",
          "kind": "",
          "location": "[resourceGroup().location]",
          "name": "MyDBServer2",
          "properties": {
            "sslEnforcement": "Disabled",
            "version": "11",
            "administratorLogin": "root",
            "administratorLoginPassword": "12345",
            "storageMB": "2048",
            "createMode": "Default",
            "collation": "SQL_Latin1_General_CP1_CI_AS",
            "creationDate": "2019-04-01T00:00:00Z",
            "lastModifiedDate": "2019-04-01T00:00:00Z",
            "maxSizeUnits": "SizeUnit.megabytes",
            "isReadOnly": "false",
            "isAutoUpgradeEnabled": "true",
            "isStateful": "false",
            "isExternal": "false"
          },
          "sku": {
            "name": "S0",
            "tier": "Basic",
            "capacity": 1,
            "family": "GeneralPurpose"
          },
          "type": "Microsoft.DBforPostgreSQL/servers",
          "resources": [
            {
              "type": "configurations",
              "apiVersion": "2017-12-01",
              "dependsOn": [
                "[resourceId('Microsoft.DBforPostgreSQL/servers', 'MyDBServer2')]"
              ],
              "name": "log_connections",
              "properties": {
                "value": "off"
              },
              "location": "[resourceGroup().location]"
            }
          ]
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
<details><summary>Positive test num. 13 - bicep file</summary>

```bicep hl_lines="32"
resource MyDBServer3 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  kind: ''
  location: resourceGroup().location
  name: 'MyDBServer3'
  properties: {
    sslEnforcement: 'Disabled'
    version: '11'
    administratorLogin: 'root'
    administratorLoginPassword: '12345'
    storageMB: '2048'
    createMode: 'Default'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    creationDate: '2019-04-01T00:00:00Z'
    lastModifiedDate: '2019-04-01T00:00:00Z'
    maxSizeUnits: 'SizeUnit.megabytes'
    isReadOnly: 'false'
    isAutoUpgradeEnabled: 'true'
    isStateful: 'false'
    isExternal: 'false'
  }
  sku: {
    name: 'S0'
    tier: 'Basic'
    capacity: 1
    family: 'GeneralPurpose'
  }
}

resource MyDBServer_log_connections 'Microsoft.DBforPostgreSQL/servers/configurations@2017-12-01' = {
  name: 'MyDBServer/log_connections'
  properties: {
    value: 'off'
  }
  location: resourceGroup().location
  dependsOn: ['MyDBServer']
}

```
</details>
<details><summary>Positive test num. 14 - json file</summary>

```json hl_lines="46"
{
  "properties": {
    "template": {
      "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "parameters": {},
      "functions": [],
      "variables": {},
      "resources": [
        {
          "type": "Microsoft.DBforPostgreSQL/servers",
          "apiVersion": "2017-12-01",
          "kind": "",
          "location": "[resourceGroup().location]",
          "name": "MyDBServer3",
          "properties": {
            "sslEnforcement": "Disabled",
            "version": "11",
            "administratorLogin": "root",
            "administratorLoginPassword": "12345",
            "storageMB": "2048",
            "createMode": "Default",
            "collation": "SQL_Latin1_General_CP1_CI_AS",
            "creationDate": "2019-04-01T00:00:00Z",
            "lastModifiedDate": "2019-04-01T00:00:00Z",
            "maxSizeUnits": "SizeUnit.megabytes",
            "isReadOnly": "false",
            "isAutoUpgradeEnabled": "true",
            "isStateful": "false",
            "isExternal": "false"
          },
          "sku": {
            "name": "S0",
            "tier": "Basic",
            "capacity": 1,
            "family": "GeneralPurpose"
          },
          "resources": [
          ]
        },
        {
          "type": "Microsoft.DBforPostgreSQL/servers/configurations",
          "apiVersion": "2017-12-01",
          "name": "MyDBServer/log_connections",
          "properties": {
            "value": "off"
          },
          "dependsOn": [
            "MyDBServer"
          ],
          "location": "[resourceGroup().location]"
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
<details><summary>Positive test num. 15 - bicep file</summary>

```bicep hl_lines="31"
resource MyDBServer3 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  kind: ''
  location: resourceGroup().location
  name: 'MyDBServer3'
  properties: {
    sslEnforcement: 'Disabled'
    version: '11'
    administratorLogin: 'root'
    administratorLoginPassword: '12345'
    storageMB: '2048'
    createMode: 'Default'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    creationDate: '2019-04-01T00:00:00Z'
    lastModifiedDate: '2019-04-01T00:00:00Z'
    maxSizeUnits: 'SizeUnit.megabytes'
    isReadOnly: 'false'
    isAutoUpgradeEnabled: 'true'
    isStateful: 'false'
    isExternal: 'false'
  }
  sku: {
    name: 'S0'
    tier: 'Basic'
    capacity: 1
    family: 'GeneralPurpose'
  }
}

resource MyDBServer_log_connections 'Microsoft.DBforPostgreSQL/servers/configurations@2017-12-01' = {
  name: 'MyDBServer/log_connections'
  properties: {
    configurationSets: [
      {
        configurationSetType: 'Microsoft.DBforPostgreSQL/servers/configurations/dbconfig'
        configurationSet: {
          name: 'dbconfig'
        }
      }
    ]
  }
  location: resourceGroup().location
  dependsOn: ['MyDBServer']
}

```
</details>
<details><summary>Positive test num. 16 - json file</summary>

```json hl_lines="45"
{
  "properties": {
    "template": {
      "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "parameters": {},
      "functions": [],
      "variables": {},
      "resources": [
        {
          "type": "Microsoft.DBforPostgreSQL/servers",
          "apiVersion": "2017-12-01",
          "kind": "",
          "location": "[resourceGroup().location]",
          "name": "MyDBServer3",
          "properties": {
            "sslEnforcement": "Disabled",
            "version": "11",
            "administratorLogin": "root",
            "administratorLoginPassword": "12345",
            "storageMB": "2048",
            "createMode": "Default",
            "collation": "SQL_Latin1_General_CP1_CI_AS",
            "creationDate": "2019-04-01T00:00:00Z",
            "lastModifiedDate": "2019-04-01T00:00:00Z",
            "maxSizeUnits": "SizeUnit.megabytes",
            "isReadOnly": "false",
            "isAutoUpgradeEnabled": "true",
            "isStateful": "false",
            "isExternal": "false"
          },
          "sku": {
            "name": "S0",
            "tier": "Basic",
            "capacity": 1,
            "family": "GeneralPurpose"
          },
          "resources": [
          ]
        },
        {
          "type": "Microsoft.DBforPostgreSQL/servers/configurations",
          "apiVersion": "2017-12-01",
          "name": "MyDBServer/log_connections",
          "properties": {
            "configurationSets": [
              {
                "configurationSetType": "Microsoft.DBforPostgreSQL/servers/configurations/dbconfig",
                "configurationSet": {
                  "name": "dbconfig"
                }
              }
            ]
          },
          "dependsOn": [
            "MyDBServer"
          ],
          "location": "[resourceGroup().location]"
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
resource MyDBServerNeg1 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  kind: ''
  location: resourceGroup().location
  name: 'MyDBServerNeg1'
  properties: {
    sslEnforcement: 'Disabled'
    version: '11'
    administratorLogin: 'root'
    administratorLoginPassword: '12345'
    storageMB: '2048'
    createMode: 'Default'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    creationDate: '2019-04-01T00:00:00Z'
    lastModifiedDate: '2019-04-01T00:00:00Z'
    maxSizeUnits: 'SizeUnit.megabytes'
    isReadOnly: 'false'
    isAutoUpgradeEnabled: 'true'
    isStateful: 'false'
    isExternal: 'false'
  }
}

resource MyDBServerNeg1_log_connections 'Microsoft.DBforPostgreSQL/servers/configurations@2017-12-01' = {
  parent: MyDBServerNeg1
  name: 'log_connections'
  properties: {
    value: 'on'
  }
  location: resourceGroup().location
  dependsOn: ['Microsoft.DBforPostgreSQL/servers/MyDBServer']
}

```
```json title="Negative test num. 2 - json file"
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "apiVersion": "2017-12-01",
      "kind": "",
      "location": "[resourceGroup().location]",
      "name": "MyDBServerNeg1",
      "properties": {
        "sslEnforcement": "Disabled",
        "version": "11",
        "administratorLogin": "root",
        "administratorLoginPassword": "12345",
        "storageMB": "2048",
        "createMode": "Default",
        "collation": "SQL_Latin1_General_CP1_CI_AS",
        "creationDate": "2019-04-01T00:00:00Z",
        "lastModifiedDate": "2019-04-01T00:00:00Z",
        "maxSizeUnits": "SizeUnit.megabytes",
        "isReadOnly": "false",
        "isAutoUpgradeEnabled": "true",
        "isStateful": "false",
        "isExternal": "false"
      },
      "type": "Microsoft.DBforPostgreSQL/servers",
      "resources": [
        {
          "type": "configurations",
          "apiVersion": "2017-12-01",
          "dependsOn": [
            "Microsoft.DBforPostgreSQL/servers/MyDBServer"
          ],
          "name": "log_connections",
          "properties": {
            "value": "on"
          },
          "location": "[resourceGroup().location]"
        }
      ]
    }
  ]
}

```
```bicep title="Negative test num. 3 - bicep file"
resource MyDBServer3 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  kind: ''
  location: resourceGroup().location
  name: 'MyDBServer3'
  properties: {
    sslEnforcement: 'Disabled'
    version: '11'
    administratorLogin: 'root'
    administratorLoginPassword: '12345'
    storageMB: '2048'
    createMode: 'Default'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    creationDate: '2019-04-01T00:00:00Z'
    lastModifiedDate: '2019-04-01T00:00:00Z'
    maxSizeUnits: 'SizeUnit.megabytes'
    isReadOnly: 'false'
    isAutoUpgradeEnabled: 'true'
    isStateful: 'false'
    isExternal: 'false'
  }
  sku: {
    name: 'S0'
    tier: 'Basic'
    capacity: 1
    family: 'GeneralPurpose'
  }
}

resource MyDBServer_log_connections 'Microsoft.DBforPostgreSQL/servers/configurations@2017-12-01' = {
  name: 'MyDBServer/log_connections'
  properties: {
    value: 'on'
  }
  location: resourceGroup().location
  dependsOn: ['MyDBServer']
}

```
<details><summary>Negative test num. 4 - json file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {},
  "functions": [],
  "variables": {},
  "resources": [
    {
      "type": "Microsoft.DBforPostgreSQL/servers",
      "apiVersion": "2017-12-01",
      "kind": "",
      "location": "[resourceGroup().location]",
      "name": "MyDBServer3",
      "properties": {
        "sslEnforcement": "Disabled",
        "version": "11",
        "administratorLogin": "root",
        "administratorLoginPassword": "12345",
        "storageMB": "2048",
        "createMode": "Default",
        "collation": "SQL_Latin1_General_CP1_CI_AS",
        "creationDate": "2019-04-01T00:00:00Z",
        "lastModifiedDate": "2019-04-01T00:00:00Z",
        "maxSizeUnits": "SizeUnit.megabytes",
        "isReadOnly": "false",
        "isAutoUpgradeEnabled": "true",
        "isStateful": "false",
        "isExternal": "false"
      },
      "sku": {
        "name": "S0",
        "tier": "Basic",
        "capacity": 1,
        "family": "GeneralPurpose"
      },
      "resources": [
      ]
    },
    {
      "type": "Microsoft.DBforPostgreSQL/servers/configurations",
      "apiVersion": "2017-12-01",
      "name": "MyDBServer/log_connections",
      "properties": {
        "value": "on"
      },
      "dependsOn": [
        "MyDBServer"
      ],
      "location": "[resourceGroup().location]"
    }
  ],
  "outputs": {}
}

```
</details>
<details><summary>Negative test num. 5 - bicep file</summary>

```bicep
resource MyDBServerNeg1 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  kind: ''
  location: resourceGroup().location
  name: 'MyDBServerNeg1'
  properties: {
    sslEnforcement: 'Disabled'
    version: '11'
    administratorLogin: 'root'
    administratorLoginPassword: '12345'
    storageMB: '2048'
    createMode: 'Default'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    creationDate: '2019-04-01T00:00:00Z'
    lastModifiedDate: '2019-04-01T00:00:00Z'
    maxSizeUnits: 'SizeUnit.megabytes'
    isReadOnly: 'false'
    isAutoUpgradeEnabled: 'true'
    isStateful: 'false'
    isExternal: 'false'
  }
}

resource MyDBServerNeg1_log_connections 'Microsoft.DBforPostgreSQL/servers/configurations@2017-12-01' = {
  parent: MyDBServerNeg1
  name: 'log_connections'
  properties: {
    value: 'on'
  }
  location: resourceGroup().location
  dependsOn: ['Microsoft.DBforPostgreSQL/servers/MyDBServer']
}

```
</details>
<details><summary>Negative test num. 6 - json file</summary>

```json
{
  "properties": {
    "template": {
      "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "resources": [
        {
          "apiVersion": "2017-12-01",
          "kind": "",
          "location": "[resourceGroup().location]",
          "name": "MyDBServerNeg1",
          "properties": {
            "sslEnforcement": "Disabled",
            "version": "11",
            "administratorLogin": "root",
            "administratorLoginPassword": "12345",
            "storageMB": "2048",
            "createMode": "Default",
            "collation": "SQL_Latin1_General_CP1_CI_AS",
            "creationDate": "2019-04-01T00:00:00Z",
            "lastModifiedDate": "2019-04-01T00:00:00Z",
            "maxSizeUnits": "SizeUnit.megabytes",
            "isReadOnly": "false",
            "isAutoUpgradeEnabled": "true",
            "isStateful": "false",
            "isExternal": "false"
          },
          "type": "Microsoft.DBforPostgreSQL/servers",
          "resources": [
            {
              "type": "configurations",
              "apiVersion": "2017-12-01",
              "dependsOn": [
                "Microsoft.DBforPostgreSQL/servers/MyDBServer"
              ],
              "name": "log_connections",
              "properties": {
                "value": "on"
              },
              "location": "[resourceGroup().location]"
            }
          ]
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
<details><summary>Negative test num. 7 - bicep file</summary>

```bicep
resource MyDBServer3 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  kind: ''
  location: resourceGroup().location
  name: 'MyDBServer3'
  properties: {
    sslEnforcement: 'Disabled'
    version: '11'
    administratorLogin: 'root'
    administratorLoginPassword: '12345'
    storageMB: '2048'
    createMode: 'Default'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    creationDate: '2019-04-01T00:00:00Z'
    lastModifiedDate: '2019-04-01T00:00:00Z'
    maxSizeUnits: 'SizeUnit.megabytes'
    isReadOnly: 'false'
    isAutoUpgradeEnabled: 'true'
    isStateful: 'false'
    isExternal: 'false'
  }
  sku: {
    name: 'S0'
    tier: 'Basic'
    capacity: 1
    family: 'GeneralPurpose'
  }
}

resource MyDBServer_log_connections 'Microsoft.DBforPostgreSQL/servers/configurations@2017-12-01' = {
  name: 'MyDBServer/log_connections'
  properties: {
    value: 'on'
  }
  location: resourceGroup().location
  dependsOn: ['MyDBServer']
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
      "parameters": {},
      "functions": [],
      "variables": {},
      "resources": [
        {
          "type": "Microsoft.DBforPostgreSQL/servers",
          "apiVersion": "2017-12-01",
          "kind": "",
          "location": "[resourceGroup().location]",
          "name": "MyDBServer3",
          "properties": {
            "sslEnforcement": "Disabled",
            "version": "11",
            "administratorLogin": "root",
            "administratorLoginPassword": "12345",
            "storageMB": "2048",
            "createMode": "Default",
            "collation": "SQL_Latin1_General_CP1_CI_AS",
            "creationDate": "2019-04-01T00:00:00Z",
            "lastModifiedDate": "2019-04-01T00:00:00Z",
            "maxSizeUnits": "SizeUnit.megabytes",
            "isReadOnly": "false",
            "isAutoUpgradeEnabled": "true",
            "isStateful": "false",
            "isExternal": "false"
          },
          "sku": {
            "name": "S0",
            "tier": "Basic",
            "capacity": 1,
            "family": "GeneralPurpose"
          },
          "resources": [
          ]
        },
        {
          "type": "Microsoft.DBforPostgreSQL/servers/configurations",
          "apiVersion": "2017-12-01",
          "name": "MyDBServer/log_connections",
          "properties": {
            "value": "on"
          },
          "dependsOn": [
            "MyDBServer"
          ],
          "location": "[resourceGroup().location]"
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
