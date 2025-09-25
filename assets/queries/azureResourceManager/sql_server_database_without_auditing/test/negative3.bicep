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

resource sqlServer1_default 'Microsoft.Sql/servers/auditingSettings@2021-02-01-preview' = {
  parent: sqlServer1
  name: 'default'
  properties: {
    auditActionsAndGroups: ['DATABASE_LOGOUT_GROUP']
    isAzureMonitorTargetEnabled: true
    isStorageSecondaryKeyInUse: true
    queueDelayMs: 1000
    retentionDays: 100
    state: 'Enabled'
  }
}

resource sqlServer1_ssqlDatabase1 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  parent: sqlServer1
  name: 'ssqlDatabase1'
  location: resourceGroup().location
  tags: {
    displayName: 'sqlDatabase1'
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    edition: 'Basic'
    maxSizeBytes: 107374182
    requestedServiceObjectiveName: 'Basic'
  }
}

resource sqlServer1_ssqlDatabase1_default 'Microsoft.Sql/servers/databases/auditingSettings@2021-02-01-preview' = {
  parent: sqlServer1_ssqlDatabase1
  name: 'default'
  properties: {
    auditActionsAndGroups: ['DATABASE_LOGOUT_GROUP']
    isAzureMonitorTargetEnabled: true
    isStorageSecondaryKeyInUse: true
    queueDelayMs: 1000
    retentionDays: 100
    state: 'Enabled'
  }
}
