resource webSitePositive7 'Microsoft.Web/sites@2020-12-01' = {
  name: 'webSitePositive7'
  location: 'location1'
  tags: {}
  identity: {
    type: 'UserAssigned'
  }
  properties: {
    enabled: true
    httpsOnly: true
  }
}
