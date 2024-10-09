resource webSitePositive2 'Microsoft.Web/sites@2020-12-01' = {
  name: 'webSitePositive2'
  location: 'location1'
  tags: {}
  properties: {
    enabled: true
    httpsOnly: true
  }
}
