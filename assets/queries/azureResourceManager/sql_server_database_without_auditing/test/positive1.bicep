resource sqlServer1 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: 'sqlServer1'
  location: resourceGroup().location
}

resource sqlServer1_sqlDatabase1 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  parent: sqlServer1
  name: 'sqlDatabase1'
  location: resourceGroup().location
  properties: {}
}
