var identityName = 'value'

resource webSiteNegative5 'Microsoft.Web/sites@2020-12-01' = {
  name: 'webSiteNegative5'
  location: 'location1'
  tags: {}
  identity: {
    type: 'SystemAssigned, UserAssigned'
    userAssignedIdentities: {
      '${resourceId('Microsoft.ManagedIdentity/userAssignedIdentities',identityName)}': {}
    }
  }
  properties: {
    enabled: true
    httpsOnly: true
  }
}
