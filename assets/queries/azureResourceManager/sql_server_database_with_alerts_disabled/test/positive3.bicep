resource sample_databases_default 'Microsoft.Sql/servers/databases/securityAlertPolicies@2021-02-01-preview' = {
  name: 'sample/databases/default'
  properties: {
    emailAccountAdmins: true
    emailAddresses: ['sample@email.com']
    retentionDays: 4
    state: 'Disabled'
  }
}
