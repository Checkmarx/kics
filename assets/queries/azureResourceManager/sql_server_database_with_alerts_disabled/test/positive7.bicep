resource sample_server_securityAlert 'Microsoft.Sql/servers/securityAlertPolicies@2021-02-01-preview' = {
  name: 'sampleServer/default'
  properties: {
    disabledAlerts: ['Sql_Injection']
    emailAccountAdmins: true
    emailAddresses: ['sample@email.com']
    retentionDays: 4
    state: 'Disabled'
  }
}
