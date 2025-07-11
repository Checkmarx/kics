param siteName string = 'myapp-http2'
param servicePlanName string = 'myapp-plan'

resource servicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: servicePlanName
  location: resourceGroup().location
  sku: {
    name: 'S1'
    tier: 'Standard'
    size: 'S1'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: siteName
  location: resourceGroup().location
  kind: 'app,linux,container'
  properties: {
    serverFarmId: servicePlan.id
    clientCertEnabled: false
    siteConfig: {
      http20Enabled: true  
      linuxFxVersion: 'DOCKER|nginx:latest'
    }
  }
}
