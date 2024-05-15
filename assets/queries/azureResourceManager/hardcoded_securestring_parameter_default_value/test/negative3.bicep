@secure()
param secureParameter string = newGuid()
param adminLogin string
param sqlServerName string

resource sqlServer 'Microsoft.Sql/servers@2015-05-01-preview' = {
  name: sqlServerName
  location: resourceGroup().location
  tags: {}
  properties: {
    administratorLogin: adminLogin
    administratorLoginPassword: secureParameter
    version: '12.0'
  }
}
