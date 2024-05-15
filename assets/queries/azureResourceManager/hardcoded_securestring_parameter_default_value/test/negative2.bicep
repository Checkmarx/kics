@secure()
param adminPassword string
param adminLogin string
param sqlServerName string

resource sqlServer 'Microsoft.Sql/servers@2015-05-01-preview' = {
  name: sqlServerName
  location: resourceGroup().location
  tags: {}
  properties: {
    administratorLogin: adminLogin
    administratorLoginPassword: adminPassword
    version: '12.0'
  }
}
