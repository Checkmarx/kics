resource sqlServer 'Microsoft.Sql/servers@2023-02-01-preview' = {
  name: name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  tags: tags
  properties: {
    administrators: {
      administratorType: 'ActiveDirectory'
      login: login
      sid: sidid
      tenantId: subscription().tenantId
      azureADOnlyAuthentication: true
    }
    version: '12.0'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'

    restrictOutboundNetworkAccess: 'Disabled'
  }
}
  resource auditSettings 'auditingSettings' = {
    parent: sqlServer
    name: 'default'
    properties: {
      auditActionsAndGroups: [
        'BATCH_COMPLETED_GROUP'
        'SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP'
        'FAILED_DATABASE_AUTHENTICATION_GROUP'
      ]
      isAzureMonitorTargetEnabled: true
      state: 'Enabled'
    }
  }
