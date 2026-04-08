resource sql_server 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: 'sql_server'
  location: resourceGroup().location
  properties: {}
}

resource sql_server_auditing_settings 'Microsoft.Sql/servers/auditingSettings@2021-02-01-preview' = {
  parent: sql_server
  name: 'default_1'
  properties: {
    state: 'Enabled'
  }
}
