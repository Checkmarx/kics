resource sql_databases 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  parent: sql_server
  name: 'sql_databases'
  location: resourceGroup().location
  properties: {}
}

resource sql_databases_auditing_settings 'Microsoft.Sql/servers/databases/auditingSettings@2021-02-01-preview' = {
  parent: sql_databases
  name: 'default_2'
  properties: {
    state: 'Enabled'
  }
}
