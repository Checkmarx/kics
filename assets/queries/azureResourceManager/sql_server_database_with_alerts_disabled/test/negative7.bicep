resource sample_server 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: 'sampleServer'
  location: resourceGroup().location
  properties: {
    administratorLogin: 'sqladminuser'
    administratorLoginPassword: 'P@ssw0rd123!' 
  }
}

resource sample_server_securityAlert 'Microsoft.Sql/servers/securityAlertPolicies@2021-02-01-preview' = {
  name: 'sampleServer/default'
  properties: {
    state: 'Enabled'
    disabledAlerts: []
    emailAccountAdmins: true
  }
}
