var identityName = 'value'

resource webSiteNegative2 'Microsoft.Web/sites@2020-12-01' = {
  name: 'webSiteNegative2'
  location: 'location1'
  tags: {}
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${resourceId('Microsoft.ManagedIdentity/userAssignedIdentities',identityName)}': {}
    }
  }
  properties: {
    enabled: true
    httpsOnly: true
  }
}
