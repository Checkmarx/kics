resource sample_server_securityAlert 'Microsoft.Sql/servers/securityAlertPolicies@2021-02-01-preview' = {
  name: 'sampleServer/default'
  properties: {
    state: 'Enabled'
    disabledAlerts: []
    emailAccountAdmins: true
  }
}
