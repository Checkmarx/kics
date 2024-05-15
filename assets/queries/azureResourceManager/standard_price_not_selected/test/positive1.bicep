resource webApp1 'Microsoft.Web/sites@2018-11-01' = {
  name: 'webApp1'
  location: resourceGroup().location
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/appServicePlan1': 'Resource'
    displayName: 'webApp1'
  }
  properties: {
    name: 'webApp1'
    serverFarmId: resourceId('Microsoft.Web/serverfarms', 'appServicePlan1')
  }
  dependsOn: [resourceId('Microsoft.Web/serverfarms', 'appServicePlan1')]
}

resource Princing 'Microsoft.Security/pricings@2017-08-01-preview' = {
  name: 'Princing'
  properties: {
    pricingTier: 'Free'
  }
}
