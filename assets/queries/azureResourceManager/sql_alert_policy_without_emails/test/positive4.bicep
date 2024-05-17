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

resource sqlServer1_sqlDatabase1 'Microsoft.Sql/servers/databases@2014-04-01' = {
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

resource sqlServer1_sqlDatabase1_securityPolicy1 'Microsoft.Sql/servers/databases/securityAlertPolicies@2021-02-01-preview' = {
  parent: sqlServer1_sqlDatabase1
  name: 'securityPolicy1'
  properties: {
    emailAccountAdmins: true
    retentionDays: 4
    state: 'Enabled'
  }
  dependsOn: [sqlServer1]
}
