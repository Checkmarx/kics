resource webSitePositive3 'Microsoft.Web/sites@2020-12-01' = {
  name: 'webSitePositive3'
  location: 'location1'
  tags: {}
  identity: {
    type: 'None'
  }
  properties: {
    enabled: true
    httpsOnly: true
  }
}
