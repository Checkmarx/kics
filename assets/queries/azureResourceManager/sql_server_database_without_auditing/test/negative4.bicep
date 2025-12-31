resource sqlServer1 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: 'sqlServer1'
  location: resourceGroup().location
}

resource sqlServer1_default 'Microsoft.Sql/servers/auditingSettings@2021-02-01-preview' = {
  parent: sqlServer1
  name: 'default_1'
  properties: {
    state: 'Enabled'
  }
}

resource sqlServer1_sqlDatabase1 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  parent: sqlServer1
  name: 'sqlDatabase1'
  location: resourceGroup().location
  properties: {}
}

resource sqlServer1_sqlDatabase1_default 'Microsoft.Sql/servers/databases/auditingSettings@2021-02-01-preview' = {
  parent: sqlServer1_sqlDatabase1
  name: 'default_2'
  properties: {
    state: 'Disabled'
  }
}
