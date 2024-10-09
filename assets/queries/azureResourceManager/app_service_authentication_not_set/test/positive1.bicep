resource appServicePlan1 'Microsoft.Web/serverfarms@2018-02-01' = {
  name: 'appServicePlan1'
  location: resourceGroup().location
  sku: {
    name: 'F1'
    capacity: 1
  }
  tags: {
    displayName: 'appServicePlan1'
  }
  properties: {
    name: 'appServicePlan1'
  }
}

resource webApp1 'Microsoft.Web/sites@2020-12-01' = {
  name: 'webApp1'
  location: resourceGroup().location
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/appServicePlan1': 'Resource'
    displayName: 'webApp1'
  }
  properties: {
    name: 'webApp1'
    serverFarmId: appServicePlan1.id
  }
}

resource webApp1_authsettings 'Microsoft.Web/sites/config@2020-12-01' = {
  parent: webApp1
  name: 'authsettings'
  properties: {
    enabled: false
  }
}
