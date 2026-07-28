resource webSiteNegative8 'Microsoft.Web/sites@2019-08-01' = {
  name: 'webSiteNegative8'
  location: 'location1'
  identity: {
    type: 'SystemAssigned, UserAssigned'
  }
  tags: {}
  properties: {
    enabled: true
    httpsOnly: true
  }
}
