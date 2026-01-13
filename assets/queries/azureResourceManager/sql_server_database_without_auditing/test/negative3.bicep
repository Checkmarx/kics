resource sql_server 'Microsoft.Sql/servers@2023-02-01-preview' = {
  name: 'sql_server'
  location: resourceGroup().location
  properties: {}
}

resource sql_databases 'Microsoft.Sql/servers/databases@2024-11-01-preview' = {
  parent: sql_server
  name: 'sql_databases'
  location: resourceGroup().location
  properties: {}
}

resource sql_server_auditing_settings 'Microsoft.Sql/servers/auditingSettings@2024-11-01-preview' = {
  parent: sql_server
  name: 'default'
  properties: {
    state: 'Enabled'
  }
}
