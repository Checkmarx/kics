resource sqlServer1 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: 'sqlServer1'
  location: resourceGroup().location
  tags: {
    displayName: 'sqlServer1'
  }
  properties: {
    administratorLogin: 'adminUsername'
    administratorLoginPassword: 'adminPassword'
  }
}

resource auditingSetting 'Microsoft.Sql/servers/auditingSettings@2022-05-01-preview' = {
  name: 'default' 
  parent: sqlServer1
  properties: {
    state: 'Enabled'
    isAzureMonitorTargetEnabled: true
    retentionDays: 89
  }
}
