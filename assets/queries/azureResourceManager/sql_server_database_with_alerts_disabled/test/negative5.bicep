resource sample_database 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  name: 'sampleServer/sampleDatabase'
  location: 'Sample'
  properties: {
    sampleName: 'AdventureWorksLT'
  }
}

resource sample_databases_default 'Microsoft.Sql/servers/databases/securityAlertPolicies@2021-02-01-preview' = {
  name: 'sample/databases/default'
  location: 'Sample'
  properties: {
    disabledAlerts: []
    state: 'Enabled'
}}
