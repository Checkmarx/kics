resource sqlServer 'Microsoft.Sql/servers@2019-06-01-preview' = {
  name: sqlServerName
  location: location
  tags: {
    displayName: 'SqlServer'
  }
  properties: {
    administratorLogin: sqlAdministratorLogin
    administratorLoginPassword: sqlAdministratorLoginPassword
    version: '12.0'
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

resource sqlAdmin 'Microsoft.Sql/servers/administrators@2019-06-01-preview' = {
  name: 'ActiveDirectory'
  parent: sqlServer
  properties: {
    administratorType: 'ActiveDirectory'
    login: ADLogin
    sid: ADobjectID
    tenantId: ADtenantID
  }
}
