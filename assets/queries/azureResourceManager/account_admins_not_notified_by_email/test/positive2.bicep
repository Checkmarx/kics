resource sample_server_default 'Microsoft.Sql/servers/databases/securityAlertPolicies@2021-02-01-preview' = {
  name: 'sample/server/default'
  properties: {
    emailAddresses: ['sample@email.com']
    retentionDays: 4
    state: 'Enabled'
  }
}
