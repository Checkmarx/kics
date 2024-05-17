resource webSite 'Microsoft.Web/sites@2020-12-01' = {
  name: 'webSite'
  location: 'location1'
  tags: {}
  properties: {
    enabled: true
    clientCertEnabled: false
  }
}
