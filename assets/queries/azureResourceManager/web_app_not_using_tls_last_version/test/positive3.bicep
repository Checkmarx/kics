resource App 'Microsoft.Web/sites@2020-12-01' = {
  name: 'App'
  location: resourceGroup().location
  properties: {
    siteConfig: {
      minTlsVersion: '1.0'
    }
  }
}
