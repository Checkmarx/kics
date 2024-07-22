resource servers1 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: 'servers1'
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'B_Gen4_1'
    tier: 'Basic'
    capacity: 500
    size: '500MB'
    family: 'family'
  }
  properties: {
    version: '11'
    sslEnforcement: 'Enabled'
    minimalTlsVersion: 'TLS1_2'
    infrastructureEncryption: 'Enabled'
    publicNetworkAccess: 'Disabled'
    storageProfile: {
      backupRetentionDays: 90
      geoRedundantBackup: 'Enabled'
      storageMB: 50
      storageAutogrow: 'Enabled'
    }
    createMode: 'Replica'
    sourceServerId: 'sample_id'
  }
  location: 'string'
  tags: {}
}
