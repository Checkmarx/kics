resource sqlServer 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: 'sample'
  location: resourceGroup().location
  properties: {
    administratorLogin: 'sqladminuser'
    administratorLoginPassword: 'P@ssw0rd123!' 
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
  }
}
