resource webSiteNegative1 'Microsoft.Web/sites@2019-08-01' = {
  name: 'webSiteNegative1'
  location: 'location1'
  identity: {
    type: 'SystemAssigned'
  }
  tags: {}
  properties: {
    enabled: true
    httpsOnly: true
  }
}
