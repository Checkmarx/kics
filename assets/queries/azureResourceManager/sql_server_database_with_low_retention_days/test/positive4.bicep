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

resource sqlServer1_sqlDatabase1 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  parent: sqlServer1
  name: 'sqlDatabase1'
  location: resourceGroup().location
  tags: {
    displayName: 'sqlDatabase1'
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    edition: 'Basic'
    maxSizeBytes: '1073741824'
    requestedServiceObjectiveName: 'Basic'
  }
}

resource sqlServer1_sqlDatabase1_default 'Microsoft.Sql/servers/databases/auditingSettings@2021-02-01-preview' = {
  parent: sqlServer1_sqlDatabase1
  name: 'default'
  properties: {
    auditActionsAndGroups: ['DATABASE_LOGOUT_GROUP']
    isAzureMonitorTargetEnabled: true
    isStorageSecondaryKeyInUse: true
    queueDelayMs: 1000
    state: 'Enabled'
    dependsOn: [sqlServer1_sqlDatabase1.id]
  }
}
