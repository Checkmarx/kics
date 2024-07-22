param databaseSkuName string
param databaseSkuTier string
param databaseDTU string
param databaseSkuSizeMB string

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
  sku: {
    name: databaseSkuName
    tier: databaseSkuTier
    capacity: databaseDTU
    size: databaseSkuSizeMB
    family: 'SkuFamily'
  }
}

resource MyDBServerNeg1_log_checkpoints 'Microsoft.DBforPostgreSQL/servers/configurations@2017-12-01' = {
  parent: MyDBServerNeg1
  name: 'log_checkpoints'
  properties: {
    value: 'on'
  }
  location: resourceGroup().location
  dependsOn: [
    'Microsoft.DBforPostgreSQL/servers/MyDBServer'
  ]
}
