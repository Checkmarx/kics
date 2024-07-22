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

resource MyDBServer2_log_checkpoints 'Microsoft.DBforPostgreSQL/servers/configurations@2017-12-01' = {
  parent: MyDBServer2
  name: 'log_checkpoints'
  properties: {
    value: 'off'
  }
  location: resourceGroup().location
  dependsOn: ['Microsoft.DBforPostgreSQL/servers/MyDBServer']
}
