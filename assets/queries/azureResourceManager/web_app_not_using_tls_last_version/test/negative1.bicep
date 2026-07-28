resource App 'Microsoft.Web/sites@2020-12-01' = {
  name: 'web'
  location: resourceGroup().location
  properties: {
    siteConfig: {
      minTlsVersion: '1.3'
    }
  }
}
