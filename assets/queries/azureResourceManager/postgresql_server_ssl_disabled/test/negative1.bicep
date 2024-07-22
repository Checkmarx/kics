param databaseSkuName int = 5
param databaseSkuTier int = 5
param databaseDTU int = 5
param databaseSkuSizeMB int = 5

var serverName = 'server'

resource MyDBServer 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  kind: ''
  location: resourceGroup().location
  name: 'MyDBServer'
  properties: {
    version: '11'
    administratorLogin: 'root'
    administratorLoginPassword: '12345'
    storageMB: '2048'
    sslEnforcement: 'Enabled'
    createMode: 'Default'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    creationDate: '2019-04-01T00:00:00Z'
    lastModifiedDate: '2019-04-01T00:00:00Z'
    maxSizeUnits: 'SizeUnit.megabytes'
    isReadOnly: 'false'
    isAutoUpgradeEnabled: 'true'
    isStateful: 'false'
    isExternal: 'false'
    defaultSecondaryLocation: resourceGroup().location
    maxSizeInGB: '10'
    isEncrypted: 'false'
    isNetworkAccessible: 'true'
    identity: ''
  }
  sku: {
    name: databaseSkuName
    tier: databaseSkuTier
    capacity: databaseDTU
    size: databaseSkuSizeMB
    family: 'SkuFamily'
  }
}

resource MyDBServer_serverName_firewall 'Microsoft.DBforPostgreSQL/servers/firewallrules@2017-12-01' = {
  parent: MyDBServer
  location: resourceGroup().location
  name: '${serverName}firewall'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
  dependsOn: [
    'Microsoft.DBforPostgreSQL/servers/${serverName}'
  ]
}

resource MyDBServer_myDB1 'Microsoft.DBforPostgreSQL/servers/databases@2017-12-01' = {
  parent: MyDBServer
  name: 'myDB1'
  properties: {
    charset: 'utf8'
    collation: 'English_United States.1252'
  }
}
